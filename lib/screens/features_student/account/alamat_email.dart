import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/account/ganti_email.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:flutter/gestures.dart';

class AlamatEmail extends StatelessWidget {
  AlamatEmail({Key? key}) : super(key: key);
  var height, width;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context)
        .size
        .width; // Pastikan variabel width terdefinisi
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 235, 251),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeader(title: "Verifikasi Akun"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/ic_email.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Email membantu anda untuk mengelola akun, email tidak dapat dilihat oleh pengguna lain',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            color: Color.fromARGB(255, 161, 161, 161),
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(height: 25, color: Color(0xFFDADADA)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Alamat Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: blueColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: "johndoe@gmail.com",
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: greyTextStyle.copyWith(fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: blueColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8), // Jarak antara TextField dan icon
                      Material(
                        color: Colors
                            .transparent, // Supaya background tetap transparan
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              100), // Opsional: untuk ripple bulat
                          onTap: () {
                            Get.to(GantiEmail());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Memberi ruang agar ripple terlihat
                            child: Icon(Icons.edit, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // ini membuat vertikal rata tengah
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Image.asset(
                          'assets/icons/ic_warning2.png', // ganti dengan path gambarmu
                          width: 14,
                          height: 14,
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'Apakah ini masih email anda? ',
                            style: blackTextStyle.copyWith(
                              fontSize: 11,
                              color: Color.fromARGB(255, 161, 161, 161),
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(
                                text: 'Konfirmasi',
                                style: blackTextStyle.copyWith(
                                  fontSize: 11,
                                  color: blueColor,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("Konfirmasi diklik");
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
