library cowpay;

import 'package:api_manager/api_manager.dart';
import 'package:api_manager/failures.dart';
import 'package:cowpay/core/helpers/cowpay_helper.dart';
import 'package:cowpay/cowpay/data/models/fawry_success_model.dart';
import 'package:cowpay/cowpay/data/models/payload_model.dart';
import 'package:cowpay/cowpay/domain/entities/fawry_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

import 'core/helpers/localization.dart';
import 'core/helpers/screen_size.dart';
import 'cowpay/data/models/card_success_model.dart';
import 'cowpay/presentation/bloc/cowpay_bloc.dart';
import 'cowpay/presentation/ui/generic_views/button_loading_view.dart';
import 'cowpay/presentation/ui/generic_views/button_view.dart';
import 'cowpay/presentation/ui/generic_views/cowpay_payment_option_card.dart';
import 'cowpay/presentation/ui/generic_views/error_alert_view.dart';
import 'cowpay/presentation/ui/screens/fawry_screen.dart';
import 'cowpay/presentation/ui/screens/web_view_screen.dart';
import 'cowpay/presentation/ui/widgets/credit_card_widget.dart';
import 'cowpay/presentation/ui/widgets/fawry_widget.dart';
import 'injection_container.dart';

export 'package:cowpay/core/helpers/enum_models.dart';

export 'cowpay/data/models/card_success_model.dart';

class Cowpay extends StatefulWidget {
  Cowpay({
    Key? key,
    required this.description,
    required this.merchantReferenceId,
    required this.customerMerchantProfileId,
    required this.customerEmail,
    required this.customerMobile,
    required this.activeEnvironment,
    required this.amount,
    required this.customerName,
    required this.token,
    required this.merchantCode,
    required this.merchantHash,
    this.height,
    this.buttonColor,
    this.buttonTextColor,
    this.mainColor,
    this.buttonTextStyle,
    this.textFieldStyle,
    this.textFieldInputDecoration,
    this.localizationCode,
    required this.onCreditCardSuccess,
    required this.onFawrySuccess,
    required this.onError,
    required this.onClosedByUser,
  }) : super(key: key);

  final String description, merchantReferenceId, customerMerchantProfileId;

  final String customerEmail, customerName;

  final String merchantCode;
  final String merchantHash;
  final String token;
  final String customerMobile;
  final CowpayEnvironment activeEnvironment;
  final double amount;
  final double? height;
  final Color? /*backGroundColor,*/ /*cardColor,*/ buttonColor,
      buttonTextColor,
      mainColor;
  final TextStyle? buttonTextStyle, textFieldStyle;
  final InputDecoration? textFieldInputDecoration;
  final LocalizationCode? localizationCode;
  final Function(CreditCardSuccessModel cardSuccessModel) onCreditCardSuccess;
  final Function(FawrySuccessModel fawrySuccessModel) onFawrySuccess;
  final Function onClosedByUser;
  final Function(dynamic error) onError;

  @override
  State<Cowpay> createState() => _CowpayState();
}

class _CowpayState extends State<Cowpay> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    initDependencyInjection();

    CowpayHelper.instance.init(
      cowpayEnvironment: widget.activeEnvironment,
      token: widget.token,
      merchantCode: widget.merchantCode,
      merchantHash: widget.merchantHash,
    );
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().height = MediaQuery.of(context).size.height;
    ScreenUtil().width = MediaQuery.of(context).size.width;

    if (widget.localizationCode == LocalizationCode.ar) {
      Localization().localizationMap = localizationMapAr;
      Localization().localizationCode = LocalizationCode.ar;
    }
    Future<bool> _willPopCallback() async {
      widget.onClosedByUser();
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Directionality(
        textDirection: widget.localizationCode == LocalizationCode.ar
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 0.1.sh,
            title: Text(Localization().localizationMap["paymentMethod"]),
            backgroundColor: Color(0xff3D1A54),
          ),
          body: DefaultTabController(
            length: 2,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<CowpayBloc>(
                  create: (context) {
                    return di<CowpayBloc>()
                      ..add(CowpayStarted(
                          merchantReferenceId: widget.merchantReferenceId,
                          customerMerchantProfileId:
                              widget.customerMerchantProfileId,
                          amount: widget.amount.toString(),
                          customerEmail: widget.customerEmail,
                          customerMobile: widget.customerMobile,
                          customerName: widget.customerName,
                          description: widget.description));
                  },
                ),
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<CowpayBloc, CowpayState>(
                    listenWhen: (prev, state) {
                      return prev.status != state.status;
                    },
                    listener: (context, state) {},
                  ),
                  BlocListener<CowpayBloc, CowpayState>(
                    listenWhen: (prev, state) {
                      return prev.failure != state.failure;
                    },
                    listener: (context, state) {
                      final failure = state.failure;
                      if (failure is ErrorFailure) {
                        final error = failure.error;
                        if (error is MessageResponse) {
                          ErrorAlertView alertView = ErrorAlertView(
                              context: context,
                              content: error.message,
                              dialogType: DialogType.DIALOG_WARNING);
                          alertView.ackAlert();
                        }
                      } else if (failure != null) {
                        ErrorAlertView alertView = ErrorAlertView(
                            context: context,
                            content: Localization().localizationMap["error"],
                            dialogType: DialogType.DIALOG_WARNING);
                        alertView.ackAlert();
                      }
                    },
                  ),
                ],
                child: Column(
                  children: [
                    _buildTabBar(),
                    Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            CreditCardWidget(
                              textFieldStyle: widget.textFieldStyle,
                              textFieldInputDecoration:
                                  widget.textFieldInputDecoration,
                            ),
                            FawryWidget(),
                          ]),
                    ),
                    Container(
                      height: 0.26.sh,
                      padding: EdgeInsets.symmetric(horizontal: 0.04.sw),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CowpayPaymentOptionsCard(),
                          Container(
                            height: 0.07.sh,
                            margin: EdgeInsets.symmetric(vertical: 0.01.sh),
                            child: _ChargeButton(
                              buttonColor: Color(0xff3D1A54),
                              buttonTextColor: widget.buttonTextColor,
                              buttonTextStyle: widget.buttonTextStyle,
                              onCreditCardSuccess: (val) =>
                                  widget.onCreditCardSuccess(val),
                              onError: (error) => widget.onError(error),
                              onClosedByUser: widget.onClosedByUser,
                              onFawrySuccess: widget.onFawrySuccess,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return BlocBuilder<CowpayBloc, CowpayState>(
        buildWhen: (previous, current) =>
            previous.tabCurrentIndex != current.tabCurrentIndex,
        builder: (context, state) {
          return Container(
              width: 1.sw,
              height: 0.15.sh,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (0.01.sw),
                  ),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        2,
                        (index) => _buildTabCard(
                            state.tabCurrentIndex, index, context),
                      ))));
        });
  }

  Widget _buildTabCard(int currentIndex, int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child: GestureDetector(
        onTap: () {
          if (currentIndex != index) {
            context.read<CowpayBloc>().add(ChangeTabCurrentIndexEvent(index));

            _tabController.animateTo(index);
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: Container(
            width: (0.22.sw),
            decoration: BoxDecoration(
                border: Border.all(
                    width: currentIndex == index ? 2 : 1,
                    color: currentIndex == index
                        ? Color(0xff3D1A54)
                        : Colors.grey),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.sp)),
            child: Container(
              alignment: AlignmentDirectional.center,
              padding: EdgeInsets.all(5.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 25.sp,
                    width: 25.sp,
                    child: SvgPicture.asset(
                      index == 0
                          ? "assets/credit-card-svgrepo-com.svg"
                          : "assets/combined-shape.svg",
                      package: 'cowpay',
                      fit: BoxFit.fill,
                      color: currentIndex == index
                          ? Color(0xff3D1A54)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    index == 0
                        ? Localization().localizationMap["creditCard"]
                        : Localization().localizationMap["fawry"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.bold,
                      color: currentIndex == index
                          ? Color(0xff3D1A54)
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChargeButton extends StatelessWidget {
  final Color? buttonColor, buttonTextColor;
  final TextStyle? buttonTextStyle;
  final Function(CreditCardSuccessModel cardSuccessModel) onCreditCardSuccess;
  final Function(FawrySuccessModel fawrySuccessModel) onFawrySuccess;
  final Function onClosedByUser;
  final Function(dynamic error) onError;

  /*final double amount;*/

  _ChargeButton({
    this.buttonTextStyle,
    this.buttonColor,
    this.buttonTextColor,
    required this.onFawrySuccess,
    required this.onClosedByUser,
    required this.onCreditCardSuccess,
    required this.onError,
    /*required this.amount*/
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CowpayBloc, CowpayState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        int currentIndex = context.read<CowpayBloc>().state.tabCurrentIndex;
        if (state.status.isSubmissionSuccess) {
          if (currentIndex == 0) {
            context.read<CowpayBloc>().add(ClearStatus());
            SchedulerBinding.instance!.addPostFrameCallback((_) async {
              PayLoadModel? payLoadModel = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewScreen(
                    creditCardEntity: state.creditCardEntity!,
                    onError: onError,
                  ),
                ),
              );
              if (payLoadModel != null) {
                CreditCardSuccessModel cardSuccessModel =
                    CreditCardSuccessModel(
                        cowpayReferenceId: payLoadModel.cowpayReferenceId,
                        paymentGatewayReferenceId:
                            payLoadModel.paymentGatewayReferenceId);

                onCreditCardSuccess(cardSuccessModel);
              }
              Navigator.pop(context);
            });
          } else {
            context.read<CowpayBloc>().add(ClearStatus());
            SchedulerBinding.instance!.addPostFrameCallback((_) async {
              FawryEntity? fawryEntity = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FawryScreen(
                    fawryEntity: state.fawryEntity!,
                  ),
                ),
              );
              if (fawryEntity != null) {
                FawrySuccessModel fawrySuccessModel = FawrySuccessModel(
                    cowpayReferenceId: fawryEntity.cowpayReferenceId.toString(),
                    paymentGatewayReferenceId:
                        fawryEntity.paymentGatewayReferenceId,
                    merchantReferenceId: fawryEntity.merchantReferenceId);
                onFawrySuccess(fawrySuccessModel);
                Navigator.pop(context);
              }
            });
          }
        } else if (state.status.isSubmissionFailure) onError(state.errorModel);
        return state.status.isSubmissionInProgress
            ? ButtonLoadingView()
            : ButtonView(
                fontWeight: FontWeight.w300,
                // title: 'PAY  $amount EGP',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Localization().localizationMap["confirmPayment"],
                        style: buttonTextStyle ??
                            TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: Colors.white),
                        textScaleFactor: 1),
                  ],
                ),
                textColor: buttonTextColor ?? Colors.white,
                fontSize: 0.025,
                backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
                mainContext: context,
                buttonTextStyle: buttonTextStyle,
                onClickFunction: onClickSubmit,
              );
      },
    );
  }

  void onClickSubmit(
    BuildContext context,
  ) {
    int currentIndex = context.read<CowpayBloc>().state.tabCurrentIndex;
    if (currentIndex == 0) {
      context.read<CowpayBloc>().add(ChargeCreditCardValidation());
    } else {
      context.read<CowpayBloc>().add(ChargeFawry());
    }
  }
}
