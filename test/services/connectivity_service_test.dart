import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ip_locator/domain/services/connectivity_service.dart';
import 'dart:async';

/// Mock implementation of Connectivity for testing
class MockConnectivity implements Connectivity {
  List<ConnectivityResult> _mockResults = [ConnectivityResult.wifi];
  StreamController<List<ConnectivityResult>>? _controller;

  void setMockConnectivityResults(List<ConnectivityResult> results) {
    _mockResults = results;
  }

  void simulateConnectivityChange(List<ConnectivityResult> results) {
    _controller?.add(results);
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return _mockResults;
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    _controller ??= StreamController<List<ConnectivityResult>>.broadcast();
    return _controller!.stream;
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}

void main() {
  group('ConnectivityServiceImpl Tests', () {
    late MockConnectivity mockConnectivity;
    late ConnectivityServiceImpl connectivityService;

    setUp(() {
      mockConnectivity = MockConnectivity();
      connectivityService = ConnectivityServiceImpl(connectivity: mockConnectivity);
    });

    tearDown(() {
      mockConnectivity.dispose();
    });

    group('hasInternetConnection Tests', () {
      test('should return true when connected to wifi', () async {
        mockConnectivity.setMockConnectivityResults([ConnectivityResult.wifi]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, true);
      });

      test('should return true when connected to mobile', () async {
        mockConnectivity.setMockConnectivityResults([ConnectivityResult.mobile]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, true);
      });

      test('should return true when connected to ethernet', () async {
        mockConnectivity.setMockConnectivityResults([ConnectivityResult.ethernet]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, true);
      });

      test('should return true when connected to multiple networks', () async {
        mockConnectivity.setMockConnectivityResults([
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
        ]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, true);
      });

      test('should return false when no connection', () async {
        mockConnectivity.setMockConnectivityResults([ConnectivityResult.none]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, false);
      });

      test('should return false when connectivity results are empty', () async {
        mockConnectivity.setMockConnectivityResults([]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, false);
      });

      test('should return false when only none connection in multiple results', () async {
        mockConnectivity.setMockConnectivityResults([
          ConnectivityResult.none,
          ConnectivityResult.none,
        ]);

        final result = await connectivityService.hasInternetConnection();

        expect(result, false);
      });

      test('should return false when mixed connections including none', () async {
        mockConnectivity.setMockConnectivityResults([
          ConnectivityResult.none,
          ConnectivityResult.wifi,
        ]);

        final result = await connectivityService.hasInternetConnection();

        // The actual implementation returns false if ANY connection is 'none'
        expect(result, false);
      });
    });

    group('getConnectivityStatus Tests', () {
      test('should return wifi connectivity status', () async {
        final expectedResults = [ConnectivityResult.wifi];
        mockConnectivity.setMockConnectivityResults(expectedResults);

        final result = await connectivityService.getConnectivityStatus();

        expect(result, equals(expectedResults));
      });

      test('should return mobile connectivity status', () async {
        final expectedResults = [ConnectivityResult.mobile];
        mockConnectivity.setMockConnectivityResults(expectedResults);

        final result = await connectivityService.getConnectivityStatus();

        expect(result, equals(expectedResults));
      });

      test('should return none connectivity status', () async {
        final expectedResults = [ConnectivityResult.none];
        mockConnectivity.setMockConnectivityResults(expectedResults);

        final result = await connectivityService.getConnectivityStatus();

        expect(result, equals(expectedResults));
      });

      test('should return multiple connectivity statuses', () async {
        final expectedResults = [
          ConnectivityResult.wifi,
          ConnectivityResult.mobile,
        ];
        mockConnectivity.setMockConnectivityResults(expectedResults);

        final result = await connectivityService.getConnectivityStatus();

        expect(result, equals(expectedResults));
      });

      test('should return empty list when no connectivity', () async {
        final expectedResults = <ConnectivityResult>[];
        mockConnectivity.setMockConnectivityResults(expectedResults);

        final result = await connectivityService.getConnectivityStatus();

        expect(result, equals(expectedResults));
      });
    });

    group('connectivityStream Tests', () {
      test('should emit connectivity changes from stream', () async {
        final expectedResults = [ConnectivityResult.wifi];
        
        // Listen to the stream
        final streamFuture = connectivityService.connectivityStream.first;
        
        // Simulate connectivity change
        mockConnectivity.simulateConnectivityChange(expectedResults);
        
        // Wait for the stream to emit
        final result = await streamFuture;
        
        expect(result, equals(expectedResults));
      });

      test('should emit multiple connectivity changes', () async {
        final results = <List<ConnectivityResult>>[];
        
        // Listen to multiple emissions
        final subscription = connectivityService.connectivityStream.listen((data) {
          results.add(data);
        });
        
        // Simulate multiple connectivity changes
        mockConnectivity.simulateConnectivityChange([ConnectivityResult.wifi]);
        await Future.delayed(Duration.zero); // Allow stream to process
        
        mockConnectivity.simulateConnectivityChange([ConnectivityResult.mobile]);
        await Future.delayed(Duration.zero); // Allow stream to process
        
        mockConnectivity.simulateConnectivityChange([ConnectivityResult.none]);
        await Future.delayed(Duration.zero); // Allow stream to process
        
        subscription.cancel();
        
        expect(results.length, equals(3));
        expect(results[0], equals([ConnectivityResult.wifi]));
        expect(results[1], equals([ConnectivityResult.mobile]));
        expect(results[2], equals([ConnectivityResult.none]));
      });

      test('should handle stream cancellation properly', () async {
        final subscription = connectivityService.connectivityStream.listen((_) {});
        
        // Cancel the subscription
        await subscription.cancel();
        
        // This should not throw any errors
        expect(() => subscription.cancel(), returnsNormally);
      });
    });

    group('Integration Tests', () {
      test('should handle rapid connectivity changes', () async {
        final results = <List<ConnectivityResult>>[];
        
        final subscription = connectivityService.connectivityStream.listen((data) {
          results.add(data);
        });
        
        // Rapid connectivity changes
        for (int i = 0; i < 5; i++) {
          final connectivityType = i.isEven ? ConnectivityResult.wifi : ConnectivityResult.mobile;
          mockConnectivity.simulateConnectivityChange([connectivityType]);
          await Future.delayed(const Duration(milliseconds: 10));
        }
        
        subscription.cancel();
        
        expect(results.length, equals(5));
      });

      test('should maintain consistency between status check and stream', () async {
        // Set initial connectivity
        mockConnectivity.setMockConnectivityResults([ConnectivityResult.wifi]);
        
        // Check status
        final statusResult = await connectivityService.getConnectivityStatus();
        
        // Listen to stream
        final streamFuture = connectivityService.connectivityStream.first;
        mockConnectivity.simulateConnectivityChange([ConnectivityResult.wifi]);
        final streamResult = await streamFuture;
        
        expect(statusResult, equals(streamResult));
      });
    });

    group('Edge Cases', () {
      test('should handle null connectivity results gracefully', () async {
        // This test ensures the service handles edge cases properly
        mockConnectivity.setMockConnectivityResults([]);
        
        final hasConnection = await connectivityService.hasInternetConnection();
        final status = await connectivityService.getConnectivityStatus();
        
        expect(hasConnection, false);
        expect(status, isEmpty);
      });

      test('should handle connectivity service with default constructor', () {
        // Test that the service can be created with default connectivity
        final service = ConnectivityServiceImpl();
        
        expect(service, isNotNull);
        expect(service.connectivityStream, isNotNull);
      });
    });
  });
}