import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/dashboard_monthly_income_expense.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class MonthlyIncomeExpense extends StatefulWidget {
  const MonthlyIncomeExpense({Key? key}) : super(key: key);

  @override
  State<MonthlyIncomeExpense> createState() => _MonthlyIncomeExpenseState();
}

class _MonthlyIncomeExpenseState extends State<MonthlyIncomeExpense> {
  bool monthlyInExLoading = true;
  late DashboardMonthlyIncomeExpense dashboardMonthlyIncomeExpense;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    getMonthlyInExData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: monthlyInExLoading ? Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 150,
          child: const SpinKitRotatingPlain(
            color: Colors.blue,
            size: 50.0,
          ),
        ) : Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'Monthly income expense',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          'last 6 months',
                          style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 64,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 20000,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: showingBarGroups,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Helpers.colorFromHex(dashboardMonthlyIncomeExpense.datasets[0].backgroundColor),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        dashboardMonthlyIncomeExpense.datasets[0].label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade400
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Helpers.colorFromHex(dashboardMonthlyIncomeExpense.datasets[1].backgroundColor),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dashboardMonthlyIncomeExpense.datasets[1].label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade400
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void getMonthlyInExData() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "dashboard/monthly-income-expense", null, null);

    if(basicResponse.response == "success"){
      setState(() {
        dashboardMonthlyIncomeExpense = DashboardMonthlyIncomeExpense.fromJson(basicResponse.data);
        List<BarChartGroupData> items = [];
        for(var i = 0; i < 6; i++) {
          final barGroup = makeGroupData(i, dashboardMonthlyIncomeExpense.datasets[0].data[i].toDouble(), dashboardMonthlyIncomeExpense.datasets[1].data[i].toDouble());
          items.add(barGroup);
        }
        rawBarGroups = items;
        showingBarGroups = rawBarGroups;

        monthlyInExLoading = false;
      });
    }
    else {
      Helpers.showToastNoBuild(basicResponse.response, "Failed to fetch data! Please reload!");
    }
  }

  Widget leftTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: Colors.blueGrey.shade400,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value >= 0) {
      text = (value ~/ 1000).toString() + 'K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      dashboardMonthlyIncomeExpense.labels[value.toInt()],
      style: TextStyle(
        color: Colors.blueGrey.shade400,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: 11,
      space: 24,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: Helpers.colorFromHex(dashboardMonthlyIncomeExpense.datasets[0].backgroundColor),
        width: 8,
      ),
      BarChartRodData(
        toY: y2,
        color: Helpers.colorFromHex(dashboardMonthlyIncomeExpense.datasets[1].backgroundColor),
        width: 8,
      ),
    ],
    );
  }
}
