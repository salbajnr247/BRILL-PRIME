import 'dart:io';
import 'package:brill_prime/models/category_model.dart';
import 'package:brill_prime/providers/image_upload_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/select_category_screen.dart';
import 'package:brill_prime/ui/vendor/select_unit_of_item_screen.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/utils/constants.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';

import '../../utils/navigation_util.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class EditCommodityScreen extends StatefulWidget {
  const EditCommodityScreen({super.key});
  @override
  State<EditCommodityScreen> createState() => _EditCommodityScreenState();
}

class _EditCommodityScreenState extends State<EditCommodityScreen> {
  final nameOfItemController = TextEditingController();
  final descriptionController = TextEditingController();
  final pricePerItemController = TextEditingController();

  String? imageUrl;

  bool uploadingImage = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final vendorProvider =
          Provider.of<VendorProvider>(context, listen: false);
      nameOfItemController.text = vendorProvider.selectedCommodity?.name ?? "";
      descriptionController.text =
          vendorProvider.selectedCommodity?.description ?? "";
      pricePerItemController.text =
          vendorProvider.selectedCommodity?.price ?? "";
      vendorProvider.updateSelectedSubCategory(CategoryData(
          id: "",
          name: vendorProvider.selectedCommodity?.category,
          imageUrl: ""));
      vendorProvider
          .updateSelectedUnitOfItem(vendorProvider.selectedCommodity?.unit);
      setState(() {});
    });
    super.initState();
  }

  File? commodityPicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer3<AuthProvider, VendorProvider, ImageUploadProvider>(
              builder: (ctx, authProvider, vendorProvider, imageUploadProvider,
                  child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (vendorProvider.resMessage != '') {
                customSnackBar(context, vendorProvider.resMessage);

                ///Clear the response message to avoid duplicate
                vendorProvider.clear();
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
                  text: "Update Commodity",
                  fontWeight: extraBoldFont,
                  textColor: Color.fromRGBO(11, 26, 81, 1),
                  fontSize: 20,
                )),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: () async {
                              commodityPicture =
                                  await handleChooseFromGallery(context);
                              setState(() {});
                            },
                            child: Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: mainColor),
                              ),
                              child: commodityPicture == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 90),
                                      child: Image.network(
                                        vendorProvider
                                                .selectedCommodity?.imageUrl ??
                                            cameraIcon,
                                        height: 80,
                                        width: 80,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 25),
                                      child: Image.file(commodityPicture!),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Name of Item",
                                nameOfItemController,
                                isCapitalizeSentence: true,
                                type: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Description",
                                descriptionController,
                                isCapitalizeSentence: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        CustomDropdownButton(
                            title: vendorProvider.selectedSubCategory?.name ??
                                "Sub Category",
                            textColor:
                                vendorProvider.selectedSubCategory != null
                                    ? black
                                    : hintTextColor,
                            fontWeight: mediumFont,
                            onTap: () async {
                              authProvider.getCategories(
                                  context: context,
                                  isFilter: true,
                                  filter: authProvider.userProfile?.data.vendor
                                          ?.businessCategory ??
                                      "NA");
                              navToWithScreenName(
                                  context: context,
                                  screen: const SelectCategoryScreen(
                                    isCategories: false,
                                  ));
                            }),
                        SizedBox(
                          height: 16.h,
                        ),
                        CustomDropdownButton(
                            title: vendorProvider.selectedUnitOfItem ??
                                "Basic Unit Of item",
                            textColor: vendorProvider.selectedUnitOfItem != null
                                ? black
                                : hintTextColor,
                            fontWeight: mediumFont,
                            onTap: () async {
                              authProvider.getCategories(context: context);
                              navToWithScreenName(
                                  context: context,
                                  screen: const SelectUnitOfItemScreen());
                            }),
                        SizedBox(
                          height: 16.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Price per Item",
                                pricePerItemController,
                                isCapitalizeSentence: false,
                                formatters: numbersOnlyFormat,
                                length: 11,
                                type: const TextInputType.numberWithOptions(
                                    signed: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: vendorProvider.updatingCommodity ||
                                    uploadingImage
                                ? const Center(
                                    child: CupertinoActivityIndicator())
                                : MainButton(
                                    "Save",
                                    fontWeight: mediumFont,
                                    () async {
                                      if (commodityPicture == null) {
                                        customSnackBar(context,
                                            "Upload the image of the commodity");
                                      } else if (nameOfItemController
                                          .text.isEmpty) {
                                        customSnackBar(
                                            context, "Enter a valid name");
                                      } else if (pricePerItemController
                                          .text.isEmpty) {
                                        customSnackBar(
                                            context, "Enter a valid price");
                                      } else if (vendorProvider
                                              .selectedSubCategory ==
                                          null) {
                                        customSnackBar(context,
                                            "Select a valid sub category");
                                      } else {
                                        setState(() {
                                          uploadingImage = true;
                                        });
                                        imageUrl = await imageUploadProvider
                                            .uploadImage(
                                                commodityPicture!,
                                                authProvider
                                                    .userProfile?.data.id);
                                        if (!mounted) return;
                                        setState(() {
                                          uploadingImage = false;
                                        });

                                        if (imageUrl != null) {
                                          final commodityAdded =
                                              await vendorProvider.updateCommodity(
                                                  context: context,
                                                  commodityId: vendorProvider
                                                          .selectedCommodity
                                                          ?.id ??
                                                      "",
                                                  commodityName:
                                                      nameOfItemController.text,
                                                  imageURL: imageUrl!.replaceAll(
                                                      "your-bucket-name",
                                                      "brillprime"),
                                                  price: pricePerItemController
                                                      .text,
                                                  unit: vendorProvider
                                                          .selectedUnitOfItem ??
                                                      "",
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  quantity: 100,
                                                  category: vendorProvider
                                                      .selectedSubCategory
                                                      ?.name);
                                          if (!mounted) return;
                                          if (commodityAdded) {
                                            debugPrint("Added=======");
                                            vendorProvider.getVendorCommodities(
                                                context: context,
                                                vendorId: authProvider
                                                        .userProfile?.data.id ??
                                                    "");
                                            Navigator.pop(context);
                                          } else {
                                            debugPrint("Not Added=======");
                                          }
                                        } else {
                                          if (!mounted) return;
                                          customSnackBar(context,
                                              'Unable to upload image');
                                        }
                                      }
                                    },
                                    color: const Color.fromRGBO(11, 26, 81, 1),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: bottomPadding.h,
                ),
              ],
            );
          })),
    );
  }
}
