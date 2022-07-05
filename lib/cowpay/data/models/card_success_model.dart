class CreditCardSuccessModel {
  final String paymentGatewayReferenceId;
  final String cowpayReferenceId;

  const CreditCardSuccessModel(
      {required this.cowpayReferenceId,
      required this.paymentGatewayReferenceId});
}
