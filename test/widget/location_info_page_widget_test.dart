import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/presentation/pages/location_info_page.dart';
import 'package:ip_locator/presentation/providers/connectivity_notifier.dart';
import 'package:ip_locator/presentation/viewmodels/location_info_vm.dart';
import 'package:ip_locator/presentation/widgets/error_display_widget.dart';
import 'package:ip_locator/presentation/widgets/base_offline_error_widget.dart';
import 'package:ip_locator/presentation/widgets/info_card_widget.dart';
import 'package:ip_locator/utils/api_error.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dart_either/dart_either.dart';

void main() {
  group('LocationInfoPage Widget Tests', () {
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

    Widget createTestApp(IpLocationData? locationData) {
      return ProviderScope(
        child: MaterialApp(
          home: LocationInfoPage(locationData: locationData),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
        ),
      );
    }

    Widget createTestAppWithMocks({
      bool isConnected = true,
      LocationinfoViewModel? viewModel,
    }) {
      return ProviderScope(
        overrides: [
          if (viewModel != null)
            locationInfoViewModelProvider.overrideWith(
              (ref) => Future.value(viewModel),
            ),
          isConnectedProvider.overrideWith((ref) => isConnected),
        ],
        child: MaterialApp(
          home: const LocationInfoPage(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
        ),
      );
    }

    group('Direct Location Data Display Tests', () {
      testWidgets('should display location data when provided directly', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(InfoCardWidget), findsAtLeastNWidgets(3));
        expect(find.text('Location Information'), findsOneWidget);
        expect(find.text('Network Information'), findsOneWidget);
        expect(find.text('Geographic Details'), findsOneWidget);
        expect(find.textContaining('8.8.8.8'), findsWidgets);
        expect(find.textContaining('Mountain View'), findsWidgets);
        expect(find.textContaining('California'), findsWidgets);
      });

      testWidgets('should have scrollable content', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should display proper card icons', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.location_on), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.public), findsAtLeastNWidgets(1));
        expect(find.byIcon(Icons.map), findsAtLeastNWidgets(1));
      });
    });

    group('Provider-based Data Display Tests', () {
      testWidgets('should display loading state', (tester) async {
        final testApp = ProviderScope(
          overrides: [
            locationInfoViewModelProvider.overrideWith(
              (ref) => Stream<LocationinfoViewModel>.value(
                LocationinfoViewModel.fromLocationData(sampleLocationData)
              ).first,
            ),
            isConnectedProvider.overrideWith((ref) => true),
          ],
          child: MaterialApp(
            home: const LocationInfoPage(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
          ),
        );
        
        await tester.pumpWidget(testApp);
        
        // Check for loading state first
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Fetching your IP location...'), findsOneWidget);
        
        // Wait for the future to complete
        await tester.pumpAndSettle();
      });

      testWidgets('should display error state when API fails', (tester) async {
        const apiError = ApiError(
          type: ApiErrorType.server,
          message: 'Internal server error',
        );
        
        final testApp = createTestAppWithMocks(
          viewModel: LocationinfoViewModel(Left(apiError)),
        );

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(ErrorDisplayWidget), findsOneWidget);
        expect(find.text('API Error'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should display success state with data', (tester) async {
        final testApp = createTestAppWithMocks(
          viewModel: LocationinfoViewModel.fromLocationData(sampleLocationData),
        );

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(InfoCardWidget), findsAtLeastNWidgets(3));
        expect(find.textContaining('8.8.8.8'), findsWidgets);
        expect(find.textContaining('Mountain View'), findsWidgets);
      });

      testWidgets('should display no data message', (tester) async {
        final testApp = createTestAppWithMocks(
          viewModel: const LocationinfoViewModel(null),
        );

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.text('No data available'), findsOneWidget);
      });
    });

    group('Connectivity Tests', () {
      testWidgets('should display offline state when not connected', (tester) async {
        final testApp = createTestAppWithMocks(isConnected: false);

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(BaseOfflineErrorWidget), findsOneWidget);
        expect(find.text('No internet connection'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should handle connectivity changes', (tester) async {
        // Start offline with a consistent set of overrides 
        final testApp = ProviderScope(
          overrides: [
            locationInfoViewModelProvider.overrideWith(
              (ref) => Future.value(LocationinfoViewModel.fromLocationData(sampleLocationData)),
            ),
            isConnectedProvider.overrideWith((ref) => false), // Start offline
          ],
          child: MaterialApp(
            home: const LocationInfoPage(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
          ),
        );
        
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();
        expect(find.byType(BaseOfflineErrorWidget), findsOneWidget);

        // For connectivity changes, we'll test in a separate test
        // This test just verifies offline display works
        expect(find.byType(InfoCardWidget), findsNothing);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle retry button tap', (tester) async {
        const apiError = ApiError(
          type: ApiErrorType.network,
          message: 'Connection failed',
        );
        
        final testApp = createTestAppWithMocks(
          viewModel: LocationinfoViewModel(Left(apiError)),
        );

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(ErrorDisplayWidget), findsOneWidget);
        
        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(find.byType(ErrorDisplayWidget), findsOneWidget);
      });

      testWidgets('should display different error types', (tester) async {
        const networkError = ApiError(
          type: ApiErrorType.network,
          message: 'Network failure',
        );
        
        final testApp = createTestAppWithMocks(
          viewModel: LocationinfoViewModel(Left(networkError)),
        );

        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(ErrorDisplayWidget), findsOneWidget);
        expect(find.text('API Error'), findsOneWidget);
        expect(find.textContaining('Network failure'), findsOneWidget);
      });
    });

    group('Data Formatting Tests', () {
      testWidgets('should properly format location data', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.text('Location Information'), findsOneWidget);
        expect(find.text('Network Information'), findsOneWidget);
        expect(find.text('Geographic Details'), findsOneWidget);
        expect(find.textContaining('8.8.8.8'), findsWidgets);
        expect(find.textContaining('37.419'), findsWidgets);
        expect(find.textContaining('USD'), findsWidgets);
      });

      testWidgets('should handle empty data gracefully', (tester) async {
        final incompleteData = IpLocationData(
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

        final testApp = createTestApp(incompleteData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(InfoCardWidget), findsAtLeastNWidgets(3));
        expect(find.textContaining('192.168.1.1'), findsWidgets);
        expect(find.textContaining('N/A'), findsWidgets);
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have proper widget hierarchy', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should maintain proper spacing', (tester) async {
        final testApp = createTestApp(sampleLocationData);
        await tester.pumpWidget(testApp);
        await tester.pumpAndSettle();

        expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
      });
    });
  });
}