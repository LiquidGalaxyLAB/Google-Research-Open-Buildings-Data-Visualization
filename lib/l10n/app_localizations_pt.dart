// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get help_title => 'Ajuda';

  @override
  String get help_app_title => 'Explorador de Edifícios Abertos';

  @override
  String get help_app_description =>
      'Explore pegadas de edifícios ao redor do mundo com integração Liquid Galaxy';

  @override
  String get help_step1_title => 'Selecionar Área do Mapa';

  @override
  String get help_step1_description =>
      'Use os controles no lado direito do mapa para modificar e selecionar a área de azulejos que deseja explorar.';

  @override
  String get help_step2_title => 'Escolher um Azulejo';

  @override
  String get help_step2_description =>
      'Clique em um azulejo específico dentro da sua área selecionada para buscar dados de edifícios do conjunto de dados de Edifícios Abertos.';

  @override
  String get help_step3_title => 'Ver Resultados';

  @override
  String get help_step3_description =>
      'Após os dados serem obtidos, uma folha inferior aparecerá mostrando os resultados. Você pode enviar todos os dados para o Liquid Galaxy para visualização.';

  @override
  String get help_step4_title => 'Explorar Edifícios';

  @override
  String get help_step4_description =>
      'Mude para a aba Edifícios para ver detalhes individuais dos edifícios, incluindo códigos plus e pontuações de confiança.';

  @override
  String get help_confidence_title => 'Sobre Pontuações de Confiança';

  @override
  String get help_confidence_description =>
      'Cada edifício mostra uma pontuação de confiança que indica quão confiáveis são os dados do conjunto de dados de Edifícios Abertos para essa estrutura específica.';

  @override
  String get onboarding_lg_integration_title => 'Integração Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Envie dados de edifícios para o Liquid Galaxy para uma experiência de visualização imersiva';

  @override
  String get onboarding_explorer_title =>
      'Explorador de Edifícios Abertos Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Explore pegadas de edifícios ao redor do mundo com visualização interativa';

  @override
  String get onboarding_interactive_map_title => 'Mapa Interativo';

  @override
  String get onboarding_interactive_map_description =>
      'Selecione regiões para visualizar densidade e pegadas de edifícios em tempo real';

  @override
  String get onboarding_get_started => 'Começar';

  @override
  String get onboarding_next => 'Próximo';

  @override
  String get map_title => 'Edifícios Abertos';

  @override
  String get map_clear_selection_tooltip => 'Limpar seleção de edifício';

  @override
  String get map_search_hint => 'Procurar uma localização';

  @override
  String get map_searching => 'Procurando...';

  @override
  String get map_search_no_results => 'Nenhum resultado encontrado';

  @override
  String get map_search_failed => 'Busca falhou. Tente novamente.';

  @override
  String get map_overlay_size_label => 'Tamanho da Sobreposição';

  @override
  String get map_loading_buildings => 'Carregando edifícios...';

  @override
  String get map_building_details_title => 'Detalhes do Edifício';

  @override
  String get map_building_area_label => 'Área:';

  @override
  String get map_building_confidence_label => 'Confiança:';

  @override
  String get map_building_points_label => 'Pontos:';

  @override
  String get map_building_center_label => 'Centro:';

  @override
  String get map_building_close => 'Fechar';

  @override
  String get map_building_send_to_lg => 'Enviar para LG';

  @override
  String get map_lg_connected => 'LG Conectado';

  @override
  String get map_lg_disconnected => 'LG Desconectado';

  @override
  String get map_sending_building_to_lg => 'Enviando para Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg =>
      'Enviando região para Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Edifício enviado para Liquid Galaxy com sucesso!';

  @override
  String map_region_sent_success(int count) {
    return 'Região com $count edifícios enviada para Liquid Galaxy!';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Falha ao enviar edifício para LG: $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Falha ao enviar região para LG: $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Falha ao carregar edifícios: $error';
  }

  @override
  String get map_connect_lg_first =>
      'Por favor conecte ao Liquid Galaxy primeiro';

  @override
  String get map_connect_action => 'Conectar';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Limite máximo de zoom out atingido (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Limite máximo de zoom in atingido (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Edifício Selecionado';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Área: $area m² • Confiança: $confidence%';
  }

  @override
  String get map_loading_historical_data => 'Carregando dados históricos...';

  @override
  String get settings_title => 'Configurações';

  @override
  String get settings_lg_configuration => 'Configuração Liquid Galaxy';

  @override
  String get settings_visualization => 'Configurações de Visualização';

  @override
  String get settings_data => 'Configurações de Dados';

  @override
  String get settings_about => 'Sobre';

  @override
  String get lg_config_title => 'Configuração Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Conexão';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Escanear Código QR';

  @override
  String get lg_config_manual_entry => 'Ou inserir manualmente:';

  @override
  String get lg_config_ip_address => 'Endereço IP';

  @override
  String get lg_config_port => 'Porta';

  @override
  String get lg_config_rigs => 'Equipamentos';

  @override
  String get lg_config_username => 'Nome de usuário';

  @override
  String get lg_config_password => 'Senha';

  @override
  String get lg_config_connecting => 'Conectando...';

  @override
  String get lg_config_connect => 'Conectar';

  @override
  String get lg_config_connection_status => 'Status da Conexão';

  @override
  String get lg_config_connect_first_message =>
      'Conecte ao Liquid Galaxy primeiro para habilitar essas ações.';

  @override
  String get lg_action_set_slaves_refresh => 'DEFINIR ATUALIZAÇÃO ESCRAVOS';

  @override
  String get lg_action_reset_slaves_refresh => 'RESETAR ATUALIZAÇÃO ESCRAVOS';

  @override
  String get lg_action_clear_kml_logos => 'LIMPAR KML + LOGOS';

  @override
  String get lg_action_relaunch => 'RELANÇAR';

  @override
  String get lg_action_reboot => 'REINICIAR';

  @override
  String get lg_action_power_off => 'DESLIGAR';

  @override
  String get lg_status_connected => 'Conectado';

  @override
  String get lg_status_connecting => 'Conectando...';

  @override
  String get lg_status_error => 'Erro';

  @override
  String get lg_status_disconnected => 'Desconectado';

  @override
  String get lg_confirm_title => 'Confirmar Ação';

  @override
  String get lg_confirm_cancel => 'Cancelar';

  @override
  String get lg_confirm_yes => 'Sim';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Tem certeza de que deseja definir atualização de escravos?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Tem certeza de que deseja resetar atualização de escravos?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Tem certeza de que deseja limpar KML e logos?';

  @override
  String get lg_confirm_relaunch => 'Tem certeza de que deseja relançar LG?';

  @override
  String get lg_confirm_reboot => 'Tem certeza de que deseja reiniciar LG?';

  @override
  String get lg_confirm_power_off => 'Tem certeza de que deseja desligar LG?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'Definindo atualização de escravos...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Resetando atualização de escravos...';

  @override
  String get lg_action_clearing_kml_logos => 'Limpando KML e logos...';

  @override
  String get lg_action_relaunching => 'Relançando LG...';

  @override
  String get lg_action_rebooting => 'Reiniciando LG...';

  @override
  String get lg_action_powering_off => 'Desligando LG...';

  @override
  String get lg_action_success => 'Ação concluída com sucesso!';

  @override
  String lg_action_failed(String error) {
    return 'Ação falhou: $error';
  }

  @override
  String get form_required => 'Obrigatório';

  @override
  String get form_invalid_ip => 'IP inválido';

  @override
  String get form_invalid_number => 'Número inválido';

  @override
  String get qr_scan_title => 'Escanear Código QR';

  @override
  String get qr_invalid_data => 'Dados JSON QR inválidos';

  @override
  String get qr_scanned_success_title => 'Código QR Escaneado com Sucesso';

  @override
  String get qr_credentials_found =>
      'As seguintes credenciais foram encontradas:';

  @override
  String get qr_proceed_question =>
      'Deseja prosseguir com a conexão ao Liquid Galaxy usando essas credenciais?';

  @override
  String get qr_connect_button => 'Conectar';

  @override
  String get lg_connection_success =>
      'Conectado com sucesso ao Liquid Galaxy! Logo exibido.';

  @override
  String lg_connection_failed(String error) {
    return 'Conexão falhou: $error';
  }

  @override
  String get viz_settings_title => 'Configurações de Visualização';

  @override
  String get viz_confidence_threshold => 'Limite de Confiança';

  @override
  String get viz_threshold_info =>
      'Defina o limite mínimo de confiança para visualizar edifícios obtidos da API. Limites mais baixos mostram mais edifícios, mas podem incluir resultados menos precisos.';

  @override
  String get data_settings_title => 'Configurações de Dados';

  @override
  String get data_source_version => 'Versão da Fonte de Dados';

  @override
  String get data_visualization_mode => 'Modo de Visualização (Híbrido/Escuro)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'Sobre';

  @override
  String get about_app_title =>
      'Ferramenta de Conjunto de Dados de Edifícios Abertos';

  @override
  String get about_app_description =>
      'Ferramenta de visualização interativa para o conjunto de dados de Edifícios Abertos do Google\ncom integração Liquid Galaxy';

  @override
  String get about_version => 'Versão';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Fonte de Dados';

  @override
  String get about_data_source_value => 'Google Edifícios Abertos V3';

  @override
  String get about_project => 'Projeto';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Data de Construção';

  @override
  String get about_build_date_value => 'Janeiro 2025';

  @override
  String get about_developer => 'Desenvolvedor';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, Índia';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Email';

  @override
  String get about_project_details => 'Sobre Este Projeto';

  @override
  String get about_project_description =>
      'Esta aplicação integra o conjunto de dados de Edifícios Abertos do Google com capacidades de mapeamento interativo e visualização Liquid Galaxy. Construída como parte do Google Summer of Code 2025 com a organização Liquid Galaxy.';

  @override
  String get about_key_features => 'Recursos Principais:';

  @override
  String get about_feature_1 =>
      'Visualização interativa de pegadas de edifícios';

  @override
  String get about_feature_2 => 'Dados em tempo real do Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Integração Liquid Galaxy para experiência imersiva';

  @override
  String get about_feature_4 =>
      'Mapeamento baseado em grade com controles de zoom';

  @override
  String get about_feature_5 =>
      'Visualização de pontuação de confiança de edifícios';

  @override
  String get about_view_repository => 'Ver Repositório do Projeto';

  @override
  String get about_open_buildings_dataset =>
      'Conjunto de Dados de Edifícios Abertos';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
