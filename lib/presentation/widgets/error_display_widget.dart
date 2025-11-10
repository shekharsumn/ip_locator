import 'package:flutter/material.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/utils/app_constants.dart';

/// A reusable widget for displaying error states consistently across the app
/// Eliminates duplicate error UI patterns and ensures consistent error presentation
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText,
    this.showBackButton = false,
    this.onBack,
  });

  /// The main error title
  final String title;

  /// The detailed error message
  final String message;

  /// The icon to display (defaults to error_outline)
  final IconData icon;

  /// Optional retry callback
  final VoidCallback? onRetry;

  /// Text for the retry button
  final String? retryButtonText;

  /// Whether to show a back button
  final bool showBackButton;

  /// Optional back callback
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppConstants.largeIconSize, color: Colors.grey),
            const SizedBox(height: AppConstants.mediumVerticalSpacing),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallVerticalSpacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            if (onRetry != null || showBackButton) ...[
              const SizedBox(height: AppConstants.standardVerticalSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBackButton) ...[
                    ElevatedButton.icon(
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(AppLocalizations.of(context)!.goBack),
                    ),
                    if (onRetry != null)
                      const SizedBox(width: AppConstants.mediumVerticalSpacing),
                  ],
                  if (onRetry != null)
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        retryButtonText ?? AppLocalizations.of(context)!.retry,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
