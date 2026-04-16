import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_student/home/presence_controller.dart';
import 'package:stipres/screens/features_student/widgets/cards/presence/presence_card.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({super.key});

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen>
    with TickerProviderStateMixin {
  late double height, width;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final PresenceController _controller = Get.find<PresenceController>();

  late AnimationController _animationController;
  late Animation<double> _animation;

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
    _controller.fetchPresence();

    return Scaffold(
        backgroundColor: styles.getMainColor(context),
        body: Obx(() {
          final filteredPresensi = _controller.presenceList.where((presensi) {
            final query = _searchController.text.toLowerCase();
            return presensi.namaMatkul.toLowerCase().contains(query);
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
                                onTap: () => Navigator.pop(context),
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
                            // Animated Search Bar dengan fade
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: _isSearching
                                    ? FadeTransition(
                                        opacity: _animation,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            width: width * 0.70,
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
                                                      'Cari mata kuliah...',
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
                            const SizedBox(width: 5),
                            // Tombol pencarian tetap di posisi yang sama
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              'Presensi Sedang Berlangsung',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                color: blueColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Divider(height: 20, color: Color(0xFFDADADA)),
                          Expanded(
                            child: filteredPresensi.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5, // setengah tinggi layar
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // agar tidak memaksa full height
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_noData.png',
                                            height: 120,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _searchController.text.isEmpty
                                                ? "Tidak ada data presensi"
                                                : "Data mata kuliah tidak ditemukan",
                                            style: TextStyle(
                                              color: greyColor,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: filteredPresensi.length,
                                    padding: const EdgeInsets.only(top: 0),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 16),
                                        child: PresensiCard(
                                          data: filteredPresensi[index],
                                        ),
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
            ],
          );
        }));
  }
}
