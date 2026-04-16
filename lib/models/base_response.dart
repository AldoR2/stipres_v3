class BaseResponse<T> {
  final String status;
  final String message;
  final T? data;

  BaseResponse({required this.status, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) createData,
  ) {
    return BaseResponse<T>(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? createData(json['data']) : null,
    );
  }
}

class BaseListResponse<T> {
  final String status;
  final String message;
  final List<T> data;

  BaseListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) createItem,
  ) {
    return BaseListResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((item) => createItem(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
