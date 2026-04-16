import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/screens/features_student/models/notifications/detail_notification_model.dart';
import 'package:stipres/screens/features_student/models/notifications/notification_model.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class DetailNotificationScreen extends StatelessWidget {
  final NotificationModel notif;

  const DetailNotificationScreen({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String iconPath;

    switch (notif.type) {
      case NotificationType.presensiGagal:
        backgroundColor = Colors.red;
        iconPath = 'assets/icons/ic_warning.png';
        break;
      case NotificationType.presensiBerhasil:
        backgroundColor = Colors.green;
        iconPath = 'assets/icons/ic_presence.png';
        break;
      case NotificationType.presensiAkanHabis:
        backgroundColor = Colors.blue;
        iconPath = 'assets/icons/ic_time.png';
        break;
      case NotificationType.pengumuman:
        backgroundColor = Colors.orange;
        iconPath = 'assets/icons/ic_announcement.png';
        break;
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 0,
        left: 0,
        right: 0,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: styles.getTextField(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifikasi",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue),
                  ),
                  IconButton(
                    icon: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: blueColor, // Background color
                        shape: BoxShape.circle, // Makes the background circular
                      ),
                      child: Icon(
                        Icons.close,
                        color: whiteColor, // Icon color
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                        Image.asset(notif.iconAssetPath!, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notif.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: styles.getTextColor(context)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif.message,
                          style: TextStyle(
                              fontSize: 13,
                              color: styles.getTextColor(context)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notif.time!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _generateDetailMessage(notif),
                  style: TextStyle(
                    fontSize: 14,
                    color: styles.getTextColor(context).withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateDetailMessage(NotificationModel notif) {
    final user = notif.namaUser ?? "User";
    final tanggal = notif.tanggal ?? "-";
    final jam = notif.jam ?? "-";
    final matkul = notif.mataKuliah ?? "-";

    switch (notif.type) {
      case NotificationType.presensiBerhasil:
        return "Hai, $user!\n\n"
            "Terima kasih telah melakukan presensi pada tanggal $tanggal, pukul $jam. "
            "Presensi Anda telah tercatat untuk mata kuliah $matkul.";
      case NotificationType.presensiGagal:
        return "Hai, $user!\n\n"
            "Kami mendeteksi kendala pada presensi Anda tanggal $tanggal, pukul $jam "
            "untuk mata kuliah $matkul. Mohon hubungi admin program studi untuk bantuan lebih lanjut.";
      case NotificationType.presensiAkanHabis:
        return "Hai, $user!\n\n"
            "Presensi mata kuliah $matkul hampir ditutup. "
            "Segera lakukan presensi sebelum batas waktu berakhir.";
      case NotificationType.pengumuman:
        return "Hai, $user!\n\n"
            "${notif.message}";
    }
  }
}
