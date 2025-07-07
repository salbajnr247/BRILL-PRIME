
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/real_time_provider.dart';
import '../resources/constants/color_constants.dart';

class RealTimeStatusWidget extends StatelessWidget {
  const RealTimeStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: realTimeProvider.isConnected 
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: realTimeProvider.isConnected 
                  ? Colors.green
                  : Colors.red,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                realTimeProvider.isConnected 
                    ? Icons.wifi
                    : Icons.wifi_off,
                color: realTimeProvider.isConnected 
                    ? Colors.green
                    : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                realTimeProvider.isConnected ? 'Live' : 'Offline',
                style: TextStyle(
                  color: realTimeProvider.isConnected 
                      ? Colors.green
                      : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
