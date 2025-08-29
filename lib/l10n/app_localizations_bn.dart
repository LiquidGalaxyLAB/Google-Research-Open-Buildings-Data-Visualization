// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get help_title => 'সাহায্য';

  @override
  String get help_app_title => 'ওপেন বিল্ডিং এক্সপ্লোরার';

  @override
  String get help_app_description =>
      'লিকুইড গ্যালাক্সি ইন্টিগ্রেশনের সাথে বিশ্বব্যাপী বিল্ডিং ফুটপ্রিন্ট অন্বেষণ করুন';

  @override
  String get help_step1_title => 'মানচিত্র এলাকা নির্বাচন করুন';

  @override
  String get help_step1_description =>
      'আপনি যে টাইলের এলাকা অন্বেষণ করতে চান তা পরিবর্তন এবং নির্বাচন করতে মানচিত্রের ডান পাশের নিয়ন্ত্রণগুলি ব্যবহার করুন।';

  @override
  String get help_step2_title => 'একটি টাইল বেছে নিন';

  @override
  String get help_step2_description =>
      'ওপেন বিল্ডিং ডেটাসেট থেকে বিল্ডিং ডেটা আনতে আপনার নির্বাচিত এলাকার মধ্যে একটি নির্দিষ্ট টাইলে ক্লিক করুন।';

  @override
  String get help_step3_title => 'ফলাফল দেখুন';

  @override
  String get help_step3_description =>
      'ডেটা আনার পরে, ফলাফল প্রদর্শনকারী একটি নিচের শীট প্রদর্শিত হবে। আপনি ভিজ্যুয়ালাইজেশনের জন্য সমস্ত ডেটা লিকুইড গ্যালাক্সিতে পাঠাতে পারেন।';

  @override
  String get help_step4_title => 'বিল্ডিং অন্বেষণ করুন';

  @override
  String get help_step4_description =>
      'প্লাস কোড এবং আস্থার স্কোর সহ পৃথক বিল্ডিংয়ের বিবরণ দেখতে বিল্ডিং ট্যাবে স্যুইচ করুন।';

  @override
  String get help_confidence_title => 'আস্থার স্কোর সম্পর্কে';

  @override
  String get help_confidence_description =>
      'প্রতিটি বিল্ডিং একটি আস্থার স্কোর প্রদর্শন করে যা নির্দেশ করে যে সেই নির্দিষ্ট কাঠামোর জন্য ওপেন বিল্ডিং ডেটাসেটের ডেটা কতটা নির্ভরযোগ্য।';

  @override
  String get onboarding_lg_integration_title => 'লিকুইড গ্যালাক্সি ইন্টিগ্রেশন';

  @override
  String get onboarding_lg_integration_description =>
      'নিমজ্জিত ভিজ্যুয়ালাইজেশন অভিজ্ঞতার জন্য বিল্ডিং ডেটা লিকুইড গ্যালাক্সিতে পাঠান';

  @override
  String get onboarding_explorer_title =>
      'লিকুইড গ্যালাক্সি ওপেন বিল্ডিং এক্সপ্লোরার';

  @override
  String get onboarding_explorer_description =>
      'ইন্টারঅ্যাক্টিভ ভিজ্যুয়ালাইজেশনের সাথে বিশ্বব্যাপী বিল্ডিং ফুটপ্রিন্ট অন্বেষণ করুন';

  @override
  String get onboarding_interactive_map_title => 'ইন্টারঅ্যাক্টিভ মানচিত্র';

  @override
  String get onboarding_interactive_map_description =>
      'রিয়েল-টাইমে বিল্ডিং ঘনত্ব এবং ফুটপ্রিন্ট ভিজ্যুয়ালাইজ করতে অঞ্চল নির্বাচন করুন';

  @override
  String get onboarding_get_started => 'শুরু করুন';

  @override
  String get onboarding_next => 'পরবর্তী';

  @override
  String get map_title => 'ওপেন বিল্ডিং';

  @override
  String get map_clear_selection_tooltip => 'বিল্ডিং নির্বাচন পরিষ্কার করুন';

  @override
  String get map_search_hint => 'একটি অবস্থান খুঁজুন';

  @override
  String get map_searching => 'অনুসন্ধান করা হচ্ছে...';

  @override
  String get map_search_no_results => 'কোন ফলাফল পাওয়া যায়নি';

  @override
  String get map_search_failed => 'অনুসন্ধান ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';

  @override
  String get map_overlay_size_label => 'ওভারলের আকার';

  @override
  String get map_loading_buildings => 'বিল্ডিং লোড করা হচ্ছে...';

  @override
  String get map_building_details_title => 'বিল্ডিংয়ের বিবরণ';

  @override
  String get map_building_area_label => 'এলাকা:';

  @override
  String get map_building_confidence_label => 'আস্থা:';

  @override
  String get map_building_points_label => 'পয়েন্ট:';

  @override
  String get map_building_center_label => 'কেন্দ্র:';

  @override
  String get map_building_close => 'বন্ধ করুন';

  @override
  String get map_building_send_to_lg => 'LG-তে পাঠান';

  @override
  String get map_lg_connected => 'LG সংযুক্ত';

  @override
  String get map_lg_disconnected => 'LG সংযোগ বিচ্ছিন্ন';

  @override
  String get map_sending_building_to_lg =>
      'লিকুইড গ্যালাক্সিতে পাঠানো হচ্ছে...';

  @override
  String get map_sending_region_to_lg =>
      'লিকুইড গ্যালাক্সিতে অঞ্চল পাঠানো হচ্ছে...';

  @override
  String get map_building_sent_success =>
      'বিল্ডিং সফলভাবে লিকুইড গ্যালাক্সিতে পাঠানো হয়েছে!';

  @override
  String map_region_sent_success(int count) {
    return '$countটি বিল্ডিং সহ অঞ্চল লিকুইড গ্যালাক্সিতে পাঠানো হয়েছে!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'LG-তে বিল্ডিং পাঠাতে ব্যর্থ: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'LG-তে অঞ্চল পাঠাতে ব্যর্থ: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'বিল্ডিং লোড করতে ব্যর্থ: $error';
  }

  @override
  String get map_connect_lg_first =>
      'প্রথমে লিকুইড গ্যালাক্সির সাথে সংযোগ করুন';

  @override
  String get map_connect_action => 'সংযোগ করুন';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'সর্বোচ্চ জুম আউট পৌঁছেছে (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'সর্বোচ্চ জুম ইন পৌঁছেছে (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'নির্বাচিত বিল্ডিং';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'এলাকা: $area m² • আস্থা: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'ঐতিহাসিক ডেটা লোড করা হচ্ছে...';

  @override
  String get settings_title => 'সেটিংস';

  @override
  String get settings_lg_configuration => 'লিকুইড গ্যালাক্সি কনফিগারেশন';

  @override
  String get settings_visualization => 'ভিজ্যুয়ালাইজেশন সেটিংস';

  @override
  String get settings_data => 'ডেটা সেটিংস';

  @override
  String get settings_about => 'সম্পর্কে';

  @override
  String get lg_config_title => 'লিকুইড গ্যালাক্সি কনফিগারেশন';

  @override
  String get lg_config_connection_tab => 'সংযোগ';

  @override
  String get lg_config_lg_tab => 'লিকুইড গ্যালাক্সি';

  @override
  String get lg_config_scan_qr => 'QR কোড স্ক্যান করুন';

  @override
  String get lg_config_manual_entry => 'অথবা ম্যানুয়ালি প্রবেশ করান:';

  @override
  String get lg_config_ip_address => 'IP ঠিকানা';

  @override
  String get lg_config_port => 'পোর্ট';

  @override
  String get lg_config_rigs => 'রিগস';

  @override
  String get lg_config_username => 'ব্যবহারকারীর নাম';

  @override
  String get lg_config_password => 'পাসওয়ার্ড';

  @override
  String get lg_config_connecting => 'সংযোগ করা হচ্ছে...';

  @override
  String get lg_config_connect => 'সংযোগ করুন';

  @override
  String get lg_config_connection_status => 'সংযোগের অবস্থা';

  @override
  String get lg_config_connect_first_message =>
      'এই ক্রিয়াগুলি সক্ষম করতে প্রথমে লিকুইড গ্যালাক্সির সাথে সংযোগ করুন।';

  @override
  String get lg_action_set_slaves_refresh => 'স্লেভ রিফ্রেশ সেট করুন';

  @override
  String get lg_action_reset_slaves_refresh => 'স্লেভ রিফ্রেশ রিসেট করুন';

  @override
  String get lg_action_clear_kml_logos => 'KML + লোগো পরিষ্কার করুন';

  @override
  String get lg_action_relaunch => 'পুনঃচালু করুন';

  @override
  String get lg_action_reboot => 'রিবুট করুন';

  @override
  String get lg_action_power_off => 'বন্ধ করুন';

  @override
  String get lg_status_connected => 'সংযুক্ত';

  @override
  String get lg_status_connecting => 'সংযোগ করা হচ্ছে...';

  @override
  String get lg_status_error => 'ত্রুটি';

  @override
  String get lg_status_disconnected => 'সংযোগ বিচ্ছিন্ন';

  @override
  String get lg_confirm_title => 'ক্রিয়া নিশ্চিত করুন';

  @override
  String get lg_confirm_cancel => 'বাতিল করুন';

  @override
  String get lg_confirm_yes => 'হ্যাঁ';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'আপনি কি নিশ্চিত যে স্লেভ রিফ্রেশ সেট করতে চান?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'আপনি কি নিশ্চিত যে স্লেভ রিফ্রেশ রিসেট করতে চান?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'আপনি কি নিশ্চিত যে KML এবং লোগো পরিষ্কার করতে চান?';

  @override
  String get lg_confirm_relaunch => 'আপনি কি নিশ্চিত যে LG পুনঃচালু করতে চান?';

  @override
  String get lg_confirm_reboot => 'আপনি কি নিশ্চিত যে LG রিবুট করতে চান?';

  @override
  String get lg_confirm_power_off => 'আপনি কি নিশ্চিত যে LG বন্ধ করতে চান?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'স্লেভ রিফ্রেশ সেট করা হচ্ছে...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'স্লেভ রিফ্রেশ রিসেট করা হচ্ছে...';

  @override
  String get lg_action_clearing_kml_logos =>
      'KML এবং লোগো পরিষ্কার করা হচ্ছে...';

  @override
  String get lg_action_relaunching => 'LG পুনঃচালু করা হচ্ছে...';

  @override
  String get lg_action_rebooting => 'LG রিবুট করা হচ্ছে...';

  @override
  String get lg_action_powering_off => 'LG বন্ধ করা হচ্ছে...';

  @override
  String get lg_action_success => 'ক্রিয়া সফলভাবে সম্পন্ন হয়েছে!';

  @override
  String lg_action_failed(String error) {
    return 'ক্রিয়া ব্যর্থ: $error';
  }

  @override
  String get form_required => 'আবশ্যক';

  @override
  String get form_invalid_ip => 'অবৈধ IP';

  @override
  String get form_invalid_number => 'অবৈধ নম্বর';

  @override
  String get qr_scan_title => 'QR কোড স্ক্যান করুন';

  @override
  String get qr_invalid_data => 'অবৈধ QR JSON ডেটা';

  @override
  String get qr_scanned_success_title => 'QR কোড সফলভাবে স্ক্যান করা হয়েছে';

  @override
  String get qr_credentials_found => 'নিম্নলিখিত প্রমাণপত্র পাওয়া গেছে:';

  @override
  String get qr_proceed_question =>
      'আপনি কি এই প্রমাণপত্র ব্যবহার করে লিকুইড গ্যালাক্সির সাথে সংযোগ করতে এগিয়ে যেতে চান?';

  @override
  String get qr_connect_button => 'সংযোগ করুন';

  @override
  String get lg_connection_success =>
      'লিকুইড গ্যালাক্সির সাথে সফলভাবে সংযুক্ত! লোগো প্রদর্শিত।';

  @override
  String lg_connection_failed(String error) {
    return 'সংযোগ ব্যর্থ: $error';
  }

  @override
  String get viz_settings_title => 'ভিজ্যুয়ালাইজেশন সেটিংস';

  @override
  String get viz_confidence_threshold => 'আস্থার থ্রেশহোল্ড';

  @override
  String get viz_threshold_info =>
      'API থেকে পুনরুদ্ধার করা বিল্ডিংগুলি ভিজ্যুয়ালাইজ করার জন্য সর্বনিম্ন আস্থার থ্রেশহোল্ড সেট করুন। নিম্ন থ্রেশহোল্ড আরও বিল্ডিং দেখায়, কিন্তু কম নির্ভুল ফলাফল অন্তর্ভুক্ত করতে পারে।';

  @override
  String get data_settings_title => 'ডেটা সেটিংস';

  @override
  String get data_source_version => 'ডেটা সোর্স ভার্সন';

  @override
  String get data_visualization_mode => 'ভিজ্যুয়ালাইজেশন মোড (হাইব্রিড/ডার্ক)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'সম্পর্কে';

  @override
  String get about_app_title => 'ওপেন বিল্ডিং ডেটাসেট টুল';

  @override
  String get about_app_description =>
      'Google এর ওপেন বিল্ডিং ডেটাসেটের জন্য ইন্টারঅ্যাক্টিভ ভিজ্যুয়ালাইজেশন টুল\nলিকুইড গ্যালাক্সি ইন্টিগ্রেশন সহ';

  @override
  String get about_version => 'ভার্সন';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'ডেটা সোর্স';

  @override
  String get about_data_source_value => 'Google ওপেন বিল্ডিং V3';

  @override
  String get about_project => 'প্রকল্প';

  @override
  String get about_project_value => 'GSoC 2025 - লিকুইড গ্যালাক্সি';

  @override
  String get about_build_date => 'বিল্ড তারিখ';

  @override
  String get about_build_date_value => 'জানুয়ারি 2025';

  @override
  String get about_developer => 'ডেভেলপার';

  @override
  String get about_developer_name => 'জয়বর্ধন শুক্লা';

  @override
  String get about_developer_location => 'VNIT নাগপুর, ভারত';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'ইমেইল';

  @override
  String get about_project_details => 'এই প্রকল্প সম্পর্কে';

  @override
  String get about_project_description =>
      'এই অ্যাপ্লিকেশনটি Google এর ওপেন বিল্ডিং ডেটাসেটকে ইন্টারঅ্যাক্টিভ ম্যাপিং ক্ষমতা এবং লিকুইড গ্যালাক্সি ভিজ্যুয়ালাইজেশনের সাথে সংহত করে। লিকুইড গ্যালাক্সি সংস্থার সাথে Google Summer of Code 2025 এর অংশ হিসেবে নির্মিত।';

  @override
  String get about_key_features => 'মূল বৈশিষ্ট্য:';

  @override
  String get about_feature_1 =>
      'বিল্ডিং ফুটপ্রিন্টের ইন্টারঅ্যাক্টিভ ভিজ্যুয়ালাইজেশন';

  @override
  String get about_feature_2 => 'Google Earth Engine থেকে রিয়েল-টাইম ডেটা';

  @override
  String get about_feature_3 =>
      'নিমজ্জিত অভিজ্ঞতার জন্য লিকুইড গ্যালাক্সি ইন্টিগ্রেশন';

  @override
  String get about_feature_4 => 'জুম নিয়ন্ত্রণ সহ গ্রিড-ভিত্তিক ম্যাপিং';

  @override
  String get about_feature_5 => 'বিল্ডিং আস্থার স্কোর ভিজ্যুয়ালাইজেশন';

  @override
  String get about_view_repository => 'প্রকল্প রিপোজিটরি দেখুন';

  @override
  String get about_open_buildings_dataset => 'ওপেন বিল্ডিং ডেটাসেট';

  @override
  String get about_liquid_galaxy => 'লিকুইড গ্যালাক্সি';
}
