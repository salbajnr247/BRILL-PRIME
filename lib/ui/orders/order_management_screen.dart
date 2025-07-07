
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_management_provider.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<OrderManagementProvider>(context, listen: false);
      provider.fetchAllOrders(context: context);
      provider.startRealTimeUpdates(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderManagementProvider(),
      child: Consumer<OrderManagementProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Order Management'),
              actions: [
                IconButton(
                  icon: Icon(provider.isRealTimeEnabled ? Icons.sync : Icons.sync_disabled),
                  onPressed: () {
                    if (provider.isRealTimeEnabled) {
                      provider.stopRealTimeUpdates();
                    } else {
                      provider.startRealTimeUpdates(context: context);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context, provider),
                ),
                IconButton(
                  icon: Icon(provider.isBulkMode ? Icons.check_box : Icons.check_box_outline_blank),
                  onPressed: provider.toggleBulkMode,
                ),
              ],
            ),
            body: Column(
              children: [
                if (provider.errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.red.shade100,
                    child: Text(
                      provider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                
                // Filter summary
                if (_hasActiveFilters(provider))
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_getFilterSummary(provider))),
                        TextButton(
                          onPressed: provider.clearFilters,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),

                // Bulk actions bar
                if (provider.isBulkMode && provider.selectedOrderIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.orange.shade50,
                    child: Row(
                      children: [
                        Text('${provider.selectedOrderIds.length} selected'),
                        const Spacer(),
                        TextButton(
                          onPressed: provider.selectAllOrders,
                          child: const Text('Select All'),
                        ),
                        TextButton(
                          onPressed: provider.clearSelection,
                          child: const Text('Clear'),
                        ),
                        ElevatedButton(
                          onPressed: provider.bulkProcessing ? null : () => _showBulkActionsDialog(context, provider),
                          child: provider.bulkProcessing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Actions'),
                        ),
                      ],
                    ),
                  ),

                // Orders list
                Expanded(
                  child: provider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredOrders.isEmpty
                          ? const Center(child: Text('No orders found'))
                          : ListView.builder(
                              itemCount: provider.filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = provider.filteredOrders[index];
                                final isSelected = provider.selectedOrderIds.contains(order.id.toString());
                                
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: ListTile(
                                    leading: provider.isBulkMode
                                        ? Checkbox(
                                            value: isSelected,
                                            onChanged: (_) => provider.toggleOrderSelection(order.id.toString()),
                                          )
                                        : const Icon(Icons.receipt),
                                    title: Text('Order #${order.id}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Status: ${order.status}'),
                                        Text('Amount: \$${order.totalPrice}'),
                                        Text('Date: ${order.createdAt.toString().split(' ')[0]}'),
                                      ],
                                    ),
                                    trailing: provider.isBulkMode
                                        ? null
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.cancel),
                                                tooltip: 'Cancel Order',
                                                onPressed: () async {
                                                  final success = await provider.cancelOrder(
                                                    context: context,
                                                    orderId: order.id.toString(),
                                                  );
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          success ? 'Order cancelled' : provider.errorMessage,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.assignment_return),
                                                tooltip: 'Return/Refund',
                                                onPressed: () async {
                                                  final success = await provider.initiateReturn(
                                                    context: context,
                                                    orderId: order.id.toString(),
                                                  );
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          success ? 'Return initiated' : provider.errorMessage,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                    onTap: provider.isBulkMode
                                        ? () => provider.toggleOrderSelection(order.id.toString())
                                        : () async {
                                            await provider.trackOrderStatus(
                                              context: context,
                                              orderId: order.id.toString(),
                                            );
                                            if (mounted) {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('Order Status'),
                                                  content: Text(
                                                    provider.orderStatus.isNotEmpty
                                                        ? provider.orderStatus
                                                        : 'No status available',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hasActiveFilters(OrderManagementProvider provider) {
    return provider.statusFilter != 'all' ||
           provider.dateFromFilter != null ||
           provider.dateToFilter != null ||
           provider.minAmountFilter != null ||
           provider.maxAmountFilter != null;
  }

  String _getFilterSummary(OrderManagementProvider provider) {
    List<String> filters = [];
    
    if (provider.statusFilter != 'all') {
      filters.add('Status: ${provider.statusFilter}');
    }
    if (provider.dateFromFilter != null || provider.dateToFilter != null) {
      filters.add('Date range applied');
    }
    if (provider.minAmountFilter != null || provider.maxAmountFilter != null) {
      filters.add('Amount range applied');
    }
    
    return 'Active filters: ${filters.join(', ')}';
  }

  void _showFilterDialog(BuildContext context, OrderManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Orders'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status filter
              DropdownButtonFormField<String>(
                value: provider.statusFilter,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'processing', child: Text('Processing')),
                  DropdownMenuItem(value: 'shipped', child: Text('Shipped')),
                  DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                  DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                ],
                onChanged: (value) {
                  if (value != null) provider.setStatusFilter(value);
                },
              ),
              const SizedBox(height: 16),
              
              // Date range filters
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'From Date'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: provider.dateFromFilter?.toString().split(' ')[0] ?? '',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: provider.dateFromFilter ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          provider.setDateFilter(from: date, to: provider.dateToFilter);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'To Date'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: provider.dateToFilter?.toString().split(' ')[0] ?? '',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: provider.dateToFilter ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          provider.setDateFilter(from: provider.dateFromFilter, to: date);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Amount range filters
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Min Amount'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: provider.minAmountFilter?.toString() ?? '',
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value);
                        provider.setAmountFilter(min: amount, max: provider.maxAmountFilter);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Max Amount'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: provider.maxAmountFilter?.toString() ?? '',
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value);
                        provider.setAmountFilter(min: provider.minAmountFilter, max: amount);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBulkActionsDialog(BuildContext context, OrderManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${provider.selectedOrderIds.length} orders selected'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel Orders'),
              onTap: () async {
                Navigator.pop(context);
                final success = await provider.bulkCancelOrders(context: context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Orders cancelled successfully' : provider.errorMessage,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Update Status'),
              onTap: () {
                Navigator.pop(context);
                _showStatusUpdateDialog(context, provider);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, OrderManagementProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'processing',
            'shipped',
            'delivered',
            'cancelled',
          ].map((status) => ListTile(
            title: Text(status.toUpperCase()),
            onTap: () async {
              Navigator.pop(context);
              final success = await provider.bulkUpdateStatus(
                context: context,
                status: status,
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Status updated successfully' : provider.errorMessage,
                    ),
                  ),
                );
              }
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
