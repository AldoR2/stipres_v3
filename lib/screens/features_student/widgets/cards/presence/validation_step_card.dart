import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stipres/models/students/validation_step_model.dart';

class ValidationStepCard extends StatelessWidget {
  final ValidationStepModel step;

  ValidationStepCard({
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (step.status) {
      case ValidationStatus.checking:
        color = Colors.blue;
        break;
      case ValidationStatus.success:
        color = Colors.green;
        break;
      case ValidationStatus.failed:
        color = Colors.red;
        break;

      default:
        color = Colors.grey.shade300;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                step.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              )
            ],
          ))
        ],
      ),
    );
  }
}
