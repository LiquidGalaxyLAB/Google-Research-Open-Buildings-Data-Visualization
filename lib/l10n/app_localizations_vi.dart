// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get help_title => 'Trợ giúp';

  @override
  String get help_app_title => 'Trình Khám Phá Tòa Nhà Mở';

  @override
  String get help_app_description =>
      'Khám phá dấu chân các tòa nhà trên toàn thế giới với tích hợp Liquid Galaxy';

  @override
  String get help_step1_title => 'Chọn Khu Vực Bản Đồ';

  @override
  String get help_step1_description =>
      'Sử dụng các điều khiển ở phía bên phải của bản đồ để sửa đổi và chọn khu vực các ô mà bạn muốn khám phá.';

  @override
  String get help_step2_title => 'Chọn Một Ô';

  @override
  String get help_step2_description =>
      'Nhấp vào một ô cụ thể trong khu vực đã chọn để lấy dữ liệu tòa nhà từ bộ dữ liệu Tòa Nhà Mở.';

  @override
  String get help_step3_title => 'Xem Kết Quả';

  @override
  String get help_step3_description =>
      'Sau khi dữ liệu được lấy, một bảng dưới sẽ xuất hiện hiển thị kết quả. Bạn có thể gửi tất cả dữ liệu đến Liquid Galaxy để hiển thị.';

  @override
  String get help_step4_title => 'Khám Phá Tòa Nhà';

  @override
  String get help_step4_description =>
      'Chuyển sang tab Tòa Nhà để xem chi tiết từng tòa nhà, bao gồm mã plus và điểm tin cậy.';

  @override
  String get help_confidence_title => 'Về Điểm Tin Cậy';

  @override
  String get help_confidence_description =>
      'Mỗi tòa nhà hiển thị một điểm tin cậy cho biết độ tin cậy của dữ liệu từ bộ dữ liệu Tòa Nhà Mở cho cấu trúc cụ thể đó.';

  @override
  String get onboarding_lg_integration_title => 'Tích Hợp Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Gửi dữ liệu tòa nhà đến Liquid Galaxy để trải nghiệm hiển thị đắm chìm';

  @override
  String get onboarding_explorer_title =>
      'Trình Khám Phá Tòa Nhà Mở Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Khám phá dấu chân tòa nhà trên toàn thế giới với hiển thị tương tác';

  @override
  String get onboarding_interactive_map_title => 'Bản Đồ Tương Tác';

  @override
  String get onboarding_interactive_map_description =>
      'Chọn các vùng để hiển thị mật độ và dấu chân tòa nhà theo thời gian thực';

  @override
  String get onboarding_get_started => 'Bắt Đầu';

  @override
  String get onboarding_next => 'Tiếp Theo';

  @override
  String get map_title => 'Tòa Nhà Mở';

  @override
  String get map_clear_selection_tooltip => 'Xóa lựa chọn tòa nhà';

  @override
  String get map_search_hint => 'Tìm kiếm một vị trí';

  @override
  String get map_searching => 'Đang tìm kiếm...';

  @override
  String get map_search_no_results => 'Không tìm thấy kết quả';

  @override
  String get map_search_failed => 'Tìm kiếm thất bại. Vui lòng thử lại.';

  @override
  String get map_overlay_size_label => 'Kích Thước Lớp Phủ';

  @override
  String get map_loading_buildings => 'Đang tải tòa nhà...';

  @override
  String get map_building_details_title => 'Chi Tiết Tòa Nhà';

  @override
  String get map_building_area_label => 'Diện tích:';

  @override
  String get map_building_confidence_label => 'Tin cậy:';

  @override
  String get map_building_points_label => 'Điểm:';

  @override
  String get map_building_center_label => 'Trung tâm:';

  @override
  String get map_building_close => 'Đóng';

  @override
  String get map_building_send_to_lg => 'Gửi đến LG';

  @override
  String get map_lg_connected => 'LG Đã Kết Nối';

  @override
  String get map_lg_disconnected => 'LG Đã Ngắt Kết Nối';

  @override
  String get map_sending_building_to_lg => 'Đang gửi đến Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg => 'Đang gửi vùng đến Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Tòa nhà đã được gửi đến Liquid Galaxy thành công!';

  @override
  String map_region_sent_success(int count) {
    return 'Vùng với $count tòa nhà đã được gửi đến Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Gửi tòa nhà đến LG thất bại: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Gửi vùng đến LG thất bại: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Tải tòa nhà thất bại: $error';
  }

  @override
  String get map_connect_lg_first => 'Vui lòng kết nối với Liquid Galaxy trước';

  @override
  String get map_connect_action => 'Kết Nối';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Đã đạt giới hạn thu nhỏ tối đa (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Đã đạt giới hạn phóng to tối đa (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Tòa Nhà Đã Chọn';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Diện tích: $area m² • Tin cậy: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Đang tải dữ liệu lịch sử...';

  @override
  String get settings_title => 'Cài Đặt';

  @override
  String get settings_lg_configuration => 'Cấu Hình Liquid Galaxy';

  @override
  String get settings_visualization => 'Cài Đặt Hiển Thị';

  @override
  String get settings_data => 'Cài Đặt Dữ Liệu';

  @override
  String get settings_about => 'Giới Thiệu';

  @override
  String get lg_config_title => 'Cấu Hình Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Kết Nối';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Quét Mã QR';

  @override
  String get lg_config_manual_entry => 'Hoặc nhập thủ công:';

  @override
  String get lg_config_ip_address => 'Địa Chỉ IP';

  @override
  String get lg_config_port => 'Cổng';

  @override
  String get lg_config_rigs => 'Thiết Bị';

  @override
  String get lg_config_username => 'Tên người dùng';

  @override
  String get lg_config_password => 'Mật khẩu';

  @override
  String get lg_config_connecting => 'Đang kết nối...';

  @override
  String get lg_config_connect => 'Kết Nối';

  @override
  String get lg_config_connection_status => 'Trạng Thái Kết Nối';

  @override
  String get lg_config_connect_first_message =>
      'Kết nối với Liquid Galaxy trước để kích hoạt các hành động này.';

  @override
  String get lg_action_set_slaves_refresh => 'ĐẶT LÀM MỚI SLAVES';

  @override
  String get lg_action_reset_slaves_refresh => 'RESET LÀM MỚI SLAVES';

  @override
  String get lg_action_clear_kml_logos => 'XÓA KML + LOGO';

  @override
  String get lg_action_relaunch => 'KHỞI ĐỘNG LẠI';

  @override
  String get lg_action_reboot => 'REBOOT';

  @override
  String get lg_action_power_off => 'TẮT NGUỒN';

  @override
  String get lg_status_connected => 'Đã kết nối';

  @override
  String get lg_status_connecting => 'Đang kết nối...';

  @override
  String get lg_status_error => 'Lỗi';

  @override
  String get lg_status_disconnected => 'Đã ngắt kết nối';

  @override
  String get lg_confirm_title => 'Xác Nhận Hành Động';

  @override
  String get lg_confirm_cancel => 'Hủy';

  @override
  String get lg_confirm_yes => 'Có';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Bạn có chắc muốn đặt làm mới slaves?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Bạn có chắc muốn reset làm mới slaves?';

  @override
  String get lg_confirm_clear_kml_logos => 'Bạn có chắc muốn xóa KML và logo?';

  @override
  String get lg_confirm_relaunch => 'Bạn có chắc muốn khởi động lại LG?';

  @override
  String get lg_confirm_reboot => 'Bạn có chắc muốn reboot LG?';

  @override
  String get lg_confirm_power_off => 'Bạn có chắc muốn tắt nguồn LG?';

  @override
  String get lg_action_setting_slaves_refresh => 'Đang đặt làm mới slaves...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Đang reset làm mới slaves...';

  @override
  String get lg_action_clearing_kml_logos => 'Đang xóa KML và logo...';

  @override
  String get lg_action_relaunching => 'Đang khởi động lại LG...';

  @override
  String get lg_action_rebooting => 'Đang reboot LG...';

  @override
  String get lg_action_powering_off => 'Đang tắt nguồn LG...';

  @override
  String get lg_action_success => 'Hành động hoàn thành thành công!';

  @override
  String lg_action_failed(String error) {
    return 'Hành động thất bại: $error';
  }

  @override
  String get form_required => 'Bắt buộc';

  @override
  String get form_invalid_ip => 'IP không hợp lệ';

  @override
  String get form_invalid_number => 'Số không hợp lệ';

  @override
  String get qr_scan_title => 'Quét Mã QR';

  @override
  String get qr_invalid_data => 'Dữ liệu JSON QR không hợp lệ';

  @override
  String get qr_scanned_success_title => 'Mã QR Đã Được Quét Thành Công';

  @override
  String get qr_credentials_found =>
      'Các thông tin xác thực sau đã được tìm thấy:';

  @override
  String get qr_proceed_question =>
      'Bạn có muốn tiếp tục kết nối với Liquid Galaxy bằng các thông tin xác thực này?';

  @override
  String get qr_connect_button => 'Kết Nối';

  @override
  String get lg_connection_success =>
      'Kết nối thành công với Liquid Galaxy! Logo đã hiển thị.';

  @override
  String lg_connection_failed(String error) {
    return 'Kết nối thất bại: $error';
  }

  @override
  String get viz_settings_title => 'Cài Đặt Hiển Thị';

  @override
  String get viz_confidence_threshold => 'Ngưỡng Tin Cậy';

  @override
  String get viz_threshold_info =>
      'Đặt ngưỡng tin cậy tối thiểu để hiển thị các tòa nhà được lấy từ API. Ngưỡng thấp hơn hiển thị nhiều tòa nhà hơn, nhưng có thể bao gồm kết quả kém chính xác.';

  @override
  String get data_settings_title => 'Cài Đặt Dữ Liệu';

  @override
  String get data_source_version => 'Phiên Bản Nguồn Dữ Liệu';

  @override
  String get data_visualization_mode => 'Chế Độ Hiển Thị (Hybrid/Dark)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Giới Thiệu';

  @override
  String get about_app_title => 'Công Cụ Bộ Dữ Liệu Tòa Nhà Mở';

  @override
  String get about_app_description =>
      'Công cụ hiển thị tương tác cho bộ dữ liệu Tòa Nhà Mở của Google\nvới tích hợp Liquid Galaxy';

  @override
  String get about_version => 'Phiên bản';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Nguồn Dữ Liệu';

  @override
  String get about_data_source_value => 'Google Tòa Nhà Mở V3';

  @override
  String get about_project => 'Dự Án';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Ngày Xây Dựng';

  @override
  String get about_build_date_value => 'Tháng 1 năm 2025';

  @override
  String get about_developer => 'Nhà Phát Triển';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, Ấn Độ';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Email';

  @override
  String get about_project_details => 'Về Dự Án Này';

  @override
  String get about_project_description =>
      'Ứng dụng này tích hợp bộ dữ liệu Tòa Nhà Mở của Google với khả năng lập bản đồ tương tác và hiển thị Liquid Galaxy. Được xây dựng như một phần của Google Summer of Code 2025 với tổ chức Liquid Galaxy.';

  @override
  String get about_key_features => 'Tính Năng Chính:';

  @override
  String get about_feature_1 => 'Hiển thị tương tác dấu chân tòa nhà';

  @override
  String get about_feature_2 => 'Dữ liệu thời gian thực từ Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Tích hợp Liquid Galaxy cho trải nghiệm đắm chìm';

  @override
  String get about_feature_4 => 'Lập bản đồ dựa trên lưới với điều khiển zoom';

  @override
  String get about_feature_5 => 'Hiển thị điểm tin cậy tòa nhà';

  @override
  String get about_view_repository => 'Xem Repository Dự Án';

  @override
  String get about_open_buildings_dataset => 'Bộ Dữ Liệu Tòa Nhà Mở';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
