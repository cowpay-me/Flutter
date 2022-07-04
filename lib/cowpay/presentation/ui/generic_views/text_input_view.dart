import 'package:cowpay/core/helpers/screen_size.dart';
import 'package:cowpay/cowpay/presentation/ui/generic_views/text_input_error_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextInputView extends StatelessWidget {
  final void Function(BuildContext, String)? onChange;
  final void Function(
    BuildContext,
  )? onHelpChange;
  final BuildContext? mainContext;
  final bool? obscureText, isNotValid, showHelp, showHelpIcon, enabled;
  final int maxLength;
  final String? image, hintText, errorMessage, helpText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final String? initialValue;
  final String? suffixIcon;
  final TextEditingController? controller;
  final Function(BuildContext)? onFieldSubmitted;
  final double? width, height;
  final InputDecoration? inputDecoration;
  final TextStyle? style;
  final Color? mainColor;

  const TextInputView(
      {/*Key key,*/
      this.onChange,
      this.onFieldSubmitted,
      this.onHelpChange,
      this.mainContext,
      this.height,
      this.obscureText = false,
      this.image,
      this.hintText,
      this.isNotValid,
      this.textInputType,
      this.mainColor,
      this.textInputAction,
      this.errorMessage,
      this.currentFocus,
      this.showHelp,
      this.nextFocus,
      this.helpText,
      this.enabled = true,
      this.maxLength = 50,
      this.initialValue,
      this.showHelpIcon = false,
      this.suffixIcon,
      this.controller,
      this.style,
      this.inputDecoration,
      this.width})
      : super(/*key: key*/);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextFormField(context),
        if (errorMessage != null && isNotValid!)
          TextInputErrorView(
            errorMessage: errorMessage,
          ),
      ],
    );
  }

  Container buildHelpText() {
    return Container(
      margin: EdgeInsetsDirectional.only(top: (0.007.sh)),
      padding:
          EdgeInsets.symmetric(horizontal: (0.02.sw), vertical: (0.007.sh)),
      width: width ?? 1.sw,
      height: height ?? 45.sp,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7.sp)),
          color: Colors.black),
      child: Text(
        helpText!,
        style: TextStyle(height: 1.3),
      ),
    );
  }

  Widget buildTextFormField(BuildContext context) {
    return Container(
      height: height ?? 45.sp,
      child: TextFormField(
        key: key,
        initialValue: initialValue ?? null,
        onChanged: (value) => onChange!(mainContext!, value),
        maxLength: maxLength,
        controller: controller,
        enabled: enabled,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        obscureText: obscureText!,
        focusNode: currentFocus,
        onFieldSubmitted: (_) {
          onFieldSubmitted!(mainContext!);
        },
        style: style ??
            TextStyle(color: mainColor ?? Colors.black, fontSize: 14.sp),
        decoration: inputDecoration ??
            InputDecoration(
              contentPadding: inputDecoration?.contentPadding ??
                  EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
              counterText: '',
              prefixIcon: image != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 45.sp,
                          height: 45.sp,
                          child: Image(
                            image: AssetImage('resources/images/$image.png'),
                            color: enabled!
                                ? isNotValid!
                                    ? Colors.red
                                    : Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 45.sp,
                          height: 45.sp,
                          child: SvgPicture.asset(
                            "assets/$suffixIcon.svg",
                            package: 'cowpay',
                            color: enabled!
                                ? isNotValid!
                                    ? Colors.red
                                    : mainColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : null,
              hintText: hintText!,
              labelText: hintText!,
              isDense: inputDecoration?.isDense ?? false,
              hintStyle: inputDecoration?.hintStyle ??
                  TextStyle(
                      color: mainColor?.withOpacity(0.4) ?? Color(0x9066496A),
                      fontSize: 14.sp),
              labelStyle: inputDecoration?.labelStyle ??
                  TextStyle(
                      color: mainColor?.withOpacity(0.4) ?? Color(0x9066496A),
                      fontSize: 14.sp),
              focusedBorder: inputDecoration?.focusedBorder ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isNotValid!
                            ? Colors.red
                            : mainColor ?? Color(0xff3D1A54),
                        width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  ),
              enabledBorder: inputDecoration?.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        color: isNotValid!
                            ? Colors.red
                            : mainColor?.withOpacity(0.3) ?? Color(0x3066496A),
                        width: 1.0),
                  ),
              disabledBorder: inputDecoration?.disabledBorder ?? buildBorder(),
            ),
        keyboardType: textInputType,
        textInputAction: textInputAction,
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: isNotValid! ? Colors.red : Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.sp)));
  }
}
