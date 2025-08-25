// services/lg_service.dart
import 'dart:async';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/selected_region_bottom_sheet.dart';
import '../entities/screen_overlay_entity.dart';
import '../entities/kml_entity.dart';
import 'dart:convert';
import 'dart:typed_data';

import '../models/building_data.dart';


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

  // Orbit functionality
  Timer? _orbitTimer;
  bool _isOrbiting = false;

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
  bool get isOrbiting => _isOrbiting;

  // Calculate left screen for logo placement
  int get leftScreen {
    final rigs = int.tryParse(_numberOfRigs ?? '3');
    if (rigs == null || rigs <= 0) return 1;
    if (rigs == 1) return 1;
    return (rigs / 2).floor() + 2;
  }

  // Calculate right screen for logo placement
  int get rightScreen {
    final rigs = int.tryParse(_numberOfRigs ?? '3');
    if (rigs == null || rigs <= 0) return 1;
    if (rigs == 1) return 1;
    if (rigs == 2) return 2;

    return rigs - 1;
  }

  // Orbit functionality
  Future<void> startOrbit360({
    required double latitude,
    required double longitude,
    double altitude = 1000,
    double tilt = 45,
    double range = 500,
    double speedDegPerSecond = 6.0, // 6 degrees per second = 60 seconds for full orbit
  }) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    if (_isOrbiting) {
      stopOrbit();
    }

    _isOrbiting = true;
    notifyListeners();

    try {
      double currentHeading = 0;
      final double stepSize = speedDegPerSecond / 2; // 2 updates per second

      _orbitTimer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
        if (!_isOrbiting) {
          timer.cancel();
          return;
        }

        try {
          // Send orbit command using flytoview
          String flytoQuery = "flytoview=<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><altitude>$altitude</altitude><heading>$currentHeading</heading><tilt>$tilt</tilt><range>$range</range></LookAt>";
          await _client!.run("echo '$flytoQuery' > /tmp/query.txt");

          currentHeading += stepSize;
          if (currentHeading >= 360) {
            currentHeading = 0; // Continue orbiting - reset to 0 and keep going
          }
        } catch (e) {
          print('Error during orbit: $e');
          stopOrbit();
        }
      });

      print('Started continuous 360° orbit at $latitude, $longitude');
    } catch (e) {
      _isOrbiting = false;
      notifyListeners();
      throw Exception('Failed to start orbit: $e');
    }
  }

  void stopOrbit() {
    _isOrbiting = false;
    _orbitTimer?.cancel();
    _orbitTimer = null;
    notifyListeners();
    print('Orbit stopped');
  }

  // Corrected debugging methods with proper return types:

// Read back the KML file to see what was actually written
  Future<Uint8List?> readKMLFile(int slaveId) async {
    if (_client == null) return null;

    try {
      final result = await _client!.run('cat /var/www/html/kml/slave_$slaveId.kml');
      return result;
    } catch (e) {
      print('Failed to read KML file: $e');
      return null;
    }
  }

  // Add this method to your LGService class:
  // Update your sendKMLToLG method to include the info panel:

  Future<void> sendKMLToLG(String kmlContent, double centerLat, double centerLng) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      print('Sending KML to LG (${kmlContent.length} characters)...');

      // FIX: Remove descriptions from buildings to prevent popups and fix empty styles
      String fixedKML = kmlContent
          .replaceAll(RegExp(r'<description>.*?</description>', dotAll: true), '') // Remove popups
          .replaceAll('<LineStyle></LineStyle>', '<LineStyle><color>ff0000ff</color><width>2</width></LineStyle>')
          .replaceAll('<PolyStyle></PolyStyle>', '<PolyStyle><color>7d00ff00</color><fill>1</fill><outline>1</outline></PolyStyle>')
          .replaceAll('<IconStyle></IconStyle>', '<IconStyle><color>ff0000ff</color></IconStyle>');

      // Step 1: Write the fixed KML content to main screen
      String command = "echo '${fixedKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_2.kml";
      await _client!.run(command);

      // Step 2: Create and send info panel to rightmost screen
      // String infoPanelKML = _createRightmostInfoPanel([]); // Start with no selected building
      //String infoPanelCommand = "echo '${infoPanelKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$rightScreen.kml";
      //await _client!.run(infoPanelCommand);

      // Step 3: Add building KML to kmls.txt
      await _client!.run("echo 'http://lg1:81/kml/slave_2.kml' > /var/www/html/kmls.txt");

      // Step 4: Move camera to region center
      String searchQuery = "search=$centerLat,$centerLng";
      await _client!.run("echo '$searchQuery' > /tmp/query.txt");

      // Step 5: Wait and set closer zoom
      await Future.delayed(Duration(seconds: 2));

      String flytoQuery = "flytoview=<LookAt><longitude>$centerLng</longitude><latitude>$centerLat</latitude><altitude>0</altitude><heading>0</heading><tilt>45</tilt><range>150</range></LookAt>";
      await _client!.run("echo '$flytoQuery' > /tmp/query.txt");

      print('KML sent successfully with info panel on rightmost screen');

    } catch (e) {
      throw Exception('Failed to send KML to LG: $e');
    }
  }


// Helper method to convert Uint8List to String for reading
  Future<String?> readKMLFileAsString(int slaveId) async {
    try {
      final bytes = await readKMLFile(slaveId);
      if (bytes == null) return null;

      return utf8.decode(bytes);
    } catch (e) {
      print('Failed to decode KML file: $e');
      return null;
    }
  }

// Verify that the KML file was written correctly
  Future<bool> verifyKMLFile(int slaveId) async {
    if (_client == null) return false;

    try {
      final result = await _client!.run('ls -la /var/www/html/kml/slave_$slaveId.kml');
      print('File verification for slave $slaveId: ${utf8.decode(result)}');

      // Check file size
      final sizeResult = await _client!.run('wc -c /var/www/html/kml/slave_$slaveId.kml');
      print('File size: ${utf8.decode(sizeResult)}');

      return true;
    } catch (e) {
      print('File verification failed: $e');
      return false;
    }
  }

// Test with a simple KML to verify the pipeline works
  Future<void> sendTestKML(int slaveId) async {
    String testKML = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Test Building</name>
    <Placemark>
      <name>Test Point</name>
      <Point>
        <coordinates>-122.084,37.422,0</coordinates>
      </Point>
      <LookAt>
        <longitude>-122.084</longitude>
        <latitude>37.422</latitude>
        <altitude>0</altitude>
        <heading>0</heading>
        <tilt>45</tilt>
        <range>1000</range>
      </LookAt>
    </Placemark>
  </Document>
</kml>''';

    try {
      await sendKMLToSlave(testKML, slaveId);
      print('Test KML sent successfully');

      // Verify it was written
      await Future.delayed(Duration(seconds: 1));
      String? readBack = await readKMLFileAsString(slaveId);
      if (readBack != null) {
        print('KML read back (first 200 chars): ${readBack.substring(0, readBack.length > 200 ? 200 : readBack.length)}...');
      } else {
        print('Failed to read back KML file');
      }

    } catch (e) {
      print('Test KML failed: $e');
    }
  }

// Check LG system status
  Future<void> checkLGStatus() async {
    if (_client == null) return;

    try {
      // Check if Google Earth is running
      final earthStatus = await _client!.run('pgrep -f "googleearth"');
      print('Google Earth processes: ${utf8.decode(earthStatus)}');

      // Check web server
      final webStatus = await _client!.run('systemctl status apache2 | grep Active');
      print('Web server status: ${utf8.decode(webStatus)}');

      // Check kml directory permissions
      final permissions = await _client!.run('ls -la /var/www/html/kml/');
      print('KML directory permissions: ${utf8.decode(permissions)}');

    } catch (e) {
      print('Status check failed: $e');
    }
  }

// Add this import if not already present:

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
      stopOrbit(); // Stop orbit when disconnecting
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

  // Set building dashboard on rightmost screen (following setLogo pattern)
  Future<void> setBuildingDashboard(BuildingData building,
      LatLng Function(BuildingData) calculateCenter,
      String Function(BuildingData) generatePlusCode) async {
    try {
      if (_client == null) {
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to establish SSH connection');
        }
      }

      // Create screen overlay using the entity with helper functions
      final screenOverlay = ScreenOverlayEntity.buildingDashboard(
          building,
          calculateCenter,
          generatePlusCode
      );

      // Rest of the method stays the same...
      final kmlContent = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="slave_$rightScreen">
    <name>Building-Dashboard</name>
    <open>1</open>
    ${screenOverlay.tag}
  </Document>
</kml>''';

      String command = "echo '${kmlContent.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$rightScreen.kml";
      await _client!.run(command);

      print('Building dashboard set successfully on screen $rightScreen');

    } catch (e) {
      print('Failed to set building dashboard: $e');
      rethrow;
    }
  }

// Clean building dashboard from rightmost screen
  Future<void> cleanBuildingDashboard() async {
    try {
      if (_client == null) {
        bool connected = await connect();
        if (!connected) {
          throw Exception('Failed to establish SSH connection');
        }
      }

      // Create a proper blank KML document
      String blankKML = KMLEntity.generateBlank('slave_$rightScreen');

      // Clean the dashboard from the right screen
      String command = "echo '${blankKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$rightScreen.kml";

      await _client!.run(command);

      print('Building dashboard cleaned successfully from screen $rightScreen');
    } catch (e) {
      print('Failed to clean building dashboard: $e');
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

  Future<void> cleanAllKML() async {
    if (_client == null) return;

    try {
      print('🧹 Cleaning all KML files...');

      // **STEP 1**: Clear query and kmls.txt first
      await _client!.run('echo "" > /tmp/query.txt');
      await _client!.run('echo "" > /var/www/html/kmls.txt');

      // **STEP 2**: Wait for Google Earth to process
      await Future.delayed(Duration(milliseconds: 500));

      // **STEP 3**: Clean all slave files
      final rigs = int.tryParse(_numberOfRigs ?? '3') ?? 3;
      for (var i = 1; i <= rigs; i++) {
        // Remove existing file
        await _client!.run('rm -f /var/www/html/kml/slave_$i.kml');

        // Create blank KML
        String blankKML = KMLEntity.generateBlank('slave_$i');
        String command = "echo '${blankKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$i.kml";
        await _client!.run(command);
      }

      // **STEP 4**: Final verification
      await Future.delayed(Duration(milliseconds: 300));

      print('✅ All KML files cleaned successfully');
    } catch (e) {
      print('❌ Failed to clean KML: $e');
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

  static String buildOrbit(double lat, double lon){
    String lookAts = '';

    for (int i=0;i<=360;i+=10) {
      lookAts += '''
      <gx:FlyTo>
              <gx:duration>1.2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                  <longitude>$lon</longitude>
                  <latitude>$lat</latitude>
                  <heading>${i.toDouble()}</heading>
                  <tilt>60</tilt>
                  <range>40000</range>
                  <gx:fovy>60</gx:fovy> 
                  <altitude>3341.7995674</altitude> 
                  <gx:altitudeMode>absolute</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
''';
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
   <gx:Tour>
   <name>Orbit</name>
      <gx:Playlist>
         $lookAts
      </gx:Playlist>
   </gx:Tour>
</kml>''';
  }

  // Add this to your LGService class in lg_service.dart
  Future<void> sendBuildingWithInfoPanel(String buildingKML, String infoPanelKML, double latitude, double longitude) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      // Calculate rightmost screen (assuming you have 3+ screens)
      final rigs = int.tryParse(_numberOfRigs ?? '3') ?? 3;
      final rightmostScreen = rigs; // Last screen

      // Step 1: Write the building KML file (main visualization)
      String buildingCommand = "echo '${buildingKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_2.kml";
      await _client!.run(buildingCommand);

      // Step 2: Write the info panel to rightmost screen
      String infoPanelCommand = "echo '${infoPanelKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$rightmostScreen.kml";
      await _client!.run(infoPanelCommand);

      // Step 3: Add building KML to kmls.txt
      await _client!.run("echo 'http://lg1:81/kml/slave_2.kml' > /var/www/html/kmls.txt");

      // Step 4: Move camera to building location
      String searchQuery = "search=$latitude,$longitude";
      await _client!.run("echo '$searchQuery' > /tmp/query.txt");

      print('Building sent with info panel on screen $rightmostScreen');

    } catch (e) {
      throw Exception('Failed to send building with info panel: $e');
    }
  }

  Future<void> sendBulkBuildingsToLG(String buildingKML, String dashboardKML, double centerLat, double centerLng) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      // Use the rightScreen getter instead of manual calculation
      final rightmostScreen = rightScreen;

      // Step 1: Write the building KML file (same as individual)
      String buildingCommand = "echo '${buildingKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_2.kml";
      await _client!.run(buildingCommand);

      // Step 2: Write the dashboard to rightmost screen
      String dashboardCommand = "echo '${dashboardKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_$rightmostScreen.kml";
      await _client!.run(dashboardCommand);

      // Step 3: Add KML to kmls.txt (same as individual)
      await _client!.run("echo 'http://lg1:81/kml/slave_2.kml' > /var/www/html/kmls.txt");

      // Step 4: Move camera to region center with closer zoom (150m range)
      String searchQuery = "search=$centerLat,$centerLng";
      await _client!.run("echo '$searchQuery' > /tmp/query.txt");

      // Step 5: Wait a moment, then set closer zoom
      await Future.delayed(Duration(seconds: 2));

      // Use flyto for precise control with 150m range
      String flytoQuery = "flytoview=<LookAt><longitude>$centerLng</longitude><latitude>$centerLat</latitude><altitude>0</altitude><heading>0</heading><tilt>45</tilt><range>150</range></LookAt>";
      await _client!.run("echo '$flytoQuery' > /tmp/query.txt");

      print('Bulk buildings sent, dashboard on rightmost screen: $rightmostScreen');

    } catch (e) {
      throw Exception('Failed to send bulk buildings: $e');
    }
  }

// Helper method for large KML files using SFTP
  Future<void> _sendLargeKMLViaSFTP(String kmlContent, String fileName) async {
    final sftp = await _client!.sftp();
    final filePath = '/var/www/html/kml/$fileName';

    try {
      final sftpFile = await sftp.open(
          filePath,
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write | SftpFileOpenMode.truncate
      );

      // Convert string to bytes and send in chunks for large files
      final bytes = utf8.encode(kmlContent);
      const chunkSize = 1024 * 1024; // 1MB chunks

      for (int i = 0; i < bytes.length; i += chunkSize) {
        final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
        final chunk = bytes.sublist(i, end);
        await sftpFile.write(Stream.fromIterable([Uint8List.fromList(chunk)]));
      }

      await sftpFile.close();
      print('Large KML file sent via SFTP: $fileName (${bytes.length} bytes)');

    } finally {
      sftp.close();
    }
  }



  // Send building data to Liquid Galaxy as KML
  Future<void> sendBuildingToLG(String buildingKML, double latitude, double longitude) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      // Step 1: Write the building KML file
      String command = "echo '${buildingKML.replaceAll("'", "'\\''")}' > /var/www/html/kml/slave_2.kml";
      await _client!.run(command);

      // Step 2: Add KML to kmls.txt so Google Earth loads it
      await _client!.run("echo 'http://lg1:81/kml/slave_2.kml' > /var/www/html/kmls.txt");

      // Step 3: Move camera to building location using search coordinates
      String searchQuery = "search=$latitude,$longitude";
      await _client!.run("echo '$searchQuery' > /tmp/query.txt");

      print('Building KML sent and camera moved to location: $latitude, $longitude');

    } catch (e) {
      throw Exception('Failed to send building to LG: $e');
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
    stopOrbit(); // Stop orbit when disposing
    _client?.close();
    super.dispose();
  }
}