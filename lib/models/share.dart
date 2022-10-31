import 'dart:convert';

Share shareFromJson(String str) => Share.fromJson(json.decode(str));

String shareToJson(Share data) => json.encode(data.toJson());

class Share {
  Share({
    required this.id,
    required this.name,
    required this.email,
    required this.pivot,
  });

  int id;
  String name;
  String email;
  Pivot pivot;

  factory Share.fromJson(Map<String, dynamic> json) => Share(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  Pivot({
    required this.recordId,
    required this.userId,
  });

  int recordId;
  int userId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    recordId: json["record_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "record_id": recordId,
    "user_id": userId,
  };
}