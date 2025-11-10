import 'package:flutter/material.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/utils/app_constants.dart';

/// Base class for offline error widgets
/// Following Single Responsibility Principle - only handles basic offline error display
class BaseOfflineErrorWidget extends StatelessWidget {
  const BaseOfflineErrorWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onRetry,
    this.retryButtonText,
    this.showRetryButton = true,
    this.icon = Icons.wifi_off,
  });

  /// The main title text (e.g., "No internet connection")
  final String title;

  /// The subtitle/description text
  final String subtitle;

  /// Callback function when retry button is pressed
  final VoidCallback? onRetry;

  /// Text for the retry button (if null, uses localized 'Go Back')
  final String? retryButtonText;

  /// Whether to show the retry button
  final bool showRetryButton;

  /// Icon to display
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppConstants.largeIconSize, color: Colors.grey),
          const SizedBox(height: AppConstants.mediumVerticalSpacing),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppConstants.smallVerticalSpacing),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          if (showRetryButton) ...[
            const SizedBox(height: AppConstants.mediumVerticalSpacing),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                retryButtonText ?? AppLocalizations.of(context)!.goBack,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
