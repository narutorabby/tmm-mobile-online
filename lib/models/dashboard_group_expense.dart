import 'dart:convert';

DashboardGroupExpense dashboardGroupExpenseFromJson(String str) => DashboardGroupExpense.fromJson(json.decode(str));

String dashboardGroupExpenseToJson(DashboardGroupExpense data) => json.encode(data.toJson());

class DashboardGroupExpense {
  DashboardGroupExpense({
    required this.labels,
    required this.datasets,
  });

  List<String> labels;
  List<Dataset> datasets;

  factory DashboardGroupExpense.fromJson(Map<String, dynamic> json) => DashboardGroupExpense(
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
    required this.backgroundColor,
    required this.data,
  });

  List<String> backgroundColor;
  List<double> data;

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
    backgroundColor: List<String>.from(json["backgroundColor"].map((x) => x)),
    data: List<double>.from(json["data"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "backgroundColor": List<dynamic>.from(backgroundColor.map((x) => x)),
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}