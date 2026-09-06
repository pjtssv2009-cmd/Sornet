class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;
  final int statusCode;

  ApiResponse({
    required this.isSuccess,
    this.data,
    this.errorMessage,
    this.statusCode = 200,
  });

  factory ApiResponse.success(T data, {int statusCode = 200}) {
    return ApiResponse(isSuccess: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String message, {int statusCode = 400}) {
    return ApiResponse(isSuccess: false, errorMessage: message, statusCode: statusCode);
  }
}

class ApiClient {
  static const String baseUrl = 'https://api.sornet.com/v1/technician';

  // Future REST API integration hooks
  Future<ApiResponse<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParams}) async {
    // Simulated network client
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.error('Using local offline-first repository layer');
  }

  Future<ApiResponse<T>> post<T>(String endpoint, {Map<String, dynamic>? body}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.error('Using local offline-first repository layer');
  }
}
