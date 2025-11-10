import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'IP Info Locator'**
  String get appTitle;

  /// Button text for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Button text for going back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Error message when offline
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Detailed message when offline
  ///
  /// In en, this message translates to:
  /// **'Unable to load. Please check your internet connection and try again.'**
  String get noInternetConnectionDescription;

  /// Message prompting user to connect to internet
  ///
  /// In en, this message translates to:
  /// **'Connect to internet to load new posts'**
  String get connectToInternetToLoadNewPosts;

  /// HTTP 400 error message
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get badRequest;

  /// HTTP 401 error message
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// HTTP 404 error message
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// HTTP 500+ error message
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// Network connectivity error
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// Connection timeout error
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// Request cancelled error
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get requestCancelled;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Message shown when no data is available from the server
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Tooltip text for refresh location button
  ///
  /// In en, this message translates to:
  /// **'Refresh Location'**
  String get refreshLocation;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// API specific error title
  ///
  /// In en, this message translates to:
  /// **'API Error'**
  String get apiError;

  /// Loading message while fetching IP location
  ///
  /// In en, this message translates to:
  /// **'Fetching your IP location...'**
  String get fetchingIpLocation;

  /// Title for location information section
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// Title for network information section
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInformation;

  /// Title for geographic details section
  ///
  /// In en, this message translates to:
  /// **'Geographic Details'**
  String get geographicDetails;

  /// Message shown when internet connection is needed
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get pleaseCheckInternetConnection;

  /// Label for IP address field
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// Label for city field
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Label for region field
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// Label for country field
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for timezone field
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get timezone;

  /// Label for network field
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Label for version field
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for ASN field
  ///
  /// In en, this message translates to:
  /// **'ASN'**
  String get asn;

  /// Label for organization field
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// Label for coordinates field
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// Label for postal code field
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// Label for continent field
  ///
  /// In en, this message translates to:
  /// **'Continent'**
  String get continent;

  /// Label for EU membership field
  ///
  /// In en, this message translates to:
  /// **'In EU'**
  String get inEu;

  /// Label for currency field
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Label for currency name field
  ///
  /// In en, this message translates to:
  /// **'Currency Name'**
  String get currencyName;

  /// Label for languages field
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Label for country code field
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get countryCode;

  /// Label for country ISO3 field
  ///
  /// In en, this message translates to:
  /// **'Country ISO3'**
  String get countryIso3;

  /// Label for country capital field
  ///
  /// In en, this message translates to:
  /// **'Country Capital'**
  String get countryCapital;

  /// Label for country TLD field
  ///
  /// In en, this message translates to:
  /// **'Country TLD'**
  String get countryTld;

  /// Label for calling code field
  ///
  /// In en, this message translates to:
  /// **'Calling Code'**
  String get callingCode;

  /// Label for UTC offset field
  ///
  /// In en, this message translates to:
  /// **'UTC Offset'**
  String get utcOffset;

  /// Label for country area field
  ///
  /// In en, this message translates to:
  /// **'Country Area'**
  String get countryArea;

  /// Label for population field
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// Label for combined location field
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Label for ISP field
  ///
  /// In en, this message translates to:
  /// **'ISP'**
  String get isp;

  /// Text displayed when data is not available
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Affirmative boolean value
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative boolean value
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Unit abbreviation for square kilometers
  ///
  /// In en, this message translates to:
  /// **'sq km'**
  String get squareKilometers;

  /// Label for capital city
  ///
  /// In en, this message translates to:
  /// **'Capital'**
  String get capital;

  /// Default error message when no specific error is available
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// user location in map view
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// More info on user IP location
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get moreInfo;

  /// Button text to get current IP location
  ///
  /// In en, this message translates to:
  /// **'Get My Current IP Location'**
  String get getCurrentIpLocation;

  /// Loading text when getting current IP
  ///
  /// In en, this message translates to:
  /// **'Getting Current IP...'**
  String get gettingCurrentIp;

  /// Title for IP address input section
  ///
  /// In en, this message translates to:
  /// **'Enter IP Address'**
  String get enterIpAddress;

  /// Description for IP address input section
  ///
  /// In en, this message translates to:
  /// **'Enter an IPv4 or IPv6 address to get location details'**
  String get enterIpAddressDescription;

  /// Divider text between two options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
