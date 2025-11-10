import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/data/repository/post_repository.dart';
import 'package:ip_locator/data/service/api_interface.dart';
import 'package:ip_locator/data/service/dio_service.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Concrete implementation of PostRepository
/// Handles both remote API calls and local storage operations
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required ApiInterface apiService})
    : _apiService = apiService;

  final ApiInterface _apiService;

  @override
  Future<Either<ApiError, IpLocationModel>> getIPLocationData() {
    return _apiService.getIPLocationData();
  }

  @override
  Future<Either<ApiError, IpLocationModel>> getIPLocationDataFromAddress(
    String ipAddress,
  ) {
    return _apiService.getIPLocationDataFromAddress(ipAddress);
  }
}

/// Riverpod provider for PostRepository
/// Provides an instance of PostRepository for dependency injection via Riverpod.
/// Note: This does not guarantee a singleton; a new instance may be created as needed.
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final apiService = ref.read(dioServiceProvider);
  return PostRepositoryImpl(apiService: apiService);
});
