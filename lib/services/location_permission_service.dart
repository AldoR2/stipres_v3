import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LocationPermissionService {
  final GetSnackBar snackBar = GetSnackBar();
  final Logger log = Logger();

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<void> openLocationSetting() async {
    Geolocator.openLocationSettings();
  }

  Future<void> openAppSetting() async {
    Geolocator.openAppSettings();
  }

  Future<Position> getCurrentLocation() async {
    bool isLocated = await Geolocator.isLocationServiceEnabled();
    if (!isLocated) {
      log.d("Location Service tidak tersedia");
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high
      ),
    );
  }
}
