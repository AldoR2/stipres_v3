import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/auth/activation_step1_controller.dart';
import 'package:stipres/screens/reusable/reusable_widget.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ActivationAccount1 extends StatelessWidget {
  ActivationAccount1({super.key});

  final _controller = Get.find<ActivationStep1Controller>();

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
                                    "assets/images/picture_book.png",
                                    width: 193,
                                    height: 193,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Validasi Akun!",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: styles.getTextColor(context))),
                                  const SizedBox(height: 10),
                                  Text("Silahkan masukkan alamat email anda",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: styles.getTextColor(context))),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Email",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                        const SizedBox(height: 7),
                                        TextField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          controller:
                                              _controller.emailController,
                                          decoration: InputDecoration(
                                            hintText: "johndoe@gmail.com",
                                            hintStyle: greyTextStyle.copyWith(
                                                fontSize: 15),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                borderSide: BorderSide(
                                                    color: blueColor)),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Obx(() {
                                            return ReusableButton(
                                                label: "Berikutnya",
                                                buttonStyle:
                                                    ElevatedButton.styleFrom(
                                                        elevation: 5,
                                                        backgroundColor:
                                                            blueColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        minimumSize: const Size(
                                                            double.infinity,
                                                            50)),
                                                textStyle:
                                                    whiteTextStyle.copyWith(
                                                        fontSize: 17,
                                                        fontWeight: bold),
                                                onPressed: (_controller
                                                        .isSnackbarOpen.value)
                                                    ? null
                                                    : () {
                                                        _controller
                                                            .checkEmail();
                                                      });
                                          }))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "Sudah validasi akun? ",
                                        style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                styles.getTextColor(context))),
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: GestureDetector(
                                          child: Text(
                                            "Login",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 14),
                                          ),
                                          onTap: () {
                                            Get.back();
                                          },
                                        ))
                                  ]))
                                ],
                              )),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
