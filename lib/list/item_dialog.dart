// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'dart:ffi';

import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class ItemDialog extends StatefulWidget {
  final Item item;
  final ShoppingList list;
  final VoidCallback onDelete;
  final VoidCallback fetchItems;

  const ItemDialog({
    super.key,
    required this.item,
    required this.list,
    required this.onDelete,
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
      final categories = await loadCategories(widget.list);

      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading categories: $e");
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
      debugPrint("Error updating item: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update item. Please try again."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Item"),
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
                      initialValue: _isQuantityBased
                          ? _amount.toInt().toString()
                          : _amount.toStringAsFixed(3),
                      key: ValueKey(_isQuantityBased),
                      decoration: InputDecoration(
                        labelText: _isQuantityBased ? "Quantity" : "Weight",
                        suffixText: _isQuantityBased ? "pcs" : "kg",
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
            widget.onDelete();
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => _updateItem(),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
