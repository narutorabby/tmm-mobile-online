import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/record.dart';
import 'package:trackmymoney/models/record_paginated.dart';
import 'package:trackmymoney/services/api_manager.dart';

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

  @override
  void initState() {
    records = [];
    getRecords();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        setState(() {
          pageLoading = true;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: pageLoading ? Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height - 150,
            child: const SpinKitRotatingPlain(
              color: Colors.blue,
              size: 50.0,
            ),
          ) : const Text("Personal"),
        ),
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
