import 'package:flutter/material.dart';
import 'package:trackmymoney/models/group_member.dart';
import 'package:trackmymoney/services/helpers.dart';

class GroupMemberListItem extends StatefulWidget {
  final GroupMember groupMember;
  final Function responseAction;

  const GroupMemberListItem({Key? key, required this.groupMember, required this.responseAction}) : super(key: key);

  @override
  State<GroupMemberListItem> createState() => _GroupMemberListItemState();
}

class _GroupMemberListItemState extends State<GroupMemberListItem> {

  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          setState(() {
            showMore = !showMore;
          });
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
                            widget.groupMember.user!.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Mob: " + (widget.groupMember.user!.mobile != null ? Helpers.mobileNumber(widget.groupMember.user!.mobile!) : "-")),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                              "Joined At",
                              style: TextStyle(fontSize: 10)
                          ),
                          Text(
                              Helpers.formatDate(widget.groupMember.joinedAt),
                              style: const TextStyle(fontSize: 16)
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: showMore,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("Email"),
                          Text(widget.groupMember.user!.email),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text("Total contribution"),
                                Text(Helpers.formatCurrency(widget.groupMember.totalContribution)),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text("Total bill"),
                                Text(Helpers.formatCurrency(widget.groupMember.totalBill)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
        )
      ),
    );
  }
}
