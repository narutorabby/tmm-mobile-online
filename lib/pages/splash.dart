import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackmymoney/models/user.dart';
import 'package:trackmymoney/pages/home.dart';
import 'package:trackmymoney/pages/root.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/services/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<Offset> animation;

  late FToast fToast;

  @override
  void initState() {
    checkConnectivity();
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    animation = Tween<Offset>(
      begin: const Offset(0.0, -4.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticInOut,
    ));
    fToast = FToast();
    fToast.init(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SlideTransition(
                position: animation,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkConnectivity() async {
    bool internet = await Helpers.checkConnectivity();
    if(internet){
      await Future.delayed(const Duration(seconds: 2));
      localData();
    }
    else{
      Helpers.showToast(fToast, "error", "No internet");
    }
  }

  Future<void> localData() async {
    String? currentSession = await LocalStorage.getStorageData("current_session");
    if(currentSession != null && User.fromJson(jsonDecode(currentSession)).token.isNotEmpty){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Root()));
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }
}
