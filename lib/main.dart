import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ip_locator/presentation/pages/home_page.dart';
import 'package:ip_locator/presentation/pages/location_details_page.dart';
import 'package:ip_locator/presentation/pages/location_map_page.dart';
import 'presentation/pages/location_info_page.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IP Locator',
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: 'home/',
      routes: {
        'home/': (context) => const HomePage(),
        'location_details/': (context) => const LocationDetailsPage(),
        'location_info/': (context) => const LocationInfoPage(),
        'location_map/': (context) => const LocationMapPage(),
      },
    );
  }
}
