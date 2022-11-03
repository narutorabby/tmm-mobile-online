import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackmymoney/pages/dashboard.dart';
import 'package:trackmymoney/pages/groups.dart';
import 'package:trackmymoney/pages/invitations.dart';
import 'package:trackmymoney/pages/personal.dart';
import 'package:trackmymoney/pages/profile.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 5);
    tabController.addListener(handleTabSelection);
    super.initState();
  }

  void handleTabSelection() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        icon: Icon(
                          tabController.index == 0 ? Icons.home_rounded : Icons.home_outlined,
                          size: 30,
                        )
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 1 ? Icons.person_rounded : Icons.person_outline_rounded,
                          size: 30,
                        )
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 2 ? Icons.people_alt_rounded : Icons.people_alt_outlined,
                          size: 30,
                        )
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 3 ? Icons.mail_rounded : Icons.mail_outline_rounded,
                          size: 30,
                        )
                      ),
                      Tab(
                        icon: Icon(
                          tabController.index == 4 ? Icons.settings_rounded : Icons.settings_outlined,
                          size: 30,
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: const <Widget>[
                Dashboard(),
                Personal(),
                Groups(),
                Invitations(),
                Profile(),
              ],
            )
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    if (tabController.index == 0) {
      await SystemNavigator.pop();
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        tabController.index = 0;
      });
    });
    return tabController.index == 0;
  }
}