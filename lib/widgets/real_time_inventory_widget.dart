
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/real_time_provider.dart';
import '../models/commodities_model.dart';
import '../resources/constants/color_constants.dart';

class RealTimeInventoryWidget extends StatelessWidget {
  final String vendorId;

  const RealTimeInventoryWidget({
    Key? key,
    required this.vendorId,
  }) : super(key: key);

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
                  'Live Inventory',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              ],
            ),
            const SizedBox(height: 16),
            if (realTimeProvider.inventory.isEmpty)
              const Center(
                child: Text('No inventory items available'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: realTimeProvider.inventory.length,
                itemBuilder: (context, index) {
                  final item = realTimeProvider.inventory[index];
                  return _buildInventoryItem(context, item, realTimeProvider);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildInventoryItem(
    BuildContext context,
    CommoditiesModel item,
    RealTimeProvider realTimeProvider,
  ) {
    final isLowStock = (item.quantity ?? 0) < 10;
    final isOutOfStock = (item.quantity ?? 0) == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOutOfStock 
              ? Colors.red.withOpacity(0.3)
              : isLowStock 
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
          width: isOutOfStock || isLowStock ? 2 : 1,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.inventory,
              color: ColorConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? 'Unknown Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Stock: ${item.quantity ?? 0}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isOutOfStock 
                            ? Colors.red
                            : isLowStock 
                                ? Colors.orange
                                : Colors.grey[600],
                        fontWeight: isOutOfStock || isLowStock 
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isOutOfStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'OUT OF STOCK',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'LOW STOCK',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _updateQuantity(context, item, 1, realTimeProvider),
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              ),
              IconButton(
                onPressed: () => _updateQuantity(context, item, -1, realTimeProvider),
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateQuantity(
    BuildContext context,
    CommoditiesModel item,
    int change,
    RealTimeProvider realTimeProvider,
  ) {
    final currentQuantity = item.quantity ?? 0;
    final newQuantity = currentQuantity + change;
    
    if (newQuantity >= 0) {
      realTimeProvider.updateInventory(item.id!, newQuantity);
    }
  }
}
