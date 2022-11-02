import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class GroupCreate extends StatefulWidget {
  final Group? group;
  final Function responseAction;
  final bool edit;

  const GroupCreate({Key? key, this.group, required this.responseAction, this.edit = false}) : super(key: key);

  @override
  State<GroupCreate> createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {

  final createFormKey = GlobalKey<FormState>();
  bool loadingData = false;
  bool loadingForm = false;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    if(widget.edit) {
      loadingData = true;
      loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: loadingData ? SizedBox(
        height: 400,
        child: SpinKitRotatingPlain(
          color: Colors.grey[900],
          size: 50.0,
        ),
      ) : Form(
        key: createFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              widget.edit ? "Edit group" : "Create group",
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            const SizedBox(height: 10),
            if(loadingForm) const LinearProgressIndicator(),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
            ),

            Container(
                margin: const EdgeInsets.only(top: 10),
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
                    ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("Save"),
                        onPressed: () {
                          if(createFormKey.currentState!.validate()){
                            setState(() {
                              loadingForm = true;
                            });
                            Map<String, dynamic> inputData = {
                              "name": nameController.text,
                            };
                            saveGroup(inputData);
                          }
                        }
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void loadData() {
    nameController.text = widget.group!.name;
    setState(() {
      loadingData = false;
    });
  }

  Future<void> saveGroup(Map<String, dynamic> inputData) async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall(
        "POST",
        widget.edit ? "group/update/${widget.group!.id}" : "group/create",
        null,
        inputData
    );

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
