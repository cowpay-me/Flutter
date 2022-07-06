// import 'package:cowpay/cowpay/data/datasources/remote_data_source_test.dart';
// import 'package:cowpay/cowpay/data/repositories/cowpay_repository_Impl.dart';
// import 'package:cowpay/cowpay/domain/repositories/cowpay_repository.dart';
// import 'package:cowpay/cowpay/domain/usecases/cash_collection_usecase.dart';
// import 'package:cowpay/cowpay/domain/usecases/creditcard_usecase.dart';
// import 'package:cowpay/cowpay/domain/usecases/fawry_usecase.dart';
// import 'package:cowpay/cowpay/presentation/bloc/cowpay_bloc.dart';
// import 'package:get_it/get_it.dart';
//
// class CowpayDI {
//   CowpayDI(
//     this.di,
//   ) {
//     call();
//   }
//
//   final GetIt di;
//
//   void call() {
//     di.registerFactory(
//       () => CowpayBloc(
//         fawryUseCase: di(),
//         creditCardUseCase: di(),
//         cashCollectionUseCase: di(),
//       ),
//     );
//
//     di.registerLazySingleton(
//       () => FawryUseCase(
//         repository: di(),
//       ),
//     );
//     di.registerLazySingleton(
//       () => CashCollectionUseCase(
//         repository: di(),
//       ),
//     );
//     di.registerLazySingleton(
//       () => CreditCardUseCase(
//         repository: di(),
//       ),
//     );
//     di.registerLazySingleton<CowpayRepository>(
//       () => CowpayRepositoryImpl(remoteDataSource: di()),
//     );
//
//     di.registerLazySingleton<RemoteDataSource>(
//       () => RemoteDataSourceImpl(di()),
//     );
//   }
// }
// /*di
//       ..registerFactory(() => CowpayBloc(
//             fawryUseCase: di(),
//             creditCardUseCase: di(),
//             cashCollectionUseCase: di(),
//           ))
//       ..registerLazySingleton(() => FawryUseCase(
//             repository: di(),
//           ))
//       ..registerLazySingleton(() => CashCollectionUseCase(
//             repository: di(),
//           ))
//       ..registerLazySingleton(() => CreditCardUseCase(
//             repository: di(),
//           ))
//       ..registerLazySingleton(
//           () => CowpayRepositoryImpl(remoteDataSource: di()))
//       ..registerLazySingleton(() => RemoteDataSourceImpl(di()));*/
import 'package:cowpay/cowpay/data/datasources/remote_data_source.dart';
import 'package:cowpay/cowpay/data/repositories/cowpay_repository_Impl.dart';
import 'package:cowpay/cowpay/domain/repositories/cowpay_repository.dart';
import 'package:cowpay/cowpay/domain/usecases/cash_collection_usecase.dart';
import 'package:cowpay/cowpay/domain/usecases/creditcard_usecase.dart';
import 'package:cowpay/cowpay/domain/usecases/fawry_usecase.dart';
import 'package:cowpay/cowpay/presentation/bloc/cowpay_bloc.dart';
import 'package:get_it/get_it.dart';

class CowpayDI {
  CowpayDI(
    this.di,
  ) {
    call();
  }

  final GetIt di;

  void call() {
    if (!di.isRegistered<RemoteDataSource>()) {
      di
        ..registerFactory(() => CowpayBloc(
              fawryUseCase: di(),
              creditCardUseCase: di(),
              cashCollectionUseCase: di(),
            ))
        ..registerLazySingleton<RemoteDataSource>(
            () => RemoteDataSourceImpl(di()))
        ..registerLazySingleton<CowpayRepository>(
            () => CowpayRepositoryImpl(remoteDataSource: di()))
        ..registerLazySingleton(() => CreditCardUseCase(
              repository: di(),
            ))
        ..registerLazySingleton(() => CashCollectionUseCase(
              repository: di(),
            ))
        ..registerLazySingleton(() => FawryUseCase(
              repository: di(),
            ));
    }
  }
}
