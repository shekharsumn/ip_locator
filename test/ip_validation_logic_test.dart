import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';

void main() {
  group('IP Validation Tests', () {
    late IpValidationService service;

    setUp(() {
      service = IpValidationServiceImpl();
    });

    test('should validate IPv4 addresses correctly', () {
      expect(service.isValidIpv4Address('192.168.1.1'), true);
      expect(service.isValidIpv4Address('8.8.8.8'), true);
      expect(service.isValidIpv4Address('127.0.0.1'), true);
      expect(service.isValidIpv4Address('255.255.255.255'), true);

      expect(service.isValidIpv4Address('256.1.1.1'), false);
      expect(service.isValidIpv4Address('192.168.1'), false);
      expect(service.isValidIpv4Address('invalid'), false);
    });

    test('should validate IPv6 addresses correctly', () {
      expect(service.isValidIpv6Address('2001:db8::1'), true);
      expect(service.isValidIpv6Address('::1'), true);
      expect(service.isValidIpv6Address('::'), true);

      expect(service.isValidIpv6Address('192.168.1.1'), false);
      expect(service.isValidIpv6Address('invalid'), false);
    });

    test('should provide correct validation errors', () {
      expect(service.getValidationError(''), 'IP address cannot be empty');
      expect(
        service.getValidationError('invalid'),
        'Please enter a valid IPv4 or IPv6 address',
      );
      expect(service.getValidationError('192.168.1.1'), null);
      expect(service.getValidationError('2001:db8::1'), null);
    });

    test('button enabling logic should work', () {
      // Simulate the canFetchData logic
      String ipAddress = '';
      String? validationError = service.getValidationError(ipAddress);
      bool isLoading = false;

      bool canFetchData =
          ipAddress.isNotEmpty && validationError == null && !isLoading;
      expect(canFetchData, false); // Empty IP should disable button

      // Test with valid IP
      ipAddress = '192.168.1.1';
      validationError = service.getValidationError(ipAddress);
      canFetchData =
          ipAddress.isNotEmpty && validationError == null && !isLoading;
      expect(canFetchData, true); // Valid IP should enable button

      // Test with invalid IP
      ipAddress = 'invalid';
      validationError = service.getValidationError(ipAddress);
      canFetchData =
          ipAddress.isNotEmpty && validationError == null && !isLoading;
      expect(canFetchData, false); // Invalid IP should disable button

      // Test with loading state
      ipAddress = '192.168.1.1';
      validationError = service.getValidationError(ipAddress);
      isLoading = true;
      canFetchData =
          ipAddress.isNotEmpty && validationError == null && !isLoading;
      expect(canFetchData, false); // Loading should disable button
    });
  });
}
