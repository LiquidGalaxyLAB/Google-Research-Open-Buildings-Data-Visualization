// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get help_title => 'Aide';

  @override
  String get help_app_title => 'Explorateur de Bâtiments Ouverts';

  @override
  String get help_app_description =>
      'Explorez les empreintes de bâtiments à travers le monde avec l\'intégration Liquid Galaxy';

  @override
  String get help_step1_title => 'Sélectionner la Zone de Carte';

  @override
  String get help_step1_description =>
      'Utilisez les contrôles sur le côté droit de la carte pour modifier et sélectionner la zone de tuiles que vous souhaitez explorer.';

  @override
  String get help_step2_title => 'Choisir une Tuile';

  @override
  String get help_step2_description =>
      'Cliquez sur une tuile spécifique dans votre zone sélectionnée pour obtenir les données de bâtiments du jeu de données Bâtiments Ouverts.';

  @override
  String get help_step3_title => 'Voir les Résultats';

  @override
  String get help_step3_description =>
      'Une fois les données récupérées, une feuille inférieure apparaîtra montrant les résultats. Vous pouvez envoyer toutes les données à Liquid Galaxy pour la visualisation.';

  @override
  String get help_step4_title => 'Explorer les Bâtiments';

  @override
  String get help_step4_description =>
      'Passez à l\'onglet Bâtiments pour voir les détails individuels des bâtiments, y compris les codes plus et les scores de confiance.';

  @override
  String get help_confidence_title => 'À propos des Scores de Confiance';

  @override
  String get help_confidence_description =>
      'Chaque bâtiment affiche un score de confiance qui indique la fiabilité des données du jeu de données Bâtiments Ouverts pour cette structure particulière.';

  @override
  String get onboarding_lg_integration_title => 'Intégration Liquid Galaxy';

  @override
  String get onboarding_lg_integration_description =>
      'Envoyez les données de bâtiments à Liquid Galaxy pour une expérience de visualisation immersive';

  @override
  String get onboarding_explorer_title =>
      'Explorateur de Bâtiments Ouverts Liquid Galaxy';

  @override
  String get onboarding_explorer_description =>
      'Explorez les empreintes de bâtiments à travers le monde avec une visualisation interactive';

  @override
  String get onboarding_interactive_map_title => 'Carte Interactive';

  @override
  String get onboarding_interactive_map_description =>
      'Sélectionnez des régions pour visualiser la densité et les empreintes de bâtiments en temps réel';

  @override
  String get onboarding_get_started => 'Commencer';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get map_title => 'Bâtiments Ouverts';

  @override
  String get map_clear_selection_tooltip => 'Effacer la sélection de bâtiment';

  @override
  String get map_search_hint => 'Rechercher un lieu';

  @override
  String get map_searching => 'Recherche en cours...';

  @override
  String get map_search_no_results => 'Aucun résultat trouvé';

  @override
  String get map_search_failed => 'Échec de la recherche. Veuillez réessayer.';

  @override
  String get map_overlay_size_label => 'Taille de Superposition';

  @override
  String get map_loading_buildings => 'Chargement des bâtiments...';

  @override
  String get map_building_details_title => 'Détails du Bâtiment';

  @override
  String get map_building_area_label => 'Surface :';

  @override
  String get map_building_confidence_label => 'Confiance :';

  @override
  String get map_building_points_label => 'Points :';

  @override
  String get map_building_center_label => 'Centre :';

  @override
  String get map_building_close => 'Fermer';

  @override
  String get map_building_send_to_lg => 'Envoyer à LG';

  @override
  String get map_lg_connected => 'LG Connecté';

  @override
  String get map_lg_disconnected => 'LG Déconnecté';

  @override
  String get map_sending_building_to_lg => 'Envoi vers Liquid Galaxy...';

  @override
  String get map_sending_region_to_lg =>
      'Envoi de la région vers Liquid Galaxy...';

  @override
  String get map_building_sent_success =>
      'Bâtiment envoyé avec succès à Liquid Galaxy !';

  @override
  String map_region_sent_success(int count) {
    return 'Région avec $count bâtiments envoyée à Liquid Galaxy !';
  }

  @override
  String map_building_send_failed(String error) {
    return 'Échec de l\'envoi du bâtiment vers LG : $error';
  }

  @override
  String map_region_send_failed(String error) {
    return 'Échec de l\'envoi de la région vers LG : $error';
  }

  @override
  String map_buildings_load_failed(String error) {
    return 'Échec du chargement des bâtiments : $error';
  }

  @override
  String get map_connect_lg_first =>
      'Veuillez d\'abord vous connecter à Liquid Galaxy';

  @override
  String get map_connect_action => 'Connecter';

  @override
  String map_zoom_out_limit(String zoom) {
    return 'Zoom arrière maximum atteint (${zoom}x)';
  }

  @override
  String map_zoom_in_limit(String zoom) {
    return 'Zoom avant maximum atteint (${zoom}x)';
  }

  @override
  String get map_selected_building_title => 'Bâtiment Sélectionné';

  @override
  String map_selected_building_info(String area, String confidence) {
    return 'Surface : $area m² • Confiance : $confidence%';
  }

  @override
  String get map_loading_historical_data =>
      'Chargement des données historiques...';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get settings_lg_configuration => 'Configuration Liquid Galaxy';

  @override
  String get settings_visualization => 'Paramètres de Visualisation';

  @override
  String get settings_data => 'Paramètres des Données';

  @override
  String get settings_about => 'À propos';

  @override
  String get lg_config_title => 'Configuration Liquid Galaxy';

  @override
  String get lg_config_connection_tab => 'Connexion';

  @override
  String get lg_config_lg_tab => 'Liquid Galaxy';

  @override
  String get lg_config_scan_qr => 'Scanner le Code QR';

  @override
  String get lg_config_manual_entry => 'Ou saisir manuellement :';

  @override
  String get lg_config_ip_address => 'Adresse IP';

  @override
  String get lg_config_port => 'Port';

  @override
  String get lg_config_rigs => 'Équipements';

  @override
  String get lg_config_username => 'Nom d\'utilisateur';

  @override
  String get lg_config_password => 'Mot de passe';

  @override
  String get lg_config_connecting => 'Connexion en cours...';

  @override
  String get lg_config_connect => 'Connecter';

  @override
  String get lg_config_connection_status => 'État de la Connexion';

  @override
  String get lg_config_connect_first_message =>
      'Connectez-vous d\'abord à Liquid Galaxy pour activer ces actions.';

  @override
  String get lg_action_set_slaves_refresh => 'DÉFINIR ACTUALISATION ESCLAVES';

  @override
  String get lg_action_reset_slaves_refresh =>
      'RÉINITIALISER ACTUALISATION ESCLAVES';

  @override
  String get lg_action_clear_kml_logos => 'EFFACER KML + LOGOS';

  @override
  String get lg_action_relaunch => 'RELANCER';

  @override
  String get lg_action_reboot => 'REDÉMARRER';

  @override
  String get lg_action_power_off => 'ÉTEINDRE';

  @override
  String get lg_status_connected => 'Connecté';

  @override
  String get lg_status_connecting => 'Connexion en cours...';

  @override
  String get lg_status_error => 'Erreur';

  @override
  String get lg_status_disconnected => 'Déconnecté';

  @override
  String get lg_confirm_title => 'Confirmer l\'Action';

  @override
  String get lg_confirm_cancel => 'Annuler';

  @override
  String get lg_confirm_yes => 'Oui';

  @override
  String get lg_confirm_set_slaves_refresh =>
      'Êtes-vous sûr de vouloir définir l\'actualisation des esclaves ?';

  @override
  String get lg_confirm_reset_slaves_refresh =>
      'Êtes-vous sûr de vouloir réinitialiser l\'actualisation des esclaves ?';

  @override
  String get lg_confirm_clear_kml_logos =>
      'Êtes-vous sûr de vouloir effacer KML et les logos ?';

  @override
  String get lg_confirm_relaunch => 'Êtes-vous sûr de vouloir relancer LG ?';

  @override
  String get lg_confirm_reboot => 'Êtes-vous sûr de vouloir redémarrer LG ?';

  @override
  String get lg_confirm_power_off => 'Êtes-vous sûr de vouloir éteindre LG ?';

  @override
  String get lg_action_setting_slaves_refresh =>
      'Définition de l\'actualisation des esclaves...';

  @override
  String get lg_action_resetting_slaves_refresh =>
      'Réinitialisation de l\'actualisation des esclaves...';

  @override
  String get lg_action_clearing_kml_logos =>
      'Effacement de KML et des logos...';

  @override
  String get lg_action_relaunching => 'Relancement de LG...';

  @override
  String get lg_action_rebooting => 'Redémarrage de LG...';

  @override
  String get lg_action_powering_off => 'Extinction de LG...';

  @override
  String get lg_action_success => 'Action terminée avec succès !';

  @override
  String lg_action_failed(String error) {
    return 'Échec de l\'action : $error';
  }

  @override
  String get form_required => 'Obligatoire';

  @override
  String get form_invalid_ip => 'IP invalide';

  @override
  String get form_invalid_number => 'Numéro invalide';

  @override
  String get qr_scan_title => 'Scanner le Code QR';

  @override
  String get qr_invalid_data => 'Données JSON QR invalides';

  @override
  String get qr_scanned_success_title => 'Code QR Scanné avec Succès';

  @override
  String get qr_credentials_found =>
      'Les identifiants suivants ont été trouvés :';

  @override
  String get qr_proceed_question =>
      'Voulez-vous procéder à la connexion à Liquid Galaxy en utilisant ces identifiants ?';

  @override
  String get qr_connect_button => 'Connecter';

  @override
  String get lg_connection_success =>
      'Connexion réussie à Liquid Galaxy ! Logo affiché.';

  @override
  String lg_connection_failed(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get viz_settings_title => 'Paramètres de Visualisation';

  @override
  String get viz_confidence_threshold => 'Seuil de Confiance';

  @override
  String get viz_threshold_info =>
      'Définissez le seuil de confiance minimum pour visualiser les bâtiments récupérés de l\'API. Des seuils plus bas affichent plus de bâtiments, mais peuvent inclure des résultats moins précis.';

  @override
  String get data_settings_title => 'Paramètres des Données';

  @override
  String get data_source_version => 'Version de la Source de Données';

  @override
  String get data_visualization_mode =>
      'Mode de Visualisation (Hybride/Sombre)';

  @override
  String get data_version_v3_2025 => 'V3 (2025)';

  @override
  String get about_title => 'À propos';

  @override
  String get about_app_title => 'Outil de Jeu de Données de Bâtiments Ouverts';

  @override
  String get about_app_description =>
      'Outil de visualisation interactive pour le jeu de données Bâtiments Ouverts de Google\navec intégration Liquid Galaxy';

  @override
  String get about_version => 'Version';

  @override
  String get about_version_number => '1.0.0';

  @override
  String get about_data_source => 'Source de Données';

  @override
  String get about_data_source_value => 'Google Bâtiments Ouverts V3';

  @override
  String get about_project => 'Projet';

  @override
  String get about_project_value => 'GSoC 2025 - Liquid Galaxy';

  @override
  String get about_build_date => 'Date de Compilation';

  @override
  String get about_build_date_value => 'Janvier 2025';

  @override
  String get about_developer => 'Développeur';

  @override
  String get about_developer_name => 'Jaivardhan Shukla';

  @override
  String get about_developer_location => 'VNIT Nagpur, Inde';

  @override
  String get about_github => 'GitHub';

  @override
  String get about_linkedin => 'LinkedIn';

  @override
  String get about_email => 'Email';

  @override
  String get about_project_details => 'À propos de ce Projet';

  @override
  String get about_project_description =>
      'Cette application intègre le jeu de données Bâtiments Ouverts de Google avec des capacités de cartographie interactive et de visualisation Liquid Galaxy. Construite dans le cadre de Google Summer of Code 2025 avec l\'organisation Liquid Galaxy.';

  @override
  String get about_key_features => 'Fonctionnalités Clés :';

  @override
  String get about_feature_1 =>
      'Visualisation interactive des empreintes de bâtiments';

  @override
  String get about_feature_2 => 'Données en temps réel de Google Earth Engine';

  @override
  String get about_feature_3 =>
      'Intégration Liquid Galaxy pour une expérience immersive';

  @override
  String get about_feature_4 =>
      'Cartographie basée sur une grille avec contrôles de zoom';

  @override
  String get about_feature_5 =>
      'Visualisation du score de confiance des bâtiments';

  @override
  String get about_view_repository => 'Voir le Dépôt du Projet';

  @override
  String get about_open_buildings_dataset => 'Jeu de Données Bâtiments Ouverts';

  @override
  String get about_liquid_galaxy => 'Liquid Galaxy';
}
