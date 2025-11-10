import 'package:flutter/material.dart';

/// Application-wide constants for UI styling and configuration
///
/// This file contains all the constant values used throughout the app
/// to maintain consistency and make future changes easier.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  static const String apiBaseUrl = 'https://ipapi.co/';

  // Info Card Styling
  /// Elevation for info cards
  static const double infoCardElevation = 4.0;

  /// Padding inside info cards
  static const EdgeInsets infoCardPadding = EdgeInsets.all(16);

  /// Spacing between icon and title in info cards
  static const double iconTitleSpacing = 8.0;

  /// Width for info row labels
  static const double infoRowLabelWidth = 120.0;

  /// Vertical spacing for info rows
  static const double infoRowVerticalSpacing = 4.0;

  // Comment Card Styling
  /// Elevation for comment cards
  static const double commentCardElevation = 2.0;

  /// Radius for user avatar in comment cards
  static const double avatarRadius = 20.0;

  /// Padding inside comment cards
  static const EdgeInsets commentCardPadding = EdgeInsets.all(16);

  /// Margin between comment cards
  static const EdgeInsets commentCardMargin = EdgeInsets.only(bottom: 12);

  /// Border radius for comment cards
  static const double commentCardBorderRadius = 8.0;

  // Spacing Constants
  /// Smallest vertical spacing for tight layouts
  static const double tinyVerticalSpacing = 10.0;

  /// Standard spacing between avatar and text in comment cards
  static const double avatarTextSpacing = 12.0;

  /// Spacing between author info and comment body
  static const double authorBodySpacing = 12.0;

  /// Standard vertical spacing for buttons and sections
  static const double standardVerticalSpacing = 20.0;

  /// Small vertical spacing
  static const double smallVerticalSpacing = 8.0;

  /// Medium vertical spacing
  static const double mediumVerticalSpacing = 16.0;

  // Typography Constants
  /// Line height for comment body text
  static const double commentBodyLineHeight = 1.4;

  // Note: Font sizes should use Theme.of(context).textTheme instead of hardcoded values
  // Examples:
  // - bodyLarge for main content (was fontSize: 16)
  // - bodyMedium for secondary content (was fontSize: 15)
  // - bodySmall for labels/captions (was fontSize: 14)

  // Button Styling
  /// Vertical padding for elevated buttons
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(vertical: 12);

  // List Styling
  /// Padding for ListView containers
  static const EdgeInsets listPadding = EdgeInsets.all(16);

  // Error and Empty State Icons
  /// Size for large icons in error/empty states
  static const double largeIconSize = 64.0;

  // General UI
  /// Standard page padding
  static const EdgeInsets pagePadding = EdgeInsets.all(15);

  // App Theme Colors
  /// Primary app bar background color
  static const Color appBarBackgroundColor = Colors.blue;

  /// App bar foreground/text color
  static const Color appBarForegroundColor = Colors.white;
}
