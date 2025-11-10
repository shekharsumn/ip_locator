import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/presentation/providers/connectivity_notifier.dart';

/// Mock implementation of ConnectivityService for testing
class MockConnectivityService implements ConnectivityService {
  final StreamController<bool> _mockController = StreamController<bool>.broadcast();
  bool _mockConnected = false;

  @override
  Stream<bool> get connectivityStream => _mockController.stream;

  @override
  bool get isConnected => _mockConnected;

  @override
  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    // Mock initialization - no-op
  }

  void setConnectivity(bool connected) {
    // Only emit if the value actually changed, like the real service
    if (_mockConnected != connected) {
      _mockConnected = connected;
      _mockController.add(connected);
    }
  }

  void addError(Object error) {
    _mockController.addError(error);
  }

  @override
  void dispose() {
    _mockController.close();
  }
}

void main() {
  group('ConnectivityService Tests', () {
    late ConnectivityService connectivityService;

    setUp(() {
      connectivityService = ConnectivityService();
      // Ensure service is properly disposed before each test
      connectivityService.dispose();
    });

    tearDown(() {
      connectivityService.dispose();
    });

    group('Singleton Pattern Tests', () {
      test('should return the same instance when called multiple times', () {
        final instance1 = ConnectivityService();
        final instance2 = ConnectivityService();
        
        expect(instance1, equals(instance2));
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('Initialization Tests', () {
      test('should initialize with default parameters', () {
        expect(() => connectivityService.initialize(), returnsNormally);
      });

      test('should initialize with custom check interval', () {
        expect(
          () => connectivityService.initialize(
            checkInterval: const Duration(seconds: 10),
          ),
          returnsNormally,
        );
      });

      test('should start with default connectivity state', () {
        // Initially should be false until first check
        expect(connectivityService.isConnected, isFalse);
      });
    });

    group('Stream Tests', () {
      test('should provide connectivity stream', () {
        expect(connectivityService.connectivityStream, isA<Stream<bool>>());
      });

      test('should emit connectivity changes on stream', () async {
        final mockService = MockConnectivityService();
        final streamEvents = <bool>[];
        
        final subscription = mockService.connectivityStream.listen(
          (connected) => streamEvents.add(connected),
        );

        // Simulate connectivity changes
        mockService.setConnectivity(true);
        mockService.setConnectivity(false);
        mockService.setConnectivity(true);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(streamEvents, equals([true, false, true]));
        
        await subscription.cancel();
        mockService.dispose();
      });

      test('should handle stream errors gracefully', () async {
        final mockService = MockConnectivityService();
        final streamEvents = <bool>[];
        final streamErrors = <Object>[];
        
        final subscription = mockService.connectivityStream.listen(
          (connected) => streamEvents.add(connected),
          onError: (error) => streamErrors.add(error),
        );

        // Simulate normal connectivity and error
        mockService.setConnectivity(true);
        mockService.addError('Test error');
        mockService.setConnectivity(false);

        await Future.delayed(const Duration(milliseconds: 100));

        expect(streamEvents, equals([true, false]));
        expect(streamErrors, isNotEmpty);
        
        await subscription.cancel();
        mockService.dispose();
      });
    });

    group('State Management Tests', () {
      test('should track connectivity state correctly', () {
        final mockService = MockConnectivityService();
        
        expect(mockService.isConnected, isFalse);
        
        mockService.setConnectivity(true);
        expect(mockService.isConnected, isTrue);
        
        mockService.setConnectivity(false);
        expect(mockService.isConnected, isFalse);
        
        mockService.dispose();
      });

      test('should only emit when state changes', () async {
        final mockService = MockConnectivityService();
        final streamEvents = <bool>[];
        
        final subscription = mockService.connectivityStream.listen(
          (connected) => streamEvents.add(connected),
        );

        // Set same value multiple times
        mockService.setConnectivity(true);
        mockService.setConnectivity(true);
        mockService.setConnectivity(true);
        
        // Change to different value
        mockService.setConnectivity(false);
        mockService.setConnectivity(false);
        
        // Change back
        mockService.setConnectivity(true);

        await Future.delayed(const Duration(milliseconds: 100));

        // Should only emit when value actually changes
        expect(streamEvents, equals([true, false, true]));
        
        await subscription.cancel();
        mockService.dispose();
      });
    });

    group('Disposal Tests', () {
      test('should dispose resources properly', () {
        final mockService = MockConnectivityService();
        
        expect(() => mockService.dispose(), returnsNormally);
        expect(mockService.connectivityStream.isBroadcast, isTrue);
      });

      test('should stop timer on disposal', () async {
        final service = ConnectivityService();
        service.initialize(checkInterval: const Duration(milliseconds: 100));
        
        // Let it run for a short time
        await Future.delayed(const Duration(milliseconds: 150));
        
        // Dispose should stop the timer
        expect(() => service.dispose(), returnsNormally);
      });
    });
  });

  group('Provider Tests', () {
    group('connectivityServiceProvider Tests', () {
      test('should provide ConnectivityService instance', () {
        final container = ProviderContainer();
        final service = container.read(connectivityServiceProvider);
        
        expect(service, isA<ConnectivityService>());
        
        container.dispose();
      });

      test('should initialize service automatically', () {
        final container = ProviderContainer();
        final service = container.read(connectivityServiceProvider);
        
        // Service should be initialized (has stream)
        expect(service.connectivityStream, isA<Stream<bool>>());
        
        container.dispose();
      });

      test('should dispose service when container is disposed', () {
        final container = ProviderContainer();
        container.read(connectivityServiceProvider);
        
        // Should not throw when disposing
        expect(() => container.dispose(), returnsNormally);
      });
    });

    group('connectivityStreamProvider Tests', () {
      test('should provide connectivity stream', () async {
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(MockConnectivityService()),
          ],
        );
        
        final streamAsync = container.read(connectivityStreamProvider);
        
        expect(streamAsync, isA<AsyncValue<bool>>());
        
        container.dispose();
      });

      test('should handle stream data correctly', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        // Listen to the stream to trigger subscription
        final listener = container.listen(connectivityStreamProvider, (_, __) {});
        
        // Emit connectivity data
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Should eventually have data
        final streamAsync = container.read(connectivityStreamProvider);
        expect(streamAsync.hasValue, isTrue);
        expect(streamAsync.value, isTrue);
        
        listener.close();
        container.dispose();
        mockService.dispose();
      });

      test('should handle stream errors correctly', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        // Listen to the stream to trigger subscription
        final listener = container.listen(connectivityStreamProvider, (_, __) {});
        
        // Emit error
        mockService.addError('Connection check failed');
        await Future.delayed(const Duration(milliseconds: 100));
        
        final streamAsync = container.read(connectivityStreamProvider);
        expect(streamAsync.hasError, isTrue);
        
        listener.close();
        container.dispose();
        mockService.dispose();
      });
    });

    group('isConnectedProvider Tests', () {
      test('should return false when loading', () {
        final container = ProviderContainer(
          overrides: [
            connectivityStreamProvider.overrideWith(
              (ref) => const Stream<bool>.empty(),
            ),
          ],
        );
        
        final isConnected = container.read(isConnectedProvider);
        expect(isConnected, isFalse);
        
        container.dispose();
      });

      test('should return false on error', () {
        final container = ProviderContainer(
          overrides: [
            connectivityStreamProvider.overrideWith(
              (ref) => Stream<bool>.error('Test error'),
            ),
          ],
        );
        
        final isConnected = container.read(isConnectedProvider);
        expect(isConnected, isFalse);
        
        container.dispose();
      });

      test('should return actual value when data available', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        // Listen to trigger subscription
        final listener = container.listen(connectivityStreamProvider, (_, __) {});
        
        // Set connectivity to true
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 100));
        
        final isConnected = container.read(isConnectedProvider);
        expect(isConnected, isTrue);
        
        listener.close();
        container.dispose();
        mockService.dispose();
      });

      test('should react to connectivity changes', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        final connectivityValues = <bool>[];
        
        // Listen to provider changes
        container.listen(
          isConnectedProvider,
          (previous, next) => connectivityValues.add(next),
          fireImmediately: true,
        );
        
        // Simulate connectivity changes
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 50));
        
        mockService.setConnectivity(false);
        await Future.delayed(const Duration(milliseconds: 50));
        
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Should have captured all changes
        expect(connectivityValues, contains(false)); // Initial
        expect(connectivityValues, contains(true));
        
        container.dispose();
        mockService.dispose();
      });
    });

    group('Provider Integration Tests', () {
      test('should work together as expected', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        // Listen to trigger subscription
        final listener = container.listen(connectivityStreamProvider, (_, __) {});
        
        // Set connected
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(container.read(isConnectedProvider), isTrue);
        
        final streamAsync = container.read(connectivityStreamProvider);
        expect(streamAsync.hasValue, isTrue);
        expect(streamAsync.value, isTrue);
        
        // Set disconnected
        mockService.setConnectivity(false);
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(container.read(isConnectedProvider), isFalse);
        
        listener.close();
        container.dispose();
        mockService.dispose();
      });

      test('should handle multiple subscribers correctly', () async {
        final mockService = MockConnectivityService();
        final container = ProviderContainer(
          overrides: [
            connectivityServiceProvider.overrideWithValue(mockService),
          ],
        );
        
        final subscriber1Values = <bool>[];
        final subscriber2Values = <bool>[];
        
        // Multiple listeners
        container.listen(
          isConnectedProvider,
          (previous, next) => subscriber1Values.add(next),
          fireImmediately: true,
        );
        
        container.listen(
          isConnectedProvider,
          (previous, next) => subscriber2Values.add(next),
          fireImmediately: true,
        );
        
        // Emit changes
        mockService.setConnectivity(true);
        await Future.delayed(const Duration(milliseconds: 50));
        
        mockService.setConnectivity(false);
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Both subscribers should receive updates
        expect(subscriber1Values, isNotEmpty);
        expect(subscriber2Values, isNotEmpty);
        expect(subscriber1Values, equals(subscriber2Values));
        
        container.dispose();
        mockService.dispose();
      });
    });
  });
}