import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/presentation/viewmodels/home_page_vm.dart';
import 'package:ip_locator/presentation/widgets/ip_input_widget.dart';
import 'package:ip_locator/presentation/widgets/error_display_widget.dart';
import 'package:ip_locator/utils/api_error_extensions.dart';
import 'package:ip_locator/utils/api_error.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageViewModelProvider);
    final viewModel = ref.watch(homePageViewModelProvider.notifier);

    // Listen for location data changes to navigate to details page
    ref.listen(homePageViewModelProvider, (previous, current) {
      if (previous?.locationData == null && current.locationData != null) {
                // Navigate to location details page when data is available
        Navigator.pushNamed(
          context,
          'location_details/',
          arguments: current.locationData,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.enterIpAddress,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.enterIpAddressDescription,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // IP Input Widget
            IpInputWidget(
              onIpChanged: viewModel.updateIpAddress,
              onFetchPressed: viewModel.fetchIpLocationData,
              validationError: state.validationError,
              isLoading: state.isLoading,
              canFetch: state.canFetchData,
              ipAddress: state.ipAddress,
            ),

            const SizedBox(height: 24),

            // Horizontal Divider
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.or,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // Get Current IP Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () {
                        viewModel.fetchCurrentIpLocationData();
                        viewModel.clearIpAddress(); // Clear text field after current IP fetch
                      },
                icon: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  state.isLoading
                      ? AppLocalizations.of(context)!.gettingCurrentIp
                      : AppLocalizations.of(context)!.getCurrentIpLocation,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Connectivity Status
            if (!state.hasConnectivity)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.wifi_off, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No internet connection detected',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Error Display
            if (state.apiError != null)
              ErrorDisplayWidget(
                title: 'Error ${state.apiError!.errorIcon}',
                message: state.apiError!.userFriendlyMessage,
                onRetry: () {
                  if (state.apiError!.type == ApiErrorType.network) {
                    viewModel.retryAfterConnectivityRestore();
                  } else {
                    viewModel.fetchIpLocationData();
                  }
                },
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
