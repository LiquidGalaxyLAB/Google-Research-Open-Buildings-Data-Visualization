// services/lg_service.dart
import 'dart:async';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/screen_overlay_entity.dart';
import '../entities/kml_entity.dart';

enum LGConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class LGService extends ChangeNotifier {
  static final LGService _instance = LGService._internal();
  factory LGService() => _instance;
  LGService._internal();

  // Connection state
  SSHClient? _client;
  LGConnectionStatus _status = LGConnectionStatus.disconnected;
  String? _errorMessage;

  // Connection details
  String? _host;
  String? _port;
  String? _username;
  String? _password;
  String? _numberOfRigs;

  // Auto-reconnection timer
  Timer? _reconnectTimer;
  bool _autoReconnectEnabled = true;

  // Getters
  LGConnectionStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _status == LGConnectionStatus.connected;
  bool get isConnecting => _status == LGConnectionStatus.connecting;
  String? get host => _host;
  String? get numberOfRigs => _numberOfRigs;
  String? get username => _username;
  String? get password => _password;
  String? get port => _port;

  // Calculate left screen for logo placement
  int get leftScreen {
    final rigs = int.tryParse(_numberOfRigs ?? '3');
    if (rigs == null || rigs <= 0) return 1;
    if (rigs == 1) return 1;
    return (rigs / 2).floor() + 2;
  }

  // Initialize service - call this once in main()
  Future<void> initialize() async {
    await _loadConnectionDetails();
    // Attempt auto-connection if credentials exist
    if (_hasValidCredentials()) {
      await connect();
    }
  }

  // Load connection details from SharedPreferences
  Future<void> _loadConnectionDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _host = prefs.getString('lg_ip');
      _port = prefs.getString('lg_port');
      _username = prefs.getString('lg_user');
      _password = prefs.getString('lg_pass');
      _numberOfRigs = prefs.getString('lg_rigs');
    } catch (e) {
      print('Error loading connection details: $e');
    }
  }

  // Save connection details to SharedPreferences
  Future<void> saveConnectionDetails({
    required String host,
    required String port,
    required String username,
    required String password,
    required String numberOfRigs,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lg_ip', host);
      await prefs.setString('lg_port', port);
      await prefs.setString('lg_user', username);
      await prefs.setString('lg_pass', password);
      await prefs.setString('lg_rigs', numberOfRigs);
      await prefs.setBool('lg_connected', false);

      // Update internal variables
      _host = host;
      _port = port;
      _username = username;
      _password = password;
      _numberOfRigs = numberOfRigs;

      notifyListeners();
    } catch (e) {
      print('Error saving connection details: $e');
    }
  }

  // Check if we have valid credentials
  bool _hasValidCredentials() {
    return _host?.isNotEmpty == true &&
        _port?.isNotEmpty == true &&
        _username?.isNotEmpty == true &&
        _password?.isNotEmpty == true &&
        _numberOfRigs?.isNotEmpty == true;
  }

  // Connect to Liquid Galaxy
  Future<bool> connect() async {
    if (!_hasValidCredentials()) {
      _setStatus(LGConnectionStatus.error, 'Missing connection credentials');
      return false;
    }

    _setStatus(LGConnectionStatus.connecting);

    try {
      // Close existing connection if any
      await disconnect();

      final socket = await SSHSocket.connect(_host!, int.parse(_port!));
      _client = SSHClient(
        socket,
        username: _username!,
        onPasswordRequest: () => _password!,
      );

      // Test the connection with a simple command
      await _client!.run('echo "Connection test"');

      _setStatus(LGConnectionStatus.connected);

      // Save connected state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lg_connected', true);

      // Start auto-reconnect monitoring
      _startAutoReconnectTimer();

      // Automatically set logo when connection is established
      try {
        await setLogo();
        print('Logo automatically set on connection');
      } catch (e) {
        print('Failed to automatically set logo: $e');
        // Don't fail the connection if logo setting fails
      }

      return true;
    } catch (e) {
      print('SSH connection failed: $e');
      _setStatus(LGConnectionStatus.error, 'Connection failed: $e');
      await disconnect();
      return false;
    }
  }

  // Disconnect from Liquid Galaxy
  Future<void> disconnect() async {
    try {
      _stopAutoReconnectTimer();
      _client?.close();
      _client = null;
      _setStatus(LGConnectionStatus.disconnected);

      // Save disconnected state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lg_connected', false);
    } catch (e) {
      print('Error during disconnect: $e');
    }
  }

  // Check if current connection is still alive
  Future<bool> checkConnection() async {
    if (_client == null) return false;

    try {
      await _client!.run('echo "alive"');
      return true;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  // Start auto-reconnect timer
  void _startAutoReconnectTimer() {
    _stopAutoReconnectTimer();
    if (!_autoReconnectEnabled) return;

    _reconnectTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (_status == LGConnectionStatus.connected) {
        bool alive = await checkConnection();
        if (!alive) {
          print('Connection lost, attempting to reconnect...');
          await connect();
        }
      }
    });
  }

  // Stop auto-reconnect timer
  void _stopAutoReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // Set connection status and notify listeners
  void _setStatus(LGConnectionStatus status, [String? error]) {
    _status = status;
    _errorMessage = error;
    notifyListeners();
  }

  // Execute a raw command
  Future<void> executeCommand(String command) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      await _client!.run(command);
    } catch (e) {
      throw Exception('Failed to execute command: $e');
    }
  }

  // Send KML content to a specific slave
  Future<void> sendKMLToSlave(String kmlContent, int slaveId) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      String command = "echo '${kmlContent.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$slaveId.kml";
      await _client!.run(command);
      print('KML sent successfully to slave $slaveId');
    } catch (e) {
      throw Exception('Failed to send KML to slave $slaveId: $e');
    }
  }

  // Send KML entity to specific slave
  Future<void> sendKMLEntity(KMLEntity kmlEntity, int slaveId) async {
    await sendKMLToSlave(kmlEntity.body, slaveId);
  }

  // Set logo on Liquid Galaxy (using existing implementation)
  Future<void> setLogo() async {
    try {
      if (_client == null) {
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to establish SSH connection');
        }
      }

      // Create screen overlay using the entity
      final screenOverlay = ScreenOverlayEntity.logos();

      // Create complete KML document with proper structure
      final kmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="slave_$leftScreen">
    <name>LG-Logo</name>
    <open>1</open>
    ${screenOverlay.tag}
  </Document>
</kml>''';

      // Send to the correct slave screen with proper escaping
      String command = "echo '${kmlContent.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$leftScreen.kml";

      await _client!.run(command);

      print('Logo set successfully on screen $leftScreen');

    } catch (e) {
      print('Failed to set logo: $e');
      rethrow;
    }
  }

  // Clean logo from Liquid Galaxy
  Future<void> cleanLogo() async {
    try {
      if (_client == null) {
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to establish SSH connection');
        }
      }

      // Create a proper blank KML document
      String blankKML = KMLEntity.generateBlank('slave_$leftScreen');

      // Clean the logo from the left screen
      String command = "echo '${blankKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$leftScreen.kml";

      await _client!.run(command);

      print('Logo cleaned successfully from screen $leftScreen');
    } catch (e) {
      print('Failed to clean logo: $e');
      rethrow;
    }
  }

  // Set slaves refresh
  Future<void> setSlavesRefresh() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 2; i <= rigs; i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client!.run(
            'sshpass -p $_password ssh -t lg$i \'echo $_password | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\''
        );
      }
      print('Slaves refresh set successfully');
    } catch (e) {
      print('Failed to set slaves refresh: $e');
      rethrow;
    }
  }

  // Reset slaves refresh
  Future<void> resetSlavesRefresh() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 2; i <= rigs; i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await _client!.run(
            'sshpass -p $_password ssh -t lg$i \'echo $_password | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\''
        );
      }
      print('Slaves refresh reset successfully');
    } catch (e) {
      print('Failed to reset slaves refresh: $e');
      rethrow;
    }
  }

  // Clear KML and logos
  Future<void> clearKMLAndLogos() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      // Clear query file
      await _client!.run('echo "" > /tmp/query.txt');

      // Clear kmls.txt
      await _client!.run("echo '' > /var/www/html/kmls.txt");

      // Clear all slave KML files
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 1; i <= rigs; i++) {
        String blankKML = KMLEntity.generateBlank('slave_$i');
        String command = "echo '${blankKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$i.kml";
        await _client!.run(command);
      }

      print('KML and logos cleared successfully');
    } catch (e) {
      print('Failed to clear KML and logos: $e');
      rethrow;
    }
  }

  // Relaunch LG
  Future<void> relaunchLG() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 1; i <= rigs; i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo $_password | sudo -S service \\\${SERVICE} start
          else
            echo $_password | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p $_password ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _client!.run(cmd);
      }
      print('LG relaunched successfully');
    } catch (e) {
      print('Failed to relaunch LG: $e');
      rethrow;
    }
  }

  // Reboot LG
  Future<void> rebootLG() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 1; i <= rigs; i++) {
        await _client!.run(
            'sshpass -p $_password ssh -t lg$i "echo $_password | sudo -S reboot"'
        );
      }
      print('LG rebooted successfully');
    } catch (e) {
      print('Failed to reboot LG: $e');
      rethrow;
    }
  }

  // Power off LG
  Future<void> powerOffLG() async {
    if (_client == null || _numberOfRigs == null) {
      throw Exception('Not connected or missing number of rigs');
    }

    try {
      final rigs = int.parse(_numberOfRigs!);
      for (var i = 1; i <= rigs; i++) {
        await _client!.run(
            'sshpass -p $_password ssh -t lg$i "echo $_password | sudo -S poweroff"'
        );
      }
      print('LG powered off successfully');
    } catch (e) {
      print('Failed to power off LG: $e');
      rethrow;
    }
  }

  // Send building data to Liquid Galaxy as KML
  Future<void> sendBuildingToLG(dynamic buildingData, {int slaveId = 2}) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      // Create KML content for the building
      String buildingKML = _createBuildingKML(buildingData);

      // Send to specified slave
      await sendKMLToSlave(buildingKML, slaveId);

      print('Building sent to Liquid Galaxy on slave $slaveId');
    } catch (e) {
      print('Failed to send building to LG: $e');
      rethrow;
    }
  }

  // Create KML content for building data
  String _createBuildingKML(dynamic buildingData) {
    // This method should be customized based on your BuildingData structure
    // For now, providing a basic template
    String placemark = '''
      <Placemark>
        <name>Building</name>
        <description>Building footprint from Open Buildings dataset</description>
        <Polygon>
          <extrude>1</extrude>
          <altitudeMode>relativeToGround</altitudeMode>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>
                <!-- Add building coordinates here -->
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      </Placemark>
    ''';

    return KMLEntity(
      name: 'Building Visualization',
      content: placemark,
    ).body;
  }

  // Enable/disable auto-reconnection
  void setAutoReconnect(bool enabled) {
    _autoReconnectEnabled = enabled;
    if (enabled && _status == LGConnectionStatus.connected) {
      _startAutoReconnectTimer();
    } else {
      _stopAutoReconnectTimer();
    }
  }

  @override
  void dispose() {
    _stopAutoReconnectTimer();
    _client?.close();
    super.dispose();
  }
}