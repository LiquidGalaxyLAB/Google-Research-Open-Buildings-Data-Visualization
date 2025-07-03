import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            icon: Icons.settings_applications_outlined,
            title: 'Liquid Galaxy Configuration',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LiquidGalaxyConfigScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.visibility_outlined,
            title: 'Visualization Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VisualizationSettingsScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.data_usage_outlined,
            title: 'Data Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DataSettingsScreen(),
              ),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: 'About',
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
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
  bool isConnected = false;

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('lg_ip') ?? '';
      _portController.text = prefs.getString('lg_port') ?? '';
      _rigsController.text = prefs.getString('lg_rigs') ?? '';
      _usernameController.text = prefs.getString('lg_user') ?? '';
      _passwordController.text = prefs.getString('lg_pass') ?? '';
      isConnected = prefs.getBool('lg_connected') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lg_ip', _ipController.text);
    await prefs.setString('lg_port', _portController.text);
    await prefs.setString('lg_rigs', _rigsController.text);
    await prefs.setString('lg_user', _usernameController.text);
    await prefs.setString('lg_pass', _passwordController.text);
    await prefs.setBool('lg_connected', isConnected);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Liquid Galaxy Configuration',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: 'Connection'), Tab(text: 'Liquid Galaxy')],
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
              label: const Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
              onPressed: _scanQRCode,
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Manual entry section
            const Text(
              'Or enter manually:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            _buildTextField(label: 'IP Address', controller: _ipController, validator: _validateIP),
            _buildTextField(label: 'Port', controller: _portController, keyboardType: TextInputType.number,  validator: _validateNumber),
            _buildTextField(label: 'Rigs', controller: _rigsController, keyboardType: TextInputType.number, validator: _validateNumber),
            _buildTextField(label: 'Username', controller: _usernameController),
            _buildTextField(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.connect_without_contact),
              label: const Text('Connect'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _connectToLiquidGalaxy,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiquidGalaxyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectionStatus(),
          const SizedBox(height: 16),
          ...['SET SLAVES REFRESH', 'RESET SLAVES REFRESH', 'CLEAR KML + LOGOS', 'RELAUNCH', 'REBOOT', 'POWER OFF']
              .map((t) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ElevatedButton(
              onPressed: isConnected ? () {
                // implement action
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$t executed')));
              } : null,
              child: Text(t),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            ),
          ))
              .toList(),
          if (!isConnected)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Connect to Liquid Galaxy first to enable these actions.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Row(
      children: [
        const Text('Connection Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        Chip(
          label: Text(isConnected ? 'Connected' : 'Disconnected'),
          backgroundColor: isConnected ? Colors.green[100] : Colors.red[100],
          avatar: CircleAvatar(
            radius: 6,
            backgroundColor: isConnected ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
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
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        onChanged: (value) {
          // Auto-save when user types
          _savePreferences();
        },
      ),
    );
  }

  String? _validateIP(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    return regex.hasMatch(v) ? null : 'Invalid IP';
  }

  String? _validateNumber(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    return int.tryParse(v) != null ? null : 'Invalid number';
  }

  Future<void> _scanQRCode() async {
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

      // Show confirmation dialog
      _showCredentialsConfirmationDialog(credentials);
    }
  }

  void _showCredentialsConfirmationDialog(Map<String, String> credentials) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'QR Code Scanned Successfully',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The following credentials were found:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                _buildCredentialRow('IP Address', credentials['ip'] ?? 'Not provided'),
                _buildCredentialRow('Port', credentials['port'] ?? 'Not provided'),
                _buildCredentialRow('Rigs', credentials['rigs'] ?? 'Not provided'),
                _buildCredentialRow('Username', credentials['user'] ?? 'Not provided'),
                _buildCredentialRow('Password',
                    credentials['pass']?.isNotEmpty == true
                        ? '•' * (credentials['pass']?.length ?? 0)
                        : 'Not provided'
                ),
                const SizedBox(height: 16),
                const Text(
                  'Do you want to proceed with connecting to Liquid Galaxy using these credentials?',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Just close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyCredentialsAndConnect(credentials);
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  void _applyCredentialsAndConnect(Map<String, String> credentials) {
    // Populate the text fields with scanned data
    setState(() {
      _ipController.text = credentials['ip'] ?? '';
      _portController.text = credentials['port'] ?? '';
      _rigsController.text = credentials['rigs'] ?? '';
      _usernameController.text = credentials['user'] ?? '';
      _passwordController.text = credentials['pass'] ?? '';
    });

    // Save the preferences
    _savePreferences();

    // Show loading dialog while attempting connection
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Connecting to Liquid Galaxy...'),
            ],
          ),
        );
      },
    );

    // Simulate connection attempt (replace with actual connection logic)
    _attemptLiquidGalaxyConnection(credentials);
  }

  void _connectToLiquidGalaxy() {
    final Map<String, String> credentials = {
      'ip': _ipController.text,
      'port': _portController.text,
      'rigs': _rigsController.text,
      'user': _usernameController.text,
      'pass': _passwordController.text,
    };

    // Show loading dialog while attempting connection
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Connecting to Liquid Galaxy...'),
            ],
          ),
        );
      },
    );

    _attemptLiquidGalaxyConnection(credentials);
  }

  Future<void> _attemptLiquidGalaxyConnection(Map<String, String> credentials) async {
    try {
      // Dummy connection logic - replace with actual implementation
      await _dummyLGConnection(credentials);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Update connection status
      setState(() {
        isConnected = true;
      });

      // Save the connected state
      _savePreferences();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully connected to Liquid Galaxy!'),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Connection Failed'),
              content: Text('Failed to connect to Liquid Galaxy: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Dummy connection function - replace with actual LG connection logic
  Future<void> _dummyLGConnection(Map<String, String> credentials) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Dummy validation - you can replace this with actual connection logic
    if (credentials['ip']?.isEmpty ?? true) {
      throw Exception('IP address is required');
    }

    if (credentials['port']?.isEmpty ?? true) {
      throw Exception('Port is required');
    }

    if (credentials['user']?.isEmpty ?? true) {
      throw Exception('Username is required');
    }

    // Simulate random connection success/failure for demo
    // Remove this and implement actual connection logic
    if (DateTime.now().millisecondsSinceEpoch % 3 != 0) {
      // Success case (2/3 chance)
      print('Dummy LG Connection successful with:');
      print('IP: ${credentials['ip']}');
      print('Port: ${credentials['port']}');
      print('Rigs: ${credentials['rigs']}');
      print('User: ${credentials['user']}');
    } else {
      // Failure case for demo (1/3 chance)
      throw Exception('Connection timeout - please check your credentials and network');
    }
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) {
      final data = scanData.code;
      try {
        final map = json.decode(data ?? '') as Map<String, dynamic>;
        Navigator.of(context).pop(map); // send back parsed JSON
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR JSON data')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Visualization Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSliderSetting(
              'Confidence Threshold',
              _confidenceThreshold,
                  (value) {
                setState(() {
                  _confidenceThreshold = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 16.0),
            _buildSwitchSetting(
              'Show Building Labels',
              _showBuildingLabels,
                  (value) {
                setState(() {
                  _showBuildingLabels = value;
                });
                _savePreferences();
              },
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
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              '${value.toInt()}%',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.grey[300],
              thumbColor: Colors.blue,
              overlayColor: Colors.blue.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 100.0,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Data Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSwitchSetting(
              'Auto-refresh Data',
              _autoRefreshData,
                  (value) {
                setState(() {
                  _autoRefreshData = value;
                });
                _savePreferences();
              },
            ),
            const SizedBox(height: 16.0),
            _buildInfoSetting('Data Source Version', _dataSourceVersion),
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
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInfoSetting(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30.0,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      backgroundColor: _isDarkMode
          ? const Color.fromARGB(255, 16, 16, 16)
          : const Color.fromARGB(255, 245, 245, 245),
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
                  'About',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    color: _isDarkMode ? Colors.white : Colors.black,
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

                  ),
                  child: Image.asset('assets/logos/app_logo.png')
                ),
              ),

              // App Title
              Text(
                'Open Buildings Dataset Tool',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // App Description
              Text(
                'Interactive visualization tool for Google\'s Open Buildings dataset\nwith Liquid Galaxy integration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
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

              ClipRRect(
                borderRadius: BorderRadius.circular(16), // adjust the radius as you like
                child: Image.asset(
                  'assets/images/splash_kml.png',
                  fit: BoxFit.cover,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
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
          _buildInfoRow('Version', '1.0.0', Icons.info_outline),
          const Divider(height: 20),
          _buildInfoRow('Data Source', 'Google Open Buildings V3', Icons.dataset),
          const Divider(height: 20),
          _buildInfoRow('Project', 'GSoC 2025 - Liquid Galaxy', Icons.code),
          const Divider(height: 20),
          _buildInfoRow('Build Date', 'January 2025', Icons.calendar_today),
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
          color: _isDarkMode ? Colors.blue[300] : Colors.blue[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
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
                color: _isDarkMode ? Colors.blue[300] : Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Developer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Jaivardhan Shukla',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'VNIT Nagpur, India',
            style: TextStyle(
              fontSize: 14,
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton('GitHub', 'https://github.com/jaivsh', Icons.code),
              _buildSocialButton('LinkedIn', 'https://www.linkedin.com/in/jaivardhan-shukla', Icons.work),
              _buildSocialButton('Email', 'mailto:akojoel60@gmail.com', Icons.email),
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
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.blue[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
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
                color: _isDarkMode ? Colors.blue[300] : Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'About this Project',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'This application integrates Google\'s Open Buildings dataset with interactive mapping capabilities and Liquid Galaxy visualization. Built as part of Google Summer of Code 2025 with the Liquid Galaxy organization.',
            style: TextStyle(
              fontSize: 14,
              color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
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
    final features = [
      'Interactive building footprint visualization',
      'Real-time data from Google Earth Engine',
      'Liquid Galaxy integration for immersive experience',
      'Grid-based mapping with zoom controls',
      'Building confidence score visualization',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black,
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
                color: Colors.green[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
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
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(Uri.parse('https://github.com/jaivsh')),
            icon: const Icon(Icons.open_in_new, size: 20),
            label: const Text('View Project Repository'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue[600],
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
                label: const Text('Open Buildings Dataset'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                  side: BorderSide(color: Colors.blue[600]!),
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
                label: const Text('Liquid Galaxy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                  side: BorderSide(color: Colors.blue[600]!),
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