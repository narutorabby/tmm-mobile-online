import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/widgets/group_create_edit.dart';
import 'package:trackmymoney/widgets/group_list_item.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with TickerProviderStateMixin {

  bool pageLoading = true;
  List<Group> groups = [];

  @override
  void initState() {
    getGroups();
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
                "Group list",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index == groups.length) {
                    return Container(
                      child: groups.isNotEmpty ? const Icon(Icons.drag_handle_outlined) : Container(
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
                  return GroupListItem(group: groups[index], responseAction: getGroups);
                },
                itemCount: groups.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return GroupCreateEdit(responseAction: getGroups);
              }
          );
        },
      )
    );
  }

  Future<void> getGroups() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "group/list", null, null);
    setState(() {
      if(basicResponse.response == "success"){
        groups = List<Group>.from(basicResponse.data.map((x) => Group.fromJson(x)));
      }
      pageLoading = false;
    });
  }
}
