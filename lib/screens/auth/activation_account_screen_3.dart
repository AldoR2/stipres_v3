import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/auth/activation_step3_controller.dart';
import 'package:stipres/screens/reusable/reusable_widget.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ActivationAccount3 extends StatelessWidget {
  ActivationAccount3({super.key});

  final activation3C = Get.find<ActivationStep3Controller>();

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
                    margin: EdgeInsets.only(top: 60),
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
                                    width: 140,
                                    height: 140,
                                  ),
                                  SizedBox(height: 20),
                                  Text("Ubah Password",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: styles.getTextColor(context))),
                                  const SizedBox(height: 10),
                                  Text("Silahkan masukkan password baru",
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: styles.getTextColor(context))),
                                  const SizedBox(height: 40),
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
                                        Text("Password baru",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                        const SizedBox(height: 7),
                                        Obx(
                                          () => TextField(
                                            obscureText: !activation3C
                                                .isPasswordVisible.value,
                                            controller:
                                                activation3C.passwordController,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            onChanged: (value) {
                                              activation3C.startTimerPassword();
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    activation3C.checkVisible();
                                                  },
                                                  icon: Icon(activation3C
                                                          .isPasswordVisible
                                                          .value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                              hintText: (!activation3C
                                                      .isPasswordVisible.value)
                                                  ? "********"
                                                  : "12345678",
                                              errorText: (activation3C
                                                          .valuePassword
                                                          .value ==
                                                      true)
                                                  ? activation3C
                                                      .passwordErrorMessage
                                                      .value
                                                  : null,
                                              hintStyle: greyTextStyle.copyWith(
                                                  fontSize: 15),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: blueColor)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text("Konfirmasi password",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                        const SizedBox(height: 7),
                                        Obx(
                                          () => TextField(
                                            obscureText: !activation3C
                                                .isPasswordVisible2.value,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            controller: activation3C
                                                .confirmPasswordController,
                                            onChanged: (value) {
                                              activation3C
                                                  .startTimerConfirmPassword();
                                            },
                                            decoration: InputDecoration(
                                              hintText: (!activation3C
                                                      .isPasswordVisible2.value)
                                                  ? "********"
                                                  : "12345678",
                                              errorText: (activation3C
                                                          .valueConfirmPassword
                                                          .value ==
                                                      true)
                                                  ? activation3C
                                                      .confirmPasswordErrorMessage
                                                      .value
                                                  : null,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    activation3C
                                                        .checkVisible2();
                                                  },
                                                  icon: Icon(activation3C
                                                          .isPasswordVisible2
                                                          .value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                              hintStyle: greyTextStyle.copyWith(
                                                  fontSize: 15),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                      color: blueColor)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
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
                                              label: "Submit",
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
                                                          double.infinity, 50)),
                                              textStyle:
                                                  whiteTextStyle.copyWith(
                                                      fontSize: 17,
                                                      fontWeight: bold),
                                              onPressed: (activation3C
                                                      .isSnackbarOpen.value)
                                                  ? null
                                                  : () {
                                                      activation3C.validate();
                                                    },
                                            );
                                          }))
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
