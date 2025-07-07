
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/real_time_provider.dart';
import '../models/notification_model.dart';
import '../resources/constants/color_constants.dart';

class RealTimeNotificationWidget extends StatelessWidget {
  const RealTimeNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: realTimeProvider.isConnected 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: realTimeProvider.isConnected 
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            realTimeProvider.isConnected ? 'Live' : 'Offline',
                            style: TextStyle(
                              fontSize: 10,
                              color: realTimeProvider.isConnected 
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (realTimeProvider.notifications.isNotEmpty)
                      IconButton(
                        onPressed: () => realTimeProvider.clearNotifications(),
                        icon: const Icon(Icons.clear_all),
                        tooltip: 'Clear all notifications',
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (realTimeProvider.notifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No new notifications',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: realTimeProvider.notifications.length,
                itemBuilder: (context, index) {
                  final notification = realTimeProvider.notifications[index];
                  return _buildNotificationItem(context, notification, realTimeProvider);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    RealTimeProvider realTimeProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead == true 
              ? Colors.grey.withOpacity(0.2)
              : ColorConstants.primaryColor.withOpacity(0.3),
          width: notification.isRead == true ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? 'Notification',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: notification.isRead == true 
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                if (notification.body != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.body!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(notification.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (notification.isRead != true)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => realTimeProvider.markNotificationAsRead(notification.id!),
                icon: Icon(
                  notification.isRead == true ? Icons.mark_email_read : Icons.mark_email_unread,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Icons.shopping_cart;
      case 'payment':
        return Icons.payment;
      case 'inventory':
        return Icons.inventory;
      case 'chat':
        return Icons.chat;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Colors.blue;
      case 'payment':
        return Colors.green;
      case 'inventory':
        return Colors.orange;
      case 'chat':
        return Colors.purple;
      case 'system':
        return Colors.grey;
      default:
        return ColorConstants.primaryColor;
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
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
