import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/invitation.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/pages/invitations/invitation_list_item.dart';

class Invitations extends StatefulWidget {
  const Invitations({Key? key}) : super(key: key);

  @override
  State<Invitations> createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {

  bool pageLoading = true;
  List<Invitation> invitations = [];
  
  @override
  void initState() {
    getInvitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: pageLoading ? Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height - 150,
          child: const SpinKitRotatingPlain(
            color: Colors.blue,
            size: 50.0,
          ),
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Invitation list",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index == invitations.length) {
                    return Container(
                      child: invitations.isNotEmpty ? const Icon(Icons.drag_handle_outlined) : Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: const Text(
                          "No invitations found!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return InvitationListItem(invitation: invitations[index], responseAction: getInvitations);
                },
                itemCount: invitations.length + 1,
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> getInvitations() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "invitation/list", null, null);
    setState(() {
      if(basicResponse.response == "success"){
        invitations = List<Invitation>.from(basicResponse.data.map((x) => Invitation.fromJson(x)));
      }
      pageLoading = false;
    });
  }
}
