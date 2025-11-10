import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for connectivity checking (Interface Segregation Principle)
abstract class ConnectivityService {
  /// Checks if device has internet connectivity
  Future<bool> hasInternetConnection();

  /// Gets current connectivity status
  Future<List<ConnectivityResult>> getConnectivityStatus();

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream;
}

/// Implementation of connectivity service (Single Responsibility Principle)
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> hasInternetConnection() async {
    final connectivityResults = await _connectivity.checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  @override
  Future<List<ConnectivityResult>> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  @override
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
