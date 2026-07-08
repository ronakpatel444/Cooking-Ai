import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://cooking-ai-1.onrender.com', // Live API URL
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
