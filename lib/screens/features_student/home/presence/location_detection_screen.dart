import 'package:flutter/material.dart';
import 'package:stipres/screens/features_student/home/presence/presence_result_screen.dart';

class LocationDetectionScreen extends StatelessWidget {
  const LocationDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: 'Presensi Mata Kuliah'),

            /// ================= BACKGROUND / BODY KOSONG =================
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
