import 'package:flutter/material.dart';
import 'package:stipres/models/students/validation_step_model.dart';

class ValidationStepCard extends StatelessWidget {
  final ValidationStepModel step;

  const ValidationStepCard({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(step.status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusConfig.borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusConfig.glowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatusIndicator(statusConfig),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.description,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildStatusBadge(statusConfig),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(_StatusConfig config) {
    if (step.status == ValidationStatus.checking) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(config.color),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: config.color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        config.icon,
        color: Colors.white,
        size: 12,
      ),
    );
  }

  Widget _buildStatusBadge(_StatusConfig config) {
    if (step.status == ValidationStatus.idle) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(ValidationStatus status) {
    switch (status) {
      case ValidationStatus.checking:
        return _StatusConfig(
          color: const Color(0xFF3B82F6),
          borderColor: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          glowColor: const Color(0xFF3B82F6).withValues(alpha: 0.08),
          icon: Icons.refresh_rounded,
          label: 'Mengecek',
        );
      case ValidationStatus.success:
        return _StatusConfig(
          color: const Color(0xFF22C55E),
          borderColor: const Color(0xFF22C55E).withValues(alpha: 0.3),
          glowColor: const Color(0xFF22C55E).withValues(alpha: 0.08),
          icon: Icons.check_rounded,
          label: 'Berhasil',
        );
      case ValidationStatus.failed:
        return _StatusConfig(
          color: const Color(0xFFEF4444),
          borderColor: const Color(0xFFEF4444).withValues(alpha: 0.3),
          glowColor: const Color(0xFFEF4444).withValues(alpha: 0.08),
          icon: Icons.close_rounded,
          label: 'Gagal',
        );
      default:
        return _StatusConfig(
          color: Colors.grey.shade400,
          borderColor: Colors.grey.shade200,
          glowColor: Colors.transparent,
          icon: Icons.circle_outlined,
          label: '',
        );
    }
  }
}

class _StatusConfig {
  final Color color;
  final Color borderColor;
  final Color glowColor;
  final IconData icon;
  final String label;

  _StatusConfig({
    required this.color,
    required this.borderColor,
    required this.glowColor,
    required this.icon,
    required this.label,
  });
}
