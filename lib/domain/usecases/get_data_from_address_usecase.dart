import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/data/repository/post_repository.dart';
import 'package:ip_locator/data/repository/post_repository_impl.dart';
import 'package:ip_locator/utils/api_error.dart';

/// Use case for fetching IP location data from an address
/// Handles the business logic for fetching IP location data from an address
class GetIPLocationFromAddressUseCase {
  GetIPLocationFromAddressUseCase({required PostRepository repository})
    : _repository = repository;

  final PostRepository _repository;

  Future<Either<ApiError, IpLocationModel>> execute(String ipAddress) {
    return _repository.getIPLocationDataFromAddress(ipAddress);
  }
}

/// Riverpod provider for GetIPLocationFromAddressUseCase
final getIPLocationFromAddressUseCaseProvider =
    Provider<GetIPLocationFromAddressUseCase>((ref) {
      final repository = ref.read(postRepositoryProvider);
      return GetIPLocationFromAddressUseCase(repository: repository);
    });
