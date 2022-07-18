import 'package:cowpay/core/helpers/enum_models.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/localization.dart';
import 'dialog_view.dart';

class ErrorAlertView {
  final BuildContext context;
  final String content;
  final DialogType dialogType;

  ErrorAlertView(
      {required this.context, required this.content, required this.dialogType});

  Future<void> ackAlert() {
    // debugPrint('Error Message:  $content');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogView(
            dialogType: dialogType,
            actionText: Localization().localizationMap["ok"],
            title: content,
            // content: content,
            onCLick: (_) {
              //TODO: do onSuccess
              // Navigator.of(context).pop();
            },
            mainContext: context,
            // title: 'Success',
          );
        });
  }
}
