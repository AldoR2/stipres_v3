import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/account/alamat_email.dart';
import 'package:stipres/screens/features_student/account/sidik_jari.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';

class Akun extends StatelessWidget {
  Akun({Key? key}) : super(key: key);
  var height, width;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context)
        .size
        .width; // Pastikan variabel width terdefinisi
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 251),
      body: Stack(
        children: [
          Column(
            children: [
              CustomHeader(title: "Akun"),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              'Pengaturan Akun',
                              style: TextStyle(
                                fontSize: 16,
                                color: blueColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Divider(height: 20, color: Color(0xFFDADADA)),
                          InkWell(
                            onTap: () {
                              Get.to(AlamatEmail());
                            },
                            borderRadius: BorderRadius.circular(
                                10), // ripple efek yang lebih halus
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0), // memperluas area klik
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/ic_gmail.png',
                                      height: 30, width: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "Verifikasi Akun",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Get.to(SidikJari());
                            },
                            borderRadius: BorderRadius.circular(
                                10), 
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0), // memperluas area klik
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/ic_fingerprint.png',
                                      height: 30, width: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "Login dengan Sidik Jari",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
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
        ],
      ),
    );
  }
}

class InvertedQuarterCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Mulai dari sudut kiri atas
    path.moveTo(0, 0);

    // Garis ke sudut kanan atas
    path.lineTo(size.width, 0);

    // Garis ke sudut kanan bawah
    path.lineTo(size.width, size.height);

    // Arc dari sudut kanan bawah ke kiri atas
    path.arcToPoint(
      Offset(0, 0),
      radius: Radius.circular(size.width),
      clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
