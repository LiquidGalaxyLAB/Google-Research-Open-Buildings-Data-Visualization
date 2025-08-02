// ui/settings_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/language_selector.dart';
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../services/lg_service.dart';
import '../providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.settings_title,  // CHANGED: 'Settings' → localized
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          // ADD THIS: Language selector at the top
          const LanguageSelector(),

          // ADD THIS: Visual separator
          Divider(color: AppColors.outline),

          // CHANGED: All hardcoded strings → localized
          _buildSettingsItem(
            icon: Icons.settings_applications_outlined,
            title: localizations.settings_lg_configuration,  // CHANGED
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LiquidGalaxyConfigScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.visibility_outlined,
            title: localizations.settings_visualization,  // CHANGED
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VisualizationSettingsScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.data_usage_outlined,
            title: localizations.settings_data,  // CHANGED
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DataSettingsScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: localizations.settings_about,  // CHANGED
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AboutScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(
        title,
        style: TextStyle(color: AppColors.onSurface),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.outline),
      onTap: onTap,
    );
  }
}

class LiquidGalaxyConfigScreen extends StatefulWidget {
  const LiquidGalaxyConfigScreen({Key? key}) : super(key: key);

  @override
  _LiquidGalaxyConfigScreenState createState() => _LiquidGalaxyConfigScreenState();
}

class _LiquidGalaxyConfigScreenState extends State<LiquidGalaxyConfigScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() {
    final lgService = Provider.of<LGService>(context, listen: false);
    _ipController.text = lgService.host ?? '';
    _portController.text = lgService.port ?? '';
    _rigsController.text = lgService.numberOfRigs ?? '';
    _usernameController.text = lgService.username ?? '';
    _passwordController.text = lgService.password ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _rigsController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.lg_config_title,  // CHANGED: 'Liquid Galaxy Configuration' → localized
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.onPrimary,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withOpacity(0.7),
          tabs: [
            Tab(text: localizations.lg_config_connection_tab),  // CHANGED: 'Connection' → localized
            Tab(text: localizations.lg_config_lg_tab),          // CHANGED: 'Liquid Galaxy' → localized
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConnectionTab(),
          _buildLiquidGalaxyTab(),
        ],
      ),
    );
  }

  Widget _buildConnectionTab() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectionStatus(),
            const SizedBox(height: 16),

            // QR Scan Button
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(localizations.lg_config_scan_qr),  // CHANGED: 'Scan QR Code' → localized
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _scanQRCode,
            ),

            const SizedBox(height: 16),
            Divider(color: AppColors.outline),
            const SizedBox(height: 16),

            // Manual entry section
            Text(
              localizations.lg_config_manual_entry,  // CHANGED: 'Or enter manually:' → localized
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: localizations.lg_config_ip_address,  // CHANGED: 'IP Address' → localized
              controller: _ipController,
              validator: _validateIP,
            ),
            _buildTextField(
              label: localizations.lg_config_port,  // CHANGED: 'Port' → localized
              controller: _portController,
              keyboardType: TextInputType.number,
              validator: _validateNumber,
            ),
            _buildTextField(
              label: localizations.lg_config_rigs,  // CHANGED: 'Rigs' → localized
              controller: _rigsController,
              keyboardType: TextInputType.number,
              validator: _validateNumber,
            ),
            _buildTextField(
              label: localizations.lg_config_username,  // CHANGED: 'Username' → localized
              controller: _usernameController,
            ),
            _buildTextField(
              label: localizations.lg_config_password,  // CHANGED: 'Password' → localized
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<LGService>(
              builder: (context, lgService, child) {
                return ElevatedButton.icon(
                  icon: lgService.isConnecting
                      ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                    ),
                  )
                      : const Icon(Icons.connect_without_contact),
                  label: Text(lgService.isConnecting
                      ? localizations.lg_config_connecting     // CHANGED: 'Connecting...' → localized
                      : localizations.lg_config_connect),     // CHANGED: 'Connect' → localized
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: lgService.isConnecting ? null : _connectToLiquidGalaxy,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidGalaxyTab() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<LGService>(
        builder: (context, lgService, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConnectionStatus(),
              const SizedBox(height: 16),

              // Set Slaves Refresh
              _buildActionButton(
                localizations.lg_action_set_slaves_refresh,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_set_slaves_refresh)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_setting_slaves_refresh, lgService.setSlavesRefresh);  // CHANGED: Localized
                  }
                } : null,
              ),

              _buildActionButton(
                localizations.lg_action_reset_slaves_refresh,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_reset_slaves_refresh)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_resetting_slaves_refresh, lgService.resetSlavesRefresh);  // CHANGED: Localized
                  }
                } : null,
              ),

              _buildActionButton(
                localizations.lg_action_clear_kml_logos,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_clear_kml_logos)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_clearing_kml_logos, lgService.clearKMLAndLogos);  // CHANGED: Localized
                  }
                } : null,
              ),

              _buildActionButton(
                localizations.lg_action_relaunch,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_relaunch)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_relaunching, lgService.relaunchLG);  // CHANGED: Localized
                  }
                } : null,
              ),

              _buildActionButton(
                localizations.lg_action_reboot,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_reboot)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_rebooting, lgService.rebootLG);  // CHANGED: Localized
                  }
                } : null,
              ),

              _buildActionButton(
                localizations.lg_action_power_off,  // CHANGED: Localized
                lgService.isConnected ? () async {
                  if (await showConfirmationDialog(context, localizations.lg_confirm_power_off)) {  // CHANGED: Localized
                    await _executeAction(localizations.lg_action_powering_off, lgService.powerOffLG);  // CHANGED: Localized
                  }
                } : null,
              ),

              if (!lgService.isConnected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    localizations.lg_config_connect_first_message,  // CHANGED: Localized
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _executeAction(String message, Future<void> Function() action) async {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(width: 16),
              Text(
                message,  // This is already localized from the calling function
                style: TextStyle(color: AppColors.onSurface),
              ),
            ],
          ),
        );
      },
    );

    try {
      await action();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.lg_action_success,  // CHANGED: 'Action completed successfully!' → localized
              style: TextStyle(color: AppColors.onPrimary),
            ),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.lg_action_failed(e.toString()),  // CHANGED: Parameterized error → localized
              style: TextStyle(color: AppColors.onError),
            ),
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Widget _buildActionButton(String text, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: onPressed != null ? AppColors.primary : AppColors.surfaceDim,
          foregroundColor: onPressed != null ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Consumer<LGService>(
      builder: (context, lgService, child) {
        return Row(
          children: [
            Text(
              localizations.lg_config_connection_status,  // CHANGED: 'Connection Status' → localized
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                // Refresh connection status when tapped
                await lgService.checkConnection();
              },
              child: Chip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getStatusText(lgService.status),
                      style: TextStyle(
                        color: _getStatusColor(lgService.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.refresh,
                      size: 14,
                      color: _getStatusColor(lgService.status),
                    ),
                  ],
                ),
                backgroundColor: _getStatusBackgroundColor(lgService.status),
                avatar: CircleAvatar(
                  radius: 6,
                  backgroundColor: _getStatusColor(lgService.status),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusText(LGConnectionStatus status) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    switch (status) {
      case LGConnectionStatus.connected:
        return localizations.lg_status_connected;    // CHANGED: 'Connected' → localized
      case LGConnectionStatus.connecting:
        return localizations.lg_status_connecting;   // CHANGED: 'Connecting...' → localized
      case LGConnectionStatus.error:
        return localizations.lg_status_error;        // CHANGED: 'Error' → localized
      case LGConnectionStatus.disconnected:
      default:
        return localizations.lg_status_disconnected; // CHANGED: 'Disconnected' → localized
    }
  }

  Color _getStatusColor(LGConnectionStatus status) {
    switch (status) {
      case LGConnectionStatus.connected:
        return Colors.green;
      case LGConnectionStatus.connecting:
        return Colors.orange;
      case LGConnectionStatus.error:
        return AppColors.error;
      case LGConnectionStatus.disconnected:
      default:
        return AppColors.outline;
    }
  }

  Color _getStatusBackgroundColor(LGConnectionStatus status) {
    switch (status) {
      case LGConnectionStatus.connected:
        return Colors.green.withOpacity(0.1);
      case LGConnectionStatus.connecting:
        return Colors.orange.withOpacity(0.1);
      case LGConnectionStatus.error:
        return AppColors.errorContainer;
      case LGConnectionStatus.disconnected:
      default:
        return AppColors.surfaceContainer;
    }
  }

  Future<bool> showConfirmationDialog(BuildContext context, String message) async {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          localizations.lg_confirm_title,  // CHANGED: 'Confirm Action' → localized
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: Text(
          message,  // This is already localized from the calling function
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              localizations.lg_confirm_cancel,  // CHANGED: 'Cancel' → localized
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: Text(localizations.lg_confirm_yes),  // CHANGED: 'Yes' → localized
          ),
        ],
      ),
    );
    return result == true;
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscureText : false,
        style: TextStyle(color: AppColors.onSurface),
        decoration: InputDecoration(
          labelText: label,  // This is already localized from calling function
          labelStyle: TextStyle(color: AppColors.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        onChanged: (value) {
          // Auto-save when user types
          _saveCredentials();
        },
      ),
    );
  }

  String? _validateIP(String? v) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    if (v == null || v.isEmpty) return localizations.form_required;      // CHANGED: 'Required' → localized
    final regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    return regex.hasMatch(v) ? null : localizations.form_invalid_ip;     // CHANGED: 'Invalid IP' → localized
  }

  String? _validateNumber(String? v) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    if (v == null || v.isEmpty) return localizations.form_required;       // CHANGED: 'Required' → localized
    return int.tryParse(v) != null ? null : localizations.form_invalid_number;  // CHANGED: 'Invalid number' → localized
  }

  Future<void> _saveCredentials() async {
    final lgService = Provider.of<LGService>(context, listen: false);
    await lgService.saveConnectionDetails(
      host: _ipController.text,
      port: _portController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      numberOfRigs: _rigsController.text,
    );
  }

  // UPDATED: Modified QR scan method to automatically populate and connect
  Future<void> _scanQRCode() async {
    final localizations = AppLocalizations.of(context)!;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (result is Map<String, dynamic>) {
      // Convert dynamic map to string map for safety
      final Map<String, String> credentials = {
        'ip': result['ip']?.toString() ?? '',
        'port': result['port']?.toString() ?? '',
        'rigs': result['rigs']?.toString() ?? '',
        'user': result['user']?.toString() ?? '',
        'pass': result['pass']?.toString() ?? '',
      };

      // Show a brief success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.qr_scanned_success_title,
            style: TextStyle(color: AppColors.onPrimary),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Automatically populate the text fields
      setState(() {
        _ipController.text = credentials['ip'] ?? '';
        _portController.text = credentials['port'] ?? '';
        _rigsController.text = credentials['rigs'] ?? '';
        _usernameController.text = credentials['user'] ?? '';
        _passwordController.text = credentials['pass'] ?? '';
      });

      // Automatically attempt connection
      _connectToLiquidGalaxy();
    }
  }

  void _connectToLiquidGalaxy() async {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS
    final lgService = Provider.of<LGService>(context, listen: false);

    // Save credentials first
    await lgService.saveConnectionDetails(
      host: _ipController.text,
      port: _portController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      numberOfRigs: _rigsController.text,
    );

    // Attempt connection
    bool success = await lgService.connect();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.lg_connection_success,  // CHANGED: 'Successfully connected...' → localized
              style: TextStyle(color: AppColors.onPrimary),
            ),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.lg_connection_failed(lgService.errorMessage ?? 'Unknown error'),  // CHANGED: Parameterized error → localized
              style: TextStyle(color: AppColors.onError),
            ),
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}

// QR Scanner Screen - Updated for auto-connection
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _hasScanned = false; // Prevent multiple scans

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    final localizations = AppLocalizations.of(context)!;

    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      // Prevent multiple scans
      if (_hasScanned) return;
      _hasScanned = true;

      final data = scanData.code;
      try {
        final map = json.decode(data ?? '') as Map<String, dynamic>;

        // Pause the camera to prevent further scanning
        controller?.pauseCamera();

        // Return the parsed data immediately
        Navigator.of(context).pop(map);
      } catch (e) {
        // Reset the scan flag if there's an error
        _hasScanned = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.qr_invalid_data,
              style: TextStyle(color: AppColors.onError),
            ),
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          localizations.qr_scan_title,
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.primary,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Text(
              'Point your camera at the QR code to scan', // Can add this to localizations if needed
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Visualization Settings Screen - Localized
class VisualizationSettingsScreen extends StatefulWidget {
  const VisualizationSettingsScreen({Key? key}) : super(key: key);

  @override
  _VisualizationSettingsScreenState createState() => _VisualizationSettingsScreenState();
}

class _VisualizationSettingsScreenState extends State<VisualizationSettingsScreen> {
  double _confidenceThreshold = 65.0;
  bool _showBuildingLabels = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _confidenceThreshold = prefs.getDouble('confidence_threshold') ?? 70.0;
      _showBuildingLabels = prefs.getBool('show_building_labels') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('confidence_threshold', _confidenceThreshold);
    await prefs.setBool('show_building_labels', _showBuildingLabels);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.viz_settings_title,  // CHANGED: 'Visualization Settings' → localized
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSliderSetting(
              localizations.viz_confidence_threshold,  // CHANGED: 'Confidence Threshold' → localized
              _confidenceThreshold,
                  (value) {
                setState(() {
                  _confidenceThreshold = value;
                });
                _savePreferences();
              },
            ),

            const SizedBox(height: 16),

            Card(
              color: AppColors.primaryContainer.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        localizations.viz_threshold_info,  // CHANGED: Long description → localized
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting(String title, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,  // This is already localized from calling function
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '${value.toInt()}%',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.outlineVariant,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 65.0,
              max: 100.0,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// Data Settings Screen - Localized
class DataSettingsScreen extends StatefulWidget {
  const DataSettingsScreen({Key? key}) : super(key: key);

  @override
  _DataSettingsScreenState createState() => _DataSettingsScreenState();
}

class _DataSettingsScreenState extends State<DataSettingsScreen> {
  bool _autoRefreshData = false;
  String _dataSourceVersion = 'V3 (2025)';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoRefreshData = prefs.getBool('auto_refresh_data') ?? false;
      _dataSourceVersion = prefs.getString('data_source_version') ?? 'V3 (2025)';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_refresh_data', _autoRefreshData);
    await prefs.setString('data_source_version', _dataSourceVersion);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.data_settings_title,  // CHANGED: 'Data Settings' → localized
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoSetting(
                localizations.data_source_version,     // CHANGED: 'Data Source Version' → localized
                localizations.data_version_v3_2025),   // CHANGED: 'V3 (2025)' → localized
            _buildSwitchSetting(
              localizations.data_visualization_mode,   // CHANGED: 'Visualization Mode...' → localized
              _autoRefreshData,
                  (value) {
                setState(() {
                  _autoRefreshData = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,  // This is already localized from calling function
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withOpacity(0.3),
          inactiveThumbColor: AppColors.outline,
          inactiveTrackColor: AppColors.outlineVariant,
        ),
      ],
    );
  }

  Widget _buildInfoSetting(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,  // This is already localized from calling function
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            value,  // This is already localized from calling function
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// About Screen - Localized
class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool _isDarkMode = false;

  _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 30.0,
              color: AppColors.onBackground,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 5, top: 80),
                child: Text(
                  localizations.about_title,  // CHANGED: 'About' → localized
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: AppColors.onBackground,
                  ),
                ),
              ),

              // App Logo/Icon
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: Image.asset('assets/logos/logo.png')
                ),
              ),

              // App Title
              Text(
                localizations.about_app_title,  // CHANGED: 'Open Buildings Dataset Tool' → localized
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.onBackground,
                ),
              ),

              const SizedBox(height: 10),

              // App Description
              Text(
                localizations.about_app_description,  // CHANGED: Description → localized
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              // Version Info Card
              _buildInfoCard(),

              const SizedBox(height: 20),

              // Developer Section
              _buildDeveloperSection(),

              const SizedBox(height: 20),

              // Project Details Section
              _buildProjectDetailsSection(),

              const SizedBox(height: 20),

              // Placeholder for splash image
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/splash_kml.png'),
                ),
              ),

              const SizedBox(height: 30),

              // Action Buttons
              _buildActionButtons(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(localizations.about_version, localizations.about_version_number, Icons.info_outline),          // CHANGED: Localized
          Divider(height: 20, color: AppColors.outline),
          _buildInfoRow(localizations.about_data_source, localizations.about_data_source_value, Icons.dataset),       // CHANGED: Localized
          Divider(height: 20, color: AppColors.outline),
          _buildInfoRow(localizations.about_project, localizations.about_project_value, Icons.code),                  // CHANGED: Localized
          Divider(height: 20, color: AppColors.outline),
          _buildInfoRow(localizations.about_build_date, localizations.about_build_date_value, Icons.calendar_today),  // CHANGED: Localized
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,  // This is already localized from calling function
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                value,  // This is already localized from calling function
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperSection() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.about_developer,  // CHANGED: 'Developer' → localized
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            localizations.about_developer_name,  // CHANGED: 'Jaivardhan Shukla' → localized
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            localizations.about_developer_location,  // CHANGED: 'VNIT Nagpur, India' → localized
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(localizations.about_github, 'https://github.com/jaivsh', Icons.code),         // CHANGED: Localized
              _buildSocialButton(localizations.about_linkedin, 'https://www.linkedin.com/in/jaivardhan-shukla', Icons.work),  // CHANGED: Localized
              _buildSocialButton(localizations.about_email, 'mailto:akojoel60@gmail.com', Icons.email),        // CHANGED: Localized
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String label, String url, IconData icon) {
    return GestureDetector(
      onTap: () => _launchURL(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              label,  // This is already localized from calling function
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsSection() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.about_project_details,  // CHANGED: 'About this Project' → localized
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            localizations.about_project_description,  // CHANGED: Long description → localized
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          _buildFeatureList(),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    final features = [
      localizations.about_feature_1,  // CHANGED: All features → localized
      localizations.about_feature_2,
      localizations.about_feature_3,
      localizations.about_feature_4,
      localizations.about_feature_5,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.about_key_features,  // CHANGED: 'Key Features:' → localized
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,  // This is already localized
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons() {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(Uri.parse('https://github.com/jaivsh')),
            icon: const Icon(Icons.open_in_new, size: 20),
            label: Text(localizations.about_view_repository),  // CHANGED: 'View Project Repository' → localized
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _launchURL(Uri.parse('https://developers.google.com/earth-engine/datasets/catalog/GOOGLE_Research_open-buildings_v3_polygons')),
                icon: const Icon(Icons.dataset, size: 18),
                label: Text(localizations.about_open_buildings_dataset),  // CHANGED: 'Open Buildings Dataset' → localized
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _launchURL(Uri.parse('https://www.liquidgalaxy.eu/')),
                icon: const Icon(Icons.public, size: 18),
                label: Text(localizations.about_liquid_galaxy),  // CHANGED: 'Liquid Galaxy' → localized
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunchUrl(Uri.parse(link.url))) {
      await launchUrl(Uri.parse(link.url));
    } else {
      throw 'Could not launch $link';
    }
  }
}