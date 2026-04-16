import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_student/home/lecture_controller.dart';
import 'package:stipres/screens/features_student/widgets/cards/lecture_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class LectureContentScreen extends StatefulWidget {
  const LectureContentScreen({super.key});

  @override
  State<LectureContentScreen> createState() => _LectureContentScreenState();
}

class _LectureContentScreenState extends State<LectureContentScreen>
    with TickerProviderStateMixin {
  late double height, width;

  final LectureController _controller = Get.put(LectureController());

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER + Search Bar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CustomHeader(title: "Perkuliahan Online"),
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

              // Body Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          'Link Perkuliahan',
                          style: TextStyle(
                            fontSize: 16,
                            color: blueColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Divider(height: 20, color: Color(0xFFDADADA)),
                      Expanded(
                        child: Obx(() {
                          return (_controller.lectureList.isEmpty)
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
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
                                          'Link tidak tersedia',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: greyColor,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _controller.lectureList.length,
                                  padding: const EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: PerkuliahanCard(
                                        data: _controller.lectureList[index],
                                      ),
                                    );
                                  },
                                );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
