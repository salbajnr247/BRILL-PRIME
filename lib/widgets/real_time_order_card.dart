
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/real_time_provider.dart';
import '../models/vendor_order_model.dart';
import '../resources/constants/color_constants.dart';

class RealTimeOrderCard extends StatelessWidget {
  final VendorOrderModel order;
  final VoidCallback? onTap;

  const RealTimeOrderCard({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: _getOrderStatusBorder(),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _buildStatusChip(),
                          const SizedBox(width: 8),
                          if (realTimeProvider.isConnected)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Customer: ${order.customerName ?? "N/A"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${order.total?.toStringAsFixed(2) ?? "0.00"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                      Text(
                        _formatTime(order.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  if (_shouldShowActions())
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          if (order.status == 'pending')
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _acceptOrder(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Accept'),
                              ),
                            ),
                          if (order.status == 'pending')
                            const SizedBox(width: 8),
                          if (order.status == 'pending')
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _rejectOrder(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                                child: const Text('Reject'),
                              ),
                            ),
                          if (order.status == 'accepted')
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _markAsReady(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstants.primaryColor,
                                ),
                                child: const Text('Mark Ready'),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    
    switch (order.status?.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'accepted':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      case 'ready':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'completed':
        backgroundColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        order.status?.toUpperCase() ?? 'UNKNOWN',
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Border? _getOrderStatusBorder() {
    switch (order.status?.toLowerCase()) {
      case 'pending':
        return Border.all(color: Colors.orange.withOpacity(0.3), width: 2);
      case 'accepted':
        return Border.all(color: Colors.blue.withOpacity(0.3), width: 2);
      default:
        return null;
    }
  }

  bool _shouldShowActions() {
    return order.status == 'pending' || order.status == 'accepted';
  }

  void _acceptOrder(BuildContext context) {
    final realTimeProvider = Provider.of<RealTimeProvider>(context, listen: false);
    realTimeProvider.updateOrderStatus(order.id!, 'accepted');
  }

  void _rejectOrder(BuildContext context) {
    final realTimeProvider = Provider.of<RealTimeProvider>(context, listen: false);
    realTimeProvider.updateOrderStatus(order.id!, 'cancelled');
  }

  void _markAsReady(BuildContext context) {
    final realTimeProvider = Provider.of<RealTimeProvider>(context, listen: false);
    realTimeProvider.updateOrderStatus(order.id!, 'ready');
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
