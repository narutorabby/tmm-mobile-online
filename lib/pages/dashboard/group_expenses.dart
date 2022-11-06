import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/dashboard_group_expense.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class GroupExpenses extends StatefulWidget {
  const GroupExpenses({Key? key}) : super(key: key);

  @override
  State<GroupExpenses> createState() => _GroupExpensesState();
}

class _GroupExpensesState extends State<GroupExpenses> {

  int touchedIndex = -1;
  bool groupExLoading = true;
  late DashboardGroupExpense dashboardGroupExpense;
  late List<PieChartSectionData> pieChartSectionData;

  @override
  void initState() {
    super.initState();
    getGroupExData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: groupExLoading ? Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 150,
          child: const SpinKitRotatingPlain(
            color: Colors.blue,
            size: 50.0,
          ),
        ) : Column(
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
                        'Group expense',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          'Contribution in groups',
                          style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                        ),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for(var i = 0; i < dashboardGroupExpense.labels.length; i++) indicator(i)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  void getGroupExData() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "dashboard/group-expense", null, null);

    if(basicResponse.response == "success"){
      setState(() {
        dashboardGroupExpense = DashboardGroupExpense.fromJson(basicResponse.data);
        groupExLoading = false;
      });
    }
    else {
      Helpers.showToastNoBuild(basicResponse.response, "Failed to fetch data! Please reload!");
    }
  }

  List<PieChartSectionData> showingSections() {
    List<PieChartSectionData> items = [];
    for(var i = 0; i < dashboardGroupExpense.labels.length; i++){
      final isTouched = i == touchedIndex;
      final opacity = isTouched ? 1.0 : 0.6;
      final color = Helpers.colorFromHex(dashboardGroupExpense.datasets[0].backgroundColor[i]);
      PieChartSectionData item = PieChartSectionData(
        color: color.withOpacity(opacity),
        value: dashboardGroupExpense.datasets[0].data[i],
        title: dashboardGroupExpense.datasets[0].data[i].toString(),
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
              color: Helpers.colorFromHex(dashboardGroupExpense.datasets[0].backgroundColor[index]),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            dashboardGroupExpense.labels[index],
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
