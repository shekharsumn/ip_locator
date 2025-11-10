import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ip_locator/presentation/pages/home_page.dart';
import 'package:ip_locator/presentation/providers/service_providers.dart';
import 'package:ip_locator/domain/services/connectivity_service.dart';
import 'package:ip_locator/domain/services/ip_validation_service.dart';
import 'package:ip_locator/l10n/app_localizations.dart';

// Mock implementations for testing
class MockConnectivityService implements ConnectivityService {
  bool _hasConnection = true;
  List<ConnectivityResult> _status = [ConnectivityResult.wifi];

  void setConnectivity(bool hasConnection, List<ConnectivityResult> status) {
    _hasConnection = hasConnection;
    _status = status;
  }

  @override
  Future<bool> hasInternetConnection() async => _hasConnection;

  @override
  Future<List<ConnectivityResult>> getConnectivityStatus() async => _status;

  @override
  Stream<List<ConnectivityResult>> get connectivityStream =>
      Stream.value(_status);
}

void main() {
  group('HomePage Widget Tests', () {
    late MockConnectivityService mockConnectivityService;
    late Widget testWidget;

    setUp(() {
      mockConnectivityService = MockConnectivityService();

      testWidget = ProviderScope(
        overrides: [
          connectivityServiceProvider.overrideWithValue(mockConnectivityService),
          ipValidationServiceProvider.overrideWithValue(IpValidationServiceImpl()),
        ],
        child: MaterialApp(
          home: const HomePage(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (settings) {
            if (settings.name == 'location_details/') {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Location Details')),
                ),
              );
            }
            return null;
          },
        ),
      );
    });

    group('Initial State Tests', () {
      testWidgets('should display app title in AppBar', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('IP Info Locator'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should display enter IP address text', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('Enter IP Address'), findsOneWidget);
        expect(find.text('Enter an IPv4 or IPv6 address to get location details'), findsOneWidget);
      });

      testWidgets('should display current IP location button', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('Get My Current IP Location'), findsOneWidget);
        expect(find.byIcon(Icons.my_location), findsOneWidget);
      });

      testWidgets('should display OR divider', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('OR'), findsOneWidget);
        expect(find.byType(Divider), findsNWidgets(2)); // Two dividers around OR text
      });
    });

    group('Button Interaction Tests', () {
      testWidgets('should enable current IP button when not loading', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('Get My Current IP Location'), findsOneWidget);
      });
    });

    group('Connectivity Status Tests', () {
      testWidgets('should not show connectivity warning when connected', (tester) async {
        mockConnectivityService.setConnectivity(true, [ConnectivityResult.wifi]);

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('No internet connection detected'), findsNothing);
        expect(find.byIcon(Icons.wifi_off), findsNothing);
      });

      testWidgets('should show connectivity warning when disconnected', (tester) async {
        mockConnectivityService.setConnectivity(false, [ConnectivityResult.none]);

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('No internet connection detected'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have proper widget structure', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('should use proper theme colors', (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final theme = Theme.of(tester.element(find.byType(AppBar)));
        
        expect(appBar.backgroundColor, equals(theme.colorScheme.inversePrimary));
      });
    });
  });
}