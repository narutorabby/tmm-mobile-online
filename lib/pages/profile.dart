import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackmymoney/models/basic_response.dart';
import 'package:trackmymoney/models/user.dart';
import 'package:trackmymoney/pages/home.dart';
import 'package:trackmymoney/services/api_manager.dart';
import 'package:trackmymoney/services/helpers.dart';
import 'package:trackmymoney/services/local_storage.dart';
import 'package:trackmymoney/widgets/button_loading.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late User user;
  bool pageLoading = true;
  final formKey = GlobalKey<FormState>();
  bool loadingForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController avatarController = TextEditingController();

  List<String> avatars = [
    "first", "football", "dragon", "smart", "pizza", "ice-cream", "male", "female",
    "male-2", "female-2", "penguin", "jaguar", "viking", "ninja", "anonymous", "scream",
    "iron-man", "simpson", "mario", "walter-white", "male-3", "female-3", "male-4", "female-4",
    "sun", "fire", "wave", "soil"
  ];

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
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
                const Text(
                  "Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name*',
                                contentPadding: EdgeInsets.only(bottom: 0),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: 'Mobile',
                                contentPadding: EdgeInsets.only(bottom: 0),
                              ),
                            ),
                          ),
                          const Text(
                            "Avatar",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: GridView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                              children: <Widget>[
                                for(var avatar in avatars) GestureDetector(
                                  onTap: () => setState(() => avatarController.text = avatar),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(5),
                                    height: 36,
                                    width: 36,
                                    color: avatarController.text == avatar ? Colors.indigoAccent : Colors.transparent,
                                    child: Image.asset("assets/images/avatar/$avatar.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: loadingForm ? const ButtonLoading() : const Icon(Icons.check),
                            label: const Text("Save"),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                            ),
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                setState(() {
                                  loadingForm = true;
                                });
                                Map<String, dynamic> inputData = {
                                  "name": nameController.text,
                                  "mobile": 'mob:' + mobileController.text,
                                  "avatar": avatarController.text,
                                };
                                saveProfile(inputData);
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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

  Future<void> getUser() async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("GET", "user/me", null, null);

    if(basicResponse.response == "success"){
      setState(() {
        user = User.fromJson(basicResponse.data);
        nameController.text = user.name;
        mobileController.text = user.mobile != null ? Helpers.mobileNumber(user.mobile!) : "";
        avatarController.text = user.avatar;
        pageLoading = false;
      });
    }
    else {
      Helpers.showToastNoBuild(basicResponse.response, "Failed to fetch data! Please reload!");
    }
  }

  Future<void> saveProfile(Map<String, dynamic> inputData) async {
    ApiManager apiManager = ApiManager();
    BasicResponse basicResponse = await apiManager.apiCall("POST", "user/update", null, inputData);

    Helpers.showToastNoBuild(basicResponse.response, basicResponse.message);
    setState(() {
      loadingForm = false;
    });
  }

  Future<void> signOut() async {
    await LocalStorage.deleteAllStorageData();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
  }
}
