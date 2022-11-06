import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/dashboard_largest_expense.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class LargestExpenses extends StatefulWidget {
  const LargestExpenses({Key? key}) : super(key: key);

  @override
  State<LargestExpenses> createState() => _LargestExpensesState();
}

class _LargestExpensesState extends State<LargestExpenses> {

  int touchedIndex = -1;
  bool largestExLoading = true;
  late DashboardLargestExpense dashboardLargestExpense;
  late List<PieChartSectionData> pieChartSectionData;

  @override
  void initState() {
    super.initState();
    getDailyInExData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: largestExLoading ? Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 150,
          child: const SpinKitRotatingPlain(
            color: Colors.blue,
            size: 50.0,
          ),
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'Largest expense',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'top 5',
                        style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          startDegreeOffset: 180,
                          sectionsSpace: 2,
                          centerSpaceRadius: 0,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for(var i = 0; i < dashboardLargestExpense.labels.length; i++) indicator(i)
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  void getDailyInExData() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "dashboard/largest-expense", null, null);

    if(basicResponse.response == "success"){
      setState(() {
        dashboardLargestExpense = DashboardLargestExpense.fromJson(basicResponse.data);
        largestExLoading = false;
      });
    }
    else {
      Helpers.showToastNoBuild(basicResponse.response, "Failed to fetch data! Please reload!");
    }
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> items = [];
    for(var i = 0; i < dashboardLargestExpense.labels.length; i++){
      final isTouched = i == touchedIndex;
      final opacity = isTouched ? 1.0 : 0.6;
      final color = Helpers.colorFromHex(dashboardLargestExpense.datasets[0].backgroundColor[i]);
      PieChartSectionData item = PieChartSectionData(
        color: color.withOpacity(opacity),
        value: dashboardLargestExpense.datasets[0].data[i],
        title: dashboardLargestExpense.datasets[0].data[i].toString(),
        radius: 110,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched ? BorderSide(color: color, width: 6) : BorderSide(color: color.withOpacity(0)),
      );
      items.add(item);
    }
    return items;
  }

  Widget indicator(index) {
    List<String> labels = ["First", "Second", "Third", "Fourth", "Fifth"];
    return Container(
      margin: const EdgeInsets.only(bottom: 10, right: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Helpers.colorFromHex(dashboardLargestExpense.datasets[0].backgroundColor[index]),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            labels[index],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade400
            ),
          )
        ],
      ),
    );
  }
}
