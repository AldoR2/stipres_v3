import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/attendances/attendance_controller.dart';
import 'package:stipres/screens/features_lecturer/home/attendance/search_attendance_screen.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/attendance/attendance_card.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late double height, width;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final _controller = Get.find<AttendanceController>();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });

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
          final filteredMahasiswa = _controller.studentList.where((nama) {
            final query = _searchController.text.toLowerCase();
            return nama.nama.toLowerCase().contains(query) ||
                nama.nim.toLowerCase().contains(query) ||
                nama.email.toLowerCase().contains(query);
          }).toList();
          return Stack(
            children: [
              Column(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextField(
                                                controller: _searchController,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                        color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Cari data mahasiswa...',
                                                  hintStyle: GoogleFonts
                                                      .plusJakartaSans(
                                                          color:
                                                              Colors.grey[600]),
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
                                        _animationController.forward();
                                      } else {
                                        _animationController.reverse();
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

                  // Konten Data Mahasiswa
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Mahasiswa',
                            style: TextStyle(fontSize: 16, color: blueColor),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Program Studi',
                                    style: TextStyle(
                                        color: styles.getTextColor(context)),
                                  )),
                              Text(
                                ' : ',
                                style: TextStyle(
                                    color: styles.getTextColor(context)),
                              ),
                              SizedBox(width: 10),
                              Obx(() {
                                return Text(
                                    _controller.prodiMap[
                                            _controller.selectedProdi.value] ??
                                        "-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: styles.getTextColor(context)));
                              })
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              SizedBox(
                                  width: 120,
                                  child: Text('Semester',
                                      style: TextStyle(
                                          color:
                                              styles.getTextColor(context)))),
                              Text(' : ',
                                  style: TextStyle(
                                      color: styles.getTextColor(context))),
                              SizedBox(width: 10),
                              Obx(() {
                                return Text(
                                  _controller.selectedSemester.value.isEmpty
                                      ? "-"
                                      : _controller.selectedSemester.value,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: styles.getTextColor(context),
                                  ),
                                );
                              })
                            ],
                          ),
                          const Divider(height: 20, color: Color(0xFFDADADA)),

                          // Scroll hanya untuk daftar card
                          Expanded(
                            child: filteredMahasiswa.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/icons/ic_noData.png',
                                            height: 120),
                                        const SizedBox(height: 16),
                                        Text(
                                          _searchController.text.isEmpty
                                              ? "Tidak ada data mahasiswa"
                                              : "Data mahasiswa tidak ditemukan",
                                          style: TextStyle(
                                              color: greyColor,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredMahasiswa.length,
                                    padding: EdgeInsets.only(top: 0),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: MahasiswaCard(
                                            mahasiswa:
                                                filteredMahasiswa[index]),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: styles.getTextField(context),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return CariDataScreen(
                            onSearch: (semester, prodi) {
                              _controller.selectedSemester.value = semester;
                              _controller.selectedProdi.value = prodi;
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(2, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            "Cari Data",
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
