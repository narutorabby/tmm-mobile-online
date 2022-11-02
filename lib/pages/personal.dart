import 'package:flutter/material.dart';
import 'package:trackmymoney/widgets/record_list.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {

  @override
  Widget build(BuildContext context) {
    return const RecordList();
  }
}
