class RekapModelApi {
  int mahasiswaId;
  String nim;
  String namaMatkul;
  String kodeMatkul;
  int status;
  int semester;
  String? persentase;
  int? hadir;
  int? izin;
  int? sakit;
  int? alpa;

  RekapModelApi(
      {required this.mahasiswaId,
      required this.nim,
      required this.namaMatkul,
      required this.kodeMatkul,
      required this.status,
      required this.semester,
      this.persentase,
      this.hadir = 0,
      this.izin = 0,
      this.sakit = 0,
      this.alpa = 0});

  factory RekapModelApi.fromJson(Map<String, dynamic> json) {
    return RekapModelApi(
        mahasiswaId: json['mahasiswa_id'],
        nim: json['nim'],
        namaMatkul: json['nama_matkul'],
        kodeMatkul: json['kode_matkul'],
        status: json['status'],
        semester: json['semester']);
  }
}
