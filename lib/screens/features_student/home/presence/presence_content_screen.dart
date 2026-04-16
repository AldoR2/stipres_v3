import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/widgets/cards/presence/presenceContent_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/controllers/features_student/home/presence_content_controller.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

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
                            color: styles.getBlueColor(context)),
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
                                  mainAxisSize: MainAxisSize
                                      .min, // agar tidak memaksa full height
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      textAlign: TextAlign.center,
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
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Divider(
                                    height: 20, color: Color(0xFFDADADA)),
                                MatkulDetailCard(
                                    data: _controller.presence.value),
                                const SizedBox(height: 15),
                                // Status Presensi
                                RadioListTile<StatusPresensi>(
                                  title: Text("Hadir",
                                      style: TextStyle(
                                          color: styles.getTextColor(context))),
                                  value: StatusPresensi.hadir,
                                  groupValue: _controller.status.value,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.status.value = value;
                                    });
                                  },
                                  activeColor: blueColor,
                                ),
                                RadioListTile<StatusPresensi>(
                                  title: Text("Izin",
                                      style: TextStyle(
                                          color: styles.getTextColor(context))),
                                  value: StatusPresensi.ijin,
                                  groupValue: _controller.status.value,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.status.value = value;
                                    });
                                  },
                                  activeColor: blueColor,
                                ),
                                RadioListTile<StatusPresensi>(
                                  title: Text("Sakit",
                                      style: TextStyle(
                                          color: styles.getTextColor(context))),
                                  value: StatusPresensi.sakit,
                                  groupValue: _controller.status.value,
                                  onChanged: (value) {
                                    setState(() {
                                      _controller.status.value = value;
                                    });
                                  },
                                  activeColor: blueColor,
                                ),
                                const SizedBox(height: 15),
                                if (_controller.status == StatusPresensi.ijin ||
                                    _controller.status.value ==
                                        StatusPresensi.sakit) ...[
                                  RichText(
                                    text: TextSpan(
                                      text: "Alasan ",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: styles.getTextColor(context),
                                        fontSize: 15,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "(Jika Tidak Hadir)",
                                          style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color:
                                                  styles.getTextColor(context)),
                                        ),
                                        TextSpan(text: " :"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: styles.getTextField(context),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      controller: _controller.alasanController,
                                      maxLines: 4,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: styles.getTextColor(
                                            context), // Atau styles.getTextColor(context) jika sudah disesuaikan
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "*Alasan ketidakhadiran",
                                        hintStyle: GoogleFonts.plusJakartaSans(
                                          color: styles
                                              .getTextColor(context)
                                              .withOpacity(0.5),
                                          fontSize: 14,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    return Text(
                                      "Maks. ${_controller.jumlahKarakter}/${_controller.maksKarakter} huruf",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _controller.jumlahKarakter >
                                                _controller.maksKarakter
                                            ? Colors.red
                                            : Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _controller.showFileOptions();
                                          },
                                          icon: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Image.asset(
                                              'assets/icons/ic_upload.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          label: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 2),
                                            child: Obx(() {
                                              return Text(
                                                _controller.bukti.value == null
                                                    ? 'Upload Bukti'
                                                    : "Ganti Bukti",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              );
                                            }),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: blueColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '(PNG, JPG, JPEG, PDF, and DOCX, up to 5 MB)',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                                // Submit Button
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 6,
                                      shadowColor: blueColor.withOpacity(0.4),
                                    ),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          );
        }));
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) => const LoadingPopup(),
  );
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Validasi"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
