import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';

void main() {
  group('IpValidationService', () {
    late IpValidationService service;

    setUp(() {
      service = IpValidationServiceImpl();
    });

    group('IPv4 Validation', () {
      test('should validate correct IPv4 addresses', () {
        expect(service.isValidIpv4Address('192.168.1.1'), true);
        expect(service.isValidIpv4Address('8.8.8.8'), true);
        expect(service.isValidIpv4Address('127.0.0.1'), true);
        expect(service.isValidIpv4Address('255.255.255.255'), true);
      });

      test('should reject invalid IPv4 addresses', () {
        expect(service.isValidIpv4Address('256.1.1.1'), false);
        expect(service.isValidIpv4Address('192.168.1'), false);
        expect(service.isValidIpv4Address('192.168.1.1.1'), false);
        expect(service.isValidIpv4Address('abc.def.ghi.jkl'), false);
      });
    });

    group('IPv6 Validation', () {
      test('should validate correct IPv6 addresses', () {
        expect(service.isValidIpv6Address('2001:db8::1'), true);
        expect(service.isValidIpv6Address('::1'), true);
        expect(service.isValidIpv6Address('::'), true);
        expect(
          service.isValidIpv6Address('2001:0db8:85a3:0000:0000:8a2e:0370:7334'),
          true,
        );
      });

      test('should reject invalid IPv6 addresses', () {
        expect(service.isValidIpv6Address('192.168.1.1'), false);
        expect(service.isValidIpv6Address('invalid'), false);
        expect(service.isValidIpv6Address(''), false);
      });
    });

    group('General IP Validation', () {
      test('should validate both IPv4 and IPv6', () {
        expect(service.isValidIpAddress('192.168.1.1'), true);
        expect(service.isValidIpAddress('2001:db8::1'), true);
        expect(service.isValidIpAddress('invalid'), false);
      });

      test('should return appropriate error messages', () {
        expect(service.getValidationError(''), 'IP address cannot be empty');
        expect(
          service.getValidationError('invalid'),
          'Please enter a valid IPv4 or IPv6 address',
        );
        expect(service.getValidationError('192.168.1.1'), null);
      });
    });
  });
}
