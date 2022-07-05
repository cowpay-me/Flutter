class FawrySuccessModel {
  final String paymentGatewayReferenceId;
  final String cowpayReferenceId;
  final String merchantReferenceId;

  const FawrySuccessModel(
      {required this.cowpayReferenceId,
      required this.paymentGatewayReferenceId, required this.merchantReferenceId});
}
