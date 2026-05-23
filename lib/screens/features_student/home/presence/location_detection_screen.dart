import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_student/home/geolocation_controller.dart';
import 'package:stipres/screens/features_student/widgets/cards/presence/validation_step_card.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class LocationDetectionScreen extends StatelessWidget {
  LocationDetectionScreen({super.key});

  final controller = Get.find<GeolocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          CustomHeader(
            title: "Presensi Mata Kuliah",
            backgroundColor: styles.getMainColor(context),
          ),
          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalPadding = screenWidth * 0.055;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.022),
          _buildMapCard(context, screenHeight),
          SizedBox(height: screenHeight * 0.02),
          _buildProgressCard(context),
          SizedBox(height: screenHeight * 0.022),
          _buildSectionHeader("Status Validasi"),
          SizedBox(height: screenHeight * 0.012),
          Expanded(child: _buildValidationList()),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMapCard(BuildContext context, double screenHeight) {
    final mapHeight = screenHeight * 0.25;

    return Obx(() {
      final location = controller.userLocation.value;

      if (location == null) {
        return Container(
          height: mapHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF3B82F6),
                ),
                SizedBox(height: 14),
                Text(
                  "Mendeteksi lokasi...",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        height: mapHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                  initialCenter: (!controller.isAnywhereLocation.value)
                      ? LatLng(controller.targetLat, controller.targetLng)
                      : LatLng(location.latitude, location.longitude),
                  initialZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.stipres.app',
                  ),
                  (!controller.isAnywhereLocation.value)
                      ? CircleLayer(
                          circles: [
                            CircleMarker(
                              point: (!controller.isAnywhereLocation.value)
                                  ? LatLng(controller.targetLat,
                                      controller.targetLng)
                                  : LatLng(
                                      location.latitude, location.longitude),
                              radius: controller.radiusMeter,
                              useRadiusInMeter: true,
                              color: blueColor.withValues(alpha: 0.15),
                              borderColor: const Color(0xFF3B82F6),
                              borderStrokeWidth: 2,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: (!controller.isAnywhereLocation.value)
                            ? LatLng(controller.targetLat, controller.targetLng)
                            : LatLng(location.latitude, location.longitude),
                        width: 36,
                        height: 36,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFF3B82F6),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Gradient overlay + info label di bawah map
              (!controller.isAnywhereLocation.value)
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.my_location_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Radius ${controller.radiusMeter.toInt()} m dari lokasi kelas",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProgressCard(BuildContext context) {
    return Obx(() {
      final percent = (controller.progress.value * 100).toInt();
      final isDone = percent == 100;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progress Validasi",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF22C55E).withValues(alpha: 0.12)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$percent%",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: controller.progress.value,
                minHeight: 8,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDone ? const Color(0xFF22C55E) : const Color(0xFF3B82F6),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildValidationList() {
    return Obx(() {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final step = controller.steps[index];
          return ValidationStepCard(step: step);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemCount: controller.steps.length,
      );
    });
  }
}
