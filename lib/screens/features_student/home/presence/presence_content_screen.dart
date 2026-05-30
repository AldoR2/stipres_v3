import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/screens/features_student/widgets/cards/presence/presenceContent_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/controllers/features_student/home/presence_content_controller.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class PresenceContentScreen extends StatefulWidget {
  PresenceContentScreen({super.key});

  @override
  State<PresenceContentScreen> createState() => _PresenceContentScreenState();
}

class _PresenceContentScreenState extends State<PresenceContentScreen> {
  final _controller = Get.find<PresenceContentController>();

  // ── Design tokens ────────────────────────────────────────
  static const _blue600 = Color(0xFF1565C0);
  static const _blue500 = Color(0xFF1976D2);
  static const _blue50 = Color(0xFFE3F2FD);
  static const _red50 = Color(0xFFFFEBEE);
  static const _red600 = Color(0xFFC62828);
  static const _amber50 = Color(0xFFFFFDE7);
  static const _amber600 = Color(0xFFF57F17);
  static const _green50 = Color(0xFFE8F5E9);
  static const _green600 = Color(0xFF2E7D32);
  static const _grey200 = Color(0xFFEEEEEE);
  static const _grey500 = Color(0xFF9E9E9E);
  static const _grey700 = Color(0xFF616161);

  double _sp(BuildContext ctx, double size) {
    final w = MediaQuery.of(ctx).size.width;
    return size * (w / 390).clamp(0.85, 1.2);
  }

  double _hPad(BuildContext ctx) =>
      (MediaQuery.of(ctx).size.width * 0.05).clamp(16.0, 24.0);

  // ── Status option config ──────────────────────────────────
  List<Map<String, dynamic>> get _statusOptions => [
        {
          'value': StatusPresensi.hadir,
          'label': 'Hadir',
          'icon': Icons.check_circle_outline_rounded,
          'activeColor': _blue600,
          'activeBg': _blue50,
          'activeBorder': _blue500,
        },
        {
          'value': StatusPresensi.ijin,
          'label': 'Izin',
          'icon': Icons.assignment_late_outlined,
          'activeColor': _amber600,
          'activeBg': _amber50,
          'activeBorder': _amber600,
        },
        {
          'value': StatusPresensi.sakit,
          'label': 'Sakit',
          'icon': Icons.local_hospital_outlined,
          'activeColor': _red600,
          'activeBg': _red50,
          'activeBorder': _red600,
        },
      ];

  @override
  Widget build(BuildContext context) {
    final hPad = _hPad(context);

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Obx(() {
        return Column(
          children: [
            // ── Header ──────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomHeader(title: "Presensi Mata Kuliah"),
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

            const SizedBox(height: 20),

            // ── Body ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, hPad * 2),
                child: (_controller.statusData.value == false)
                    ? _buildEmptyState(context)
                    : _buildContent(context, hPad),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Empty state ───────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _grey200,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icons/ic_noData.png',
                height: 72,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tidak ada presensi',
              style: GoogleFonts.plusJakartaSans(
                color: _grey500,
                fontSize: _sp(context, 16),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Belum ada sesi presensi yang aktif saat ini',
              style: GoogleFonts.plusJakartaSans(
                color: _grey500,
                fontSize: _sp(context, 13),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content ──────────────────────────────────────────
  Widget _buildContent(BuildContext context, double hPad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Row(
          children: [
            Container(
              width: 4,
              height: _sp(context, 18),
              decoration: BoxDecoration(
                color: _blue600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Form Presensi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: _sp(context, 16),
                fontWeight: FontWeight.w700,
                color: _blue600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Matkul detail card
        MatkulDetailCard(data: _controller.presence.value),

        const SizedBox(height: 20),

        // ── Status label ──────────────────────────────────
        Text(
          'Status Kehadiran',
          style: GoogleFonts.plusJakartaSans(
            fontSize: _sp(context, 13),
            fontWeight: FontWeight.w700,
            color: styles.getTextColor(context),
          ),
        ),
        const SizedBox(height: 10),

        // ── Status selector (3 pill toggle) ──────────────
        Obx(() {
          return Row(
            children: _statusOptions.map((opt) {
              final isSelected = _controller.status.value == opt['value'];
              final Color activeColor = opt['activeColor'];
              final Color activeBg = opt['activeBg'];
              final Color activeBorder = opt['activeBorder'];

              return Expanded(
                child: GestureDetector(
                  onTap: () => _controller.status.value = opt['value'],
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(
                      right: opt['label'] != 'Sakit' ? 8 : 0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: _sp(context, 12),
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? activeBg : styles.getTextField(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? activeBorder
                            : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: activeColor.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          opt['icon'],
                          size: _sp(context, 22),
                          color: isSelected ? activeColor : _grey500,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opt['label'],
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: _sp(context, 12),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? activeColor : _grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        const SizedBox(height: 20),

        // ── HADIR: Deteksi Wajah ──────────────────────────
        Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _controller.status.value == StatusPresensi.hadir
                ? Column(
                    key: const ValueKey('hadir'),
                    children: [
                      // Info card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: _sp(context, 14),
                          vertical: _sp(context, 12),
                        ),
                        decoration: BoxDecoration(
                          color: _blue50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _blue500.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: _blue600, size: _sp(context, 18)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Pastikan Anda berada di sekitar area kampus sebelum melakukan deteksi wajah.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: _sp(context, 12),
                                  color: _blue600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Deteksi Wajah button
                      SizedBox(
                        width: double.infinity,
                        height: _sp(context, 52),
                        child: ElevatedButton.icon(
                          onPressed: () => _controller.submitDetection(),
                          icon: const Icon(
                              Icons.face_retouching_natural_rounded,
                              color: Colors.white),
                          label: Text(
                            'Deteksi Wajah',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: _sp(context, 14),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue600,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox(key: ValueKey('empty')),
          );
        }),

        // ── IJIN / SAKIT ──────────────────────────────────
        Obx(() {
          final isIjinOrSakit =
              _controller.status.value == StatusPresensi.ijin ||
                  _controller.status.value == StatusPresensi.sakit;

          final isIjin = _controller.status.value == StatusPresensi.ijin;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: isIjinOrSakit
                ? Column(
                    key: ValueKey(isIjin ? 'ijin' : 'sakit'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: _sp(context, 14),
                          vertical: _sp(context, 12),
                        ),
                        decoration: BoxDecoration(
                          color: isIjin ? _amber50 : _red50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                (isIjin ? _amber600 : _red600).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isIjin
                                  ? Icons.assignment_late_outlined
                                  : Icons.local_hospital_outlined,
                              color: isIjin ? _amber600 : _red600,
                              size: _sp(context, 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                isIjin
                                    ? 'Isi alasan izin dan lampirkan bukti dokumen jika ada.'
                                    : 'Isi alasan sakit dan lampirkan surat keterangan dokter jika ada.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: _sp(context, 12),
                                  color: isIjin ? _amber600 : _red600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Label Alasan
                      Text(
                        'Alasan Ketidakhadiran',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: _sp(context, 13),
                          fontWeight: FontWeight.w700,
                          color: styles.getTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // TextField Alasan
                      Container(
                        decoration: BoxDecoration(
                          color: styles.getTextField(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller.alasanController,
                          maxLines: 5,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: _sp(context, 14),
                            color: styles.getTextColor(context),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tuliskan alasan ketidakhadiran...',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              color: _grey500,
                              fontSize: _sp(context, 13),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Upload Bukti button
                      SizedBox(
                        width: double.infinity,
                        height: _sp(context, 50),
                        child: OutlinedButton.icon(
                          onPressed: () => _controller.showFileOptions(),
                          icon: Icon(
                            Icons.upload_file_rounded,
                            size: _sp(context, 18),
                            color: _blue600,
                          ),
                          label: Obx(() {
                            final status = _controller.bukti.value;
                            return (status == null)
                                ? Text(
                                    'Upload Bukti',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: _sp(context, 14),
                                      fontWeight: FontWeight.w600,
                                      color: _blue600,
                                    ),
                                  )
                                : Text('Perbarui Bukti',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: _sp(context, 14),
                                      fontWeight: FontWeight.w600,
                                      color: _blue600,
                                    ));
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: _sp(context, 52),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!_controller.isSnackbarOpen.value) {
                              _controller.submitPresence();
                            }
                          },
                          icon: const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.white),
                          label: Text(
                            'Submit Presensi',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: _sp(context, 14),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _blue600,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox(key: ValueKey('none')),
          );
        }),
      ],
    );
  }
}
