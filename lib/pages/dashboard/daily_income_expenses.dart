import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/dashboard_daily_income_expense.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class DailyIncomeExpense extends StatefulWidget {
  const DailyIncomeExpense({Key? key}) : super(key: key);

  @override
  State<DailyIncomeExpense> createState() => _DailyIncomeExpenseState();
}

class _DailyIncomeExpenseState extends State<DailyIncomeExpense> {
  bool dailyInExLoading = true;
  late DashboardDailyIncomeExpense dashboardDailyIncomeExpense;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    getDailyInExData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: dailyInExLoading ? Container(
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
                        'Daily income expense',
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          'Last 10 days',
                          style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
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
                              reservedSize: 16,
                              interval: 1000,
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
                          color: Helpers.colorFromHex(dashboardDailyIncomeExpense.datasets[0].backgroundColor),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        dashboardDailyIncomeExpense.datasets[0].label,
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
                          color: Helpers.colorFromHex(dashboardDailyIncomeExpense.datasets[1].backgroundColor),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dashboardDailyIncomeExpense.datasets[1].label,
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

  void getDailyInExData() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "dashboard/daily-income-expense", null, null);

    if(basicResponse.response == "success"){
      setState(() {
        dashboardDailyIncomeExpense = DashboardDailyIncomeExpense.fromJson(basicResponse.data);
        List<BarChartGroupData> items = [];
        for(var i = 0; i < 10; i++) {
          final barGroup = makeGroupData(i, dashboardDailyIncomeExpense.datasets[0].data[i].toDouble(), dashboardDailyIncomeExpense.datasets[1].data[i].toDouble());
          items.add(barGroup);
        }
        rawBarGroups = items;
        showingBarGroups = rawBarGroups;

        dailyInExLoading = false;
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
      dashboardDailyIncomeExpense.labels[value.toInt()],
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
          color: Helpers.colorFromHex(dashboardDailyIncomeExpense.datasets[0].backgroundColor),
          width: 8,
        ),
        BarChartRodData(
          toY: y2,
          color: Helpers.colorFromHex(dashboardDailyIncomeExpense.datasets[1].backgroundColor),
          width: 8,
        ),
      ],
    );
  }
}
