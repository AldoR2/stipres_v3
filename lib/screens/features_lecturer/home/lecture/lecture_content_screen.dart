import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/home/lectures/lecture_controller.dart';
import 'package:stipres/screens/features_lecturer/widgets/cards/lecture_card.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/screens/features_lecturer/widgets/dialog/edit_lecture_dialog.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class LectureContentScreen extends StatefulWidget {
  const LectureContentScreen({super.key});

  @override
  State<LectureContentScreen> createState() => _LectureContentScreenState();
}

class _LectureContentScreenState extends State<LectureContentScreen>
    with TickerProviderStateMixin {
  late double height, width;

  final _controller = Get.find<LectureController>();

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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomHeader(title: "Perkuliahan Online"),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Link Perkuliahan Online',
                          style: TextStyle(
                            fontSize: 16,
                            color: blueColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Divider(height: 20, color: Color(0xFFDADADA)),
                      Obx(() {
                        return Expanded(
                            child: _controller.lectureList.isEmpty
                                ? Container(
                                    width: double
                                        .infinity, // Biar bisa center dalam parent
                                    padding: const EdgeInsets.only(top: 30),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  )
                                : ListView.builder(
                                    itemCount: _controller.lectureList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 0),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: PerkuliahanCard(
                                            data:
                                                _controller.lectureList[index],
                                            onEdit: (String currentLink,
                                                int presensisId) {
                                              showEditLinkDialog(
                                                  context, currentLink,
                                                  (String newLink) {
                                                // ✅ Tangani perubahan di sini
                                                _controller.submitUpdateLecture(
                                                    presensisId,
                                                    newLink,
                                                    currentLink,
                                                    _controller
                                                        .lectureList[index]);
                                              });
                                            }),
                                      );
                                    },
                                  ));
                      })
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
