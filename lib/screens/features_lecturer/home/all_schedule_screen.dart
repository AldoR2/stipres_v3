import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/all_schedule_controller.dart';
import 'package:stipres/models/lecturers/all_schedule_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/allSchedule_card.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AllScheduleScreen extends StatefulWidget {
  const AllScheduleScreen({super.key});

  @override
  State<AllScheduleScreen> createState() => _AllScheduleScreenState();
}

class _AllScheduleScreenState extends State<AllScheduleScreen>
    with SingleTickerProviderStateMixin {
  late double height, width;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final _controller = Get.find<LecturerAllScheduleController>();

  // final List<AllScheduleModel> JadwalSemester = [
  //   AllScheduleModel(
  //     day: 'Senin',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF123',
  //     mataKuliah: 'Matematika Dasar',
  //     semester: 'Semester 1',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  //   AllScheduleModel(
  //     day: 'Senin',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF124',
  //     mataKuliah: 'Logika Algoritma',
  //     semester: 'Semester 1',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  //   AllScheduleModel(
  //     day: 'Selasa',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF125',
  //     mataKuliah: 'Pemrograman Dasar',
  //     semester: 'Semester 1',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  //   AllScheduleModel(
  //     day: 'Rabu',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF126',
  //     mataKuliah: 'Basis Data',
  //     semester: 'Semester 3',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  //   AllScheduleModel(
  //     day: 'Jumat',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF127',
  //     mataKuliah: 'Kewirausahaan',
  //     semester: 'Semester 5',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  //   AllScheduleModel(
  //     day: 'Jumat',
  //     waktu: '08:00 - 10:00',
  //     kodeMatkul: 'TIF128',
  //     mataKuliah: 'Agama',
  //     semester: 'Semester 1',
  //     lokasi: 'Ruang 101',
  //     durasi: '2 Jam',
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild saat teks berubah
    });

    // Setup animation controller untuk fade-in/fade-out
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: styles.getMainColor(context),
        body: Obx(() {
          final filteredSchedule = _controller.scheduleList.where((jadwal) {
            final query = _searchController.text.toLowerCase();
            return jadwal.namaMatkul!.toLowerCase().contains(query);
          }).toList();

          Map<String, List<LecturerAllScheduleModel>> jadwalPerHari = {};
          for (var jadwal in filteredSchedule) {
            jadwalPerHari.putIfAbsent(jadwal.hari!, () => []).add(jadwal);
          }

          final List<String> daysOfWeek = [
            'Senin',
            'Selasa',
            'Rabu',
            'Kamis',
            'Jumat',
            'Sabtu',
          ];

          final query = _searchController.text.toLowerCase();

          final filteredDays = daysOfWeek.where((day) {
            final jadwals = jadwalPerHari[day] ?? [];
            if (query.isEmpty)
              return true; // Kalau tidak mencari, tampilkan semua hari
            return jadwals.any(
                (jadwal) => jadwal.namaMatkul!.toLowerCase().contains(query));
          }).toList();

          return Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: width,
                    height: 110,
                    decoration: BoxDecoration(
                      color: styles.getBlueColor(context),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/bgheader.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(100),
                            customBorder: const CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/icons/ic_back.png',
                                height: 18,
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isSearching
                                ? FadeTransition(
                                    opacity: _animation,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: width * 0.65,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextField(
                                            controller: _searchController,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: 'Cari mata kuliah...',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[600]),
                                              border: InputBorder.none,
                                            ),
                                            autofocus: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Jadwal Mengajar",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isSearching = !_isSearching;
                                  if (_isSearching) {
                                    _animationController
                                        .forward(); // Fade-in saat search aktif
                                  } else {
                                    _animationController
                                        .reverse(); // Fade-out saat search non-aktif
                                    _searchController.clear();
                                  }
                                });
                              },
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  'assets/icons/ic_search.png',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Corner Bottom-Right U Shape
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

              // Body
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'Jadwal Mengajar Semester Ini',
                        style: TextStyle(
                          fontSize: 16,
                          color: blueColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Divider(height: 20, color: Color(0xFFDADADA)),
                    Expanded(
                      child: Container(
                        child: filteredSchedule.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // Center the content vertically
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic_noData.png',
                                      height: 120,
                                    ),
                                    const SizedBox(
                                        height:
                                            8), // Add spacing between the image and text
                                    Text(
                                      "Tidak ada mata kuliah ditemukan.",
                                      style: TextStyle(
                                        color: greyColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.only(top: 0),
                                children: filteredDays.map((day) {
                                  final jadwal = (jadwalPerHari[day] ?? [])
                                      .where((jadwal) {
                                    final query =
                                        _searchController.text.toLowerCase();
                                    return jadwal.namaMatkul!
                                        .toLowerCase()
                                        .contains(query);
                                  }).toList();

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: blueColor,
                                            fontFamily: 'poppins',
                                          ),
                                        ),
                                      ),
                                      if (jadwal.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/ic_noData.png',
                                                  height: 60,
                                                  width: 60,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Tidak ada jadwal",
                                                  style: TextStyle(
                                                    color: greyColor,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        Column(
                                          children: jadwal.map((item) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child:
                                                  AllScheduleCard(jadwal: item),
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                      ),
                    )
                  ],
                ),
              ))
            ],
          );
        }));
  }
}
