// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class ItemDialog extends StatefulWidget {
  final Item item;
  final ShoppingList list;
  final VoidCallback fetchItems;

  const ItemDialog({
    super.key,
    required this.item,
    required this.list,
    required this.fetchItems,
  });

  @override
  State<ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final _formKey = GlobalKey<FormState>();

  // ---------------------- STATE VARIABLES ----------------------
  List<Category> _categories = [];
  bool _isLoading = true;

  // ---------------------- FORM FIELDS ----------------------
  String _itemName = '';
  String? _selectedCategoryId;
  bool _isQuantityBased = true;
  double _amount = 1.0;

  @override
  void initState() {
    super.initState();

    setState(() {
      _itemName = widget.item.name;
      _selectedCategoryId = widget.item.categoryId;
      _isQuantityBased = widget.item.isQuantityBased;
      _amount = widget.item.isQuantityBased
          ? widget.item.quantity.ceilToDouble()
          : widget.item.weight;
    });

    _loadCategories();
  }

  // ---------------------- METHOD: LOAD CATEGORIES ----------------------
  Future<void> _loadCategories() async {
    try {
      final categories = await loadCategories(context, widget.list);

      if (!mounted || categories == null) {
        return;
      }
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ---------------------- METHOD: UPDATE ITEM ----------------------
  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final updatedItem = Item(
      id: widget.item.id,
      name: _itemName,
      categoryId: _selectedCategoryId!,
      isQuantityBased: _isQuantityBased,
      quantity: _isQuantityBased ? _amount.toInt() : 0,
      weight: !_isQuantityBased ? _amount : 0.0,
      isCollected: widget.item.isCollected,
    );

    try {
      await FirebaseController().updateItem(updatedItem, widget.list);

      if (!mounted) return;

      Navigator.of(context).pop();
      widget.fetchItems();
    } catch (e) {
      if (mounted) {
        showMessage(context, "Failed to update item: ${e.toString}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Item", style: AppFonts.blackHeaderText),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Item Name Field
                    TextFormField(
                      initialValue: _itemName,
                      decoration: const InputDecoration(
                        labelText: "Item Name",
                        labelStyle: AppFonts.blackSubHeadingText,
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                      onSaved: (value) => _itemName = value!,
                      style: AppFonts.blackSubHeadingText,
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Category",
                        hintStyle: AppFonts.blackSubHeadingText,
                      ),
                      initialValue: _selectedCategoryId,
                      items: _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategoryId = val),
                      validator: (val) =>
                          val == null ? 'Please select a category' : null,
                      style: AppFonts.blackSubHeadingText,
                    ),
                    const SizedBox(height: 16),

                    // Toggle for Quantity vs Weight
                    SwitchListTile(
                      title: Text(
                        _isQuantityBased ? "Mode: Quantity" : "Mode: Weight",
                        style: AppFonts.blackSubHeadingText,
                      ),
                      value: _isQuantityBased,
                      activeThumbColor: AppColors.contrast,
                      onChanged: (val) =>
                          setState(() => _isQuantityBased = val),
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Dynamic Number Field
                    TextFormField(
                      initialValue: _isQuantityBased
                          ? _amount.toInt().toString()
                          : _amount.toStringAsFixed(3),
                      key: ValueKey(_isQuantityBased),
                      style: AppFonts.blackSubHeadingText,
                      decoration: InputDecoration(
                        labelText: _isQuantityBased ? "Quantity" : "Weight",
                        suffixText: _isQuantityBased ? "pcs" : "kg",
                        labelStyle: AppFonts.blackSubHeadingText,
                        suffixStyle: AppFonts.blackSubHeadingText,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onSaved: (value) =>
                          _amount = double.tryParse(value ?? '0') ?? 0,
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            handleDeleteItem(context, widget.list, widget.item);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => _updateItem(),
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
