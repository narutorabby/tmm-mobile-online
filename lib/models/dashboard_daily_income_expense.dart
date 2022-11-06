import 'dart:convert';

DashboardDailyIncomeExpense dashboardDailyIncomeExpenseFromJson(String str) => DashboardDailyIncomeExpense.fromJson(json.decode(str));

String dashboardDailyIncomeExpenseToJson(DashboardDailyIncomeExpense data) => json.encode(data.toJson());

class DashboardDailyIncomeExpense {
  DashboardDailyIncomeExpense({
    required this.labels,
    required this.datasets,
  });

  List<String> labels;
  List<Dataset> datasets;

  factory DashboardDailyIncomeExpense.fromJson(Map<String, dynamic> json) => DashboardDailyIncomeExpense(
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
  String backgroundColor;
  List<double> data;

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
    label: json["label"],
    backgroundColor: json["backgroundColor"],
    data: List<double>.from(json["data"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "backgroundColor": backgroundColor,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}