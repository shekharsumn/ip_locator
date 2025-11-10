class IpLocationData {
  final String ip;
  final String network;
  final String version;
  final String city;
  final String region;
  final String regionCode;
  final String country;
  final String countryName;
  final String countryCode;
  final String countryCodeIso3;
  final String countryCapital;
  final String countryTld;
  final String continentCode;
  final bool inEu;
  final String postal;
  final double latitude;
  final double longitude;
  final String timezone;
  final String utcOffset;
  final String countryCallingCode;
  final String currency;
  final String currencyName;
  final String languages;
  final double countryArea;
  final int countryPopulation;
  final String asn;
  final String org;

  const IpLocationData({
    required this.ip,
    required this.network,
    required this.version,
    required this.city,
    required this.region,
    required this.regionCode,
    required this.country,
    required this.countryName,
    required this.countryCode,
    required this.countryCodeIso3,
    required this.countryCapital,
    required this.countryTld,
    required this.continentCode,
    required this.inEu,
    required this.postal,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.utcOffset,
    required this.countryCallingCode,
    required this.currency,
    required this.currencyName,
    required this.languages,
    required this.countryArea,
    required this.countryPopulation,
    required this.asn,
    required this.org,
  });
}
