class KehadiranItem {
  final String label;
  final int jumlah;

  KehadiranItem({
    required this.label,
    required this.jumlah,
  });
}


class Kehadiran {
  final int semester;
  final String matkul;
  final double persentase;
  final List<KehadiranItem> kehadiran;

  Kehadiran({
    required this.semester,
    required this.matkul,
    required this.persentase,
    required this.kehadiran,
  });
}

