import 'package:brill_prime/models/opening_hours_model.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../widgets/custom_snack_back.dart';

class SelectCategoryScreen extends StatefulWidget {
  final bool isCategories;
  const SelectCategoryScreen({super.key, this.isCategories = true});
  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
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
          child: Consumer2<AuthProvider, VendorProvider>(
              builder: (ctx, authProvider, vendorProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (authProvider.resMessage != '') {
                customSnackBar(context, authProvider.resMessage);

                ///Clear the response message to avoid duplicate
                authProvider.clear();
              }
            });
            return Column(
              children: [
                const CustomAppbar(title: ""),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                    child: BodyTextPrimaryWithLineHeight(
                  text: "Category",
                  fontWeight: extraBoldFont,
                  textColor: Color.fromRGBO(11, 26, 81, 1),
                  fontSize: 20,
                )),
                const SizedBox(
                  height: 30,
                ),
                authProvider.gettingCategories
                    ? const LoadingIndicator()
                    : authProvider.categories.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              const BodyTextPrimaryWithLineHeight(
                                text: "No Categories Available",
                                fontWeight: semiBoldFont,
                                fontSize: 18,
                                textColor: blackTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: MainButton("Try Again", () {
                                  authProvider.getCategories(context: context);
                                }),
                              )
                            ],
                          )
                        : Expanded(
                            child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding.w),
                            child: ListView.builder(
                                itemCount: authProvider.categories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      authProvider.categories[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.isCategories) {
                                          authProvider
                                              .updateSelectedCategory(category);
                                        } else {
                                          vendorProvider
                                              .updateSelectedSubCategory(
                                                  category);
                                        }

                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Image.network(
                                                category.imageUrl ??
                                                    categoryImagePlaceHolder),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child:
                                                BodyTextPrimaryWithLineHeight(
                                              text: category.name,
                                              textColor: const Color.fromRGBO(
                                                  19, 19, 19, 1),
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

final List<String> categoryList = [
  "Apparel & Clothing",
  "Art & Entertainment",
  "Beauty, Cosmetics & Personal Care",
  "Education",
  "Event Planner",
  "Finance",
  "Supermarket/Convenience Store",
  "Hotel",
  "Medical & Health",
  "Non-profit Organisation",
  "Oil & Gas",
  "Restaurant",
  "Shopping & Retail",
  "Ticket",
  "Toll Gate",
  "Vehicle Service",
  "Other Business"
];
