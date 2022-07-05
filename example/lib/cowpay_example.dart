import 'dart:math';

import 'package:cowpay/cowpay.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CowpayExample extends StatelessWidget {
  double amount = 2.0;
  String customerEmail = "example@mail.com";
  String customerMobile = "01068890002";
  String description = "description";
  String customerMerchantProfileId = "ExmpleId122345682";
  String customerName = "Testing";
  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTI2ZmM1YzNmMTU4MmNlY2RhNTUyOTNiYzcyMTdhZGFlZTE3OTk2YjgxMDlhNTUxNGY1OGNiMjc1ZmRlMzdlNDZhOTRiOWM2NzY4ZWFjNGUiLCJpYXQiOjE2NTI4ODQ3NDguNzg1Nzc3LCJuYmYiOjE2NTI4ODQ3NDguNzg1Nzg0LCJleHAiOjQ4MDg1NTgzNDguNzA0MTc1LCJzdWIiOiI4OTAiLCJzY29wZXMiOltdfQ.M6F7sUxAx8aEd6y963KEBnFkybmhbdbAaWByKfTvbKGWUMH7QgUsMWrnhVWBLqXDZctWdt6UFvi606WUNJiSmA";
  String merchantCode = "Bi0InJ1bp5gh";
  String merchantHash =
      "\$2y\$10\$06g0SeTNKoFD0SU1aKcO9.ProYRS4.mk8gyUW82VUJ2KKwtiNb30G";
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
      activeEnvironment: CowpayEnvironment.staging,
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
