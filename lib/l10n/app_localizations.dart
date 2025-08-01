import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ha.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_vi.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ha'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('sw'),
    Locale('vi')
  ];

  /// Help screen title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help_title;

  /// Application title shown in help screen
  ///
  /// In en, this message translates to:
  /// **'Open Buildings Explorer'**
  String get help_app_title;

  /// Application description in help screen
  ///
  /// In en, this message translates to:
  /// **'Explore building footprints across the globe with Liquid Galaxy integration'**
  String get help_app_description;

  /// Title for help step 1
  ///
  /// In en, this message translates to:
  /// **'Select Map Area'**
  String get help_step1_title;

  /// Description for help step 1
  ///
  /// In en, this message translates to:
  /// **'Use the controls on the right side of the map to modify and select the area of tiles you want to explore.'**
  String get help_step1_description;

  /// Title for help step 2
  ///
  /// In en, this message translates to:
  /// **'Choose a Tile'**
  String get help_step2_title;

  /// Description for help step 2
  ///
  /// In en, this message translates to:
  /// **'Click on a specific tile within your selected area to fetch building data from the Open Buildings dataset.'**
  String get help_step2_description;

  /// Title for help step 3
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get help_step3_title;

  /// Description for help step 3
  ///
  /// In en, this message translates to:
  /// **'Once data is fetched, a bottom sheet will appear showing the results. You can send all data to Liquid Galaxy for visualization.'**
  String get help_step3_description;

  /// Title for help step 4
  ///
  /// In en, this message translates to:
  /// **'Explore Buildings'**
  String get help_step4_title;

  /// Description for help step 4
  ///
  /// In en, this message translates to:
  /// **'Switch to the Buildings tab to see individual building details, including plus codes and confidence scores.'**
  String get help_step4_description;

  /// Title for confidence scores info section
  ///
  /// In en, this message translates to:
  /// **'About Confidence Scores'**
  String get help_confidence_title;

  /// Description explaining confidence scores
  ///
  /// In en, this message translates to:
  /// **'Each building shows a confidence score that indicates how reliable the data from the Open Buildings dataset is for that particular structure.'**
  String get help_confidence_description;

  /// Title for Liquid Galaxy integration onboarding page
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy Integration'**
  String get onboarding_lg_integration_title;

  /// Description for Liquid Galaxy integration onboarding page
  ///
  /// In en, this message translates to:
  /// **'Send building data to Liquid Galaxy for immersive visualization experience'**
  String get onboarding_lg_integration_description;

  /// Title for main app explorer onboarding page
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy Open Buildings Explorer'**
  String get onboarding_explorer_title;

  /// Description for main app explorer onboarding page
  ///
  /// In en, this message translates to:
  /// **'Explore building footprints across the globe with interactive visualization'**
  String get onboarding_explorer_description;

  /// Title for interactive map onboarding page
  ///
  /// In en, this message translates to:
  /// **'Interactive Map'**
  String get onboarding_interactive_map_title;

  /// Description for interactive map onboarding page
  ///
  /// In en, this message translates to:
  /// **'Select regions to visualize building density and footprints in real-time'**
  String get onboarding_interactive_map_description;

  /// Button text to complete onboarding
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;

  /// Button text to go to next onboarding page
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// Map screen title
  ///
  /// In en, this message translates to:
  /// **'Open Buildings'**
  String get map_title;

  /// Tooltip for clear selection button
  ///
  /// In en, this message translates to:
  /// **'Clear building selection'**
  String get map_clear_selection_tooltip;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search for a location'**
  String get map_search_hint;

  /// Search progress indicator text
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get map_searching;

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get map_search_no_results;

  /// Error message when search fails
  ///
  /// In en, this message translates to:
  /// **'Search failed. Please try again.'**
  String get map_search_failed;

  /// Label for overlay size control
  ///
  /// In en, this message translates to:
  /// **'Overlay Size'**
  String get map_overlay_size_label;

  /// Loading message when fetching building data
  ///
  /// In en, this message translates to:
  /// **'Loading buildings...'**
  String get map_loading_buildings;

  /// Title for building details dialog
  ///
  /// In en, this message translates to:
  /// **'Building Details'**
  String get map_building_details_title;

  /// Label for building area information
  ///
  /// In en, this message translates to:
  /// **'Area:'**
  String get map_building_area_label;

  /// Label for building confidence score
  ///
  /// In en, this message translates to:
  /// **'Confidence:'**
  String get map_building_confidence_label;

  /// Label for building polygon points count
  ///
  /// In en, this message translates to:
  /// **'Points:'**
  String get map_building_points_label;

  /// Label for building center coordinates
  ///
  /// In en, this message translates to:
  /// **'Center:'**
  String get map_building_center_label;

  /// Close button for building details dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get map_building_close;

  /// Button to send building to Liquid Galaxy
  ///
  /// In en, this message translates to:
  /// **'Send to LG'**
  String get map_building_send_to_lg;

  /// Connection status when LG is connected
  ///
  /// In en, this message translates to:
  /// **'LG Connected'**
  String get map_lg_connected;

  /// Connection status when LG is disconnected
  ///
  /// In en, this message translates to:
  /// **'LG Disconnected'**
  String get map_lg_disconnected;

  /// Progress message when sending building to LG
  ///
  /// In en, this message translates to:
  /// **'Sending to Liquid Galaxy...'**
  String get map_sending_building_to_lg;

  /// Progress message when sending region to LG
  ///
  /// In en, this message translates to:
  /// **'Sending region to Liquid Galaxy...'**
  String get map_sending_region_to_lg;

  /// Success message when building is sent to LG
  ///
  /// In en, this message translates to:
  /// **'Building sent to Liquid Galaxy successfully!'**
  String get map_building_sent_success;

  /// Success message when region is sent to LG
  ///
  /// In en, this message translates to:
  /// **'Region with {count} buildings sent to Liquid Galaxy!'**
  String map_region_sent_success(int count);

  /// Error message when building send fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send building to LG: {error}'**
  String map_building_send_failed(String error);

  /// Error message when region send fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send region to LG: {error}'**
  String map_region_send_failed(String error);

  /// Error message when building loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load buildings: {error}'**
  String map_buildings_load_failed(String error);

  /// Message when LG connection is required
  ///
  /// In en, this message translates to:
  /// **'Please connect to Liquid Galaxy first'**
  String get map_connect_lg_first;

  /// Action button to connect to LG
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get map_connect_action;

  /// Message when zoom out limit is reached
  ///
  /// In en, this message translates to:
  /// **'Maximum zoom out reached ({zoom}x)'**
  String map_zoom_out_limit(String zoom);

  /// Message when zoom in limit is reached
  ///
  /// In en, this message translates to:
  /// **'Maximum zoom in reached ({zoom}x)'**
  String map_zoom_in_limit(String zoom);

  /// Title for selected building banner
  ///
  /// In en, this message translates to:
  /// **'Selected Building'**
  String get map_selected_building_title;

  /// Information shown for selected building
  ///
  /// In en, this message translates to:
  /// **'Area: {area} m² • Confidence: {confidence}%'**
  String map_selected_building_info(String area, String confidence);

  /// Message when loading historical data
  ///
  /// In en, this message translates to:
  /// **'Loading historical data...'**
  String get map_loading_historical_data;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// Liquid Galaxy configuration settings menu item
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy Configuration'**
  String get settings_lg_configuration;

  /// Visualization settings menu item
  ///
  /// In en, this message translates to:
  /// **'Visualization Settings'**
  String get settings_visualization;

  /// Data settings menu item
  ///
  /// In en, this message translates to:
  /// **'Data Settings'**
  String get settings_data;

  /// About settings menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// Liquid Galaxy configuration screen title
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy Configuration'**
  String get lg_config_title;

  /// Connection tab label
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get lg_config_connection_tab;

  /// Liquid Galaxy tab label
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy'**
  String get lg_config_lg_tab;

  /// Scan QR code button text
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get lg_config_scan_qr;

  /// Manual entry section header
  ///
  /// In en, this message translates to:
  /// **'Or enter manually:'**
  String get lg_config_manual_entry;

  /// IP address field label
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get lg_config_ip_address;

  /// Port field label
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get lg_config_port;

  /// Rigs field label
  ///
  /// In en, this message translates to:
  /// **'Rigs'**
  String get lg_config_rigs;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get lg_config_username;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lg_config_password;

  /// Connecting button state text
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get lg_config_connecting;

  /// Connect button text
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get lg_config_connect;

  /// Connection status label
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get lg_config_connection_status;

  /// Message shown when not connected to LG
  ///
  /// In en, this message translates to:
  /// **'Connect to Liquid Galaxy first to enable these actions.'**
  String get lg_config_connect_first_message;

  /// Set slaves refresh action button
  ///
  /// In en, this message translates to:
  /// **'SET SLAVES REFRESH'**
  String get lg_action_set_slaves_refresh;

  /// Reset slaves refresh action button
  ///
  /// In en, this message translates to:
  /// **'RESET SLAVES REFRESH'**
  String get lg_action_reset_slaves_refresh;

  /// Clear KML and logos action button
  ///
  /// In en, this message translates to:
  /// **'CLEAR KML + LOGOS'**
  String get lg_action_clear_kml_logos;

  /// Relaunch LG action button
  ///
  /// In en, this message translates to:
  /// **'RELAUNCH'**
  String get lg_action_relaunch;

  /// Reboot LG action button
  ///
  /// In en, this message translates to:
  /// **'REBOOT'**
  String get lg_action_reboot;

  /// Power off LG action button
  ///
  /// In en, this message translates to:
  /// **'POWER OFF'**
  String get lg_action_power_off;

  /// Connected status text
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get lg_status_connected;

  /// Connecting status text
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get lg_status_connecting;

  /// Error status text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get lg_status_error;

  /// Disconnected status text
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get lg_status_disconnected;

  /// Confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get lg_confirm_title;

  /// Cancel button in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get lg_confirm_cancel;

  /// Yes button in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get lg_confirm_yes;

  /// Confirmation message for set slaves refresh
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to set slaves refresh?'**
  String get lg_confirm_set_slaves_refresh;

  /// Confirmation message for reset slaves refresh
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset slaves refresh?'**
  String get lg_confirm_reset_slaves_refresh;

  /// Confirmation message for clear KML and logos
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear KML and logos?'**
  String get lg_confirm_clear_kml_logos;

  /// Confirmation message for relaunch LG
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to relaunch LG?'**
  String get lg_confirm_relaunch;

  /// Confirmation message for reboot LG
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot LG?'**
  String get lg_confirm_reboot;

  /// Confirmation message for power off LG
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to power off LG?'**
  String get lg_confirm_power_off;

  /// Progress message for setting slaves refresh
  ///
  /// In en, this message translates to:
  /// **'Setting slaves refresh...'**
  String get lg_action_setting_slaves_refresh;

  /// Progress message for resetting slaves refresh
  ///
  /// In en, this message translates to:
  /// **'Resetting slaves refresh...'**
  String get lg_action_resetting_slaves_refresh;

  /// Progress message for clearing KML and logos
  ///
  /// In en, this message translates to:
  /// **'Clearing KML and logos...'**
  String get lg_action_clearing_kml_logos;

  /// Progress message for relaunching LG
  ///
  /// In en, this message translates to:
  /// **'Relaunching LG...'**
  String get lg_action_relaunching;

  /// Progress message for rebooting LG
  ///
  /// In en, this message translates to:
  /// **'Rebooting LG...'**
  String get lg_action_rebooting;

  /// Progress message for powering off LG
  ///
  /// In en, this message translates to:
  /// **'Powering off LG...'**
  String get lg_action_powering_off;

  /// Success message for completed actions
  ///
  /// In en, this message translates to:
  /// **'Action completed successfully!'**
  String get lg_action_success;

  /// Error message for failed actions
  ///
  /// In en, this message translates to:
  /// **'Action failed: {error}'**
  String lg_action_failed(String error);

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get form_required;

  /// Invalid IP address validation message
  ///
  /// In en, this message translates to:
  /// **'Invalid IP'**
  String get form_invalid_ip;

  /// Invalid number validation message
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get form_invalid_number;

  /// QR scanner screen title
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get qr_scan_title;

  /// Error message for invalid QR data
  ///
  /// In en, this message translates to:
  /// **'Invalid QR JSON data'**
  String get qr_invalid_data;

  /// Title for successful QR scan dialog
  ///
  /// In en, this message translates to:
  /// **'QR Code Scanned Successfully'**
  String get qr_scanned_success_title;

  /// Message showing QR scan results
  ///
  /// In en, this message translates to:
  /// **'The following credentials were found:'**
  String get qr_credentials_found;

  /// Confirmation question for QR scanned credentials
  ///
  /// In en, this message translates to:
  /// **'Do you want to proceed with connecting to Liquid Galaxy using these credentials?'**
  String get qr_proceed_question;

  /// Connect button in QR confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get qr_connect_button;

  /// Success message for LG connection
  ///
  /// In en, this message translates to:
  /// **'Successfully connected to Liquid Galaxy! Logo displayed.'**
  String get lg_connection_success;

  /// Error message for LG connection failure
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String lg_connection_failed(String error);

  /// Visualization settings screen title
  ///
  /// In en, this message translates to:
  /// **'Visualization Settings'**
  String get viz_settings_title;

  /// Label for confidence threshold setting
  ///
  /// In en, this message translates to:
  /// **'Confidence Threshold'**
  String get viz_confidence_threshold;

  /// Information text about confidence threshold
  ///
  /// In en, this message translates to:
  /// **'Set the minimum confidence threshold for visualizing buildings retrieved from the API. Lower thresholds show more buildings, but may include less accurate results.'**
  String get viz_threshold_info;

  /// Data settings screen title
  ///
  /// In en, this message translates to:
  /// **'Data Settings'**
  String get data_settings_title;

  /// Label for data source version
  ///
  /// In en, this message translates to:
  /// **'Data Source Version'**
  String get data_source_version;

  /// Label for visualization mode setting
  ///
  /// In en, this message translates to:
  /// **'Visualization Mode (Hybrid/Dark)'**
  String get data_visualization_mode;

  /// Data version identifier
  ///
  /// In en, this message translates to:
  /// **'V3 (2025)'**
  String get data_version_v3_2025;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// Application title in about screen
  ///
  /// In en, this message translates to:
  /// **'Open Buildings Dataset Tool'**
  String get about_app_title;

  /// Application description in about screen
  ///
  /// In en, this message translates to:
  /// **'Interactive visualization tool for Google\'s Open Buildings dataset\nwith Liquid Galaxy integration'**
  String get about_app_description;

  /// Version label in about screen
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_version;

  /// Application version number
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get about_version_number;

  /// Data source label in about screen
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get about_data_source;

  /// Data source value in about screen
  ///
  /// In en, this message translates to:
  /// **'Google Open Buildings V3'**
  String get about_data_source_value;

  /// Project label in about screen
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get about_project;

  /// Project value in about screen
  ///
  /// In en, this message translates to:
  /// **'GSoC 2025 - Liquid Galaxy'**
  String get about_project_value;

  /// Build date label in about screen
  ///
  /// In en, this message translates to:
  /// **'Build Date'**
  String get about_build_date;

  /// Build date value in about screen
  ///
  /// In en, this message translates to:
  /// **'January 2025'**
  String get about_build_date_value;

  /// Developer label in about screen
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get about_developer;

  /// Developer name in about screen
  ///
  /// In en, this message translates to:
  /// **'Jaivardhan Shukla'**
  String get about_developer_name;

  /// Developer location in about screen
  ///
  /// In en, this message translates to:
  /// **'VNIT Nagpur, India'**
  String get about_developer_location;

  /// GitHub social link label
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get about_github;

  /// LinkedIn social link label
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get about_linkedin;

  /// Email social link label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get about_email;

  /// Project details section title
  ///
  /// In en, this message translates to:
  /// **'About this Project'**
  String get about_project_details;

  /// Detailed project description
  ///
  /// In en, this message translates to:
  /// **'This application integrates Google\'s Open Buildings dataset with interactive mapping capabilities and Liquid Galaxy visualization. Built as part of Google Summer of Code 2025 with the Liquid Galaxy organization.'**
  String get about_project_description;

  /// Key features section title
  ///
  /// In en, this message translates to:
  /// **'Key Features:'**
  String get about_key_features;

  /// First key feature description
  ///
  /// In en, this message translates to:
  /// **'Interactive building footprint visualization'**
  String get about_feature_1;

  /// Second key feature description
  ///
  /// In en, this message translates to:
  /// **'Real-time data from Google Earth Engine'**
  String get about_feature_2;

  /// Third key feature description
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy integration for immersive experience'**
  String get about_feature_3;

  /// Fourth key feature description
  ///
  /// In en, this message translates to:
  /// **'Grid-based mapping with zoom controls'**
  String get about_feature_4;

  /// Fifth key feature description
  ///
  /// In en, this message translates to:
  /// **'Building confidence score visualization'**
  String get about_feature_5;

  /// Button text to view project repository
  ///
  /// In en, this message translates to:
  /// **'View Project Repository'**
  String get about_view_repository;

  /// Button text for Open Buildings dataset link
  ///
  /// In en, this message translates to:
  /// **'Open Buildings Dataset'**
  String get about_open_buildings_dataset;

  /// Button text for Liquid Galaxy link
  ///
  /// In en, this message translates to:
  /// **'Liquid Galaxy'**
  String get about_liquid_galaxy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'es',
        'fr',
        'ha',
        'hi',
        'id',
        'pt',
        'sw',
        'vi'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ha':
      return AppLocalizationsHa();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'sw':
      return AppLocalizationsSw();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
