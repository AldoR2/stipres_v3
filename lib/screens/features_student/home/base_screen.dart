import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:stipres/controllers/features_student/base_screen_controller.dart';
import 'package:stipres/screens/features_student/account/profile_screen.dart';
import 'package:stipres/screens/features_student/home/dashboard.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/styles/icons.dart';
import 'package:stipres/styles/size.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final BaseScreenController _controller = Get.find<BaseScreenController>();
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DashboardScreenStudent(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: styles.getTextField(context),
        currentIndex: _selectedIndex,
        elevation: 0,
        selectedItemColor: styles.getItemSelected(context),
        unselectedItemColor: styles.getTextColor(context),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: blueColor,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: styles.getTextColor(context),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
