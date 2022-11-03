import 'dart:convert';

import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/models/user.dart';

Invitation invitationFromJson(String str) => Invitation.fromJson(json.decode(str));

String invitationToJson(Invitation data) => json.encode(data.toJson());

class Invitation {
  Invitation({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.status,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.group,
    this.user,
    required this.received
  });

  int id;
  int groupId;
  int userId;
  String status;
  int createdBy;
  int? updatedBy;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  User? user;
  Group? group;
  bool received;

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
    id: json["id"],
    groupId: json["group_id"],
    userId: json["user_id"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    deletedAt: json["deleted_at"] != null ? DateTime.parse(json["deleted_at"]) : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    group: json["group"] != null ? Group.fromJson(json["group"]) : null,
    received: json["received"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "user_id": userId,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "group": group!.toJson(),
    "user": user!.toJson(),
    "received": received,
  };
}