import '../components/selected_region_bottom_sheet.dart';
import '../models/building_data.dart';

/// Class that defines the `screen overlay` entity, which contains its
/// properties and methods.
class ScreenOverlayEntity {
  /// Property that defines the screen overlay `name`.
  String name;

  /// Property that defines the screen overlay `icon url`.
  String icon;

  /// Property that defines the screen overlay `overlayX`.
  double overlayX;

  /// Property that defines the screen overlay `overlayY`.
  double overlayY;

  /// Property that defines the screen overlay `screenX`.
  double screenX;

  /// Property that defines the screen overlay `screenY`.
  double screenY;

  /// Property that defines the screen overlay `sizeX`.
  double sizeX;

  /// Property that defines the screen overlay `sizeY`.
  double sizeY;

  ScreenOverlayEntity({
    required this.name,
    this.icon = '',
    required this.overlayX,
    required this.overlayY,
    required this.screenX,
    required this.screenY,
    required this.sizeX,
    required this.sizeY,
  });

  /// Property that defines the screen overlay `tag` according to its current
  /// properties.
  ///
  /// Example
  /// ```
  /// ScreenOverlay screenOverlay = ScreenOverlay(
  ///   name: "Overlay",
  ///   this.icon = 'https://google.com/...',
  ///   overlayX = 0,
  ///   overlayY = 0,
  ///   screenX = 0,
  ///   screenY = 0,
  ///   sizeX = 0,
  ///   sizeY = 0,
  /// )
  ///
  /// screenOverlay.tag => '''
  ///   <ScreenOverlay>
  ///     <name>Overlay</name>
  ///     <Icon>
  ///       <href>https://google.com/...</href>
  ///     </Icon>
  ///     <overlayXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <screenXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
  ///     <size x="0" y="0" xunits="pixels" yunits="pixels"/>
  ///   </ScreenOverlay>
  /// '''
  /// ```
  String get tag => '''
      <ScreenOverlay>
        <name>$name</name>
        <Icon>
          <href>$icon</href>
        </Icon>
        <color>ffffffff</color>
        <overlayXY x="$overlayX" y="$overlayY" xunits="fraction" yunits="fraction"/>
        <screenXY x="$screenX" y="$screenY" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="$sizeX" y="$sizeY" xunits="pixels" yunits="pixels"/>
      </ScreenOverlay>
    ''';

  /// Generates a [ScreenOverlayEntity] with the logos data in it.
  factory ScreenOverlayEntity.logos() {
    return ScreenOverlayEntity(
      name: 'LogoSO',
      icon: 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjKF9CFL6dPYxg4PRMdiM2YpTqUfPrcOZeCajjn-9uEm7UEpsiGX_DXY6iO99rKcNw025Tb45GxAbwnbojtfimFxhyn09z1HX63opCg3LpHNnlw3R5lpH0yBBlT2YABZmnvFfggvdOf8ApzLSjkycbXyShIa3rFHqg9ZFdMXTzfpdfcTVLayGW4KNWKdXp6/s500/OPEN%20BUILDINGS%20VISUALIZER-2.png',
      overlayX: 0,
      overlayY: 1,
      screenX: 0.02,
      screenY: 0.95,
      sizeX: 500,
      sizeY: 500,
    );
  }

  // Add this factory method to your ScreenOverlayEntity class
// (Add this inside the ScreenOverlayEntity class)

  /// Generates a [ScreenOverlayEntity] with building dashboard data for rightmost screen.
  /// Generates a [ScreenOverlayEntity] with building dashboard data for rightmost screen.
  factory ScreenOverlayEntity.buildingDashboard(BuildingData building,
      LatLng Function(BuildingData) calculateCenter,
      String Function(BuildingData) generatePlusCode) {

    final center = calculateCenter(building);
    final plusCode = generatePlusCode(building);

    // Determine confidence level and colors
    String confidenceLevel;
    String confidenceColor;
    String confidenceEmoji;

    if (building.confidenceScore >= 0.75) {
      confidenceLevel = 'High';
      confidenceColor = '#4CAF50';
      confidenceEmoji = '🟢';
    } else if (building.confidenceScore >= 0.70) {
      confidenceLevel = 'Medium';
      confidenceColor = '#FF9800';
      confidenceEmoji = '🟡';
    } else {
      confidenceLevel = 'Low';
      confidenceColor = '#F44336';
      confidenceEmoji = '🔴';
    }

    // Classification based on area
    String classification;
    String classificationEmoji;
    if (building.area > 1000) {
      classification = 'Large Structure';
      classificationEmoji = '🏢';
    } else if (building.area > 100) {
      classification = 'Medium Building';
      classificationEmoji = '🏠';
    } else {
      classification = 'Small Structure';
      classificationEmoji = '🏘️';
    }

    // Create HTML content for the dashboard
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      margin: 0;
      padding: 20px;
      width: 400px;
      height: 600px;
      box-sizing: border-box;
      overflow: hidden;
      position: relative;
    }
    .container {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(20px);
      border-radius: 20px;
      padding: 24px;
      height: calc(100% - 40px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      position: relative;
      overflow-y: auto;
    }
    .header {
      text-align: center;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid rgba(255, 255, 255, 0.3);
    }
    .title {
      font-size: 26px;
      font-weight: bold;
      margin: 0;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
    }
    .subtitle {
      font-size: 14px;
      opacity: 0.9;
      margin: 8px 0 0 0;
    }
    .plus-code {
      font-family: 'Courier New', monospace;
      font-size: 22px;
      background: rgba(0, 0, 0, 0.4);
      padding: 16px;
      border-radius: 12px;
      text-align: center;
      margin: 20px 0;
      letter-spacing: 3px;
      border: 2px solid rgba(255, 255, 255, 0.3);
      font-weight: bold;
      box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.2);
    }
    .info-card {
      background: rgba(255, 255, 255, 0.2);
      padding: 20px;
      border-radius: 16px;
      margin: 16px 0;
      border: 1px solid rgba(255, 255, 255, 0.3);
      backdrop-filter: blur(10px);
    }
    .info-label {
      font-size: 12px;
      opacity: 0.8;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 1px;
      font-weight: 600;
    }
    .info-value {
      font-size: 20px;
      font-weight: bold;
      margin: 0;
    }
    .confidence-high { color: #66bb6a; }
    .confidence-medium { color: #ffa726; }
    .confidence-low { color: #ef5350; }
    .stats-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      margin-top: 16px;
    }
    .stat-item {
      text-align: center;
      background: rgba(0, 0, 0, 0.2);
      padding: 12px;
      border-radius: 10px;
    }
    .stat-number {
      font-size: 24px;
      font-weight: bold;
      display: block;
      margin-bottom: 4px;
    }
    .stat-label {
      font-size: 11px;
      opacity: 0.8;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .classification {
      background: rgba(255, 255, 255, 0.25);
      padding: 20px;
      border-radius: 16px;
      text-align: center;
      margin: 20px 0;
      border: 1px solid rgba(255, 255, 255, 0.3);
    }
    .classification-icon {
      font-size: 36px;
      margin-bottom: 12px;
      display: block;
      animation: pulse 2s infinite;
    }
    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.1); }
      100% { transform: scale(1); }
    }
    .coordinates-section {
      background: rgba(255, 255, 255, 0.2);
      padding: 16px;
      border-radius: 12px;
      margin: 16px 0;
    }
    .coordinates {
      font-family: 'Courier New', monospace;
      font-size: 13px;
      background: rgba(0, 0, 0, 0.3);
      padding: 12px;
      border-radius: 8px;
      margin-top: 8px;
      line-height: 1.6;
    }
    .footer {
      text-align: center;
      font-size: 12px;
      opacity: 0.8;
      margin-top: 20px;
      padding-top: 16px;
      border-top: 1px solid rgba(255, 255, 255, 0.2);
    }
    .live-indicator {
      display: inline-block;
      width: 8px;
      height: 8px;
      background: #4CAF50;
      border-radius: 50%;
      margin-right: 8px;
      animation: blink 1s infinite;
    }
    @keyframes blink {
      0%, 50% { opacity: 1; }
      51%, 100% { opacity: 0.3; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 class="title">🏢 Building Analysis</h1>
      <p class="subtitle">Google Open Buildings Dataset</p>
    </div>
    
    <div class="plus-code">${plusCode}</div>
    
    <div class="info-card">
      <div class="info-label">Confidence Score</div>
      <div class="info-value confidence-${confidenceLevel.toLowerCase()}">
        ${confidenceEmoji} ${(building.confidenceScore * 100).toStringAsFixed(1)}% (${confidenceLevel})
      </div>
      <div class="stats-grid">
        <div class="stat-item">
          <span class="stat-number">${building.area.toStringAsFixed(0)}</span>
          <span class="stat-label">Area (m²)</span>
        </div>
        <div class="stat-item">
          <span class="stat-number">${building.polygonPoints.length}</span>
          <span class="stat-label">Points</span>
        </div>
      </div>
    </div>
    
    <div class="classification">
      <span class="classification-icon">${classificationEmoji}</span>
      <div class="info-value">${classification}</div>
    </div>
    
    <div class="coordinates-section">
      <div class="info-label">Geographic Center</div>
      <div class="coordinates">
        📍 Lat: ${center.latitude.toStringAsFixed(6)}<br>
        📍 Lng: ${center.longitude.toStringAsFixed(6)}
      </div>
    </div>
    
    <div class="footer">
      <span class="live-indicator"></span>Live on Liquid Galaxy<br>
      🏗️ Real-time Building Analysis
    </div>
  </div>
</body>
</html>
  ''';

    // Encode HTML content as data URL
    final dataUrl = 'data:text/html;charset=utf-8,${Uri.encodeComponent(htmlContent)}';

    return ScreenOverlayEntity(
      name: 'BuildingDashboard',
      icon: dataUrl,
      overlayX: 1,
      overlayY: 1,
      screenX: 0.98,
      screenY: 0.98,
      sizeX: 420,
      sizeY: 620,
    );
  }
 }