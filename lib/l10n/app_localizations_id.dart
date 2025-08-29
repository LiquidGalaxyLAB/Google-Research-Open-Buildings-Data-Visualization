// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get help_title => 'Bantuan';

  @override
  String get help_app_title => 'Penjelajah Bangunan Terbuka';

  @override
  String get help_app_description =>
      'Jelajahi jejak bangunan di seluruh dunia dengan integrasi Liquid Galaxy';

  @override
  String get help_step1_title => 'Pilih Area Peta';

  @override
  String get help_step1_description =>
      'Gunakan kontrol di sisi kanan peta untuk memodifikasi dan memilih area ubin yang ingin Anda jelajahi.';

  @override
  String get help_step2_title => 'Pilih Ubin';

  @override
  String get help_step2_description =>
      'Klik pada ubin tertentu dalam area yang dipilih untuk mengambil data bangunan dari dataset Bangunan Terbuka.';

  @override
  String get help_step3_title => 'Lihat Hasil';

  @override
  String get help_step3_description =>
      'Setelah data diambil, lembar bawah akan muncul menampilkan hasil. Anda dapat mengirim semua data ke Liquid Galaxy untuk visualisasi.';

  @override
  String get help_step4_title => 'Jelajahi Bangunan';

  @override
  String get help_step4_description =>
      'Beralih ke tab Bangunan untuk melihat detail bangunan individual, termasuk kode plus dan skor kepercayaan.';

  @override
  String get help_confidence_title => 'Tentang Skor Kepercayaan';

  @override
  String get help_confidence_description =>
      'Setiap bangunan menampilkan skor kepercayaan yang menunjukkan seberapa dapat diandalkan data dari dataset Bangunan Terbuka untuk struktur tertentu tersebut.';

  @override
  String get onboarding_lg_integration_title => 'Integrasi Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Kirim data bangunan ke Liquid Galaxy untuk pengalaman visualisasi yang imersif';

  @override
  String get onboarding_explorer_title =>
      'Penjelajah Bangunan Terbuka Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Jelajahi jejak bangunan di seluruh dunia dengan visualisasi interaktif';

  @override
  String get onboarding_interactive_map_title => 'Peta Interaktif';

  @override
  String get onboarding_interactive_map_description =>
      'Pilih wilayah untuk memvisualisasikan kepadatan dan jejak bangunan secara real-time';

  @override
  String get onboarding_get_started => 'Mulai';

  @override
  String get onboarding_next => 'Berikutnya';

  @override
  String get map_title => 'Bangunan Terbuka';

  @override
  String get map_clear_selection_tooltip => 'Hapus pilihan bangunan';

  @override
  String get map_search_hint => 'Cari lokasi';

  @override
  String get map_searching => 'Mencari...';

  @override
  String get map_search_no_results => 'Tidak ada hasil ditemukan';

  @override
  String get map_search_failed => 'Pencarian gagal. Silakan coba lagi.';

  @override
  String get map_overlay_size_label => 'Ukuran Overlay';

  @override
  String get map_loading_buildings => 'Memuat bangunan...';

  @override
  String get map_building_details_title => 'Detail Bangunan';

  @override
  String get map_building_area_label => 'Area:';

  @override
  String get map_building_confidence_label => 'Kepercayaan:';

  @override
  String get map_building_points_label => 'Titik:';

  @override
  String get map_building_center_label => 'Pusat:';

  @override
  String get map_building_close => 'Tutup';

  @override
  String get map_building_send_to_lg => 'Kirim ke LG';

  @override
  String get map_lg_connected => 'LG Terhubung';

  @override
  String get map_lg_disconnected => 'LG Terputus';

  @override
  String get map_sending_building_to_lg => 'Mengirim ke Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg => 'Mengirim wilayah ke Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Bangunan berhasil dikirim ke Liquid Galaxy!';

  @override
  String map_region_sent_success(int count) {
    return 'Wilayah dengan $count bangunan telah dikirim ke Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Gagal mengirim bangunan ke LG: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Gagal mengirim wilayah ke LG: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Gagal memuat bangunan: $error';
  }

  @override
  String get map_connect_lg_first =>
      'Silakan hubungkan ke Liquid Galaxy terlebih dahulu';

  @override
  String get map_connect_action => 'Hubungkan';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Batas zoom out maksimum tercapai (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Batas zoom in maksimum tercapai (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Bangunan Terpilih';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Area: $area m² • Kepercayaan: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Memuat data historis...';

  @override
  String get settings_title => 'Pengaturan';

  @override
  String get settings_lg_configuration => 'Konfigurasi Liquid Galaxy';

  @override
  String get settings_visualization => 'Pengaturan Visualisasi';

  @override
  String get settings_data => 'Pengaturan Data';

  @override
  String get settings_about => 'Tentang';

  @override
  String get lg_config_title => 'Konfigurasi Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Koneksi';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Pindai Kode QR';

  @override
  String get lg_config_manual_entry => 'Atau masukkan secara manual:';

  @override
  String get lg_config_ip_address => 'Alamat IP';

  @override
  String get lg_config_port => 'Port';

  @override
  String get lg_config_rigs => 'Rig';

  @override
  String get lg_config_username => 'Nama pengguna';

  @override
  String get lg_config_password => 'Kata sandi';

  @override
  String get lg_config_connecting => 'Menghubungkan...';

  @override
  String get lg_config_connect => 'Hubungkan';

  @override
  String get lg_config_connection_status => 'Status Koneksi';

  @override
  String get lg_config_connect_first_message =>
      'Hubungkan ke Liquid Galaxy terlebih dahulu untuk mengaktifkan tindakan ini.';

  @override
  String get lg_action_set_slaves_refresh => 'ATUR REFRESH SLAVE';

  @override
  String get lg_action_reset_slaves_refresh => 'RESET REFRESH SLAVE';

  @override
  String get lg_action_clear_kml_logos => 'HAPUS KML + LOGO';

  @override
  String get lg_action_relaunch => 'JALANKAN ULANG';

  @override
  String get lg_action_reboot => 'REBOOT';

  @override
  String get lg_action_power_off => 'MATIKAN';

  @override
  String get lg_status_connected => 'Terhubung';

  @override
  String get lg_status_connecting => 'Menghubungkan...';

  @override
  String get lg_status_error => 'Error';

  @override
  String get lg_status_disconnected => 'Terputus';

  @override
  String get lg_confirm_title => 'Konfirmasi Tindakan';

  @override
  String get lg_confirm_cancel => 'Batal';

  @override
  String get lg_confirm_yes => 'Ya';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Apakah Anda yakin ingin mengatur refresh slave?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Apakah Anda yakin ingin mereset refresh slave?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Apakah Anda yakin ingin menghapus KML dan logo?';

  @override
  String get lg_confirm_relaunch =>
      'Apakah Anda yakin ingin menjalankan ulang LG?';

  @override
  String get lg_confirm_reboot => 'Apakah Anda yakin ingin me-reboot LG?';

  @override
  String get lg_confirm_power_off => 'Apakah Anda yakin ingin mematikan LG?';

  @override
  String get lg_action_setting_slaves_refresh => 'Mengatur refresh slave...';

  @override
  String get lg_action_resetting_slaves_refresh => 'Mereset refresh slave...';

  @override
  String get lg_action_clearing_kml_logos => 'Menghapus KML dan logo...';

  @override
  String get lg_action_relaunching => 'Menjalankan ulang LG...';

  @override
  String get lg_action_rebooting => 'Me-reboot LG...';

  @override
  String get lg_action_powering_off => 'Mematikan LG...';

  @override
  String get lg_action_success => 'Tindakan berhasil diselesaikan!';

  @override
  String lg_action_failed(String error) {
    return 'Tindakan gagal: $error';
  }

  @override
  String get form_required => 'Wajib diisi';

  @override
  String get form_invalid_ip => 'IP tidak valid';

  @override
  String get form_invalid_number => 'Nomor tidak valid';

  @override
  String get qr_scan_title => 'Pindai Kode QR';

  @override
  String get qr_invalid_data => 'Data JSON QR tidak valid';

  @override
  String get qr_scanned_success_title => 'Kode QR Berhasil Dipindai';

  @override
  String get qr_credentials_found => 'Kredensial berikut ditemukan:';

  @override
  String get qr_proceed_question =>
      'Apakah Anda ingin melanjutkan untuk terhubung ke Liquid Galaxy menggunakan kredensial ini?';

  @override
  String get qr_connect_button => 'Hubungkan';

  @override
  String get lg_connection_success =>
      'Berhasil terhubung ke Liquid Galaxy! Logo ditampilkan.';

  @override
  String lg_connection_failed(String error) {
    return 'Koneksi gagal: $error';
  }

  @override
  String get viz_settings_title => 'Pengaturan Visualisasi';

  @override
  String get viz_confidence_threshold => 'Ambang Batas Kepercayaan';

  @override
  String get viz_threshold_info =>
      'Tetapkan ambang batas kepercayaan minimum untuk memvisualisasikan bangunan yang diambil dari API. Ambang batas yang lebih rendah menampilkan lebih banyak bangunan, tetapi mungkin termasuk hasil yang kurang akurat.';

  @override
  String get data_settings_title => 'Pengaturan Data';

  @override
  String get data_source_version => 'Versi Sumber Data';

  @override
  String get data_visualization_mode => 'Mode Visualisasi (Hybrid/Dark)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Tentang';

  @override
  String get about_app_title => 'Alat Dataset Bangunan Terbuka';

  @override
  String get about_app_description =>
      'Alat visualisasi interaktif untuk dataset Bangunan Terbuka Google\ndengan integrasi Liquid Galaxy';

  @override
  String get about_version => 'Versi';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Sumber Data';

  @override
  String get about_data_source_value => 'Google Bangunan Terbuka V3';

  @override
  String get about_project => 'Proyek';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Tanggal Build';

  @override
  String get about_build_date_value => 'Januari 2025';

  @override
  String get about_developer => 'Pengembang';

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
  String get about_project_details => 'Tentang Proyek Ini';

  @override
  String get about_project_description =>
      'Aplikasi ini mengintegrasikan dataset Bangunan Terbuka Google dengan kemampuan pemetaan interaktif dan visualisasi Liquid Galaxy. Dibangun sebagai bagian dari Google Summer of Code 2025 dengan organisasi Liquid Galaxy.';

  @override
  String get about_key_features => 'Fitur Utama:';

  @override
  String get about_feature_1 => 'Visualisasi jejak bangunan interaktif';

  @override
  String get about_feature_2 => 'Data real-time dari Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Integrasi Liquid Galaxy untuk pengalaman imersif';

  @override
  String get about_feature_4 => 'Pemetaan berbasis grid dengan kontrol zoom';

  @override
  String get about_feature_5 => 'Visualisasi skor kepercayaan bangunan';

  @override
  String get about_view_repository => 'Lihat Repository Proyek';

  @override
  String get about_open_buildings_dataset => 'Dataset Bangunan Terbuka';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
