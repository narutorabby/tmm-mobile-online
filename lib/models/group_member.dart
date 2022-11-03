import 'dart:convert';

import 'package:trackmymoney/models/user.dart';

GroupMember groupMemberFromJson(String str) => GroupMember.fromJson(json.decode(str));

String groupMemberToJson(GroupMember data) => json.encode(data.toJson());

class GroupMember {
  GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
    required this.totalContribution,
    required this.totalBill,
    this.user,
  });

  int id;
  int groupId;
  int userId;
  DateTime joinedAt;
  double totalContribution;
  double totalBill;
  User? user;

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    id: json["id"],
    groupId: json["group_id"],
    userId: json["user_id"],
    joinedAt: DateTime.parse(json["joined_at"]),
    totalContribution: json["total_contribution"].toDouble(),
    totalBill: json["total_bill"].toDouble(),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "user_id": userId,
    "joined_at": joinedAt,
    "total_contribution": totalContribution,
    "total_bill": totalBill,
    "user": user?.toJson(),
  };
}