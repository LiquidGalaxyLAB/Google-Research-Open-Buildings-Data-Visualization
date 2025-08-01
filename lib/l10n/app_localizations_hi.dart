// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get help_title => 'सहायता';

  @override
  String get help_app_title => 'ओपन बिल्डिंग्स एक्सप्लोरर';

  @override
  String get help_app_description =>
      'लिक्विड गैलेक्सी एकीकरण के साथ दुनिया भर में इमारतों के नक्शे देखें';

  @override
  String get help_step1_title => 'मानचित्र क्षेत्र चुनें';

  @override
  String get help_step1_description =>
      'मानचित्र के दाईं ओर के नियंत्रणों का उपयोग करके उस टाइल क्षेत्र को संशोधित और चुनें जिसे आप एक्सप्लोर करना चाहते हैं।';

  @override
  String get help_step2_title => 'एक टाइल चुनें';

  @override
  String get help_step2_description =>
      'ओपन बिल्डिंग्स डेटासेट से बिल्डिंग डेटा प्राप्त करने के लिए अपने चयनित क्षेत्र के भीतर एक विशिष्ट टाइल पर क्लिक करें।';

  @override
  String get help_step3_title => 'परिणाम देखें';

  @override
  String get help_step3_description =>
      'डेटा प्राप्त होने के बाद, परिणाम दिखाने वाली एक बॉटम शीट दिखाई देगी। आप विज़ुअलाइज़ेशन के लिए सभी डेटा को लिक्विड गैलेक्सी में भेज सकते हैं।';

  @override
  String get help_step4_title => 'इमारतों का अन्वेषण करें';

  @override
  String get help_step4_description =>
      'प्लस कोड और विश्वास स्कोर सहित व्यक्तिगत इमारत विवरण देखने के लिए बिल्डिंग्स टैब पर स्विच करें।';

  @override
  String get help_confidence_title => 'विश्वास स्कोर के बारे में';

  @override
  String get help_confidence_description =>
      'प्रत्येक इमारत एक विश्वास स्कोर दिखाती है जो इंगित करता है कि उस विशेष संरचना के लिए ओपन बिल्डिंग्स डेटासेट का डेटा कितना विश्वसनीय है।';

  @override
  String get onboarding_lg_integration_title => 'लिक्विड गैलेक्सी एकीकरण';

  @override
  String get onboarding_lg_integration_description =>
      'इमर्सिव विज़ुअलाइज़ेशन अनुभव के लिए बिल्डिंग डेटा को लिक्विड गैलेक्सी में भेजें';

  @override
  String get onboarding_explorer_title =>
      'लिक्विड गैलेक्सी ओपन बिल्डिंग्स एक्सप्लोरर';

  @override
  String get onboarding_explorer_description =>
      'इंटरैक्टिव विज़ुअलाइज़ेशन के साथ दुनिया भर में इमारतों के नक्शे देखें';

  @override
  String get onboarding_interactive_map_title => 'इंटरैक्टिव मानचित्र';

  @override
  String get onboarding_interactive_map_description =>
      'रियल-टाइम में इमारतों की घनत्व और नक्शे देखने के लिए क्षेत्रों का चयन करें';

  @override
  String get onboarding_get_started => 'शुरू करें';

  @override
  String get onboarding_next => 'अगला';

  @override
  String get map_title => 'ओपन बिल्डिंग्स';

  @override
  String get map_clear_selection_tooltip => 'Clear building selection';

  @override
  String get map_search_hint => 'एक स्थान खोजें';

  @override
  String get map_searching => 'खोज रहे हैं...';

  @override
  String get map_search_no_results => 'कोई परिणाम नहीं मिला';

  @override
  String get map_search_failed => 'Search failed. Please try again.';

  @override
  String get map_overlay_size_label => 'Overlay Size';

  @override
  String get map_loading_buildings => 'इमारतें लोड हो रही हैं...';

  @override
  String get map_building_details_title => 'इमारत विवरण';

  @override
  String get map_building_area_label => 'Area:';

  @override
  String get map_building_confidence_label => 'Confidence:';

  @override
  String get map_building_points_label => 'Points:';

  @override
  String get map_building_center_label => 'Center:';

  @override
  String get map_building_close => 'बंद करें';

  @override
  String get map_building_send_to_lg => 'LG को भेजें';

  @override
  String get map_lg_connected => 'LG Connected';

  @override
  String get map_lg_disconnected => 'LG Disconnected';

  @override
  String get map_sending_building_to_lg => 'Sending to Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg => 'Sending region to Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Building sent to Liquid Galaxy successfully!';

  @override
  String map_region_sent_success(int count) {
    return 'Region with $count buildings sent to Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Failed to send building to LG: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Failed to send region to LG: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Failed to load buildings: $error';
  }

  @override
  String get map_connect_lg_first => 'Please connect to Liquid Galaxy first';

  @override
  String get map_connect_action => 'Connect';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Maximum zoom out reached (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Maximum zoom in reached (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Selected Building';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Area: $area m² • Confidence: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Loading historical data...';

  @override
  String get settings_title => 'सेटिंग्स';

  @override
  String get settings_lg_configuration => 'लिक्विड गैलेक्सी कॉन्फ़िगरेशन';

  @override
  String get settings_visualization => 'विज़ुअलाइज़ेशन सेटिंग्स';

  @override
  String get settings_data => 'डेटा सेटिंग्स';

  @override
  String get settings_about => 'के बारे में';

  @override
  String get lg_config_title => 'लिक्विड गैलेक्सी कॉन्फ़िगरेशन';

  @override
  String get lg_config_connection_tab => 'कनेक्शन';

  @override
  String get lg_config_lg_tab => 'लिक्विड गैलेक्सी';

  @override
  String get lg_config_scan_qr => 'QR कोड स्कैन करें';

  @override
  String get lg_config_manual_entry => 'Or enter manually:';

  @override
  String get lg_config_ip_address => 'IP Address';

  @override
  String get lg_config_port => 'Port';

  @override
  String get lg_config_rigs => 'Rigs';

  @override
  String get lg_config_username => 'Username';

  @override
  String get lg_config_password => 'Password';

  @override
  String get lg_config_connecting => 'कनेक्ट हो रहा है...';

  @override
  String get lg_config_connect => 'कनेक्ट करें';

  @override
  String get lg_config_connection_status => 'Connection Status';

  @override
  String get lg_config_connect_first_message =>
      'Connect to Liquid Galaxy first to enable these actions.';

  @override
  String get lg_action_set_slaves_refresh => 'SET SLAVES REFRESH';

  @override
  String get lg_action_reset_slaves_refresh => 'RESET SLAVES REFRESH';

  @override
  String get lg_action_clear_kml_logos => 'CLEAR KML + LOGOS';

  @override
  String get lg_action_relaunch => 'RELAUNCH';

  @override
  String get lg_action_reboot => 'REBOOT';

  @override
  String get lg_action_power_off => 'POWER OFF';

  @override
  String get lg_status_connected => 'कनेक्टेड';

  @override
  String get lg_status_connecting => 'Connecting...';

  @override
  String get lg_status_error => 'Error';

  @override
  String get lg_status_disconnected => 'डिस्कनेक्टेड';

  @override
  String get lg_confirm_title => 'Confirm Action';

  @override
  String get lg_confirm_cancel => 'Cancel';

  @override
  String get lg_confirm_yes => 'Yes';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Are you sure you want to set slaves refresh?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Are you sure you want to reset slaves refresh?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Are you sure you want to clear KML and logos?';

  @override
  String get lg_confirm_relaunch => 'Are you sure you want to relaunch LG?';

  @override
  String get lg_confirm_reboot => 'Are you sure you want to reboot LG?';

  @override
  String get lg_confirm_power_off => 'Are you sure you want to power off LG?';

  @override
  String get lg_action_setting_slaves_refresh => 'Setting slaves refresh...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Resetting slaves refresh...';

  @override
  String get lg_action_clearing_kml_logos => 'Clearing KML and logos...';

  @override
  String get lg_action_relaunching => 'Relaunching LG...';

  @override
  String get lg_action_rebooting => 'Rebooting LG...';

  @override
  String get lg_action_powering_off => 'Powering off LG...';

  @override
  String get lg_action_success => 'Action completed successfully!';

  @override
  String lg_action_failed(String error) {
    return 'Action failed: $error';
  }

  @override
  String get form_required => 'Required';

  @override
  String get form_invalid_ip => 'Invalid IP';

  @override
  String get form_invalid_number => 'Invalid number';

  @override
  String get qr_scan_title => 'Scan QR Code';

  @override
  String get qr_invalid_data => 'Invalid QR JSON data';

  @override
  String get qr_scanned_success_title => 'QR Code Scanned Successfully';

  @override
  String get qr_credentials_found => 'The following credentials were found:';

  @override
  String get qr_proceed_question =>
      'Do you want to proceed with connecting to Liquid Galaxy using these credentials?';

  @override
  String get qr_connect_button => 'Connect';

  @override
  String get lg_connection_success =>
      'Successfully connected to Liquid Galaxy! Logo displayed.';

  @override
  String lg_connection_failed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get viz_settings_title => 'Visualization Settings';

  @override
  String get viz_confidence_threshold => 'Confidence Threshold';

  @override
  String get viz_threshold_info =>
      'Set the minimum confidence threshold for visualizing buildings retrieved from the API. Lower thresholds show more buildings, but may include less accurate results.';

  @override
  String get data_settings_title => 'Data Settings';

  @override
  String get data_source_version => 'Data Source Version';

  @override
  String get data_visualization_mode => 'Visualization Mode (Hybrid/Dark)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'के बारे में';

  @override
  String get about_app_title => 'ओपन बिल्डिंग्स डेटासेट टूल';

  @override
  String get about_app_description =>
      'Interactive visualization tool for Google\'s Open Buildings dataset\nwith Liquid Galaxy integration';

  @override
  String get about_version => 'Version';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Data Source';

  @override
  String get about_data_source_value => 'Google Open Buildings V3';

  @override
  String get about_project => 'Project';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Build Date';

  @override
  String get about_build_date_value => 'January 2025';

  @override
  String get about_developer => 'Developer';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, India';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Email';

  @override
  String get about_project_details => 'About this Project';

  @override
  String get about_project_description =>
      'This application integrates Google\'s Open Buildings dataset with interactive mapping capabilities and Liquid Galaxy visualization. Built as part of Google Summer of Code 2025 with the Liquid Galaxy organization.';

  @override
  String get about_key_features => 'Key Features:';

  @override
  String get about_feature_1 => 'Interactive building footprint visualization';

  @override
  String get about_feature_2 => 'Real-time data from Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Liquid Galaxy integration for immersive experience';

  @override
  String get about_feature_4 => 'Grid-based mapping with zoom controls';

  @override
  String get about_feature_5 => 'Building confidence score visualization';

  @override
  String get about_view_repository => 'View Project Repository';

  @override
  String get about_open_buildings_dataset => 'Open Buildings Dataset';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
