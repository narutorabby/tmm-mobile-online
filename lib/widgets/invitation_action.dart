import 'package:flutter/material.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/widgets/button_loading.dart';

class InvitationAction extends StatefulWidget {
  final int id;
  final String action;
  final Function responseAction;
  const InvitationAction({Key? key, required this.id, required this.action, required this.responseAction}) : super(key: key);

  @override
  State<InvitationAction> createState() => _InvitationActionState();
}

class _InvitationActionState extends State<InvitationAction> {
  bool loadingForm = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.action + " invitation"),
      content: Text(widget.action + " this invitation! Are you sure?"),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        ElevatedButton.icon(
          icon: loadingForm ? const ButtonLoading() : const Icon(Icons.check),
          label: const Text('Yes'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () {
            setState(() {
              loadingForm = true;
            });
            invitationAction();
          },
        ),
      ],
    );
  }

  Future<void> invitationAction() async {
    Map<String, dynamic> inputData = {
      "status": widget.action == "Accept" ? "Accepted" : widget.action == "Decline" ? "Declined" : widget.action == "Cancel" ? "Canceled" : "",
    };
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("POST", "invitation/invitation-action/${widget.id}", null, inputData);

    Helpers.showToastNoBuild(basicResponse.response, basicResponse.message);
    setState(() {
      loadingForm = false;
    });

    if(basicResponse.response == "success"){
      Navigator.pop(context);
      widget.responseAction();
    }
  }
}
