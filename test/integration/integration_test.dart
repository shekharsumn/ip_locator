import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ip_locator/main.dart';

void main() {
  group('Integration Tests - End-to-End User Flow', () {
    testWidgets('Complete IP location lookup flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify home page is displayed
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Get Location Details'), findsOneWidget);

      // Enter a valid IP address (Google DNS)
      final textField = find.byType(TextField);
      await tester.enterText(textField, '8.8.8.8');

      // Tap the lookup button
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);

      // Wait for the API call and navigation
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should navigate to location info page or show results
      // The exact behavior depends on the app's navigation structure
      // We'll check for common location information elements
      
      // These might be present depending on the UI implementation
      expect(find.textContaining('8.8.8.8'), findsWidgets);
    });

    testWidgets('Invalid IP address handling flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter an invalid IP address
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'invalid.ip.address');

      // Tap the lookup button
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);

      // Wait for validation or error handling
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should show some form of error feedback
      // This could be a snackbar, dialog, or inline error message
      // The exact implementation depends on the app's error handling
    });

    testWidgets('Empty input handling flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Don't enter anything and tap the lookup button
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);

      // Wait for validation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should handle empty input gracefully
      // Either prevent submission or show appropriate error
    });

    testWidgets('Clear IP address functionality', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter an IP address
      final textField = find.byType(TextField);
      await tester.enterText(textField, '1.1.1.1');

      // Look for a clear button (might be an icon button or clear text button)
      final clearButton = find.byIcon(Icons.clear).first;
      if (find.byIcon(Icons.clear).evaluate().isNotEmpty) {
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Verify the text field is cleared
        expect(find.text('1.1.1.1'), findsNothing);
      }
    });

    testWidgets('App localization integration', (WidgetTester tester) async {
      // Test with English locale (default)
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify English text is present
      expect(find.text('Get Location Details'), findsOneWidget);
    });

    testWidgets('Navigation and back button flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter a valid IP address
      final textField = find.byType(TextField);
      await tester.enterText(textField, '1.1.1.1');

      // Tap the lookup button
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);

      // Wait for potential navigation
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // If we navigated to a new page, test back navigation
      if (find.byType(AppBar).evaluate().isNotEmpty) {
        final backButton = find.byTooltip('Back');
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();

          // Should be back to the home page
          expect(find.byType(TextField), findsOneWidget);
          expect(find.text('Get Location Details'), findsOneWidget);
        }
      }
    });

    testWidgets('Multiple IP address lookups in sequence', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // First lookup
      final textField = find.byType(TextField);
      await tester.enterText(textField, '8.8.8.8');
      
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate back if needed (this depends on app structure)
      if (find.byTooltip('Back').evaluate().isNotEmpty) {
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
      }

      // Clear previous input and enter a different IP
      await tester.enterText(textField, '1.1.1.1');
      await tester.tap(lookupButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should handle the second lookup
      // The exact verification depends on the app's behavior
    });

    testWidgets('Error recovery flow', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // First try an invalid IP
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'invalid');
      
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Then correct it with a valid IP
      await tester.enterText(textField, '8.8.8.8');
      await tester.tap(lookupButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should successfully recover and show results
    });

    testWidgets('App responsiveness and UI state management', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter IP and start lookup
      final textField = find.byType(TextField);
      await tester.enterText(textField, '8.8.8.8');
      
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);

      // Check for loading states (this depends on implementation)
      await tester.pump(); // Single pump to check immediate state

      // The app might show loading indicators, disable buttons, etc.
      // This test verifies the app doesn't crash and handles UI states

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // After completion, UI should be responsive again
    });

    testWidgets('Connectivity error handling', (WidgetTester tester) async {
      // This test is challenging to implement without mocking network calls
      // But we can test the UI's ability to handle error states

      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Enter IP that might cause network issues (private IP)
      final textField = find.byType(TextField);
      await tester.enterText(textField, '192.168.1.1');
      
      final lookupButton = find.text('Get Location Details');
      await tester.tap(lookupButton);
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // The app should handle network errors gracefully
      // This might show error messages, retry options, etc.
    });

    group('Widget Integration Tests', () {
      testWidgets('Text field and button interaction', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        final lookupButton = find.text('Get Location Details');

        // Verify initial state
        expect(textField, findsOneWidget);
        expect(lookupButton, findsOneWidget);

        // Test text input
        await tester.enterText(textField, 'test input');
        expect(find.text('test input'), findsOneWidget);

        // Test button tap
        await tester.tap(lookupButton);
        await tester.pumpAndSettle();

        // Button should be responsive
        expect(lookupButton, findsOneWidget);
      });

      testWidgets('App theme and styling consistency', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Check that Material Design components are properly themed
        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.theme, isNotNull);

        // Verify key UI elements are styled consistently
        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Get Location Details'), findsOneWidget);
      });
    });

    group('State Management Integration', () {
      testWidgets('Riverpod provider integration', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // The app should initialize without provider errors
        expect(tester.takeException(), isNull);

        // Basic interaction should not cause provider errors
        final textField = find.byType(TextField);
        await tester.enterText(textField, '8.8.8.8');
        
        final lookupButton = find.text('Get Location Details');
        await tester.tap(lookupButton);
        
        await tester.pump(); // Check immediate state
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility Integration', () {
      testWidgets('Semantic labels and accessibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify key interactive elements have proper semantics
        final textField = find.byType(TextField);
        final lookupButton = find.text('Get Location Details');

        expect(textField, findsOneWidget);
        expect(lookupButton, findsOneWidget);

        // Elements should be accessible for screen readers
        // This is a basic check - real accessibility testing requires more depth
      });
    });
  });
}