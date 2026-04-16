class PresensiId {
  final String? tahun;
  final int? lastIncrement;

  PresensiId({
    required this.tahun,
    required this.lastIncrement,
  });

  factory PresensiId.fromJson(Map<String, dynamic> json) {
    return PresensiId(
      tahun: json["tahun"],
      lastIncrement: json["lastIncrement"],
    );
  }
}
