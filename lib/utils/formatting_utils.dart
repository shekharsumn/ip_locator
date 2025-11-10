/// Utility class for formatting data for display purposes
/// This class contains reusable formatting methods that can be used across the application
class FormattingUtils {
  // Private constructor to prevent instantiation
  FormattingUtils._();

  /// Format field values for display (handles null/empty values)
  /// Returns provided notAvailable string for null or empty strings
  static String formatField(String? value, {String notAvailable = 'N/A'}) {
    return (value == null || value.isEmpty) ? notAvailable : value;
  }

  /// Format coordinates for display
  /// Returns provided notAvailable string if both coordinates are 0.0, otherwise returns formatted coordinates
  static String formatCoordinates(
    double latitude,
    double longitude, {
    String notAvailable = 'N/A',
  }) {
    if (latitude == 0.0 && longitude == 0.0) return notAvailable;
    return '$latitude, $longitude';
  }

  /// Format boolean values for user display
  /// Converts boolean to provided yes/no strings
  static String formatBoolean(
    bool value, {
    String yes = 'Yes',
    String no = 'No',
  }) {
    return value ? yes : no;
  }

  /// Format currency information for display
  /// Combines currency code and name, handles null/empty values gracefully
  static String formatCurrency(
    String? currency,
    String? currencyName, {
    String notAvailable = 'N/A',
  }) {
    if (currency == null || currency.isEmpty) return notAvailable;
    if (currencyName == null || currencyName.isEmpty) return currency;
    return '$currency ($currencyName)';
  }

  /// Format a numeric value with proper decimal places
  /// Useful for displaying areas, populations, etc.
  static String formatNumeric(
    num? value, {
    int decimalPlaces = 0,
    String notAvailable = 'N/A',
  }) {
    if (value == null || value == 0) return notAvailable;
    if (decimalPlaces == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(decimalPlaces);
  }

  /// Format large numbers with comma separators (e.g., population)
  /// Example: 1234567 -> 1,234,567
  static String formatLargeNumber(int? value, {String notAvailable = 'N/A'}) {
    if (value == null || value == 0) return notAvailable;
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format area with appropriate unit
  static String formatArea(
    double? area, {
    String unit = 'sq km',
    String notAvailable = 'N/A',
  }) {
    if (area == null || area == 0.0) return notAvailable;
    return '${formatNumeric(area, notAvailable: notAvailable)} $unit';
  }

  /// Format population with comma separators
  static String formatPopulation(
    int? population, {
    String notAvailable = 'N/A',
  }) {
    if (population == null || population == 0) return notAvailable;
    return formatLargeNumber(population, notAvailable: notAvailable);
  }

  /// Format timezone with UTC offset if available
  static String formatTimezoneWithOffset(
    String? timezone,
    String? utcOffset, {
    String notAvailable = 'N/A',
  }) {
    final formattedTimezone = formatField(timezone, notAvailable: notAvailable);
    if (formattedTimezone == notAvailable) return formattedTimezone;

    final formattedOffset = formatField(utcOffset, notAvailable: notAvailable);
    if (formattedOffset == notAvailable) return formattedTimezone;

    return '$formattedTimezone ($formattedOffset)';
  }

  /// Format country information with capital
  static String formatCountryWithCapital(
    String? country,
    String? capital, {
    String capitalLabel = 'Capital',
    String notAvailable = 'N/A',
  }) {
    final formattedCountry = formatField(country, notAvailable: notAvailable);
    if (formattedCountry == notAvailable) return formattedCountry;

    final formattedCapital = formatField(capital, notAvailable: notAvailable);
    if (formattedCapital == notAvailable) return formattedCountry;

    return '$formattedCountry ($capitalLabel: $formattedCapital)';
  }

  /// Format location as "City, Region" or similar combinations
  /// Returns combined location string, handles null/empty values gracefully
  static String formatLocation(
    String? primary,
    String? secondary, {
    String notAvailable = 'N/A',
  }) {
    final formattedPrimary = formatField(primary, notAvailable: notAvailable);
    final formattedSecondary = formatField(
      secondary,
      notAvailable: notAvailable,
    );

    if (formattedPrimary == notAvailable && formattedSecondary == notAvailable) {
      return notAvailable;
    }
    if (formattedPrimary == notAvailable) {
      return formattedSecondary;
    }
    if (formattedSecondary == notAvailable) {
      return formattedPrimary;
    }

    return '$formattedPrimary, $formattedSecondary';
  }

  /// Format error messages for consistent error display
  /// Provides a fallback message if the error is null or empty
  static String formatErrorMessage(
    Object? error, {
    String fallback = 'An error occurred',
  }) {
    if (error == null) return fallback;
    final errorString = error.toString();
    return errorString.isEmpty ? fallback : errorString;
  }
}
