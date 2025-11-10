import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  group('HomePageViewModel Clear IP Address Test', () {
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

    test('should clear IP address field when clearIpAddress is called', () {
      // Set an IP address first
      viewModel.updateIpAddress('8.8.8.8');
      
      var state = container.read(homePageViewModelProvider);
      expect(state.ipAddress, '8.8.8.8');
      
      // Clear the IP address
      viewModel.clearIpAddress();
      
      // Check that IP address is cleared
      state = container.read(homePageViewModelProvider);
      expect(state.ipAddress, '');
      expect(state.validationError, null);
      expect(state.apiError, null);
      expect(state.locationData, null);
    });

    test('should clear IP address after updating it multiple times', () {
      // Set multiple IP addresses
      viewModel.updateIpAddress('1.1.1.1');
      viewModel.updateIpAddress('8.8.8.8');
      viewModel.updateIpAddress('192.168.1.1');
      
      var state = container.read(homePageViewModelProvider);
      expect(state.ipAddress, '192.168.1.1');
      
      // Clear the IP address
      viewModel.clearIpAddress();
      
      // Check that IP address is cleared
      state = container.read(homePageViewModelProvider);
      expect(state.ipAddress, '');
    });
  });
}