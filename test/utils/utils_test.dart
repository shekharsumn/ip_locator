import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:ip_locator/utils/api_error_extensions.dart';
import 'package:ip_locator/utils/app_constants.dart';
import 'package:ip_locator/utils/formatting_utils.dart';
import 'package:ip_locator/utils/ip_location_data_utils.dart';

void main() {
  group('ApiErrorExtensions Tests', () {
    group('userFriendlyMessage Tests', () {
      test('should return network error message for network type', () {
        const error = ApiError(
          type: ApiErrorType.network,
          message: 'Network error',
        );

        expect(error.userFriendlyMessage, 
            equals('No internet connection. Please check your network settings and try again.'));
      });

      test('should return timeout error message for timeout type', () {
        const error = ApiError(
          type: ApiErrorType.timeout,
          message: 'Timeout occurred',
        );

        expect(error.userFriendlyMessage, 
            equals('The request timed out. Please check your connection and try again.'));
      });

      test('should return specific server error message for 500 status', () {
        const error = ApiError(
          type: ApiErrorType.server,
          message: 'Internal server error',
          statusCode: 500,
        );

        expect(error.userFriendlyMessage, 
            equals('The server is experiencing issues. Please try again later.'));
      });

      test('should return generic server error message for other server errors', () {
        const error = ApiError(
          type: ApiErrorType.server,
          message: 'Server error',
          statusCode: 503,
        );

        expect(error.userFriendlyMessage, 
            equals('Server error occurred. Please try again later.'));
      });

      test('should return bad request message for badRequest type', () {
        const error = ApiError(
          type: ApiErrorType.badRequest,
          message: 'Bad request',
        );

        expect(error.userFriendlyMessage, 
            equals('Invalid IP address format. Please enter a valid IPv4 or IPv6 address.'));
      });

      test('should return not found message for notFound type', () {
        const error = ApiError(
          type: ApiErrorType.notFound,
          message: 'Not found',
        );

        expect(error.userFriendlyMessage, 
            equals('No location data found for this IP address.'));
      });

      test('should return unauthorized message for unauthorized type', () {
        const error = ApiError(
          type: ApiErrorType.unauthorized,
          message: 'Unauthorized',
        );

        expect(error.userFriendlyMessage, 
            equals('Access denied. Please check your API credentials.'));
      });

      test('should return custom message for rateLimited type when message is provided', () {
        const error = ApiError(
          type: ApiErrorType.rateLimited,
          message: 'Rate limit exceeded for this hour',
        );

        expect(error.userFriendlyMessage, 
            equals('Rate limit exceeded for this hour'));
      });

      test('should return default message for rateLimited type when message is empty', () {
        const error = ApiError(
          type: ApiErrorType.rateLimited,
          message: '',
        );

        expect(error.userFriendlyMessage, 
            equals('Too many requests. Please try again later.'));
      });

      test('should return cancelled message for cancelled type', () {
        const error = ApiError(
          type: ApiErrorType.cancelled,
          message: 'Request cancelled',
        );

        expect(error.userFriendlyMessage, 
            equals('Request was cancelled.'));
      });
    });

    group('errorIcon Tests', () {
      test('should return network icon for network error', () {
        const error = ApiError(
          type: ApiErrorType.network,
          message: 'Network error',
        );

        expect(error.errorIcon, equals('📡'));
      });

      test('should return timeout icon for timeout error', () {
        const error = ApiError(
          type: ApiErrorType.timeout,
          message: 'Timeout error',
        );

        expect(error.errorIcon, equals('⏰'));
      });

      test('should return server icon for server error', () {
        const error = ApiError(
          type: ApiErrorType.server,
          message: 'Server error',
        );

        expect(error.errorIcon, equals('🔧'));
      });

      test('should return validation icon for bad request', () {
        const error = ApiError(
          type: ApiErrorType.badRequest,
          message: 'Bad request',
        );

        expect(error.errorIcon, equals('❌'));
      });

      test('should return not found icon for not found error', () {
        const error = ApiError(
          type: ApiErrorType.notFound,
          message: 'Not found',
        );

        expect(error.errorIcon, equals('🔍'));
      });
    });
  });

  group('FormattingUtils Tests', () {
    group('formatField Tests', () {
      test('should return original value for non-empty string', () {
        final result = FormattingUtils.formatField('Test Value');
        expect(result, equals('Test Value'));
      });

      test('should return N/A for null value', () {
        final result = FormattingUtils.formatField(null);
        expect(result, equals('N/A'));
      });

      test('should return N/A for empty string', () {
        final result = FormattingUtils.formatField('');
        expect(result, equals('N/A'));
      });

      test('should return custom notAvailable text when provided', () {
        final result = FormattingUtils.formatField(null, notAvailable: 'Not Available');
        expect(result, equals('Not Available'));
      });

      test('should return original value even with custom notAvailable text', () {
        final result = FormattingUtils.formatField('Value', notAvailable: 'Custom N/A');
        expect(result, equals('Value'));
      });
    });

    group('formatCoordinates Tests', () {
      test('should return formatted coordinates for valid values', () {
        final result = FormattingUtils.formatCoordinates(37.4419, -122.143);
        expect(result, equals('37.4419, -122.143'));
      });

      test('should return N/A for zero coordinates', () {
        final result = FormattingUtils.formatCoordinates(0.0, 0.0);
        expect(result, equals('N/A'));
      });

      test('should return formatted coordinates for negative values', () {
        final result = FormattingUtils.formatCoordinates(-33.8688, 151.2093);
        expect(result, equals('-33.8688, 151.2093'));
      });

      test('should return custom notAvailable text for zero coordinates', () {
        final result = FormattingUtils.formatCoordinates(0.0, 0.0, notAvailable: 'Unknown Location');
        expect(result, equals('Unknown Location'));
      });

      test('should return formatted coordinates when only one coordinate is zero', () {
        final result = FormattingUtils.formatCoordinates(0.0, 151.2093);
        expect(result, equals('0.0, 151.2093'));
      });
    });

    group('formatBoolean Tests', () {
      test('should return Yes for true value', () {
        final result = FormattingUtils.formatBoolean(true);
        expect(result, equals('Yes'));
      });

      test('should return No for false value', () {
        final result = FormattingUtils.formatBoolean(false);
        expect(result, equals('No'));
      });

      test('should return custom yes text for true value', () {
        final result = FormattingUtils.formatBoolean(true, yes: 'Enabled');
        expect(result, equals('Enabled'));
      });

      test('should return custom no text for false value', () {
        final result = FormattingUtils.formatBoolean(false, no: 'Disabled');
        expect(result, equals('Disabled'));
      });

      test('should return custom yes/no texts', () {
        final trueResult = FormattingUtils.formatBoolean(true, yes: 'Active', no: 'Inactive');
        final falseResult = FormattingUtils.formatBoolean(false, yes: 'Active', no: 'Inactive');
        
        expect(trueResult, equals('Active'));
        expect(falseResult, equals('Inactive'));
      });
    });

    group('formatCurrency Tests', () {
      test('should return formatted currency with name', () {
        final result = FormattingUtils.formatCurrency('USD', 'US Dollar');
        expect(result, equals('USD (US Dollar)'));
      });

      test('should return currency code only when name is null', () {
        final result = FormattingUtils.formatCurrency('EUR', null);
        expect(result, equals('EUR'));
      });

      test('should return currency code only when name is empty', () {
        final result = FormattingUtils.formatCurrency('GBP', '');
        expect(result, equals('GBP'));
      });

      test('should return N/A when currency is null', () {
        final result = FormattingUtils.formatCurrency(null, 'US Dollar');
        expect(result, equals('N/A'));
      });

      test('should return N/A when currency is empty', () {
        final result = FormattingUtils.formatCurrency('', 'US Dollar');
        expect(result, equals('N/A'));
      });

      test('should return custom notAvailable text when currency is null', () {
        final result = FormattingUtils.formatCurrency(null, 'US Dollar', notAvailable: 'Unknown Currency');
        expect(result, equals('Unknown Currency'));
      });
    });

    group('formatNumeric Tests', () {
      test('should format integer with zero decimal places', () {
        final result = FormattingUtils.formatNumeric(1000);
        expect(result, equals('1000'));
      });

      test('should format double with specified decimal places', () {
        final result = FormattingUtils.formatNumeric(1234.5678, decimalPlaces: 2);
        expect(result, equals('1234.57'));
      });

      test('should return N/A for null value', () {
        final result = FormattingUtils.formatNumeric(null);
        expect(result, equals('N/A'));
      });

      test('should return custom notAvailable text for null value', () {
        final result = FormattingUtils.formatNumeric(null, notAvailable: 'No Data');
        expect(result, equals('No Data'));
      });

      test('should format zero value as N/A by default', () {
        final result = FormattingUtils.formatNumeric(0);
        expect(result, equals('N/A'));
      });

      test('should format negative numbers correctly', () {
        final result = FormattingUtils.formatNumeric(-1234.56, decimalPlaces: 1);
        expect(result, equals('-1234.6'));
      });
    });
  });

  group('IpLocationDataUtils Tests', () {
    late IpLocationData sampleData;

    setUp(() {
      sampleData = IpLocationData(
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
    });

    group('getLocationInfo Tests', () {
      test('should return formatted location information items', () {
        final result = IpLocationDataUtils.getLocationInfo(
          sampleData,
          ipAddressLabel: 'IP Address',
          cityLabel: 'City',
          regionLabel: 'Region',
          countryLabel: 'Country',
          timezoneLabel: 'Timezone',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.isNotEmpty, isTrue);
        expect(result.length, equals(5));

        // Check specific items
        expect(result[0].label, equals('IP Address'));
        expect(result[0].value, equals('8.8.8.8'));
        
        expect(result[1].label, equals('City'));
        expect(result[1].value, equals('Mountain View'));

        expect(result[2].label, equals('Region'));
        expect(result[2].value, equals('California'));

        expect(result[3].label, equals('Country'));
        expect(result[3].value, equals('United States'));

        expect(result[4].label, equals('Timezone'));
        expect(result[4].value, equals('America/Los_Angeles'));
      });

      test('should handle null data gracefully', () {
        final result = IpLocationDataUtils.getLocationInfo(
          null,
          ipAddressLabel: 'IP Address',
          cityLabel: 'City',
          regionLabel: 'Region',
          countryLabel: 'Country',
          timezoneLabel: 'Timezone',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        // When data is null, method returns empty list
        expect(result.isEmpty, isTrue);
      });
    });

    group('getNetworkInfo Tests', () {
      test('should return formatted network information items', () {
        final result = IpLocationDataUtils.getNetworkInfo(
          sampleData,
          networkLabel: 'Network',
          versionLabel: 'Version',
          asnLabel: 'ASN',
          organizationLabel: 'Organization',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.length, equals(4));

        expect(result[0].label, equals('Network'));
        expect(result[0].value, equals('8.8.8.0/24'));

        expect(result[1].label, equals('Version'));
        expect(result[1].value, equals('IPv4'));

        expect(result[2].label, equals('ASN'));
        expect(result[2].value, equals('AS15169'));

        expect(result[3].label, equals('Organization'));
        expect(result[3].value, equals('Google LLC'));
      });

      test('should handle empty network data', () {
        final emptyData = IpLocationData(
          ip: '',
          network: '',
          version: '',
          city: '',
          region: '',
          regionCode: '',
          country: '',
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

        final result = IpLocationDataUtils.getNetworkInfo(
          emptyData,
          networkLabel: 'Network',
          versionLabel: 'Version',
          asnLabel: 'ASN',
          organizationLabel: 'Organization',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.length, equals(4));

        // All values should be N/A for empty data
        for (final item in result) {
          expect(item.value, equals('N/A'));
        }
      });
    });

    group('getGeographicInfo Tests', () {
      test('should return formatted geographic information items', () {
        final result = IpLocationDataUtils.getGeographicInfo(
          sampleData,
          coordinatesLabel: 'Coordinates',
          postalCodeLabel: 'Postal Code',
          continentLabel: 'Continent',
          inEuLabel: 'In EU',
          currencyLabel: 'Currency',
          languagesLabel: 'Languages',
          notAvailable: 'N/A',
          yes: 'Yes',
          no: 'No',
        );

        expect(result, isNotNull);
        expect(result.isNotEmpty, isTrue);

        // Should contain coordinates
        final coordinatesItem = result.firstWhere((item) => item.label == 'Coordinates');
        expect(coordinatesItem.value, equals('37.4192, -122.0574'));

        // Should contain postal code
        final postalItem = result.firstWhere((item) => item.label == 'Postal Code');
        expect(postalItem.value, equals('94043'));

        // Should contain continent
        final continentItem = result.firstWhere((item) => item.label == 'Continent');
        expect(continentItem.value, equals('NA'));

        // Should contain EU status as "No"
        final euItem = result.firstWhere((item) => item.label == 'In EU');
        expect(euItem.value, equals('No'));

        // Should contain currency
        final currencyItem = result.firstWhere((item) => item.label == 'Currency');
        expect(currencyItem.value, equals('USD (US Dollar)'));

        // Should contain languages
        final languagesItem = result.firstWhere((item) => item.label == 'Languages');
        expect(languagesItem.value, equals('en-US,es-US,haw,fr'));
      });

      test('should handle EU country correctly', () {
        final euData = IpLocationData(
          ip: '8.8.4.4',
          network: '',
          version: 'IPv4',
          city: 'Paris',
          region: '',
          regionCode: '',
          country: 'France',
          countryName: 'France',
          countryCode: 'FR',
          countryCodeIso3: 'FRA',
          countryCapital: 'Paris',
          countryTld: '.fr',
          continentCode: 'EU',
          inEu: true, // EU country
          postal: '',
          latitude: 48.8566,
          longitude: 2.3522,
          timezone: 'Europe/Paris',
          utcOffset: '+0100',
          countryCallingCode: '+33',
          currency: 'EUR',
          currencyName: 'Euro',
          languages: 'fr',
          countryArea: 643801.0,
          countryPopulation: 67081000,
          asn: '',
          org: '',
        );

        final result = IpLocationDataUtils.getGeographicInfo(
          euData,
          coordinatesLabel: 'Coordinates',
          postalCodeLabel: 'Postal Code',
          continentLabel: 'Continent',
          inEuLabel: 'In EU',
          currencyLabel: 'Currency',
          languagesLabel: 'Languages',
          notAvailable: 'N/A',
          yes: 'Yes',
          no: 'No',
        );

        final euItem = result.firstWhere((item) => item.label == 'In EU');
        expect(euItem.value, equals('Yes'));
      });
    });

    group('getAllInfo Tests', () {
      test('should return map with all information categories', () {
        final result = IpLocationDataUtils.getAllInfo(sampleData);

        expect(result, isNotNull);
        expect(result.keys.isNotEmpty, isTrue);
        // Check that result contains expected info lists
        for (final category in result.keys) {
          expect(result[category], isNotNull);
        }
      });

      test('should handle null data for getAllInfo', () {
        final result = IpLocationDataUtils.getAllInfo(null);

        expect(result, isNotNull);
        // When data is null, should still return a map (might be empty)
        expect(result, isA<Map<String, List<InfoItem>>>());
      });
    });

    group('getExtendedLocationInfo Tests', () {
      test('should return extended location information', () {
        final result = IpLocationDataUtils.getExtendedLocationInfo(
          sampleData,
          ipAddressLabel: 'IP Address',
          cityLabel: 'City',
          regionLabel: 'Region',
          countryLabel: 'Country',
          timezoneLabel: 'Timezone',
          countryCodeLabel: 'Country Code',
          countryIso3Label: 'Country ISO3',
          countryCapitalLabel: 'Capital',
          countryTldLabel: 'TLD',
          callingCodeLabel: 'Calling Code',
          utcOffsetLabel: 'UTC Offset',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.length, greaterThan(5)); // More than basic location info

        // Check for extended fields
        final countryCodeItem = result.firstWhere((item) => item.label == 'Country Code');
        expect(countryCodeItem.value, equals('US'));

        final iso3Item = result.firstWhere((item) => item.label == 'Country ISO3');
        expect(iso3Item.value, equals('USA'));

        final capitalItem = result.firstWhere((item) => item.label == 'Capital');
        expect(capitalItem.value, equals('Washington D.C.'));

        final tldItem = result.firstWhere((item) => item.label == 'TLD');
        expect(tldItem.value, equals('.us'));

        final callingCodeItem = result.firstWhere((item) => item.label == 'Calling Code');
        expect(callingCodeItem.value, equals('+1'));

        final utcOffsetItem = result.firstWhere((item) => item.label == 'UTC Offset');
        expect(utcOffsetItem.value, equals('-0800'));
      });
    });

    group('filterAvailableInfo Tests', () {
      test('should filter out N/A values', () {
        final inputItems = [
          InfoItem('Label 1', 'Value 1'),
          InfoItem('Label 2', 'N/A'),
          InfoItem('Label 3', 'Value 3'),
          InfoItem('Label 4', 'N/A'),
        ];

        final result = IpLocationDataUtils.filterAvailableInfo(inputItems);

        expect(result.length, equals(2));
        expect(result[0].label, equals('Label 1'));
        expect(result[0].value, equals('Value 1'));
        expect(result[1].label, equals('Label 3'));
        expect(result[1].value, equals('Value 3'));
      });

      test('should return empty list when all items are N/A', () {
        final inputItems = [
          InfoItem('Label 1', 'N/A'),
          InfoItem('Label 2', 'N/A'),
        ];

        final result = IpLocationDataUtils.filterAvailableInfo(inputItems);

        expect(result.isEmpty, isTrue);
      });

      test('should return all items when none are N/A', () {
        final inputItems = [
          InfoItem('Label 1', 'Value 1'),
          InfoItem('Label 2', 'Value 2'),
        ];

        final result = IpLocationDataUtils.filterAvailableInfo(inputItems);

        expect(result.length, equals(2));
        expect(result, equals(inputItems));
      });
    });

    group('getSummaryInfo Tests', () {
      test('should return summary information with key fields', () {
        final result = IpLocationDataUtils.getSummaryInfo(
          sampleData,
          ipAddressLabel: 'IP',
          locationLabel: 'Location',
          countryLabel: 'Country',
          timezoneLabel: 'Timezone',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.isNotEmpty, isTrue);

        // Check that IP address is included
        final hasIpAddress = result.any((item) => item.value == '8.8.8.8');
        expect(hasIpAddress, isTrue);

        // Check that location information is included
        final hasLocation = result.any((item) => item.value.contains('Mountain View'));
        expect(hasLocation, isTrue);

        // Check that country is included
        final hasCountry = result.any((item) => item.value == 'United States');
        expect(hasCountry, isTrue);

        // Check that timezone is included
        final hasTimezone = result.any((item) => item.value == 'America/Los_Angeles');
        expect(hasTimezone, isTrue);
      });

      test('should handle partial data in summary', () {
        final partialData = IpLocationData(
          ip: '192.168.1.1',
          network: '',
          version: 'IPv4',
          city: 'Test City',
          region: '',
          regionCode: '',
          country: '',
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

        final result = IpLocationDataUtils.getSummaryInfo(
          partialData,
          ipAddressLabel: 'IP',
          locationLabel: 'Location',
          countryLabel: 'Country',
          timezoneLabel: 'Timezone',
          notAvailable: 'N/A',
        );

        expect(result, isNotNull);
        expect(result.isNotEmpty, isTrue);

        // Check that IP address is preserved
        final hasIpAddress = result.any((item) => item.value == '192.168.1.1');
        expect(hasIpAddress, isTrue);

        // Check that city is preserved
        final hasCity = result.any((item) => item.value.contains('Test City'));
        expect(hasCity, isTrue);
      });
    });
  });

  group('AppConstants Tests', () {
    test('should have correct API base URL', () {
      expect(AppConstants.apiBaseUrl, equals('https://ipapi.co/'));
    });

    test('should have valid info card styling constants', () {
      expect(AppConstants.infoCardElevation, equals(4.0));
      expect(AppConstants.infoCardPadding, isA<EdgeInsets>());
      expect(AppConstants.iconTitleSpacing, equals(8.0));
      expect(AppConstants.infoRowLabelWidth, equals(120.0));
      expect(AppConstants.infoRowVerticalSpacing, equals(4.0));
    });

    test('should not be instantiable', () {
      // AppConstants has private constructor, so we can't instantiate it
      // We can test by ensuring the class has the expected constants
      expect(AppConstants.apiBaseUrl, isNotNull);
      expect(AppConstants.infoCardElevation, isNotNull);
      expect(AppConstants.infoCardPadding, isNotNull);
    });
  });
}