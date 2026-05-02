import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/widgets/cards/presence/presenceContent_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/controllers/features_student/home/presence_content_controller.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;
import 'package:stipres/screens/features_student/home/presence/face_recognition_screen.dart';

class PresenceContentScreen extends StatefulWidget {
  PresenceContentScreen({super.key});

  @override
  State<PresenceContentScreen> createState() => _PresenceContentScreenState();
}

class _PresenceContentScreenState extends State<PresenceContentScreen> {
  var height, width;

  final _controller = Get.find<PresenceContentController>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Obx(() {
        return Stack(
          children: [
            Column(
              children: [
                // HEADER
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomHeader(title: "Presensi Mata Kuliah"),
                    Positioned(
                      bottom: -44,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 44,
                        color: styles.getBlueColor(context),
                      ),
                    ),
                    Positioned(
                      bottom: -45,
                      right: 0,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: styles.getMainColor(context),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: (_controller.statusData.value == false)
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/icons/ic_noData.png',
                                    height: 120,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak ada presensi',
                                    style: TextStyle(
                                      color: greyColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Form Presensi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  color: blueColor,
                                ),
                              ),
                              const Divider(
                                  height: 20, color: Color(0xFFDADADA)),

                              MatkulDetailCard(
                                  data: _controller.presence.value),

                              const SizedBox(height: 15),

                              /// ================= RADIO =================
                              RadioListTile<StatusPresensi>(
                                title: Text("Hadir"),
                                value: StatusPresensi.hadir,
                                groupValue: _controller.status.value,
                                onChanged: (value) {
                                  _controller.status.value = value;
                                },
                                activeColor: blueColor,
                              ),

                              RadioListTile<StatusPresensi>(
                                title: Text("Izin"),
                                value: StatusPresensi.ijin,
                                groupValue: _controller.status.value,
                                onChanged: (value) {
                                  _controller.status.value = value;
                                },
                                activeColor: blueColor,
                              ),

                              RadioListTile<StatusPresensi>(
                                title: Text("Sakit"),
                                value: StatusPresensi.sakit,
                                groupValue: _controller.status.value,
                                onChanged: (value) {
                                  _controller.status.value = value;
                                },
                                activeColor: blueColor,
                              ),

                              const SizedBox(height: 15),

                              /// ================= HADIR → DETEKSI WAJAH =================
                              Obx(() {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _controller.status.value ==
                                          StatusPresensi.hadir
                                      ? Column(
                                          key: const ValueKey('hadir'),
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      FaceRecognitionScreen());
                                                },
                                                icon: const Icon(Icons.face,
                                                    color: Colors.white),
                                                label: const Text(
                                                  "Deteksi Wajah",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: blueColor,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "Pastikan Anda berada di sekitar area kampus",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                          ],
                                        )
                                      : const SizedBox(),
                                );
                              }),

                              /// ================= IJIN / SAKIT =================
                              if (_controller.status.value ==
                                      StatusPresensi.ijin ||
                                  _controller.status.value ==
                                      StatusPresensi.sakit) ...[
                                Text("Alasan"),
                                const SizedBox(height: 10),

                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: styles.getTextField(context),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: _controller.alasanController,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      hintText: "*Alasan ketidakhadiran",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                ElevatedButton(
                                  onPressed: () {
                                    _controller.showFileOptions();
                                  },
                                  child: const Text("Upload Bukti"),
                                ),

                                const SizedBox(height: 30),

                                /// ================= SUBMIT =================
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      (!_controller.isSnackbarOpen.value)
                                          ? _controller.submitPresence()
                                          : null;
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blueColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
