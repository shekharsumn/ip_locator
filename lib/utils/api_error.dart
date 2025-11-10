import 'package:dio/dio.dart';

enum ApiErrorType {
  network,
  timeout,
  server,
  cancelled,
  badRequest,
  unauthorized,
  notFound,
  methodNotAllowed,
  rateLimited,
  unknown,
}

class ApiError {
  factory ApiError.fromDio(DioException e) {
    // Status code aware mapping
    final int? statusCode = e.response?.statusCode;
    if (statusCode != null) {
      if (statusCode == 400) {
        return ApiError(
          type: ApiErrorType.badRequest,
          message: 'Bad request',
          statusCode: statusCode,
        );
      }
      if (statusCode == 401) {
        return ApiError(
          type: ApiErrorType.unauthorized,
          message: 'Unauthorized',
          statusCode: statusCode,
        );
      }
      if (statusCode == 404) {
        return ApiError(
          type: ApiErrorType.notFound,
          message: 'Not found',
          statusCode: statusCode,
        );
      }
      if (statusCode == 405) {
        return ApiError(
          type: ApiErrorType.methodNotAllowed,
          message: 'Method not allowed',
          statusCode: statusCode,
        );
      }
      if (statusCode == 429) {
        // Try to extract message from response for rate limiting
        String message = 'Quota exceeded';
        try {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic> &&
              responseData['message'] != null) {
            message = responseData['message'];
          }
        } catch (_) {
          // Use default message if parsing fails
        }
        return ApiError(
          type: ApiErrorType.rateLimited,
          message: message,
          statusCode: statusCode,
        );
      }
      if (statusCode >= 500) {
        return ApiError(
          type: ApiErrorType.server,
          message: 'Server error',
          statusCode: statusCode,
        );
      }
    }

    // DioException type mapping
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiError(
          type: ApiErrorType.timeout,
          message: 'Connection timed out',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        return ApiError(
          type: ApiErrorType.server,
          message: 'Server error',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const ApiError(
          type: ApiErrorType.cancelled,
          message: 'Request cancelled',
        );
      case DioExceptionType.connectionError:
        return const ApiError(
          type: ApiErrorType.network,
          message: 'No internet connection',
        );
      case DioExceptionType.unknown:
        // Heuristic for socket/ssl etc.
        if (e.error is Error ||
            e.message?.toLowerCase().contains('socket') == true) {
          return const ApiError(
            type: ApiErrorType.network,
            message: 'Network error',
          );
        }
        return const ApiError(
          type: ApiErrorType.unknown,
          message: 'Something went wrong',
        );
    }
  }

  const ApiError({required this.type, required this.message, this.statusCode});
  final ApiErrorType type;
  final String message;
  final int? statusCode;
}
