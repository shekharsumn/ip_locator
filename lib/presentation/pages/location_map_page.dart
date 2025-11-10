import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/presentation/viewmodels/location_info_vm.dart';
import 'package:ip_locator/presentation/widgets/error_display_widget.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMapPage extends ConsumerWidget {
  final IpLocationData? locationData;
  
  const LocationMapPage({super.key, this.locationData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    
    // If we have manual location data, use it directly
    if (locationData != null) {
      return SafeArea(
        child: _buildMapWidget(locationData!),
      );
    }
    
    // Otherwise, use the provider for current IP location
    final viewModelAsync = ref.watch(locationInfoViewModelProvider);

    return SafeArea(
      child: viewModelAsync.when(
        data: (viewModel) {
          final locationData = viewModel.locationData;
          if (locationData == null) {
            return Center(
              child: ErrorDisplayWidget(
                title: localizations.error,
                message:
                    viewModel.error?.toString() ?? 'No location data available',
                onRetry: () => ref.invalidate(locationInfoViewModelProvider),
              ),
            );
          }

          return _buildMapWidget(locationData);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: ErrorDisplayWidget(
            title: localizations.error,
            message: error.toString(),
            onRetry: () => ref.invalidate(locationInfoViewModelProvider),
          ),
        ),
      ),
    );
  }

  /// Builds the Flutter map widget with the given location data
  Widget _buildMapWidget(IpLocationData locationData) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          locationData.latitude,
          locationData.longitude,
        ),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.ip_locator',
        ),
        RichAttributionWidget(
          // Include a stylish prebuilt attribution widget that meets all requirments
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(
                Uri.parse('https://openstreetmap.org/copyright'),
              ), // (external)
            ),
            // Also add images...
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                locationData.latitude,
                locationData.longitude,
              ),
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
