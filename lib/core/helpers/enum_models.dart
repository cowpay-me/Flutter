import 'package:cowpay/core/constants/network/urls_data.dart';
import 'package:flutter/material.dart';

enum CowpayEnvironment { production, staging }

enum LocalizationCode { en, ar }

extension CowpayEnvironmenteExtension on CowpayEnvironment {
  String get baseUrl {
    switch (this) {
      case CowpayEnvironment.production:
        return UrlsData.host_production;
      case CowpayEnvironment.staging:
        return UrlsData.host_staging;
    }
  }
}

enum DialogType { DIALOG_INFO, DIALOG_WARNING, DIALOG_ERROR }

extension DialogTypeExtension on DialogType {
  Color get color {
    switch (this) {
      case DialogType.DIALOG_INFO:
        return Colors.black;
      case DialogType.DIALOG_WARNING:
        return Colors.amber;
      case DialogType.DIALOG_ERROR:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String? get image {
    switch (this) {
      case DialogType.DIALOG_INFO:
        return 'resources/images/info_icon.svg';
      case DialogType.DIALOG_WARNING:
        return 'assets/error.svg';
      case DialogType.DIALOG_ERROR:
        return 'assets/error.svg';
      default:
        return 'resources/images/info_icon.svg';
    }
  }
}

Map<String, String> citiesListEn = {
  "Cairo": "EG-01",
  "Giza & Haram": "EG-01",
  "Downtown Alex": "EG-02",
  "Sahel": "EG-03",
  "Behira": "EG-04",
  "Dakahlia": "EG-05",
  "El Kalioubia": "EG-06",
  "Gharbia": "EG-07",
  "Kafr Alsheikh": "EG-08",
  "Monufia": "EG-09",
  "Sharqia": "EG-10",
  "Isamilia": "EG-11",
  "Suez": "EG-12",
  "Port Said": "EG-13",
  "Damietta": "EG-14",
  "Fayoum": "EG-15",
  "Bani Suif": "EG-16",
  "Asyut": "EG-17",
  "Sohag": "EG-18",
  "Menya": "EG-19",
  "Qena": "EG-20",
  "Aswan": "EG-21",
  "Luxor": "EG-22",
};

Map<String, String> citiesListAr = {
  "القاهرة": "EG-01",
  "الجيزة و الهرم": "EG-01",
  "الاسكندرية": "EG-02",
  "الساحل": "EG-03",
  "البحيرة": "EG-04",
  "الدقهلية": "EG-05",
  "القليوبية": "EG-06",
  "الغربية": "EG-07",
  "كفر الشيخ": "EG-08",
  "المنوفية": "EG-09",
  "الشرقية": "EG-10",
  "الاسماعيلية": "EG-11",
  "السويس": "EG-12",
  "بورسعيد": "EG-13",
  "دمياط": "EG-14",
  "الفيوم": "EG-15",
  "بني سويف": "EG-16",
  "اسيوط": "EG-17",
  "سوهاج": "EG-18",
  "المنيا": "EG-19",
  "قنا": "EG-20",
  "اسوان": "EG-21",
  "الاقصر": "EG-22",
};

Map<String, String> localizationMapEn = {
  "district": "District",
  "address": "Address",
  "floor": "Floor",
  "apartment": "Apartment",
  "city": "City",
  "confirm": "CONFIRM",
  "egp": "EGP",
  "mm": "MM",
  "yy": "YY",
  "cardHolderName": "Card Holder Name",
  "cardNumber": "Card Number",
  "cvv": "CVV",
  "pay": "PAY",
  "paymentMethod": "Payment Method",
  "fawry": "Fawry",
  "creditCard": "Credit Card",
  "fawryPayPlaceholderMessage":
      "Please click Confirm Payment button to generate Reference Number",
  "confirmPayment": "Confirm Payment",
  "copyCode": "Copy Code",
  "paymentSteps": "Payment Steps:",
  "FawrySteps1": "• Go to any Fawry retail store",
  "FawrySteps2": "• Choose Fawry Pay | from the main menu",
  "FawrySteps3": "• Enter the reference number",
  "FawrySteps4": "• Make sure your data is correct",
  "FawrySteps5": "• Pay and keep the receipt",
  "cowpayPaymentOptionsText":
      "Create & Manage Payment Links For Your Business Seamlessly",
  "back": "Back",
  "someThingWentWrong": "Something went wrong, please try again later",
  "ok": "OK",
  "error": "Error"
};

Map<String, String> localizationMapAr = {
  "district": "الحى",
  "address": "العنوان",
  "floor": "الطابق",
  "apartment": "الشقة",
  "city": "المحافظة",
  "confirm": "تأكيد",
  "egp": "جم",
  "mm": "شهر",
  "yy": "سنة",
  "cardHolderName": "اسم حامل البطاقة",
  "cardNumber": "رقم البطاقة",
  "cvv": "رمز التحقق",
  "pay": "ادفع",
  "paymentMethod": "طريقة الدفع",
  "fawry": "فوري",
  "creditCard": "بطاقة ائتمان",
  "fawryPayPlaceholderMessage": "برجاء الضغط على زر الدفع لاستخراج الرقم",
  "confirmPayment": "ادفع",
  "copyCode": "نسخ الكود",
  "paymentSteps": "• خطوات الدفع:",
  "FawrySteps1": "• اذهب الى فرع فوري",
  "FawrySteps2": "• اختر فوري باي من القائمة الرئيسية",
  "FawrySteps3": "• ادخل الرقم الرقم المرجعي",
  "FawrySteps4": "• التأكد من صحة البيانات",
  "FawrySteps5": "• ادفع و احتفظ بالفاتورة",
  "cowpayPaymentOptionsText": "إنشاء وإدارة روابط الدفع لعملك بكل سهولة",
  "back": "رجوع",
  "someThingWentWrong": "حدث خطأ ما ، برجاء المحاولة لاحقا",
  "ok": "حسنا",
  "error": "خطأ"
};
