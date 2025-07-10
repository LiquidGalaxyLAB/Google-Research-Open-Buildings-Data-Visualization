// components/selected_region_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/lg_service.dart';
import '../ui/settings_screen.dart';

class SelectedRegionBottomSheet extends StatefulWidget {
  final MapOverlay selectedOverlay;
  final List<BuildingData> buildings;
  final bool isLoading;
  final VoidCallback onSendToLiquidGalaxy;
  final Function(BuildingData) onBuildingTap;
  final VoidCallback onVisualizeHistoricalChanges;

  const SelectedRegionBottomSheet({
    Key? key,
    required this.selectedOverlay,
    required this.buildings,
    required this.isLoading,
    required this.onSendToLiquidGalaxy,
    required this.onBuildingTap,
    required this.onVisualizeHistoricalChanges,
  }) : super(key: key);

  @override
  _SelectedRegionBottomSheetState createState() => _SelectedRegionBottomSheetState();
}

class _SelectedRegionBottomSheetState extends State<SelectedRegionBottomSheet> {
  bool _isExpanded = false;
  String _sortBy = 'area'; // 'area', 'confidence', 'points'
  bool _ascending = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LGService>(
      builder: (context, lgService, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isExpanded
              ? MediaQuery.of(context).size.height * 0.8
              : MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar and header
              _buildHeader(lgService),

              // Content area
              Expanded(
                child: widget.isLoading
                    ? _buildLoadingContent()
                    : _buildContent(lgService),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(LGService lgService) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 16),

          // Header content
          Row(
            children: [
              Icon(Icons.map, color: Colors.blue, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Region',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.buildings.length} buildings found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Connection status indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lgService.isConnected
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      lgService.isConnected ? Icons.cloud_done : Icons.cloud_off,
                      size: 14,
                      color: lgService.isConnected ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 4),
                    Text(
                      lgService.isConnected ? 'LG Ready' : 'LG Off',
                      style: TextStyle(
                        fontSize: 12,
                        color: lgService.isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Expand/collapse button
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Action buttons row
          _buildActionButtons(lgService),
        ],
      ),
    );
  }

  Widget _buildActionButtons(LGService lgService) {
    return Row(
      children: [
        // Send to Liquid Galaxy button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: lgService.isConnected ? widget.onSendToLiquidGalaxy : () {
              _showConnectionDialog(context);
            },
            icon: Icon(
              lgService.isConnected ? Icons.send : Icons.cloud_off,
              size: 16,
            ),
            label: Text(
              lgService.isConnected ? 'Send to LG' : 'Connect LG',
              style: TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: lgService.isConnected ? Colors.blue : Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        SizedBox(width: 8),

        // Historical data button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onVisualizeHistoricalChanges,
            icon: Icon(Icons.history, size: 16),
            label: Text(
              'History',
              style: TextStyle(fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading buildings...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait while we fetch building data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LGService lgService) {
    if (widget.buildings.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Statistics and sorting controls
        _buildStatsAndControls(),

        // Buildings list
        Expanded(
          child: _buildBuildingsList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Buildings Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This region doesn\'t contain any building data',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              // Could implement region expansion or different data source
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Try selecting a different region or zoom level'),
                ),
              );
            },
            icon: Icon(Icons.refresh),
            label: Text('Try Different Area'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsAndControls() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          // Statistics row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total Area',
                '${_getTotalArea().toStringAsFixed(0)} m²',
                Icons.square_foot,
              ),
              _buildStatItem(
                'Avg Confidence',
                '${_getAverageConfidence().toStringAsFixed(1)}%',
                Icons.trending_up,
              ),
              _buildStatItem(
                'Buildings',
                '${widget.buildings.length}',
                Icons.apartment,
              ),
            ],
          ),

          SizedBox(height: 12),

          // Sorting controls
          Row(
            children: [
              Text(
                'Sort by:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: _sortBy,
                  isExpanded: true,
                  underline: Container(),
                  items: [
                    DropdownMenuItem(value: 'area', child: Text('Area')),
                    DropdownMenuItem(value: 'confidence', child: Text('Confidence')),
                    DropdownMenuItem(value: 'points', child: Text('Complexity')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _ascending = !_ascending;
                  });
                },
                icon: Icon(
                  _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                ),
                tooltip: _ascending ? 'Ascending' : 'Descending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingsList() {
    List<BuildingData> sortedBuildings = List.from(widget.buildings);

    // Sort buildings based on selected criteria
    sortedBuildings.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'area':
          comparison = a.area.compareTo(b.area);
          break;
        case 'confidence':
          comparison = a.confidenceScore.compareTo(b.confidenceScore);
          break;
        case 'points':
          comparison = a.polygonPoints.length.compareTo(b.polygonPoints.length);
          break;
        default:
          comparison = a.area.compareTo(b.area);
      }
      return _ascending ? comparison : -comparison;
    });

    return ListView.builder(
      itemCount: sortedBuildings.length,
      itemBuilder: (context, index) {
        final building = sortedBuildings[index];
        return _buildBuildingListItem(building, index + 1);
      },
    );
  }

  Widget _buildBuildingListItem(BuildingData building, int index) {
    final confidenceColor = building.confidenceScore > 0.8
        ? Colors.green
        : building.confidenceScore > 0.5
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: confidenceColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                color: confidenceColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Building $index',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: confidenceColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(building.confidenceScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: confidenceColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.square_foot, size: 14, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '${building.area.toStringAsFixed(0)} m²',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 12),
              Icon(Icons.scatter_plot, size: 14, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '${building.polygonPoints.length} points',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // View on map button
            IconButton(
              onPressed: () => widget.onBuildingTap(building),
              icon: Icon(Icons.visibility, size: 20),
              tooltip: 'View on map',
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.1),
                foregroundColor: Colors.blue,
              ),
            ),
            SizedBox(width: 4),
            // Send individual building to LG
            Consumer<LGService>(
              builder: (context, lgService, child) {
                return IconButton(
                  onPressed: lgService.isConnected ? () {
                    _sendIndividualBuildingToLG(building, lgService);
                  } : null,
                  icon: Icon(Icons.send, size: 20),
                  tooltip: lgService.isConnected ? 'Send to LG' : 'LG not connected',
                  style: IconButton.styleFrom(
                    backgroundColor: lgService.isConnected
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    foregroundColor: lgService.isConnected ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () => widget.onBuildingTap(building),
      ),
    );
  }

  // Send individual building to Liquid Galaxy
  Future<void> _sendIndividualBuildingToLG(BuildingData building, LGService lgService) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Sending building to LG...'),
            ],
          ),
        ),
      );

      // Create KML content for the building
      String buildingKML = _createIndividualBuildingKML(building);

      // Send to Liquid Galaxy
      await lgService.sendKMLToSlave(buildingKML, 2);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Building sent to Liquid Galaxy successfully!'),
            backgroundColor: Colors.green,
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
            content: Text('Failed to send building to LG: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Create KML for individual building
  String _createIndividualBuildingKML(BuildingData building) {
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
        <n>Selected Building from Region</n>
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
          <range>300</range>
          <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
        </LookAt>
      </Placemark>
    ''';

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="slave_2">
    <n>Individual Building Visualization</n>
    <open>1</open>
    <Folder>
      <n>Selected Building</n>
      <open>1</open>
      $placemark
    </Folder>
  </Document>
</kml>''';
  }

  // Calculate building center
  LatLng _calculateBuildingCenter(BuildingData building) {
    if (building.polygonPoints.isEmpty) {
      return LatLng(0, 0); // Fallback
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

  // Show connection dialog when LG is not connected
  void _showConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.cloud_off, color: Colors.orange),
              SizedBox(width: 8),
              Text('Liquid Galaxy Not Connected'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To send building data to Liquid Galaxy, you need to establish a connection first.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Connect via Settings > Liquid Galaxy Configuration',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiquidGalaxyConfigScreen(),
                  ),
                );
              },
              icon: Icon(Icons.settings, size: 16),
              label: Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // Calculate statistics
  double _getTotalArea() {
    return widget.buildings.fold(0.0, (sum, building) => sum + building.area);
  }

  double _getAverageConfidence() {
    if (widget.buildings.isEmpty) return 0.0;
    double totalConfidence = widget.buildings.fold(
      0.0,
          (sum, building) => sum + building.confidenceScore,
    );
    return (totalConfidence / widget.buildings.length) * 100;
  }
}

// Import this class if it doesn't exist in your models
class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}