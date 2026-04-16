import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stipres/controllers/auth/activation_step2_controller.dart';
import 'package:stipres/screens/reusable/reusable_widget.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ActivationAccount2 extends StatelessWidget {
  ActivationAccount2({super.key});

  final _controller = Get.find<ActivationStep2Controller>();

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
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        styles.getLogoImage(context),
                        SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "assets/images/picture_book.png",
                          width: 193,
                          height: 193,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Perubahan Password",
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: styles.getTextColor(context))),
                        const SizedBox(height: 10),
                        Text(
                          "Silahkan masukkan nim dan kode OTP yang dikirim pada",
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: styles.getTextColor(context)),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _controller.maskedEmail(),
                          style: TextStyle(fontSize: 16, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("NIM",
                                  style: blueTextStyle.copyWith(fontSize: 15),
                                  textAlign: TextAlign.left),
                              const SizedBox(
                                height: 7,
                              ),
                              TextField(
                                cursorHeight: 18,
                                controller: _controller.nimController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintText: "E41231261",
                                    hintStyle:
                                        greyTextStyle.copyWith(fontSize: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: blueColor))),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text("Kode OTP",
                                  style: blueTextStyle.copyWith(fontSize: 15),
                                  textAlign: TextAlign.left),
                              const SizedBox(height: 7),
                              PinCodeTextField(
                                controller: _controller.otpController,
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
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 29,
                                  fieldWidth: 51,
                                  inactiveColor: Colors.grey,
                                  activeColor: blueColor,
                                  selectedColor: Colors.blueAccent,
                                ),
                                onCompleted: (value) {
                                  print("Kode OTP: $value");
                                },
                              ),
                              const SizedBox(height: 5),
                              Obx(() {
                                return RichText(
                                  text: TextSpan(
                                    text: "Belum menerima kode? ",
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: styles.getTextColor(context)),
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: GestureDetector(
                                          onTap:
                                              _controller.isButtonEnabled.value
                                                  ? _controller.send
                                                  : null,
                                          child: Text(
                                            _controller.textKirim.value,
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Obx(() {
                                  return ReusableButton(
                                      label: "Berikutnya",
                                      buttonStyle: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          backgroundColor: blueColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          minimumSize:
                                              const Size(double.infinity, 50)),
                                      textStyle: whiteTextStyle.copyWith(
                                          fontSize: 17, fontWeight: bold),
                                      onPressed:
                                          (_controller.isSnackbarOpen.value)
                                              ? null
                                              : () async {
                                                  await _controller.checkOtp();
                                                });
                                })),
                          ],
                        )
                      ],
                    )))
          ],
        ));
  }
}
