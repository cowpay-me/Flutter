import 'package:equatable/equatable.dart';

//TODO set your user entity here
class FawryEntity extends Equatable {
  final bool success;
  final int statusCode;
  final String statusDescription;
  final String type;
  final String paymentGatewayReferenceId;
  final String merchantReferenceId;
  final int cowpayReferenceId;

  FawryEntity(
      {required this.success,
      required this.statusCode,
      required this.statusDescription,
      required this.type,
      required this.paymentGatewayReferenceId,
      required this.merchantReferenceId,
      required this.cowpayReferenceId});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
