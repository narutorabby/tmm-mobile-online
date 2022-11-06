import 'dart:convert';

DashboardLargestExpense dashboardLargestExpenseFromJson(String str) => DashboardLargestExpense.fromJson(json.decode(str));

String dashboardLargestExpenseToJson(DashboardLargestExpense data) => json.encode(data.toJson());

class DashboardLargestExpense {
  DashboardLargestExpense({
    required this.labels,
    required this.datasets,
  });

  List<String> labels;
  List<Dataset> datasets;

  factory DashboardLargestExpense.fromJson(Map<String, dynamic> json) => DashboardLargestExpense(
    labels: List<String>.from(json["labels"].map((x) => x)),
    datasets: List<Dataset>.from(json["datasets"].map((x) => Dataset.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "labels": List<dynamic>.from(labels.map((x) => x)),
    "datasets": List<dynamic>.from(datasets.map((x) => x.toJson())),
  };
}

class Dataset {
  Dataset({
    required this.label,
    required this.backgroundColor,
    required this.data,
  });

  String label;
  List<String> backgroundColor;
  List<double> data;

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
    label: json["label"],
    backgroundColor: List<String>.from(json["backgroundColor"].map((x) => x)),
    data: List<double>.from(json["data"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "backgroundColor": List<dynamic>.from(backgroundColor.map((x) => x)),
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}