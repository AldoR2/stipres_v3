import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/account/kebijakan_privasi.dart';
import 'package:stipres/screens/features_student/account/ketentuan_layanan.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';

class Bantuan extends StatelessWidget {
  Bantuan({Key? key}) : super(key: key);
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
              CustomHeader(title: "Bantuan"),
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
                          InkWell(
                            onTap: () {
                              Get.to(KetentuanLayanan());
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
                                  Image.asset(
                                      'assets/icons/ic_ketentuanlayanan.png',
                                      height: 30,
                                      width: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "Ketentuan Layanan",
                                      style: blackTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
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
                              Get.to(KebijakanPrivasi());
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
                                  Image.asset(
                                      'assets/icons/ic_kebijakanprivasi.png',
                                      height: 30,
                                      width: 30),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "Kebijakan Privasi",
                                      style: blackTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
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

  Widget _buildHeader(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: 80,
          decoration: BoxDecoration(
            color: blueColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/bgheader.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(100),
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage('assets/icons/ic_back.png'),
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Bantuan",
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
          child: ClipPath(
            clipper: InvertedQuarterCircleClipper(),
            child: Container(
              width: 40,
              height: 44,
              color:
                  Color.fromARGB(255, 30, 136, 228), // warna abu sesuai gambar
            ),
          ),
        ),
      ],
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
