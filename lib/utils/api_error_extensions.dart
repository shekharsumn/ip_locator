import 'package:ip_locator/utils/api_error.dart';

/// Extension for ApiError to provide user-friendly messages
/// Follows Open/Closed Principle - extends functionality without modifying ApiError
extension ApiErrorExtensions on ApiError {
  /// Get user-friendly error message based on error type
  String get userFriendlyMessage {
    switch (type) {
      case ApiErrorType.network:
        return 'No internet connection. Please check your network settings and try again.';
      case ApiErrorType.timeout:
        return 'The request timed out. Please check your connection and try again.';
      case ApiErrorType.server:
        if (statusCode == 500) {
          return 'The server is experiencing issues. Please try again later.';
        }
        return 'Server error occurred. Please try again later.';
      case ApiErrorType.badRequest:
        return 'Invalid IP address format. Please enter a valid IPv4 or IPv6 address.';
      case ApiErrorType.notFound:
        return 'No location data found for this IP address.';
      case ApiErrorType.unauthorized:
        return 'Access denied. Please check your API credentials.';
      case ApiErrorType.rateLimited:
        return message.isNotEmpty
            ? message
            : 'Too many requests. Please try again later.';
      case ApiErrorType.cancelled:
        return 'Request was cancelled.';
      case ApiErrorType.methodNotAllowed:
        return 'Operation not supported.';
      case ApiErrorType.unknown:
        return message.isNotEmpty
            ? message
            : 'An unexpected error occurred. Please try again.';
    }
  }

  /// Get appropriate icon for error type
  String get errorIcon {
    switch (type) {
      case ApiErrorType.network:
        return '📡';
      case ApiErrorType.timeout:
        return '⏰';
      case ApiErrorType.server:
        return '🔧';
      case ApiErrorType.badRequest:
        return '❌';
      case ApiErrorType.notFound:
        return '🔍';
      case ApiErrorType.unauthorized:
        return '🔒';
      case ApiErrorType.rateLimited:
        return '⏱️';
      case ApiErrorType.cancelled:
        return '🚫';
      case ApiErrorType.methodNotAllowed:
        return '⚠️';
      case ApiErrorType.unknown:
        return '⚠️';
    }
  }
}
