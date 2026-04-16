import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/home/notification_controller.dart';
import 'package:stipres/screens/features_student/home/notifications/detail_notification_screen.dart';
import 'package:stipres/screens/features_student/models/notifications/detail_notification_model.dart';
import 'package:stipres/screens/features_student/models/notifications/notification_model.dart';
import 'package:stipres/screens/features_student/widgets/cards/notification_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedCategory = 'Semua';
  final _controller = Get.find<NotificationController>();

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

    return Scaffold(
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
                                  height: 150),
                              const SizedBox(height: 20),
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
                                    builder: (_) =>
                                        DetailNotificationScreen(notif: notif),
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
    );
  }
}
