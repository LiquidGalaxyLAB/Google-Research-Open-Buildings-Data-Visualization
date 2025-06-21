import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proofofconceptapp/ui/settings_screen.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:proofofconceptapp/components/selected_region_bottom_sheet.dart';


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
  final LatLng initialCenter = LatLng(28.613939, 77.209021); // Example: Delhi, India
  final double initialZoom = 13.0;

  // Zoom constraints
  static const double minZoom = 8.0;  // Minimum zoom to prevent too large areas
  static const double maxZoom = 18.0; // Maximum zoom for detailed view
  static const double optimalMinZoom = 10.0; // Below this, overlays become too large

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

  // Search related variables
  List<SearchResult> searchResults = [];
  bool isSearching = false;
  bool showSearchResults = false;
  FocusNode searchFocusNode = FocusNode();

  // Zoom related variables
  double currentZoom = 13.0;
  bool showZoomWarning = false;

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
        _updateCurrentZoom();
      }
    });

    // Listen for search focus changes
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

  // Update current zoom level and show warnings if needed
  void _updateCurrentZoom() {
    try {
      final newZoom = mapController.camera.zoom;
      setState(() {
        currentZoom = newZoom;
        // Show warning if zoom is too low (area too large for API)
        if (newZoom < optimalMinZoom) {
          showZoomWarning = true;
          // Auto hide warning after 3 seconds
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showZoomWarning = false;
              });
            }
          });
        } else {
          showZoomWarning = false;
        }
      });
    } catch (e) {
      print('Error updating zoom: $e');
    }
  }

  // Zoom in
  void _zoomIn() {
    final newZoom = (currentZoom + 1).clamp(minZoom, maxZoom);
    mapController.move(mapController.camera.center, newZoom);
  }

  // Zoom out
  void _zoomOut() {
    final newZoom = (currentZoom - 1).clamp(minZoom, maxZoom);
    mapController.move(mapController.camera.center, newZoom);
  }

  // Search for places using Nominatim API
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
        setState(() {
          searchResults = data.map((item) => SearchResult.fromJson(item)).toList();
          isSearching = false;
        });
      } else {
        throw Exception('Failed to search places');
      }
    } catch (e) {
      print('Search error: $e');
      setState(() {
        isSearching = false;
        searchResults = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed. Please try again.')),
      );
    }
  }

  // Navigate to selected location
  void _goToLocation(SearchResult result) {
    final latLng = LatLng(result.lat, result.lon);

    // Animate to the location
    mapController.move(latLng, 15.0);

    // Clear search and hide results
    setState(() {
      showSearchResults = false;
      searchResults = [];
    });

    // Unfocus search field
    searchFocusNode.unfocus();

    // Update search text to show selected location
    searchController.text = result.displayName;
  }

  // Clear search
  void _clearSearch() {
    searchController.clear();
    setState(() {
      searchResults = [];
      showSearchResults = false;
    });
    searchFocusNode.unfocus();
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

    // Calculate adaptive grid size based on zoom level
    // The grid size gets smaller as zoom increases, and larger as zoom decreases
    double baseGridSize = 0.01;
    double zoomFactor = zoom / 13.0; // Normalize to our initial zoom

    // Dynamic grid sizing with more intelligent scaling
    double gridSizeLat, gridSizeLng;

    if (zoom < 10) {
      // Large areas - bigger grid cells to prevent API overload
      gridSizeLat = baseGridSize * 4 / zoomFactor;
      gridSizeLng = baseGridSize * 4 / zoomFactor;
    } else if (zoom < 13) {
      // Medium areas - standard grid cells
      gridSizeLat = baseGridSize * 2 / zoomFactor;
      gridSizeLng = baseGridSize * 2 / zoomFactor;
    } else {
      // Small areas - smaller grid cells for precision
      gridSizeLat = baseGridSize / zoomFactor;
      gridSizeLng = baseGridSize / zoomFactor;
    }

    // Ensure minimum grid size to prevent too many cells
    gridSizeLat = gridSizeLat.clamp(0.002, 0.1);
    gridSizeLng = gridSizeLng.clamp(0.002, 0.1);

    // Calculate number of cells needed to cover the viewport
    final cellsLat = ((bounds.northEast.latitude - bounds.southWest.latitude) / gridSizeLat).ceil();
    final cellsLng = ((bounds.northEast.longitude - bounds.southWest.longitude) / gridSizeLng).ceil();

    // Limit maximum number of cells to prevent performance issues
    final maxCells = 50;
    if (cellsLat * cellsLng > maxCells * maxCells) {
      print('Warning: Too many grid cells (${cellsLat * cellsLng}), reducing grid density');
      // Increase grid size to reduce cell count
      final scaleFactor = sqrt(cellsLat * cellsLng / (maxCells * maxCells)); // Fixed: use sqrt function
      gridSizeLat *= scaleFactor;
      gridSizeLng *= scaleFactor;
    }

    List<MapOverlay> newOverlays = [];

    // Create grid cells
    final actualCellsLat = ((bounds.northEast.latitude - bounds.southWest.latitude) / gridSizeLat).ceil().clamp(1, maxCells);
    final actualCellsLng = ((bounds.northEast.longitude - bounds.southWest.longitude) / gridSizeLng).ceil().clamp(1, maxCells);

    for (int i = 0; i < actualCellsLat; i++) {
      for (int j = 0; j < actualCellsLng; j++) {
        final south = bounds.southWest.latitude + (i * gridSizeLat);
        final west = bounds.southWest.longitude + (j * gridSizeLng);
        final north = (south + gridSizeLat).clamp(bounds.southWest.latitude, bounds.northEast.latitude);
        final east = (west + gridSizeLng).clamp(bounds.southWest.longitude, bounds.northEast.longitude);

        final overlayBounds = LatLngBounds(
          LatLng(south, west),
          LatLng(north, east),
        );

        newOverlays.add(MapOverlay(
          id: 'overlay_${i}_${j}_${zoom.toStringAsFixed(1)}',
          bounds: overlayBounds,
        ));
      }
    }

    setState(() {
      overlays = newOverlays;
    });

    print('Generated ${newOverlays.length} grid cells at zoom level ${zoom.toStringAsFixed(1)}');
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
      showBottomSheet = true; // Add this line
    });

    try {
      // Fetch buildings in the selected region
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
    return WillPopScope(
        onWillPop: () async {
      if (showBottomSheet) {
        setState(() {
          showBottomSheet = false;
        });
        return false;
      }
      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Open Buildings Visualizer'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: _togosettings,
          ),
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
              initialCenter: initialCenter,
              initialZoom: initialZoom,
              maxZoom: maxZoom,
              minZoom: minZoom,
              onTap: (_, point) {
                // Hide search results when map is tapped
                if (showSearchResults) {
                  setState(() {
                    showSearchResults = false;
                  });
                  searchFocusNode.unfocus();
                }

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

          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    decoration: InputDecoration(
                      hintText: 'Search for a location',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: _clearSearch,
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (value) {
                      // Debounce search to avoid too many API calls
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

                // Search Results
                if (showSearchResults)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Searching...'),
                          ],
                        ),
                      ),
                    )
                        : searchResults.isEmpty
                        ? Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.blue),
                          title: Text(
                            result.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            result.address,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

          // Zoom Controls
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                // Zoom In Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          color: currentZoom < maxZoom ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Current Zoom Level Indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${currentZoom.toStringAsFixed(1)}x',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: currentZoom < optimalMinZoom ? Colors.orange : Colors.black87,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Zoom Out Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          color: currentZoom > minZoom ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Zoom Warning
          if (showZoomWarning)
            Positioned(
              top: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Zoom in for better performance. Large areas may cause API limitations.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
          // Bottom Sheet
          if (buildings.isNotEmpty && selectedOverlay != null && showBottomSheet)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showBottomSheet = false;
                  });
                },
                child: Container(
                  color: Colors.black26,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {}, // Prevent closing when tapping the sheet
                      child: SelectedRegionBottomSheet(
                        selectedOverlay: selectedOverlay!,
                        buildings: buildings,
                        isLoading: isLoading,
                        onSendToLiquidGalaxy: () {
                          // Your existing Liquid Galaxy logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sending to Liquid Galaxy...')),
                          );
                        },
                        onBuildingTap: (BuildingData building) {
                          // Handle individual building tap - send to Liquid Galaxy
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Visualizing building on Liquid Galaxy...')),
                          );
                          // TODO: Implement dartssh2 logic here
                        },
                        onVisualizeHistoricalChanges: () {
                          // Handle historical changes visualization
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Loading historical data...')),
                          );
                          // TODO: Implement historical data visualization
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),),
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
      name: json['name'] ?? json['display_name']?.split(',')[0] ?? 'Unknown Location',
      displayName: json['display_name'] ?? 'Unknown Location',
      address: json['display_name'] ?? 'Unknown Address',
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
    );
  }
}