class LocationModel {
  final int? id;
  final double latitude;
  final double longitude;
  final String? nama;
  final int? radius;
  final int? isActive;

  LocationModel(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.nama,
      required this.radius,
      this.isActive});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        id: json['id'],
        latitude: double.parse(json['latitude']),
        longitude: double.parse(json['longitude']),
        nama: json['nama'],
        radius: json['radius'],
        isActive: json['is_active']);
  }
}
