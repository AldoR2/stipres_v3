import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:stipres/controllers/features_lecturer/home/dashboard_controller.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/schedule_card.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/weeklyCalendar_card.dart';
import 'package:stipres/screens/features_lecturer/widgets/link/allSchedule_link.dart';
import 'package:stipres/screens/features_lecturer/widgets/link/calendar_link.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class DashboardScreenLecturer extends StatefulWidget {
  DashboardScreenLecturer({super.key});

  @override
  State<DashboardScreenLecturer> createState() =>
      _DashboardScreenLecturerState();
}

class _DashboardScreenLecturerState extends State<DashboardScreenLecturer> {
  var height, width;

  final _controller = Get.find<DashboardController>();

  Logger log = Logger();

  Future<void> _refreshData() async {
    await _controller.fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    _controller.fetchSchedule(); // Fetch data saat pertama kali dibuka

    return Obx(() => Scaffold(
          backgroundColor: styles.getMainColor(context),
          body: RefreshIndicator(
            onRefresh: _refreshData, // Fungsi refresh
            color: styles.getBlueColor(context),
            child: Stack(
              children: [
                Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: width,
                          height: 150,
                          decoration: BoxDecoration(
                            color: styles.getBlueColor(context),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/bgheader.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 24, left: 16, right: 16, bottom: 70),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Logo_PantiWaluya.png',
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  "STIKES Panti Waluya Malang",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      onTap: () async {
                                        final result = await Get.toNamed(
                                            "/lecturer/notification-screen");
                                        if (result != null && result is bool) {
                                          setState(() {
                                            _controller.hasNotification.value =
                                                result;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          _controller.hasNotification.value
                                              ? Icons.notifications
                                              : Icons.notifications_none,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_controller.hasNotification.value)
                                    const Positioned(
                                      top: 2,
                                      right: 2,
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -44,
                          right: 0,
                          child: Container(
                            width: 40,
                            height: 44,
                            decoration: BoxDecoration(
                              color: styles.getBlueColor(context),
                            ),
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
                                )),
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 30,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/lecturer/view-profile-screen");
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: styles.getCircleColor(context),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(child: Obx(() {
                                    final imageUrl =
                                        _controller.storedProfile.value;
                                    return (imageUrl.isNotEmpty)
                                        ? FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/icons/ic_profile.jpeg",
                                            image: imageUrl,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/icons/ic_profile.jpeg",
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/icons/ic_profile.jpeg",
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          );
                                  })),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(() {
                                return SizedBox(
                                  width: width * 0.65,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _controller.storedName.value,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _controller.storedNip.value,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          color: blueColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: SingleChildScrollView(
                        physics:
                            const AlwaysScrollableScrollPhysics(), // Pastikan bisa di-scroll
                        child: Container(
                          width: width,
                          decoration: const BoxDecoration(
                            color: Color(0XEDEBFB),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: styles.getMainColor(context),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: "Menu ",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          styles.getTextColor(
                                                              context))),
                                          TextSpan(
                                            text: "Utama",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 180,
                                width: width,
                                child: Container(
                                  color: styles.getMainColor(context),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      children: [
                                        CategoryCard(
                                          title: 'Kehadiran',
                                          items:
                                              _controller.storedKehadiran.value,
                                          imagePath:
                                              'assets/icons/ic_kehadiran.png',
                                          bgColor: const Color.fromARGB(
                                              255, 187, 235, 251),
                                          onTap: () {
                                            Get.toNamed(
                                                "/lecturer/attendance-screen");
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        CategoryCard(
                                          title: 'Presensi',
                                          items:
                                              _controller.storedPresensi.value,
                                          imagePath:
                                              'assets/icons/rekap_kehadiran.png',
                                          bgColor: const Color.fromARGB(
                                              255, 187, 251, 193),
                                          onTap: () {
                                            Get.toNamed(
                                                "/lecturer/presence-screen");
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        CategoryCard(
                                          title: 'Jadwal Mengajar',
                                          items: _controller.storedJadwal.value,
                                          imagePath:
                                              'assets/icons/ic_jadwal_perkuliahan.png',
                                          bgColor: const Color.fromARGB(
                                              255, 251, 232, 187),
                                          onTap: () {
                                            Get.toNamed(
                                                "/lecturer/all-schedule-screen");
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        CategoryCard(
                                          title: 'Kalender Akademik',
                                          items:
                                              _controller.storedKalender.value,
                                          imagePath:
                                              'assets/icons/kalender_akademik.png',
                                          bgColor: const Color.fromARGB(
                                              255, 251, 187, 187),
                                          onTap: () {
                                            Get.toNamed(
                                                "/student/calendar-screen");
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        CategoryCard(
                                          title: 'Perkuliahan Online',
                                          items: _controller
                                              .storedPerkuliahanOnline.value,
                                          imagePath: 'assets/icons/zoom.png',
                                          bgColor: const Color.fromARGB(
                                              255, 187, 191, 251),
                                          onTap: () {
                                            Get.toNamed(
                                                "/lecturer/lecture-screen");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: styles.getMainColor(context),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: "Kalender",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          styles.getTextColor(
                                                              context))),
                                        ],
                                      ),
                                    ),
                                    CalendarLink(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              WeeklyCalendar(),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: styles.getMainColor(context),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: "Jadwal ",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          styles.getTextColor(
                                                              context))),
                                          TextSpan(
                                            text: "Hari Ini",
                                            style: GoogleFonts.plusJakartaSans(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    AllScheduleLink(),
                                  ],
                                ),
                              ),
                              Obx(() {
                                return Container(
                                  alignment: Alignment.center,
                                  color: styles.getMainColor(context),
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: _controller.jadwalList.isEmpty
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 20),
                                            Image.asset(
                                              'assets/icons/ic_noData.png',
                                              height: 120,
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              'Tidak ada jadwal hari ini',
                                              style: greyTextStyle.copyWith(
                                                  fontSize: 15,
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          itemCount:
                                              _controller.jadwalList.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return ScheduleCardLecturer(
                                                jadwal: _controller
                                                    .jadwalList[index]);
                                          },
                                        ),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int items;
  final String imagePath;
  final Color bgColor;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.items,
    required this.imagePath,
    required this.bgColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color.fromARGB(255, 120, 120, 120).withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.1),
        onTap: onTap, // Gunakan onTap dari parameter
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFC8C8C8),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AutoSizeText(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "$items items",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color.fromARGB(255, 98, 98, 98),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipItem extends StatelessWidget {
  final String label;

  const ChipItem({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
