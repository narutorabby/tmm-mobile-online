import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/services/helpers.dart';

class RecordListItem extends StatefulWidget {

  final Record record;

  const RecordListItem({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordListItem> createState() => _RecordListItemState();
}

class _RecordListItemState extends State<RecordListItem> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.record.title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(Helpers.formatDate(widget.record.date)),
                        ],
                      ),
                    ),
                    Text(
                      Helpers.formatCurrency(widget.record.amount),
                      style: const TextStyle(fontSize: 18)
                    )
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
