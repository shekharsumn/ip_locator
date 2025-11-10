import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/presentation/providers/connectivity_notifier.dart';
import 'package:ip_locator/presentation/viewmodels/location_info_vm.dart';
import 'package:ip_locator/presentation/widgets/base_offline_error_widget.dart';
import 'package:ip_locator/presentation/widgets/error_display_widget.dart';
import 'package:ip_locator/presentation/widgets/info_card_widget.dart';
import 'package:ip_locator/utils/localized_formatting_utils.dart';
import 'package:ip_locator/utils/localized_ip_location_data_utils.dart';

class LocationInfoPage extends ConsumerWidget {
  final IpLocationData? locationData;
  
  const LocationInfoPage({super.key, this.locationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isConnected = ref.watch(isConnectedProvider);
    
    // If we have manual location data, display it directly
    if (locationData != null) {
      return SafeArea(
        child: _buildLocationDisplay(
          context,
          LocationinfoViewModel.fromLocationData(locationData!),
        ),
      );
    }
    
    // Otherwise, use the provider for current IP location
    final viewModelAsync = ref.watch(locationInfoViewModelProvider);

    return SafeArea(
      child: isConnected
          ? _buildBody(context, viewModelAsync, localizations)
          : _buildOfflineBody(context, ref, localizations),
    );
  }

  /// Helper method to create consistent error display widgets
  ///
  /// Eliminates code duplication for error handling across different error states
  Widget _buildErrorWidget({
    required BuildContext context,
    required WidgetRef ref,
    required AppLocalizations localizations,
    required String title,
    required String message,
  }) {
    return Center(
      child: ErrorDisplayWidget(
        title: title,
        message: message,
        onRetry: () => ref.refresh(locationInfoViewModelProvider),
      ),
    );
  }

  /// Builds the main body content when online
  ///
  /// Handles different async states: loading, error, and success with data display
  Widget _buildBody(
    BuildContext context,
    AsyncValue<LocationinfoViewModel> viewModelAsync,
    AppLocalizations localizations,
  ) {
    final formattingUtils = LocalizedFormattingUtils.of(context);
    return viewModelAsync.when(
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.fetchingIpLocation),
          ],
        ),
      ),
      error: (error, stack) => Consumer(
        builder: (context, ref, child) => _buildErrorWidget(
          context: context,
          ref: ref,
          localizations: localizations,
          title: localizations.error,
          message: formattingUtils.formatErrorMessage(error),
        ),
      ),
      data: (viewModel) {
        if (viewModel.hasError) {
          return Consumer(
            builder: (context, ref, child) => _buildErrorWidget(
              context: context,
              ref: ref,
              localizations: localizations,
              title: localizations.apiError,
              message:
                  viewModel.error?.message ?? localizations.somethingWentWrong,
            ),
          );
        }

        if (viewModel.locationData != null) {
          return _buildLocationDisplay(context, viewModel);
        }

        return Center(child: Text(localizations.noDataAvailable));
      },
    );
  }

  /// Builds the offline state UI when no internet connection is available
  ///
  /// Provides a user-friendly message and retry functionality to check connectivity
  Widget _buildOfflineBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    return BaseOfflineErrorWidget(
      title: localizations.noInternetConnection,
      subtitle: localizations.noInternetConnectionDescription,
      onRetry: () {
        // Trigger connectivity check by refreshing the provider
        ref.invalidate(connectivityServiceProvider);
        // Also refresh the home page view model to retry data loading
        ref.read(locationInfoViewModelProvider.future);
      },
      retryButtonText: localizations.retry,
    );
  }

  /// Builds the main content display showing IP location information
  ///
  /// Creates organized cards for location, network, and geographic information
  /// using localized data formatting utilities
  Widget _buildLocationDisplay(
    BuildContext context,
    LocationinfoViewModel viewModel,
  ) {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoCardWidget(
            title: localizations.locationInformation,
            icon: Icons.location_on,
            iconColor: Colors.blue,
            items: LocalizedIpLocationDataUtils.getLocationInfo(
              viewModel.locationData,
              context,
            ),
          ),
          const SizedBox(height: 16),
          InfoCardWidget(
            title: localizations.networkInformation,
            icon: Icons.public,
            iconColor: Colors.green,
            items: LocalizedIpLocationDataUtils.getNetworkInfo(
              viewModel.locationData,
              context,
            ),
          ),
          const SizedBox(height: 16),
          InfoCardWidget(
            title: localizations.geographicDetails,
            icon: Icons.map,
            iconColor: Colors.orange,
            items: LocalizedIpLocationDataUtils.getGeographicInfo(
              viewModel.locationData,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
