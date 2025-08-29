// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get help_title => 'Ayuda';

  @override
  String get help_app_title => 'Explorador de Edificios Abiertos';

  @override
  String get help_app_description =>
      'Explora las huellas de edificios en todo el mundo con integración de Liquid Galaxy';

  @override
  String get help_step1_title => 'Seleccionar Área del Mapa';

  @override
  String get help_step1_description =>
      'Usa los controles en el lado derecho del mapa para modificar y seleccionar el área de azulejos que quieres explorar.';

  @override
  String get help_step2_title => 'Elegir un Azulejo';

  @override
  String get help_step2_description =>
      'Haz clic en un azulejo específico dentro de tu área seleccionada para obtener datos de edificios del conjunto de datos de Edificios Abiertos.';

  @override
  String get help_step3_title => 'Ver Resultados';

  @override
  String get help_step3_description =>
      'Una vez que se obtengan los datos, aparecerá una hoja inferior mostrando los resultados. Puedes enviar todos los datos a Liquid Galaxy para visualización.';

  @override
  String get help_step4_title => 'Explorar Edificios';

  @override
  String get help_step4_description =>
      'Cambia a la pestaña de Edificios para ver detalles individuales de edificios, incluyendo códigos plus y puntuaciones de confianza.';

  @override
  String get help_confidence_title => 'Acerca de las Puntuaciones de Confianza';

  @override
  String get help_confidence_description =>
      'Cada edificio muestra una puntuación de confianza que indica qué tan confiables son los datos del conjunto de datos de Edificios Abiertos para esa estructura particular.';

  @override
  String get onboarding_lg_integration_title => 'Integración con Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Envía datos de edificios a Liquid Galaxy para una experiencia de visualización inmersiva';

  @override
  String get onboarding_explorer_title =>
      'Explorador de Edificios Abiertos de Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Explora las huellas de edificios en todo el mundo con visualización interactiva';

  @override
  String get onboarding_interactive_map_title => 'Mapa Interactivo';

  @override
  String get onboarding_interactive_map_description =>
      'Selecciona regiones para visualizar la densidad y huellas de edificios en tiempo real';

  @override
  String get onboarding_get_started => 'Comenzar';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get map_title => 'Edificios Abiertos';

  @override
  String get map_clear_selection_tooltip => 'Limpiar selección de edificio';

  @override
  String get map_search_hint => 'Buscar una ubicación';

  @override
  String get map_searching => 'Buscando...';

  @override
  String get map_search_no_results => 'No se encontraron resultados';

  @override
  String get map_search_failed =>
      'Búsqueda fallida. Por favor intenta de nuevo.';

  @override
  String get map_overlay_size_label => 'Tamaño de Superposición';

  @override
  String get map_loading_buildings => 'Cargando edificios...';

  @override
  String get map_building_details_title => 'Detalles del Edificio';

  @override
  String get map_building_area_label => 'Área:';

  @override
  String get map_building_confidence_label => 'Confianza:';

  @override
  String get map_building_points_label => 'Puntos:';

  @override
  String get map_building_center_label => 'Centro:';

  @override
  String get map_building_close => 'Cerrar';

  @override
  String get map_building_send_to_lg => 'Enviar a LG';

  @override
  String get map_lg_connected => 'LG Conectado';

  @override
  String get map_lg_disconnected => 'LG Desconectado';

  @override
  String get map_sending_building_to_lg => 'Enviando a Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg => 'Enviando región a Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      '¡Edificio enviado a Liquid Galaxy exitosamente!';

  @override
  String map_region_sent_success(int count) {
    return '¡Región con $count edificios enviada a Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Error al enviar edificio a LG: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Error al enviar región a LG: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Error al cargar edificios: $error';
  }

  @override
  String get map_connect_lg_first =>
      'Por favor conecta a Liquid Galaxy primero';

  @override
  String get map_connect_action => 'Conectar';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Alejamiento máximo alcanzado (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Acercamiento máximo alcanzado (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Edificio Seleccionado';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Área: $area m² • Confianza: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Cargando datos históricos...';

  @override
  String get settings_title => 'Configuración';

  @override
  String get settings_lg_configuration => 'Configuración de Liquid Galaxy';

  @override
  String get settings_visualization => 'Configuración de Visualización';

  @override
  String get settings_data => 'Configuración de Datos';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get lg_config_title => 'Configuración de Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Conexión';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Escanear Código QR';

  @override
  String get lg_config_manual_entry => 'O ingresar manualmente:';

  @override
  String get lg_config_ip_address => 'Dirección IP';

  @override
  String get lg_config_port => 'Puerto';

  @override
  String get lg_config_rigs => 'Equipos';

  @override
  String get lg_config_username => 'Usuario';

  @override
  String get lg_config_password => 'Contraseña';

  @override
  String get lg_config_connecting => 'Conectando...';

  @override
  String get lg_config_connect => 'Conectar';

  @override
  String get lg_config_connection_status => 'Estado de Conexión';

  @override
  String get lg_config_connect_first_message =>
      'Conecta a Liquid Galaxy primero para habilitar estas acciones.';

  @override
  String get lg_action_set_slaves_refresh =>
      'ESTABLECER ACTUALIZACIÓN DE ESCLAVOS';

  @override
  String get lg_action_reset_slaves_refresh =>
      'RESTABLECER ACTUALIZACIÓN DE ESCLAVOS';

  @override
  String get lg_action_clear_kml_logos => 'LIMPIAR KML + LOGOS';

  @override
  String get lg_action_relaunch => 'RELANZAR';

  @override
  String get lg_action_reboot => 'REINICIAR';

  @override
  String get lg_action_power_off => 'APAGAR';

  @override
  String get lg_status_connected => 'Conectado';

  @override
  String get lg_status_connecting => 'Conectando...';

  @override
  String get lg_status_error => 'Error';

  @override
  String get lg_status_disconnected => 'Desconectado';

  @override
  String get lg_confirm_title => 'Confirmar Acción';

  @override
  String get lg_confirm_cancel => 'Cancelar';

  @override
  String get lg_confirm_yes => 'Sí';

  @override
  String get lg_confirm_set_slaves_refresh =>
      '¿Estás seguro de que quieres establecer la actualización de esclavos?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      '¿Estás seguro de que quieres restablecer la actualización de esclavos?';

  @override
  String get lg_confirm_clear_kml_logos =>
      '¿Estás seguro de que quieres limpiar KML y logos?';

  @override
  String get lg_confirm_relaunch => '¿Estás seguro de que quieres relanzar LG?';

  @override
  String get lg_confirm_reboot => '¿Estás seguro de que quieres reiniciar LG?';

  @override
  String get lg_confirm_power_off => '¿Estás seguro de que quieres apagar LG?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'Estableciendo actualización de esclavos...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Restableciendo actualización de esclavos...';

  @override
  String get lg_action_clearing_kml_logos => 'Limpiando KML y logos...';

  @override
  String get lg_action_relaunching => 'Relanzando LG...';

  @override
  String get lg_action_rebooting => 'Reiniciando LG...';

  @override
  String get lg_action_powering_off => 'Apagando LG...';

  @override
  String get lg_action_success => '¡Acción completada exitosamente!';

  @override
  String lg_action_failed(String error) {
    return 'Acción fallida: $error';
  }

  @override
  String get form_required => 'Requerido';

  @override
  String get form_invalid_ip => 'IP inválida';

  @override
  String get form_invalid_number => 'Número inválido';

  @override
  String get qr_scan_title => 'Escanear Código QR';

  @override
  String get qr_invalid_data => 'Datos JSON del QR inválidos';

  @override
  String get qr_scanned_success_title => 'Código QR Escaneado Exitosamente';

  @override
  String get qr_credentials_found =>
      'Se encontraron las siguientes credenciales:';

  @override
  String get qr_proceed_question =>
      '¿Quieres proceder a conectarte a Liquid Galaxy usando estas credenciales?';

  @override
  String get qr_connect_button => 'Conectar';

  @override
  String get lg_connection_success =>
      '¡Conectado exitosamente a Liquid Galaxy! Logo mostrado.';

  @override
  String lg_connection_failed(String error) {
    return 'Conexión fallida: $error';
  }

  @override
  String get viz_settings_title => 'Configuración de Visualización';

  @override
  String get viz_confidence_threshold => 'Umbral de Confianza';

  @override
  String get viz_threshold_info =>
      'Establece el umbral mínimo de confianza para visualizar edificios obtenidos de la API. Umbrales más bajos muestran más edificios, pero pueden incluir resultados menos precisos.';

  @override
  String get data_settings_title => 'Configuración de Datos';

  @override
  String get data_source_version => 'Versión de Fuente de Datos';

  @override
  String get data_visualization_mode =>
      'Modo de Visualización (Híbrido/Oscuro)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Acerca de';

  @override
  String get about_app_title =>
      'Herramienta de Conjunto de Datos de Edificios Abiertos';

  @override
  String get about_app_description =>
      'Herramienta de visualización interactiva para el conjunto de datos de Edificios Abiertos de Google\ncon integración de Liquid Galaxy';

  @override
  String get about_version => 'Versión';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Fuente de Datos';

  @override
  String get about_data_source_value => 'Edificios Abiertos V3 de Google';

  @override
  String get about_project => 'Proyecto';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Fecha de Compilación';

  @override
  String get about_build_date_value => 'Enero 2025';

  @override
  String get about_developer => 'Desarrollador';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, India';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Correo';

  @override
  String get about_project_details => 'Acerca de este Proyecto';

  @override
  String get about_project_description =>
      'Esta aplicación integra el conjunto de datos de Edificios Abiertos de Google con capacidades de mapeo interactivo y visualización de Liquid Galaxy. Construida como parte de Google Summer of Code 2025 con la organización Liquid Galaxy.';

  @override
  String get about_key_features => 'Características Principales:';

  @override
  String get about_feature_1 =>
      'Visualización interactiva de huellas de edificios';

  @override
  String get about_feature_2 => 'Datos en tiempo real de Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Integración con Liquid Galaxy para experiencia inmersiva';

  @override
  String get about_feature_4 =>
      'Mapeo basado en cuadrícula con controles de zoom';

  @override
  String get about_feature_5 =>
      'Visualización de puntuación de confianza de edificios';

  @override
  String get about_view_repository => 'Ver Repositorio del Proyecto';

  @override
  String get about_open_buildings_dataset =>
      'Conjunto de Datos de Edificios Abiertos';

  @override
  String get about_liquid_galaxy => 'sobre la galaxia liquida';
}
