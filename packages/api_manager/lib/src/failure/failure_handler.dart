import 'dart:io';

import 'package:dio/dio.dart';

import 'enum.dart';
import 'exceptions.dart';
import 'failures.dart';
import 'status_checker.dart';

void Function(Response<dynamic>?, dynamic, String, {bool allReponse})?
    recordError;

class FailureHandler {
  FailureHandler();
  final StatusChecker _statusChecker = StatusChecker();

  Failure handle(dynamic exception, Response? response) {
    if (exception is ErrorException) {
      return Failures.errorFailure(
        errorStatus: _statusChecker.getErrorState(exception.statusCode),
        error: exception.error,
      );
    } else if (exception is DioError) {
      switch (exception.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          return Failures.connectionFailure();
        case DioErrorType.cancel:
          return Failures.requestCanceledFailure();
        case DioErrorType.response:
        case DioErrorType.other:
          {
            if (exception.message.contains('SocketException')) {
              return Failures.connectionFailure();
            }
            return unkownFailure(response, exception, 'Unknown DioError');
          }
      }
    } else if (exception is ServerException) {
      final status = _statusChecker(exception.response?.statusCode);
      switch (status) {
        case HTTPCodes.invalidToken:
          return Failures.sessionEndedFailure();
        case HTTPCodes.serviceNotAvailable:
          recordError?.call(
              exception.response, exception, 'Service Not Available',
              allReponse: false);

          return Failures.serviceNotAvailableFailure();
        case HTTPCodes.unknown:
          return unkownFailure(response, exception, 'Unknown ServerException');
        default:
          break;
      }
    } else if (exception is SocketException) {
      return Failures.connectionFailure();
    } else if (exception is FormatException) {
      recordError?.call(response, exception, 'Service Not Available Failure');

      return Failures.serviceNotAvailableFailure();
    } else if (exception is CacheException) {
      return Failures.cacheFailure();
    } else if (exception is ValidationException) {
      return Failures.validationFailure(exception.value);
    } else if (exception is TypeError) {
      recordError?.call(response, exception, 'TypeError');

      return Failures.serviceNotAvailableFailure();
    }
    return unkownFailure(response, exception, 'Unkown Failure');
  }

  UnkownFailure unkownFailure(
      Response? response, dynamic exception, String type) {
    recordError?.call(response, exception, type);

    return UnkownFailure(exception);
  }
}
