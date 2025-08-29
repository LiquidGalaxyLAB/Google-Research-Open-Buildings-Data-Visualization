// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get help_title => 'Msaada';

  @override
  String get help_app_title => 'Mchunguzi wa Majengo ya Wazi';

  @override
  String get help_app_description =>
      'Chunguza alama za majengo ulimwenguni kote na uunganisho wa Liquid Galaxy';

  @override
  String get help_step1_title => 'Chagua Eneo la Ramani';

  @override
  String get help_step1_description =>
      'Tumia vidhibiti upande wa kulia wa ramani kubadilisha na kuchagua eneo la vigae unavyotaka kuchunguza.';

  @override
  String get help_step2_title => 'Chagua Kigae';

  @override
  String get help_step2_description =>
      'Bonyeza kwenye kigae maalum ndani ya eneo ulilochagua ili kupata data ya majengo kutoka kwenye daftari la data ya Majengo ya Wazi.';

  @override
  String get help_step3_title => 'Ona Matokeo';

  @override
  String get help_step3_description =>
      'Baada ya kupata data, jedwali la chini litaonekana likionyesha matokeo. Unaweza kutuma data zote kwenye Liquid Galaxy kwa ajili ya miwani.';

  @override
  String get help_step4_title => 'Chunguza Majengo';

  @override
  String get help_step4_description =>
      'Badilisha kwenda kwenye tab ya Majengo kuona maelezo ya kila jengo, ikiwa ni pamoja na misimbo ya plus na alama za uaminifu.';

  @override
  String get help_confidence_title => 'Kuhusu Alama za Uaminifu';

  @override
  String get help_confidence_description =>
      'Kila jengo linaonyesha alama ya uaminifu inayoonyesha jinsi data kutoka kwenye daftari la data ya Majengo ya Wazi ni za kuaminika kwa muundo huo maalum.';

  @override
  String get onboarding_lg_integration_title => 'Uunganisho wa Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Tuma data ya majengo kwenye Liquid Galaxy kwa uzoefu wa miwani wa kujitumbukiza';

  @override
  String get onboarding_explorer_title =>
      'Mchunguzi wa Majengo ya Wazi wa Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Chunguza alama za majengo ulimwenguni kote na miwani ya maingiliano';

  @override
  String get onboarding_interactive_map_title => 'Ramani ya Maingiliano';

  @override
  String get onboarding_interactive_map_description =>
      'Chagua mikoa ili kuona msongamano na alama za majengo muda halisi';

  @override
  String get onboarding_get_started => 'Anza';

  @override
  String get onboarding_next => 'Ifuatayo';

  @override
  String get map_title => 'Majengo ya Wazi';

  @override
  String get map_clear_selection_tooltip => 'Futa uchaguzi wa jengo';

  @override
  String get map_search_hint => 'Tafuta mahali';

  @override
  String get map_searching => 'Inatafuta...';

  @override
  String get map_search_no_results => 'Hakuna matokeo yaliyopatikana';

  @override
  String get map_search_failed =>
      'Utafutaji umeshindwa. Tafadhali jaribu tena.';

  @override
  String get map_overlay_size_label => 'Ukubwa wa Uwandani';

  @override
  String get map_loading_buildings => 'Inapakia majengo...';

  @override
  String get map_building_details_title => 'Maelezo ya Jengo';

  @override
  String get map_building_area_label => 'Eneo:';

  @override
  String get map_building_confidence_label => 'Uaminifu:';

  @override
  String get map_building_points_label => 'Pointi:';

  @override
  String get map_building_center_label => 'Kituo:';

  @override
  String get map_building_close => 'Funga';

  @override
  String get map_building_send_to_lg => 'Tuma kwenye LG';

  @override
  String get map_lg_connected => 'LG Imeunganishwa';

  @override
  String get map_lg_disconnected => 'LG Imekatika';

  @override
  String get map_sending_building_to_lg => 'Inatuma kwenye Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg => 'Inatuma mkoa kwenye Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Jengo limetumwa kwenye Liquid Galaxy kwa mafanikio!';

  @override
  String map_region_sent_success(int count) {
    return 'Mkoa wenye majengo $count umetumwa kwenye Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Imeshindwa kutuma jengo kwenye LG: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Imeshindwa kutuma mkoa kwenye LG: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Imeshindwa kupakia majengo: $error';
  }

  @override
  String get map_connect_lg_first =>
      'Tafadhali unganisha kwenye Liquid Galaxy kwanza';

  @override
  String get map_connect_action => 'Unganisha';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Kikomo cha juu cha zoom out kimefikiwa (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Kikomo cha juu cha zoom in kimefikiwa (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Jengo Lililochaguliwa';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Eneo: $area m² • Uaminifu: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Inapakia data ya kihistoria...';

  @override
  String get settings_title => 'Mipangilio';

  @override
  String get settings_lg_configuration => 'Usanidi wa Liquid Galaxy';

  @override
  String get settings_visualization => 'Mipangilio ya Miwani';

  @override
  String get settings_data => 'Mipangilio ya Data';

  @override
  String get settings_about => 'Kuhusu';

  @override
  String get lg_config_title => 'Usanidi wa Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Muunganisho';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Changanua Msimbo wa QR';

  @override
  String get lg_config_manual_entry => 'Au ingiza kwa mkono:';

  @override
  String get lg_config_ip_address => 'Anwani ya IP';

  @override
  String get lg_config_port => 'Bandari';

  @override
  String get lg_config_rigs => 'Vifaa';

  @override
  String get lg_config_username => 'Jina la mtumiaji';

  @override
  String get lg_config_password => 'Nywila';

  @override
  String get lg_config_connecting => 'Inaunganisha...';

  @override
  String get lg_config_connect => 'Unganisha';

  @override
  String get lg_config_connection_status => 'Hali ya Muunganisho';

  @override
  String get lg_config_connect_first_message =>
      'Unganisha kwenye Liquid Galaxy kwanza ili kuwezesha vitendo hivi.';

  @override
  String get lg_action_set_slaves_refresh => 'WEKA ONYESHO UPYA WA WATUMWA';

  @override
  String get lg_action_reset_slaves_refresh =>
      'REJESHA ONYESHO UPYA WA WATUMWA';

  @override
  String get lg_action_clear_kml_logos => 'FUTA KML + NEMBO';

  @override
  String get lg_action_relaunch => 'ZINDUA UPYA';

  @override
  String get lg_action_reboot => 'ZINDUA UPYA MFUMO';

  @override
  String get lg_action_power_off => 'ZIMA';

  @override
  String get lg_status_connected => 'Imeunganishwa';

  @override
  String get lg_status_connecting => 'Inaunganisha...';

  @override
  String get lg_status_error => 'Hitilafu';

  @override
  String get lg_status_disconnected => 'Imekatika';

  @override
  String get lg_confirm_title => 'Thibitisha Kitendo';

  @override
  String get lg_confirm_cancel => 'Ghairi';

  @override
  String get lg_confirm_yes => 'Ndiyo';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Je, una uhakika unataka kuweka onyesho upya wa watumwa?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Je, una uhakika unataka kurejesha onyesho upya wa watumwa?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Je, una uhakika unataka kufuta KML na nembo?';

  @override
  String get lg_confirm_relaunch => 'Je, una uhakika unataka kuzindua upya LG?';

  @override
  String get lg_confirm_reboot =>
      'Je, una uhakika unataka kuzindua upya mfumo wa LG?';

  @override
  String get lg_confirm_power_off => 'Je, una uhakika unataka kuzima LG?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'Inaweka onyesho upya wa watumwa...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Inarejesha onyesho upya wa watumwa...';

  @override
  String get lg_action_clearing_kml_logos => 'Inafuta KML na nembo...';

  @override
  String get lg_action_relaunching => 'Inazindua upya LG...';

  @override
  String get lg_action_rebooting => 'Inazindua upya mfumo wa LG...';

  @override
  String get lg_action_powering_off => 'Inazima LG...';

  @override
  String get lg_action_success => 'Kitendo kimekamilika kwa mafanikio!';

  @override
  String lg_action_failed(String error) {
    return 'Kitendo kimeshindwa: $error';
  }

  @override
  String get form_required => 'Inahitajika';

  @override
  String get form_invalid_ip => 'IP batili';

  @override
  String get form_invalid_number => 'Nambari batili';

  @override
  String get qr_scan_title => 'Changanua Msimbo wa QR';

  @override
  String get qr_invalid_data => 'Data ya JSON ya QR ni batili';

  @override
  String get qr_scanned_success_title =>
      'Msimbo wa QR Umechunguzwa kwa Mafanikio';

  @override
  String get qr_credentials_found => 'Vyeti vifuatavyo vimepatikana:';

  @override
  String get qr_proceed_question =>
      'Je, unataka kuendelea kuunganisha kwenye Liquid Galaxy kwa kutumia vyeti hivi?';

  @override
  String get qr_connect_button => 'Unganisha';

  @override
  String get lg_connection_success =>
      'Imeunganishwa kwenye Liquid Galaxy kwa mafanikio! Nembo imeonyeshwa.';

  @override
  String lg_connection_failed(String error) {
    return 'Muunganisho umeshindwa: $error';
  }

  @override
  String get viz_settings_title => 'Mipangilio ya Miwani';

  @override
  String get viz_confidence_threshold => 'Kizingiti cha Uaminifu';

  @override
  String get viz_threshold_info =>
      'Weka kizingiti cha chini cha uaminifu kwa kuonyesha majengo yaliyopatikana kutoka kwenye API. Vizingiti vya chini vinaonyesha majengo zaidi, lakini vinaweza kujumuisha matokeo yasiyo sahihi.';

  @override
  String get data_settings_title => 'Mipangilio ya Data';

  @override
  String get data_source_version => 'Toleo la Chanzo cha Data';

  @override
  String get data_visualization_mode => 'Hali ya Miwani (Mchanganyiko/Giza)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Kuhusu';

  @override
  String get about_app_title => 'Zana ya Daftari la Data ya Majengo ya Wazi';

  @override
  String get about_app_description =>
      'Zana ya miwani ya maingiliano kwa daftari la data ya Majengo ya Wazi ya Google\nna uunganisho wa Liquid Galaxy';

  @override
  String get about_version => 'Toleo';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Chanzo cha Data';

  @override
  String get about_data_source_value => 'Google Majengo ya Wazi V3';

  @override
  String get about_project => 'Mradi';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Tarehe ya Ujenzi';

  @override
  String get about_build_date_value => 'Januari 2025';

  @override
  String get about_developer => 'Msanidi';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, India';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Barua pepe';

  @override
  String get about_project_details => 'Kuhusu Mradi Huu';

  @override
  String get about_project_description =>
      'Programu hii inaunganisha daftari la data ya Majengo ya Wazi ya Google na uwezo wa ramani ya maingiliano na miwani ya Liquid Galaxy. Imejengwa kama sehemu ya Google Summer of Code 2025 na shirika la Liquid Galaxy.';

  @override
  String get about_key_features => 'Vipengele Muhimu:';

  @override
  String get about_feature_1 => 'Miwani ya maingiliano ya alama za majengo';

  @override
  String get about_feature_2 =>
      'Data ya wakati halisi kutoka Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Uunganisho wa Liquid Galaxy kwa uzoefu wa kujitumbukiza';

  @override
  String get about_feature_4 =>
      'Ramani ya msingi wa gridi na vidhibiti vya zoom';

  @override
  String get about_feature_5 => 'Miwani ya alama za uaminifu wa majengo';

  @override
  String get about_view_repository => 'Ona Hifadhi ya Mradi';

  @override
  String get about_open_buildings_dataset =>
      'Daftari la Data ya Majengo ya Wazi';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
