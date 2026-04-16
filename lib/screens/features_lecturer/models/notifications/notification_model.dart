import 'package:stipres/screens/features_lecturer/models/notifications/detail_notification_model.dart';

class NotificationModel {
  final String title;
  final String message;
  String? time;
  final NotificationType type;
  String? iconAssetPath;

  // Properti tambahan
  final String? namaUser;
  final String? tanggal;
  String? jam;
  final String? mataKuliah;

  NotificationModel({
    required this.title,
    required this.message,
    this.time,
    required this.type,
    this.iconAssetPath,
    this.namaUser,
    this.tanggal,
    this.jam,
    this.mataKuliah,
  });

  // Factory constructor untuk membuat model dari JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String,
      message: json['message'] as String,
      // time: json['time'] as String,
      type: _parseNotificationType(json['type'] as String),
      namaUser: json['nama_user'] as String,
      tanggal: json['tanggal'] as String,
      jam: json['jam'] as String,
      mataKuliah: json['mata_kuliah'],
    );
  }
  // // Getter untuk icon berdasarkan type
  // String get iconAssetPath {
  //   switch (type) {
  //     case NotificationType.presensiBerhasil:
  //       return "assets/icons/ic_presence.png";
  //     case NotificationType.presensiGagal:
  //       return "assets/icons/ic_presence_failed.png";
  //     case NotificationType.pengumuman:
  //       return "assets/icons/ic_announcement.png";
  //     default:
  //       return "assets/icons/ic_notification.png";
  //   }
  // }

  // Helper untuk parsing string ke enum NotificationType
  static NotificationType _parseNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'presensiberhasil':
        return NotificationType.presensiBerhasil;
      case 'presensigagal':
        return NotificationType.presensiGagal;
      default:
        return NotificationType.pengumuman;
    }
  }
}
