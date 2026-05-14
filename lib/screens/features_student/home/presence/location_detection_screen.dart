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
      backgroundColor: styles.getMainColor(context),
      body: Column(
        children: [
          CustomHeader(
              title: "Presensi Mata Kuliah",
              backgroundColor: styles.getMainColor(context)),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  _buildMapPreview(),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(child: _buildValidationList()),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildProgressBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Obx(() {
      final location = controller.userLocation.value;

      if (location == null) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(24),
        child: SizedBox(
          height: 220,
          child: FlutterMap(
              options: MapOptions(
                  interactionOptions:
                      const InteractionOptions(flags: InteractiveFlag.none),
                  initialCenter:
                      LatLng(controller.targetLat, controller.targetLng),
                  initialZoom: 17),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.stipres.app',
                ),
                CircleLayer(circles: [
                  CircleMarker(
                      point: LatLng(controller.targetLat, controller.targetLng),
                      radius: controller.radiusMeter,
                      useRadiusInMeter: true,
                      color: blueColor.withValues(alpha: 0.2),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2)
                ]),
                MarkerLayer(markers: [
                  Marker(
                      point: LatLng(controller.targetLat, controller.targetLng),
                      width: 30,
                      height: 30,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ))
                ])
              ]),
        ),
      );
    });
  }

  Widget _buildValidationList() {
    return Obx(() {
      return ListView.separated(
          itemBuilder: (_, index) {
            final step = controller.steps[index];
            return ValidationStepCard(step: step);
          },
          separatorBuilder: (_, __) => const SizedBox(
                height: 14,
              ),
          itemCount: controller.steps.length);
    });
  }

  Widget _buildProgressBar() {
    return Obx(() {
      return Column(
        children: [
          LinearProgressIndicator(
            color: blueColor,
            value: controller.progress.value,
            minHeight: 10,
            borderRadius: BorderRadius.circular(100),
          ),
          const SizedBox(
            height: 8,
          ),
          Text('${(controller.progress.value * 100).toInt()} %')
        ],
      );
    });
  }
}
