import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:ip_locator/utils/app_constants.dart';

import '../models/ip_location_model.dart';
import 'api_interface.dart';

/// Riverpod provider for the API service
final dioServiceProvider = Provider<ApiInterface>((ref) {
  return DioService();
});

class DioService implements ApiInterface {
  DioService({Dio? dio, String? baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
              sendTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'User-Agent': 'Flutter-App/1.0.0',
              },
            ),
          );

  final Dio _dio;

  @override
  Future<Either<ApiError, IpLocationModel>> getIPLocationData() async {
    try {
      final response = await _dio.get('json/');
      return Right(IpLocationModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ApiError.fromDio(e));
    } catch (e) {
      return Left(ApiError(message: e.toString(), type: ApiErrorType.unknown));
    }
  }

  @override
  Future<Either<ApiError, IpLocationModel>> getIPLocationDataFromAddress(
    String ipAddress,
  ) async {
    try {
      final endpoint = Uri.parse(
        _dio.options.baseUrl,
      ).resolve('$ipAddress/json/').toString();
      final response = await _dio.get(endpoint);
      return Right(IpLocationModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ApiError.fromDio(e));
    } catch (e) {
      return Left(ApiError(message: e.toString(), type: ApiErrorType.unknown));
    }
  }
}
