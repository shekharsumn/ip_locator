import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();
  static final ConnectivityService _instance = ConnectivityService._internal();

  StreamController<bool>? _connectivityController;
  Timer? _timer;
  bool _isConnected = false;
  bool _isDisposed = false;

  Stream<bool> get connectivityStream {
    if (_connectivityController == null || _connectivityController!.isClosed) {
      _connectivityController = StreamController<bool>.broadcast();
    }
    return _connectivityController!.stream;
  }
  
  bool get isConnected => _isConnected;

  void initialize({Duration checkInterval = const Duration(seconds: 5)}) {
    if (_isDisposed) {
      _isDisposed = false;
      _connectivityController = StreamController<bool>.broadcast();
    }
    
    // Initial check
    _checkConnection();

    // Periodic checks
    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(checkInterval, (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    if (_isDisposed || _connectivityController == null || _connectivityController!.isClosed) {
      return;
    }
    
    try {
      final result = await InternetAddress.lookup('google.com');
      final connected = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      if (connected != _isConnected) {
        _isConnected = connected;
        if (!_connectivityController!.isClosed) {
          _connectivityController!.add(_isConnected);
        }
      }
    } catch (_) {
      if (_isConnected != false) {
        _isConnected = false;
        if (!_isDisposed && !_connectivityController!.isClosed) {
          _connectivityController!.add(false);
        }
      }
    }
  }

  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    _connectivityController?.close();
    _connectivityController = null;
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
