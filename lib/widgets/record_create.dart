import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';

class RecordCreate extends StatefulWidget {

  final String groupId;
  final String type;
  final bool edit;
  final Record? record;
  final Function responseAction;

  const RecordCreate({
    Key? key,
    required this.type,
    required this.responseAction,
    this.record,
    this.groupId = "",
    this.edit = false
  }) : super(key: key);

  @override
  State<RecordCreate> createState() => _RecordCreateState();
}

class _RecordCreateState extends State<RecordCreate> {

  final createFormKey = GlobalKey<FormState>();
  bool loadingData = false;
  bool loadingForm = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int memberId = 0;
  late List membersId;
  List<dynamic> memberList = [];

  @override
  void initState() {
    if(widget.edit){
      loadingData = true;
      loadData();
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
                const SizedBox(height: 10),
                if(loadingForm) const LinearProgressIndicator(),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title*',
                      contentPadding: EdgeInsets.only(bottom: 0),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Title is required';
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
                            if (value != null && double.parse(value) <= 0) {
                              return 'Amount must be greater than zero';
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
                              return 'Date is required';
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
                        print(["newValue", newValue]);
                        // memberId = newValue;
                      });
                    },
                    items: memberList.map((member) {
                      return DropdownMenuItem(
                        child: Text(member['name']),
                        value: member['id'],
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Member is required';
                      }
                      return null;
                    },
                  ),
                ),
                if(widget.type == "Bill") Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MultiSelectFormField(
                    title: const Text("Members*"),
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Member is required';
                      }
                      return null;
                    },
                    dataSource: memberList,
                    textField: 'name',
                    valueField: 'id',
                    hintWidget: const Text('Tap to select members'),
                    initialValue: membersId,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        membersId = value;
                      });
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
                              "type": widget.type,
                              "title": titleController.text,
                              "amount": amountController.text,
                              "date": dateController.text,
                              "description": descriptionController.text
                            };
                            if(widget.groupId != "") {
                              inputData["group_id"] = widget.groupId;
                            }
                            if(widget.type == "Contribution"){
                              inputData["member"] = memberId;
                            }
                            else if(widget.type == "Bill"){
                              inputData["members"] = membersId;
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

  void loadData() {
    setState(() {
      amountController.text = widget.record!.amount.toStringAsFixed(2);
      dateController.text = Helpers.formatDate(widget.record!.date);
      selectedDate = widget.record!.date;
      titleController.text = widget.record!.title;
      descriptionController.text = widget.record!.description == null ? "" : widget.record!.description.toString();
      // if(widget.type == "Contribution"){
      //   memberId = widget.record.shares[0].userId;
      // }
      // else if(widget.type == "Bill"){
      //   membersId = [];
      //   for(int i = 0; i < widget.record.shares.length; i++){
      //     membersId.add(widget.record.shares[i].userId);
      //   }
      // }
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
