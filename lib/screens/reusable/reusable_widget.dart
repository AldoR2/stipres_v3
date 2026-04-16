import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ReusableButton extends StatelessWidget {
  const ReusableButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.buttonStyle,
      required this.textStyle});

  final String label;
  final void Function()? onPressed;
  final ButtonStyle buttonStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(label, style: textStyle));
  }
}

class ReusableBackground extends StatelessWidget {
  const ReusableBackground({super.key});

  double getBigDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 3 / 8;
  double getMediumDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 4 / 20;
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 4 / 100;
  double getLengthVector(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 15;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -getBigDiameter(context) / 2,
          top: -getBigDiameter(context) / 3,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1E88E4)),
          ),
        ),
        Positioned(
          left: -getBigDiameter(context) / 1.3,
          bottom: MediaQuery.of(context).size.height / 1.9,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFAFF00)),
          ),
        ),
        Positioned(
          right: -getBigDiameter(context) / 1.5,
          top: MediaQuery.of(context).size.height / 1.9,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFAFF00)),
          ),
        ),
        Positioned(
          left: -getBigDiameter(context) / 2,
          bottom: -getBigDiameter(context) / 2,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1E88E4)),
          ),
        ),
        Positioned(
            top: getSmallDiameter(context) * 3.5,
            right: getSmallDiameter(context) * 5.3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFFFAFF00)),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height / 3,
            left: getSmallDiameter(context) * 3,
            child: Container(
              width: getSmallDiameter(context),
              height: getSmallDiameter(context),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF1E88E4)),
            )),
        Positioned(
            top: -getLengthVector(context) / 9.9,
            right: getLengthVector(context) * 0.9,
            child: SizedBox(
              width: getLengthVector(context),
              height: getLengthVector(context),
              child: SvgPicture.asset("assets/images/Vector.svg"),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height / 2.5,
            left: -getLengthVector(context) / 9.9,
            child: SizedBox(
              width: getLengthVector(context),
              height: getLengthVector(context),
              child: SvgPicture.asset(
                "assets/images/Vector_2.svg",
              ),
            )),
        Positioned(
            bottom: MediaQuery.of(context).size.height / 2.5,
            right: -getLengthVector(context) / 5,
            child: SizedBox(
              width: getLengthVector(context),
              height: getLengthVector(context),
              child: SvgPicture.asset(
                "assets/images/Vector_2.svg",
              ),
            )),
        Positioned(
            bottom: getLengthVector(context) * 0.9,
            left: -getLengthVector(context) / 2,
            child: SizedBox(
              width: getLengthVector(context),
              height: getLengthVector(context),
              child: SvgPicture.asset("assets/images/Vector.svg"),
            )),
      ],
    );
  }
}

void showLoadingPopup() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
  Get.dialog(
      Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withAlpha(4),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Mohon Tunggu",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      barrierDismissible: false,
      name: "loading_popup");
}

void hideLoadingPopup() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
