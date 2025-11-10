import 'package:dart_either/dart_either.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Repository interface for IP location data operations
/// Follows Repository pattern to abstract remote IP location APIs as data sources
abstract class PostRepository {
  /// Fetches location data based on the current IP address.
  ///
  /// Returns [Either] with [IpLocationModel] on success, or [ApiError] on failure.
  Future<Either<ApiError, IpLocationModel>> getIPLocationData();

  /// Fetches location data for the provided IP address.
  ///
  /// Returns [Either] with [IpLocationModel] on success, or [ApiError] on failure.
  Future<Either<ApiError, IpLocationModel>> getIPLocationDataFromAddress(
    String ipAddress,
  );
}
