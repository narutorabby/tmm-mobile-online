import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/user.dart';
import 'package:trackmymoney/pages/root.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/google_api.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/services/local_storage.dart';
import 'package:trackmymoney/widgets/user_suggestion.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late FToast fToast;
  bool googleLoading = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 240.0,
              pinned: true,
              title: const Text("Track My Money", style: TextStyle(fontWeight: FontWeight.bold)),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.white,
                  child: Image.asset(
                    "assets/images/landing_bg_1.jpg",
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(FontAwesomeIcons.user, size: 30, color: Colors.blueAccent),
                      title: Text("Individual"),
                      subtitle: Text("Track individual incomes, expenses and debts!"),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.users, size: 30, color: Colors.blueAccent),
                      title: Text("Group"),
                      subtitle: Text("Track group contributions and bills!"),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.globe, size: 30, color: Colors.blueAccent),
                      title: Text("Online"),
                      subtitle: Text("Watch your information from anywhere!"),
                    )
                  ],
                ),
              ),
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/landing_bg_2.jpg"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const UserSuggestion()
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text("ABOUT", style: TextStyle(fontSize: 18)),
                    ListTile(
                      leading: Image(image: AssetImage("assets/images/logo.png")),
                      title: Text("Track My Money"),
                      subtitle: Text("Track My Money is an easy-to-use daily income, expanse and debt tracker mobile app for everyone. It can be used for both individual and/or a group of people. And it's totally free of cost."),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      title: Text("Individual"),
                      subtitle: Text("With this application you can keep track of your all individual incomes, expenses and debts."),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      title: Text("Group"),
                      subtitle: Text("With this application you can keep track of all the contributions and bills for a group of people."),
                    ),
                    Divider(thickness: 1, height: 40),
                    Text("WORD FROM DEVELOPER", style: TextStyle(fontSize: 18)),
                    ListTile(
                      leading: Image(image: AssetImage("assets/images/developer.png")),
                      title: Text("Don't like ads?"),
                      subtitle: Text("So does the developer. That's why this application is ad-free. So no advertisement, no annoying pop-ups."),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(FontAwesomeIcons.google),
        label: const Text("Continue with Google", style: TextStyle(fontSize: 16)),
        onPressed: googleToken,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> googleToken() async {
    await GoogleApi.signin().then((result){
      result?.authentication.then((googleKey){
        signin(googleKey.accessToken);
      }).catchError((err){
        Helpers.showToast(fToast, "error", "Could not signed up via Google!");
      });
    }).catchError((err){
      Helpers.showToast(fToast, "error", "Could not signed up via Google!");
    });
  }

  Future<void> signin(String? token) async {
    dynamic inputData = {
      "token": token,
    };
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("POST", "authenticate", null, null, inputData);

    if(basicResponse.response == "success"){
      Map<String, dynamic> userMap = basicResponse.data;
      User user = User.fromJson(userMap);

      String currentSession = jsonEncode(user.toJson());
      setCurrentSession(currentSession);
    }
    else{
      Helpers.showToast(fToast, basicResponse.response, basicResponse.message);
      setState(() {
        googleLoading = false;
      });
    }
  }

  Future<void> setCurrentSession(String sessionData) async {
    await LocalStorage.setStorageData("current_session", sessionData);
    setState(() {
      googleLoading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Root()));
  }
}