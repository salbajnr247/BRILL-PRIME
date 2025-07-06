import 'dart:io';

import 'package:brill_prime/models/opening_hours_model.dart';
import 'package:brill_prime/providers/image_upload_provider.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/select_category_screen.dart';
import 'package:brill_prime/ui/vendor/vendor_home_screen.dart';
import 'package:brill_prime/ui/vendor/widgets/modal/show_opening_hour_time_modal.dart';
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
import '../../resources/constants/image_constant.dart';
import '../../utils/navigation_util.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class CompleteVendorScreen extends StatefulWidget {
  const CompleteVendorScreen({super.key});
  @override
  State<CompleteVendorScreen> createState() => _CompleteVendorScreenState();
}

class _CompleteVendorScreenState extends State<CompleteVendorScreen> {
  final businessNameController = TextEditingController();
  final businessNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final monOpController = TextEditingController();
  final monClController = TextEditingController();

  final tuesOpController = TextEditingController();
  final tuesClController = TextEditingController();

  final wedOpController = TextEditingController();
  final wedClController = TextEditingController();

  final thursOpController = TextEditingController();
  final thursClController = TextEditingController();

  final friOpController = TextEditingController();
  final friClController = TextEditingController();

  final satOpController = TextEditingController();
  final satClController = TextEditingController();

  final sunOpController = TextEditingController();
  final sunClController = TextEditingController();

  List<OpeningHoursModel> openingHours = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      openingHours = [
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Monday",
            openingHour: "",
            openingTime: "am",
            openingHourController: monOpController,
            closingHourController: monClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Tuesday",
            openingHour: "",
            openingTime: "am",
            openingHourController: tuesOpController,
            closingHourController: tuesClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Wednesday",
            openingHour: "",
            openingTime: "am",
            openingHourController: wedOpController,
            closingHourController: wedClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Thursday",
            openingHour: "",
            openingTime: "am",
            openingHourController: thursOpController,
            closingHourController: thursClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Friday",
            openingHour: "",
            openingTime: "am",
            openingHourController: friOpController,
            closingHourController: friClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Saturday",
            openingHour: "",
            openingTime: "am",
            openingHourController: satOpController,
            closingHourController: satClController),
        OpeningHoursModel(
            closingHour: "",
            closingTime: "pm",
            dayOfTheWeek: "Sunday",
            openingHour: "",
            openingTime: "am",
            openingHourController: sunOpController,
            closingHourController: sunClController),
      ];
      setState(() {});
    });
    super.initState();
  }

  File? profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer2<AuthProvider, ImageUploadProvider>(
              builder: (ctx, authProvider, imageUploadProvider, child) {
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
                  text: "Complete Your Profile",
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
                              profilePicture =
                                  await handleChooseFromGallery(context);
                              setState(() {});
                              if (profilePicture != null) {
                                //   Upload the image;
                                String? profileImageURL =
                                    await imageUploadProvider.uploadImage(
                                        profilePicture!,
                                        authProvider.userProfile?.data.id);
                                debugPrint("The URL is::::: $profileImageURL");
                              }
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromRGBO(217, 217, 217, 1),
                                  image: profilePicture == null
                                      ? null
                                      : DecorationImage(
                                          image: FileImage(profilePicture!),
                                          fit: BoxFit.cover)),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                      bottom: 10,
                                      right: -4,
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Image.asset(editIcon),
                                      )),
                                  if (profilePicture == null)
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        top: 30,
                                        bottom: 30,
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Image.network(cameraIcon),
                                        )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Label(title: "Company/Business Name"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Company/Business Name",
                                businessNameController,
                                isCapitalizeSentence: true,
                                type: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Business Number"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "RC 00000",
                                businessNumberController,
                                isCapitalizeSentence: false,
                                length: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Category"),
                        CustomDropdownButton(
                            title: authProvider.selectedCategory?.name ??
                                "Category",
                            textColor: authProvider.selectedCategory != null
                                ? black
                                : hintTextColor,
                            fontWeight: mediumFont,
                            onTap: () async {
                              authProvider.getCategories(context: context);
                              navToWithScreenName(
                                  context: context,
                                  screen: const SelectCategoryScreen());
                            }),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Email"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "name@email.com ",
                                emailController,
                                isCapitalizeSentence: false,
                                type: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Number"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "+234 0000 0000 00 ",
                                phoneController,
                                isCapitalizeSentence: false,
                                length: 11,
                                formatters: numbersOnlyFormat,
                                type: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Address"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Address ",
                                addressController,
                                isCapitalizeSentence: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Opening Hours"),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: openingHours.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final openingHour = openingHours[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BodyTextPrimaryWithLineHeight(
                                      text: openingHour.dayOfTheWeek,
                                      fontWeight: boldFont,
                                      textColor: black,
                                      fontSize: 16,
                                    ),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OpeningHourInputField(
                                          onChange: (String? value) {
                                            final updatedOpeningHour =
                                                OpeningHoursModel(
                                                    closingHour:
                                                        openingHour.closingHour,
                                                    closingTime:
                                                        openingHour.closingTime,
                                                    dayOfTheWeek: openingHour
                                                        .dayOfTheWeek,
                                                    openingHour: value ?? "",
                                                    openingTime:
                                                        openingHour.openingTime,
                                                    openingHourController:
                                                        openingHour
                                                            .openingHourController,
                                                    closingHourController:
                                                        openingHour
                                                            .closingHourController);
                                            openingHours[index] =
                                                updatedOpeningHour;
                                            debugPrint("Updated");
                                            setState(() {});
                                          },
                                          controller:
                                              openingHour.openingHourController,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: OpenHoursDropdownBtn(
                                              title: openingHour.openingTime,
                                              onTap: () async {
                                                String? selection =
                                                    await showOpeningHourTimeModal(
                                                        context);
                                                if (selection != null) {
                                                  debugPrint(
                                                      "Opening  Selection::::$selection");
                                                  final updatedOpeningHour =
                                                      OpeningHoursModel(
                                                          closingHour:
                                                              openingHour
                                                                  .closingHour,
                                                          closingTime:
                                                              openingHour
                                                                  .closingTime,
                                                          dayOfTheWeek:
                                                              openingHour
                                                                  .dayOfTheWeek,
                                                          openingHour:
                                                              openingHour
                                                                  .openingHour,
                                                          openingTime:
                                                              selection,
                                                          openingHourController:
                                                              openingHour
                                                                  .openingHourController,
                                                          closingHourController:
                                                              openingHour
                                                                  .closingHourController);
                                                  openingHours[index] =
                                                      updatedOpeningHour;
                                                  debugPrint("Updated");
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                        OpeningHourInputField(
                                          onChange: (String? value) {
                                            debugPrint("Value $value");
                                          },
                                          controller:
                                              openingHour.closingHourController,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: OpenHoursDropdownBtn(
                                              title: openingHour.closingTime,
                                              onTap: () async {
                                                String? selection =
                                                    await showOpeningHourTimeModal(
                                                        context);
                                                if (selection != null) {
                                                  debugPrint(
                                                      "Closing Time Selection $selection");
                                                  final updatedClosingTime =
                                                      OpeningHoursModel(
                                                          closingHour:
                                                              openingHour
                                                                  .closingHour,
                                                          closingTime:
                                                              selection,
                                                          dayOfTheWeek:
                                                              openingHour
                                                                  .dayOfTheWeek,
                                                          openingHour:
                                                              openingHour
                                                                  .openingHour,
                                                          openingTime:
                                                              openingHour
                                                                  .openingTime,
                                                          openingHourController:
                                                              openingHour
                                                                  .openingHourController,
                                                          closingHourController:
                                                              openingHour
                                                                  .closingHourController);
                                                  openingHours[index] =
                                                      updatedClosingTime;

                                                  debugPrint(
                                                      "Updated:::::: $selection  ${openingHours[index].closingTime}");
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10.h,
                        ),
                        authProvider.onboardingVendor
                            ? const Center(child: CupertinoActivityIndicator())
                            : Center(
                                child: SizedBox(
                                  width: 200,
                                  child: MainButton(
                                    "Save",
                                    fontWeight: mediumFont,
                                    () async {
                                      if (businessNameController.text
                                              .trim()
                                              .length <
                                          2) {
                                        customSnackBar(context,
                                            "Enter a valid Company name");
                                      } else if (businessNumberController.text
                                              .trim()
                                              .length <
                                          2) {
                                        customSnackBar(context,
                                            "Enter a valid Business Number");
                                      } else if (authProvider
                                              .selectedCategory ==
                                          null) {
                                        customSnackBar(
                                            context, "Select a category");
                                      } else if (emailController.text
                                              .trim()
                                              .length <
                                          3) {
                                        customSnackBar(
                                            context, "Enter a valid Email");
                                      } else if (phoneController.text.length <
                                          11) {
                                        customSnackBar(
                                          context,
                                          "Enter a valid phone number",
                                        );
                                      } else if (addressController.text
                                              .trim()
                                              .length <
                                          5) {
                                        customSnackBar(
                                            context, "Enter a valid Address");
                                      } else {
                                        final isOnboarded =
                                            await authProvider.onboardVendor(
                                                context: context,
                                                companyName:
                                                    businessNameController.text,
                                                businessNumber:
                                                    businessNumberController
                                                        .text,
                                                categoryName: authProvider
                                                        .selectedCategory
                                                        ?.name ??
                                                    "",
                                                number: phoneController.text,
                                                address: addressController.text,
                                                openingHours: openingHours);
                                        if (isOnboarded && context.mounted) {
                                          authProvider.getProfile(
                                              context: context);
                                          navToWithScreenName(
                                              context: context,
                                              screen: const VendorHomeScreen());
                                        }
                                      }
                                    },
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

class Label extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  const Label(
      {super.key,
      required this.title,
      this.fontSize = 20,
      this.fontWeight = boldFont});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: BodyTextPrimaryWithLineHeight(
            text: title,
            fontWeight: fontWeight,
            textColor: black,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}

class OpeningHourInputField extends StatelessWidget {
  final void Function(String?) onChange;
  final TextEditingController controller;
  const OpeningHourInputField(
      {super.key, required this.onChange, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      child: CustomField(
        "00:00",
        controller,
        contentPadding: 7,
        length: 5,
        fontSize: 12,
        onChange: onChange,
      ),
    );
  }
}

class OpenHoursDropdownBtn extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const OpenHoursDropdownBtn(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color.fromRGBO(70, 130, 180, 1))),
        alignment: Alignment.center,
        child: Row(
          children: [
            BodyTextPrimaryWithLineHeight(
              text: title,
              fontSize: 12,
            ),
            const SizedBox(
              width: 2,
            ),
            SizedBox(height: 10, width: 10, child: Image.asset(dropdownIcon))
          ],
        ),
      ),
    );
  }
}
