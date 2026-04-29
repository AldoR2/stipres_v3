import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:stipres/constants/styles.dart';
import 'dart:async';
import 'dart:convert';
import 'package:stipres/screens/reusable/custom_header.dart';

/// Model hasil pemilihan lokasi — dikembalikan ke screen sebelumnya
class PickedLocation {
  final String name;
  final double latitude;
  final double longitude;

  const PickedLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // ─── State ────────────────────────────────────────────────
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng _pinPosition = const LatLng(-8.1727, 113.6994); // default Polije
  String _locationName = 'Politeknik Negeri Jember';
  bool _isLoading = false;
  bool _hasPickedLocation = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─── Geocoding (Nominatim - gratis) ──────────────────────

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
      );
      final response = await http
          .get(uri, headers: {'User-Agent': 'StipresApp/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final name = data[0]['display_name'] as String;
          final shortName = name.split(',').take(3).join(',').trim();

          final newPos = LatLng(lat, lon);
          setState(() {
            _pinPosition = newPos;
            _locationName = shortName;
            _hasPickedLocation = true;
          });
          _mapController.move(newPos, 17);
        } else {
          _showSnack('Lokasi tidak ditemukan');
        }
      }
    } on TimeoutException {
      _showSnack('Koneksi timeout, coba lagi');
    } catch (_) {
      _showSnack('Gagal mencari lokasi');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _isLoading = true);
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?lat=${pos.latitude}&lon=${pos.longitude}&format=json',
      );
      final response = await http
          .get(uri, headers: {'User-Agent': 'StipresApp/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name'] as String? ?? '';
        final short = address.split(',').take(3).join(',').trim();
        setState(() {
          _locationName = short.isEmpty ? 'Lokasi dipilih' : short;
          _searchController.text = _locationName;
          _hasPickedLocation = true;
        });
      }
    } catch (_) {
      setState(() {
        _locationName = 'Lokasi dipilih';
        _hasPickedLocation = true;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showPermissionDialog(
          title: 'GPS Tidak Aktif',
          message: 'Aktifkan GPS di pengaturan perangkat kamu.',
          onSettings: () => Geolocator.openLocationSettings(),
        );
        return;
      }

      PermissionStatus status = await Permission.locationWhenInUse.status;
      if (status.isDenied) {
        status = await Permission.locationWhenInUse.request();
      }
      if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          title: 'Izin Lokasi Ditolak',
          message:
              'Aktifkan izin lokasi secara manual di Pengaturan → Aplikasi → Stipres.',
          onSettings: () => openAppSettings(),
        );
        return;
      }
      if (!status.isGranted) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      final newPos = LatLng(pos.latitude, pos.longitude);
      setState(() => _pinPosition = newPos);
      _mapController.move(newPos, 17);
      await _reverseGeocode(newPos);
    } on TimeoutException {
      _showSnack('GPS timeout, coba di area terbuka');
    } catch (_) {
      _showSnack('Gagal mendapatkan lokasi GPS');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPermissionDialog({
    required String title,
    required String message,
    required VoidCallback onSettings,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 8),
          Flexible(child: Text(title)),
        ]),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                const Text('Tutup', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Buka Pengaturan',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Submit lokasi → pop dengan membawa hasil PickedLocation
  void _confirmLocation() {
    Navigator.pop(
      context,
      PickedLocation(
        name: _locationName,
        latitude: _pinPosition.latitude,
        longitude: _pinPosition.longitude,
      ),
    );
  }

  // ─── BUILD ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        children: [
          CustomHeader(title: 'Pilih Lokasi Presensi'),

          // ── Search bar ──
          Container(
            color: mainColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: _searchLocation,
                    decoration: InputDecoration(
                      hintText: 'Cari nama gedung / jalan...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.search, color: blueColor, size: 20),
                      suffixIcon: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: blueColor, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol lokasi saat ini
                GestureDetector(
                  onTap: _useCurrentLocation,
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.my_location, color: blueColor, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // ── Peta (expanded penuh) ──
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _pinPosition,
                    initialZoom: 16,
                    onTap: (_, latLng) {
                      setState(() => _pinPosition = latLng);
                      _reverseGeocode(latLng);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.stipres.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _pinPosition,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.location_pin,
                            color: blueColor,
                            size: 48,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Tombol zoom ──
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    children: [
                      _zoomButton(Icons.add, () {
                        _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom + 1,
                        );
                      }),
                      const SizedBox(height: 4),
                      _zoomButton(Icons.remove, () {
                        _mapController.move(
                          _mapController.camera.center,
                          _mapController.camera.zoom - 1,
                        );
                      }),
                    ],
                  ),
                ),

                // ── Info nama lokasi terpilih ──
                Positioned(
                  top: 12,
                  left: 12,
                  right: 70,
                  child: AnimatedOpacity(
                    opacity: _hasPickedLocation ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: blueColor, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _locationName,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Info tap peta ──
                Positioned(
                  bottom: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Tap pada peta untuk memilih lokasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Tombol Konfirmasi Lokasi ──
          Container(
            color: mainColor,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _hasPickedLocation ? _confirmLocation : null,
                icon: const Icon(Icons.check_circle_outline,
                    color: Colors.white),
                label: Text(
                  'Konfirmasi Lokasi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12), blurRadius: 4),
          ],
        ),
        child: Icon(icon, size: 20, color: blueColor),
      ),
    );
  }
}