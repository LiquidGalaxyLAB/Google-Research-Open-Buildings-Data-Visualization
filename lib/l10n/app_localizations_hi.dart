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
  String get map_clear_selection_tooltip => 'इमारत चयन साफ़ करें';

  @override
  String get map_search_hint => 'एक स्थान खोजें';

  @override
  String get map_searching => 'खोज रहे हैं...';

  @override
  String get map_search_no_results => 'कोई परिणाम नहीं मिला';

  @override
  String get map_search_failed => 'खोज असफल। कृपया पुनः प्रयास करें।';

  @override
  String get map_overlay_size_label => 'ओवरले आकार';

  @override
  String get map_loading_buildings => 'इमारतें लोड हो रही हैं...';

  @override
  String get map_building_details_title => 'इमारत विवरण';

  @override
  String get map_building_area_label => 'क्षेत्र:';

  @override
  String get map_building_confidence_label => 'विश्वास:';

  @override
  String get map_building_points_label => 'बिंदु:';

  @override
  String get map_building_center_label => 'केंद्र:';

  @override
  String get map_building_close => 'बंद करें';

  @override
  String get map_building_send_to_lg => 'LG को भेजें';

  @override
  String get map_lg_connected => 'LG कनेक्टेड';

  @override
  String get map_lg_disconnected => 'LG डिस्कनेक्टेड';

  @override
  String get map_sending_building_to_lg => 'लिक्विड गैलेक्सी को भेज रहे हैं...';

  @override
  String get map_sending_region_to_lg =>
      'क्षेत्र को लिक्विड गैलेक्सी में भेज रहे हैं...';

  @override
  String get map_building_sent_success =>
      'इमारत सफलतापूर्वक लिक्विड गैलेक्सी को भेजी गई!';

  @override
  String map_region_sent_success(int count) {
    return '$count इमारतों के साथ क्षेत्र लिक्विड गैलेक्सी को भेजा गया!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'इमारत को LG में भेजने में असफल: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'क्षेत्र को LG में भेजने में असफल: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'इमारतें लोड करने में असफल: $error';
  }

  @override
  String get map_connect_lg_first =>
      'कृपया पहले लिक्विड गैलेक्सी से कनेक्ट करें';

  @override
  String get map_connect_action => 'कनेक्ट करें';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'अधिकतम ज़ूम आउट पहुंच गया (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'अधिकतम ज़ूम इन पहुंच गया (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'चयनित इमारत';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'क्षेत्र: $area m² • विश्वास: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'ऐतिहासिक डेटा लोड हो रहा है...';

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
  String get lg_config_manual_entry => 'या मैन्युअल रूप से दर्ज करें:';

  @override
  String get lg_config_ip_address => 'IP पता';

  @override
  String get lg_config_port => 'पोर्ट';

  @override
  String get lg_config_rigs => 'रिग्स';

  @override
  String get lg_config_username => 'उपयोगकर्ता नाम';

  @override
  String get lg_config_password => 'पासवर्ड';

  @override
  String get lg_config_connecting => 'कनेक्ट हो रहा है...';

  @override
  String get lg_config_connect => 'कनेक्ट करें';

  @override
  String get lg_config_connection_status => 'कनेक्शन स्थिति';

  @override
  String get lg_config_connect_first_message =>
      'इन क्रियाओं को सक्षम करने के लिए पहले लिक्विड गैलेक्सी से कनेक्ट करें।';

  @override
  String get lg_action_set_slaves_refresh => 'स्लेव्स रिफ्रेश सेट करें';

  @override
  String get lg_action_reset_slaves_refresh => 'स्लेव्स रिफ्रेश रीसेट करें';

  @override
  String get lg_action_clear_kml_logos => 'KML + लोगो साफ़ करें';

  @override
  String get lg_action_relaunch => 'पुनः लॉन्च करें';

  @override
  String get lg_action_reboot => 'रीबूट करें';

  @override
  String get lg_action_power_off => 'पावर ऑफ करें';

  @override
  String get lg_status_connected => 'कनेक्टेड';

  @override
  String get lg_status_connecting => 'कनेक्ट हो रहा है...';

  @override
  String get lg_status_error => 'त्रुटि';

  @override
  String get lg_status_disconnected => 'डिस्कनेक्टेड';

  @override
  String get lg_confirm_title => 'क्रिया की पुष्टि करें';

  @override
  String get lg_confirm_cancel => 'रद्द करें';

  @override
  String get lg_confirm_yes => 'हाँ';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'क्या आप वाकई स्लेव्स रिफ्रेश सेट करना चाहते हैं?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'क्या आप वाकई स्लेव्स रिफ्रेश रीसेट करना चाहते हैं?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'क्या आप वाकई KML और लोगो साफ़ करना चाहते हैं?';

  @override
  String get lg_confirm_relaunch =>
      'क्या आप वाकई LG को पुनः लॉन्च करना चाहते हैं?';

  @override
  String get lg_confirm_reboot => 'क्या आप वाकई LG को रीबूट करना चाहते हैं?';

  @override
  String get lg_confirm_power_off =>
      'क्या आप वाकई LG को पावर ऑफ करना चाहते हैं?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'स्लेव्स रिफ्रेश सेट कर रहे हैं...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'स्लेव्स रिफ्रेश रीसेट कर रहे हैं...';

  @override
  String get lg_action_clearing_kml_logos => 'KML और लोगो साफ़ कर रहे हैं...';

  @override
  String get lg_action_relaunching => 'LG को पुनः लॉन्च कर रहे हैं...';

  @override
  String get lg_action_rebooting => 'LG को रीबूट कर रहे हैं...';

  @override
  String get lg_action_powering_off => 'LG को पावर ऑफ कर रहे हैं...';

  @override
  String get lg_action_success => 'क्रिया सफलतापूर्वक पूर्ण हुई!';

  @override
  String lg_action_failed(String error) {
    return 'क्रिया असफल: $error';
  }

  @override
  String get form_required => 'आवश्यक';

  @override
  String get form_invalid_ip => 'अमान्य IP';

  @override
  String get form_invalid_number => 'अमान्य संख्या';

  @override
  String get qr_scan_title => 'QR कोड स्कैन करें';

  @override
  String get qr_invalid_data => 'अमान्य QR JSON डेटा';

  @override
  String get qr_scanned_success_title => 'QR कोड सफलतापूर्वक स्कैन किया गया';

  @override
  String get qr_credentials_found => 'निम्नलिखित क्रेडेंशियल मिले:';

  @override
  String get qr_proceed_question =>
      'क्या आप इन क्रेडेंशियल का उपयोग करके लिक्विड गैलेक्सी से कनेक्ट करना चाहते हैं?';

  @override
  String get qr_connect_button => 'कनेक्ट करें';

  @override
  String get lg_connection_success =>
      'लिक्विड गैलेक्सी से सफलतापूर्वक कनेक्ट हो गए! लोगो प्रदर्शित।';

  @override
  String lg_connection_failed(String error) {
    return 'कनेक्शन असफल: $error';
  }

  @override
  String get viz_settings_title => 'विज़ुअलाइज़ेशन सेटिंग्स';

  @override
  String get viz_confidence_threshold => 'विश्वास सीमा';

  @override
  String get viz_threshold_info =>
      'API से प्राप्त इमारतों को विज़ुअलाइज़ करने के लिए न्यूनतम विश्वास सीमा सेट करें। कम सीमा अधिक इमारतें दिखाती है, लेकिन कम सटीक परिणाम शामिल हो सकते हैं।';

  @override
  String get data_settings_title => 'डेटा सेटिंग्स';

  @override
  String get data_source_version => 'डेटा स्रोत संस्करण';

  @override
  String get data_visualization_mode => 'विज़ुअलाइज़ेशन मोड (हाइब्रिड/डार्क)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'के बारे में';

  @override
  String get about_app_title => 'ओपन बिल्डिंग्स डेटासेट टूल';

  @override
  String get about_app_description =>
      'गूगल के ओपन बिल्डिंग्स डेटासेट के लिए इंटरैक्टिव विज़ुअलाइज़ेशन टूल\nलिक्विड गैलेक्सी एकीकरण के साथ';

  @override
  String get about_version => 'संस्करण';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'डेटा स्रोत';

  @override
  String get about_data_source_value => 'गूगल ओपन बिल्डिंग्स V3';

  @override
  String get about_project => 'परियोजना';

  @override
  String get about_project_value => 'GSoC 2025 - लिक्विड गैलेक्सी';

  @override
  String get about_build_date => 'बिल्ड दिनांक';

  @override
  String get about_build_date_value => 'जनवरी 2025';

  @override
  String get about_developer => 'डेवलपर';

  @override
  String get about_developer_name => 'जैवर्धन शुक्ला';

  @override
  String get about_developer_location => 'VNIT नागपुर, भारत';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'ईमेल';

  @override
  String get about_project_details => 'इस परियोजना के बारे में';

  @override
  String get about_project_description =>
      'यह एप्लिकेशन गूगल के ओपन बिल्डिंग्स डेटासेट को इंटरैक्टिव मैपिंग क्षमताओं और लिक्विड गैलेक्सी विज़ुअलाइज़ेशन के साथ एकीकृत करता है। लिक्विड गैलेक्सी संगठन के साथ गूगल समर ऑफ कोड 2025 के हिस्से के रूप में बनाया गया।';

  @override
  String get about_key_features => 'मुख्य विशेषताएं:';

  @override
  String get about_feature_1 => 'इंटरैक्टिव बिल्डिंग फुटप्रिंट विज़ुअलाइज़ेशन';

  @override
  String get about_feature_2 => 'गूगल अर्थ इंजन से रियल-टाइम डेटा';

  @override
  String get about_feature_3 => 'इमर्सिव अनुभव के लिए लिक्विड गैलेक्सी एकीकरण';

  @override
  String get about_feature_4 => 'ज़ूम नियंत्रण के साथ ग्रिड-आधारित मैपिंग';

  @override
  String get about_feature_5 => 'बिल्डिंग विश्वास स्कोर विज़ुअलाइज़ेशन';

  @override
  String get about_view_repository => 'परियोजना रिपॉजिटरी देखें';

  @override
  String get about_open_buildings_dataset => 'ओपन बिल्डिंग्स डेटासेट';

  @override
  String get about_liquid_galaxy => 'लिक्विड गैलेक्सी के बारे में';
}
