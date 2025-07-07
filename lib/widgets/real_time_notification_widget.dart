import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../services/real_time_service.dart';
import '../models/notification_model.dart';
import '../resources/constants/color_constants.dart';
import '../resources/constants/styles_manager.dart';

class RealTimeNotificationWidget extends StatefulWidget {
  final String userId;
  final Function(NotificationModel)? onNotificationTap;

  const RealTimeNotificationWidget({
    Key? key,
    required this.userId,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  State<RealTimeNotificationWidget> createState() => _RealTimeNotificationWidgetState();
}

class _RealTimeNotificationWidgetState extends State<RealTimeNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  NotificationModel? _lastNotification;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupRealTimeListener();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  void _setupRealTimeListener() {
    final realTimeService = RealTimeService();
    realTimeService.subscribeToNotifications(widget.userId);

    realTimeService.notifications.listen((notification) {
      final notificationModel = NotificationModel.fromJson(notification);
      _showNotification(notificationModel);

      // Add to provider
      context.read<NotificationProvider>().addNotification(notificationModel);
    });
  }

  void _showNotification(NotificationModel notification) {
    if (mounted) {
      setState(() {
        _lastNotification = notification;
        _isVisible = true;
      });

      _animationController.forward();

      // Auto-hide after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        _hideNotification();
      });
    }
  }

  void _hideNotification() {
    if (mounted) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _isVisible = false;
            _lastNotification = null;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _lastNotification == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: mainColor, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getNotificationIcon(_lastNotification!.type),
                      color: mainColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _lastNotification!.title,
                          style: getBoldStyle(textColor: mainColor, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _lastNotification!.body,
                          style: getRegularStyle(textColor: lightTextColor, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _hideNotification,
                    icon: const Icon(Icons.close, size: 20),
                    color: lightTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag;
      case 'payment':
        return Icons.payment;
      case 'delivery':
        return Icons.local_shipping;
      case 'promotion':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }
}