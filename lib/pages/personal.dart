import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/models/record_paginated.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/widgets/record_list_item.dart';

class Personal extends StatefulWidget {
  const Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {

  bool pageLoading = true;
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
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Personal records",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  return RecordListItem(record: records[index]);
                },
                itemCount: records.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        elevation: 10,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.filter_list),
            onTap: () {},
            label: 'Filter list',
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w500),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_card_rounded),
            onTap: () {},
            label: 'Create expense',
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w500),
          ),
          SpeedDialChild(
            child: const Icon(Icons.playlist_add_rounded),
            onTap: () {},
            label: 'Create income',
            labelStyle:
            const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Future<void> getRecords() async {
    Map<String, dynamic> params = {
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
}
