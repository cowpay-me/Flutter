import 'package:cowpay/core/helpers/enum_models.dart';
import 'package:cowpay/core/helpers/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//TODO check localizations

class DialogView extends StatelessWidget {
  final String? content;
  final String? actionText;
  final String? cancelText;
  final void Function(BuildContext)? onCLick, extraOnCancel;
  final BuildContext mainContext;
  final DialogType dialogType;
  final String? image;
  final String? title;

  const DialogView(
      {Key? key,
      this.content,
      this.actionText,
      this.image,
      this.onCLick,
      required this.mainContext,
      required this.dialogType,
      this.extraOnCancel,
      this.title,
      this.cancelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: buildContent(context),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.04.sh),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image != null
              ? Container(
                  height: 0.1.sh,
                  width: 0.1.sh,
                  child: Image.asset(
                    "$image",
                    package: 'cowpay',
                    height: 0.1.sh,
                    width: 0.1.sh,
                  ))
              : dialogType.image != null
                  ? Container(
                      height: 0.1.sh,
                      width: 0.1.sh,
                      child: SvgPicture.asset(
                        dialogType.image ?? '',
                        package: 'cowpay',
                        width: 0.1.sh,
                        height: 0.1.sh,
                      ),
                    )
                  : Container(height: 0.1.sh, width: 0.1.sw),
          SizedBox(
            height: 0.015.sh,
          ),
          Text(
            title ?? 'Title',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xff808080),
                height: 1.4,
                // fontWeight: FontWeight.bold,
                fontSize: 22),
            textScaleFactor: 0.8,
          ),
          SizedBox(
            height: 0.02.sh,
          ),
          if (content != null)
            Column(
              children: [
                Text(
                  content ?? '',
                  textAlign: dialogType == DialogType.DIALOG_WARNING
                      ? TextAlign.start
                      : TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff808080),
                    height: 1.2,
                  ),
                  textScaleFactor: 0.8,
                ),
                SizedBox(
                  height: 0.015.sh,
                ),
              ],
            ),
          if (actionText != null)
            Column(
              children: [
                Row(
                  mainAxisAlignment: cancelText != null
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
                  children: [
                    if (cancelText != null) buildInkWellCancel(context),
                    SizedBox(
                      width: 10,
                    ),
                    if (actionText != null) buildInkWellActionClick(context),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  InkWell buildInkWellActionClick(BuildContext context) {
    return InkWell(
      onTap: () => callCallaBack(context),
      child: Container(
        height: 0.05.sh,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 65),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xff3D1A54).withOpacity(0.8)),
        child: Center(
          child: Text(
            actionText!,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }

  InkWell buildInkWellCancel(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.red),
        child: Text(
          'cancel',
          style: TextStyle(color: dialogType.color),
          textScaleFactor: 0.7,
        ),
      ),
    );
  }

  void callCallaBack(BuildContext context) {
    Navigator.pop(context);
    onCLick!(mainContext);
  }

  void cancelClick(BuildContext context) {
    Navigator.pop(context);
    onCLick!(mainContext);
  }

  static Future<void> dialog(
    BuildContext _context,
    String content,
    String title,
    DialogType dialogType, {
    String? actionText,
    String cancelText = 'cancel',
    void Function(BuildContext)? onCLick,
    bool barrierDismissible = true,
    void Function(BuildContext)? extraOnCancel,
  }) {
    debugPrint('Error Message:  $content');
    return showDialog(
        barrierDismissible: barrierDismissible,
        context: _context,
        builder: (BuildContext context) {
          return DialogView(
            dialogType: dialogType,
            content: content,
            title: title,
            mainContext: _context,
            actionText: actionText!,
            extraOnCancel: extraOnCancel,
            onCLick: onCLick,
            cancelText: cancelText,
          );
        });
  }
}
