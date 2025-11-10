import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';
import 'package:ip_locator/domain/services/connectivity_service.dart';

/// Provider for IP validation service
final ipValidationServiceProvider = Provider<IpValidationService>((ref) {
  return IpValidationServiceImpl();
});

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl();
});
