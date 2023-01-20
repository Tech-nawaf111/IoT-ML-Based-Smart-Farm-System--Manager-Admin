import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Expenses_Income/pages/Main_exp_imp.dart';
import '../../Notifications/Notification_Screen.dart';
import '../../controllers/MenuController.dart';
import '../../user_management/all_users.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {

  static Page page() => MaterialPage<void>(child: MainScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/bloc_logo_small.png"),
            ),

            DrawerListTile(
              title: "Expenses & Income",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>     SummaryPage()),
                );

              },
            ),


            DrawerListTile(
              title: "Accept Profiles",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AllUsers()),
                );
              },
            ),
            DrawerListTile(
              title: "Notification",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const NotificationsScreen()),
                );


              },
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
