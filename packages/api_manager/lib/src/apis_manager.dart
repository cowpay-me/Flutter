import 'package:api_manager/api_manager.dart';
import 'package:api_manager/failures.dart';
import 'package:dartz/dartz.dart';

abstract class APIsManager {
  Future<Either<Failure, R>> send<R, ER extends ResponseModel>({
    required Request request,
    required R Function(Map<String, dynamic> map) responseFromMap,
    ER Function(Map<String, dynamic> map)? errorResponseFromMap,
  });
}
