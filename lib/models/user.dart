// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.googleId,
    required this.mobile,
    required this.avatar,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.token,
  });

  int id;
  String name;
  String email;
  double googleId;
  String mobile;
  String avatar;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    googleId: json["google_id"],
    mobile: json["mobile"],
    avatar: json["avatar"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
    token: json.containsKey("token") ? json["token"] : "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "google_id": googleId,
    "mobile": mobile,
    "avatar": avatar,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "token": token,
  };
}
