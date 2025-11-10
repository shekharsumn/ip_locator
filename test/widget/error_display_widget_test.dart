import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/presentation/widgets/error_display_widget.dart';
import 'package:ip_locator/l10n/app_localizations.dart';

void main() {
  group('ErrorDisplayWidget Tests', () {
    late Widget testWidget;

    Widget createTestWidget({
      required String title,
      required String message,
      IconData? icon,
      VoidCallback? onRetry,
      String? retryButtonText,
      bool showBackButton = false,
      VoidCallback? onBack,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ErrorDisplayWidget(
            title: title,
            message: message,
            icon: icon ?? Icons.error_outline,
            onRetry: onRetry,
            retryButtonText: retryButtonText,
            showBackButton: showBackButton,
            onBack: onBack,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    group('Display Tests', () {
      testWidgets('should display title and message', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Test Error'), findsOneWidget);
        expect(find.text('This is a test error message'), findsOneWidget);
      });

      testWidgets('should display default error icon', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
        );

        await tester.pumpWidget(testWidget);

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should display custom icon when provided', (tester) async {
        testWidget = createTestWidget(
          title: 'Network Error',
          message: 'No internet connection',
          icon: Icons.wifi_off,
        );

        await tester.pumpWidget(testWidget);

        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsNothing);
      });
    });

    group('Retry Button Tests', () {
      testWidgets('should not show retry button when onRetry is null', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
        );

        await tester.pumpWidget(testWidget);

        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.text('Retry'), findsNothing);
      });

      testWidgets('should show retry button with default text when onRetry is provided', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          onRetry: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should show retry button with custom text when provided', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          onRetry: () {},
          retryButtonText: 'Try Again',
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Try Again'), findsOneWidget);
        expect(find.text('Retry'), findsNothing);
      });

      testWidgets('should call onRetry when retry button is tapped', (tester) async {
        bool retryTapped = false;

        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          onRetry: () => retryTapped = true,
        );

        await tester.pumpWidget(testWidget);

        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(retryTapped, true);
      });
    });

    group('Back Button Tests', () {
      testWidgets('should not show back button by default', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Go Back'), findsNothing);
      });

      testWidgets('should show back button when showBackButton is true', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          showBackButton: true,
          onBack: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Go Back'), findsOneWidget);
      });

      testWidgets('should call onBack when back button is tapped', (tester) async {
        bool backTapped = false;

        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          showBackButton: true,
          onBack: () => backTapped = true,
        );

        await tester.pumpWidget(testWidget);

        await tester.tap(find.text('Go Back'));
        await tester.pump();

        expect(backTapped, true);
      });
    });

    group('Layout Tests', () {
      testWidgets('should have proper widget structure', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          onRetry: () {},
          showBackButton: true,
          onBack: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Padding), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Icon), findsAtLeastNWidgets(1)); // Error icon plus button icons
        expect(find.byType(Text), findsAtLeastNWidgets(2)); // Title and message
      });

      testWidgets('should display both retry and back buttons when both are enabled', (tester) async {
        testWidget = createTestWidget(
          title: 'Test Error',
          message: 'This is a test error message',
          onRetry: () {},
          showBackButton: true,
          onBack: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Go Back'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Go Back'), findsOneWidget);
      });
    });

    group('Error State Scenarios', () {
      testWidgets('should handle network error state', (tester) async {
        testWidget = createTestWidget(
          title: 'Network Error 🌐',
          message: 'Unable to connect to the server. Please check your internet connection.',
          icon: Icons.wifi_off,
          onRetry: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Network Error 🌐'), findsOneWidget);
        expect(find.text('Unable to connect to the server. Please check your internet connection.'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should handle server error state', (tester) async {
        testWidget = createTestWidget(
          title: 'Server Error ⚠️',
          message: 'The server is currently unavailable. Please try again later.',
          icon: Icons.warning_amber_outlined,
          onRetry: () {},
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Server Error ⚠️'), findsOneWidget);
        expect(find.text('The server is currently unavailable. Please try again later.'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });

      testWidgets('should handle validation error state', (tester) async {
        testWidget = createTestWidget(
          title: 'Invalid Input ❌',
          message: 'Please enter a valid IP address.',
          icon: Icons.error,
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('Invalid Input ❌'), findsOneWidget);
        expect(find.text('Please enter a valid IP address.'), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);
        expect(find.text('Retry'), findsNothing); // No retry for validation errors
      });
    });
  });
}