enum ValidationStatus { idle, checking, success, failed }

class ValidationStepModel {
  final String title;
  final String description;

  ValidationStatus status;

  ValidationStepModel(
      {required this.title,
      required this.description,
      this.status = ValidationStatus.idle});
}
