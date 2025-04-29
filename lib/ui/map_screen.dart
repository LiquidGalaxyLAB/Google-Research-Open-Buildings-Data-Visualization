import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  final ApiService apiService = ApiService();

  // Initial map center and zoom
  final LatLng initialCenter = LatLng(28.613939, 77.209021); // Example: Delhi, India
  final double initialZoom = 13.0;

  // List of grid overlays
  List<MapOverlay> overlays = [];

  // Currently selected overlay
  MapOverlay? selectedOverlay;

  // Buildings to display
  List<BuildingData> buildings = [];

  // Loading state
  bool isLoading = false;

  // Current map bounds
  LatLngBounds? currentBounds;

  @override
  void initState() {
    super.initState();
    // We'll generate the initial grid after the first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateGrid();
    });

    // Listen for map movement to update grid
    mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        _generateGrid();
      }
    });
  }

  // Get the current visible map bounds
  LatLngBounds _getCurrentBounds() {
    // If we have stored bounds from a previous calculation, use those as fallback
    if (currentBounds != null) {
      return currentBounds!;
    }

    // Default bounds around the initial center if we can't calculate
    return LatLngBounds(
      LatLng(initialCenter.latitude - 0.05, initialCenter.longitude - 0.05),
      LatLng(initialCenter.latitude + 0.05, initialCenter.longitude + 0.05),
    );
  }

  // Generate a grid of overlays based on current map bounds
  // Generate a grid of overlays based on current map bounds
  void _generateGrid() {
    // For the latest flutter_map versions, we need to work with the current map state

    // Default bounds as fallback
    LatLngBounds bounds;
    double zoom = initialZoom; // Default to initial zoom if we can't get current

    // Try to access map state using reflection since direct access is no longer available
    try {
      // This is a workaround - in a real app, consider refactoring to use flutter_map's
      // latest approach with MapCamera and FollowerWidget which are more reliable

      // Get the current map state from the visible MapOptions
      final mapPosition = mapController.camera;
      final center = mapPosition.center;
      zoom = mapPosition.zoom;

      // Estimate the bounds based on the screen size and zoom level
      // This is an approximation - at zoom level 1, about 0.3 degrees per 100 pixels
      final pixelsToDegrees = 0.3 / zoom;
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

      // Calculate the approximate bounds
      final latSpan = height * pixelsToDegrees / 100;
      final lngSpan = width * pixelsToDegrees / 100;

      bounds = LatLngBounds(
        LatLng(center.latitude - latSpan/2, center.longitude - lngSpan/2),
        LatLng(center.latitude + latSpan/2, center.longitude + lngSpan/2),
      );

      // Store for future reference
      currentBounds = bounds;
    } catch (e) {
      print('Error calculating bounds: $e');
      // Fallback to current bounds or default if we can't calculate
      bounds = currentBounds ?? LatLngBounds(
        LatLng(initialCenter.latitude - 0.05, initialCenter.longitude - 0.05),
        LatLng(initialCenter.latitude + 0.05, initialCenter.longitude + 0.05),
      );
    }

    // Calculate grid size based on zoom level
    // Higher zoom = smaller grid cells
    final gridSizeLat = 0.02 / (zoom / 10);
    final gridSizeLng = 0.02 / (zoom / 10);

    // Calculate number of cells needed to cover the viewport
    final cellsLat = ((bounds.northEast.latitude - bounds.southWest.latitude) / gridSizeLat).ceil();
    final cellsLng = ((bounds.northEast.longitude - bounds.southWest.longitude) / gridSizeLng).ceil();

    List<MapOverlay> newOverlays = [];

    // Create grid cells
    for (int i = 0; i < cellsLat; i++) {
      for (int j = 0; j < cellsLng; j++) {
        final south = bounds.southWest.latitude + (i * gridSizeLat);
        final west = bounds.southWest.longitude + (j * gridSizeLng);
        final north = south + gridSizeLat;
        final east = west + gridSizeLng;

        final overlayBounds = LatLngBounds(
          LatLng(south, west),
          LatLng(north, east),
        );

        newOverlays.add(MapOverlay(
          id: 'overlay_${i}_${j}',
          bounds: overlayBounds,
        ));
      }
    }

    setState(() {
      overlays = newOverlays;
    });
  }

  // Handle tap on an overlay
  void _handleOverlayTap(MapOverlay overlay) async {
    setState(() {
      // Deselect previous overlay
      if (selectedOverlay != null) {
        final index = overlays.indexWhere((o) => o.id == selectedOverlay!.id);
        if (index >= 0) {
          overlays[index] = overlays[index].copyWith(isSelected: false);
        }
      }

      // Select new overlay
      final index = overlays.indexWhere((o) => o.id == overlay.id);
      if (index >= 0) {
        overlays[index] = overlays[index].copyWith(isSelected: true);
        selectedOverlay = overlays[index];
      }

      // Clear previous buildings
      buildings = [];
      isLoading = true;
    });

    try {
      // Fetch buildings in the selected region
      // For MVP, use mock data. Replace with real API call later
      final fetchedBuildings = await apiService.fetchMockBuildingsInRegion(overlay.bounds);

      setState(() {
        buildings = fetchedBuildings;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching buildings: $e');
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load buildings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Buildings Visualizer'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _generateGrid,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialCenter, initialZoom: initialZoom,
              maxZoom: 18.0,
              minZoom: 3.0,
              onTap: (_, point) {
                // Find which overlay was tapped
                for (final overlay in overlays) {
                  if (overlay.containsPoint(point)) {
                    _handleOverlayTap(overlay);
                    break;
                  }
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              // Draw the grid overlays
              PolygonLayer(
                polygons: overlays.map((overlay) {
                  return Polygon(
                    points: [
                      overlay.bounds.southWest,
                      LatLng(overlay.bounds.northEast.latitude, overlay.bounds.southWest.longitude),
                      overlay.bounds.northEast,
                      LatLng(overlay.bounds.southWest.latitude, overlay.bounds.northEast.longitude),
                    ],
                    borderColor: overlay.isSelected ? Colors.red : Colors.blue,
                    borderStrokeWidth: 2.0,
                    color: overlay.isSelected ?
                    Colors.red.withOpacity(0.2) :
                    Colors.blue.withOpacity(0.1),
                  );
                }).toList(),
              ),
              // Draw building footprints
              PolygonLayer(
                polygons: buildings.map((building) {
                  // Color based on confidence score
                  final color = building.confidenceScore > 0.8 ?
                  Colors.green :
                  (building.confidenceScore > 0.5 ?
                  Colors.orange :
                  Colors.red);

                  return Polygon(
                    points: building.polygonPoints,
                    borderColor: color,
                    borderStrokeWidth: 1.5,
                    color: color.withOpacity(0.5),
                  );
                }).toList(),
              ),
            ],
          ),
          // Loading indicator
          if (isLoading)
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading buildings...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          // Information panel when buildings are loaded
          if (buildings.isNotEmpty && selectedOverlay != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Visualize Buildings in Selected Region',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),

                    SizedBox(height: 4),
                    Text(
                      'Region: ${selectedOverlay!.bounds.southWest.latitude.toStringAsFixed(4)}, '
                          '${selectedOverlay!.bounds.southWest.longitude.toStringAsFixed(4)} to '
                          '${selectedOverlay!.bounds.northEast.latitude.toStringAsFixed(4)}, '
                          '${selectedOverlay!.bounds.northEast.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Here you would implement sending to Liquid Galaxy
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sending to Liquid Galaxy...')),
                        );
                      },
                      child: Text('Send to Liquid Galaxy'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}