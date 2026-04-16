import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stipres/screens/features_student/models/notifications/detail_notification_model.dart';
import 'package:stipres/screens/features_student/models/notifications/notification_model.dart';
import 'package:stipres/services/student/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController extends GetxController {
  final _box = GetStorage();
  final Logger log = Logger();

  final errorMessage = ''.obs;

  var notificationList = <NotificationModel>[].obs;
  final StudentNotificationService studentNotificationService =
      StudentNotificationService();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    try {
      String mahasiswaId = _box.read("mahasiswa_id").toString();
      log.d("Check mahasiswa Id: $mahasiswaId");
      final result =
          await studentNotificationService.tampilNotifikasi(mahasiswaId);

      if (result.status == "success" && result.data != null) {
        final List<NotificationModel> updatedList =
            result.data!.map((notification) {
          final waktu =
              parseNotificationTime(notification.tanggal!, notification.jam!);
          notification.time = waktu;
          notification.jam = "${notification.jam} WIB";

          if (notification.type == NotificationType.presensiBerhasil) {
            notification.iconAssetPath = "assets/icons/ic_presence.png";
          } else if (notification.type == NotificationType.presensiGagal) {
            notification.iconAssetPath = "assets/icons/ic_warning.png";
          } else if (notification.type == NotificationType.presensiAkanHabis) {
            notification.iconAssetPath = "assets/icons/ic_time.png";
          } else if (notification.type == NotificationType.pengumuman) {
            notification.iconAssetPath = "assets/icons/ic_announcement.png";
          } else {
            notification.iconAssetPath = "assets/icons/ic_announcement.png";
          }

          // if (notification.jam)
          return notification;
        }).toList();
        notificationList.assignAll(updatedList);
      } else {
        errorMessage.value = result.message;
      }
    } catch (e) {
      log.f("Error: $e");
    }
  }

  String parseNotificationTime(String tanggalNotif, String jamNotif) {
    final jakarta = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(jakarta);
    try {
      // Format tanggal dan jam notifikasi
      final tanggal = tanggalNotif; // Contoh: "30 Mei 2025"
      final jam = jamNotif; // "03.50" → "03.50"

      // Parsing tanggal dan jam ke DateTime
      final combinedString = "$tanggal $jam";
      final format = DateFormat("d MMMM yyyy HH.mm", "id_ID");
      final notifDateTime =
          tz.TZDateTime.from(format.parse(combinedString), jakarta);

      final difference = now.difference(notifDateTime);

      if (difference.inMinutes <= 60) {
        return "Baru saja";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} jam yang lalu";
      } else if (difference.inDays == 1) {
        return "Kemarin";
      } else if (difference.inDays == 2) {
        return "Kemarin lusa";
      } else {
        return DateFormat("d MMMM yyyy", "id_ID").format(notifDateTime);
      }
    } catch (e) {
      return "-";
    }
  }
}
