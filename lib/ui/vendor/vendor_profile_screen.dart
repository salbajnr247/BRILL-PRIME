import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/user_profile_picture_widget.dart';
import 'package:brill_prime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/string_constants.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});
  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      usernameController.text = authProvider.userProfile?.data.fullName ?? "";
      emailController.text = authProvider.userProfile?.data.email ?? "";
      phoneController.text = authProvider.userProfile?.data.phone ?? "";
      locationController.text =
          authProvider.userProfile?.data.vendor?.address ?? "";

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (authProvider.resMessage != '') {
                customSnackBar(context, authProvider.resMessage);

                ///Clear the response message to avoid duplicate
                authProvider.clear();
              }
            });
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppbar(title: ""),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: UserProfilePictureWidget(
                          dimension: 100,
                              onTap: (){},
                        )),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  const Label(title: username),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Full Name",
                          usernameController,
                          isCapitalizeSentence: true,
                          type: TextInputType.name,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  const Label(title: "Email"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Email",
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
                          "+234 8000 0000 00 ",
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
                  const Label(title: "Location"),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Jahi, Abuja",
                          locationController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  authProvider.updatingUserProfile
                      ? const Center(child: CupertinoActivityIndicator())
                      : Center(
                          child: SizedBox(
                            width: 200,
                            child: MainButton(
                              isEditing ? "Save" : "Edit",
                              fontWeight: mediumFont,
                              () async {
                                if (isEditing) {
                                  if (usernameController.text.trim().length <
                                      5) {
                                    customSnackBar(
                                        context, "Enter a valid full name");
                                  } else if (emailController.text.length < 4) {
                                    customSnackBar(
                                      context,
                                      "Please enter a valid email",
                                    );
                                  } else if (phoneController.text
                                          .trim()
                                          .length <
                                      10) {
                                    customSnackBar(context,
                                        "Provide a valid phone number");
                                  } else if (locationController.text.length <
                                      3) {
                                    customSnackBar(
                                        context, "Provide a valid address");
                                  } else {
                                    bool profileUpdated =
                                        await authProvider.updateUserProfile(
                                            context: context,
                                            fullName: usernameController.text,
                                            email: emailController.text,
                                            phone: phoneController.text,
                                            location: locationController.text,
                                            imageURL: "");

                                    if (profileUpdated) {
                                      setState(() {
                                        isEditing = !isEditing;
                                      });
                                      authProvider.getProfile(context: context);
                                    }
                                  }
                                } else {
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 8.h,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          })),
    );
  }
}

class Label extends StatelessWidget {
  final String title;
  const Label({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: BodyTextPrimaryWithLineHeight(
            text: title,
            fontWeight: boldFont,
            textColor: black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final success = await context.read<AuthProvider>().updateVendorProfile(
          context: context,
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          location: _locationController.text.trim(),
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields correctly'), backgroundColor: Colors.orange),
      );
    }
  }
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }
