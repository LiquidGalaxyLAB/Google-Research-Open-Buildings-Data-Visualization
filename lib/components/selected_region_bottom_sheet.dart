import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_data.dart';
import '../models/map_overlay.dart';
import '../services/kml_fetcher.dart';

class SelectedRegionBottomSheet extends StatefulWidget {
  final MapOverlay selectedOverlay;
  final List<BuildingData> buildings;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSendToLiquidGalaxy;
  final Function(BuildingData) onBuildingTap;
  final VoidCallback onVisualizeHistoricalChanges;
  final VoidCallback? onRetry;
  final VoidCallback? onDismissError;

  const SelectedRegionBottomSheet({
    Key? key,
    required this.selectedOverlay,
    required this.buildings,
    required this.isLoading,
    this.errorMessage,
    required this.onSendToLiquidGalaxy,
    required this.onBuildingTap,
    required this.onVisualizeHistoricalChanges,
    this.onRetry,
    this.onDismissError,
  }) : super(key: key);

  @override
  _SelectedRegionBottomSheetState createState() => _SelectedRegionBottomSheetState();
}

class _SelectedRegionBottomSheetState extends State<SelectedRegionBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // KML data state variables
  String? _kmlData;
  bool _isLoadingKMLData = false;
  String? _kmlErrorMessage;
  List<BuildingData> _kmlBuildings = [];
  String? _actualRegionName;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });

    // Delay the initial fetch to avoid immediate network calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _handleUserSelection();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleUserSelection() async {
    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Debounce the network call
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      setState(() {
        _isLoadingKMLData = true;
        _kmlErrorMessage = null;
      });

      try {
        // Add timeout and better error handling
        await _fetchKMLData().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Request timed out', const Duration(seconds: 30));
          },
        );
      } on TimeoutException {
        if (mounted) {
          setState(() {
            _kmlErrorMessage = "Request timed out. Please check your connection.";
            _isLoadingKMLData = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _kmlErrorMessage = "Network error: ${e.toString()}";
            _isLoadingKMLData = false;
          });
        }
      }
    });
  }

  Future<void> _fetchKMLData() async {
    try {
      // Extract coordinates from the selected overlay bounds
      final minLat = widget.selectedOverlay.bounds.southWest.latitude;
      final maxLat = widget.selectedOverlay.bounds.northEast.latitude;
      final minLng = widget.selectedOverlay.bounds.southWest.longitude;
      final maxLng = widget.selectedOverlay.bounds.northEast.longitude;

      // For now, simulate network call with mock data to avoid actual network issues
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Generate mock KML data instead of actual network call
      final mockKMLData = _generateMockKMLData();

      if (mounted) {
        setState(() {
          _kmlData = mockKMLData;
          _kmlBuildings = _parseKMLData(mockKMLData);
          _actualRegionName = _extractRegionNameFromKML(mockKMLData);
          _isLoadingKMLData = true;
        });
      }

      // TODO: Uncomment when actual KML service is ready

      final kmlData = await KMLData.fetchBuildingsKML(
        context: context,
        minLng: minLng,
        minLat: minLat,
        maxLng: maxLng,
        maxLat: maxLat,
      );

      if (kmlData != null) {
        if (mounted) {
          setState(() {
            _kmlData = kmlData;
            _kmlBuildings = _parseKMLData(kmlData);
            _actualRegionName = _extractRegionNameFromKML(kmlData);
            _isLoadingKMLData = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _kmlErrorMessage = "No data available for this region";
            _isLoadingKMLData = false;
          });
        }
      }

    } catch (e) {
      rethrow;
    }
  }

  String _generateMockKMLData() {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Mock Building Data</name>
    <Placemark>
      <name>Sample Building</name>
    </Placemark>
  </Document>
</kml>''';
  }

  List<BuildingData> _parseKMLData(String kmlData) {
    List<BuildingData> buildings = [];

    if (kmlData.isNotEmpty) {
      final random = Random();
      final buildingCount = 3 + random.nextInt(8);

      for (int i = 0; i < buildingCount; i++) {
        List<LatLng> polygonPoints = _generateRandomPolygon(random);

        buildings.add(BuildingData(
          id: 'kml_building_$i',
          area: 500 + random.nextDouble() * 2000,
          confidenceScore: 0.7 + random.nextDouble() * 0.3,
          polygonPoints: polygonPoints,
        ));
      }
    }

    return buildings;
  }

  List<LatLng> _generateRandomPolygon(Random random) {
    final centerLat = widget.selectedOverlay.bounds.southWest.latitude +
        random.nextDouble() * (widget.selectedOverlay.bounds.northEast.latitude -
            widget.selectedOverlay.bounds.southWest.latitude);
    final centerLng = widget.selectedOverlay.bounds.southWest.longitude +
        random.nextDouble() * (widget.selectedOverlay.bounds.northEast.longitude -
            widget.selectedOverlay.bounds.southWest.longitude);

    final latOffset = 0.0001 + random.nextDouble() * 0.0002;
    final lngOffset = 0.0001 + random.nextDouble() * 0.0002;

    return [
      LatLng(centerLat - latOffset, centerLng - lngOffset),
      LatLng(centerLat + latOffset, centerLng - lngOffset),
      LatLng(centerLat + latOffset, centerLng + lngOffset),
      LatLng(centerLat - latOffset, centerLng + lngOffset),
      LatLng(centerLat - latOffset, centerLng - lngOffset),
    ];
  }

  String? _extractRegionNameFromKML(String kmlData) {
    // Simple extraction - in real implementation, parse XML properly
    if (kmlData.contains('<name>') && kmlData.contains('</name>')) {
      final startIndex = kmlData.indexOf('<name>') + 6;
      final endIndex = kmlData.indexOf('</name>', startIndex);
      if (endIndex > startIndex) {
        return kmlData.substring(startIndex, endIndex);
      }
    }
    return null;
  }

  List<BuildingData> get _effectiveBuildings {
    return _kmlBuildings.isNotEmpty ? _kmlBuildings : widget.buildings;
  }

  double get _averageBuildingSize {
    final buildings = _effectiveBuildings;
    if (buildings.isEmpty) return 0.0;
    double totalArea = buildings.fold(0.0, (sum, building) => sum + building.area);
    return totalArea / buildings.length;
  }

  String get _regionName {
    if (_actualRegionName != null && _actualRegionName!.isNotEmpty) {
      return _actualRegionName!;
    }

    final center = LatLng(
      (widget.selectedOverlay.bounds.southWest.latitude + widget.selectedOverlay.bounds.northEast.latitude) / 2,
      (widget.selectedOverlay.bounds.southWest.longitude + widget.selectedOverlay.bounds.northEast.longitude) / 2,
    );

    return "Selected Region (${center.latitude.toStringAsFixed(3)}, ${center.longitude.toStringAsFixed(3)})";
  }

  double get _regionArea {
    const double earthRadius = 6371.0;

    final lat1 = widget.selectedOverlay.bounds.southWest.latitude * (pi / 180);
    final lat2 = widget.selectedOverlay.bounds.northEast.latitude * (pi / 180);
    final lon1 = widget.selectedOverlay.bounds.southWest.longitude * (pi / 180);
    final lon2 = widget.selectedOverlay.bounds.northEast.longitude * (pi / 180);

    final deltaLat = lat2 - lat1;
    final deltaLon = lon2 - lon1;

    final avgLat = (lat1 + lat2) / 2;
    final width = deltaLon * cos(avgLat) * earthRadius;
    final height = deltaLat * earthRadius;

    return width * height;
  }

  Widget _buildErrorBanner() {
    String? errorToShow = widget.errorMessage ?? _kmlErrorMessage;

    if (errorToShow == null || errorToShow.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorToShow,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _handleUserSelection();
                      if (widget.onRetry != null) {
                        widget.onRetry!();
                      }
                    },
                    child: Text(
                      'Check your connection and tap to retry',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _kmlErrorMessage = null;
                });
                if (widget.onDismissError != null) {
                  widget.onDismissError!();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Error banner
          _buildErrorBanner(),

          // Header with proper scrolling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Region',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _regionName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: widget.onSendToLiquidGalaxy,
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text('Send to LG'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.bar_chart),
                  text: 'Statistics',
                ),
                Tab(
                  icon: Icon(Icons.apartment),
                  text: 'Buildings',
                ),
                Tab(
                  icon: Icon(Icons.info_outline),
                  text: 'Details',
                ),
              ],
            ),
          ),

          // Tab Content with proper scrolling
          Expanded(
            child: (widget.isLoading || _isLoadingKMLData)
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _isLoadingKMLData ? 'Fetching region data...' : 'Loading buildings...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : TabBarView(
              controller: _tabController,
              children: [
                _buildStatisticsTab(),
                _buildBuildingsTab(),
                _buildDetailsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Building Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.apartment,
                  iconColor: Colors.blue,
                  title: '${_effectiveBuildings.length}',
                  subtitle: 'Total Buildings',
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.square_foot,
                  iconColor: Colors.green,
                  title: '${_averageBuildingSize.toStringAsFixed(0)} m²',
                  subtitle: 'Avg. Size',
                  backgroundColor: Colors.green.withOpacity(0.1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.map,
                  iconColor: Colors.orange,
                  title: '${_regionArea.toStringAsFixed(2)} km²',
                  subtitle: 'Region Area',
                  backgroundColor: Colors.orange.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.analytics,
                  iconColor: Colors.purple,
                  title: '${_effectiveBuildings.isEmpty ? 0 : (_effectiveBuildings.fold(0.0, (sum, b) => sum + b.confidenceScore) / _effectiveBuildings.length * 100).toStringAsFixed(0)}%',
                  subtitle: 'Avg. Confidence',
                  backgroundColor: Colors.purple.withOpacity(0.1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onVisualizeHistoricalChanges,
              icon: const Icon(Icons.timeline, color: Colors.blue),
              label: const Text(
                'Visualize historical changes over time',
                style: TextStyle(color: Colors.blue),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _isLoadingKMLData ? null : _handleUserSelection,
              icon: Icon(Icons.refresh, color: Colors.grey[600]),
              label: Text(
                'Refresh region data',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingsTab() {
    final buildings = _effectiveBuildings;

    if (buildings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.apartment, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No buildings found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try selecting a different region or refresh the data',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoadingKMLData ? null : _handleUserSelection,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Data'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: buildings.length,
      itemBuilder: (context, index) {
        final building = buildings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.apartment,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: Text(
                'Building ${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Area: ${building.area.toStringAsFixed(0)} m² • Confidence: ${(building.confidenceScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
              onTap: () => widget.onBuildingTap(building),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab() {
    final centerLat = (widget.selectedOverlay.bounds.southWest.latitude +
        widget.selectedOverlay.bounds.northEast.latitude) / 2;
    final centerLon = (widget.selectedOverlay.bounds.southWest.longitude +
        widget.selectedOverlay.bounds.northEast.longitude) / 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Region Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          _buildDetailRow('Region:', _regionName),
          const SizedBox(height: 12),
          _buildDetailRow(
              'Center Coordinates:',
              '${centerLat.toStringAsFixed(5)}, ${centerLon.toStringAsFixed(5)}'
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Area:', '${_regionArea.toStringAsFixed(2)} km²'),
          const SizedBox(height: 12),
          _buildDetailRow('Buildings Found:', '${_effectiveBuildings.length}'),
          const SizedBox(height: 12),
          _buildDetailRow('Data Source:', _kmlData != null ? 'KML Data' : 'Default Data'),

          if (_kmlData != null) ...[
            const SizedBox(height: 12),
            _buildDetailRow('KML Status:', 'Successfully loaded'),
          ],

          const SizedBox(height: 24),

          ExpansionTile(
            title: const Text('Technical Details', style: TextStyle(fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('SW Corner:',
                        '${widget.selectedOverlay.bounds.southWest.latitude.toStringAsFixed(6)}, ${widget.selectedOverlay.bounds.southWest.longitude.toStringAsFixed(6)}'),
                    const SizedBox(height: 8),
                    _buildDetailRow('NE Corner:',
                        '${widget.selectedOverlay.bounds.northEast.latitude.toStringAsFixed(6)}, ${widget.selectedOverlay.bounds.northEast.longitude.toStringAsFixed(6)}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}