import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_order_detail_screen.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VendorTransactionHistoryScreen extends StatelessWidget {
  const VendorTransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Consumer2<VendorProvider, AuthProvider>(
              builder: (ctx, vendorProvider, authProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {});
            return Column(
              children: [
                const CustomAppbar(title: ""),
                const SizedBox(
                  height: 20,
                ),
                const BodyTextPrimaryWithLineHeight(
                  text: "Transaction History",
                  textColor: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 20,
                  fontWeight: extraBoldFont,
                ),
                const SizedBox(
                  height: 20,
                ),
                vendorProvider.gettingVendorOrders
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.35),
                          child: const CupertinoActivityIndicator(),
                        ),
                      )
                    : Expanded(
                        child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding.w),
                            child: ListView.builder(
                                itemCount: vendorProvider.vendorOrders.length,
                                itemBuilder: (context, index) {
                                  final order =
                                      vendorProvider.vendorOrders[index];
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: InkWell(
                                        onTap: () {
                                          vendorProvider
                                              .getConsumerSingleOrders(
                                                  context: context,
                                                  orderId: order.id);
                                          navToWithScreenName(
                                              context: context,
                                              screen:
                                                  const VendorOrderDetailScreen());
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const BodyTextPrimaryWithLineHeight(
                                                  text: "Received",
                                                  textColor: Color.fromRGBO(
                                                      19, 19, 19, 1),
                                                  fontWeight: mediumFont,
                                                  fontSize: 13,
                                                ),
                                                BodyTextPrimaryWithLineHeight(
                                                  text:
                                                      "+${returnFormattedAmountWithCurrency(amount: order.totalPrice)}",
                                                  textColor:
                                                      const Color.fromRGBO(
                                                          101, 117, 255, 1),
                                                  fontSize: 13,
                                                  fontWeight: mediumFont,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BodyTextPrimaryWithLineHeight(
                                                  text:
                                                      returnFormattedDateAndTime(
                                                              order.createdAt
                                                                  .toString())
                                                          .capitalize(),
                                                  textColor:
                                                      const Color.fromRGBO(
                                                          19, 19, 19, 1),
                                                  fontSize: 8,
                                                  fontWeight: mediumFont,
                                                ),
                                                BodyTextPrimaryWithLineHeight(
                                                  text: "${order.status}"
                                                      .capitalize(),
                                                  textColor: order.status ==
                                                          "PAID"
                                                      ? const Color.fromRGBO(
                                                          101, 117, 255, 1)
                                                      : const Color.fromRGBO(
                                                          255, 149, 0, 1),
                                                  fontSize: 8,
                                                  fontWeight: mediumFont,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            const LongDivider(),
                                          ],
                                        ),
                                      ));
                                }),
                          ))
                        ],
                      )),
              ],
            );
          })),
    );
  }
}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions() async {
    try {
      await context.read<VendorProvider>().getVendorOrders(context: context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transactions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshTransactions() async {
    try {
      await context.read<VendorProvider>().getVendorOrders(context: context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error refreshing transactions: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
          body: Consumer<VendorProvider>(
            builder: (context, vendorProvider, child) {
              if (vendorProvider.loadingOrders) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (vendorProvider.orders.isEmpty) {
                return const Center(
                  child: Text('No transactions found'),
                );
              }

              return RefreshIndicator(
                onRefresh: _refreshTransactions,
                child: ListView.builder(
                  itemCount: vendorProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = vendorProvider.orders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorOrderDetailScreen(
                              order: order,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        // ... existing card content ...
