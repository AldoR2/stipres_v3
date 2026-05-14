import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stipres/controllers/features_lecturer/account/profile_controller.dart';
import 'package:stipres/constants/styles.dart';
import 'package:stipres/controllers/features_lecturer/home/dashboard_controller.dart';
import 'package:stipres/theme/dialog_theme_helper.dart';
import 'package:stipres/theme/theme_controller.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class ProfileScreenLecturer extends StatefulWidget {
  ProfileScreenLecturer({Key? key}) : super(key: key);

  @override
  State<ProfileScreenLecturer> createState() => _ProfileScreenLecturerState();
}

class _ProfileScreenLecturerState extends State<ProfileScreenLecturer> {
  var height, width;

  final _controller = Get.find<ProfileController>();
  final dashboardCon = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: styles.getMainColor(context),
      body: Stack(
        children: [
          Column(
            children: [
              // =====================
              // HEADER (tidak diubah)
              // =====================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: styles.getBlueColor(context),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/bgheader.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        top: 24, left: 16, right: 16, bottom: 70),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Logo_PantiWaluya.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            "STIKES Panti Waluya Malang",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: () async {
                                  final result = await Get.toNamed(
                                      "/lecturer/notification-screen");
                                  if (result != null && result is bool) {
                                    setState(() {
                                      dashboardCon.hasNotification.value =
                                          result;
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                    dashboardCon.hasNotification.value
                                        ? Icons.notifications
                                        : Icons.notifications_none,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            if (dashboardCon.hasNotification.value)
                              const Positioned(
                                top: 2,
                                right: 2,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Corner decoration kanan bawah header
                  Positioned(
                    bottom: -44,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 44,
                      decoration: BoxDecoration(
                        color: styles.getBlueColor(context),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -45,
                    right: 0,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: styles.getMainColor(context),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // =====================
                  // FOTO PROFIL
                  // =====================
                  Positioned(
                    top: 105,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.blue.shade700,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: styles.getMainColor(context),
                                ),
                                child: ClipOval(
                                  child: Obx(() {
                                    final foto =
                                        _controller.storedProfile.value;
                                    return (foto.isNotEmpty)
                                        ? FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/icons/ic_profile.jpeg",
                                            image: foto,
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder:
                                                (context, url, error) {
                                              return Image.asset(
                                                "assets/icons/ic_profile.jpeg",
                                                height: 90,
                                                width: 90,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            "assets/icons/ic_profile.jpeg",
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                          );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // =====================
              // KONTEN UTAMA
              // =====================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- Nama, NIP, Email dalam card ----
                        _buildInfoCard(context, width),

                        const SizedBox(height: 16),

                        // ---- Tombol Lihat Profil ----
                        _buildViewProfileButton(context),

                        const SizedBox(height: 16),

                        // ---- Menu Card: Pengaturan & Ganti Password ----
                        _buildMenuCard(context),

                        const SizedBox(height: 16),

                        // ---- Tombol Logout ----
                        _buildLogoutButton(context),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================================
  // WIDGET: Info Card (Nama, NIP, Email)
  // ================================================
  Widget _buildInfoCard(BuildContext context, double width) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: styles.getTextField(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context: context,
            icon: Icons.person_outline_rounded,
            label: "Nama Lengkap",
            valueBuilder: () => Obx(() => Text(
                  _controller.storedName.value,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFA1A1A1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
          _buildDivider(),
          _buildInfoRow(
            context: context,
            icon: Icons.badge_outlined,
            label: "NIP",
            valueBuilder: () => Obx(() => Text(
                  _controller.storedNip.value,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFA1A1A1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
          _buildDivider(),
          _buildInfoRow(
            context: context,
            icon: Icons.email_outlined,
            label: "Email",
            valueBuilder: () => Obx(() => Text(
                  _controller.storedEmail.value,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFA1A1A1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Widget Function() valueBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: styles.getTextColor(context).withOpacity(0.5),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                valueBuilder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.15),
      thickness: 1,
      height: 1,
    );
  }

  // ================================================
  // WIDGET: Tombol Lihat Profil
  // ================================================
  Widget _buildViewProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed("/lecturer/view-profile-screen");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/ic_view.png', height: 20, width: 20),
            const SizedBox(width: 10),
            Text(
              "Lihat Profil",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================
  // WIDGET: Menu Card (Pengaturan & Ganti Password)
  // ================================================
  Widget _buildMenuCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: styles.getTextField(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            iconAsset: 'assets/icons/ic_settings.png',
            label: 'Pengaturan',
            onTap: () {
              Get.toNamed("/student/settings-screen");
            },
            showDivider: true,
          ),
          _buildMenuItem(
            context: context,
            iconAsset: 'assets/icons/ic_gantipassword.png',
            label: 'Ganti Password',
            onTap: () {
              _controller.changePassword();
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String iconAsset,
    required String label,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    iconAsset,
                    height: 22,
                    width: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: styles.getTextColor(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.withOpacity(0.5),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: Colors.grey.withOpacity(0.15),
              height: 1,
              thickness: 1,
            ),
          ),
      ],
    );
  }

  // ================================================
  // WIDGET: Tombol Logout
  // ================================================
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/ic_logout.png', height: 20, width: 20),
            const SizedBox(width: 10),
            Text(
              "Logout",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================
// DIALOG: Logout Confirmation (tidak diubah)
// ================================================
void _showLogoutDialog(BuildContext context) {
  final _controller = Get.find<ProfileController>();
  _controller.checkBiometric();
  final themeController = Get.find<ThemeController>();

  final isDarkMode = themeController.currentTheme == ThemeMode.dark;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: isDarkMode
            ? customDarkDialogTheme(Colors.blue)
            : customLightDialogTheme(Colors.blue),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'KONFIRMASI LOGOUT',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'Apakah anda yakin ingin keluar?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                    ),
                  ),
                  Obx(() {
                    final showBiometric =
                        _controller.isBiometricAvailable.value &&
                            _controller.isBiometricEnabled.value;

                    return showBiometric
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Simpan informasi login anda',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: _controller.saveLoginInfo.value,
                                    activeColor: Colors.blue,
                                    checkColor: Colors.white,
                                    onChanged: (bool? value) {
                                      _controller.saveLoginInfo.value =
                                          value ?? true;
                                      print(_controller.saveLoginInfo.value);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox.shrink();
                  }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
