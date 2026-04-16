import 'package:flutter/material.dart';
import 'package:stipres/screens/features_lecturer/account/profile_screen.dart';
import 'package:stipres/screens/features_lecturer/home/dashboard.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/styles/icons.dart';
import 'package:stipres/styles/size.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class BaseScreenLecturer extends StatefulWidget {
  const BaseScreenLecturer({Key? key}) : super(key: key);

  @override
  _BaseScreenLecturerState createState() => _BaseScreenLecturerState();
}

class _BaseScreenLecturerState extends State<BaseScreenLecturer> {
  int _selectedIndex = 0;

  static final List<Widget Function()> _widgetOptions = <Widget Function()>[
    () => DashboardScreenLecturer(),
    () => ProfileScreenLecturer(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex](),
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
