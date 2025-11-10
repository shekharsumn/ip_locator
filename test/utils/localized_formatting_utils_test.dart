import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/l10n/app_localizations_en.dart';
import 'package:ip_locator/utils/localized_formatting_utils.dart';

void main() {
  group('LocalizedFormattingUtils Tests', () {
    late AppLocalizations localizations;
    late LocalizedFormattingUtils formatter;

    setUp(() {
      // Create mock localizations
      localizations = AppLocalizationsEn();
      formatter = LocalizedFormattingUtils(localizations);
    });

    group('Constructor Tests', () {
      test('should create instance with localizations', () {
        expect(formatter, isNotNull);
        expect(formatter.localizations, equals(localizations));
      });

      testWidgets('should create instance from BuildContext', (WidgetTester tester) async {
        LocalizedFormattingUtils? contextFormatter;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                contextFormatter = LocalizedFormattingUtils.of(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(contextFormatter, isNotNull);
        expect(contextFormatter!.localizations, isNotNull);
      });
    });

    group('formatField Tests', () {
      test('should return original value for non-empty string', () {
        final result = formatter.formatField('Test Value');
        expect(result, equals('Test Value'));
      });

      test('should return localized N/A for null value', () {
        final result = formatter.formatField(null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A for empty string', () {
        final result = formatter.formatField('');
        expect(result, equals(localizations.notAvailable));
      });

      test('should handle whitespace-only strings', () {
        final result = formatter.formatField('   ');
        expect(result, equals('   ')); // Should preserve whitespace
      });
    });

    group('formatCoordinates Tests', () {
      test('should return formatted coordinates for valid values', () {
        final result = formatter.formatCoordinates(37.4419, -122.143);
        expect(result, equals('37.4419, -122.143'));
      });

      test('should return localized N/A for zero coordinates', () {
        final result = formatter.formatCoordinates(0.0, 0.0);
        expect(result, equals(localizations.notAvailable));
      });

      test('should return formatted coordinates for negative values', () {
        final result = formatter.formatCoordinates(-33.8688, 151.2093);
        expect(result, equals('-33.8688, 151.2093'));
      });

      test('should return formatted coordinates when only one coordinate is zero', () {
        final result = formatter.formatCoordinates(0.0, 151.2093);
        expect(result, equals('0.0, 151.2093'));
      });

      test('should handle very large coordinate values', () {
        final result = formatter.formatCoordinates(999.9999, -999.9999);
        expect(result, equals('999.9999, -999.9999'));
      });
    });

    group('formatBoolean Tests', () {
      test('should return localized Yes for true value', () {
        final result = formatter.formatBoolean(true);
        expect(result, equals(localizations.yes));
      });

      test('should return localized No for false value', () {
        final result = formatter.formatBoolean(false);
        expect(result, equals(localizations.no));
      });
    });

    group('formatCurrency Tests', () {
      test('should return formatted currency with name', () {
        final result = formatter.formatCurrency('USD', 'US Dollar');
        expect(result, equals('USD (US Dollar)'));
      });

      test('should return currency code only when name is null', () {
        final result = formatter.formatCurrency('EUR', null);
        expect(result, equals('EUR'));
      });

      test('should return currency code only when name is empty', () {
        final result = formatter.formatCurrency('GBP', '');
        expect(result, equals('GBP'));
      });

      test('should return localized N/A when currency is null', () {
        final result = formatter.formatCurrency(null, 'US Dollar');
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A when currency is empty', () {
        final result = formatter.formatCurrency('', 'US Dollar');
        expect(result, equals(localizations.notAvailable));
      });
    });

    group('formatNumeric Tests', () {
      test('should format integer with zero decimal places', () {
        final result = formatter.formatNumeric(1000);
        expect(result, equals('1000'));
      });

      test('should format double with specified decimal places', () {
        final result = formatter.formatNumeric(1234.5678, decimalPlaces: 2);
        expect(result, equals('1234.57'));
      });

      test('should return localized N/A for null value', () {
        final result = formatter.formatNumeric(null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format zero value as localized N/A by default', () {
        final result = formatter.formatNumeric(0);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format negative numbers correctly', () {
        final result = formatter.formatNumeric(-1234.56, decimalPlaces: 1);
        expect(result, equals('-1234.6'));
      });
    });

    group('formatLargeNumber Tests', () {
      test('should format large numbers with comma separators', () {
        final result = formatter.formatLargeNumber(1234567);
        expect(result, contains('1'));
        expect(result, contains('234'));
        expect(result, contains('567'));
      });

      test('should return localized N/A for null value', () {
        final result = formatter.formatLargeNumber(null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format zero as localized N/A', () {
        final result = formatter.formatLargeNumber(0);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format negative large numbers correctly', () {
        final result = formatter.formatLargeNumber(-1000000);
        expect(result, startsWith('-'));
      });
    });

    group('formatArea Tests', () {
      test('should format area with localized unit', () {
        final result = formatter.formatArea(9629091.0);
        expect(result, contains('9629091'));
        expect(result, contains(localizations.squareKilometers));
      });

      test('should return localized N/A for null value', () {
        final result = formatter.formatArea(null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A for zero area', () {
        final result = formatter.formatArea(0.0);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format decimal area values', () {
        final result = formatter.formatArea(123.45);
        expect(result, contains('123'));
        expect(result, contains(localizations.squareKilometers));
      });
    });

    group('formatPopulation Tests', () {
      test('should format population with comma separators', () {
        final result = formatter.formatPopulation(310232863);
        expect(result, contains('310'));
        expect(result, contains('232'));
        expect(result, contains('863'));
      });

      test('should return localized N/A for null value', () {
        final result = formatter.formatPopulation(null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A for zero population', () {
        final result = formatter.formatPopulation(0);
        expect(result, equals(localizations.notAvailable));
      });

      test('should format small populations correctly', () {
        final result = formatter.formatPopulation(1000);
        expect(result, contains('1'));
        expect(result, contains('000'));
      });
    });

    group('formatTimezoneWithOffset Tests', () {
      test('should format timezone with UTC offset', () {
        final result = formatter.formatTimezoneWithOffset('America/New_York', '-0500');
        expect(result, equals('America/New_York (-0500)'));
      });

      test('should return timezone only when offset is null', () {
        final result = formatter.formatTimezoneWithOffset('Europe/London', null);
        expect(result, equals('Europe/London'));
      });

      test('should return timezone only when offset is empty', () {
        final result = formatter.formatTimezoneWithOffset('Asia/Tokyo', '');
        expect(result, equals('Asia/Tokyo'));
      });

      test('should return localized N/A when timezone is null', () {
        final result = formatter.formatTimezoneWithOffset(null, '-0800');
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A when timezone is empty', () {
        final result = formatter.formatTimezoneWithOffset('', '+0000');
        expect(result, equals(localizations.notAvailable));
      });

      test('should handle positive UTC offsets', () {
        final result = formatter.formatTimezoneWithOffset('Asia/Dubai', '+0400');
        expect(result, equals('Asia/Dubai (+0400)'));
      });
    });

    group('formatCountryWithCapital Tests', () {
      test('should format country with capital', () {
        final result = formatter.formatCountryWithCapital('United States', 'Washington D.C.');
        expect(result, contains('United States'));
        expect(result, contains('Washington D.C.'));
        expect(result, contains(localizations.capital));
      });

      test('should return country only when capital is null', () {
        final result = formatter.formatCountryWithCapital('Germany', null);
        expect(result, equals('Germany'));
      });

      test('should return country only when capital is empty', () {
        final result = formatter.formatCountryWithCapital('France', '');
        expect(result, equals('France'));
      });

      test('should return localized N/A when country is null', () {
        final result = formatter.formatCountryWithCapital(null, 'Paris');
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A when country is empty', () {
        final result = formatter.formatCountryWithCapital('', 'London');
        expect(result, equals(localizations.notAvailable));
      });
    });

    group('formatLocation Tests', () {
      test('should format primary and secondary location', () {
        final result = formatter.formatLocation('San Francisco', 'California');
        expect(result, equals('San Francisco, California'));
      });

      test('should return primary location only when secondary is null', () {
        final result = formatter.formatLocation('New York', null);
        expect(result, equals('New York'));
      });

      test('should return primary location only when secondary is empty', () {
        final result = formatter.formatLocation('Chicago', '');
        expect(result, equals('Chicago'));
      });

      test('should return secondary location when primary is null', () {
        final result = formatter.formatLocation(null, 'Texas');
        expect(result, equals('Texas'));
      });

      test('should return secondary location when primary is empty', () {
        final result = formatter.formatLocation('', 'Florida');
        expect(result, equals('Florida'));
      });

      test('should return localized N/A when both are null', () {
        final result = formatter.formatLocation(null, null);
        expect(result, equals(localizations.notAvailable));
      });

      test('should return localized N/A when both are empty', () {
        final result = formatter.formatLocation('', '');
        expect(result, equals(localizations.notAvailable));
      });
    });

    group('formatErrorMessage Tests', () {
      test('should return string error as-is', () {
        final result = formatter.formatErrorMessage('Network error');
        expect(result, equals('Network error'));
      });

      test('should return exception message', () {
        final exception = Exception('Something went wrong');
        final result = formatter.formatErrorMessage(exception);
        expect(result, equals('Exception: Something went wrong'));
      });

      test('should return localized fallback for null error', () {
        final result = formatter.formatErrorMessage(null);
        expect(result, equals(localizations.anErrorOccurred));
      });

      test('should return localized fallback for empty string error', () {
        final result = formatter.formatErrorMessage('');
        expect(result, equals(localizations.anErrorOccurred));
      });

      test('should handle complex error objects', () {
        final error = {'type': 'network', 'message': 'Connection failed'};
        final result = formatter.formatErrorMessage(error);
        expect(result, contains('type'));
        expect(result, contains('network'));
      });
    });

    group('Edge Cases and Integration Tests', () {
      test('should handle all null values consistently', () {
        expect(formatter.formatField(null), equals(localizations.notAvailable));
        expect(formatter.formatCurrency(null, null), equals(localizations.notAvailable));
        expect(formatter.formatNumeric(null), equals(localizations.notAvailable));
        expect(formatter.formatArea(null), equals(localizations.notAvailable));
        expect(formatter.formatPopulation(null), equals(localizations.notAvailable));
        expect(formatter.formatTimezoneWithOffset(null, null), equals(localizations.notAvailable));
        expect(formatter.formatCountryWithCapital(null, null), equals(localizations.notAvailable));
        expect(formatter.formatLocation(null, null), equals(localizations.notAvailable));
      });

      test('should handle mixed localization usage', () {
        final boolResult = formatter.formatBoolean(true);
        final fieldResult = formatter.formatField(null);
        
        expect(boolResult, equals(localizations.yes));
        expect(fieldResult, equals(localizations.notAvailable));
      });

      test('should maintain consistent formatting style', () {
        final currency = formatter.formatCurrency('USD', 'US Dollar');
        final timezone = formatter.formatTimezoneWithOffset('America/New_York', '-0500');
        
        expect(currency, equals('USD (US Dollar)'));
        expect(timezone, equals('America/New_York (-0500)'));
      });
    });
  });
}