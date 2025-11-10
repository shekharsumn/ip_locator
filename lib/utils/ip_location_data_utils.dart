import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/utils/formatting_utils.dart';

/// Simple data class for key-value info display
class InfoItem {
  final String label;
  final String value;

  const InfoItem(this.label, this.value);
}

/// Utility class for transforming IP location data into display-ready format
/// This class provides reusable methods for converting IpLocationData into structured InfoItem lists
class IpLocationDataUtils {
  // Private constructor to prevent instantiation
  IpLocationDataUtils._();

  /// Transform location data into location information items
  /// Returns formatted location details including IP, city, region, country, and timezone
  static List<InfoItem> getLocationInfo(
    IpLocationData? data, {
    String ipAddressLabel = 'IP Address',
    String cityLabel = 'City',
    String regionLabel = 'Region',
    String countryLabel = 'Country',
    String timezoneLabel = 'Timezone',
    String notAvailable = 'N/A',
  }) {
    if (data == null) return [];

    return [
      InfoItem(
        ipAddressLabel,
        FormattingUtils.formatField(data.ip, notAvailable: notAvailable),
      ),
      InfoItem(
        cityLabel,
        FormattingUtils.formatField(data.city, notAvailable: notAvailable),
      ),
      InfoItem(
        regionLabel,
        FormattingUtils.formatField(data.region, notAvailable: notAvailable),
      ),
      InfoItem(
        countryLabel,
        FormattingUtils.formatField(
          data.countryName,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        timezoneLabel,
        FormattingUtils.formatField(data.timezone, notAvailable: notAvailable),
      ),
    ];
  }

  /// Transform location data into network information items
  /// Returns formatted network details including network, version, ASN, and organization
  static List<InfoItem> getNetworkInfo(
    IpLocationData? data, {
    String networkLabel = 'Network',
    String versionLabel = 'Version',
    String asnLabel = 'ASN',
    String organizationLabel = 'Organization',
    String notAvailable = 'N/A',
  }) {
    if (data == null) return [];

    return [
      InfoItem(
        networkLabel,
        FormattingUtils.formatField(data.network, notAvailable: notAvailable),
      ),
      InfoItem(
        versionLabel,
        FormattingUtils.formatField(data.version, notAvailable: notAvailable),
      ),
      InfoItem(
        asnLabel,
        FormattingUtils.formatField(data.asn, notAvailable: notAvailable),
      ),
      InfoItem(
        organizationLabel,
        FormattingUtils.formatField(data.org, notAvailable: notAvailable),
      ),
    ];
  }

  /// Transform location data into geographic information items
  /// Returns formatted geographic details including coordinates, postal code, continent, EU status, currency, and languages
  static List<InfoItem> getGeographicInfo(
    IpLocationData? data, {
    String coordinatesLabel = 'Coordinates',
    String postalCodeLabel = 'Postal Code',
    String continentLabel = 'Continent',
    String inEuLabel = 'In EU',
    String currencyLabel = 'Currency',
    String languagesLabel = 'Languages',
    String notAvailable = 'N/A',
    String yes = 'Yes',
    String no = 'No',
  }) {
    if (data == null) return [];

    return [
      InfoItem(
        coordinatesLabel,
        FormattingUtils.formatCoordinates(
          data.latitude,
          data.longitude,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        postalCodeLabel,
        FormattingUtils.formatField(data.postal, notAvailable: notAvailable),
      ),
      InfoItem(
        continentLabel,
        FormattingUtils.formatField(
          data.continentCode,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        inEuLabel,
        FormattingUtils.formatBoolean(data.inEu, yes: yes, no: no),
      ),
      InfoItem(
        currencyLabel,
        FormattingUtils.formatCurrency(
          data.currency,
          data.currencyName,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        languagesLabel,
        FormattingUtils.formatField(data.languages, notAvailable: notAvailable),
      ),
    ];
  }

  /// Get all available information sections as a comprehensive data structure
  /// Returns a map containing all three information categories
  static Map<String, List<InfoItem>> getAllInfo(IpLocationData? data) {
    return {
      'location': getLocationInfo(data),
      'network': getNetworkInfo(data),
      'geographic': getGeographicInfo(data),
    };
  }

  /// Get extended location information with additional details
  /// Includes all basic location info plus additional country details
  static List<InfoItem> getExtendedLocationInfo(
    IpLocationData? data, {
    // Basic location labels (passed to getLocationInfo)
    String ipAddressLabel = 'IP Address',
    String cityLabel = 'City',
    String regionLabel = 'Region',
    String countryLabel = 'Country',
    String timezoneLabel = 'Timezone',
    // Additional labels
    String countryCodeLabel = 'Country Code',
    String countryIso3Label = 'Country ISO3',
    String countryCapitalLabel = 'Country Capital',
    String countryTldLabel = 'Country TLD',
    String callingCodeLabel = 'Calling Code',
    String utcOffsetLabel = 'UTC Offset',
    String notAvailable = 'N/A',
  }) {
    if (data == null) return [];

    final basicInfo = getLocationInfo(
      data,
      ipAddressLabel: ipAddressLabel,
      cityLabel: cityLabel,
      regionLabel: regionLabel,
      countryLabel: countryLabel,
      timezoneLabel: timezoneLabel,
      notAvailable: notAvailable,
    );
    final additionalInfo = [
      InfoItem(
        countryCodeLabel,
        FormattingUtils.formatField(
          data.countryCode,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        countryIso3Label,
        FormattingUtils.formatField(
          data.countryCodeIso3,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        countryCapitalLabel,
        FormattingUtils.formatField(
          data.countryCapital,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        countryTldLabel,
        FormattingUtils.formatField(
          data.countryTld,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        callingCodeLabel,
        FormattingUtils.formatField(
          data.countryCallingCode,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        utcOffsetLabel,
        FormattingUtils.formatField(data.utcOffset, notAvailable: notAvailable),
      ),
    ];

    return [...basicInfo, ...additionalInfo];
  }

  /// Get extended geographic information with formatting options
  static List<InfoItem> getExtendedGeographicInfo(
    IpLocationData? data, {
    String coordinatesLabel = 'Coordinates',
    String postalCodeLabel = 'Postal Code',
    String continentLabel = 'Continent',
    String inEuLabel = 'In EU',
    String currencyLabel = 'Currency',
    String languagesLabel = 'Languages',
    String countryIso3Label = 'Country ISO3',
    String countryCapitalLabel = 'Country Capital',
    String currencyNameLabel = 'Currency Name',
    String callingCodeLabel = 'Calling Code',
    String notAvailable = 'Not Available',
    String yes = 'Yes',
    String no = 'No',
  }) {
    if (data == null) return [];

    final basicInfo = getGeographicInfo(
      data,
      coordinatesLabel: coordinatesLabel,
      postalCodeLabel: postalCodeLabel,
      continentLabel: continentLabel,
      inEuLabel: inEuLabel,
      currencyLabel: currencyLabel,
      languagesLabel: languagesLabel,
      notAvailable: notAvailable,
      yes: yes,
      no: no,
    );

    final additionalInfo = [
      InfoItem(
        countryIso3Label,
        FormattingUtils.formatField(
          data.countryCodeIso3,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        countryCapitalLabel,
        FormattingUtils.formatField(
          data.countryCapital,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        currencyNameLabel,
        FormattingUtils.formatField(
          data.currencyName,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        callingCodeLabel,
        FormattingUtils.formatField(
          data.countryCallingCode,
          notAvailable: notAvailable,
        ),
      ),
    ];

    return [...basicInfo, ...additionalInfo];
  }

  /// Filter info items to exclude empty values (marked as 'N/A')
  /// Useful for displaying only available information
  static List<InfoItem> filterAvailableInfo(List<InfoItem> items) {
    return items.where((item) => item.value != 'N/A').toList();
  }

  /// Create a summary info item list with most important details
  /// Returns a condensed view of the most relevant location information
  static List<InfoItem> getSummaryInfo(
    IpLocationData? data, {
    String ipAddressLabel = 'IP Address',
    String locationLabel = 'Location',
    String countryLabel = 'Country',
    String coordinatesLabel = 'Coordinates',
    String timezoneLabel = 'Timezone',
    String ispLabel = 'ISP',
    String notAvailable = 'Not Available',
  }) {
    if (data == null) return [];

    return filterAvailableInfo([
      InfoItem(
        ipAddressLabel,
        FormattingUtils.formatField(data.ip, notAvailable: notAvailable),
      ),
      InfoItem(
        locationLabel,
        FormattingUtils.formatLocation(
          data.city,
          data.region,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        countryLabel,
        FormattingUtils.formatField(
          data.countryName,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        coordinatesLabel,
        FormattingUtils.formatCoordinates(
          data.latitude,
          data.longitude,
          notAvailable: notAvailable,
        ),
      ),
      InfoItem(
        timezoneLabel,
        FormattingUtils.formatField(data.timezone, notAvailable: notAvailable),
      ),
      InfoItem(
        ispLabel,
        FormattingUtils.formatField(data.org, notAvailable: notAvailable),
      ),
    ]);
  }
}
