// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class AddItemDialog extends StatefulWidget {
  final ShoppingList list;
  final VoidCallback fetchItems;

  const AddItemDialog({
    super.key,
    required this.list,
    required this.fetchItems,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
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
    _loadCategories();
  }

  // ---------------------- METHOD: LOAD CATEGORIES ----------------------
  Future<void> _loadCategories() async {
    final categories = await loadCategories(context, widget.list);

    if (!mounted || categories == null) {
      return;
    }
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  // ---------------------- METHOD: ADD NEW ITEM ----------------------
  Future<void> _addNewItem() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final newItem = Item(
      id: '', // Firestore will generate this
      name: _itemName,
      categoryId: _selectedCategoryId!,
      isQuantityBased: _isQuantityBased,
      quantity: _isQuantityBased ? _amount.toInt() : 0,
      weight: !_isQuantityBased ? _amount : 0.0,
    );

    try {
      await FirebaseController().addNewItem(newItem, widget.list);

      if (!mounted) return;

      Navigator.of(context).pop();
      widget.fetchItems();
    } catch (e) {
      debugPrint("Error adding item: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  // ---------------------- BUILD METHOD ----------------------
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Item"),
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
                      decoration: const InputDecoration(labelText: "Item Name"),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? 'Required' : null,
                      onSaved: (value) => _itemName = value!,
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Category"),
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
                    ),
                    const SizedBox(height: 16),

                    // Toggle for Quantity vs Weight
                    SwitchListTile(
                      title: Text(
                        _isQuantityBased ? "Mode: Quantity" : "Mode: Weight",
                      ),
                      value: _isQuantityBased,
                      onChanged: (val) =>
                          setState(() => _isQuantityBased = val),
                      contentPadding: EdgeInsets.zero,
                    ),

                    // Dynamic Number Field
                    TextFormField(
                      key: ValueKey(_isQuantityBased),
                      decoration: InputDecoration(
                        labelText: _isQuantityBased ? "Quantity" : "Weight",
                        suffixText: _isQuantityBased ? "pcs" : "kg",
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      initialValue: _isQuantityBased ? "1" : "0.0",
                      onSaved: (value) =>
                          _amount = double.tryParse(value ?? '0') ?? 0,
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: _addNewItem, child: const Text("Create")),
      ],
    );
  }
}
