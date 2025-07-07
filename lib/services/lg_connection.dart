import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LGConnection {
  SSHClient? _client;
  String? _host;
  String? _port;
  String? _username;
  String? _password;
  String? _numberOfRigs;

  // Load connection details from SharedPreferences
  Future<void> _loadConnectionDetails() async {
    final prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('lg_ip');
    _port = prefs.getString('lg_port');
    _username = prefs.getString('lg_user');
    _password = prefs.getString('lg_pass');
    _numberOfRigs = prefs.getString('lg_rigs');
  }

  // Connect to Liquid Galaxy
  Future<bool> connect() async {
    await _loadConnectionDetails();

    if (_host == null || _host!.isEmpty ||
        _port == null || _port!.isEmpty ||
        _username == null || _username!.isEmpty ||
        _password == null || _password!.isEmpty) {
      throw Exception('Connection details are incomplete');
    }

    try {
      final socket = await SSHSocket.connect(_host!, int.parse(_port!));

      _client = SSHClient(
        socket,
        username: _username!,
        onPasswordRequest: () => _password!,
      );

      // Test connection with a simple command
      await _client!.execute('echo "test"');

      return true;
    } on SocketException catch (e) {
      throw Exception('Failed to connect: ${e.message}');
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  // Disconnect
  Future<void> disconnect() async {
    _client?.close();
    _client = null;
  }

  // Check if connected
  bool get isConnected => _client != null;

  // Execute a command
  Future<void> execute(String command) async {
    if (_client == null) {
      throw Exception('Not connected to Liquid Galaxy');
    }

    try {
      await _client!.execute(command);
    } catch (e) {
      throw Exception('Failed to execute command: $e');
    }
  }

  // Set slaves refresh
  Future<void> setSlavesRefresh() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      for (var i = 2; i <= int.parse(_numberOfRigs!); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client!.run(
            'sshpass -p $_password ssh -t lg$i \'echo $_password | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\''
        );
      }
    } catch (e) {
      throw Exception('Failed to set slaves refresh: $e');
    }
  }

  // Reset slaves refresh
  Future<void> resetSlavesRefresh() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      for (var i = 2; i <= int.parse(_numberOfRigs!); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';

        await _client!.run(
            'sshpass -p $_password ssh -t lg$i \'echo $_password | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\''
        );
      }
    } catch (e) {
      throw Exception('Failed to reset slaves refresh: $e');
    }
  }

  // Clear KML and logos
  Future<void> clearKMLAndLogos() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      // Clear main query
      await _client!.run('echo "" > /tmp/query.txt');

      // Clear kmls.txt
      await _client!.run("echo '' > /var/www/html/kmls.txt");

      // Clear slave KML files
      for (var i = 2; i <= int.parse(_numberOfRigs!); i++) {
        String blankKML = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document id="blank">
  </Document>
</kml>''';

        await _client!.run("echo '$blankKML' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (e) {
      throw Exception('Failed to clear KML and logos: $e');
    }
  }

  // Relaunch LG
  Future<void> relaunchLG() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      for (var i = 1; i <= int.parse(_numberOfRigs!); i++) {
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
    } catch (e) {
      throw Exception('Failed to relaunch LG: $e');
    }
  }

  // Reboot LG
  Future<void> rebootLG() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      for (var i = 1; i <= int.parse(_numberOfRigs!); i++) {
        await _client!.run(
            'sshpass -p $_password ssh -t lg$i "echo $_password | sudo -S reboot"'
        );
      }
    } catch (e) {
      throw Exception('Failed to reboot LG: $e');
    }
  }

  // Power off LG
  Future<void> powerOffLG() async {
    if (_client == null || _numberOfRigs == null) return;

    try {
      for (var i = 1; i <= int.parse(_numberOfRigs!); i++) {
        await _client!.run(
            'sshpass -p $_password ssh -t lg$i "echo $_password | sudo -S poweroff"'
        );
      }
    } catch (e) {
      throw Exception('Failed to power off LG: $e');
    }
  }
}