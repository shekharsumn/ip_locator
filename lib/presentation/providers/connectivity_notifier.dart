import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();
  static final ConnectivityService _instance = ConnectivityService._internal();

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  Timer? _timer;
  bool _isConnected = false;

  Stream<bool> get connectivityStream => _connectivityController.stream;
  bool get isConnected => _isConnected;

  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    // Initial check
    _checkConnection();

    // Periodic checks
    _timer = Timer.periodic(checkInterval, (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final connected = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      if (connected != _isConnected) {
        _isConnected = connected;
        _connectivityController.add(_isConnected);
      }
    } catch (_) {
      if (_isConnected != false) {
        _isConnected = false;
        _connectivityController.add(false);
      }
    }
  }

  void dispose() {
    _timer?.cancel();
    _connectivityController.close();
  }
}

/// Providers
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

final isConnectedProvider = Provider<bool>((ref) {
  final asyncConnected = ref.watch(connectivityStreamProvider);
  return asyncConnected.when(
    data: (connected) => connected,
    loading: () => false,
    error: (_, __) => false,
  );
});
