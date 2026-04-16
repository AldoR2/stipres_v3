import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:stipres/screens/reusable/upload_data_dialog.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class LoadingPopup extends StatefulWidget {
  const LoadingPopup({super.key});

  @override
  _LoadingPopupState createState() => _LoadingPopupState();
}

class _LoadingPopupState extends State<LoadingPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _timeoutTimer = Timer(const Duration(seconds: 20), () {
      if (mounted && (Get.isDialogOpen ?? false)) {
        Get.back();
        Get.back();
        showUploadDialog(
            context: context,
            title: "Timeout",
            subtitle: "Operasi terlalu lama, coba lagi.",
            gifAssetPath: "assets/gif/failed_animation.gif");
        return;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: styles.getTextField(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 60,
          height: 60,
          child: SpinKitSquareCircle(
            color: Colors.blue,
            size: 50.0,
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
