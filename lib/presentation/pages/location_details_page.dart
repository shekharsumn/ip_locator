import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/domain/entities/ip_location_data.dart';
import 'package:ip_locator/l10n/app_localizations.dart';
import 'package:ip_locator/presentation/pages/location_info_page.dart';
import 'package:ip_locator/presentation/pages/location_map_page.dart';

class LocationDetailsPage extends ConsumerWidget {
  const LocationDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the location data passed from navigation arguments
    final locationData = ModalRoute.of(context)?.settings.arguments as IpLocationData?;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.yourLocation),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(AppLocalizations.of(context)!.moreInfo)],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          LocationMapPage(locationData: locationData),
          LocationInfoPage(locationData: locationData)
        ]),
      ),
    );
  }
}
