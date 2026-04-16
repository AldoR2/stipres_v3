import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/account/biometric_controller.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class SidikJari extends StatefulWidget {
  SidikJari({Key? key}) : super(key: key);

  @override
  State<SidikJari> createState() => _SidikJariState();
}

class _SidikJariState extends State<SidikJari> {
  var height, width;
  final _controller = Get.find<BiometricController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context)
        .size
        .width; // Pastikan variabel width terdefinisi
    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeader(title: "Sidik Jari"),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/ic_fingerprint3.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Akses STIPRES dengan cara yang aman dan mudah menggunakan sidik jari',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            color: Color.fromARGB(255, 161, 161, 161),
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors
                              .grey[300], // Atau sesuaikan dengan tema kamu
                          indent: 5, // Margin kiri
                          endIndent: 5, // Margin kanan
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Sidik Jari',
                      style: TextStyle(
                        fontSize: 16,
                        color: blueColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return InkWell(
                            onTap: () {
                              _controller.toggleBiometric(
                                  !_controller.isBiometricEnabled.value);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/icons/ic_fingerprint2.png',
                                            height: 30,
                                            width: 30),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            "Login dengan sidik jari",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: styles
                                                    .getTextColor(context)),
                                            overflow: TextOverflow
                                                .ellipsis, // Tambahkan jika perlu memotong teks panjang
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Transform.scale(
                                          scale: 0.75,
                                          child: Switch(
                                            value: _controller
                                                .isBiometricEnabled.value,
                                            onChanged: (bool newValue) {
                                              _controller
                                                  .toggleBiometric(newValue);
                                            },
                                            activeColor: Color.fromARGB(
                                                255, 30, 136, 228),
                                            activeTrackColor: Color.fromARGB(
                                                255, 189, 222, 251),
                                            inactiveThumbColor: Colors.grey,
                                            inactiveTrackColor: Color.fromARGB(
                                                255, 224, 224, 224),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
