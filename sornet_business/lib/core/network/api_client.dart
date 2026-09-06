import 'dart:convert';
import 'package:flutter/foundation.dart';

enum ApiEnvironment { mock, development, staging, production }

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode = 200,
  });
}

class ApiClient {
  static ApiEnvironment environment = ApiEnvironment.mock;
  static String baseUrl = 'https://api.sornet.com/v1';
  static String? authToken;

  static void setAuthToken(String? token) {
    authToken = token;
  }

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        'X-Platform': 'Android-Business',
        'X-App-Version': '1.0.0',
      };

  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic json)? fromJson,
  }) async {
    debugPrint('[API GET] $baseUrl$endpoint | Query: $queryParams');
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse<T>(
      success: true,
      message: 'Success',
      statusCode: 200,
    );
  }

  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    debugPrint('[API POST] $baseUrl$endpoint | Body: ${jsonEncode(body)}');
    await Future.delayed(const Duration(milliseconds: 400));
    return ApiResponse<T>(
      success: true,
      message: 'Operation completed successfully',
      statusCode: 201,
    );
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    debugPrint('[API PUT] $baseUrl$endpoint | Body: ${jsonEncode(body)}');
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse<T>(
      success: true,
      message: 'Updated successfully',
      statusCode: 200,
    );
  }

  static Future<ApiResponse<bool>> delete(String endpoint) async {
    debugPrint('[API DELETE] $baseUrl$endpoint');
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse<bool>(
      success: true,
      data: true,
      statusCode: 200,
    );
  }
}
