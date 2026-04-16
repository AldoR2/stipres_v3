class DisabledPertemuansModel {
  final int? idPertemuan;
  final int? pertemuanKe;

  DisabledPertemuansModel({
    required this.idPertemuan,
    required this.pertemuanKe,
  });

  factory DisabledPertemuansModel.fromJson(Map<String, dynamic> json) {
    return DisabledPertemuansModel(
      idPertemuan: json["id_pertemuan"],
      pertemuanKe: json["pertemuan_ke"],
    );
  }
}
