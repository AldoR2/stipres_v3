import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_lecturer/home/notification_controller.dart';
import 'package:stipres/screens/features_lecturer/home/notifications/detail_notification_screen.dart';
import 'package:stipres/screens/features_lecturer/models/notifications/detail_notification_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/notification_card.dart';
import 'package:stipres/screens/features_lecturer/models/notifications/notification_model.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedCategory = 'Semua';
  final _controller = Get.find<LecturerNotificationController>();

  // final List<NotificationModel> allNotifications = [
  //   NotificationModel(
  //     title: "Presensi Berhasil Ditambahkan!",
  //     message: "Presensi Anda berhasil direkam.",
  //     time: "Baru saja",
  //     type: NotificationType.presensiBerhasil,
  //     iconAssetPath: "assets/icons/ic_presence.png",
  //     namaUser: "Bagus",
  //     tanggal: "29 Mei 2025",
  //     jam: "08.00 WIB",
  //     mataKuliah: "Struktur Data",
  //   ),

  //   // PRESENSI GAGAL
  //   NotificationModel(
  //     title: "Presensi Gagal Ditambahkan!",
  //     message: "Presensi Anda gagal dilakukan.",
  //     time: "10 menit yang lalu",
  //     type: NotificationType.presensiGagal,
  //     iconAssetPath: "assets/icons/ic_warning.png",
  //     namaUser: "Bagus",
  //     tanggal: "29 Mei 2025",
  //     jam: "10.15 WIB",
  //     mataKuliah: "Basis Data",
  //   ),

  //   NotificationModel(
  //     title: "Presensi Hampir Ditutup!",
  //     message: "Waktu presensi Anda akan segera berakhir.",
  //     time: "30 menit yang lalu",
  //     type: NotificationType.presensiAkanHabis,
  //     iconAssetPath: "assets/icons/ic_time.png",
  //     namaUser: "Bagus",
  //     tanggal: "29 Mei 2025",
  //     jam: "09.00 WIB",
  //     mataKuliah: "Pemrograman Mobile",
  //   ),

  //   NotificationModel(
  //     title: "Perubahan Jadwal!",
  //     message:
  //         "Jadwal perkuliahan minggu ini mengalami perubahan. Silakan cek di menu Jadwal.",
  //     time: "1 jam yang lalu",
  //     type: NotificationType.pengumuman,
  //     iconAssetPath: "assets/icons/ic_announcement.png",
  //     namaUser: "Bagus", // bisa kosong juga
  //   ),

  //   NotificationModel(
  //     title: "Update Keamanan Akun",
  //     message: "Segera ubah password akun Anda untuk menjaga keamanan akun.",
  //     time: "3 jam yang lalu",
  //     type: NotificationType.pengumuman,
  //     iconAssetPath: "assets/icons/ic_announcement.png",
  //     namaUser: "Bagus",
  //   ),
  // ];

  List<NotificationModel> get filteredNotifications {
    if (selectedCategory == 'Semua') return _controller.notificationList;
    return _controller.notificationList.where((notif) {
      if (selectedCategory == 'Presensi') {
        return notif.type == NotificationType.presensiAkanHabis ||
            notif.type == NotificationType.presensiBerhasil ||
            notif.type == NotificationType.presensiGagal;
      } else if (selectedCategory == 'Pengumuman') {
        return notif.type == NotificationType.pengumuman;
      }
      return true; // For 'Semua' or other categories, include all notifications
    }).toList();
  }

  Widget buildCategoryButton(String label) {
    final isSelected = selectedCategory == label;
    final color = isSelected ? Colors.purple : blueColor;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              color: isSelected ? Colors.purple : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context, _controller.notificationList.isNotEmpty); // BENAR
        return false;
      },
      child: Scaffold(
        backgroundColor: styles.getMainColor(context),
        body: Stack(
          children: [
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomHeader(title: "Notifikasi"),
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

                // Filter Buttons
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align ke kiri
                    children: [
                      buildCategoryButton("Semua"),
                      const SizedBox(width: 20), // Spasi antar tombol
                      buildCategoryButton("Presensi"),
                      const SizedBox(width: 20),
                      buildCategoryButton("Pengumuman"),
                    ],
                  ),
                ),

                // Animated List or Empty Placeholder
                Expanded(child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-1, 0), end: Offset.zero)
                          .animate(animation);
                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                    child: filteredNotifications.isEmpty
                        ? Center(
                            key: const ValueKey('empty'),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/icons/ic_noData.png',
                                    height: 120),
                                const SizedBox(height: 16),
                                Text(
                                  "Tidak ada notifikasi",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            key: ValueKey<String>(selectedCategory),
                            padding: const EdgeInsets.fromLTRB(10, 0, 20, 10),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final notif = filteredNotifications[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled:
                                          true, // agar bisa tinggi penuh jika perlu
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      backgroundColor: Colors.white,
                                      builder: (_) => DetailNotificationScreen(
                                          notif: notif),
                                    );
                                  },
                                  child: NotificationCard(notification: notif),
                                ),
                              );
                            },
                          ),
                  );
                })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
