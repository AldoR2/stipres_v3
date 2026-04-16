import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/auth/forget_password_step1_controller.dart';
import 'package:stipres/screens/reusable/reusable_widget.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ForgetPassword1 extends StatelessWidget {
  ForgetPassword1({super.key});

  final emailController = TextEditingController();
  final forgetPass1C = Get.find<ForgetPasswordStep1Controller>();

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
                                    width: 193,
                                    height: 193,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text("Perubahan Password",
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
                                  const SizedBox(height: 30),
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
                                        Text("Email",
                                            style: blueTextStyle.copyWith(
                                                fontSize: 15),
                                            textAlign: TextAlign.left),
                                        const SizedBox(height: 7),
                                        TextField(
                                            style: TextStyle(
                                                color: styles
                                                    .getTextColor(context)),
                                            controller: emailController,
                                            keyboardType:
                                                TextInputType.visiblePassword,
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
                                            )),
                                        const SizedBox(height: 40),
                                        Obx(
                                          () => ElevatedButton(
                                            onPressed: (forgetPass1C
                                                    .isSnackbarOpen.value)
                                                ? null
                                                : () async {
                                                    await forgetPass1C.sendOtp(
                                                        emailController.text
                                                            .trim());
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
                                                    fontSize: 17)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Sudah memiliki akun? ",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: styles
                                                  .getTextColor(context))),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "Login",
                                          style: linkTextStyle.copyWith(
                                              fontSize: 14),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
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
