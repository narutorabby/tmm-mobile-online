import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/group.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/widgets/button_loading.dart';

class RecordCreateEdit extends StatefulWidget {

  final String type;
  final bool edit;
  final Group? group;
  final Record? record;
  final Function responseAction;

  const RecordCreateEdit({
    Key? key,
    required this.type,
    required this.responseAction,
    this.group,
    this.record,
    this.edit = false
  }) : super(key: key);

  @override
  State<RecordCreateEdit> createState() => _RecordCreateEditState();
}

class _RecordCreateEditState extends State<RecordCreateEdit> {

  final createFormKey = GlobalKey<FormState>();
  bool loadingData = false;
  bool loadingForm = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int memberId = 0;
  List membersId = [];
  List<Map<String, dynamic>> memberList = [];

  @override
  void initState() {
    if(widget.group != null) {
      loadMemberData();
    }
    if(widget.edit){
      loadingData = true;
      loadRecordData();
    }
    else {
      var now = DateTime.now();
      var formatter = DateFormat('dd-MM-yyyy');
      dateController.text = formatter.format(now);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: loadingData ? SizedBox(
          height: 400,
          child: SpinKitRotatingPlain(
            color: Colors.grey[900],
            size: 50.0,
          ),
        ) : SingleChildScrollView(
          child: Form(
            key: createFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  (widget.edit ? "Edit " : "Create ") + widget.type.toLowerCase(),
                  style: const TextStyle(
                      fontSize: 20
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title*',
                      contentPadding: EdgeInsets.only(bottom: 0),
                    ),
                    validator: (value) {
                      if (value == null || value == "") {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount*',
                            contentPadding: EdgeInsets.only(bottom: 0),
                          ),
                          validator: (value) {
                            if (value == null || value == "") {
                              return 'Required';
                            }
                            if(!Helpers.isNumeric(value)) {
                              return 'Must be a number';
                            }
                            if(double.parse(value) <= 0) {
                              return 'Must be positive';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextFormField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: dateController,
                          decoration: const InputDecoration(
                            labelText: 'Date*',
                            contentPadding: EdgeInsets.only(bottom: 0),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                            return null;
                          },
                          onTap: () {
                            selectDate(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      contentPadding: EdgeInsets.only(bottom: 0),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.group != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(widget.type == "Contribution") Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Member*',
                            contentPadding: EdgeInsets.only(bottom: 0),
                          ),
                          value: memberId,
                          isExpanded: true,
                          onChanged: (newValue) {
                            setState(() {
                              memberId = int.parse(newValue.toString());
                            });
                          },
                          items: memberList.map((member) {
                            return DropdownMenuItem(
                              child: Text(member['name']),
                              value: member['id'],
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value == 0) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      if(widget.type == "Bill") Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: MultiSelectDialogField(
                          onConfirm: (val) {
                            membersId = val;
                          },
                          items: memberList.map((member) {
                            return MultiSelectItem(member['id'], member['name']);
                          }).toList(),
                          initialValue: membersId,
                          validator: (values) {
                            if (values == null || values.isEmpty) {
                              return "Required";
                            }
                            return null;
                          }
                        ),
                      ),
                    ],
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
                        label: const Text("Save"),
                        onPressed: () {
                          if(createFormKey.currentState!.validate()){
                            setState(() {
                              loadingForm = true;
                            });
                            Map<String, dynamic> inputData = {
                              "type": widget.type,
                              "title": titleController.text,
                              "amount": amountController.text,
                              "date": dateController.text,
                              "description": descriptionController.text
                            };
                            if(widget.group != null) {
                              inputData["group_id"] = widget.group!.id;
                              if(widget.type == "Contribution"){
                                inputData["members"] = memberId;
                              }
                              else if(widget.type == "Bill"){
                                inputData["members"] = membersId;
                              }
                            }
                            saveRecord(inputData);
                          }
                        }
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );

    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      dateController
        ..text = DateFormat("dd-MM-yyyy").format(selectedDate)
        ..selection = TextSelection.fromPosition(
            TextPosition(
                offset: dateController.text.length,
                affinity: TextAffinity.upstream
            )
        );
    }
  }

  void loadMemberData() {
    setState(() {
      if(widget.type == "Contribution") {
        memberList.add({'id': 0, 'name': "Select member"});
      }
      for(int i = 0; i < widget.group!.members!.length; i++) {
        Map<String, dynamic> member = {
          'id': widget.group!.members![i].id,
          'name': widget.group!.members![i].name,
        };
        memberList.add(member);
      }
    });
  }

  void loadRecordData() {
    setState(() {
      amountController.text = widget.record!.amount.toStringAsFixed(2);
      dateController.text = Helpers.formatDate(widget.record!.date);
      selectedDate = widget.record!.date;
      titleController.text = widget.record!.title;
      descriptionController.text = widget.record!.description == null ? "" : widget.record!.description.toString();
      if(widget.group != null) {
        if(widget.type == "Contribution"){
          memberId = widget.record!.shares![0].id;
        }
        else if(widget.type == "Bill"){
          membersId = [];
          for(int i = 0; i < widget.record!.shares!.length; i++){
            membersId.add(widget.record!.shares![i].id);
          }
        }
      }
      loadingData = false;
    });
  }

  Future<void> saveRecord(Map<String, dynamic> inputData) async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall(
      "POST",
      widget.edit ? "record/update/${widget.record!.id}" : "record/create",
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
