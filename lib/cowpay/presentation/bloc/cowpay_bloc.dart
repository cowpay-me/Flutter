import 'package:api_manager/failures.dart';
import 'package:cowpay/core/formz_models/credit_card_cvv.dart';
import 'package:cowpay/core/formz_models/credit_card_expiry_month.dart';
import 'package:cowpay/core/formz_models/credit_card_expiry_year.dart';
import 'package:cowpay/core/formz_models/credit_card_holder_name.dart';
import 'package:cowpay/core/formz_models/credit_card_number.dart';
import 'package:cowpay/core/helpers/cowpay_helper.dart';
import 'package:cowpay/cowpay/data/models/credit_card_request_model.dart';
import 'package:cowpay/cowpay/data/models/fawry_request_model.dart';
import 'package:cowpay/cowpay/domain/entities/credit_card_entity.dart';
import 'package:cowpay/cowpay/domain/entities/fawry_entity.dart';
import 'package:cowpay/cowpay/domain/usecases/cash_collection_usecase.dart';
import 'package:cowpay/cowpay/domain/usecases/creditcard_usecase.dart';
import 'package:cowpay/cowpay/domain/usecases/fawry_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../core/helpers/nullable.dart';

part 'cowpay_event.dart';
part 'cowpay_state.dart';

class CowpayBloc extends Bloc<CowpayEvent, CowpayState> {
  CowpayBloc(
      {required this.fawryUseCase,
      required this.creditCardUseCase,
      required this.cashCollectionUseCase})
      : super(CowpayState());
  final FawryUseCase fawryUseCase;
  final CreditCardUseCase creditCardUseCase;
  final CashCollectionUseCase cashCollectionUseCase;

  @override
  Stream<CowpayState> mapEventToState(CowpayEvent event) async* {
    if (event is ChangeTabCurrentIndexEvent) {
      yield _changeTabCurrentIndexToState(event);
    } else if (event is CowpayStarted) {
      yield _mapCardStartToState(event, state);
    } else if (event is ChargeCreditCardValidation) {
      yield* _validateChangedToState(state, event);
    } else if (event is ChargeFawry) {
      yield* _mapChargeFawryToState(
        state,
      );
    } else if (event is CreditCardNameChange) {
      yield _mapCardHolderNameChangedToState(event, state);
    } else if (event is CreditCardNumberChange) {
      yield _mapCardNumberChangedToState(event, state);
    } else if (event is CreditCardCvvChange) {
      yield _mapCardCvvChangedToState(event, state);
    } else if (event is CreditCardExpiryYearChange) {
      yield _mapCardExpiryYearChangedToState(event, state);
    } else if (event is CreditCardExpiryMonthChange) {
      yield _mapCardExpiryMonthChangedToState(event, state);
    } else if (event is ClearStatus) {
      yield _mapClearStatusToState();
    }
  }

  CowpayState _changeTabCurrentIndexToState(ChangeTabCurrentIndexEvent event) {
    return state.copyWith(tabCurrentIndex: event.index);
  }

  CowpayState _mapClearStatusToState() {
    return state.copyWith(status: FormzStatus.pure);
  }

//region Fawry
  Stream<CowpayState> _mapChargeFawryToState(
    CowpayState state,
  ) async* {
    yield state.copyWith(
        status: FormzStatus.submissionInProgress,
        failure: Nullable(null),
        fawryResponseModel: Nullable(null));
    try {
      String signature = CowpayHelper().generateSignature(
        state.merchantReferenceId ?? '',
        state.customerMerchantProfileId ?? '',
        state.amount ?? '',
      );
      FawryChargeRequestModel fawryRequestModel = FawryChargeRequestModel(
          merchantReferenceId: state.merchantReferenceId ?? '',
          amount: state.amount ?? '',
          customerEmail: state.customerEmail ?? '',
          description: state.description ?? '',
          customerMerchantProfileId: state.customerMerchantProfileId ?? '',
          customerMobile: state.customerMobile ?? '',
          customerName: state.customerName ?? '',
          signature: signature);

      Either<Failure, FawryEntity> responseOrFailure =
          await fawryUseCase.call(fawryRequestModel);

      yield* _eitherStateOrErrorState<FawryEntity>(responseOrFailure, state);
    } catch (error) {
      yield state.copyWith(
          status: FormzStatus.submissionFailure, errorModel: Nullable(error));
    }
  }

  //endregion

  //region Credit Card

  CowpayState _mapCardStartToState(
    CowpayStarted event,
    CowpayState state,
  ) {
    int currentYear = DateTime.now().year;
    List<String> yearsList = [];
    for (int i = 0; i < 10; i++) {
      yearsList.add(currentYear.toString().replaceRange(0, 2, ''));
      currentYear += 1;
    }

    return state.copyWith(
        merchantReferenceId: event.merchantReferenceId,
        customerMerchantProfileId: event.customerMerchantProfileId,
        customerEmail: event.customerEmail,
        customerMobile: event.customerMobile,
        amount: event.amount,
        customerName: event.customerName,
        description: event.description,
        yearsList: yearsList);
  }

  Stream<CowpayState> _validateChangedToState(
    CowpayState state,
    ChargeCreditCardValidation event,
  ) async* {
    final creditCardHolderName =
        CreditCardHolderName.dirty(state.creditCardHolderName.value);
    final creditCardNumber =
        CreditCardNumber.dirty(state.creditCardNumber.value);
    final creditCardCvv = CreditCardCvv.dirty(state.creditCardCvv.value);
    final creditCardExpiryMonth =
        CreditCardExpiryMonth.dirty(state.creditCardExpiryMonth.value);
    final creditCardExpiryYear =
        CreditCardExpiryYear.dirty(state.creditCardExpiryYear.value);

    List<FormzStatus> validationListState = [];
    validationListState.add(Formz.validate([creditCardHolderName]));
    validationListState.add(Formz.validate([creditCardNumber]));
    validationListState.add(Formz.validate([creditCardCvv]));
    validationListState.add(Formz.validate([creditCardExpiryMonth]));
    validationListState.add(Formz.validate([creditCardExpiryYear]));
    if (validationListState.where((element) => element.isInvalid).isEmpty)
      yield* _mapRegisterSubmittedToState(
          state,
          creditCardHolderName,
          creditCardNumber,
          creditCardCvv,
          creditCardExpiryMonth,
          creditCardExpiryYear,
          validationListState
              .where((element) => element == FormzStatus.invalid)
              .length);
    else
      yield state.copyWith(
          isNotValidExpirationDate: false,
          creditCardHolderName: creditCardHolderName,
          creditCardNumber: creditCardNumber,
          creditCardCvv: creditCardCvv,
          creditCardExpiryMonth: creditCardExpiryMonth,
          creditCardExpiryYear: creditCardExpiryYear,
          checkValidation: true,
          status: Formz.validate([
            creditCardHolderName,
            creditCardNumber,
            creditCardCvv,
            creditCardExpiryMonth,
            creditCardExpiryYear
          ]),
          notValid: validationListState
              .where((element) => element == FormzStatus.invalid)
              .length);
  }

  Stream<CowpayState> _mapRegisterSubmittedToState(
      CowpayState state,
      CreditCardHolderName creditCardHolderName,
      CreditCardNumber creditCardNumber,
      CreditCardCvv creditCardCvv,
      CreditCardExpiryMonth creditCardExpiryMonth,
      CreditCardExpiryYear creditCardExpiryYear,
      int length) async* {
    yield state.copyWith(
        status: FormzStatus.submissionInProgress,
        failure: Nullable(null),
        creditCardEntity: Nullable(null));
    try {
      String signature = CowpayHelper().generateSignature(
        state.merchantReferenceId ?? '',
        state.customerMerchantProfileId ?? '',
        state.amount ?? '',
      );
      CreditCardChargeRequestModel creditCardRequestModel =
          CreditCardChargeRequestModel(
              merchantReferenceId: state.merchantReferenceId ?? '',
              customerMerchantProfileId: state.customerMerchantProfileId ?? '',
              customerEmail: state.customerEmail ?? '',
              customerMobile: state.customerMobile ?? '',
              customerName: state.creditCardHolderName.value,
              cvv: creditCardCvv.value,
              cardNumber: creditCardNumber.value,
              expiryYear: creditCardExpiryYear.value,
              expiryMonth: creditCardExpiryMonth.value,
              amount: state.amount ?? '',
              description: state.description ?? '',
              signature: signature,
              cardHolder: state.creditCardHolderName.value);

      Either<Failure, CreditCardEntity> responseOrFailure =
          await creditCardUseCase.call(creditCardRequestModel);

      yield* _eitherStateOrErrorState<CreditCardEntity>(
          responseOrFailure, state);
    } catch (error) {
      state.copyWith(
          creditCardHolderName: creditCardHolderName,
          creditCardNumber: creditCardNumber,
          creditCardCvv: creditCardCvv,
          creditCardExpiryMonth: creditCardExpiryMonth,
          creditCardExpiryYear: creditCardExpiryYear,
          checkValidation: true,
          status: Formz.validate([
            creditCardHolderName,
            creditCardNumber,
            creditCardCvv,
            creditCardExpiryMonth,
            creditCardExpiryYear
          ]),
          notValid: length);

      yield state.copyWith(
          status: FormzStatus.submissionFailure, errorModel: Nullable(error));
    }
  }

  CowpayState _mapCardHolderNameChangedToState(
    CreditCardNameChange event,
    CowpayState state,
  ) {
    final name = CreditCardHolderName.dirty(event.creditCardHolderName);
    return state.copyWith(
      creditCardHolderName: name,
    );
  }

  CowpayState _mapCardNumberChangedToState(
    CreditCardNumberChange event,
    CowpayState state,
  ) {
    final creditCardNumber = CreditCardNumber.dirty(event.creditCardNumber);
    return state.copyWith(
      creditCardNumber: creditCardNumber,
    );
  }

  CowpayState _mapCardCvvChangedToState(
    CreditCardCvvChange event,
    CowpayState state,
  ) {
    final creditCardCvv = CreditCardCvv.dirty(event.creditCardCvv);
    return state.copyWith(
      creditCardCvv: creditCardCvv,
    );
  }

  CowpayState _mapCardExpiryMonthChangedToState(
    CreditCardExpiryMonthChange event,
    CowpayState state,
  ) {
    final creditCardExpiryMonth =
        CreditCardExpiryMonth.dirty(event.creditCardExpiryMonth);

    bool isNotValidExpirationDate = true;
    if (state.creditCardExpiryYear.value != "" &&
        state.creditCardExpiryMonth.value != "") {
      var expirationDate = DateTime(int.parse(state.creditCardExpiryYear.value),
          int.parse(creditCardExpiryMonth.value) + 1);
      //add 1 month
      if (expirationDate.isAfter(DateTime.now())) {
        isNotValidExpirationDate = false;
      }
    }
    return state.copyWith(
      creditCardExpiryMonth: creditCardExpiryMonth,
      isNotValidExpirationDate: isNotValidExpirationDate,
    );
  }

  CowpayState _mapCardExpiryYearChangedToState(
    CreditCardExpiryYearChange event,
    CowpayState state,
  ) {
    final creditCardExpiryYear =
        CreditCardExpiryYear.dirty(event.creditCardExpiryYear);

    bool isNotValidExpirationDate = true;
    if (state.creditCardExpiryYear.value != "" &&
        state.creditCardExpiryMonth.value != "") {
      var expirationDate = DateTime(int.parse(creditCardExpiryYear.value),
          int.parse(state.creditCardExpiryMonth.value) + 1);
      //add 1 month
      if (expirationDate.isAfter(DateTime.now())) {
        isNotValidExpirationDate = false;
      }
    }

    return state.copyWith(
      isNotValidExpirationDate: isNotValidExpirationDate,
      creditCardExpiryYear: creditCardExpiryYear,
    );
  }

//endregion

  Stream<CowpayState> _eitherStateOrErrorState<T>(
    Either<Failure, T> failureOrResponse,
    CowpayState state,
  ) async* {
    yield failureOrResponse.fold(
      (failure) {
        return state.copyWith(
          status: FormzStatus.submissionFailure,
          failure: Nullable(failure),
        );
      },
      (response) {
        if (response is FawryEntity) {
          return state.copyWith(
              status: FormzStatus.submissionSuccess,
              fawryResponseModel: Nullable(response));
        } else if (response is CreditCardEntity) {
          return state.copyWith(
              status: FormzStatus.submissionSuccess,
              creditCardEntity: Nullable(response));
        }
        return state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
      },
    );
  }
}
