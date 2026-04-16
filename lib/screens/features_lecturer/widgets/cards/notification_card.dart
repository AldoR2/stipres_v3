import 'package:flutter/material.dart';
import 'package:stipres/screens/features_lecturer/models/notifications/detail_notification_model.dart';
import 'package:stipres/screens/features_lecturer/models/notifications/notification_model.dart';
import 'package:stipres/theme/theme_helper.dart' as styles;

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String iconPath;

    switch (notification.type) {
      case NotificationType.presensiGagal:
        backgroundColor = Colors.red;
        iconPath = 'assets/icons/ic_warning.png';
        break;
      case NotificationType.presensiBerhasil:
        backgroundColor = Colors.green;
        iconPath = 'assets/icons/ic_presence.png';
        break;
      case NotificationType.presensiAkanHabis:
        backgroundColor = Colors.blue;
        iconPath = 'assets/icons/ic_time.png';
        break;
      case NotificationType.pengumuman:
        backgroundColor = Colors.orange;
        iconPath = 'assets/icons/ic_announcement.png';
        break;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: styles.getTextField(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(iconPath, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: styles.getTextColor(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.time!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationChip extends StatelessWidget {
  final NotificationType type;

  const NotificationChip({required this.type});

  @override
  Widget build(BuildContext context) {
    String label =
        type == NotificationType.presensiBerhasil ? 'Presensi' : 'Pengumuman';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type == NotificationType.presensiBerhasil
            ? Colors.blue[50]
            : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: type == NotificationType.presensiBerhasil
              ? Colors.blue
              : Colors.orange,
        ),
      ),
    );
  }
}
