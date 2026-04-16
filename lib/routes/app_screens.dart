import 'package:get/get.dart';
import 'package:stipres/bindings/auth/activation_step1_binding.dart';
import 'package:stipres/bindings/auth/activation_step2_binding.dart';
import 'package:stipres/bindings/auth/activation_step3_binding.dart';
import 'package:stipres/bindings/auth/forget_password_step1_binding.dart';
import 'package:stipres/bindings/auth/forget_password_step2_binding.dart';
import 'package:stipres/bindings/auth/forget_password_step3_binding.dart';
import 'package:stipres/bindings/auth/login_binding.dart';
import 'package:stipres/bindings/features_lecturer/add_presence_binding.dart';
import 'package:stipres/bindings/features_lecturer/all_schedule_binding.dart';
import 'package:stipres/bindings/features_lecturer/attendance_binding.dart';
import 'package:stipres/bindings/features_lecturer/lecture_binding.dart';
import 'package:stipres/bindings/features_lecturer/notification_binding.dart';
import 'package:stipres/bindings/features_lecturer/presence_binding.dart';
import 'package:stipres/bindings/features_lecturer/presence_detail_binding.dart';
import 'package:stipres/bindings/features_lecturer/view_profile_binding.dart';
import 'package:stipres/bindings/features_student/all_schedule_binding.dart';
import 'package:stipres/bindings/features_student/attendance_binding.dart';
import 'package:stipres/bindings/features_student/base_binding.dart' as student;
import 'package:stipres/bindings/features_lecturer/base_binding.dart';
import 'package:stipres/bindings/features_lecturer/dashboard_binding.dart';
import 'package:stipres/bindings/features_student/biometric_binding.dart';
import 'package:stipres/bindings/features_student/calendar_binding.dart';
import 'package:stipres/bindings/features_student/dashboard_binding.dart'
    as student;
import 'package:stipres/bindings/features_student/lecture_binding.dart';
import 'package:stipres/bindings/features_student/notification_binding.dart';
import 'package:stipres/bindings/features_student/presence_binding.dart';
import 'package:stipres/bindings/features_student/presence_content_binding.dart';
import 'package:stipres/bindings/features_student/profile_binding.dart'
    as student;
import 'package:stipres/bindings/features_lecturer/profile_binding.dart';
import 'package:stipres/bindings/features_student/settings_binding.dart';
import 'package:stipres/bindings/features_student/view_profile_binding.dart';
import 'package:stipres/screens/auth/activation_account_screen_1.dart';
import 'package:stipres/screens/auth/activation_account_screen_2.dart';
import 'package:stipres/screens/auth/activation_account_screen_3.dart';
import 'package:stipres/screens/auth/forget_password_screen_1.dart';
import 'package:stipres/screens/auth/forget_password_screen_2.dart';
import 'package:stipres/screens/auth/forget_password_screen_3.dart';
import 'package:stipres/screens/auth/login_screen.dart';
import 'package:stipres/screens/features_lecturer/account/view_profile.dart';
import 'package:stipres/screens/features_lecturer/home/all_schedule_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_lecturer/home/offline_screen.dart';
import 'package:stipres/screens/features_lecturer/home/presence/add_presence_screen.dart';
import 'package:stipres/screens/features_lecturer/home/presence/presence_detail_screen.dart';
import 'package:stipres/screens/features_student/account/alamat_email.dart'
    as student;
import 'package:stipres/screens/features_student/account/bantuan.dart';
import 'package:stipres/screens/features_student/account/kebijakan_privasi.dart';
import 'package:stipres/screens/features_student/account/ketentuan_layanan.dart';
import 'package:stipres/screens/features_student/account/pengaturan.dart'
    as student;
import 'package:stipres/screens/features_student/account/sidik_jari.dart';

import 'package:stipres/screens/features_student/account/view_profile.dart'
    as student;
import 'package:stipres/screens/features_student/home/all_schedule_screen.dart';
import 'package:stipres/screens/features_student/home/attendance_screen.dart';
import 'package:stipres/screens/features_lecturer/home/attendance/attendance_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/base_screen.dart'
    as student;
import 'package:stipres/screens/features_lecturer/home/base_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/calendar_screen.dart';
import 'package:stipres/screens/features_lecturer/home/calendar_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/lecture/lecture_content_screen.dart';
import 'package:stipres/screens/features_lecturer/home/lecture/lecture_content_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/lecture/lecture_screen.dart';
import 'package:stipres/screens/features_lecturer/home/lecture/lecture_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/notifications/notification_screen.dart';
import 'package:stipres/screens/features_lecturer/home/notifications/notification_screen.dart'
    as lecturer;
import 'package:stipres/screens/features_student/home/offline_screen.dart';
import 'package:stipres/screens/features_student/home/presence/presence_content_screen.dart';
import 'package:stipres/screens/features_student/home/presence/presence_screen.dart';
import 'package:stipres/screens/features_lecturer/home/presence/presence_screen.dart'
    as lecturer;

class AppScreens {
  static final screens = [
    GetPage(name: "/", page: () => LoginScreen(), binding: LoginBinding()),
    GetPage(
        name: "/auth/forget-password/step1",
        page: () => ForgetPassword1(),
        binding: ForgetPasswordStep1Binding()),
    GetPage(
        name: "/auth/forget-password/step2",
        page: () => ForgetPassword2(),
        binding: ForgetPasswordStep2Binding()),
    GetPage(
        name: "/auth/forget-password/step3",
        page: () => ForgetPassword3(),
        binding: ForgetPasswordStep3Binding()),
    GetPage(
        name: "/auth/activation/step1",
        page: () => ActivationAccount1(),
        binding: ActivationStep1Binding()),
    GetPage(
        name: "/auth/activation/step2",
        page: () => ActivationAccount2(),
        binding: ActivationStep2Binding()),
    GetPage(
        name: "/auth/activation/step3",
        page: () => ActivationAccount3(),
        binding: ActivationStep3Binding()),
    GetPage(
        name: "/lecturer/base-screen",
        page: () => lecturer.BaseScreenLecturer(),
        bindings: [
          LecturerBaseBinding(),
          LecturerDashboardBinding(),
          LecturerProfileBinding()
        ]),
    GetPage(
        name: "/lecturer/attendance-screen",
        page: () => lecturer.AttendanceScreen(),
        binding: LecturerAttendanceBinding()),
    GetPage(
        name: "/lecturer/presence-screen",
        page: () => lecturer.PresenceScreen(),
        binding: LecturerPresenceBinding()),
    GetPage(
        name: "/lecturer/add-presence-screen",
        page: () => AddPresenceScreen(),
        binding: AddPresenceBinding()),
    GetPage(
        name: "/lecturer/all-schedule-screen",
        page: () => lecturer.AllScheduleScreen(),
        binding: LecturerAllScheduleBinding()),
    GetPage(
      name: "/lecturer/calendar-screen",
      page: () => lecturer.CalendarScreen(),
    ),
    GetPage(
        name: "/lecturer/offline-screen", page: () => LecturerOfflineScreen()),
    GetPage(
        name: "/lecturer/lecture-screen",
        page: () => lecturer.LectureScreen(),
        binding: LecturerLectureBinding()),
    GetPage(
        name: "/lecturer/view-profile-screen",
        page: () => ViewProfilePage(),
        binding: LecturerViewProfileBinding()),
    GetPage(
        name: "/lecturer/notification-screen",
        page: () => lecturer.NotificationScreen(),
        binding: LecturerNotificationBinding()),
    GetPage(
        name: "/lecturer/presence-detail-screen",
        page: () => PresenceDetailScreen(),
        binding: PresenceDetailBinding()),
    GetPage(
        name: "/lecturer/lecture-content-screen",
        page: () => lecturer.LectureContentScreen(),
        binding: LecturerLectureBinding()),
    GetPage(
        name: "/student/base-screen",
        page: () => student.BaseScreen(),
        bindings: [
          student.BaseBinding(),
          student.DashboardBinding(),
          student.ProfileBinding()
        ]),
    GetPage(
        name: "/student/attendance-screen",
        page: () => AttendanceScreen(),
        binding: AttendanceBinding()),
    GetPage(
        name: "/student/presence-screen",
        page: () => PresenceScreen(),
        binding: PresenceBinding()),
    GetPage(name: "/student/offline-screen", page: () => OfflineScreen()),
    GetPage(
        name: "/student/calendar-screen",
        page: () => CalendarScreen(),
        binding: CalendarBinding()),
    GetPage(
        name: "/student/lecture-screen",
        page: () => LectureScreen(),
        binding: LectureBinding()),
    GetPage(
        name: "/student/all-schedule-screen",
        page: () => AllScheduleScreen(),
        binding: StudentAllScheduleBinding()),
    GetPage(
        name: "/student/view-profile-screen",
        page: () => student.ViewProfilePage(),
        binding: ViewProfileBinding()),
    GetPage(
        name: "/student/settings-screen",
        page: () => student.Pengaturan(),
        binding: SettingsBinding()),
    GetPage(
        name: "/student/biometric-screen",
        page: () => SidikJari(),
        binding: BiometricBinding()),
    GetPage(
        name: "/student/change-email-screen",
        page: () => student.AlamatEmail()),
    GetPage(name: "/student/help-screen", page: () => Bantuan()),
    GetPage(
        name: "/student/privacy-policy-screen", page: () => KetentuanLayanan()),
    GetPage(
        name: "/student/terms-of-service-screen",
        page: () => KebijakanPrivasi()),
    GetPage(
        name: "/student/notification-screen",
        page: () => NotificationScreen(),
        binding: NotificationBinding()),
    GetPage(
        name: "/student/presence-content-screen",
        page: () => PresenceContentScreen(),
        binding: PresenceContentBinding()),
    GetPage(
        name: "/student/lecture-content-screen",
        page: () => LectureContentScreen())
  ];
}
