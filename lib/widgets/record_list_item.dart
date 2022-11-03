import 'package:flutter/material.dart';
import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/widgets/record_create_edit.dart';

class RecordListItem extends StatefulWidget {

  final Group? group;
  final Record record;
  final Function responseAction;

  const RecordListItem({Key? key, this.group, required this.record, required this.responseAction}) : super(key: key);

  @override
  State<RecordListItem> createState() => _RecordListItemState();
}

class _RecordListItemState extends State<RecordListItem> {

  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return RecordCreateEdit(
                type: widget.record.type,
                responseAction: widget.responseAction,
                record: widget.record,
                group: widget.group,
                edit: true,
              );
            }
          );
        },
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.record.type.toUpperCase(),
                            style: const TextStyle(fontSize: 10)
                          ),
                          Text(
                            Helpers.formatCurrency(widget.record.amount),
                            style: const TextStyle(fontSize: 18)
                          ),
                        ],
                      ),
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
