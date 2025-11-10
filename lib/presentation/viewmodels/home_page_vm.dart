import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/domain/usecases/get_ip_location_usecase.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';
import 'package:ip_locator/domain/services/connectivity_service.dart';
import 'package:ip_locator/presentation/providers/service_providers.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// State for the home page
class HomePageState {
  final String ipAddress;
  final String? validationError;
  final bool isLoading;
  final ApiError? apiError;
  final IpLocationData? locationData;
  final bool hasConnectivity;

  const HomePageState({
    this.ipAddress = '',
    this.validationError,
    this.isLoading = false,
    this.apiError,
    this.locationData,
    this.hasConnectivity = true,
  });

  HomePageState copyWith({
    String? ipAddress,
    String? validationError,
    bool? isLoading,
    ApiError? apiError,
    IpLocationData? locationData,
    bool? hasConnectivity,
    bool clearValidationError = false,
    bool clearApiError = false,
    bool clearLocationData = false,
  }) {
    return HomePageState(
      ipAddress: ipAddress ?? this.ipAddress,
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      isLoading: isLoading ?? this.isLoading,
      apiError: clearApiError ? null : (apiError ?? this.apiError),
      locationData: clearLocationData
          ? null
          : (locationData ?? this.locationData),
      hasConnectivity: hasConnectivity ?? this.hasConnectivity,
    );
  }

  bool get hasData => locationData != null;
  bool get hasError => validationError != null || apiError != null;
  bool get canFetchData =>
      ipAddress.isNotEmpty && validationError == null && !isLoading;
}

/// ViewModel for home page with proper state management
class HomePageViewModel extends Notifier<HomePageState> {
  late GetIPLocationUseCase _getIPLocationUseCase;
  late IpValidationService _ipValidationService;
  late ConnectivityService _connectivityService;

  @override
  HomePageState build() {
    _getIPLocationUseCase = ref.watch(getIPLocationUseCaseProvider);
    _ipValidationService = ref.watch(ipValidationServiceProvider);
    _connectivityService = ref.watch(connectivityServiceProvider);

    // Initialize connectivity checking asynchronously to avoid platform channel issues in tests
    Future.microtask(() {
      _checkConnectivity();
      _listenToConnectivityChanges();
    });

    return const HomePageState();
  }

  /// Update IP address and validate it
  void updateIpAddress(String ipAddress) {
    final validationError = _ipValidationService.getValidationError(ipAddress);
    state = state.copyWith(
      ipAddress: ipAddress,
      validationError: validationError,
      clearValidationError:
          validationError == null, // Clear error when IP is valid
      clearApiError: true,
      clearLocationData: true,
    );
  }

  /// Fetch IP location data
  Future<void> fetchIpLocationData() async {
    if (!state.canFetchData) return;

    // Check connectivity first
    final hasConnection = await _connectivityService.hasInternetConnection();
    if (!hasConnection) {
      state = state.copyWith(
        apiError: const ApiError(
          type: ApiErrorType.network,
          message:
              'No internet connection. Please check your network settings.',
        ),
        hasConnectivity: false,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearApiError: true,
      clearLocationData: true,
      hasConnectivity: true,
    );

    try {
      final result = await _getIPLocationUseCase.executeForIp(state.ipAddress);

      result.fold(
        ifLeft: (error) {
          state = state.copyWith(isLoading: false, apiError: error);
        },
        ifRight: (data) {
          state = state.copyWith(isLoading: false, locationData: data);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        apiError: const ApiError(
          type: ApiErrorType.unknown,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  /// Fetch current IP address and location data
  Future<void> fetchCurrentIpLocationData() async {
    // Check connectivity first
    final hasConnection = await _connectivityService.hasInternetConnection();
    if (!hasConnection) {
      state = state.copyWith(
        apiError: const ApiError(
          type: ApiErrorType.network,
          message:
              'No internet connection. Please check your network settings.',
        ),
        hasConnectivity: false,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearApiError: true,
      clearLocationData: true,
      hasConnectivity: true,
    );

    try {
      final result = await _getIPLocationUseCase.execute();

      result.fold(
        ifLeft: (error) {
          state = state.copyWith(isLoading: false, apiError: error);
        },
        ifRight: (data) {
          state = state.copyWith(
            isLoading: false,
            locationData: data,
            ipAddress: data.ip, // Update the IP address with the current IP
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        apiError: const ApiError(
          type: ApiErrorType.unknown,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  /// Clear all errors and data
  void clearErrors() {
    state = state.copyWith(clearValidationError: true, clearApiError: true);
  }

  /// Clear location data
  void clearLocationData() {
    state = state.copyWith(clearLocationData: true);
  }

  /// Clear IP address field
  void clearIpAddress() {
    state = state.copyWith(
      ipAddress: '',
      clearValidationError: true,
      clearApiError: true,
      clearLocationData: true,
    );
  }

  /// Manually check connectivity and clear network errors if connected
  Future<void> checkConnectivityAndClearErrors() async {
    await _checkConnectivity();
  }

  /// Force retry API call (useful for manual retry after connectivity issues)
  Future<void> retryAfterConnectivityRestore() async {
    // Clear any existing network errors first
    if (state.apiError?.type == ApiErrorType.network) {
      state = state.copyWith(clearApiError: true);
    }

    // Then attempt the API call
    await fetchIpLocationData();
  }

  /// Check initial connectivity
  Future<void> _checkConnectivity() async {
    final hasConnection = await _connectivityService.hasInternetConnection();

    // Clear network error when connectivity is detected on initial check
    final shouldClearNetworkError =
        hasConnection && state.apiError?.type == ApiErrorType.network;

    state = state.copyWith(
      hasConnectivity: hasConnection,
      clearApiError: shouldClearNetworkError,
    );
  }

  /// Listen to connectivity changes
  void _listenToConnectivityChanges() {
    _connectivityService.connectivityStream.listen((connectivityResults) {
      final hasConnection =
          connectivityResults.isNotEmpty &&
          !connectivityResults.contains(ConnectivityResult.none);

      final previousConnectivity = state.hasConnectivity;
      final hadNetworkError = state.apiError?.type == ApiErrorType.network;

      // Update connectivity status
      state = state.copyWith(hasConnectivity: hasConnection);

      // Clear network error when connectivity is restored
      if (hasConnection && hadNetworkError) {
        state = state.copyWith(clearApiError: true);
      }

      // Auto-retry if connectivity was restored and we have a valid IP
      if (!previousConnectivity && hasConnection && state.canFetchData) {
        Future.microtask(() => fetchIpLocationData());
      }
    });
  }
}

/// Provider for HomePageViewModel
final homePageViewModelProvider =
    NotifierProvider<HomePageViewModel, HomePageState>(() {
      return HomePageViewModel();
    });
