import 'dart:convert';
import 'package:trackmymoney/models/share.dart';
import 'package:trackmymoney/models/user.dart';

Record recordFromJson(String str) => Record.fromJson(json.decode(str));

String recordToJson(Record data) => json.encode(data.toJson());

class Record {
  Record({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.title,
    required this.description,
    required this.userId,
    required this.groupId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.user,
    required this.shares,
  });

  int id;
  String type;
  double amount;
  DateTime date;
  String title;
  String? description;
  int? userId;
  int? groupId;
  int createdBy;
  int? updatedBy;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User? user;
  List<Share> shares;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json["id"],
    type: json["type"],
    amount: json["amount"].toDouble(),
    date: DateTime.parse(json["date"]),
    title: json["title"],
    description: json["description"],
    userId: json["user_id"],
    groupId: json["group_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    deletedAt: json["deleted_at"] != null ? DateTime.parse(json["deleted_at"]) : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    shares: List<Share>.from(json["shares"].map((x) => Share.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "amount": amount,
    "date": date.toIso8601String(),
    "title": title,
    "description": description,
    "user_id": userId,
    "group_id": groupId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "user": user?.toJson(),
    "shares": List<dynamic>.from(shares.map((x) => x.toJson())),
  };
}