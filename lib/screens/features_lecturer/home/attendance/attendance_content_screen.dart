import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_lecturer/models/attendance/attendance_content_model.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/attendance/attendance_content_card.dart';
import 'package:stipres/constants/styles.dart';

class AttendanceContentScreen extends StatefulWidget {
  const AttendanceContentScreen({super.key});

  @override
  State<AttendanceContentScreen> createState() =>
      _AttendanceContentScreenState();
}

class _AttendanceContentScreenState extends State<AttendanceContentScreen>
    with SingleTickerProviderStateMixin {
  late double height, width;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Kehadiran> dataKehadiran = [
    Kehadiran(
      semester: 3,
      matkul: 'Pemrograman Dasar',
      persentase: 100,
      kehadiran: [
        KehadiranItem(label: 'Hadir', jumlah: 1),
        KehadiranItem(label: 'Sakit', jumlah: 1),
        KehadiranItem(label: 'Izin', jumlah: 1),
        KehadiranItem(label: 'Alpa', jumlah: 1),
      ],
    ),
    Kehadiran(
      semester: 3,
      matkul: 'Matematika Diskrit',
      persentase: 100,
      kehadiran: [
        KehadiranItem(label: 'Hadir', jumlah: 1),
        KehadiranItem(label: 'Sakit', jumlah: 1),
        KehadiranItem(label: 'Izin', jumlah: 1),
        KehadiranItem(label: 'Alpa', jumlah: 1),
      ],
    ),
    Kehadiran(
      semester: 3,
      matkul: 'Kewarganegaraan',
      persentase: 100,
      kehadiran: [
        KehadiranItem(label: 'Hadir', jumlah: 1),
        KehadiranItem(label: 'Sakit', jumlah: 1),
        KehadiranItem(label: 'Izin', jumlah: 1),
        KehadiranItem(label: 'Alpa', jumlah: 1),
      ],
    ),
    Kehadiran(
      semester: 3,
      matkul: 'Bahasa Inggris',
      persentase: 100,
      kehadiran: [
        KehadiranItem(label: 'Hadir', jumlah: 1),
        KehadiranItem(label: 'Sakit', jumlah: 2),
        KehadiranItem(label: 'Izin', jumlah: 3),
        KehadiranItem(label: 'Alpa', jumlah: 4),
      ],
    ),
  ];

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

    final filteredKehadiran = dataKehadiran.where((kehadiran) {
      final query = _searchController.text.toLowerCase();
      return kehadiran.matkul.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // HEADER
                  Container(
                    width: width,
                    height: 110,
                    decoration: BoxDecoration(
                      color: blueColor,
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
                                      "Rekap Kehadiran Mata Kuliah",
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
                      color: blueColor,
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    right: 0,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Body
          // Ganti bagian Stack anak kedua:
          Positioned.fill(
            top: 110, // Atur offset agar tidak menabrak header
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'Rekap Kehadiran Semester Ini',
                      style: TextStyle(
                        fontSize: 16,
                        color: blueColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Divider(height: 20, color: Color(0xFFDADADA)),
                  Expanded(
                    child: filteredKehadiran.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/icons/ic_noData.png',
                                  height: 120,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? "Tidak ada data kehadiran"
                                      : "Data mata kuliah tidak ditemukan",
                                  style: TextStyle(
                                    color: greyColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredKehadiran.length,
                            padding: const EdgeInsets.only(top: 0),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: KehadiranCard(
                                  jadwal: filteredKehadiran[index],
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
