import 'package:flutter/material.dart';
import 'package:trackmymoney/models/invitation.dart';
import 'package:trackmymoney/widgets/invitation_action.dart';

class InvitationListItem extends StatefulWidget {
  final Invitation invitation;
  final Function responseAction;

  const InvitationListItem({Key? key, required this.invitation, required this.responseAction}) : super(key: key);

  @override
  State<InvitationListItem> createState() => _InvitationListItemState();
}

class _InvitationListItemState extends State<InvitationListItem> {

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.invitation.group!.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      widget.invitation.status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor(widget.invitation.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("GROUP"),
                        const SizedBox(height: 10),
                        Text(
                          widget.invitation.group!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("USER"),
                        const SizedBox(height: 10),
                        Text(
                          widget.invitation.user!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.invitation.status == "Pending",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    widget.invitation.received ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.close),
                              label: const Text("Decline"),
                              onPressed: () {
                                invitationAction("Decline");
                              },
                            )
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text("Accept"),
                              onPressed: () {
                                invitationAction("Accept");
                              },
                            )
                        ),
                      ],
                    ) : OutlinedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text("Cancel"),
                      onPressed: () {
                        invitationAction("Cancel");
                      },
                    )
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    if(status == "Accepted") {
      return Colors.green.shade600;
    }
    else if(status == "Declined" || status == "Canceled") {
      return Colors.red.shade600;
    }
    return Colors.blue.shade600;
  }

  void invitationAction(String action) {
    showDialog(
        context: context,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InvitationAction(
              id: widget.invitation.id,
              action: action,
              responseAction: widget.responseAction
          );
        }
    );
  }
}
