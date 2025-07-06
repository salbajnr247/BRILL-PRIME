import 'dart:io';

import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_order_screen.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../consumer/consumer_home.dart';
import '../widgets/components.dart';
import '../widgets/rating_widget.dart';
import '../widgets/vendor_drawar_widget.dart';
import 'manage_commodities.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVendorData();
      _loadVendorDashboard();
    });
  }

  Future<void> _loadVendorData() async {
    try {
      final vendorProvider = context.read<VendorProvider>();
      await vendorProvider.getVendorOrders(context: context);
      if (!mounted) return;

      if (vendorProvider.resMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vendorProvider.resMessage),
            backgroundColor: vendorProvider.resMessage.toLowerCase().contains('error')
                ? Colors.red
                : Colors.green,
          ),
        );
        vendorProvider.clear();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading vendor data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadVendorDashboard() async {
    try {
      final vendorProvider = context.read<VendorProvider>();
      await vendorProvider.getVendorDashboard(context: context);
      if (!mounted) return;
      if (vendorProvider.resMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vendorProvider.resMessage),
            backgroundColor: vendorProvider.resMessage.toLowerCase().contains('error')
                ? Colors.red
                : Colors.green,
          ),
        );
        vendorProvider.clear();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshData() async {
    try {
      await _loadVendorData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: const VendorDrawerWidget()),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu)),
        actions: const [
          // IconButton(
          //     onPressed: (){
          //       Get.to(()=> const ConsumerCartPage());
          //     },
          //     icon: const Icon(Icons.shopping_cart_outlined)
          // )
        ],
      ),
      body: SafeArea(child: Consumer2<AuthProvider, VendorProvider>(
          builder: (ctx, authProvider, vendorProvider, child) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Image.network(authProvider.userProfile?.data.imageUrl ??
                  categoryImagePlaceHolder),
            ),
            BodyTextPrimaryWithLineHeight(
              text: "${authProvider.userProfile?.data.vendor?.businessName}",
              textColor: const Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            BodyTextPrimaryWithLineHeight(
              text:
                  "${authProvider.userProfile?.data.vendor?.businessCategory ?? 'NA'}",
              fontSize: 12,
              fontWeight: thinFont,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  // DASHBOARD SECTION
                  Consumer<VendorProvider>(
                    builder: (context, vendorProvider, _) {
                      if (vendorProvider.loadingDashboard) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (vendorProvider.dashboardData == null) {
                        return const SizedBox();
                      }
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 8),
                              ...vendorProvider.dashboardData!.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // END DASHBOARD SECTION
                  const RatingWidget(
                    rating: 4,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 40),
                  //   child: BodyTextPrimaryWithLineHeight(
                  //     text:
                  //         "Total Energy ar your reliable, friendly fuel distributors, trust us to deliver the best services.",
                  //     alignCenter: true,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Address",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BodyTextPrimaryWithLineHeight(
                      text:
                          "${authProvider.userProfile?.data.vendor?.businessCategory ?? 'NA'}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Email",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BodyTextPrimaryWithLineHeight(
                      text: "${authProvider.userProfile?.data.email ?? 'NA'}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Number",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BodyTextPrimaryWithLineHeight(
                      text: "${authProvider.userProfile?.data.phone ?? 'NA'}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Opening Hours",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BodyTextPrimaryWithLineHeight(text: "Always Open"),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: CustomContainerButton(
                                  onTap: () {
                                    vendorProvider.getVendorOrders(
                                        context: context);
                                    navToWithScreenName(
                                        context: context,
                                        screen: const VendorOrderScreen());
                                  },
                                  title: "",
                                  borderRadius: 30,
                                  widget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        manageOrdersIcon,
                                        height: 24,
                                        width: 24,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: BodyTextPrimaryWithLineHeight(
                                          text: "Manage Orders",
                                          textColor: white,
                                          fontWeight: mediumFont,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  bgColor: mainColor,
                                )),
                            if (vendorProvider.vendorOrders.isNotEmpty)
                              Positioned(
                                right: -10,
                                top: -15,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                  child: BodyTextPrimaryWithLineHeight(
                                    text:
                                        "${vendorProvider.vendorOrders.length}",
                                    fontWeight: boldFont,
                                    textColor: black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ActionButton(
                              icon: manageCommoditiesIcon,
                              title: "Manage Commodities",
                              isNetworkImage: false,
                              bgColor: deepBlueColor,
                              onTap: () {
                                vendorProvider.getVendorCommodities(
                                    context: context,
                                    vendorId:
                                        authProvider.userProfile?.data.id ??
                                            "");
                                authProvider.getCategories(
                                    context: context,
                                    isFilter: true,
                                    filter: authProvider.userProfile?.data
                                            .vendor?.businessCategory ??
                                        "");
                                navToWithScreenName(
                                    context: context,
                                    screen: const ManageCommoditiesScreen());
                              })),
                    ],
                  ),
                  SizedBox(
                    height: Platform.isAndroid ? bottomPadding.h : 0,
                  )
                ],
              ),
            )
          ],
        );
      })),
    );
  }
}

class ButtonWithCounter extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double counter;
  final String iconName;
  final Color bgColor;
  const ButtonWithCounter(
      {super.key,
      required this.onTap,
      required this.title,
      required this.counter,
      required this.iconName,
      this.bgColor = mainColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: 54,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomContainerButton(
                    onTap: onTap,
                    title: "",
                    borderRadius: 30,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          iconName,
                          height: 24,
                          width: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: BodyTextPrimaryWithLineHeight(
                            text: title,
                            textColor: white,
                            fontWeight: mediumFont,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    bgColor: bgColor,
                  )),
              if (counter > 1)
                Positioned(
                  right: -10,
                  top: -15,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: BodyTextPrimaryWithLineHeight(
                      text: counter.toStringAsFixed(0),
                      fontWeight: boldFont,
                      textColor: black,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        )),
      ],
    );
  }
}
