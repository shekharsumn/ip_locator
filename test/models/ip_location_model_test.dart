import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/data/models/ip_location_model.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';

void main() {
  group('IpLocationModel Tests', () {
    const testJson = {
      'ip': '8.8.8.8',
      'network': '8.8.8.0/24',
      'version': 'IPv4',
      'city': 'Mountain View',
      'region': 'California',
      'region_code': 'CA',
      'country': 'US',
      'country_name': 'United States',
      'country_code': 'US',
      'country_code_iso3': 'USA',
      'country_capital': 'Washington',
      'country_tld': '.us',
      'continent_code': 'NA',
      'in_eu': false,
      'postal': '94043',
      'latitude': 37.405992,
      'longitude': -122.078515,
      'timezone': 'America/Los_Angeles',
      'utc_offset': '-0800',
      'country_calling_code': '+1',
      'currency': 'USD',
      'currency_name': 'US Dollar',
      'languages': 'en-US,es-US,haw,fr',
      'country_area': 9629091.0,
      'country_population': 310232863,
      'asn': 'AS15169',
      'org': 'Google LLC',
    };

    group('Constructor Tests', () {
      test('should create IpLocationModel with all required fields', () {
        const model = IpLocationModel(
          ip: '8.8.8.8',
          network: '8.8.8.0/24',
          version: 'IPv4',
          city: 'Mountain View',
          region: 'California',
          regionCode: 'CA',
          country: 'US',
          countryName: 'United States',
          countryCode: 'US',
          countryCodeIso3: 'USA',
          countryCapital: 'Washington',
          countryTld: '.us',
          continentCode: 'NA',
          inEu: false,
          postal: '94043',
          latitude: 37.405992,
          longitude: -122.078515,
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

        expect(model.ip, equals('8.8.8.8'));
        expect(model.country, equals('US'));
        expect(model.city, equals('Mountain View'));
        expect(model.latitude, equals(37.405992));
        expect(model.longitude, equals(-122.078515));
      });

      test('should extend IpLocationData', () {
        const model = IpLocationModel(
          ip: '8.8.8.8',
          network: '8.8.8.0/24',
          version: 'IPv4',
          city: 'Mountain View',
          region: 'California',
          regionCode: 'CA',
          country: 'US',
          countryName: 'United States',
          countryCode: 'US',
          countryCodeIso3: 'USA',
          countryCapital: 'Washington',
          countryTld: '.us',
          continentCode: 'NA',
          inEu: false,
          postal: '94043',
          latitude: 37.405992,
          longitude: -122.078515,
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

        expect(model, isA<IpLocationData>());
      });
    });

    group('JSON Serialization Tests', () {
      test('should create model from valid JSON', () {
        final model = IpLocationModel.fromJson(testJson);

        expect(model.ip, equals('8.8.8.8'));
        expect(model.network, equals('8.8.8.0/24'));
        expect(model.version, equals('IPv4'));
        expect(model.city, equals('Mountain View'));
        expect(model.region, equals('California'));
        expect(model.regionCode, equals('CA'));
        expect(model.country, equals('US'));
        expect(model.countryName, equals('United States'));
        expect(model.countryCode, equals('US'));
        expect(model.countryCodeIso3, equals('USA'));
        expect(model.countryCapital, equals('Washington'));
        expect(model.countryTld, equals('.us'));
        expect(model.continentCode, equals('NA'));
        expect(model.inEu, equals(false));
        expect(model.postal, equals('94043'));
        expect(model.latitude, equals(37.405992));
        expect(model.longitude, equals(-122.078515));
        expect(model.timezone, equals('America/Los_Angeles'));
        expect(model.utcOffset, equals('-0800'));
        expect(model.countryCallingCode, equals('+1'));
        expect(model.currency, equals('USD'));
        expect(model.currencyName, equals('US Dollar'));
        expect(model.languages, equals('en-US,es-US,haw,fr'));
        expect(model.countryArea, equals(9629091.0));
        expect(model.countryPopulation, equals(310232863));
        expect(model.asn, equals('AS15169'));
        expect(model.org, equals('Google LLC'));
      });

      test('should handle missing fields with default values', () {
        const incompleteJson = {
          'ip': '1.1.1.1',
          'city': 'Unknown',
          // Missing most fields
        };

        final model = IpLocationModel.fromJson(incompleteJson);

        expect(model.ip, equals('1.1.1.1'));
        expect(model.city, equals('Unknown'));
        expect(model.network, equals('')); // Default value
        expect(model.version, equals('')); // Default value
        expect(model.country, equals('')); // Default value
        expect(model.latitude, equals(0.0)); // Default value
        expect(model.longitude, equals(0.0)); // Default value
        expect(model.inEu, equals(false)); // Default value
        expect(model.countryPopulation, equals(0)); // Default value
        expect(model.countryArea, equals(0.0)); // Default value
      });

      test('should handle null values with default values', () {
        const jsonWithNulls = {
          'ip': '1.1.1.1',
          'city': null,
          'country': null,
          'latitude': null,
          'longitude': null,
          'in_eu': null,
          'country_population': null,
          'country_area': null,
        };

        final model = IpLocationModel.fromJson(jsonWithNulls);

        expect(model.ip, equals('1.1.1.1'));
        expect(model.city, equals('')); // Default for null
        expect(model.country, equals('')); // Default for null
        expect(model.latitude, equals(0.0)); // Default for null
        expect(model.longitude, equals(0.0)); // Default for null
        expect(model.inEu, equals(false)); // Default for null
        expect(model.countryPopulation, equals(0)); // Default for null
        expect(model.countryArea, equals(0.0)); // Default for null
      });

      test('should handle string numbers in latitude and longitude', () {
        const jsonWithStringNumbers = {
          'ip': '1.1.1.1',
          'latitude': '37.405992',
          'longitude': '-122.078515',
          'country_area': '9629091.0',
          'country_population': '310232863',
        };

        final model = IpLocationModel.fromJson(jsonWithStringNumbers);

        expect(model.latitude, equals(37.405992));
        expect(model.longitude, equals(-122.078515));
        expect(model.countryArea, equals(9629091.0));
        expect(model.countryPopulation, equals(310232863));
      });

      test('should handle invalid string numbers with defaults', () {
        const jsonWithInvalidNumbers = {
          'ip': '1.1.1.1',
          'latitude': 'invalid',
          'longitude': 'not_a_number',
          'country_area': 'invalid_area',
          'country_population': 'invalid_population',
        };

        final model = IpLocationModel.fromJson(jsonWithInvalidNumbers);

        expect(model.latitude, equals(0.0)); // Default for invalid
        expect(model.longitude, equals(0.0)); // Default for invalid
        expect(model.countryArea, equals(0.0)); // Default for invalid
        expect(model.countryPopulation, equals(0)); // Default for invalid
      });
    });

    group('JSON Deserialization Tests', () {
      test('should convert model to JSON correctly', () {
        const model = IpLocationModel(
          ip: '8.8.8.8',
          network: '8.8.8.0/24',
          version: 'IPv4',
          city: 'Mountain View',
          region: 'California',
          regionCode: 'CA',
          country: 'US',
          countryName: 'United States',
          countryCode: 'US',
          countryCodeIso3: 'USA',
          countryCapital: 'Washington',
          countryTld: '.us',
          continentCode: 'NA',
          inEu: false,
          postal: '94043',
          latitude: 37.405992,
          longitude: -122.078515,
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

        final json = model.toJson();

        expect(json['ip'], equals('8.8.8.8'));
        expect(json['network'], equals('8.8.8.0/24'));
        expect(json['version'], equals('IPv4'));
        expect(json['city'], equals('Mountain View'));
        expect(json['region'], equals('California'));
        expect(json['region_code'], equals('CA'));
        expect(json['country'], equals('US'));
        expect(json['country_name'], equals('United States'));
        expect(json['country_code'], equals('US'));
        expect(json['country_code_iso3'], equals('USA'));
        expect(json['country_capital'], equals('Washington'));
        expect(json['country_tld'], equals('.us'));
        expect(json['continent_code'], equals('NA'));
        expect(json['in_eu'], equals(false));
        expect(json['postal'], equals('94043'));
        expect(json['latitude'], equals(37.405992));
        expect(json['longitude'], equals(-122.078515));
        expect(json['timezone'], equals('America/Los_Angeles'));
        expect(json['utc_offset'], equals('-0800'));
        expect(json['country_calling_code'], equals('+1'));
        expect(json['currency'], equals('USD'));
        expect(json['currency_name'], equals('US Dollar'));
        expect(json['languages'], equals('en-US,es-US,haw,fr'));
        expect(json['country_area'], equals(9629091.0));
        expect(json['country_population'], equals(310232863));
        expect(json['asn'], equals('AS15169'));
        expect(json['org'], equals('Google LLC'));
      });
    });

    group('Round Trip Tests', () {
      test('should maintain data integrity through JSON round trip', () {
        final originalModel = IpLocationModel.fromJson(testJson);
        final json = originalModel.toJson();
        final recreatedModel = IpLocationModel.fromJson(json);

        expect(recreatedModel.ip, equals(originalModel.ip));
        expect(recreatedModel.network, equals(originalModel.network));
        expect(recreatedModel.version, equals(originalModel.version));
        expect(recreatedModel.city, equals(originalModel.city));
        expect(recreatedModel.region, equals(originalModel.region));
        expect(recreatedModel.regionCode, equals(originalModel.regionCode));
        expect(recreatedModel.country, equals(originalModel.country));
        expect(recreatedModel.countryName, equals(originalModel.countryName));
        expect(recreatedModel.countryCode, equals(originalModel.countryCode));
        expect(recreatedModel.countryCodeIso3, equals(originalModel.countryCodeIso3));
        expect(recreatedModel.countryCapital, equals(originalModel.countryCapital));
        expect(recreatedModel.countryTld, equals(originalModel.countryTld));
        expect(recreatedModel.continentCode, equals(originalModel.continentCode));
        expect(recreatedModel.inEu, equals(originalModel.inEu));
        expect(recreatedModel.postal, equals(originalModel.postal));
        expect(recreatedModel.latitude, equals(originalModel.latitude));
        expect(recreatedModel.longitude, equals(originalModel.longitude));
        expect(recreatedModel.timezone, equals(originalModel.timezone));
        expect(recreatedModel.utcOffset, equals(originalModel.utcOffset));
        expect(recreatedModel.countryCallingCode, equals(originalModel.countryCallingCode));
        expect(recreatedModel.currency, equals(originalModel.currency));
        expect(recreatedModel.currencyName, equals(originalModel.currencyName));
        expect(recreatedModel.languages, equals(originalModel.languages));
        expect(recreatedModel.countryArea, equals(originalModel.countryArea));
        expect(recreatedModel.countryPopulation, equals(originalModel.countryPopulation));
        expect(recreatedModel.asn, equals(originalModel.asn));
        expect(recreatedModel.org, equals(originalModel.org));
      });
    });
  });
}