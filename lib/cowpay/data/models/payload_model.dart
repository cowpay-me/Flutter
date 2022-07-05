class PayLoadModel {
  String messageSource;
  String messageType;
  String callbackType;
  String paymentStatus;
  String paymentGatewayReferenceId;
  String cowpayReferenceId;
  String amount;
  String paymentMethod;
  String signature;

  PayLoadModel({
    required this.amount,
    required this.callbackType,
    required this.cowpayReferenceId,
    required this.messageSource,
    required this.messageType,
    required this.paymentGatewayReferenceId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.signature,
  });

  factory PayLoadModel.fromJson(Map<String, dynamic> json) {
    return PayLoadModel(
      amount: json['amount'],
      callbackType: json['callback_type'],
      cowpayReferenceId: json['cowpay_reference_id'],
      messageSource: json['message_source'],
      messageType: json['message_type'],
      paymentGatewayReferenceId: json['payment_gateway_reference_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      signature: json['signature'],
    );
  }
}
