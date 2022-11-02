import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/models/record_paginated.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/widgets/record_create.dart';
import 'package:trackmymoney/widgets/record_filter.dart';
import 'package:trackmymoney/widgets/record_list_item.dart';

class RecordList extends StatefulWidget {
  final bool isGroup;
  const RecordList({Key? key, this.isGroup = false}) : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {

  bool pageLoading = true;
  String dateTo = "";
  String dateFrom = "";
  String type = "Any";

  late RecordPaginated recordPaginated;
  late List<Record> records;
  int currentPage = 1;
  final scrollController = ScrollController();
  late bool loadingMore;

  @override
  void initState() {
    records = [];
    loadingMore = false;
    getRecords();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        setState(() {
          loadingMore = true;
          currentPage++;
        });
        getRecords();
      }
    });
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.isGroup ? "Group records" : "Personal records",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.filter_list),
                    label: const Text("Filter"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                          builder: (BuildContext context) {
                            return RecordsFilter(
                              currentFromDate: dateFrom,
                              currentToDate: dateTo,
                              currentType: type,
                              sendFilterDataBack: getFilteredRecords,
                              isGroup: widget.isGroup,
                            );
                          }
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index == records.length) {
                    return Container(
                      child: records.isNotEmpty ? const Icon(Icons.drag_handle_outlined) : Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: const Text(
                          "No records matches your search terms",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return RecordListItem(record: records[index], responseAction: resetFilters);
                },
                itemCount: records.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        elevation: 10,
        children: [
          SpeedDialChild(
            label: widget.isGroup ? "Create bill" : "Create expense",
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            child: const Icon(Icons.add_card_rounded),
            onTap: () {
              createRecord(widget.isGroup ? "Bill" : "Expense");
            },
          ),
          SpeedDialChild(
            label: widget.isGroup ? "Create contribution" : "Create income",
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w500),
            child: const Icon(Icons.playlist_add_rounded),
            onTap: () {
              createRecord(widget.isGroup ? "Contribution" : "Income");
            },
          )
        ],
      ),
    );
  }

  Future<void> getRecords() async {
    Map<String, dynamic> params = {
      'type': type,
      'date_from': dateFrom,
      'date_to': dateTo,
      'page': currentPage
    };
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "record/personal", params, null);
    setState(() {
      if(basicResponse.response == "success"){
        recordPaginated = RecordPaginated.fromJson(basicResponse.data);
        if(currentPage == recordPaginated.lastPage){
          currentPage--;
        }
        if(records.length < recordPaginated.total){
          records.addAll(recordPaginated.data);
        }
      }
      pageLoading = false;
    });
  }

  void getFilteredRecords(String newFromDate, String newToDate, String newType){
    setState(() {
      dateFrom = newFromDate;
      dateTo = newToDate;
      type = newType;
      currentPage = 1;
      pageLoading = true;
      records = [];
    });
    getRecords();
  }

  void resetFilters(){
    setState(() {
      type = "Any";
      dateFrom = "";
      dateTo = "";
      pageLoading = true;
      currentPage = 1;
      records = [];
    });
    getRecords();
  }

  void createRecord(String type) {
    showDialog(
        context: context,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RecordCreate(
            type: type,
            responseAction: resetFilters,
          );
        }
    );
  }
}
