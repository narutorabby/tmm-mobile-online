import 'dart:convert';

BasicResponse holidayFromJson(String str) => BasicResponse.fromJson(json.decode(str));

String holidayToJson(BasicResponse data) => json.encode(data.toJson());

class BasicResponse{
  BasicResponse({
    required this.response,
    required this.message,
    this.data
  });

  String response;
  String message;
  dynamic data;

  factory BasicResponse.fromJson(Map<String, dynamic> json) => BasicResponse(
      response: json['response'],
      message: json['message'],
      data: json['data'],
  );

  Map<String, dynamic> toJson() => {
    "response": response,
    "message": message,
    "data": data,
  };
}