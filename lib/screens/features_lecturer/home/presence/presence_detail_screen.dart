import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/presence_detail_controller.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/presence/presence_detail_card.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class PresenceDetailScreen extends StatefulWidget {
  const PresenceDetailScreen({super.key});

  @override
  State<PresenceDetailScreen> createState() => _PresenceDetailScreenState();
}

class _PresenceDetailScreenState extends State<PresenceDetailScreen>
    with SingleTickerProviderStateMixin {
  late double height, width;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final _controller = Get.find<PresenceDetailController>();

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
          final filteredMahasiswa = _controller.studentList.where((nama) {
            final query = _searchController.text.toLowerCase();
            return nama.nama!.toLowerCase().contains(query) ||
                nama.nim!.toLowerCase().contains(query) ||
                nama.keterangan!.toLowerCase().contains(query);
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
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Cari data mahasiswa...',
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
                                          "Presensi Mata Kuliah",
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
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Body Konten
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detail Presensi Mahasiswa',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: blueColor,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120, // Set the desired width
                                    child: Text(
                                      'Program Studi',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: styles.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    _controller.storedProdi.value,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120, // Set the desired width
                                    child: Text(
                                      'Mata Kuliah',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: styles.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    _controller.storedMatkul.value,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120, // Set the desired width
                                    child: Text(
                                      'Jam Presensi',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: styles.getTextColor(context),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    _controller.storedDurasiPresensi.value,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: styles.getTextColor(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(
                                  height: 1, color: Color(0xFFDADADA)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: filteredMahasiswa.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 30),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/ic_noData.png',
                                        height: 120,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _searchController.text.isEmpty
                                            ? "Tidak ada data mahasiswa"
                                            : "Data mahasiswa tidak ditemukan",
                                        style: TextStyle(
                                          color: greyColor,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 150),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredMahasiswa.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: PresenceDetailCard(
                                        mahasiswa:
                                            _controller.studentList[index],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ],
          );
        }));
  }
}
