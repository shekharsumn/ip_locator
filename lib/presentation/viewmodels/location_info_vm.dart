import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/domain/usecases/get_ip_location_usecase.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Presentation model for displaying IP location data
/// This class provides access to the raw location data - UI components handle localized formatting
class LocationinfoViewModel {
  final Either<ApiError, IpLocationModel>? _ipLocationResponse;
  final IpLocationData? _directLocationData;

  const LocationinfoViewModel(this._ipLocationResponse, [this._directLocationData]);
  
  /// Constructor for direct location data (bypassing API response)
  const LocationinfoViewModel.fromLocationData(IpLocationData locationData)
      : _ipLocationResponse = null,
        _directLocationData = locationData;

  /// Check if data is available
  bool get hasData => _directLocationData != null || _ipLocationResponse != null;

  /// Get error if any
  ApiError? get error {
    if (_directLocationData != null) return null;
    return _ipLocationResponse?.fold(ifLeft: (error) => error, ifRight: (_) => null);
  }

  /// Check if there's an error
  bool get hasError => error != null;

  /// Get the location data for display
  /// UI components should use LocalizedIpLocationDataUtils for formatted, localized data
  IpLocationData? get locationData {
    if (_directLocationData != null) return _directLocationData;
    return _ipLocationResponse?.fold(
      ifLeft: (_) => null,
      ifRight: (data) => data, // IpLocationModel extends IpLocationData
    );
  }
}

/// Provider for fetching current IP location data and wrapping it in ViewModel
final locationInfoViewModelProvider =
    FutureProvider.autoDispose<LocationinfoViewModel>((ref) async {
      final getIPLocationUseCase = ref.read(getIPLocationUseCaseProvider);
      final result = await getIPLocationUseCase.execute();
      return LocationinfoViewModel(result);
    });




