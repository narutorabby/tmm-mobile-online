import 'package:flutter/material.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/widgets/button_loading.dart';

class GroupMemberInvite extends StatefulWidget {
  final String slug;

  const GroupMemberInvite({Key? key, required this.slug}) : super(key: key);

  @override
  State<GroupMemberInvite> createState() => _GroupMemberInviteState();
}

class _GroupMemberInviteState extends State<GroupMemberInvite> {

  final formKey = GlobalKey<FormState>();
  bool loadingForm = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              "Invite member",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email*',
                  contentPadding: EdgeInsets.only(bottom: 0),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Email is required';
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
                        icon: loadingForm ? const ButtonLoading() : const Icon(Icons.check),
                        label: const Text("Invite"),
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            setState(() {
                              loadingForm = true;
                            });
                            Map<String, dynamic> inputData = {
                              "group": widget.slug,
                              "email": emailController.text,
                            };
                            invite(inputData);
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

  Future<void> invite(Map<String, dynamic> inputData) async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("POST", "invitation/invite", null, inputData);

    Helpers.showToastNoBuild(basicResponse.response, basicResponse.message);
    setState(() {
      loadingForm = false;
    });

    if(basicResponse.response == "success"){
      Navigator.pop(context);
    }
  }
}
