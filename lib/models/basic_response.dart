class BasicResponse {
  final String status;
  final String message;

  BasicResponse({required this.status, required this.message});

  factory BasicResponse.fromJson(Map<String, dynamic> json) {
    return BasicResponse(status: json['status'], message: json['message']);
  }
}
