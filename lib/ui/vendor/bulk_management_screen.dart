
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bulk_management_provider.dart';
import '../../models/commodities_model.dart';
import '../../widgets/custom_appbar.dart';

class BulkManagementScreen extends StatefulWidget {
  final List<CommodityData> items;
  
  const BulkManagementScreen({Key? key, required this.items}) : super(key: key);

  @override
  State<BulkManagementScreen> createState() => _BulkManagementScreenState();
}

class _BulkManagementScreenState extends State<BulkManagementScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BulkManagementProvider(),
      child: Consumer<BulkManagementProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Bulk Management',
              actions: [
                if (provider.selectedCount > 0)
                  TextButton(
                    onPressed: () => provider.clearSelection(),
                    child: const Text('Clear'),
                  ),
              ],
            ),
            body: Column(
              children: [
                // Selection Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Checkbox(
                        value: provider.selectAll,
                        onChanged: (_) => provider.toggleSelectAll(widget.items),
                      ),
                      Text('Select All (${provider.selectedCount} selected)'),
                      const Spacer(),
                      if (provider.selectedCount > 0)
                        ElevatedButton(
                          onPressed: () => _showBulkActionsDialog(context, provider),
                          child: const Text('Bulk Actions'),
                        ),
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = provider.isItemSelected(item);
                      
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (_) => provider.toggleItemSelection(item),
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${item.price}'),
                            Text('Stock: ${item.stock ?? 0}'),
                            Text('Category: ${item.category}'),
                          ],
                        ),
                        secondary: item.image.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(item.image),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.shopping_bag),
                              ),
                      );
                    },
                  ),
                ),

                if (provider.isLoading)
                  const LinearProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context, BulkManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Update Prices'),
              onTap: () {
                Navigator.pop(context);
                _showUpdatePriceDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Update Stock'),
              onTap: () {
                Navigator.pop(context);
                _showUpdateStockDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.toggle_on),
              title: const Text('Toggle Status'),
              onTap: () {
                Navigator.pop(context);
                _showToggleStatusDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Items'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(context, provider);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdatePriceDialog(BuildContext context, BulkManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Prices'),
        content: TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Price',
            prefixText: '\$',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final price = double.tryParse(_priceController.text);
              if (price != null && price > 0) {
                Navigator.pop(context);
                final success = await provider.bulkUpdatePrices(price);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prices updated successfully')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, BulkManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock'),
        content: TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Stock Quantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final stock = int.tryParse(_stockController.text);
              if (stock != null && stock >= 0) {
                Navigator.pop(context);
                final success = await provider.bulkUpdateStock(stock);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stock updated successfully')),
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showToggleStatusDialog(BuildContext context, BulkManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Toggle Status'),
        content: const Text('Choose the new status for selected items:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.bulkToggleStatus(true);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Items activated successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Activate'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.bulkToggleStatus(false);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Items deactivated successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, BulkManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Items'),
        content: Text('Are you sure you want to delete ${provider.selectedCount} items? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.bulkDelete();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Items deleted successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
