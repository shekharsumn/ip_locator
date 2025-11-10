import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/data/repository/post_repository.dart';
import 'package:ip_locator/data/repository/post_repository_impl.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Use case for fetching IP location data
/// Encapsulates the business logic for getting IP location data
class GetIPLocationUseCase {
  GetIPLocationUseCase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  Future<Either<ApiError, IpLocationModel>> execute() {
    return _repository.getIPLocationData();
  }

  Future<Either<ApiError, IpLocationModel>> executeForIp(String ipAddress) {
    return _repository.getIPLocationDataFromAddress(ipAddress);
  }
}

/// Riverpod provider for GetIPLocationUseCase
final getIPLocationUseCaseProvider = Provider<GetIPLocationUseCase>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return GetIPLocationUseCase(repository: repository);
});
