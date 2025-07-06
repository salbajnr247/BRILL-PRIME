import 'package:brill_prime/providers/bank_provider.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_profile_screen.dart';
import 'package:brill_prime/ui/widgets/bank_list_modal.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class AddBankAccountScreen extends StatefulWidget {
  final String accountNumber;
  const AddBankAccountScreen({super.key, this.accountNumber = ""});
  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final accountNumberController = TextEditingController();

  @override
  void initState() {
    accountNumberController.text = widget.accountNumber;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer2<AuthProvider, BankProvider>(
              builder: (ctx, authProvider, bankProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (bankProvider.resMessage != '' ||
                  authProvider.resMessage != "") {
                customSnackBar(
                    context,
                    bankProvider.resMessage.isEmpty
                        ? authProvider.resMessage
                        : bankProvider.resMessage);

                ///Clear the response message to avoid duplicate
                bankProvider.clear();
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
                  text: "Add New Bank Details",
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
                        const SizedBox(
                          height: 30,
                        ),
                        const Label(title: "Bank"),
                        CustomDropdownButton(
                            title: bankProvider.selectedBank?.name ?? "Bank",
                            textColor: bankProvider.selectedBank != null
                                ? black
                                : hintTextColor,
                            fontWeight: mediumFont,
                            onTap: () async {
                              bankProvider.resetBankList();
                              showBankListModal(context);
                            }),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Account Number"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "1234567890",
                                accountNumberController,
                                isCapitalizeSentence: false,
                                onChange: (value) {
                                  if (value != null && value.length == 10) {
                                    if (bankProvider.selectedBank != null) {
                                      bankProvider.verifyBankAccount(
                                          context: context,
                                          bankAccount: value,
                                          bankCode:
                                              bankProvider.selectedBank?.code ??
                                                  '');
                                    } else {
                                      customSnackBar(context, "Select Bank");
                                    }
                                  } else {
                                    bankProvider.resetVerification();
                                  }
                                },
                                // 0690000032
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
                        BodyTextPrimaryWithLineHeight(
                            text: bankProvider.accountRetrieved?.accountName ??
                                ""),
                      ],
                    ),
                  ),
                ),
                authProvider.onboardingVendor
                    ? const Center(child: CupertinoActivityIndicator())
                    : Center(
                        child: SizedBox(
                          width: 200,
                          child: authProvider.addingBankAccount ||
                                  bankProvider.verifyingBankAccount
                              ? const Center(
                                  child: CupertinoActivityIndicator())
                              : MainButton(
                                  "Save",
                                  fontWeight: mediumFont,
                                  () async {
                                    if (bankProvider.accountRetrieved != null) {
                                      bool accountAdded = await authProvider
                                          .addBankAccount(
                                              context: context,
                                              accountName: bankProvider
                                                  .accountRetrieved
                                                  ?.accountName,
                                              bankName: bankProvider
                                                  .selectedBank?.name,
                                              accountNumber: bankProvider
                                                  .accountRetrieved
                                                  ?.accountNumber,
                                              bankCode: bankProvider
                                                  .selectedBank?.code);

                                      if (accountAdded) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  },
                                  color: const Color.fromRGBO(11, 26, 81, 1),
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
