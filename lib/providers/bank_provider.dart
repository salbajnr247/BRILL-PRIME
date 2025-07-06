import 'dart:io';

import 'package:brill_prime/models/bank_model.dart';
import 'package:brill_prime/models/retrieved_account_model.dart';
import 'package:flutter/material.dart';

import '../resources/constants/connectivity.dart';
import '../services/api_client.dart';

class BankProvider extends ChangeNotifier {
  BankData? selectedBank;
  void updateSelectedBank(BankData? bank) {
    selectedBank = bank;
    notifyListeners();
  }

  void searchForBank(String query) {
    debugPrint("Query=======$query");
    allBanksToDisplay = reservedBanks
        .where((bank) =>
            bank.name.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void resetBankList() {
    allBanksToDisplay = [];
    notifyListeners();
    allBanksToDisplay.addAll(reservedBanks);
    notifyListeners();
  }

  List<BankData> allBanksToDisplay = [];
  List<BankData> reservedBanks = [];
  bool gettingBanks = false;
  Future<bool> getBanks({required BuildContext context}) async {
    if (allBanksToDisplay.isEmpty) {
      gettingBanks = true;
    }
    notifyListeners();
    bool profileFetched = false;
    final connected = await connectionChecker();
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) profileRequestFetched = await ApiClient().getRequest(
              "payment/banks",
              context: context,
              printResponseBody: true,
              requestName: "getBanks");
          gettingBanks = false;
          notifyListeners();
          if (profileRequestFetched.$1) {
            reservedBanks = bankModelFromJson(profileRequestFetched.$2);

            allBanksToDisplay.addAll(reservedBanks);
            profileFetched = true;
          } else {
            gettingBanks = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        resMessage = "Internet connection is not available";
        gettingBanks = false;
        notifyListeners();
      } catch (e) {
        resMessage = "Please try again";
        gettingBanks = false;
        debugPrint("Get User Profile Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      resMessage = "Internet connection is not available";
      gettingBanks = false;
      notifyListeners();
    }
    gettingBanks = false;
    notifyListeners();
    return profileFetched;
  }

  bool verifyingBankAccount = false;
  RetrievedAccountModel? accountRetrieved;
  void resetVerification() {
    verifyingBankAccount = false;
    accountRetrieved = null;
    notifyListeners();
  }

  Future<bool> verifyBankAccount(
      {required BuildContext context,
      required dynamic bankAccount,
      required dynamic bankCode}) async {
    verifyingBankAccount = true;
    accountRetrieved = null;
    notifyListeners();
    bool verified = false;
    final connected = await connectionChecker();

    final body = {"accountNumber": bankAccount, "bankCode": bankCode};
    if (connected) {
      try {
        if (context.mounted) {
          (bool, String) request = await ApiClient().postRequest(
              "payment/verify-account",
              context: context,
              body: body,
              printResponseBody: true,
              requestName: "verifyBankAccount");
          debugPrint("verifyBankAccount Payload::::: $body");
          verifyingBankAccount = false;
          notifyListeners();
          if (request.$1) {
            verified = true;
            accountRetrieved = retrievedAccountModelFromJson(request.$2);
            notifyListeners();
          } else {
            resMessage = request.$2;
            verifyingBankAccount = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        resMessage = "Internet connection is not available";
        notifyListeners();
      } catch (e) {
        resMessage = "Please try again";
        verifyingBankAccount = false;
        debugPrint("Get User Profile Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      resMessage = "Internet connection is not available";
      verifyingBankAccount = false;
      notifyListeners();
    }
    return verified;
  }

  String resMessage = "";

  void clear() {
    resMessage = "";
    notifyListeners();
  }
}
