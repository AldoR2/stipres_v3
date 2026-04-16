import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stipres/controllers/features_student/home/calendar_controller.dart';
import 'package:stipres/screens/reusable/custom_header.dart';
import 'package:stipres/constants/styles.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _controller = Get.find<CalendarController>();

  // Simulasi data dari database
  // final Map<DateTime, List<Map<String, String>>> _events = {
  //   DateTime.utc(2025, 4, 1): [
  //     {'title': 'Hari Raya Idul Fitri 1446 H', 'type': 'Libur'},
  //   ],
  //   DateTime.utc(2025, 4, 10): [
  //     {'title': 'Ujian Akhir Semester 2024/2025', 'type': 'Kegiatan'},
  //   ],
  //   DateTime.utc(2025, 4, 14): [
  //     {'title': 'Libur Kenaikan Semester', 'type': 'Libur'},
  //   ],
  //   DateTime.utc(2025, 4, 24): [
  //     {'title': 'Batas Pembayaran UKT Semester Genap', 'type': 'Kegiatan'},
  //     {'title': 'Perbaikan Nilai', 'type': 'Kegiatan'},
  //   ],
  //   DateTime.utc(2025, 4, 30): [
  //     {'title': 'Perkuliahan Semester Genap', 'type': 'Kegiatan'},
  //   ],
  // };

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _controller.getEventsForDay(day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final selectedEvents =
        _controller.getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
        backgroundColor: styles.getMainColor(context),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              Column(
                children: [
                  CustomHeader(title: "Kalender Akademik"),
                  SizedBox(height: 10),
                  TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: _getEventsForDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      headerPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.07, vertical: 10),
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        color: blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: blueColor,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: blueColor,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      // existing defaultBuilder (biarkan tetap)
                      defaultBuilder: (context, day, focusedDay) {
                        final isSelected = isSameDay(day, _selectedDay);
                        final isToday = isSameDay(day, DateTime.now());

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = day;
                                _focusedDay = focusedDay;
                              });
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : isToday
                                          ? Colors.orange
                                          : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: isSelected || isToday
                                          ? Colors.white
                                          : styles.getTextColor(context),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },

                      markerBuilder: (context, day, events) {
                        final dateKey =
                            DateTime.utc(day.year, day.month, day.day);
                        final eventList = _controller.getEventsForDay(day);
                        [dateKey];

                        if (eventList == null || eventList.isEmpty)
                          return const SizedBox();

                        // Cek apakah ada event Libur dan Kegiatan
                        final hasHoliday =
                            eventList.any((e) => e['type'] == 'Libur');
                        final hasKegiatan =
                            eventList.any((e) => e['type'] == 'Kegiatan');

                        List<Widget> markers = [];

                        if (hasHoliday) {
                          markers.add(_buildDot(Colors.red));
                        }
                        if (hasKegiatan) {
                          markers.add(_buildDot(Colors.green));
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: markers,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child:
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: selectedEvents.isEmpty
                          ? Center(
                              key: ValueKey("no_event"),
                              child: Text(
                                "Tidak ada acara pada hari ini.",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: greyColor),
                              ),
                            )
                          : ListView.builder(
                              key: const ValueKey("has_event"),
                              itemCount: selectedEvents.length,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemBuilder: (context, index) {
                                final event = selectedEvents[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: event['type'] == 'Libur'
                                              ? Colors.red[400]
                                              : Colors.green[400],
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "${_selectedDay!.day.toString().padLeft(2, '0')}\n${_getMonthName(_selectedDay!.month)}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: event['type'] == 'Libur'
                                                ? Colors.red[300]
                                                : Colors.green[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event['title'] ?? '',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteColor),
                                              ),
                                              Text(
                                                event['type'] ?? '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: whiteColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          );
        }));
  }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES'
    ];
    return months[month - 1];
  }
}

Widget _buildDot(Color color) {
  return Container(
    width: 6,
    height: 6,
    margin: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}
