import 'dart:math';

import 'package:cowpay/cowpay.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CowpayExample extends StatelessWidget {
  //Transaction Data
  double amount = 2.0;
  String customerEmail = "flutter@mail.com";
  String customerMobile = "01068890002";
  String description = "description";
  String customerMerchantProfileId = "ExmpleId122345681";
  String customerName = "Testing";

  //Merchant data
  String token = "token";
  String merchantCode = "merchantCode";
  String merchantHash = "merchantHash";

  @override
  Widget build(BuildContext context) {
    return Cowpay(
      localizationCode: LocalizationCode.en,
      amount: amount,
      customerEmail: customerEmail,
      customerMobile: customerMobile,
      customerName: customerName,
      description: description,
      customerMerchantProfileId: customerMerchantProfileId,
      merchantReferenceId: getRandString(),
      activeEnvironment: CowpayEnvironment.production,
      merchantCode: merchantCode,
      merchantHash: merchantHash,
      token: token,
      onCreditCardSuccess: (val) {
        debugPrint(val.cowpayReferenceId);
      },
      onError: (val) {
        debugPrint(val.toString());
      },
      onClosedByUser: () {
        debugPrint("closedByUser");
      },
      onFawrySuccess: (val) {
        debugPrint(val.paymentGatewayReferenceId);
      },
    );
  }

  String getRandString() {
    Random random = new Random();
    int randomNumber = random.nextInt(9000) + 1000;
    return randomNumber.toString();
  }
}
