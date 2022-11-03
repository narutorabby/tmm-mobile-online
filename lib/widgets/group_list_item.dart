import 'package:flutter/material.dart';
import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/pages/group_members.dart';
import 'package:trackmymoney/pages/group_records.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/widgets/group_create_edit.dart';

class GroupListItem extends StatefulWidget {
  final Group group;
  final Function responseAction;

  const GroupListItem({Key? key, required this.group, required this.responseAction}) : super(key: key);

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.group.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("Admin"),
                        Text(widget.group.admin!.name),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Members"),
                              Text(widget.group.membersCount.toString()),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Records"),
                              Text(widget.group.recordsCount.toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    child: const Text("Edit"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return GroupCreateEdit(group: widget.group, responseAction: widget.responseAction, edit: true);
                          }
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    child: const Text("Members"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupMembers(slug: widget.group.slug)));
                    },
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    child: const Text("Records"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupRecords(slug: widget.group.slug)));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
