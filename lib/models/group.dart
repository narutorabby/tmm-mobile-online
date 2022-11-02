import 'dart:convert';

import 'package:trackmymoney/models/user.dart';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  Group({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.membersCount,
    this.recordsCount,
    this.admin,
  });

  int id;
  String name;
  String slug;
  int createdBy;
  int? updatedBy;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  int? membersCount;
  int? recordsCount;
  User? admin;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
    deletedAt: json["deleted_at"] != null ? DateTime.parse(json["deleted_at"]) : null,
    membersCount: json["members_count"],
    recordsCount: json["records_count"],
    admin: User.fromJson(json["admin"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "members_count": membersCount,
    "records_count": recordsCount,
    "admin": admin?.toJson(),
  };
}