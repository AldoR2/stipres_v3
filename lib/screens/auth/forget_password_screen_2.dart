import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stipres/controllers/auth/forget_password_step2_controller.dart';
import 'package:stipres/screens/reusable/reusable_widget.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ForgetPassword2 extends StatelessWidget {
  ForgetPassword2({super.key});

  final forgetPass2C = Get.find<ForgetPasswordStep2Controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: styles.getMainColor(context),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ReusableBackground(),
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        styles.getLogoImage(context),
                        Expanded(
                          child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/reset_password_1.png",
                                    width: 160,
                                    height: 160,
                                  ),
                                  SizedBox(height: 20),
                                  Text("Perubahan Password",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: styles.getTextColor(context))),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text:
                                                "Silahkan masukkan nim dan kode OTP yang telah dikirimkan pada ",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: styles
                                                    .getTextColor(context)),
                                          ),
                                          TextSpan(
                                            text: forgetPass2C.maskedEmail(),
                                            style: blackTextStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: bold,
                                                color: const Color.fromARGB(
                                                    255, 0, 177, 6)),
                                          )
                                        ])),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Kode OTP",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                        const SizedBox(height: 7),
                                        PinCodeTextField(
                                          textStyle: TextStyle(
                                              color:
                                                  styles.getTextColor(context)),
                                          controller:
                                              forgetPass2C.otpController,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            fieldHeight: 35,
                                            fieldWidth: 51,
                                            inactiveColor: Colors.grey,
                                            activeColor: blueColor,
                                            selectedColor: Colors.blueAccent,
                                          ),
                                          onCompleted: (value) {
                                            print("Kode OTP: $value");
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Obx(
                                          () => RichText(
                                              text: TextSpan(
                                            text: "Belum menerima kode? ",
                                            style: blackTextStyle.copyWith(
                                                fontSize: 15),
                                            children: [
                                              WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: GestureDetector(
                                                    onTap: forgetPass2C
                                                            .isButtonEnabled
                                                            .value
                                                        ? forgetPass2C.send
                                                        : null,
                                                    child: Text(
                                                      forgetPass2C
                                                          .textKirim.value,
                                                      style: blueTextStyle
                                                          .copyWith(
                                                              fontSize: 15),
                                                    ),
                                                  )),
                                            ],
                                          )),
                                        ),
                                        const SizedBox(height: 20),
                                        Obx(
                                          () => ElevatedButton(
                                            onPressed: (forgetPass2C
                                                    .isSnackbarOpen.value)
                                                ? null
                                                : () async {
                                                    await forgetPass2C
                                                        .checkOtp();
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              backgroundColor: blueColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              minimumSize: const Size(
                                                  double.infinity, 50),
                                            ),
                                            child: Text("Berikutnya",
                                                style: whiteTextStyle.copyWith(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
