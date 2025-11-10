import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';

void main() {
  group('Validation Error Clearing Logic Tests', () {
    late IpValidationService validationService;

    setUp(() {
      validationService = IpValidationServiceImpl();
    });

    test('validation error should clear when IP becomes valid', () {
      // First enter an invalid IP
      String? error = validationService.getValidationError('invalid-ip');
      expect(error, isNotNull);
      expect(error, 'Please enter a valid IPv4 or IPv6 address');

      // Then enter a valid IP - error should clear
      error = validationService.getValidationError('192.168.1.1');
      expect(error, isNull);
    });

    test('validation error should appear and disappear correctly', () {
      // Start with empty - should have error
      String? error = validationService.getValidationError('');
      expect(error, 'IP address cannot be empty');

      // Enter invalid IP - should still have error
      error = validationService.getValidationError('999.999.999.999');
      expect(error, 'Please enter a valid IPv4 or IPv6 address');

      // Enter valid IPv4 - error should clear
      error = validationService.getValidationError('8.8.8.8');
      expect(error, isNull);

      // Enter valid IPv6 - should remain clear
      error = validationService.getValidationError('2001:db8::1');
      expect(error, isNull);

      // Enter invalid again - error should appear
      error = validationService.getValidationError('not-an-ip');
      expect(error, 'Please enter a valid IPv4 or IPv6 address');
    });

    test('button enabling logic simulation', () {
      // Simulate the canFetchData logic with error clearing

      // Invalid IP scenario
      String ipAddress = 'invalid-ip';
      String? validationError = validationService.getValidationError(ipAddress);
      bool clearValidationError = validationError == null;
      bool canFetchData =
          ipAddress.isNotEmpty &&
          validationError == null &&
          !false; // isLoading = false

      expect(validationError, isNotNull);
      expect(clearValidationError, false);
      expect(canFetchData, false);

      // Valid IP scenario
      ipAddress = '192.168.1.1';
      validationError = validationService.getValidationError(ipAddress);
      clearValidationError = validationError == null;
      canFetchData = ipAddress.isNotEmpty && validationError == null && !false;

      expect(validationError, isNull);
      expect(
        clearValidationError,
        true,
      ); // This should clear the previous error
      expect(canFetchData, true);
    });
  });
}
