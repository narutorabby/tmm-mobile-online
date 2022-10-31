import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmymoney/pages/home.dart';
import 'package:trackmymoney/services/local_storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(FontAwesomeIcons.signOutAlt),
                  label: const Text(
                    "Signout",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Signout?'),
                        content: const Text('Are you sure you want to signout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                            ),
                            onPressed: () => signOut(),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await LocalStorage.deleteAllStorageData();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  }
}
