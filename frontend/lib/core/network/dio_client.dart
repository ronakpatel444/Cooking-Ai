import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.28:8000', // Use your computer's IP for real device testing over Wi-Fi
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add interceptors here (e.g., for logging or auth tokens)
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
});
