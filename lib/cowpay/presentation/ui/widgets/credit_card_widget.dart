library cowpay;

import 'package:cowpay/core/formz_models/credit_card_cvv.dart';
import 'package:cowpay/core/formz_models/credit_card_holder_name.dart';
import 'package:cowpay/core/formz_models/credit_card_number.dart';
import 'package:cowpay/core/helpers/localization.dart';
import 'package:cowpay/core/helpers/screen_size.dart';
import 'package:cowpay/cowpay/presentation/bloc/cowpay_bloc.dart';
import 'package:cowpay/cowpay/presentation/ui/generic_views/drop_down_view.dart';
import 'package:cowpay/cowpay/presentation/ui/generic_views/text_input_error_view.dart';
import 'package:cowpay/cowpay/presentation/ui/generic_views/text_input_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreditCardWidget extends StatelessWidget {
  final TextStyle? textFieldStyle;
  final InputDecoration? textFieldInputDecoration;

  CreditCardWidget({
    this.textFieldStyle,
    this.textFieldInputDecoration,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.05)),
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _buildCardHolderName(),
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    _buildCardNumberTextField(),
                    SizedBox(
                      height: 0.025.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      // width: ScreenSize().width! * 0.365,
                                      child: _buildDropDownExpiryMonth(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.012.sw,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      // width: ScreenSize().width! * 0.365,
                                      child: _buildDropDownExpiryYear(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 0.025.sw,
                        ),
                        Expanded(
                          flex: 3,
                          child: _buildCvvTextField(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHolderName() {
    return BlocBuilder<CowpayBloc, CowpayState>(
      buildWhen: (previous, current) =>
          previous.creditCardHolderName != current.creditCardHolderName ||
          previous.status != current.status,
      builder: (context, state) {
        bool isNotValid =
            state.creditCardHolderName.invalid && state.status.isInvalid;
        return TextInputView(
          style: textFieldStyle,
          inputDecoration: textFieldInputDecoration,
          mainContext: context,
          isNotValid: isNotValid,
          obscureText: false,
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.text,
          hintText: Localization().localizationMap["cardHolderName"],
          onChange: onChangeCreditCardHolderName,
          // currentFocus: currentNode,
          // nextFocus: nextNode,
          errorMessage: state.creditCardHolderName.error?.message,
        );
      },
    );
  }

  void onChangeCreditCardHolderName(BuildContext context, String value) {
    context.read<CowpayBloc>().add(CreditCardNameChange(value));
  }

  Widget _buildCardNumberTextField() {
    return BlocBuilder<CowpayBloc, CowpayState>(
      buildWhen: (previous, current) =>
          previous.creditCardNumber != current.creditCardNumber ||
          previous.status != current.status,
      builder: (context, state) {
        bool isNotValid =
            state.creditCardNumber.invalid && state.status.isInvalid;
        return TextInputView(
          style: textFieldStyle,
          inputDecoration: textFieldInputDecoration,
          mainContext: context,
          isNotValid: isNotValid,
          obscureText: false,
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.number,
          maxLength: 16,
          hintText: Localization().localizationMap["cardNumber"],
          onChange: onChangeCreditCardNumber,
          errorMessage: state.creditCardNumber.error?.message,
        );
      },
    );
  }

  void onChangeCreditCardNumber(BuildContext context, String value) {
    context.read<CowpayBloc>().add(CreditCardNumberChange(value));
  }

  Widget _buildCvvTextField() {
    return BlocBuilder<CowpayBloc, CowpayState>(
      buildWhen: (previous, current) =>
          previous.creditCardCvv != current.creditCardCvv ||
          previous.status != current.status,
      builder: (context, state) {
        bool isNotValid = state.creditCardCvv.invalid && state.status.isInvalid;
        return TextInputView(
          suffixIcon: "cvv",
          inputDecoration: textFieldInputDecoration,
          style: textFieldStyle,
          mainContext: context,
          isNotValid: isNotValid,
          onFieldSubmitted: (_) {
            onClickSubmit(context);
          },
          width: 0.4.sw,
          obscureText: false,
          textInputAction: TextInputAction.next,
          textInputType: TextInputType.number,
          maxLength: 3,
          hintText: Localization().localizationMap["cvv"],
          onChange: onChangeCreditCardCvv,
          errorMessage: state.creditCardCvv.error?.message,
        );
      },
    );
  }

  void onChangeCreditCardCvv(BuildContext context, String value) {
    context.read<CowpayBloc>().add(CreditCardCvvChange(value));
  }

  void onClickSubmit(
    BuildContext context,
  ) {
    // context.read<CowpayBloc>().add(ChargeValidation(context));
  }

  _buildDropDownExpiryMonth() {
    return BlocBuilder<CowpayBloc, CowpayState>(
        buildWhen: (previous, current) =>
            previous.creditCardExpiryMonth != current.creditCardExpiryMonth ||
            previous.status != current.status,
        builder: (context, state) {
          bool isInValid =
              state.creditCardExpiryMonth.value == '' && state.checkValidation;
          return DropDownView(
            list: [
              "01",
              "02",
              "03",
              "04",
              "05",
              "06",
              "07",
              "08",
              "09",
              "10",
              "11",
              "12"
            ],
            onChange: onChangeCreditCardExpiryMonth,
            isNotValid: isInValid,
            hintText: Localization().localizationMap["mm"],
            value: state.creditCardExpiryMonth.value,
          );
        });
  }

  void onChangeCreditCardExpiryMonth(BuildContext context, String? value) {
    if (value != null) {
      context.read<CowpayBloc>().add(CreditCardExpiryMonthChange(value));
    }
  }

  _buildDropDownExpiryYear() {
    return BlocBuilder<CowpayBloc, CowpayState>(
        buildWhen: (previous, current) =>
            previous.creditCardExpiryYear != current.creditCardExpiryYear ||
            previous.yearsList != current.yearsList ||
            previous.status != current.status,
        builder: (context, state) {
          bool isInValid =
              state.creditCardExpiryYear.value == '' && state.checkValidation;
          return DropDownView(
            list: state.yearsList ?? [],
            onChange: onChangeCreditCardExpiryYear,
            isNotValid: isInValid,
            hintText: Localization().localizationMap["yy"],
            value: state.creditCardExpiryYear.value,
          );
        });
  }

  void onChangeCreditCardExpiryYear(BuildContext context, String? value) {
    if (value != null) {
      context.read<CowpayBloc>().add(CreditCardExpiryYearChange(value));
    }
  }
}

Widget buildExpiryError() {
  return BlocBuilder<CowpayBloc, CowpayState>(
      buildWhen: (previous, current) =>
          previous.creditCardExpiryMonth != current.creditCardExpiryMonth ||
          previous.status != current.status ||
          previous.creditCardExpiryYear != current.creditCardExpiryYear ||
          previous.isNotValidExpirationDate != current.isNotValidExpirationDate,
      builder: (context, state) {
        bool isNotValid = (state.creditCardExpiryMonth.invalid ||
                state.creditCardExpiryYear.invalid ||
                state.isNotValidExpirationDate) &&
            state.checkValidation;
        return isNotValid
            ? TextInputErrorView(
                errorMessage: "Expiration Error",
              )
            : SizedBox();
      });
}

class _ScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
