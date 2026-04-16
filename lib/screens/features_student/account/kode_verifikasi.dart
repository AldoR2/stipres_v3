import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class KodeVerifikasi extends StatelessWidget {
  KodeVerifikasi({Key? key}) : super(key: key);
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
            CustomHeader(title: "Konfirmasi Email"),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/ic_emailVerifikasi.png', // Ganti dengan path sesuai gambar kamu
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Kode Verifikasi Telah Dikirim!',
                          style: TextStyle(
                            fontSize: 16,
                            color: blueColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Kami telah mengirimkan kode verifikasi ke email: ',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      color: Color.fromARGB(255, 161, 161, 161),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'iz****@gmail.com ',
                    style: greenTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(225, 22, 130, 0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Silahkan masukkan 4 kode digit dibawah ini:',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      color: Color.fromARGB(255, 161, 161, 161),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 7),
                        PinCodeTextField(
                          appContext: context,
                          length: 4, // Jumlah kotak OTP
                          // controller: otpController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Hanya angka
                          ],
                          obscureText: false,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 36,
                            fieldWidth: 70,
                            inactiveColor: Colors.grey,
                            activeColor: blueColor,
                            selectedColor: blueColor,
                          ),
                          textStyle: TextStyle(
                            color: const Color.fromARGB(
                                255, 0, 0, 0), // Warna teks saat user mengetik
                            fontSize: 18, // Optional: ubah ukuran font
                            fontWeight:
                                FontWeight.bold, // Optional: tebalkan angka
                          ),
                          onCompleted: (value) {
                            print("Kode OTP: $value");
                          },
                        ),
                        // const SizedBox(height: ),
                        RichText(
                          text: TextSpan(
                            text: "Belum menerima kode? ",
                            style: blackTextStyle.copyWith(fontSize: 12),
                            children: [
                              TextSpan(
                                text: "Kirim ulang",
                                style: blueTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: ElevatedButton(
          onPressed: () {
            Get.to(KodeVerifikasi()); // Ganti dengan navigasi yang sesuai
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: blueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            "Kirim  ",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
