// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get help_title => 'Taimako';

  @override
  String get help_app_title => 'Mai Binciken Gine-ginen Buɗaɗɗe';

  @override
  String get help_app_description =>
      'Bincika alamun gine-gine a duk duniya tare da haɗin Liquid Galaxy';

  @override
  String get help_step1_title => 'Zaɓi Yankin Taswira';

  @override
  String get help_step1_description =>
      'Yi amfani da sarrafa a gefen dama na taswira don gyara da zaɓi yankin tiles da kake son bincikar.';

  @override
  String get help_step2_title => 'Zaɓi Tile';

  @override
  String get help_step2_description =>
      'Danna kan wani takamaiman tile a cikin yankin da ka zaɓa don samun bayanan gine-gine daga bayanan Open Buildings.';

  @override
  String get help_step3_title => 'Duba Sakamakon';

  @override
  String get help_step3_description =>
      'Bayan samun bayanan, za a nuna takarda ta ƙasa da ke nuna sakamakon. Za ka iya aika duk bayanan zuwa Liquid Galaxy don gani.';

  @override
  String get help_step4_title => 'Bincika Gine-gine';

  @override
  String get help_step4_description =>
      'Canza zuwa shafin Gine-gine don ganin cikakkun bayanai na kowane gini, har da plus codes da ƙimar amincewa.';

  @override
  String get help_confidence_title => 'Game da Ƙimar Amincewa';

  @override
  String get help_confidence_description =>
      'Kowane gini yana nuna ƙimar amincewa da ke nuna yadda bayanan Open Buildings dataset suke da aminci ga wannan tsarin.';

  @override
  String get onboarding_lg_integration_title => 'Haɗin Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Aika bayanan gine-gine zuwa Liquid Galaxy don ƙwarewar gani mai zurfi';

  @override
  String get onboarding_explorer_title =>
      'Mai Binciken Gine-ginen Buɗaɗɗe na Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Bincika alamun gine-gine a duk duniya tare da gani mai amsawa';

  @override
  String get onboarding_interactive_map_title => 'Taswira Mai Amsawa';

  @override
  String get onboarding_interactive_map_description =>
      'Zaɓi yankuna don ganin ƙarfin gine-gine da alamunsu nan take';

  @override
  String get onboarding_get_started => 'Fara';

  @override
  String get onboarding_next => 'Na gaba';

  @override
  String get map_title => 'Gine-ginen Buɗaɗɗe';

  @override
  String get map_clear_selection_tooltip => 'Share zaɓin gini';

  @override
  String get map_search_hint => 'Nema wuri';

  @override
  String get map_searching => 'Ana nema...';

  @override
  String get map_search_no_results => 'Ba a samu sakamako ba';

  @override
  String get map_search_failed => 'Binciken ya kasa. Ka sake gwadawa.';

  @override
  String get map_overlay_size_label => 'Girman Overlay';

  @override
  String get map_loading_buildings => 'Ana ɗaukar gine-gine...';

  @override
  String get map_building_details_title => 'Bayanan Gini';

  @override
  String get map_building_area_label => 'Yanki:';

  @override
  String get map_building_confidence_label => 'Amincewa:';

  @override
  String get map_building_points_label => 'Maki:';

  @override
  String get map_building_center_label => 'Cibiya:';

  @override
  String get map_building_close => 'Rufe';

  @override
  String get map_building_send_to_lg => 'Aika zuwa LG';

  @override
  String get map_lg_connected => 'LG ya Haɗu';

  @override
  String get map_lg_disconnected => 'LG ya Rabu';

  @override
  String get map_sending_building_to_lg => 'Ana aikawa zuwa Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg =>
      'Ana aikan yanki zuwa Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'An aika ginin zuwa Liquid Galaxy da nasara!';

  @override
  String map_region_sent_success(int count) {
    return 'An aika yanki mai gine-gine $count zuwa Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Aikawa gini zuwa LG ya kasa: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Aikawa yanki zuwa LG ya kasa: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Ɗaukar gine-gine ya kasa: $error';
  }

  @override
  String get map_connect_lg_first => 'Da fari ka haɗu da Liquid Galaxy';

  @override
  String get map_connect_action => 'Haɗa';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'An kai iyakar zoom out (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'An kai iyakar zoom in (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Ginin da aka Zaɓa';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Yanki: $area m² • Amincewa: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Ana ɗaukar bayanan tarihi...';

  @override
  String get settings_title => 'Saiti';

  @override
  String get settings_lg_configuration => 'Saitar Liquid Galaxy';

  @override
  String get settings_visualization => 'Saitar Gani';

  @override
  String get settings_data => 'Saitar Bayanai';

  @override
  String get settings_about => 'Game da';

  @override
  String get lg_config_title => 'Saitar Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Haɗi';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Scan QR Code';

  @override
  String get lg_config_manual_entry => 'Ko shigar da hannu:';

  @override
  String get lg_config_ip_address => 'Adireshin IP';

  @override
  String get lg_config_port => 'Port';

  @override
  String get lg_config_rigs => 'Rigs';

  @override
  String get lg_config_username => 'Sunan mai amfani';

  @override
  String get lg_config_password => 'Kalmar sirri';

  @override
  String get lg_config_connecting => 'Ana haɗawa...';

  @override
  String get lg_config_connect => 'Haɗa';

  @override
  String get lg_config_connection_status => 'Matsayin Haɗi';

  @override
  String get lg_config_connect_first_message =>
      'Ka fara haɗu da Liquid Galaxy don kunna waɗannan ayyuka.';

  @override
  String get lg_action_set_slaves_refresh => 'SAITA SABUNTA BAYI';

  @override
  String get lg_action_reset_slaves_refresh => 'SAKE SAITA SABUNTA BAYI';

  @override
  String get lg_action_clear_kml_logos => 'SHARE KML + LOGOS';

  @override
  String get lg_action_relaunch => 'SAKE ƘADDAMARWA';

  @override
  String get lg_action_reboot => 'SAKE KUNNA';

  @override
  String get lg_action_power_off => 'KASHE';

  @override
  String get lg_status_connected => 'Ya haɗu';

  @override
  String get lg_status_connecting => 'Ana haɗawa...';

  @override
  String get lg_status_error => 'Kuskure';

  @override
  String get lg_status_disconnected => 'Ya rabu';

  @override
  String get lg_confirm_title => 'Tabbatar da Aikin';

  @override
  String get lg_confirm_cancel => 'Soke';

  @override
  String get lg_confirm_yes => 'Eh';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Ka tabbata kana son saita sabunta bayi?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Ka tabbata kana son sake saita sabunta bayi?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Ka tabbata kana son share KML da logos?';

  @override
  String get lg_confirm_relaunch => 'Ka tabbata kana son sake ƙaddamar da LG?';

  @override
  String get lg_confirm_reboot => 'Ka tabbata kana son sake kunna LG?';

  @override
  String get lg_confirm_power_off => 'Ka tabbata kana son kashe LG?';

  @override
  String get lg_action_setting_slaves_refresh => 'Ana saita sabunta bayi...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Ana sake saita sabunta bayi...';

  @override
  String get lg_action_clearing_kml_logos => 'Ana share KML da logos...';

  @override
  String get lg_action_relaunching => 'Ana sake ƙaddamar da LG...';

  @override
  String get lg_action_rebooting => 'Ana sake kunna LG...';

  @override
  String get lg_action_powering_off => 'Ana kashe LG...';

  @override
  String get lg_action_success => 'An kammala aikin da nasara!';

  @override
  String lg_action_failed(String error) {
    return 'Aikin ya kasa: $error';
  }

  @override
  String get form_required => 'Ana bukata';

  @override
  String get form_invalid_ip => 'IP mara inganci';

  @override
  String get form_invalid_number => 'Lamba mara inganci';

  @override
  String get qr_scan_title => 'Scan QR Code';

  @override
  String get qr_invalid_data => 'Bayanan QR JSON marasa inganci';

  @override
  String get qr_scanned_success_title => 'An Scan QR Code da Nasara';

  @override
  String get qr_credentials_found => 'An samo waɗannan takaddun shaida:';

  @override
  String get qr_proceed_question =>
      'Kana son ci gaba da haɗuwa da Liquid Galaxy ta amfani da waɗannan takaddun shaida?';

  @override
  String get qr_connect_button => 'Haɗa';

  @override
  String get lg_connection_success =>
      'An haɗu da Liquid Galaxy da nasara! An nuna logo.';

  @override
  String lg_connection_failed(String error) {
    return 'Haɗuwa ya kasa: $error';
  }

  @override
  String get viz_settings_title => 'Saitar Gani';

  @override
  String get viz_confidence_threshold => 'Iyakar Amincewa';

  @override
  String get viz_threshold_info =>
      'Saita ƙaramin iyakar amincewa don ganin gine-ginen da aka samo daga API. Ƙananan iyakoki suna nuna ƙarin gine-gine, amma za su iya haɗa sakamako marasa daidaito.';

  @override
  String get data_settings_title => 'Saitar Bayanai';

  @override
  String get data_source_version => 'Sigar Tushen Bayanai';

  @override
  String get data_visualization_mode => 'Yanayin Gani (Hybrid/Dark)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Game da';

  @override
  String get about_app_title => 'Kayan Aikin Bayanan Gine-ginen Buɗaɗɗe';

  @override
  String get about_app_description =>
      'Kayan aikin gani mai amsawa don bayanan Open Buildings na Google\ntare da haɗin Liquid Galaxy';

  @override
  String get about_version => 'Sigar';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Tushen Bayanai';

  @override
  String get about_data_source_value => 'Google Open Buildings V3';

  @override
  String get about_project => 'Aikin';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Ranar Ginawa';

  @override
  String get about_build_date_value => 'Janairu 2025';

  @override
  String get about_developer => 'Mai Ƙirƙira';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, Indiya';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Imel';

  @override
  String get about_project_details => 'Game da wannan Aikin';

  @override
  String get about_project_description =>
      'Wannan aikawa-yarjejeniya tana haɗa bayanan Open Buildings na Google tare da damar taswira mai amsawa da gani na Liquid Galaxy. An gina shi a matsayin sashen Google Summer of Code 2025 tare da ƙungiyar Liquid Galaxy.';

  @override
  String get about_key_features => 'Mahimman Dabarun:';

  @override
  String get about_feature_1 => 'Gani mai amsawa na alamun gine-gine';

  @override
  String get about_feature_2 => 'Bayanan kai tsaye daga Google Earth Engine';

  @override
  String get about_feature_3 => 'Haɗin Liquid Galaxy don ƙwararar zurfi';

  @override
  String get about_feature_4 => 'Taswira tushen grid tare da sarrafa zoom';

  @override
  String get about_feature_5 => 'Ganin ƙimar amincewa gine-gine';

  @override
  String get about_view_repository => 'Duba Repository na Aikin';

  @override
  String get about_open_buildings_dataset => 'Bayanan Gine-ginen Buɗaɗɗe';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
