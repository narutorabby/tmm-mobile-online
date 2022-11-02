import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackmymoney/pages/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0.25)
  ));
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);


  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Nunito',
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.only(bottom: 0),
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
          fontFamily: 'Nunito',
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.only(bottom: 0),
          )
      ),
      home: const SplashScreen(),
    );
  }
}
