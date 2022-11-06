import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/group_member.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/pages/group_members/group_member_list_item.dart';
import 'package:trackmymoney/pages/group_members/group_member_invite.dart';

class GroupMembers extends StatefulWidget {
  final String slug;
  const GroupMembers({Key? key, required this.slug}) : super(key: key);

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {

  bool pageLoading = true;
  List<GroupMember> groupMembers = [];

  @override
  void initState() {
    getGroupMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
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
                      "Group members",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == groupMembers.length) {
                        return Container(
                          child: groupMembers.isNotEmpty ? const Icon(Icons.drag_handle_outlined) : Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: const Text(
                              "No groups found!",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }
                      return GroupMemberListItem(groupMember: groupMembers[index], responseAction: getGroupMembers);
                    },
                    itemCount: groupMembers.length + 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.email_outlined),
          onPressed: () {
            showDialog(
                context: context,
                barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return GroupMemberInvite(slug: widget.slug);
                }
            );
          },
        )
    );
  }

  Future<void> getGroupMembers() async {
    Map<String, dynamic> params = {
      "slug": widget.slug
    };
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "member/list", params, null);
    setState(() {
      if(basicResponse.response == "success"){
        groupMembers = List<GroupMember>.from(basicResponse.data.map((x) => GroupMember.fromJson(x)));
      }
      pageLoading = false;
    });
  }
}
