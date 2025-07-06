import 'package:brill_prime/models/opening_hours_model.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../resources/constants/dimension_constants.dart';

class SelectUnitOfItemScreen extends StatefulWidget {
  const SelectUnitOfItemScreen({super.key});
  @override
  State<SelectUnitOfItemScreen> createState() => _SelectUnitOfItemScreenState();
}

class _SelectUnitOfItemScreenState extends State<SelectUnitOfItemScreen> {
  List<OpeningHoursModel> openingHours = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child:
              Consumer<VendorProvider>(builder: (ctx, vendorProvider, child) {
            return Column(
              children: [
                const CustomAppbar(title: ""),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                    child: BodyTextPrimaryWithLineHeight(
                  text: "Unit of Item",
                  fontWeight: extraBoldFont,
                  textColor: Color.fromRGBO(11, 26, 81, 1),
                  fontSize: 20,
                )),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                  child: ListView.builder(
                      itemCount: unitOfItems.length,
                      itemBuilder: (context, index) {
                        final unit = unitOfItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              vendorProvider.updateSelectedUnitOfItem(unit);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: BodyTextPrimaryWithLineHeight(
                                    text: unit,
                                    textColor:
                                        const Color.fromRGBO(19, 19, 19, 1),
                                    fontSize: 18,
                                    fontWeight: mediumFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )),
                SizedBox(
                  height: bottomPadding.h,
                ),
              ],
            );
          })),
    );
  }
}
