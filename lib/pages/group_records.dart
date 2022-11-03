import 'package:flutter/material.dart';
import 'package:trackmymoney/widgets/record_list.dart';

class GroupRecords extends StatefulWidget {
  final String slug;
  const GroupRecords({Key? key, required this.slug}) : super(key: key);

  @override
  State<GroupRecords> createState() => _GroupRecordsState();
}

class _GroupRecordsState extends State<GroupRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RecordList(isGroup: true, slug: widget.slug)
      )
    );
  }
}
