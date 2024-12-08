class ApiResponse {
  final bool status;
  final String message;
  final dynamic data;
  final String? accessToken;
  final String? tokenType;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.accessToken,
    this.tokenType,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error',
      data: json['data'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }

  // Konversi ke Map (opsional, jika diperlukan untuk POST)
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'access_token': accessToken,
      'token_type': tokenType,
    };
  }
}
