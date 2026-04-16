import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:stipres/models/calendar_model.dart';
import 'package:stipres/screens/reusable/loading_screen.dart';
import 'package:stipres/services/academic_calendar_service.dart';

class CalendarController extends GetxController {
  final _box = GetStorage();
  final Logger log = Logger();
  final AcademicCalendarService academicCalendarService =
      AcademicCalendarService();
  var calenderList = <EventCalendar>[].obs;
  final RxMap<DateTime, List<Map<String, String>>> eventsMap =
      <DateTime, List<Map<String, String>>>{}.obs;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(DateTime.now());
  // Di CalendarController, tambahkan:
  final RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchCalendar();
    log.d("Fetch calendar");
  }

  Future<void> fetchCalendar() async {
    try {
      isLoading.value = true;

      final result = await academicCalendarService.fetchCalendar();

      if (result.status == 'success') {
        final calendar = result.data ?? []; // default empty list
        // Get.back();
        calenderList.assignAll(calendar);
        log.d(result.data);
        eventsMap.assignAll(_generateEventMap(calendar));
        log.d(isLoading.value);
      } else {
        // Get.back();

        log.w("Fetch calendar failed: ${result.message}");
      }
    } catch (e) {
      log.f("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<DateTime, List<Map<String, String>>> _generateEventMap(
      List<EventCalendar> calendarList) {
    final Map<DateTime, List<Map<String, String>>> eventMap = {};

    for (var event in calendarList) {
      final DateTime startDate = event.tanggalMulai;
      final DateTime? endDate =
          event.tanggalSelesai != null ? event.tanggalSelesai : null;

      final String type = event.status == 1 ? 'Kegiatan' : 'Libur';

      // loop dari startDate ke endDate jika endDate ada, kalau tidak, hanya 1 hari
      DateTime currentDate = startDate;
      while (true) {
        final dateKey =
            DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
        eventMap.putIfAbsent(dateKey, () => []);
        eventMap[dateKey]!.add({'title': event.judul, 'type': type});

        if (endDate == null || currentDate.isAtSameMomentAs(endDate)) break;

        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return eventMap;
  }

  List<Map<String, String>> getEventsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return eventsMap[key] ?? [];
  }

  void showLoading() {
    Get.dialog(const LoadingPopup(),
        barrierDismissible: false, barrierColor: Colors.black.withOpacity(0.3));
  }
}
