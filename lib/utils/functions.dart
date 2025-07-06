import 'dart:io';

import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hive_models/biometric_detail_model.dart';
import '../models/hive_models/hive_user_model.dart';
import '../resources/constants/string_constants.dart';
import '../ui/login_option/login_option_screen.dart';
import '../ui/widgets/loading_indicator.dart';
import 'constants.dart';
import 'navigation_util.dart';

String formatDate(String str) {
  DateTime date = DateTime.parse(str);
  return DateFormat().add_yMMMd().add_jm().format(date);
}

String formatCurrency(double num, {String? symbol}) =>
    NumberFormat.currency(symbol: symbol ?? '₦').format(num);

double getFileSize(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  return sizeInMb;
}

double returnPercentAchieved({required double amount, required double total}) {
  double percentAchieved = amount < 1 ? 0 : (amount * 100) / total;
  debugPrint("Percentage achieved:  $percentAchieved");

  return percentAchieved;
}

int returnPercentDiscount(
    {required double sellingPrice, required double discountedPrice}) {
  double discount = sellingPrice - discountedPrice;
  double discountPercent = (discount * 100) / sellingPrice;
  String approximateValue = discountPercent.toStringAsFixed(0);

  return double.parse(approximateValue).toInt();
}

double returnRealAmount({required String amount}) {
  String localAmount = "00";
  if (amount.endsWith("K")) {
    localAmount = amount.replaceAll("K", "000");
  } else if (amount.endsWith("M")) {
    localAmount = amount.replaceAll("M", "000000");
  } else {
    localAmount = amount;
  }
  debugPrint("The local amount is: $localAmount");
  return double.parse(localAmount);
}

// requests storage permission
Future<bool> requestWritePermission() async {
  await Permission.storage.request();
  return await Permission.storage.request().isGranted;
}

String getToken() {
  String token = "";
  if (Hive.box<HiveUserModel>(userBox).isNotEmpty) {
    debugPrint("The token retrieved is:::::$token");
    final hiveUserData = Hive.box<HiveUserModel>(userBox).getAt(0);
    token = hiveUserData?.token ?? "";
    // debugPrint("The token retrieved is:::::$token");
  } else {
    debugPrint("Get Token Method has User data empty ========");
  }
  return token;
}

String getCustomerID() {
  String customerID = "";
  if (Hive.box<HiveUserModel>(userBox).isNotEmpty) {
    debugPrint("The ID retrieved is:::::$customerID");
    final hiveUserData = Hive.box<HiveUserModel>(userBox).getAt(0);
    customerID = hiveUserData?.userId ?? "";
    debugPrint("The customerID retrieved is:::::$customerID");
  } else {
    debugPrint("Get Token Method has User data empty ========");
  }
  return customerID;
}

void copyToClipboard(String info) {
  Clipboard.setData(ClipboardData(text: info));
  Fluttertoast.showToast(msg: "Copied!", backgroundColor: mainColor);
}

Future<void> showAppLoader(BuildContext context,
    {bool barrierDismissible = false, String message = "Loading..."}) async {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => HashITLoadingIndicator(
            message: message,
          ));
}

String replaceCharAt(String oldString, dynamic index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

File? snapshot;
XFile? xFile;
final ImagePicker _picker = ImagePicker();

Future<File?> handleChooseFromGallery(BuildContext context) async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
  );
  if (pickedFile != null) {
    final imageSize = (await File(pickedFile.path).readAsBytes()).length;
    double fileSize = imageSize / 1048576;
    debugPrint("Image Size: $fileSize");
    if (fileSize > 5) {
    } else {
      xFile = pickedFile;
      snapshot = File(pickedFile.path);
    }
  }
  return snapshot;
}

Future<File?> handleFileUpload({required BuildContext context}) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.media);
  return result == null ? null : File(result.files.single.path!);
}

String returnFileName({required File file}) {
  String fileName = file.path.split('/').last;
  return fileName;
}

//This function pops out screen according to the type of routing used
void popLoader({required BuildContext context, bool isGoRouterScreen = true}) {
  if (isGoRouterScreen) {
    Navigator.pop(context);
  } else {
    Navigator.pop(context);
  }
}

// LOG Out User
Future<bool> logoutAndClearHive({
  required BuildContext context,
}) async {
  final sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString(savedSharedPrefPassword, "");
  sharedPref.setString(savedSharedPrefEmail, "");
  sharedPref.setString(savedSharedPrefUserID, "");
  bool isLogout = false;
  await Hive.box<HiveUserModel>(userBox)
      .deleteAll(Hive.box<HiveUserModel>(userBox).keys);
  isLogout = true;
  if (context.mounted && isLogout) {
    navToWithScreenName(
        context: context,
        screen: const LoginOptionScreen(),
        isPushAndRemoveUntil: true);
  }
  return isLogout;
}

Future<void> clearHiveData() async {
  final sharedPref = await SharedPreferences.getInstance();
  sharedPref.setString(savedSharedPrefPassword, "");
  sharedPref.setString(savedSharedPrefEmail, "");
  sharedPref.setString(savedSharedPrefUserID, "");
  await Hive.box<HiveUserModel>(userBox)
      .deleteAll(Hive.box<HiveUserModel>(userBox).keys);
  await Hive.box<HiveBiometricModel>(biometricBox)
      .deleteAll(Hive.box<HiveBiometricModel>(biometricBox).keys);

  debugPrint("==================Data CLEARED=================");
}

int returnKycTier({required dynamic kycTier}) {
  debugPrint(
      "KYC Level::: ${kycTier == null ? 0 : int.parse(kycTier.toString().replaceAll("t", ""))}");
  return kycTier == null
      ? 0
      : int.parse(kycTier.toString().replaceAll("t", ""));
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_.]).{8,}$')
        .hasMatch(this);
  }
}

bool isInsufficientBalance({required String balance, required String amount}) {
  debugPrint("Balance: $balance : Amount $amount");
  return double.parse(amount) > double.parse(balance);
}

Future<int> getBackgroundAndResumeTimeDifference(
    DateTime backgroundTime) async {
  final date2 = DateTime.now();
  debugPrint('Time Saved in background ${backgroundTime.toString()}');
  debugPrint(
      "Time difference in minute ${date2.difference(backgroundTime).inMinutes}");
  return date2.difference(backgroundTime).inMinutes;
}

String returnBillAmount(String amount) {
  return (double.parse(amount) / 100).toStringAsFixed(0);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String returnFormattedAmount({required String amount}) {
  // debugPrint("Amount to format  $amount");
  String thisAmount = amount.replaceAll(",", "");
  // debugPrint("Trimmed Amount::: $thisAmount");
  return double.parse(thisAmount) >= 100
      ? moneyFormat.format(double.parse(thisAmount))
      : double.parse(thisAmount).toStringAsFixed(2);
}

String returnFormattedDate(String date) {
  final convertedDate = DateTime.parse(date);
  String newDate =
      "${convertedDate.day}, ${convertedDate.month}, ${convertedDate.year}";
  return Jiffy.parseFromDateTime(DateTime.parse(date)).yMMMMd;
}

String returnFormattedDateAndTime(String date) {
  final convertedDate = DateTime.parse(date);
  String newDate =
      "${convertedDate.day}, ${convertedDate.month}, ${convertedDate.year}";
  return Jiffy.parseFromDateTime(DateTime.parse(date)).yMMMdjm;
}

String maskAccountNumberString(String input) {
  if (input.length != 10) {
    return "Invalid String";
  }
  return '${input.substring(0, 4)}****${input.substring(8)}';
}

String getFirstCharactersAsWord(String sentence) {
  return sentence
      .split(' ') // Split by spaces
      .where((word) => word.isNotEmpty) // Remove empty words
      .map((word) => word[0]) // Get the first character of each word
      .join(); // Join them into a single string
}

String returnFormattedAmountWithCurrency(
    {required dynamic amount, String currency = nairaSign}) {
  debugPrint("Amount to format  $amount");
  String thisAmount = amount.toString().replaceAll(",", "");
  debugPrint("Trimmed Amount::: $thisAmount");
  final nairaFormatter =
      NumberFormat.currency(locale: 'en_NG', symbol: currency);
  String formattedAmount =
      nairaFormatter.format(double.parse(thisAmount.toString()));
  return formattedAmount;
}

String getFirstWordInSentence(String sentence) {
  if (sentence.trim().isEmpty) return ""; // Handle empty string
  return sentence.trim().split(" ").first;
}
