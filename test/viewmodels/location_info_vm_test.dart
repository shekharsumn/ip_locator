import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/presentation/viewmodels/location_info_vm.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';

void main() {
  group('LocationinfoViewModel Tests', () {
    // Sample test data
    final sampleLocationData = IpLocationData(
      ip: '8.8.8.8',
      network: '8.8.8.0/24',
      version: 'IPv4',
      city: 'Mountain View',
      region: 'California',
      regionCode: 'CA',
      country: 'United States',
      countryName: 'United States',
      countryCode: 'US',
      countryCodeIso3: 'USA',
      countryCapital: 'Washington D.C.',
      countryTld: '.us',
      continentCode: 'NA',
      inEu: false,
      postal: '94043',
      latitude: 37.419200,
      longitude: -122.057400,
      timezone: 'America/Los_Angeles',
      utcOffset: '-0800',
      countryCallingCode: '+1',
      currency: 'USD',
      currencyName: 'US Dollar',
      languages: 'en-US,es-US,haw,fr',
      countryArea: 9629091.0,
      countryPopulation: 310232863,
      asn: 'AS15169',
      org: 'Google LLC',
    );

    final sampleModel = IpLocationModel(
      ip: '8.8.8.8',
      network: '8.8.8.0/24',
      version: 'IPv4',
      city: 'Mountain View',
      region: 'California',
      regionCode: 'CA',
      country: 'United States',
      countryName: 'United States',
      countryCode: 'US',
      countryCodeIso3: 'USA',
      countryCapital: 'Washington D.C.',
      countryTld: '.us',
      continentCode: 'NA',
      inEu: false,
      postal: '94043',
      latitude: 37.419200,
      longitude: -122.057400,
      timezone: 'America/Los_Angeles',
      utcOffset: '-0800',
      countryCallingCode: '+1',
      currency: 'USD',
      currencyName: 'US Dollar',
      languages: 'en-US,es-US,haw,fr',
      countryArea: 9629091.0,
      countryPopulation: 310232863,
      asn: 'AS15169',
      org: 'Google LLC',
    );

    group('Constructor Tests', () {
      group('Default Constructor', () {
        test('should create instance with successful API response', () {
          final viewModel = LocationinfoViewModel(Right(sampleModel));

          expect(viewModel.hasData, isTrue);
          expect(viewModel.hasError, isFalse);
          expect(viewModel.error, isNull);
          expect(viewModel.locationData, equals(sampleModel));
        });

        test('should create instance with API error', () {
          const apiError = ApiError(
            type: ApiErrorType.network,
            message: 'Network failure',
          );
          final viewModel = LocationinfoViewModel(Left(apiError));

          expect(viewModel.hasData, isTrue); // Has response data (even if error)
          expect(viewModel.hasError, isTrue);
          expect(viewModel.error, equals(apiError));
          expect(viewModel.locationData, isNull);
        });

        test('should create instance with null response', () {
          const viewModel = LocationinfoViewModel(null);

          expect(viewModel.hasData, isFalse);
          expect(viewModel.hasError, isFalse);
          expect(viewModel.error, isNull);
          expect(viewModel.locationData, isNull);
        });
      });

      group('fromLocationData Constructor', () {
        test('should create instance from direct location data', () {
          final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);

          expect(viewModel.hasData, isTrue);
          expect(viewModel.hasError, isFalse);
          expect(viewModel.error, isNull);
          expect(viewModel.locationData, equals(sampleLocationData));
        });
      });
    });

    group('Property Tests', () {
      group('hasData Property', () {
        test('should return true when API response exists', () {
          final viewModel = LocationinfoViewModel(Right(sampleModel));
          expect(viewModel.hasData, isTrue);
        });

        test('should return true when direct data exists', () {
          final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);
          expect(viewModel.hasData, isTrue);
        });

        test('should return false when no data exists', () {
          const viewModel = LocationinfoViewModel(null);
          expect(viewModel.hasData, isFalse);
        });

        test('should return true even with error response', () {
          const apiError = ApiError(
            type: ApiErrorType.server,
            message: 'Server error',
          );
          final viewModel = LocationinfoViewModel(Left(apiError));
          expect(viewModel.hasData, isTrue); // Response exists, even if error
        });
      });

      group('hasError Property', () {
        test('should return false with successful response', () {
          final viewModel = LocationinfoViewModel(Right(sampleModel));
          expect(viewModel.hasError, isFalse);
        });

        test('should return false with direct data', () {
          final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);
          expect(viewModel.hasError, isFalse);
        });

        test('should return true with API error', () {
          const apiError = ApiError(
            type: ApiErrorType.unauthorized,
            message: 'Unauthorized access',
          );
          final viewModel = LocationinfoViewModel(Left(apiError));
          expect(viewModel.hasError, isTrue);
        });

        test('should return false with null response', () {
          const viewModel = LocationinfoViewModel(null);
          expect(viewModel.hasError, isFalse);
        });
      });

      group('error Property', () {
        test('should return null with successful response', () {
          final viewModel = LocationinfoViewModel(Right(sampleModel));
          expect(viewModel.error, isNull);
        });

        test('should return null with direct data', () {
          final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);
          expect(viewModel.error, isNull);
        });

        test('should return error with API error response', () {
          const apiError = ApiError(
            type: ApiErrorType.timeout,
            message: 'Request timeout',
          );
          final viewModel = LocationinfoViewModel(Left(apiError));
          expect(viewModel.error, equals(apiError));
        });

        test('should return null with null response', () {
          const viewModel = LocationinfoViewModel(null);
          expect(viewModel.error, isNull);
        });
      });

      group('locationData Property', () {
        test('should return model data with successful API response', () {
          final viewModel = LocationinfoViewModel(Right(sampleModel));
          expect(viewModel.locationData, equals(sampleModel));
        });

        test('should return direct data when constructed from location data', () {
          final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);
          expect(viewModel.locationData, equals(sampleLocationData));
        });

        test('should return null with API error', () {
          const apiError = ApiError(
            type: ApiErrorType.notFound,
            message: 'Not found',
          );
          final viewModel = LocationinfoViewModel(Left(apiError));
          expect(viewModel.locationData, isNull);
        });

        test('should return null with null response', () {
          const viewModel = LocationinfoViewModel(null);
          expect(viewModel.locationData, isNull);
        });
      });
    });

    group('Error Type Tests', () {
      test('should handle network errors correctly', () {
        const networkError = ApiError(
          type: ApiErrorType.network,
          message: 'No internet connection',
        );
        final viewModel = LocationinfoViewModel(Left(networkError));

        expect(viewModel.hasError, isTrue);
        expect(viewModel.error?.type, equals(ApiErrorType.network));
        expect(viewModel.error?.message, equals('No internet connection'));
      });

      test('should handle server errors correctly', () {
        const serverError = ApiError(
          type: ApiErrorType.server,
          message: 'Internal server error',
          statusCode: 500,
        );
        final viewModel = LocationinfoViewModel(Left(serverError));

        expect(viewModel.hasError, isTrue);
        expect(viewModel.error?.type, equals(ApiErrorType.server));
        expect(viewModel.error?.statusCode, equals(500));
      });

      test('should handle timeout errors correctly', () {
        const timeoutError = ApiError(
          type: ApiErrorType.timeout,
          message: 'Connection timeout',
        );
        final viewModel = LocationinfoViewModel(Left(timeoutError));

        expect(viewModel.hasError, isTrue);
        expect(viewModel.error?.type, equals(ApiErrorType.timeout));
      });

      test('should handle authorization errors correctly', () {
        const authError = ApiError(
          type: ApiErrorType.unauthorized,
          message: 'Unauthorized',
          statusCode: 401,
        );
        final viewModel = LocationinfoViewModel(Left(authError));

        expect(viewModel.hasError, isTrue);
        expect(viewModel.error?.type, equals(ApiErrorType.unauthorized));
        expect(viewModel.error?.statusCode, equals(401));
      });
    });

    group('Data Integrity Tests', () {
      test('should preserve all data fields from API response', () {
        final viewModel = LocationinfoViewModel(Right(sampleModel));
        final data = viewModel.locationData!;

        expect(data.ip, equals('8.8.8.8'));
        expect(data.city, equals('Mountain View'));
        expect(data.region, equals('California'));
        expect(data.country, equals('United States'));
        expect(data.latitude, equals(37.419200));
        expect(data.longitude, equals(-122.057400));
        expect(data.currency, equals('USD'));
        expect(data.timezone, equals('America/Los_Angeles'));
      });

      test('should preserve all data fields from direct data', () {
        final viewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);
        final data = viewModel.locationData!;

        expect(data.ip, equals('8.8.8.8'));
        expect(data.city, equals('Mountain View'));
        expect(data.region, equals('California'));
        expect(data.country, equals('United States'));
        expect(data.latitude, equals(37.419200));
        expect(data.longitude, equals(-122.057400));
        expect(data.currency, equals('USD'));
        expect(data.timezone, equals('America/Los_Angeles'));
      });

      test('should handle partial data correctly', () {
        final partialModel = IpLocationModel(
          ip: '192.168.1.1',
          network: '',
          version: 'IPv4',
          city: '',
          region: '',
          regionCode: '',
          country: 'Unknown',
          countryName: '',
          countryCode: '',
          countryCodeIso3: '',
          countryCapital: '',
          countryTld: '',
          continentCode: '',
          inEu: false,
          postal: '',
          latitude: 0.0,
          longitude: 0.0,
          timezone: '',
          utcOffset: '',
          countryCallingCode: '',
          currency: '',
          currencyName: '',
          languages: '',
          countryArea: 0.0,
          countryPopulation: 0,
          asn: '',
          org: '',
        );

        final viewModel = LocationinfoViewModel(Right(partialModel));
        final data = viewModel.locationData!;

        expect(data.ip, equals('192.168.1.1'));
        expect(data.city, isEmpty);
        expect(data.region, isEmpty);
        expect(data.country, equals('Unknown'));
        expect(data.latitude, equals(0.0));
        expect(data.longitude, equals(0.0));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty API response gracefully', () {
        const viewModel = LocationinfoViewModel(null);

        expect(viewModel.hasData, isFalse);
        expect(viewModel.hasError, isFalse);
        expect(viewModel.error, isNull);
        expect(viewModel.locationData, isNull);
      });

      test('should differentiate between API response and direct data', () {
        final apiViewModel = LocationinfoViewModel(Right(sampleModel));
        final directViewModel = LocationinfoViewModel.fromLocationData(sampleLocationData);

        // Both should have data but different sources
        expect(apiViewModel.hasData, isTrue);
        expect(directViewModel.hasData, isTrue);
        expect(apiViewModel.locationData, isNotNull);
        expect(directViewModel.locationData, isNotNull);

        // Data content should be equivalent
        expect(apiViewModel.locationData?.ip, equals(directViewModel.locationData?.ip));
        expect(apiViewModel.locationData?.city, equals(directViewModel.locationData?.city));
      });

      test('should handle unknown error types', () {
        const unknownError = ApiError(
          type: ApiErrorType.unknown,
          message: 'Something went wrong',
        );
        final viewModel = LocationinfoViewModel(Left(unknownError));

        expect(viewModel.hasError, isTrue);
        expect(viewModel.error?.type, equals(ApiErrorType.unknown));
        expect(viewModel.error?.message, equals('Something went wrong'));
      });
    });

    group('Equality and Comparison Tests', () {
      test('should consider view models with same data as equal', () {
        final viewModel1 = LocationinfoViewModel.fromLocationData(sampleLocationData);
        final viewModel2 = LocationinfoViewModel.fromLocationData(sampleLocationData);

        // Should have same properties
        expect(viewModel1.hasData, equals(viewModel2.hasData));
        expect(viewModel1.hasError, equals(viewModel2.hasError));
        expect(viewModel1.locationData?.ip, equals(viewModel2.locationData?.ip));
      });

      test('should consider view models with different errors as different', () {
        const error1 = ApiError(type: ApiErrorType.network, message: 'Network error');
        const error2 = ApiError(type: ApiErrorType.server, message: 'Server error');
        
        final viewModel1 = LocationinfoViewModel(Left(error1));
        final viewModel2 = LocationinfoViewModel(Left(error2));

        expect(viewModel1.error?.type, isNot(equals(viewModel2.error?.type)));
        expect(viewModel1.error?.message, isNot(equals(viewModel2.error?.message)));
      });
    });
  });

  group('LocationInfoViewModelProvider Tests', () {
    test('should provide LocationinfoViewModel instance', () async {
      final container = ProviderContainer();
      
      // Provider should be available
      expect(
        () => container.read(locationInfoViewModelProvider.future),
        returnsNormally,
      );
      
      container.dispose();
    });

    test('should be an auto-dispose provider', () {
      final container = ProviderContainer();
      
      // Read the provider to create it
      container.read(locationInfoViewModelProvider);
      
      // Should dispose automatically when not being watched
      expect(() => container.dispose(), returnsNormally);
    });

    test('should handle provider refresh', () async {
      final container = ProviderContainer();
      
      // Initial read
      container.read(locationInfoViewModelProvider);
      
      // Refresh should not throw
      expect(
        () => container.refresh(locationInfoViewModelProvider),
        returnsNormally,
      );
      
      container.dispose();
    });
  });
}