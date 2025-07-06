import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_appbar.dart';

class CanineAroundYouDetailScreen extends StatefulWidget {
  const CanineAroundYouDetailScreen({super.key});

  @override
  State<CanineAroundYouDetailScreen> createState() =>
      _CanineAroundYouDetailScreenState();
}

class _CanineAroundYouDetailScreenState
    extends State<CanineAroundYouDetailScreen> with TickerProviderStateMixin {
  PageController pageViewController = PageController();

  int selectedIndex = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Consumer2<AuthProvider, DashboardProvider>(
              builder: (ctx, authProvider, dashboardProvider, child) {
            return Column(
              children: [
                const TopPadding(),
                const CustomAppbar(title: "Around you"),
                Expanded(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Stack(
                        alignment: Alignment.bottomCenter,
                        children: [],
                      )),
                ),
              ],
            );
          })),
    );
  }
}
