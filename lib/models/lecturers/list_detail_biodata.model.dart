class ListDetailBiodata {
  final String? nim;
  final String? nama;
  final int? semester;
  final String? namaProdi;
  String? foto;

  ListDetailBiodata({
    required this.nim,
    required this.nama,
    required this.semester,
    required this.namaProdi,
    required this.foto,
  });

  factory ListDetailBiodata.fromJson(Map<String, dynamic> json) {
    return ListDetailBiodata(
      nim: json["nim"],
      nama: json["nama"],
      semester: json["semester"],
      namaProdi: json["nama_prodi"],
      foto: json["foto"],
    );
  }
}
