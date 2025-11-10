import 'package:flutter/material.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/utils/ip_location_data_utils.dart';

/// Utility class for transforming IP location data into localized display-ready format
/// This class provides reusable methods for converting IpLocationData into structured InfoItem lists with localized labels
class LocalizedIpLocationDataUtils {
  // Private constructor to prevent instantiation
  LocalizedIpLocationDataUtils._();

  /// Transform location data into localized location information items
  /// Returns formatted location details with localized labels
  static List<InfoItem> getLocationInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getLocationInfo(
      data,
      ipAddressLabel: localizations.ipAddress,
      cityLabel: localizations.city,
      regionLabel: localizations.region,
      countryLabel: localizations.country,
      timezoneLabel: localizations.timezone,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Transform location data into localized network information items
  /// Returns formatted network details with localized labels
  static List<InfoItem> getNetworkInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getNetworkInfo(
      data,
      networkLabel: localizations.network,
      versionLabel: localizations.version,
      asnLabel: localizations.asn,
      organizationLabel: localizations.organization,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Transform location data into localized geographic information items
  /// Returns formatted geographic details with localized labels
  static List<InfoItem> getGeographicInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getGeographicInfo(
      data,
      coordinatesLabel: localizations.coordinates,
      postalCodeLabel: localizations.postalCode,
      continentLabel: localizations.continent,
      inEuLabel: localizations.inEu,
      currencyLabel: localizations.currency,
      languagesLabel: localizations.languages,
      notAvailable: localizations.notAvailable,
      yes: localizations.yes,
      no: localizations.no,
    );
  }

  /// Get extended localized location information with additional details
  /// Includes all basic location info plus additional country details
  static List<InfoItem> getExtendedLocationInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getExtendedLocationInfo(
      data,
      ipAddressLabel: localizations.ipAddress,
      cityLabel: localizations.city,
      regionLabel: localizations.region,
      countryLabel: localizations.country,
      timezoneLabel: localizations.timezone,
      countryCodeLabel: localizations.countryCode,
      countryIso3Label: localizations.countryIso3,
      countryCapitalLabel: localizations.countryCapital,
      countryTldLabel: localizations.countryTld,
      callingCodeLabel: localizations.callingCode,
      utcOffsetLabel: localizations.utcOffset,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Get extended geographic information with localization
  static List<InfoItem> getExtendedGeographicInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getExtendedGeographicInfo(
      data,
      coordinatesLabel: localizations.coordinates,
      postalCodeLabel: localizations.postalCode,
      continentLabel: localizations.continent,
      inEuLabel: localizations.inEu,
      currencyLabel: localizations.currency,
      languagesLabel: localizations.languages,
      countryIso3Label: localizations.countryIso3,
      countryCapitalLabel: localizations.countryCapital,
      currencyNameLabel: localizations.currencyName,
      callingCodeLabel: localizations.callingCode,
      notAvailable: localizations.notAvailable,
      yes: localizations.yes,
      no: localizations.no,
    );
  }

  /// Create a localized summary info item list with most important details
  /// Returns a condensed view of the most relevant location information
  static List<InfoItem> getSummaryInfo(
    IpLocationData? data,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return IpLocationDataUtils.getSummaryInfo(
      data,
      ipAddressLabel: localizations.ipAddress,
      locationLabel: localizations.location,
      countryLabel: localizations.country,
      coordinatesLabel: localizations.coordinates,
      timezoneLabel: localizations.timezone,
      ispLabel: localizations.isp,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Filter info items to exclude empty values (marked as 'N/A')
  /// Useful for displaying only available information
  static List<InfoItem> filterAvailableInfo(
    List<InfoItem> items, {
    String notAvailable = 'N/A',
  }) {
    return items.where((item) => item.value != notAvailable).toList();
  }
}
