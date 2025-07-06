import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification_model.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationProvider()..fetchNotifications(context: context),
      child: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Notifications')),
            body: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.errorMessage.isNotEmpty
                    ? Center(child: Text(provider.errorMessage))
                    : provider.notifications.isEmpty
                        ? const Center(child: Text('No notifications.'))
                        : ListView.builder(
                            itemCount: provider.notifications.length,
                            itemBuilder: (context, index) {
                              final notif = provider.notifications[index];
                              return ListTile(
                                leading: notif.isRead
                                    ? const Icon(Icons.mark_email_read, color: Colors.green)
                                    : const Icon(Icons.mark_email_unread, color: Colors.blue),
                                title: Text(notif.title),
                                subtitle: Text('${notif.body}\n${notif.createdAt.toLocal()}'),
                                trailing: notif.isRead
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.done),
                                        tooltip: 'Mark as read',
                                        onPressed: () async {
                                          final marked = await provider.markAsRead(
                                            context: context,
                                            notificationId: notif.id,
                                          );
                                          if (marked) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Marked as read.')),
                                            );
                                          } else if (provider.errorMessage.isNotEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(provider.errorMessage)),
                                            );
                                          }
                                        },
                                      ),
                              );
                            },
                          ),
          );
        },
      ),
    );
  }
} 