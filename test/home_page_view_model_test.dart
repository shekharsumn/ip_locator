import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:ip_locator/domain/services/ip_validation_service.dart';
import 'package:ip_locator/domain/services/connectivity_service.dart';
import 'package:ip_locator/presentation/viewmodels/home_page_vm.dart';
import 'package:ip_locator/presentation/providers/service_providers.dart';

/// Mock connectivity service for testing
class MockConnectivityService implements ConnectivityService {
  @override
  Future<bool> hasInternetConnection() async => true;

  @override
  Future<List<ConnectivityResult>> getConnectivityStatus() async => [
    ConnectivityResult.wifi,
  ];

  @override
  Stream<List<ConnectivityResult>> get connectivityStream =>
      Stream.value([ConnectivityResult.wifi]);
}

void main() {
  group('HomePageViewModel Button Enabling', () {
    late ProviderContainer container;
    late HomePageViewModel viewModel;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      container = ProviderContainer(
        overrides: [
          connectivityServiceProvider.overrideWithValue(
            MockConnectivityService(),
          ),
        ],
      );
      viewModel = container.read(homePageViewModelProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('button should be disabled initially', () {
      final state = container.read(homePageViewModelProvider);
      expect(state.canFetchData, false);
      expect(state.ipAddress, '');
      expect(state.validationError, null);
    });

    test('button should be disabled with invalid IP', () {
      viewModel.updateIpAddress('invalid-ip');
      final state = container.read(homePageViewModelProvider);

      expect(state.canFetchData, false);
      expect(state.ipAddress, 'invalid-ip');
      expect(
        state.validationError,
        'Please enter a valid IPv4 or IPv6 address',
      );
    });

    test('button should be enabled with valid IPv4 address', () {
      viewModel.updateIpAddress('192.168.1.1');
      final state = container.read(homePageViewModelProvider);

      expect(state.canFetchData, true);
      expect(state.ipAddress, '192.168.1.1');
      expect(state.validationError, null);
    });

    test('button should be enabled with valid IPv6 address', () {
      viewModel.updateIpAddress('2001:db8::1');
      final state = container.read(homePageViewModelProvider);

      expect(state.canFetchData, true);
      expect(state.ipAddress, '2001:db8::1');
      expect(state.validationError, null);
    });

    test('button should be disabled with empty IP', () {
      viewModel.updateIpAddress('192.168.1.1'); // First enable it
      var state = container.read(homePageViewModelProvider);
      expect(state.canFetchData, true);

      viewModel.updateIpAddress(''); // Then clear it
      state = container.read(homePageViewModelProvider);

      expect(state.canFetchData, false);
      expect(state.ipAddress, '');
      expect(state.validationError, 'IP address cannot be empty');
    });

    test('validation service should work correctly', () {
      final service = IpValidationServiceImpl();

      // Test various IP formats
      expect(service.isValidIpAddress('8.8.8.8'), true);
      expect(service.isValidIpAddress('127.0.0.1'), true);
      expect(service.isValidIpAddress('::1'), true);
      expect(service.isValidIpAddress('2001:db8::1'), true);
      expect(service.isValidIpAddress('invalid'), false);
      expect(service.isValidIpAddress('256.1.1.1'), false);

      expect(service.getValidationError('8.8.8.8'), null);
      expect(
        service.getValidationError('invalid'),
        'Please enter a valid IPv4 or IPv6 address',
      );
      expect(service.getValidationError(''), 'IP address cannot be empty');
    });
  });
}
