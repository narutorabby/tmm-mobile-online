import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordsFilter extends StatefulWidget {

  final String currentFromDate;
  final String currentToDate;
  final String currentType;
  final Function sendFilterDataBack;
  final bool isGroup;

  const RecordsFilter({
    Key? key,
    required this.currentFromDate,
    required this.currentToDate,
    required this.currentType,
    required this.sendFilterDataBack,
    this.isGroup = false,
  }) : super(key: key);

  @override
  _RecordsFilterState createState() => _RecordsFilterState();
}

class _RecordsFilterState extends State<RecordsFilter> {

  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  static const List<String> personalRecordTypes = ["Any", "Income", "Expense"];
  static const List<String> groupRecordTypes = ["Any", "Contribution", "Bill"];
  String type = "Any";

  @override
  void initState() {
    dateFromController.text = widget.currentFromDate;
    dateToController.text = widget.currentToDate;
    type = widget.currentType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Filter list",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                icon: const Icon(Icons.date_range_rounded),
                labelText: 'Date from',
                contentPadding: const EdgeInsets.only(bottom: 0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    dateFromController.text = "";
                  },
                ),
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: dateFromController,
              onTap: () {
                selectDateFrom(context);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                icon: const Icon(Icons.date_range_rounded),
                labelText: 'Date to',
                contentPadding: const EdgeInsets.only(bottom: 0),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    dateToController.text = "";
                  },
                ),
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: dateToController,
              onTap: () {
                selectDateTo(context);
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.sort_by_alpha_rounded),
                labelText: 'Results list type',
                contentPadding: EdgeInsets.only(bottom: 0),
              ),
              value: type,
              isExpanded: true,
              onChanged: (newValue) {
                setState(() {
                  type = newValue.toString();
                });
              },
              items: (widget.isGroup ? groupRecordTypes : personalRecordTypes).map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      child: const Text("Apply"),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.sendFilterDataBack(dateFromController.text, dateToController.text, type);
                      }
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  selectDateFrom(BuildContext context) async {
    DateTime? newSelectedDateFrom = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );

    if (newSelectedDateFrom != null) {
      selectedDateFrom = newSelectedDateFrom;
      dateFromController
      ..text = DateFormat("dd-MM-yyyy").format(selectedDateFrom)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: dateFromController.text.length,
          affinity: TextAffinity.upstream
        )
      );
    }
  }

  selectDateTo(BuildContext context) async {
    DateTime? newSelectedDateTo = await showDatePicker(
      context: context,
      initialDate: selectedDateTo,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );

    if (newSelectedDateTo != null) {
      selectedDateTo = newSelectedDateTo;
      dateToController
      ..text = DateFormat("dd-MM-yyyy").format(selectedDateTo)
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: dateToController.text.length,
          affinity: TextAffinity.upstream
        )
      );
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
