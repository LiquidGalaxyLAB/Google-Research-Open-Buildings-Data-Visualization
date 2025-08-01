// ui/map_screen.dart - THEMED VERSION WITH APP COLORS AND LOCALIZATION
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proofofconceptapp/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:proofofconceptapp/ui/settings_screen.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/api_service.dart';
import '../services/lg_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:proofofconceptapp/components/selected_region_bottom_sheet.dart' hide LatLng;
import '../utils/colors.dart';
import 'help_screen.dart';
import '../l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  final ApiService apiService = ApiService();
  final TextEditingController searchController = TextEditingController();
  bool showBottomSheet = false;

  // Initial map center and zoom
  final LatLng initialCenter = LatLng(28.613939, 77.209021);
  final double initialZoom = 13.0;

  // FIXED: More restrictive zoom constraints for better UX
  static const double minZoom = 12.0;  // Increased from 8.0
  static const double maxZoom = 16.0;  // Decreased from 18.0
  static const double zoomStep = 1.0;  // Fixed zoom step

  // FIXED OVERLAY SETTINGS
  static const double fixedOverlaySize = 0.01;
  static const double maxOverlaySize = 0.025;
  static const double minOverlaySize = 0.005;

  double currentOverlaySize = fixedOverlaySize;

  // List of grid overlays
  List<MapOverlay> overlays = [];

  // Currently selected overlay
  MapOverlay? selectedOverlay;

  // Buildings to display
  List<BuildingData> buildings = [];

  // Selected building for highlighting
  BuildingData? selectedBuilding;

  // Building markers list
  List<Marker> buildingMarkers = [];

  // Loading state
  bool isLoading = false;

  // Search related variables
  List<SearchResult> searchResults = [];
  bool isSearching = false;
  bool showSearchResults = false;
  FocusNode searchFocusNode = FocusNode();

  // FIXED: Current zoom level with proper initialization
  double currentZoom = 13.0;

  @override
  void initState() {
    super.initState();

    // Initialize map after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateFixedSizeGrid();
      _updateCurrentZoom();
    });

    // FIXED: Better map event handling with zoom constraints
    mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        _generateFixedSizeGrid();
        _updateCurrentZoom();
        // FIXED: Enforce zoom constraints on map events
        _enforceZoomConstraints();
      }
    });

    // Search focus listener
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus && searchController.text.isEmpty) {
        setState(() {
          showSearchResults = false;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  // FIXED: More robust zoom level tracking
  void _updateCurrentZoom() {
    try {
      final newZoom = mapController.camera.zoom;
      // FIXED: Clamp the zoom level and update state
      final clampedZoom = newZoom.clamp(minZoom, maxZoom);
      if (mounted && (currentZoom - clampedZoom).abs() > 0.01) {
        setState(() {
          currentZoom = clampedZoom;
        });
      }
    } catch (e) {
      print('Error updating zoom: $e');
      // FIXED: Fallback to a safe zoom level
      if (mounted) {
        setState(() {
          currentZoom = initialZoom.clamp(minZoom, maxZoom);
        });
      }
    }
  }

  // FIXED: Enforce zoom constraints programmatically with toast notification
  void _enforceZoomConstraints() {
    try {
      final currentMapZoom = mapController.camera.zoom;
      if (currentMapZoom < minZoom || currentMapZoom > maxZoom) {
        final clampedZoom = currentMapZoom.clamp(minZoom, maxZoom);
        mapController.move(mapController.camera.center, clampedZoom);

        // Show toast notification when zoom limit is reached
        if (mounted) {
          String message;
          if (currentMapZoom < minZoom) {
            message = AppLocalizations.of(context)!.map_zoom_out_limit(minZoom.toInt().toString());
          } else {
            message = AppLocalizations.of(context)!.map_zoom_in_limit(maxZoom.toInt().toString());
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: TextStyle(color: AppColors.onSurface),
              ),
              backgroundColor: AppColors.surfaceContainer,
              duration: Duration(milliseconds: 1500),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 100, left: 16, right: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error enforcing zoom constraints: $e');
    }
  }

  // FIXED: Improved zoom in with immediate grid regeneration and limit message
  void _zoomIn() {
    if (currentZoom >= maxZoom) {
      // Show message when zoom limit is reached
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_zoom_in_limit(maxZoom.toInt().toString()),
              style: TextStyle(color: AppColors.onSurface),
            ),
            backgroundColor: AppColors.surfaceContainer,
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100, left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
      return;
    }

    final newZoom = (currentZoom + zoomStep).clamp(minZoom, maxZoom);
    if (newZoom != currentZoom) {
      mapController.move(mapController.camera.center, newZoom);
      setState(() {
        currentZoom = newZoom;
      });

      // FIXED: Force grid regeneration immediately after zoom
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _generateFixedSizeGrid();
        }
      });
    }
  }

  // FIXED: Improved zoom out with immediate grid regeneration and limit message
  void _zoomOut() {
    if (currentZoom <= minZoom) {
      // Show message when zoom limit is reached
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_zoom_out_limit(minZoom.toInt().toString()),
              style: TextStyle(color: AppColors.onSurface),
            ),
            backgroundColor: AppColors.surfaceContainer,
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100, left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
      return;
    }

    final newZoom = (currentZoom - zoomStep).clamp(minZoom, maxZoom);
    if (newZoom != currentZoom) {
      mapController.move(mapController.camera.center, newZoom);
      setState(() {
        currentZoom = newZoom;
      });

      // FIXED: Force grid regeneration immediately after zoom
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _generateFixedSizeGrid();
        }
      });
    }
  }

  // Handle building selection from bottom sheet
  void _onBuildingSelected(BuildingData building) {
    setState(() {
      selectedBuilding = building;
    });

    // Calculate building center point
    final buildingCenter = _calculateBuildingCenter(building);

    // Create marker for the selected building
    final marker = Marker(
      point: buildingCenter,
      width: 40,
      height: 40,
      child: _buildBuildingMarker(building, isSelected: true),
    );

    setState(() {
      // Clear previous markers and add new one
      buildingMarkers = [marker];
    });

    // FIXED: Animate to building location with zoom constraint
    final targetZoom = max(currentZoom, 15.0).clamp(minZoom, maxZoom);
    mapController.move(buildingCenter, targetZoom);

    // Show building info
    _showBuildingInfo(building);
  }

  // Calculate center point of a building polygon
  LatLng _calculateBuildingCenter(BuildingData building) {
    if (building.polygonPoints.isEmpty) {
      // Fallback to overlay center if no polygon points
      if (selectedOverlay != null) {
        return LatLng(
          (selectedOverlay!.bounds.southWest.latitude + selectedOverlay!.bounds.northEast.latitude) / 2,
          (selectedOverlay!.bounds.southWest.longitude + selectedOverlay!.bounds.northEast.longitude) / 2,
        );
      }
      return initialCenter;
    }

    double totalLat = 0;
    double totalLng = 0;

    for (final point in building.polygonPoints) {
      totalLat += point.latitude;
      totalLng += point.longitude;
    }

    return LatLng(
      totalLat / building.polygonPoints.length,
      totalLng / building.polygonPoints.length,
    );
  }

  // Build marker widget for buildings
  Widget _buildBuildingMarker(BuildingData building, {bool isSelected = false}) {
    final color = isSelected
        ? AppColors.error
        : (building.confidenceScore > 0.8 ? Colors.green :
    building.confidenceScore > 0.5 ? Colors.orange : AppColors.error);

    return GestureDetector(
      onTap: () => _showBuildingInfo(building),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.surfaceContainerLowest,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.apartment,
          color: AppColors.onPrimary,
          size: isSelected ? 24 : 20,
        ),
      ),
    );
  }

  // Show building information popup with LG integration
  void _showBuildingInfo(BuildingData building) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<LGService>(
          builder: (context, lgService, child) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.apartment, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.map_building_details_title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    AppLocalizations.of(context)!.map_building_area_label,
                    '${building.area.toStringAsFixed(0)} m²',
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.map_building_confidence_label,
                    '${(building.confidenceScore * 100).toStringAsFixed(1)}%',
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.map_building_points_label,
                    '${building.polygonPoints.length}',
                  ),
                  if (building.polygonPoints.isNotEmpty) ...[
                    SizedBox(height: 8),
                    _buildInfoRow(
                      AppLocalizations.of(context)!.map_building_center_label,
                      '${_calculateBuildingCenter(building).latitude.toStringAsFixed(5)}, '
                          '${_calculateBuildingCenter(building).longitude.toStringAsFixed(5)}',
                    ),
                  ],
                  SizedBox(height: 16),
                  // Connection status indicator
                  Row(
                    children: [
                      Icon(
                        lgService.isConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: lgService.isConnected ? Colors.green : AppColors.error,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        lgService.isConnected
                            ? AppLocalizations.of(context)!.map_lg_connected
                            : AppLocalizations.of(context)!.map_lg_disconnected,
                        style: TextStyle(
                          color: lgService.isConnected ? Colors.green : AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.map_building_close,
                    style: TextStyle(color: AppColors.onSurface),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: lgService.isConnected ? () async {
                    Navigator.of(context).pop();
                    await _sendBuildingToLiquidGalaxy(building, lgService);
                  } : null,
                  icon: Icon(Icons.send, size: 16),
                  label: Text(AppLocalizations.of(context)!.map_building_send_to_lg),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lgService.isConnected ? AppColors.primary : AppColors.surfaceDim,
                    foregroundColor: lgService.isConnected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Send individual building to Liquid Galaxy
  Future<void> _sendBuildingToLiquidGalaxy(BuildingData building, LGService lgService) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.map_sending_building_to_lg,
                style: TextStyle(color: AppColors.onSurface),
              ),
            ],
          ),
        ),
      );

      // Create KML content for the building
      String buildingKML = _createBuildingKML(building);

      // Send to Liquid Galaxy using the centralized service
      await lgService.sendKMLToSlave(buildingKML, 2); // Send to slave 2

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_building_sent_success,
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
              AppLocalizations.of(context)!.map_building_send_failed(e.toString()),
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

  // Create KML content for individual building
  String _createBuildingKML(BuildingData building) {
    final center = _calculateBuildingCenter(building);

    // Create coordinates string for the polygon
    String coordinates = building.polygonPoints
        .map((point) => '${point.longitude},${point.latitude},0')
        .join(' ');

    // Close the polygon by adding the first point at the end
    if (building.polygonPoints.isNotEmpty) {
      final firstPoint = building.polygonPoints.first;
      coordinates += ' ${firstPoint.longitude},${firstPoint.latitude},0';
    }

    String placemark = '''
      <Placemark>
        <name>Open Buildings - Building Footprint</name>
        <description>
          <![CDATA[
            <b>Building Information:</b><br/>
            Area: ${building.area.toStringAsFixed(0)} m²<br/>
            Confidence Score: ${(building.confidenceScore * 100).toStringAsFixed(1)}%<br/>
            Number of Points: ${building.polygonPoints.length}<br/>
            Center: ${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}
          ]]>
        </description>
        <Style>
          <LineStyle>
            <color>ff0000ff</color>
            <width>3</width>
          </LineStyle>
          <PolyStyle>
            <color>7f0000ff</color>
          </PolyStyle>
        </Style>
        <Polygon>
          <extrude>1</extrude>
          <altitudeMode>clampToGround</altitudeMode>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>$coordinates</coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
        <LookAt>
          <longitude>${center.longitude}</longitude>
          <latitude>${center.latitude}</latitude>
          <altitude>0</altitude>
          <heading>0</heading>
          <tilt>45</tilt>
          <range>500</range>
          <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
        </LookAt>
      </Placemark>
    ''';

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="slave_2">
    <name>Open Buildings Visualization</name>
    <open>1</open>
    <Folder>
      <name>Selected Building</name>
      <open>1</open>
      $placemark
    </Folder>
  </Document>
</kml>''';
  }

  // Handle sending entire region to Liquid Galaxy
  Future<void> _handleSendRegionToLiquidGalaxy() async {
    final lgService = Provider.of<LGService>(context, listen: false);

    if (!lgService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.map_connect_lg_first,
            style: TextStyle(color: AppColors.onSurface),
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.map_connect_action,
            textColor: AppColors.onPrimary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiquidGalaxyConfigScreen()),
              );
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.map_sending_region_to_lg,
                style: TextStyle(color: AppColors.onSurface),
              ),
            ],
          ),
        ),
      );

      // Create KML for the entire region with all buildings
      String regionKML = _createRegionKML();

      // Send to Liquid Galaxy
      await lgService.sendKMLToSlave(regionKML, 2);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_region_sent_success(buildings.length),
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
              AppLocalizations.of(context)!.map_region_send_failed(e.toString()),
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

  // Create KML for entire region with all buildings
  String _createRegionKML() {
    if (selectedOverlay == null) return '';

    String placemarks = '';

    for (int i = 0; i < buildings.length; i++) {
      final building = buildings[i];
      final center = _calculateBuildingCenter(building);

      // Create coordinates string for the polygon
      String coordinates = building.polygonPoints
          .map((point) => '${point.longitude},${point.latitude},0')
          .join(' ');

      // Close the polygon by adding the first point at the end
      if (building.polygonPoints.isNotEmpty) {
        final firstPoint = building.polygonPoints.first;
        coordinates += ' ${firstPoint.longitude},${firstPoint.latitude},0';
      }

      // Color based on confidence score
      String color = building.confidenceScore > 0.8
          ? '7f00ff00'  // Green with transparency
          : building.confidenceScore > 0.5
          ? '7f0080ff'  // Orange with transparency
          : '7f0000ff';  // Red with transparency

      String lineColor = building.confidenceScore > 0.8
          ? 'ff00ff00'  // Green
          : building.confidenceScore > 0.5
          ? 'ff0080ff'  // Orange
          : 'ff0000ff';  // Red

      placemarks += '''
        <Placemark>
          <name>Building ${i + 1}</name>
          <description>
            <![CDATA[
              <b>Building ${i + 1}</b><br/>
              Area: ${building.area.toStringAsFixed(0)} m²<br/>
              Confidence: ${(building.confidenceScore * 100).toStringAsFixed(1)}%<br/>
              Points: ${building.polygonPoints.length}<br/>
              Center: ${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}
            ]]>
          </description>
          <Style>
            <LineStyle>
              <color>$lineColor</color>
              <width>2</width>
            </LineStyle>
            <PolyStyle>
              <color>$color</color>
            </PolyStyle>
          </Style>
          <Polygon>
            <extrude>1</extrude>
            <altitudeMode>clampToGround</altitudeMode>
            <outerBoundaryIs>
              <LinearRing>
                <coordinates>$coordinates</coordinates>
              </LinearRing>
            </outerBoundaryIs>
          </Polygon>
        </Placemark>
      ''';
    }

    // Calculate region center for LookAt
    final regionCenter = LatLng(
      (selectedOverlay!.bounds.southWest.latitude + selectedOverlay!.bounds.northEast.latitude) / 2,
      (selectedOverlay!.bounds.southWest.longitude + selectedOverlay!.bounds.northEast.longitude) / 2,
    );

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="slave_2">
    <name>Open Buildings - Region Visualization</name>
    <open>1</open>
    <description>Region containing ${buildings.length} buildings from Google Open Buildings dataset</description>
    <LookAt>
      <longitude>${regionCenter.longitude}</longitude>
      <latitude>${regionCenter.latitude}</latitude>
      <altitude>0</altitude>
      <heading>0</heading>
      <tilt>60</tilt>
      <range>2000</range>
      <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
    </LookAt>
    <Folder>
      <name>Buildings (${buildings.length} total)</name>
      <open>1</open>
      $placemarks
    </Folder>
  </Document>
</kml>''';
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }

  // Clear building selection
  void _clearBuildingSelection() {
    setState(() {
      selectedBuilding = null;
      buildingMarkers.clear();
    });
  }

  // FIXED SIZE GRID GENERATION
  void _generateFixedSizeGrid() {
    LatLngBounds bounds = _getCurrentBounds();

    final latSpan = bounds.northEast.latitude - bounds.southWest.latitude;
    final lngSpan = bounds.northEast.longitude - bounds.southWest.longitude;

    final cellsLat = (latSpan / currentOverlaySize).ceil() + 2;
    final cellsLng = (lngSpan / currentOverlaySize).ceil() + 2;

    final startLat = bounds.southWest.latitude - currentOverlaySize;
    final startLng = bounds.southWest.longitude - currentOverlaySize;

    List<MapOverlay> newOverlays = [];

    for (int i = 0; i < cellsLat; i++) {
      for (int j = 0; j < cellsLng; j++) {
        final south = startLat + (i * currentOverlaySize);
        final west = startLng + (j * currentOverlaySize);
        final north = south + currentOverlaySize;
        final east = west + currentOverlaySize;

        final overlayBounds = LatLngBounds(
          LatLng(south, west),
          LatLng(north, east),
        );

        newOverlays.add(MapOverlay(
          id: 'fixed_overlay_${i}_${j}',
          bounds: overlayBounds,
        ));
      }
    }

    if (mounted) {
      setState(() {
        overlays = newOverlays;
      });
    }
  }

  LatLngBounds _getCurrentBounds() {
    try {
      final center = mapController.camera.center;
      final zoom = mapController.camera.zoom;

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final degreesPerPixel = 360 / (256 * pow(2, zoom));

      final latSpan = (screenHeight * degreesPerPixel) / 2;
      final lngSpan = (screenWidth * degreesPerPixel) / 2;

      return LatLngBounds(
        LatLng(center.latitude - latSpan, center.longitude - lngSpan),
        LatLng(center.latitude + latSpan, center.longitude + lngSpan),
      );
    } catch (e) {
      return LatLngBounds(
        LatLng(initialCenter.latitude - 0.05, initialCenter.longitude - 0.05),
        LatLng(initialCenter.latitude + 0.05, initialCenter.longitude + 0.05),
      );
    }
  }

  void _adjustOverlaySize(double delta) {
    setState(() {
      currentOverlaySize = (currentOverlaySize + delta).clamp(minOverlaySize, maxOverlaySize);
    });
    _generateFixedSizeGrid();
  }

  double _getOverlayAreaInKm() {
    final areaInDegrees = currentOverlaySize * currentOverlaySize;
    return areaInDegrees * 111 * 111;
  }

  // Search functionality
  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        showSearchResults = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      showSearchResults = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5&addressdetails=1',
        ),
        headers: {
          'User-Agent': 'OpenBuildingsVisualizer/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            searchResults = data.map((item) => SearchResult.fromJson(item)).toList();
            isSearching = false;
          });
        }
      } else {
        throw Exception('Failed to search places');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isSearching = false;
          searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_search_failed,
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

  void _goToLocation(SearchResult result) {
    final latLng = LatLng(result.lat, result.lon);
    // FIXED: Respect zoom constraints when navigating to search results
    final targetZoom = 15.0.clamp(minZoom, maxZoom);
    mapController.move(latLng, targetZoom);
    setState(() {
      showSearchResults = false;
      searchResults = [];
      currentZoom = targetZoom;
    });
    searchFocusNode.unfocus();
    searchController.text = result.displayName;
  }

  void _clearSearch() {
    searchController.clear();
    setState(() {
      searchResults = [];
      showSearchResults = false;
    });
    searchFocusNode.unfocus();
  }

  // Handle overlay tap
  void _handleOverlayTap(MapOverlay overlay) async {
    // Clear any existing building selection when selecting new overlay
    _clearBuildingSelection();

    setState(() {
      if (selectedOverlay != null) {
        final index = overlays.indexWhere((o) => o.id == selectedOverlay!.id);
        if (index >= 0) {
          overlays[index] = overlays[index].copyWith(isSelected: false);
        }
      }

      final index = overlays.indexWhere((o) => o.id == overlay.id);
      if (index >= 0) {
        overlays[index] = overlays[index].copyWith(isSelected: true);
        selectedOverlay = overlays[index];
      }

      buildings = [];
      isLoading = true;
      showBottomSheet = true;
    });

    try {
      final fetchedBuildings = await apiService.fetchBuildingsInRegion(overlay.bounds);
      if (mounted) {
        setState(() {
          buildings = fetchedBuildings;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.map_buildings_load_failed(e.toString()),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (showBottomSheet) {
          setState(() {
            showBottomSheet = false;
            _clearBuildingSelection();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.map_title,
            style: TextStyle(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            // Connection status indicator
            Consumer<LGService>(
              builder: (context, lgService, child) {
                return IconButton(
                  icon: Icon(
                    lgService.isConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: lgService.isConnected ? Colors.green : AppColors.error,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LiquidGalaxyConfigScreen()),
                    );
                  },
                  tooltip: lgService.isConnected
                      ? AppLocalizations.of(context)!.map_lg_connected
                      : AppLocalizations.of(context)!.map_lg_disconnected,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings, color: AppColors.onPrimary),
              onPressed: _togosettings,
            ),
            IconButton(
              icon: Icon(Icons.help, color: AppColors.onPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpScreen()),
                );
              },
            ),
            // Clear selection button
            if (selectedBuilding != null)
              IconButton(
                icon: Icon(Icons.clear_all, color: AppColors.onPrimary),
                onPressed: _clearBuildingSelection,
                tooltip: AppLocalizations.of(context)!.map_clear_selection_tooltip,
              ),
          ],
        ),
        body: Stack(
          children: [
            // FIXED: THE ACTUAL MAP WIDGET WITH PROPER ZOOM CONSTRAINTS
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
                // FIXED: Enforce zoom constraints in MapOptions
                maxZoom: maxZoom,
                minZoom: minZoom,
                // FIXED: Add interactionOptions to control zoom behavior
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                  // FIXED: Ensure pinch-to-zoom respects constraints
                  enableMultiFingerGestureRace: true,
                ),
                onTap: (_, point) {
                  if (showSearchResults) {
                    setState(() {
                      showSearchResults = false;
                    });
                    searchFocusNode.unfocus();
                  }

                  // Check if we tapped on an overlay
                  bool overlayTapped = false;
                  for (final overlay in overlays) {
                    if (overlay.containsPoint(point)) {
                      _handleOverlayTap(overlay);
                      overlayTapped = true;
                      break;
                    }
                  }

                  // If no overlay was tapped, clear building selection
                  if (!overlayTapped) {
                    _clearBuildingSelection();
                  }
                },
              ),
              children: [
                // CARTODB TILE LAYER - WORKS WITHOUT 403 ERRORS
                TileLayer(
                  urlTemplate: 'https://api.maptiler.com/maps/basic-v2/{z}/{x}/{y}.png?key=5xIHDp2mW8tDgquyuMMy',
                  userAgentPackageName: 'com.example.openbuildings',
                  maxZoom: 20,
                  additionalOptions: const {
                    'attribution': '© MapTiler © OpenStreetMap contributors',
                  },
                ),

                // Fixed-size grid overlays with improved aesthetics
                PolygonLayer(
                  polygons: overlays.map((overlay) {
                    return Polygon(
                      points: [
                        overlay.bounds.southWest,
                        LatLng(overlay.bounds.northEast.latitude, overlay.bounds.southWest.longitude),
                        overlay.bounds.northEast,
                        LatLng(overlay.bounds.southWest.latitude, overlay.bounds.northEast.longitude),
                      ],
                      // THEMED: Using AppColors for overlay styling
                      borderColor: overlay.isSelected ? AppColors.error : AppColors.outline,
                      borderStrokeWidth: 2.0,
                      color: overlay.isSelected
                          ? AppColors.error.withOpacity(0.2)
                          : AppColors.outlineVariant.withOpacity(0.15),
                    );
                  }).toList(),
                ),

                // Building footprints
                PolygonLayer(
                  polygons: buildings.map((building) {
                    final isHighlighted = selectedBuilding != null &&
                        selectedBuilding!.polygonPoints == building.polygonPoints;

                    final color = isHighlighted
                        ? AppColors.error
                        : (building.confidenceScore > 0.8
                        ? Colors.green
                        : (building.confidenceScore > 0.5 ? Colors.orange : AppColors.error));

                    return Polygon(
                      points: building.polygonPoints,
                      borderColor: color,
                      borderStrokeWidth: isHighlighted ? 3.0 : 1.5,
                      color: color.withOpacity(isHighlighted ? 0.7 : 0.5),
                    );
                  }).toList(),
                ),

                // Building markers layer
                MarkerLayer(
                  markers: buildingMarkers,
                ),
              ],
            ),

            // Search Bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      style: TextStyle(color: AppColors.onSurface),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.map_search_hint,
                        hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                        prefixIcon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, color: AppColors.onSurfaceVariant),
                          onPressed: _clearSearch,
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onChanged: (value) {
                        Future.delayed(Duration(milliseconds: 500), () {
                          if (searchController.text == value) {
                            _searchPlaces(value);
                          }
                        });
                      },
                      onTap: () {
                        if (searchResults.isNotEmpty || searchController.text.isNotEmpty) {
                          setState(() {
                            showSearchResults = true;
                          });
                        }
                      },
                    ),
                  ),
                  // Search results
                  if (showSearchResults)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(maxHeight: 200),
                      child: isSearching
                          ? Container(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)!.map_searching,
                                style: TextStyle(color: AppColors.onSurface),
                              ),
                            ],
                          ),
                        ),
                      )
                          : searchResults.isEmpty
                          ? Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          AppLocalizations.of(context)!.map_search_no_results,
                          style: TextStyle(color: AppColors.onSurfaceVariant),
                        ),
                      )
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ListTile(
                            leading: Icon(Icons.location_on, color: AppColors.primary),
                            title: Text(
                              result.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              result.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _goToLocation(result),
                            dense: true,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // THEMED: Enhanced Controls Panel with AppColors
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.map_overlay_size_label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${_getOverlayAreaInKm().toStringAsFixed(1)} km²',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => _adjustOverlaySize(-0.002),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: AppColors.onPrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => _adjustOverlaySize(0.002),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: AppColors.onPrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // THEMED: Improved zoom controls with AppColors
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: currentZoom < maxZoom ? _zoomIn : null,
                        child: Container(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.add,
                            color: currentZoom >= maxZoom ? AppColors.surfaceDim : AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // THEMED: Improved zoom level display with AppColors
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${currentZoom.toStringAsFixed(1)}x',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          '${minZoom.toInt()}-${maxZoom.toInt()}',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: currentZoom > minZoom ? _zoomOut : null,
                        child: Container(
                          width: 48,
                          height: 48,
                          child: Icon(
                            Icons.remove,
                            color: currentZoom <= minZoom ? AppColors.surfaceDim : AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // THEMED: Loading indicator with AppColors
            if (isLoading)
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.map_loading_buildings,
                        style: TextStyle(color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom Sheet
            if (selectedOverlay != null && showBottomSheet)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showBottomSheet = false;
                      _clearBuildingSelection();
                    });
                  },
                  child: Container(
                    color: Colors.black26,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {},
                        child: SelectedRegionBottomSheet(
                          selectedOverlay: selectedOverlay!,
                          buildings: buildings,
                          isLoading: isLoading,
                          onSendToLiquidGalaxy: _handleSendRegionToLiquidGalaxy,
                          onBuildingTap: _onBuildingSelected,
                          onVisualizeHistoricalChanges: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.map_loading_historical_data,
                                  style: TextStyle(color: AppColors.onSurface),
                                ),
                                backgroundColor: AppColors.surfaceContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // THEMED: Selected building info banner with AppColors
            if (selectedBuilding != null)
              Positioned(
                bottom: showBottomSheet ? MediaQuery.of(context).size.height * 0.6 + 20 : 20,
                left: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.apartment, color: AppColors.onError, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.map_selected_building_title,
                              style: TextStyle(
                                color: AppColors.onError,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.map_selected_building_info(
                                selectedBuilding!.area.toStringAsFixed(0),
                                (selectedBuilding!.confidenceScore * 100).toStringAsFixed(0),
                              ),
                              style: TextStyle(
                                color: AppColors.onError.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _clearBuildingSelection,
                        icon: Icon(Icons.close, color: AppColors.onError, size: 18),
                        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
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

  void _togosettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }
}

// Search Result Model
class SearchResult {
  final String name;
  final String displayName;
  final String address;
  final double lat;
  final double lon;

  SearchResult({
    required this.name,
    required this.displayName,
    required this.address,
    required this.lat,
    required this.lon,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      name: json['name'] ?? json['display_name']?.split(',')[0] ??
          'Unknown Location',
      displayName: json['display_name'] ?? 'Unknown Location',
      address: json['display_name'] ?? 'Unknown Address',
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
    );
  }
}