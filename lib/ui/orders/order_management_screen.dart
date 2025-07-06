import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_management_provider.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderManagementProvider(),
      child: Consumer<OrderManagementProvider>(
        builder: (context, provider, _) {
          // Placeholder orders
          final orders = [
            {'id': 'order1', 'status': 'Processing'},
            {'id': 'order2', 'status': 'Shipped'},
            {'id': 'order3', 'status': 'Delivered'},
          ];
          return Scaffold(
            appBar: AppBar(title: const Text('Order Management')),
            body: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (provider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(provider.errorMessage, style: const TextStyle(color: Colors.red)),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text('Order ID: ${order['id']}'),
                                subtitle: Text('Status: ${order['status']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.cancel),
                                      tooltip: 'Cancel Order',
                                      onPressed: () async {
                                        await provider.cancelOrder(context: context, orderId: order['id']!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(provider.errorMessage.isEmpty ? 'Order cancelled' : provider.errorMessage)),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.assignment_return),
                                      tooltip: 'Return/Refund',
                                      onPressed: () async {
                                        await provider.initiateReturn(context: context, orderId: order['id']!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(provider.errorMessage.isEmpty ? 'Return initiated' : provider.errorMessage)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await provider.trackOrderStatus(context: context, orderId: order['id']!);
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Order Status'),
                                      content: Text(provider.orderStatus.isNotEmpty ? provider.orderStatus : 'No status available'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
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
} 