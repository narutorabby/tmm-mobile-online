import 'dart:convert';

import 'package:trackmymoney/models/record.dart';

RecordPaginated recordPaginatedFromJson(String str) => RecordPaginated.fromJson(json.decode(str));

String recordPaginatedToJson(RecordPaginated data) => json.encode(data.toJson());

class RecordPaginated {
  RecordPaginated({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.from,
    required this.to,
    required this.total,
    required this.lastPage,
  });

  int currentPage;
  List<Record> data;
  int perPage;
  int from;
  int to;
  int total;
  int lastPage;

  factory RecordPaginated.fromJson(Map<String, dynamic> json) => RecordPaginated(
    currentPage: json["current_page"],
    data: List<Record>.from(json["data"].map((x) => Record.fromJson(x))),
    perPage: json["per_page"],
    from: json["from"],
    to: json["to"],
    total: json["total"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "per_page": perPage,
    "from": from,
    "to": to,
    "total": total,
    "last_page": lastPage,
  };
}