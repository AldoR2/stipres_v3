import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/account/settings_controller.dart';
import 'package:stipres/screens/features_student/account/bantuan.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/dialog_theme_helper.dart';
import 'package:stipres/theme/theme_controller.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class Pengaturan extends StatefulWidget {
  Pengaturan({Key? key}) : super(key: key);

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  var height, width;
  final _controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context)
        .size
        .width; // Pastikan variabel width terdefinisi
    return Obx(() => Scaffold(
          backgroundColor: styles.getMainColor(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: width,
                      height: 110,
                      decoration: BoxDecoration(
                        color: styles.getBlueColor(context),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/bgheader.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                final role = GetStorage().read('role');

                                if (role == 'dosen') {
                                  Get.offAllNamed("/lecturer/base-screen");
                                } else if (role == 'mahasiswa') {
                                  Get.offAllNamed("/student/base-screen");
                                }
                              },
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/icons/ic_back.png',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Pengaturan",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -44,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 44,
                        color: styles.getBlueColor(context),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Pengaturan Aplikasi',
                          style: TextStyle(
                            fontSize: 16,
                            color: blueColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Divider(height: 20, color: Color(0xFFDADADA)),
                      Container(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                _controller.checkAvalaiblityBiometric();
                              },
                              borderRadius: BorderRadius.circular(
                                  10), // opsional, supaya ripple-nya lebih bagus
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal:
                                        4.0), // ⬅️ memperluas area klik secara vertikal
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/icons/ic_fingerprint.png',
                                        height: 30,
                                        width: 30),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sidik Jari",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  styles.getTextColor(context)),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Login dengan sidik jari",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 161, 161, 161),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 30, 136, 228),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(1.0),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                () {
                                  _controller.toggleNotification(
                                      !_controller.isNotificationEnabled.value);
                                };
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        'assets/icons/ic_notification.png',
                                        height: 30,
                                        width: 30),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Notifikasi",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: styles
                                                    .getTextColor(context)),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            "Pengingat notifikasi",
                                            style: blackTextStyle.copyWith(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 161, 161, 161),
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left:
                                                  100), // Ganti angkanya sesuai kebutuhan
                                          child: Transform.scale(
                                              scale: 0.75,
                                              child: Obx(() {
                                                return Switch(
                                                  value: _controller
                                                      .isNotificationEnabled
                                                      .value,
                                                  onChanged: (bool newValue) {
                                                    _controller
                                                        .toggleNotification(
                                                            newValue);
                                                  },
                                                  activeColor: Color.fromARGB(
                                                      255, 30, 136, 228),
                                                  activeTrackColor:
                                                      Color.fromARGB(
                                                          255, 189, 222, 251),
                                                  inactiveThumbColor:
                                                      Colors.grey,
                                                  inactiveTrackColor:
                                                      Color.fromARGB(
                                                          255, 224, 224, 224),
                                                );
                                              })),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                final themeController =
                                    Get.find<ThemeController>();

                                String? selectedTheme;
                                switch (themeController.currentTheme) {
                                  case ThemeMode.dark:
                                    selectedTheme = "Gelap";
                                    break;
                                  case ThemeMode.light:
                                    selectedTheme = "Cerah";
                                    break;
                                  case ThemeMode.system:
                                  default:
                                    selectedTheme = "Default";
                                    break;
                                }

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final themeController =
                                        Get.find<ThemeController>();

                                    final isDarkMode =
                                        themeController.currentTheme ==
                                            ThemeMode.dark;

                                    return Theme(
                                      data: isDarkMode
                                          ? customDarkDialogTheme(blueColor)
                                          : customLightDialogTheme(blueColor),
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            title: Text(
                                              "Pilih Tema",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  children: [
                                                    "Default",
                                                    "Cerah",
                                                    "Gelap"
                                                  ].map((option) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4),
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          splashColor: blueColor
                                                              .withOpacity(0.2),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedTheme =
                                                                  option;
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        6),
                                                            child: Row(
                                                              children: [
                                                                Radio<String>(
                                                                  value: option,
                                                                  groupValue:
                                                                      selectedTheme,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      selectedTheme =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  option,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Batal",
                                                    style: TextStyle(
                                                        color: blueColor)),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (selectedTheme ==
                                                      "Gelap") {
                                                    themeController
                                                        .setThemeMode(
                                                            ThemeMode.dark);
                                                  } else if (selectedTheme ==
                                                      "Cerah") {
                                                    themeController
                                                        .setThemeMode(
                                                            ThemeMode.light);
                                                  } else {
                                                    themeController
                                                        .setThemeMode(
                                                            ThemeMode.system);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: blueColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                ),
                                                child: Text(
                                                  "Simpan",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        'assets/icons/ic_personalisasi.png',
                                        height: 30,
                                        width: 30),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Personalisasi",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  styles.getTextColor(context)),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Atur tema",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 161, 161, 161),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () {
                                Get.to(Bantuan());
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Image.asset('assets/icons/ic_help.png',
                                        height: 30, width: 30),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Bantuan",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  styles.getTextColor(context)),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Ketentuan layanan, kebijakan privasi",
                                          style: blackTextStyle.copyWith(
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 161, 161, 161),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 30, 136, 228),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(1.0),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
