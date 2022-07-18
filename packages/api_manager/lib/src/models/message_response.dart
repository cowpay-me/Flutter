import 'response_model.dart';

class MessageResponse extends ResponseModel {
  MessageResponse({required this.message});

  factory MessageResponse.fromMap(Map<String, dynamic> map) => MessageResponse(
      message: map['message'] as String? ??
          map['msg'] as String? ??
          map['status_description'] as String);

  final String message;

  @override
  List<Object?> get props => [message];

  Map<String, dynamic> toMap() {
    return {'message': message};
  }
}
