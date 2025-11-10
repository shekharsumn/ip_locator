import 'package:flutter/material.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/utils/formatting_utils.dart';

/// Localized version of FormattingUtils that uses app localizations
/// This class provides the same formatting functionality but with localized strings
class LocalizedFormattingUtils {
  final AppLocalizations localizations;

  const LocalizedFormattingUtils(this.localizations);

  /// Create instance from BuildContext
  factory LocalizedFormattingUtils.of(BuildContext context) {
    return LocalizedFormattingUtils(AppLocalizations.of(context)!);
  }

  /// Format field values for display (handles null/empty values)
  /// Returns localized 'N/A' for null or empty strings
  String formatField(String? value) {
    return FormattingUtils.formatField(
      value,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format coordinates for display
  /// Returns localized 'N/A' if both coordinates are 0.0, otherwise returns formatted coordinates
  String formatCoordinates(double latitude, double longitude) {
    return FormattingUtils.formatCoordinates(
      latitude,
      longitude,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format boolean values for user display
  /// Converts boolean to localized 'Yes'/'No' string
  String formatBoolean(bool value) {
    return FormattingUtils.formatBoolean(
      value,
      yes: localizations.yes,
      no: localizations.no,
    );
  }

  /// Format currency information for display
  /// Combines currency code and name, handles null/empty values gracefully
  String formatCurrency(String? currency, String? currencyName) {
    return FormattingUtils.formatCurrency(
      currency,
      currencyName,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format a numeric value with proper decimal places
  /// Useful for displaying areas, populations, etc.
  String formatNumeric(num? value, {int decimalPlaces = 0}) {
    return FormattingUtils.formatNumeric(
      value,
      decimalPlaces: decimalPlaces,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format large numbers with comma separators (e.g., population)
  /// Example: 1234567 -> 1,234,567
  String formatLargeNumber(int? value) {
    return FormattingUtils.formatLargeNumber(
      value,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format area with appropriate localized unit
  String formatArea(double? area) {
    return FormattingUtils.formatArea(
      area,
      unit: localizations.squareKilometers,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format population with comma separators
  String formatPopulation(int? population) {
    return FormattingUtils.formatPopulation(
      population,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format timezone with UTC offset if available
  String formatTimezoneWithOffset(String? timezone, String? utcOffset) {
    return FormattingUtils.formatTimezoneWithOffset(
      timezone,
      utcOffset,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format country information with capital
  String formatCountryWithCapital(String? country, String? capital) {
    return FormattingUtils.formatCountryWithCapital(
      country,
      capital,
      capitalLabel: localizations.capital,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format location as "City, Region" or similar combinations
  /// Returns combined location string, handles null/empty values gracefully
  String formatLocation(String? primary, String? secondary) {
    return FormattingUtils.formatLocation(
      primary,
      secondary,
      notAvailable: localizations.notAvailable,
    );
  }

  /// Format error messages for consistent error display
  /// Provides a localized fallback message if the error is null or empty
  String formatErrorMessage(Object? error) {
    return FormattingUtils.formatErrorMessage(
      error,
      fallback: localizations.anErrorOccurred,
    );
  }
}
