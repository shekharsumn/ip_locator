import 'package:dart_either/dart_either.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Abstraction for IP location-related API methods used by the app.
/// All methods return an Either that wraps successful data or an ApiError for failures.
abstract class ApiInterface {
  /// Fetch location data based on the device's public IP address.
  /// If the IP address is not available, the service will attempt to use the device's current public IP.
  Future<Either<ApiError, IpLocationModel>> getIPLocationData();

  /// Fetch a location data by IP address.
  ///
  /// [ipAddress] should be a valid IPv4 or IPv6 address string.
  Future<Either<ApiError, IpLocationModel>> getIPLocationDataFromAddress(
    String ipAddress,
  );
}
