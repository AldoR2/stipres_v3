import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:stipres/controllers/features_lecturer/home/presences/add_presence_controller.dart';
import 'package:stipres/models/lecturers/data_prodi_model.dart';
import 'package:stipres/models/lecturers/matkul_model.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class AddPresenceScreen extends StatefulWidget {
  const AddPresenceScreen({super.key});

  @override
  State<AddPresenceScreen> createState() => _AddPresenceScreenState();
}

class _AddPresenceScreenState extends State<AddPresenceScreen> {
  final _controller = Get.find<AddPresenceController>();

  final jenisPertemuan = ['Teori', 'Praktik'];
  final kategoriPresensi = ['Luring', 'Daring'];
  ValueChanged<String>? onChanged;

  final List<String> semuaPertemuan =
      List.generate(32, (i) => (i + 1).toString());

  // ─── Design tokens ───────────────────────────────────────────────
  static const _primary = Color(0xFF1E88E4);
  static const _primaryLight = Color(0xFFEEF3FF);
  static const _primaryDark = Color.fromARGB(255, 20, 92, 155);
  static const _surface = Colors.white;
  static const _surfaceAlt = Color(0xFFF8FAFF);
  static const _border = Color(0xFFDDE3F0);
  static const _borderFocus = Color.fromARGB(255, 26, 116, 196);
  static const _textPrimary = Color(0xFF111827);
  static const _textSecondary = Color(0xFF6B7280);
  static const _textDisabled = Color(0xFFADB5BD);
  static const _danger = Color(0xFFEF4444);

  // ─── Responsive helpers ──────────────────────────────────────────
  double _sp(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    // Base width 390 (iPhone 14). Scale font relative to screen width.
    return size * (width / 390).clamp(0.85, 1.2);
  }

  double _hp(BuildContext context) =>
      (MediaQuery.of(context).size.width * 0.04).clamp(14.0, 20.0);

  // ─── Shared input decoration ─────────────────────────────────────
  InputDecoration _fieldDecoration(
    BuildContext context,
    String hint, {
    IconData? prefixIcon,
  }) {
    final fs = _sp(context, 14);
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(color: _textDisabled, fontSize: fs),
      filled: true,
      fillColor: _surface,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: _sp(context, 18), color: _textSecondary)
          : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: _hp(context),
        vertical: _sp(context, 14),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _borderFocus, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _border.withOpacity(0.5)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _danger),
      ),
    );
  }

  // ─── Section label ────────────────────────────────────────────────
  Widget _label(BuildContext context, String text, {bool required = false}) =>
      Padding(
        padding: EdgeInsets.only(bottom: _sp(context, 6)),
        child: RichText(
          text: TextSpan(
            text: text,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: _sp(context, 13),
              color: _textPrimary,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: _danger),
                    )
                  ]
                : [],
          ),
        ),
      );

  // ─── Section card wrapper ─────────────────────────────────────────
  Widget _card(BuildContext context,
          {required String title, required Widget child}) =>
      Container(
        margin: EdgeInsets.only(bottom: _sp(context, 16)),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A56DB).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: _hp(context),
                vertical: _sp(context, 12),
              ),
              decoration: const BoxDecoration(
                color: _primaryLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: _sp(context, 14),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: _sp(context, 8)),
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: _sp(context, 13),
                      color: _primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_hp(context)),
              child: child,
            ),
          ],
        ),
      );

  Widget _gap(BuildContext context) => SizedBox(height: _sp(context, 14));

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = _hp(context);

    return Scaffold(
      backgroundColor: _surfaceAlt,
      body: Column(
        children: [
          // ── Header ──
          CustomHeader(
            title: 'Presensi Mata Kuliah',
            backgroundColor: _surfaceAlt,
          ),

          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, hPad, hPad, hPad * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page intro banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _sp(context, 14),
                      vertical: _sp(context, 12),
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_primary, _primaryDark],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file_rounded,
                            color: Colors.white, size: _sp(context, 20)),
                        SizedBox(width: _sp(context, 10)),
                        Text(
                          'Upload Presensi',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: _sp(context, 14),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _sp(context, 8),
                            vertical: _sp(context, 3),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Wajib isi semua field',
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: _sp(context, 10),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: _sp(context, 16)),

                  // ─── CARD 1: Informasi Kelas ──────────────────────
                  _card(
                    context,
                    title: 'Informasi Kelas',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Program Studi
                        _label(context, 'Program Studi', required: true),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            value:
                                _controller.selectedProdiName.value.isNotEmpty
                                    ? _controller.selectedProdiName.value
                                    : null,
                            hint: Text('Pilih program studi',
                                style: GoogleFonts.dmSans(
                                    color: _textDisabled,
                                    fontSize: _sp(context, 14))),
                            style: GoogleFonts.dmSans(
                                color: _textPrimary,
                                fontSize: _sp(context, 14)),
                            isExpanded: true,
                            decoration: _fieldDecoration(
                                context, 'Pilih program studi',
                                prefixIcon: Icons.school_outlined),
                            items: _controller.listProdi
                                .map((e) => DropdownMenuItem(
                                      value: e.namaProdi,
                                      child: Text(e.namaProdi ?? '',
                                          style: GoogleFonts.dmSans(
                                              fontSize: _sp(context, 14))),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              _controller.selectedProdiName.value = val ?? '';
                              final selected = _controller.listProdi.firstWhere(
                                  (e) =>
                                      e.namaProdi.toLowerCase().trim() ==
                                      val!.toLowerCase().trim(),
                                  orElse: () =>
                                      DataProdi(id: '', namaProdi: ''));
                              _controller.selectedProdiMap.value = {
                                'id': selected.id,
                                'nama_prodi': selected.namaProdi,
                              };
                              _controller.validateMatkul();
                              _controller.validateDisabledPertemuans();
                            },
                          );
                        }),

                        _gap(context),

                        // Semester
                        _label(context, 'Semester', required: true),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            value: _controller.selectedSemester.value.isNotEmpty
                                ? _controller.selectedSemester.value
                                : null,
                            hint: Text('Pilih semester',
                                style: GoogleFonts.dmSans(
                                    color: _textDisabled,
                                    fontSize: _sp(context, 14))),
                            style: GoogleFonts.dmSans(
                                color: _textPrimary,
                                fontSize: _sp(context, 14)),
                            isExpanded: true,
                            decoration: _fieldDecoration(
                                context, 'Pilih semester',
                                prefixIcon: Icons.calendar_view_week_outlined),
                            items: ['1', '2', '3', '4', '5', '6', '7', '8']
                                .map((v) => DropdownMenuItem(
                                    value: v,
                                    child: Text('Semester $v',
                                        style: GoogleFonts.dmSans(
                                            fontSize: _sp(context, 14)))))
                                .toList(),
                            onChanged: (val) {
                              _controller.selectedSemester.value = val!;
                              _controller.validateMatkul();
                              _controller.validateDisabledPertemuans();
                            },
                          );
                        }),

                        _gap(context),

                        // Tahun Ajaran
                        _label(context, 'Tahun Ajaran'),
                        Obx(() {
                          final enabled =
                              _controller.tahunAjaran.value.isNotEmpty;
                          return TextFormField(
                            style: GoogleFonts.dmSans(
                              color: enabled ? _textPrimary : _textDisabled,
                              fontSize: _sp(context, 14),
                            ),
                            decoration: _fieldDecoration(
                                    context, 'Tahun ajaran',
                                    prefixIcon: Icons.date_range_outlined)
                                .copyWith(
                              hintText: _controller.tahunAjaran.value.isNotEmpty
                                  ? _controller.tahunAjaran.value
                                  : 'Tahun ajaran',
                              hintStyle: GoogleFonts.dmSans(
                                color: enabled ? _textPrimary : _textDisabled,
                                fontSize: _sp(context, 14),
                              ),
                              filled: true,
                              fillColor:
                                  enabled ? _surface : const Color(0xFFF3F4F6),
                            ),
                            readOnly: true,
                            enabled: enabled,
                          );
                        }),

                        _gap(context),

                        // Mata Kuliah
                        _label(context, 'Mata Kuliah', required: true),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            value: _controller.selectedMatkul.value.isNotEmpty
                                ? _controller.selectedMatkul.value
                                : null,
                            hint: Text('Pilih mata kuliah',
                                style: GoogleFonts.dmSans(
                                    color: _textDisabled,
                                    fontSize: _sp(context, 14))),
                            style: GoogleFonts.dmSans(
                                color: _textPrimary,
                                fontSize: _sp(context, 14)),
                            isExpanded: true,
                            decoration: _fieldDecoration(
                                context, 'Pilih mata kuliah',
                                prefixIcon: Icons.book_outlined),
                            items: _controller.listMatkul
                                .map((e) => e.namaMatkul)
                                .toSet()
                                .map((nama) => DropdownMenuItem(
                                    value: nama,
                                    child: Text(nama ?? '',
                                        style: GoogleFonts.dmSans(
                                            fontSize: _sp(context, 14)))))
                                .toList(),
                            onChanged: (val) {
                              final selected =
                                  _controller.listMatkul.firstWhere(
                                (e) => e.namaMatkul == val,
                                orElse: () => MatkulModel(
                                    idMatkul: 0,
                                    kodeMatkul: '',
                                    namaMatkul: ''),
                              );
                              _controller.selectedMatkul.value = val ?? '';
                              _controller.selectedMatkulMap.value = {
                                'id': selected.idMatkul.toString(),
                                'nama_matkul': selected.namaMatkul!,
                                'kode_matkul': selected.kodeMatkul!,
                              };
                              _controller.validateDisabledPertemuans();
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // ─── CARD 2: Jadwal Pertemuan ─────────────────────
                  _card(
                    context,
                    title: 'Jadwal Pertemuan',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tanggal
                        _label(context, 'Tanggal Presensi', required: true),
                        Obx(() {
                          final hasDate =
                              _controller.selectedDate.value != null;
                          return GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                builder: (ctx, child) => Theme(
                                  data: Theme.of(ctx).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: _primary,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (picked != null) {
                                _controller.selectedDate.value = picked;
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: _sp(context, 14),
                                vertical: _sp(context, 14),
                              ),
                              decoration: BoxDecoration(
                                color: hasDate ? _primaryLight : _surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: hasDate ? _primary : _border,
                                  width: hasDate ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: _sp(context, 18),
                                    color: hasDate ? _primary : _textSecondary,
                                  ),
                                  SizedBox(width: _sp(context, 10)),
                                  Expanded(
                                    child: Text(
                                      hasDate
                                          ? DateFormat(
                                                  'EEEE, dd MMMM yyyy', 'id_ID')
                                              .format(_controller
                                                  .selectedDate.value!)
                                          : 'Pilih tanggal presensi',
                                      style: GoogleFonts.dmSans(
                                        fontSize: _sp(context, 14),
                                        color: hasDate
                                            ? _primaryDark
                                            : _textDisabled,
                                        fontWeight: hasDate
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color:
                                          hasDate ? _primary : _textSecondary),
                                ],
                              ),
                            ),
                          );
                        }),

                        _gap(context),

                        // Pertemuan Ke-
                        _label(context, 'Pertemuan Ke-', required: true),
                        Obx(() {
                          final selected = semuaPertemuan
                                  .contains(_controller.selectedPertemuan.value)
                              ? _controller.selectedPertemuan.value
                              : null;
                          return DropdownButtonFormField<String>(
                            value: selected,
                            hint: Text('Pilih pertemuan',
                                style: GoogleFonts.dmSans(
                                    color: _textDisabled,
                                    fontSize: _sp(context, 14))),
                            style: GoogleFonts.dmSans(
                                color: _textPrimary,
                                fontSize: _sp(context, 14)),
                            isExpanded: true,
                            decoration: _fieldDecoration(
                                context, 'Pilih pertemuan',
                                prefixIcon: Icons.format_list_numbered),
                            items: semuaPertemuan.map((pertemuan) {
                              final isDisabled = _controller.pertemuanTerpakai
                                  .contains(int.parse(pertemuan));
                              return DropdownMenuItem<String>(
                                value: pertemuan,
                                enabled: !isDisabled,
                                child: Row(
                                  children: [
                                    Text(
                                      'Pertemuan $pertemuan',
                                      style: GoogleFonts.dmSans(
                                        color: isDisabled
                                            ? _textDisabled
                                            : _textPrimary,
                                        fontSize: _sp(context, 14),
                                      ),
                                    ),
                                    if (isDisabled) ...[
                                      SizedBox(width: _sp(context, 6)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: _sp(context, 6),
                                          vertical: _sp(context, 2),
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Terpakai',
                                          style: GoogleFonts.dmSans(
                                            color: _danger,
                                            fontSize: _sp(context, 10),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                _controller.selectedPertemuan.value = value;
                              }
                            },
                          );
                        }),

                        _gap(context),

                        // Status
                        _label(context, 'Status Presensi', required: true),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            value: _controller.selectedStatus.value.isNotEmpty
                                ? _controller.selectedStatus.value
                                : null,
                            hint: Text('Pilih status',
                                style: GoogleFonts.dmSans(
                                    color: _textDisabled,
                                    fontSize: _sp(context, 14))),
                            style: GoogleFonts.dmSans(
                                color: _textPrimary,
                                fontSize: _sp(context, 14)),
                            isExpanded: true,
                            decoration: _fieldDecoration(
                                context, 'Pilih status',
                                prefixIcon: Icons.toggle_on_outlined),
                            items: _controller.listStatus
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: e == 'Aktif'
                                                  ? const Color(0xFF10B981)
                                                  : _textDisabled,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Text(e,
                                              style: GoogleFonts.dmSans(
                                                  fontSize: _sp(context, 14))),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              _controller.selectedStatus.value = val ?? '';
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // ─── CARD 3: Detail Pertemuan (hanya jika Aktif) ──
                  Obx(() {
                    if (_controller.selectedStatus.value != 'Aktif') {
                      return const SizedBox();
                    }

                    return _card(
                      context,
                      title: 'Detail Pertemuan',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Jenis Pertemuan
                          _label(context, 'Jenis Pertemuan', required: true),
                          Obx(() {
                            final selected = jenisPertemuan
                                    .contains(_controller.selectedJenis.value)
                                ? _controller.selectedJenis.value
                                : null;
                            return DropdownButtonFormField<String>(
                              value: selected,
                              hint: Text('Pilih jenis pertemuan',
                                  style: GoogleFonts.dmSans(
                                      color: _textDisabled,
                                      fontSize: _sp(context, 14))),
                              style: GoogleFonts.dmSans(
                                  color: _textPrimary,
                                  fontSize: _sp(context, 14)),
                              isExpanded: true,
                              decoration: _fieldDecoration(
                                  context, 'Pilih jenis pertemuan',
                                  prefixIcon: Icons.category_outlined),
                              items: jenisPertemuan
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          style: GoogleFonts.dmSans(
                                              fontSize: _sp(context, 14)))))
                                  .toList(),
                              onChanged: (val) {
                                _controller.selectedJenis.value = val ?? '';
                              },
                            );
                          }),

                          _gap(context),

                          // Waktu
                          _label(context, 'Waktu Pertemuan', required: true),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Obx(() => _buildTimePicker(
                                      context: context,
                                      label: 'Jam Awal',
                                      time: _controller.jamAwal.value,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (ctx, child) => Theme(
                                            data: Theme.of(ctx).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                      primary: _primary),
                                            ),
                                            child: child!,
                                          ),
                                        );
                                        if (picked != null) {
                                          _controller.jamAwal.value = picked;
                                        }
                                      },
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _sp(context, 8),
                                  vertical: _sp(context, 20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(_sp(context, 6)),
                                  decoration: BoxDecoration(
                                    color: _primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.arrow_forward,
                                      size: _sp(context, 14), color: _primary),
                                ),
                              ),
                              Expanded(
                                child: Obx(() => _buildTimePicker(
                                      context: context,
                                      label: 'Jam Akhir',
                                      time: _controller.jamAkhir.value,
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                          builder: (ctx, child) => Theme(
                                            data: Theme.of(ctx).copyWith(
                                              colorScheme:
                                                  const ColorScheme.light(
                                                      primary: _primary),
                                            ),
                                            child: child!,
                                          ),
                                        );
                                        if (picked != null) {
                                          _controller.jamAkhir.value = picked;
                                        }
                                      },
                                    )),
                              ),
                            ],
                          ),

                          _gap(context),

                          // Jenis Presensi toggle
                          _label(context, 'Jenis Presensi', required: true),
                          Obx(() {
                            final selected = kategoriPresensi.contains(
                                    _controller.selectedKategori.value)
                                ? _controller.selectedKategori.value
                                : null;
                            return Row(
                              children: kategoriPresensi.map((k) {
                                final isSelected = selected == k;
                                final isLuring = k == 'Luring';
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _controller.selectedKategori.value = k;
                                      if (k == 'Luring') {
                                        _controller.linkZoomController.text =
                                            '';
                                      } else {
                                        _controller.selectedRuanganID.value =
                                            '';
                                      }
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: EdgeInsets.only(
                                          right:
                                              isLuring ? _sp(context, 8) : 0),
                                      padding: EdgeInsets.symmetric(
                                          vertical: _sp(context, 12)),
                                      decoration: BoxDecoration(
                                        color: isSelected ? _primary : _surface,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              isSelected ? _primary : _border,
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isLuring
                                                ? Icons.location_on_outlined
                                                : Icons.videocam_outlined,
                                            size: _sp(context, 16),
                                            color: isSelected
                                                ? Colors.white
                                                : _textSecondary,
                                          ),
                                          SizedBox(width: _sp(context, 6)),
                                          Text(
                                            k,
                                            style: GoogleFonts.dmSans(
                                              fontSize: _sp(context, 13),
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? Colors.white
                                                  : _textSecondary,
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

                          _gap(context),

                          // Link Zoom atau Ruangan
                          Obx(() {
                            if (_controller.selectedKategori.value ==
                                'Daring') {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label(context, 'Link Zoom', required: true),
                                  TextFormField(
                                    controller: _controller.linkZoomController,
                                    onChanged: onChanged,
                                    maxLength: 254,
                                    style: GoogleFonts.dmSans(
                                        fontSize: _sp(context, 14),
                                        color: _textPrimary),
                                    decoration: _fieldDecoration(
                                        context, 'https://zoom.us/j/...',
                                        prefixIcon: Icons.link),
                                  ),
                                ],
                              );
                            } else if (_controller.selectedKategori.value ==
                                'Luring') {
                              final selected = _controller.listRuangan
                                      .toList()
                                      .contains(
                                          _controller.selectedRuanganID.value)
                                  ? _controller.selectedRuanganID.value
                                  : null;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label(context, 'Ruangan', required: true),
                                  DropdownButtonFormField<String>(
                                    value: selected,
                                    hint: Text('Pilih ruangan',
                                        style: GoogleFonts.dmSans(
                                            color: _textDisabled,
                                            fontSize: _sp(context, 14))),
                                    style: GoogleFonts.dmSans(
                                        color: _textPrimary,
                                        fontSize: _sp(context, 14)),
                                    isExpanded: true,
                                    decoration: _fieldDecoration(
                                        context, 'Pilih ruangan',
                                        prefixIcon:
                                            Icons.meeting_room_outlined),
                                    items: _controller.listRuangan
                                        .map((e) => DropdownMenuItem(
                                            value: e.id ?? '',
                                            child: Text(e.namaRuangan ?? '',
                                                style: GoogleFonts.dmSans(
                                                    fontSize:
                                                        _sp(context, 14)))))
                                        .toList(),
                                    onChanged: (val) {
                                      _controller.selectedRuanganID.value =
                                          val ?? '';
                                    },
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          }),

                          _gap(context),

                          // Lokasi Presensi
                          _label(context, 'Lokasi Presensi', required: true),
                          Obx(() => DropdownButtonFormField<String>(
                                value: _controller
                                        .selectedLokasiId.value.isNotEmpty
                                    ? _controller.selectedLokasiId.value
                                    : null,
                                hint: Text('Pilih lokasi',
                                    style: GoogleFonts.dmSans(
                                        color: _textDisabled,
                                        fontSize: _sp(context, 14))),
                                style: GoogleFonts.dmSans(
                                    color: _textPrimary,
                                    fontSize: _sp(context, 14)),
                                isExpanded: true,
                                decoration: _fieldDecoration(
                                    context, 'Pilih lokasi',
                                    prefixIcon: Icons.place_outlined),
                                items: [
                                  ..._controller.listLokasi
                                      .map((lokasi) => DropdownMenuItem<String>(
                                            value: lokasi.id.toString(),
                                            child: Text(lokasi.nama ?? '',
                                                style: GoogleFonts.dmSans(
                                                    fontSize:
                                                        _sp(context, 14))),
                                          )),
                                  const DropdownMenuItem<String>(
                                      value: "0",
                                      child: Text(
                                        "Dimana Saja",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  DropdownMenuItem(
                                    value: 'tambah_lokasi',
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(_sp(context, 4)),
                                          decoration: BoxDecoration(
                                            color: _primaryLight,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                              Icons.add_location_alt_outlined,
                                              size: _sp(context, 14),
                                              color: _primary),
                                        ),
                                        SizedBox(width: _sp(context, 8)),
                                        Text(
                                          'Tambah Lokasi Baru',
                                          style: GoogleFonts.dmSans(
                                            color: _primary,
                                            fontSize: _sp(context, 14),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val == null) return;

                                  if (val == 'tambah_lokasi') {
                                    _controller.openLocationPicker(context);
                                    return;
                                  }

                                  if (val == '0') {
                                    _controller.selectedLokasiId.value = '0';
                                    _controller.selectedLokasiNama.value =
                                        'Dimana Saja';
                                    _controller.latitude.value = '';
                                    _controller.longitude.value = '';
                                    return;
                                  }

                                  _controller.selectedLokasiId.value = val;

                                  final lokasi =
                                      _controller.listLokasi.firstWhere(
                                    (e) => e.id.toString() == val,
                                  );

                                  _controller.selectedLokasiNama.value =
                                      lokasi.nama ?? '';
                                  _controller.latitude.value =
                                      lokasi.latitude?.toString() ?? '';
                                  _controller.longitude.value =
                                      lokasi.longitude?.toString() ?? '';
                                  // if (val == 'tambah_lokasi') {
                                  //   _controller.selectedLokasiId.value =
                                  //       _controller.selectedLokasiId.value;
                                  //   _controller.openLocationPicker(context);
                                  // } else {
                                  //   _controller.selectedLokasiId.value = val!;
                                  //   final lokasi = _controller.listLokasi
                                  //       .firstWhere(
                                  //           (e) => e.id.toString() == val);
                                  //   _controller.selectedLokasiNama.value =
                                  //       lokasi.nama ?? '';
                                  //   _controller.latitude.value =
                                  //       lokasi.latitude?.toString() ?? '';
                                  //   _controller.longitude.value =
                                  //       lokasi.longitude?.toString() ?? '';
                                  // }
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Lokasi presensi wajib dipilih';
                                  }
                                  return null;
                                },
                              )),

                          // Info koordinat
                          Obx(() {
                            if (_controller.latitude.value.isEmpty) {
                              return const SizedBox();
                            }
                            return Container(
                              margin: EdgeInsets.only(top: _sp(context, 8)),
                              padding: EdgeInsets.symmetric(
                                horizontal: _sp(context, 12),
                                vertical: _sp(context, 8),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFF6EE7B7)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.my_location,
                                      size: _sp(context, 14),
                                      color: const Color(0xFF059669)),
                                  SizedBox(width: _sp(context, 6)),
                                  Expanded(
                                    child: Text(
                                      'Lat: ${_controller.latitude.value}  ·  Lng: ${_controller.longitude.value}',
                                      style: GoogleFonts.dmSans(
                                        fontSize: _sp(context, 12),
                                        color: const Color(0xFF065F46),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),

                  // ─── Submit Button ──────────────────────────────────
                  Obx(() {
                    final enabled = _controller.isEnabled.value;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: enabled
                            ? const LinearGradient(
                                colors: [_primary, _primaryDark],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: enabled ? null : const Color(0xFFE5E7EB),
                        boxShadow: enabled
                            ? [
                                BoxShadow(
                                  color: _primary.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: enabled ? _controller.submitPresence : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: _sp(context, 16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: enabled ? Colors.white : _textDisabled,
                                  size: _sp(context, 18),
                                ),
                                SizedBox(width: _sp(context, 8)),
                                Text(
                                  'Submit Presensi',
                                  style: GoogleFonts.dmSans(
                                    fontSize: _sp(context, 15),
                                    fontWeight: FontWeight.w700,
                                    color:
                                        enabled ? Colors.white : _textDisabled,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final hasTime = time != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: _sp(context, 12),
            color: _textSecondary,
          ),
        ),
        SizedBox(height: _sp(context, 6)),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: _sp(context, 10),
              vertical: _sp(context, 13),
            ),
            decoration: BoxDecoration(
              color: hasTime ? _primaryLight : _surface,
              border: Border.all(
                color: hasTime ? _primary : _border,
                width: hasTime ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded,
                    size: _sp(context, 16),
                    color: hasTime ? _primary : _textSecondary),
                SizedBox(width: _sp(context, 4)),
                Text(
                  hasTime ? time.format(context) : '--:--',
                  style: GoogleFonts.dmSans(
                    fontSize: _sp(context, 14),
                    fontWeight: hasTime ? FontWeight.w700 : FontWeight.w400,
                    color: hasTime ? _primaryDark : _textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
