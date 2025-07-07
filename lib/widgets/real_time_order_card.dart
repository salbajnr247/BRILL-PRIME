
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/real_time_service.dart';
import '../providers/order_management_provider.dart';
import '../models/consumer_order_model.dart';
import '../resources/constants/color_constants.dart';
import '../resources/constants/styles_manager.dart';
import '../ui/consumer/toll_gates/consumer_order_detail.dart';

class RealTimeOrderCard extends StatefulWidget {
  final ConsumerOrderData order;
  final VoidCallback? onStatusChanged;
  
  const RealTimeOrderCard({
    Key? key,
    required this.order,
    this.onStatusChanged,
  }) : super(key: key);

  @override
  State<RealTimeOrderCard> createState() => _RealTimeOrderCardState();
}

class _RealTimeOrderCardState extends State<RealTimeOrderCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _statusController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _statusColorAnimation;
  
  ConsumerOrderData? _currentOrder;
  String _previousStatus = '';

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _previousStatus = widget.order.status;
    _setupAnimations();
    _setupRealTimeListener();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _statusController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _statusColorAnimation = ColorTween(
      begin: _getStatusColor(_previousStatus),
      end: _getStatusColor(_currentOrder?.status ?? ''),
    ).animate(CurvedAnimation(
      parent: _statusController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupRealTimeListener() {
    final realTimeService = RealTimeService();
    realTimeService.orderUpdates.listen((orderUpdate) {
      if (orderUpdate['orderId'] == _currentOrder?.id.toString()) {
        _updateOrderStatus(orderUpdate);
      }
    });
  }

  void _updateOrderStatus(Map<String, dynamic> orderUpdate) {
    if (mounted) {
      setState(() {
        _previousStatus = _currentOrder?.status ?? '';
        _currentOrder = _currentOrder?.copyWith(
          status: orderUpdate['status'] ?? _currentOrder?.status,
        );
      });
      
      // Animate status change
      _statusColorAnimation = ColorTween(
        begin: _getStatusColor(_previousStatus),
        end: _getStatusColor(_currentOrder?.status ?? ''),
      ).animate(CurvedAnimation(
        parent: _statusController,
        curve: Curves.easeInOut,
      ));
      
      _statusController.forward().then((_) {
        _statusController.reset();
      });
      
      // Pulse animation for attention
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });
      
      widget.onStatusChanged?.call();
      
      // Update provider
      context.read<OrderManagementProvider>().fetchAllOrders(context: context);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Confirmation';
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Being Prepared';
      case 'ready':
        return 'Ready for Pickup';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentOrder == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsumerOrderDetail(
                      orderId: _currentOrder!.id.toString(),
                    ),
                  ),
                );
              },
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
                          'Order #${_currentOrder!.id}',
                          style: getBoldStyle(textColor: mainColor, fontSize: 16),
                        ),
                        AnimatedBuilder(
                          animation: _statusColorAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: (_statusColorAnimation.value ?? _getStatusColor(_currentOrder!.status))
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _statusColorAnimation.value ?? _getStatusColor(_currentOrder!.status),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getStatusText(_currentOrder!.status),
                                style: getBoldStyle(
                                  textColor: _statusColorAnimation.value ?? _getStatusColor(_currentOrder!.status),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total: ₦${_currentOrder!.totalPrice}',
                      style: getRegularStyle(textColor: lightTextColor, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Order Date: ${_currentOrder!.createdAt.toString().split(' ')[0]}',
                      style: getRegularStyle(textColor: lightTextColor, fontSize: 12),
                    ),
                    if (_currentOrder!.status.toLowerCase() == 'preparing') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStatusColor(_currentOrder!.status),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Your order is being prepared...',
                            style: getRegularStyle(
                              textColor: _getStatusColor(_currentOrder!.status),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
