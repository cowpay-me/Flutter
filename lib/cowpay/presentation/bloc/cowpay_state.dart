part of 'cowpay_bloc.dart';

class CowpayState extends Equatable {
  const CowpayState(
      {this.status = FormzStatus.pure,
      this.creditCardNumber = const CreditCardNumber.pure(),
      this.creditCardExpiryMonth = const CreditCardExpiryMonth.pure(),
      this.creditCardExpiryYear = const CreditCardExpiryYear.pure(),
      this.creditCardCvv = const CreditCardCvv.pure(),
      this.creditCardHolderName = const CreditCardHolderName.pure(),
      this.notValid = 0,
      this.checkValidation = false,
      this.isNotValidExpirationDate = true,
      this.merchantReferenceId,
      this.customerMerchantProfileId,
      this.customerEmail,
      this.customerMobile,
      this.amount,
      this.creditCardEntity,
      this.fawryEntity,
      this.errorModel,
      this.description,
      this.yearsList,
      this.customerName,
      this.failure,
      this.tabCurrentIndex = 0});

  final FormzStatus status;
  final CreditCardExpiryMonth creditCardExpiryMonth;
  final CreditCardExpiryYear creditCardExpiryYear;
  final CreditCardCvv creditCardCvv;
  final CreditCardNumber creditCardNumber;
  final CreditCardHolderName creditCardHolderName;

  final String? merchantReferenceId;
  final String? customerMerchantProfileId;
  final String? customerEmail;
  final String? customerMobile;
  final String? amount;
  final String? description;
  final String? customerName;

  final int notValid;
  final bool checkValidation;
  final bool isNotValidExpirationDate;

  final List<String>? yearsList;

  final CreditCardEntity? creditCardEntity;
  final FawryEntity? fawryEntity;
  final Failure? failure;
  final dynamic? errorModel;
  final int tabCurrentIndex;

  CowpayState copyWith(
      {FormzStatus? status,
      CreditCardExpiryMonth? creditCardExpiryMonth,
      CreditCardExpiryYear? creditCardExpiryYear,
      CreditCardCvv? creditCardCvv,
      CreditCardNumber? creditCardNumber,
      CreditCardHolderName? creditCardHolderName,
      bool? checkValidation,
      bool? isNotValidExpirationDate,
      int? notValid,
      String? merchantReferenceId,
      String? customerMerchantProfileId,
      String? customerName,
      String? customerEmail,
      String? customerMobile,
      Nullable<Failure?>? failure,
      String? amount,
      String? description,
      Nullable<CreditCardEntity?>? creditCardEntity,
      Nullable<FawryEntity?>? fawryResponseModel,
      Nullable<dynamic?>? errorModel,
      List<String>? yearsList,
      int? tabCurrentIndex}) {
    return CowpayState(
        status: status ?? this.status,
        yearsList: yearsList ?? this.yearsList,
        creditCardExpiryMonth:
            creditCardExpiryMonth ?? this.creditCardExpiryMonth,
        creditCardExpiryYear: creditCardExpiryYear ?? this.creditCardExpiryYear,
        creditCardCvv: creditCardCvv ?? this.creditCardCvv,
        creditCardNumber: creditCardNumber ?? this.creditCardNumber,
        creditCardHolderName: creditCardHolderName ?? this.creditCardHolderName,
        notValid: notValid ?? this.notValid,
        checkValidation: checkValidation ?? this.checkValidation,
        isNotValidExpirationDate:
            isNotValidExpirationDate ?? this.isNotValidExpirationDate,
        merchantReferenceId: merchantReferenceId ?? this.merchantReferenceId,
        customerMerchantProfileId:
            customerMerchantProfileId ?? this.customerMerchantProfileId,
        customerEmail: customerEmail ?? this.customerEmail,
        customerMobile: customerMobile ?? this.customerMobile,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        creditCardEntity: creditCardEntity == null
            ? this.creditCardEntity
            : creditCardEntity.value,
        fawryEntity: fawryResponseModel == null
            ? this.fawryEntity
            : fawryResponseModel.value,
        errorModel: errorModel ?? this.errorModel,
        customerName: customerName ?? this.customerName,
        failure: failure == null ? this.failure : failure.value,
        tabCurrentIndex: tabCurrentIndex ?? this.tabCurrentIndex);
  }

  @override
  List get props => [
        status,
        creditCardExpiryMonth,
        creditCardExpiryYear,
        creditCardHolderName,
        creditCardNumber,
        creditCardCvv,
        checkValidation,
        isNotValidExpirationDate,
        yearsList,
        tabCurrentIndex,
        fawryEntity,
        creditCardEntity,
        failure,
      ];
}
