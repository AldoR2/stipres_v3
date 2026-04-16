import 'package:flutter/material.dart';

class CourseDetailCard extends StatelessWidget {
  final String namaMatkul;
  final String idMatkul;
  final String tanggal;
  final String jam;
  final String dosen;

  const CourseDetailCard({
    super.key,
    required this.namaMatkul,
    required this.idMatkul,
    required this.tanggal,
    required this.jam,
    required this.dosen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Background Image
              Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/images/bgDetailMataKuliah.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // Foreground Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detail Mata Kuliah",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 136,
                            228), // Add the alpha value (255 for full opacity)
                      ),
                    ),
                    const SizedBox(height: 16),

                    // White Container
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaMatkul,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF083663),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              idMatkul,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF083663),
                              ),
                            ),
                            const Divider(height: 24),
                            _buildRowInfo('Tanggal', tanggal),
                            const SizedBox(height: 8),
                            _buildRowInfo('Jam', jam),
                            const SizedBox(height: 8),
                            _buildRowInfo('Dosen Pengampu', dosen,
                                isMultiline: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.normal, color: Color(0xFF083663)),
          ),
        ),
        const Text(':  '),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF083663),
            ),
          ),
        ),
      ],
    );
  }
}
