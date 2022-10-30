import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helpers {
  static Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static String formatCurrency(double number){
    return NumberFormat.simpleCurrency(name: 'BDT', decimalDigits: 2).format(number);
  }

  static String formatDate(String rawDate){
    return Jiffy(rawDate).format("dd-MM-yyyy");
  }

  static String formatDateNthLong(String rawDate){
    return Jiffy(rawDate).format("do MMM yyyy");
  }

  static String formatHolidayDate(String rawDate){
    return Jiffy(rawDate).format("EEEE, do MMM yyyy");
  }

  static showToast(FToast fToast, String response, String message, {int duration = 4}){
    Color bgColor = Colors.orange.withOpacity(0.75);
    IconData icon = Icons.info_outline;
    if(response == "success"){
      bgColor = Colors.green.withOpacity(0.98);
      icon = Icons.check_circle_outlined;
    }
    else if(response == "error"){
      bgColor = Colors.red.withOpacity(0.98);
      icon = Icons.cancel_outlined;
    }

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: bgColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration),
    );
  }

  static showToastNoBuild(String response, String message, {int duration = 4}){
    Color bgColor = Colors.blue.withOpacity(0.98);
    if(response == "success"){
      bgColor = Colors.green.withOpacity(0.98);
    }
    else if(response == "error"){
      bgColor = Colors.red.withOpacity(0.98);
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
    );
  }
}