import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_controller.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/screens/reusable/failed_dialog.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class EditPresensiDialog extends StatefulWidget {
  final String presensisId;
  final String awal;
  final String akhir;
  EditPresensiDialog(
      {super.key,
      required this.presensisId,
      required this.awal,
      required this.akhir});

  @override
  State<EditPresensiDialog> createState() => _EditPresensiDialogState();
}

class _EditPresensiDialogState extends State<EditPresensiDialog> {
  final _controller = Get.find<PresenceController>();

  @override
  void initState() {
    super.initState();
    _controller.setInitialTime(widget.awal, widget.akhir);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: styles.getTextField(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        "Edit Presensi",
        style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: styles.getTextColor(context)),
      ),
      content: SizedBox(
        width: 300, // Ganti ini sesuai kebutuhan kamu
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return _buildTimePickerField(
                label: "Jam Awal",
                selectedTime: _controller.jamAwal.value,
                onTimePicked: (picked) => _controller.jamAwal.value = picked,
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              return _buildTimePickerField(
                label: "Jam Akhir",
                selectedTime: _controller.jamAkhir.value,
                onTimePicked: (picked) => _controller.jamAkhir.value = picked,
              );
            })
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("CANCEL", style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          onPressed: () async {
            if (_controller.validateUpdate(widget.awal, widget.akhir) == true) {
              final isConflictFree =
                  await _controller.checkPresence(widget.presensisId) == true;
              if (isConflictFree) {
                (await _controller.updatePresence(widget.presensisId));
              } else {
                showFailedDialog(
                  context: context,
                  title: "Presensi gagal diubah!",
                  subtitle: "Terjadi kesalahan saat mengunggah data",
                  gifAssetPath: 'assets/gif/failed_animation.gif',
                  onDetailPressed: () =>
                      Get.toNamed("/lecturer/notification-screen"),
                );
              }
            }
          },
          child: const Text("SUBMIT",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay> onTimePicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(color: blueColor)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );
            if (picked != null) {
              onTimePicked(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: styles.getTextField(context),
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime?.format(context) ?? '',
                  style: GoogleFonts.plusJakartaSans(
                      color: styles.getTextColor(context)),
                ),
                const Icon(Icons.access_time, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
