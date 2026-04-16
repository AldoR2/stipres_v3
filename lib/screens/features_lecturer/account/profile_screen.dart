import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/account/profile_controller.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_lecturer/home/dashboard_controller.dart';
import 'package:stipres/theme/dialog_theme_helper.dart';
import 'package:stipres/theme/theme_controller.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ProfileScreenLecturer extends StatefulWidget {
  ProfileScreenLecturer({Key? key}) : super(key: key);

  @override
  State<ProfileScreenLecturer> createState() => _ProfileScreenLecturerState();
}

class _ProfileScreenLecturerState extends State<ProfileScreenLecturer> {
  var height, width;

  final _controller = Get.find<ProfileController>();
  final dashboardCon = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          styles.getMainColor(context), // Set background putih ke seluruh layar
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // HEADER
                  Container(
                    width: width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: styles.getBlueColor(context),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bgheader.png'),
                        fit: BoxFit.cover, // agar penuh
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 70),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Logo_PantiWaluya.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                            width: 3), // jarak kecil antara logo dan teks
                        Expanded(
                          child: Text(
                            "STIKES Panti Waluya Malang",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: () async {
                                  final result = await Get.toNamed(
                                      "/lecturer/notification-screen");

                                  if (result != null && result is bool) {
                                    setState(() {
                                      dashboardCon.hasNotification.value =
                                          result;
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    dashboardCon.hasNotification.value
                                        ? Icons.notifications
                                        : Icons.notifications_none,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),

                            // Badge merah
                            if (dashboardCon.hasNotification.value)
                              const Positioned(
                                top: 2,
                                right: 2,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: -44,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 44,
                      decoration: BoxDecoration(
                        color: styles.getBlueColor(context), // warna ungu muda
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -45,
                    right: 0,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: styles.getMainColor(context),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                          ) // warna ungu muda
                          ),
                    ),
                  ),

                  // PROFIL (TENGAH)
                  Positioned(
                    top: 105,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: styles.getCircleColor(context),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(child: Obx(() {
                                final foto = _controller.storedProfile.value;
                                return (foto.isNotEmpty)
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/icons/ic_profile.jpeg",
                                        image: foto,
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, url, error) {
                                          return Image.asset(
                                            "assets/icons/ic_profile.jpeg",
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        "assets/icons/ic_profile.jpeg",
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.cover,
                                      );
                              })),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60), // Jarak agar profil tidak tertutup

              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: styles.getMainColor(context),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 48, left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama Lengkap",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: styles.getTextColor(context),
                              ),
                              textAlign: TextAlign.start),
                          const SizedBox(height: 7),
                          Container(
                            height: 50,
                            width: width,
                            decoration: BoxDecoration(
                              color: styles.getTextField(context),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(() {
                                    return Text(
                                      _controller.storedName.value,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 161, 161, 161),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  })),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text("NIP",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: styles.getTextColor(context),
                              ),
                              textAlign: TextAlign.start),
                          const SizedBox(height: 7),
                          Container(
                            height: 50,
                            width: width,
                            decoration: BoxDecoration(
                              color: styles.getTextField(context),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(() {
                                    return Text(
                                      _controller.storedNip.value,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 161, 161, 161),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  })),
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text("Email",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: styles.getTextColor(context),
                              ),
                              textAlign: TextAlign.start),
                          const SizedBox(height: 7),
                          Container(
                            height: 50,
                            width: width,
                            decoration: BoxDecoration(
                              color: styles.getTextField(context),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(() {
                                    return Text(
                                      _controller.storedEmail.value,
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 161, 161, 161),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  })),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(
                                        "/lecturer/view-profile-screen");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: blueColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/ic_view.png',
                                          height: 20, width: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        "Lihat Profil",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                              width: width,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: styles.getTextField(context),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed("/student/settings-screen");
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/icons/ic_settings.png',
                                            height: 30,
                                            width: 30),
                                        SizedBox(width: 16),
                                        Text("Pengaturan",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: styles
                                                    .getTextColor(context)),
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      _controller.changePassword();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/icons/ic_gantipassword.png',
                                            height: 30,
                                            width: 30),
                                        SizedBox(width: 16),
                                        Text("Ganti Password",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: styles
                                                    .getTextColor(context)),
                                            textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    _showLogoutDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: redColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/ic_logout.png',
                                          height: 20, width: 20),
                                      SizedBox(width: 10),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: bold,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  final _controller = Get.find<ProfileController>();
  _controller.checkBiometric();
  final themeController = Get.find<ThemeController>();

  final isDarkMode = themeController.currentTheme == ThemeMode.dark;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: isDarkMode
            ? customDarkDialogTheme(Colors.blue)
            : customLightDialogTheme(Colors.blue),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'KONFIRMASI LOGOUT',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Apakah anda yakin ingin keluar?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  Obx(() {
                    final showBiometric =
                        _controller.isBiometricAvailable.value &&
                            _controller.isBiometricEnabled.value;

                    return showBiometric
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Simpan informasi login anda',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: _controller.saveLoginInfo.value,
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    onChanged: (bool? value) {
                                      _controller.saveLoginInfo.value =
                                          value ?? true;
                                      print(_controller.saveLoginInfo.value);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox.shrink();
                  }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
