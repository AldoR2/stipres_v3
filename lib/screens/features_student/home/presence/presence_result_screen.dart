import 'package:flutter/material.dart';

class PresensiResultScreen extends StatefulWidget {
  final String campusName;
  final String presenceStatus; // 'Hadir' | 'Ijin' | 'Sakit'
  final DateTime? presenceTime;

  const PresensiResultScreen({
    super.key,
    required this.campusName,
    required this.presenceStatus,
    this.presenceTime,
  });

  @override
  State<PresensiResultScreen> createState() => _PresensiResultScreenState();
}

class _PresensiResultScreenState extends State<PresensiResultScreen>
    with SingleTickerProviderStateMixin {
  // ─── Animasi masuk ────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _checkAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _animController, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _checkAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animController,
          curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );

    // Mulai animasi setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────
  String get _formattedTime {
    final time = widget.presenceTime ?? DateTime.now();
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s WIB';
  }

  String get _formattedDate {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final d = widget.presenceTime ?? DateTime.now();
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Color _statusColor(Color mainColor) {
    switch (widget.presenceStatus) {
      case 'Ijin':
        return Colors.orange.shade600;
      case 'Sakit':
        return Colors.red.shade500;
      default:
        return Colors.green.shade600;
    }
  }

  IconData _statusIcon() {
    switch (widget.presenceStatus) {
      case 'Ijin':
        return Icons.info_outline_rounded;
      case 'Sakit':
        return Icons.local_hospital_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  // ─── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // TODO: Ganti `Colors.blue` dengan `mainColor` dari constants kamu
    const Color mainColor = Color(0xFF1976D2);
    final statusColor = _statusColor(mainColor);

    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header (template milik kamu) ──
            CustomHeader(title: 'Presensi Mata Kuliah'),

            // ── Konten utama ──
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6FA),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Label section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Presensi Mata Kuliah',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),

                    // ── Card hasil ──
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ── Ikon status animasi ──
                              AnimatedBuilder(
                                animation: _animController,
                                builder: (_, __) => FadeTransition(
                                  opacity: _fadeAnim,
                                  child: ScaleTransition(
                                    scale: _scaleAnim,
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          _statusIcon(),
                                          color: statusColor,
                                          size: 52,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ── Teks "Presensi Berhasil!" ──
                              FadeTransition(
                                opacity: _checkAnim,
                                child: Column(
                                  children: [
                                    Text(
                                      'Presensi Berhasil!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        widget.presenceStatus,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // ── Divider ──
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                                child: Divider(
                                  color: Colors.grey.shade200,
                                  thickness: 1,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // ── Info lokasi ──
                              FadeTransition(
                                opacity: _checkAnim,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28),
                                  child: Column(
                                    children: [
                                      _InfoRow(
                                        icon: Icons.location_on_rounded,
                                        label: 'Deteksi lokasi',
                                        value: widget.campusName,
                                        iconColor: mainColor,
                                      ),
                                      const SizedBox(height: 16),
                                      _InfoRow(
                                        icon: Icons.calendar_today_rounded,
                                        label: 'Tanggal',
                                        value: _formattedDate,
                                        iconColor: mainColor,
                                      ),
                                      const SizedBox(height: 16),
                                      _InfoRow(
                                        icon: Icons.access_time_rounded,
                                        label: 'Waktu presensi',
                                        value: _formattedTime,
                                        iconColor: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Tombol Kembali ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Kembali ke halaman utama (pop semua route presensi)
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Kembali',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget baris info ────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Placeholder CustomHeader ─────────────────────────────────────────────────
// Hapus ini jika sudah punya widget CustomHeader sendiri
class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}