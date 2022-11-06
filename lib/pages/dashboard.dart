import 'package:flutter/material.dart';
import 'package:trackmymoney/pages/dashboard/daily_income_expenses.dart';
import 'package:trackmymoney/pages/dashboard/group_expenses.dart';
import 'package:trackmymoney/pages/dashboard/largest_expenses.dart';
import 'package:trackmymoney/pages/dashboard/monthly_income_expense.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              DailyIncomeExpense(),
              LargestExpenses(),
              GroupExpenses(),
              MonthlyIncomeExpense()
            ],
          ),
        )
      )
    );
  }
}
