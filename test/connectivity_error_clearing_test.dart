import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:ip_locator/presentation/viewmodels/home_page_vm.dart';

void main() {
  group('Connectivity Error Clearing Tests', () {
    test('network error should be cleared when connectivity is restored', () {
      // Simulate the state management logic

      // Initial state with network error
      var currentState = const HomePageState(
        apiError: ApiError(
          type: ApiErrorType.network,
          message:
              'No internet connection. Please check your network settings.',
        ),
        hasConnectivity: false,
      );

      // Simulate connectivity being restored
      bool hasConnection = true;
      bool shouldClearNetworkError =
          hasConnection && currentState.apiError?.type == ApiErrorType.network;

      // Update state as the connectivity listener would
      currentState = currentState.copyWith(
        hasConnectivity: hasConnection,
        clearApiError: shouldClearNetworkError,
      );

      // Verify the network error is cleared
      expect(currentState.hasConnectivity, true);
      expect(currentState.apiError, isNull);
    });

    test('non-network errors should not be cleared on connectivity restore', () {
      // Initial state with a server error (not network error)
      var currentState = const HomePageState(
        apiError: ApiError(
          type: ApiErrorType.server,
          message: 'Server error occurred.',
        ),
        hasConnectivity: false,
      );

      // Simulate connectivity being restored
      bool hasConnection = true;
      bool shouldClearNetworkError =
          hasConnection && currentState.apiError?.type == ApiErrorType.network;

      // Update state as the connectivity listener would
      currentState = currentState.copyWith(
        hasConnectivity: hasConnection,
        clearApiError: shouldClearNetworkError,
      );

      // Verify the server error is NOT cleared (only network errors should be cleared)
      expect(currentState.hasConnectivity, true);
      expect(currentState.apiError, isNotNull);
      expect(currentState.apiError!.type, ApiErrorType.server);
    });

    test('no error clearing when connectivity remains lost', () {
      // Initial state with network error and no connectivity
      var currentState = const HomePageState(
        apiError: ApiError(
          type: ApiErrorType.network,
          message: 'No internet connection.',
        ),
        hasConnectivity: false,
      );

      // Update state with still no connectivity (clearApiError: false)
      currentState = currentState.copyWith(
        hasConnectivity: false,
        clearApiError: false, // Don't clear when still no connection
      );

      // Verify the network error is NOT cleared when still disconnected
      expect(currentState.hasConnectivity, false);
      expect(currentState.apiError, isNotNull);
      expect(currentState.apiError!.type, ApiErrorType.network);
    });
  });
}
