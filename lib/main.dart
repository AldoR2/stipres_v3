import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stipres/bindings/auth/auth_binding.dart';
import 'package:stipres/controllers/network_controller.dart';
import 'package:stipres/services/notification_service.dart';
import 'package:stipres/routes/app_screens.dart';
import 'package:stipres/theme/theme_controller.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting("id_ID", null);
  tzdata.initializeTimeZones();
  AuthBinding().dependencies();
  Get.put(NetworkController());
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.initialize();
  await handleNotificationPermission();
  await GetStorage.init();
  await _setupFirebaseMessaging();
  Get.put(ThemeController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          themeMode: themeController.themeMode.value,
          getPages: AppScreens.screens,
          initialRoute: "/",
        ));
  }
}

Future<void> handleNotificationPermission() async {
  final box = GetStorage();

  final settings = await FirebaseMessaging.instance.requestPermission();

  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
      // Bisa lanjut inisialisasi FCM token jika dibutuhkan
      break;

    case AuthorizationStatus.denied:
      box.write('isNotificationEnabled', false); // simpan sebagai boolean
      break;

    case AuthorizationStatus.provisional:
      // Mode silent (misal: iOS)
      break;

    case AuthorizationStatus.notDetermined:
      // Jarang terjadi karena requestPermission menampilkan dialog
      break;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // handle background notification
}

/// Set up Firebase Messaging handlers and permissions
Future<void> _setupFirebaseMessaging() async {
  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle when app is opened from background
  _setupOnMessageOpenedApp();
}

/// Setup handler for when app is opened from background
void _setupOnMessageOpenedApp() {
  FirebaseMessaging.onMessageOpenedApp.listen(_navigateBasedOnRole);
}

/// Navigate to appropriate screen based on user role
void _navigateBasedOnRole(RemoteMessage message) {
  final role = GetStorage().read("role");

  if (role == 'mahasiswa') {
    navigatorKey.currentState?.pushNamed('/student/notification-screen');
  } else if (role == 'dosen') {
    navigatorKey.currentState?.pushNamed('/lecturer/notification-screen');
  } else {
    navigatorKey.currentState?.pushNamed('/');
  }
}
