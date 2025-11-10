import 'package:ip_locator/domain/entities/ip_location_data.dart';

class IpLocationModel extends IpLocationData {
  const IpLocationModel({
    required super.ip,
    required super.network,
    required super.version,
    required super.city,
    required super.region,
    required super.regionCode,
    required super.country,
    required super.countryName,
    required super.countryCode,
    required super.countryCodeIso3,
    required super.countryCapital,
    required super.countryTld,
    required super.continentCode,
    required super.inEu,
    required super.postal,
    required super.latitude,
    required super.longitude,
    required super.timezone,
    required super.utcOffset,
    required super.countryCallingCode,
    required super.currency,
    required super.currencyName,
    required super.languages,
    required super.countryArea,
    required super.countryPopulation,
    required super.asn,
    required super.org,
  });

  /// ✅ Creates a model from a JSON map.
  ///
  /// Expects [json] to be a [Map<String, dynamic>] where all keys are present.
  /// Handles missing or null values by providing default values.
  factory IpLocationModel.fromJson(Map<String, dynamic> json) {
    return IpLocationModel(
      ip: json['ip'] ?? '',
      network: json['network'] ?? '',
      version: json['version'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      regionCode: json['region_code'] ?? '',
      country: json['country'] ?? '',
      countryName: json['country_name'] ?? '',
      countryCode: json['country_code'] ?? '',
      countryCodeIso3: json['country_code_iso3'] ?? '',
      countryCapital: json['country_capital'] ?? '',
      countryTld: json['country_tld'] ?? '',
      continentCode: json['continent_code'] ?? '',
      inEu: json['in_eu'] ?? false,
      postal: json['postal'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      timezone: json['timezone'] ?? '',
      utcOffset: json['utc_offset'] ?? '',
      countryCallingCode: json['country_calling_code'] ?? '',
      currency: json['currency'] ?? '',
      currencyName: json['currency_name'] ?? '',
      languages: json['languages'] ?? '',
      countryArea: double.tryParse(json['country_area'].toString()) ?? 0.0,
      countryPopulation:
          int.tryParse(json['country_population'].toString()) ?? 0,
      asn: json['asn'] ?? '',
      org: json['org'] ?? '',
    );
  }

  /// ✅ Convert model back to JSON (for caching or network)
  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'network': network,
      'version': version,
      'city': city,
      'region': region,
      'region_code': regionCode,
      'country': country,
      'country_name': countryName,
      'country_code': countryCode,
      'country_code_iso3': countryCodeIso3,
      'country_capital': countryCapital,
      'country_tld': countryTld,
      'continent_code': continentCode,
      'in_eu': inEu,
      'postal': postal,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'utc_offset': utcOffset,
      'country_calling_code': countryCallingCode,
      'currency': currency,
      'currency_name': currencyName,
      'languages': languages,
      'country_area': countryArea,
      'country_population': countryPopulation,
      'asn': asn,
      'org': org,
    };
  }
}
