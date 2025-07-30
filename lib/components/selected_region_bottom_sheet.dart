// components/selected_region_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/lg_service.dart';
import '../ui/settings_screen.dart';
import '../utils/colors.dart';
import 'package:http/http.dart' as http;



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

class _SelectedRegionBottomSheetState extends State<SelectedRegionBottomSheet>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  String _sortBy = 'area'; // 'area', 'confidence', 'points'
  bool _ascending = false;

  // Tab controller for Statistics/Buildings/Details tabs
  late TabController _tabController;

  // Search functionality
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0); // Start with Statistics
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    // Listen to tab changes to update the historical button visibility
    _tabController.addListener(() {
      setState(() {
        // This will trigger a rebuild when tab changes to show/hide the button
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Generate plus code for building based on its center coordinates
  String _generatePlusCode(BuildingData building) {
    final center = _calculateBuildingCenter(building);
    // Simple plus code generation based on coordinates
    final latStr = center.latitude.toStringAsFixed(4).replaceAll('.', '');
    final lngStr = center.longitude.toStringAsFixed(4).replaceAll('.', '');
    final hash = (center.latitude * center.longitude * 1000).abs().toInt();
    return '${latStr.substring(0, 4)}+${lngStr.substring(0, 4)}${hash.toString().substring(0, 2)}';
  }

  // Filter buildings based on search query
  List<BuildingData> _getFilteredBuildings() {
    if (_searchQuery.isEmpty) return widget.buildings;

    return widget.buildings.where((building) {
      final plusCode = _generatePlusCode(building).toLowerCase();
      return plusCode.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LGService>(
      builder: (context, lgService, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: _isExpanded
              ? MediaQuery.of(context).size.height * 0.85
              : MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: AppColors.surface,
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

              // Tab bar
              _buildTabBar(),

              // Content area with tabs
              Expanded(
                child: widget.isLoading
                    ? _buildLoadingContent()
                    : _buildTabContent(lgService),
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
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 16),

          // Header content
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visualize Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Open Building Footprints Queried',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton.icon(
                onPressed: lgService.isConnected ? () => _sendAllBuildingsToLG(lgService) : () {
                  _showConnectionDialog(context);
                },
                icon: Icon(Icons.monitor, size: 18),
                label: Text('Send to LG'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.onSurfaceVariant,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: [
          Tab(
            icon: Icon(Icons.bar_chart, size: 20),
            text: 'Statistics',
          ),
          Tab(
            icon: Icon(Icons.apartment, size: 20),
            text: 'Buildings',
          ),
          Tab(
            icon: Icon(Icons.description, size: 20),
            text: 'Details',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(LGService lgService) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Statistics Tab
        _buildStatisticsTab(),

        // Buildings Tab
        _buildBuildingsTab(),

        // Details Tab
        _buildDetailsTab(),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Building Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 20),

          // Main Statistics Cards with responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(constraints.maxWidth < 350 ? 16 : 20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.apartment, color: AppColors.primary, size: constraints.maxWidth < 350 ? 28 : 32),
                          SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              '${widget.buildings.length}',
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 350 ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Total Buildings',
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 350 ? 12 : 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(constraints.maxWidth < 350 ? 16 : 20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.square_foot, color: AppColors.primary, size: constraints.maxWidth < 350 ? 28 : 32),
                          SizedBox(height: 8),
                          FittedBox(
                            child: Text(
                              '${_getAverageArea().toStringAsFixed(0)} m²',
                              style: TextStyle(
                                fontSize: constraints.maxWidth < 350 ? 20 : 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Avg. Size',
                            style: TextStyle(
                              fontSize: constraints.maxWidth < 350 ? 12 : 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),


          SizedBox(height: 24),

          // Confidence Distribution
          Text(
            'Confidence Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 16),
          _buildConfidenceDistribution(),

          SizedBox(height: 24),

          // Historical changes button - FULL WIDTH inside scroll view
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final lgService = Provider.of<LGService>(context, listen: false);
                await lgService.sendTestKML(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryContainer,
                foregroundColor: AppColors.onSecondaryContainer,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.outlineVariant),
                ),
              ),
              child: Text(
                'Visualize historical changes over time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildBuildingsTab() {
    if (widget.buildings.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Search and sorting controls
        _buildSearchAndControls(),

        // Buildings list
        Expanded(
          child: _buildBuildingsList(),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Region Overview Section
          Text(
            'Region Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow('Coordinates',
              'SW: ${widget.selectedOverlay.bounds.southWest.latitude.toStringAsFixed(5)}, ${widget.selectedOverlay.bounds.southWest.longitude.toStringAsFixed(5)}\n'
                  'NE: ${widget.selectedOverlay.bounds.northEast.latitude.toStringAsFixed(5)}, ${widget.selectedOverlay.bounds.northEast.longitude.toStringAsFixed(5)}'
          ),
          SizedBox(height: 12),
          _buildInfoRow('Region Size', '${_getRegionArea().toStringAsFixed(2)} km²'),
          SizedBox(height: 12),
          _buildInfoRow('Building Density', '${_getBuildingDensity().toStringAsFixed(1)} buildings/km²'),

          SizedBox(height: 24),

          // Data Source Information
          Text(
            'Data Source',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow('Dataset', 'Google Open Buildings'),
          SizedBox(height: 12),
          _buildInfoRow('Coverage', 'Global building footprints'),
          SizedBox(height: 12),
          _buildInfoRow('Accuracy', 'Machine learning derived'),
          SizedBox(height: 12),
          _buildInfoRow('Last Updated', 'Continuously updated'),

          SizedBox(height: 24),

          // Technical Details
          Text(
            'Technical Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow('Projection', 'WGS84 (EPSG:4326)'),
          SizedBox(height: 12),
          _buildInfoRow('Format', 'GeoJSON/KML'),
          SizedBox(height: 12),
          _buildInfoRow('Precision', '~1 meter accuracy'),
          SizedBox(height: 12),
          _buildInfoRow('Processing', 'Real-time analysis'),
        ],
      ),
    );
  }

  Widget _buildSearchAndControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: AppColors.outline.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.onSurface),
              decoration: InputDecoration(
                hintText: 'Search by Plus Code...',
                hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
                prefixIcon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
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
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    isExpanded: true,
                    underline: Container(),
                    style: TextStyle(color: AppColors.onSurface),
                    dropdownColor: AppColors.surface,
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
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _ascending = !_ascending;
                    });
                  },
                  icon: Icon(
                    _ascending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  tooltip: _ascending ? 'Ascending' : 'Descending',
                ),
              ),
            ],
          ),

          if (_searchQuery.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              'Found ${_getFilteredBuildings().length} buildings matching "$_searchQuery"',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfidenceDistribution() {
    final highConfidence = widget.buildings.where((b) => b.confidenceScore > 0.8).length;
    final mediumConfidence = widget.buildings.where((b) => b.confidenceScore > 0.5 && b.confidenceScore <= 0.8).length;
    final lowConfidence = widget.buildings.where((b) => b.confidenceScore <= 0.5).length;
    final total = widget.buildings.length;

    return Column(
      children: [
        _buildConfidenceBar('High (>80%)', highConfidence, total, Colors.green),
        SizedBox(height: 8),
        _buildConfidenceBar('Medium (50-80%)', mediumConfidence, total, Colors.orange),
        SizedBox(height: 8),
        _buildConfidenceBar('Low (<50%)', lowConfidence, total, Colors.red),
      ],
    );
  }

  Widget _buildConfidenceBar(
      String label,
      int count,
      int total,
      Color color,
      ) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Label flexes to avoid overflow
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurface,
                ),
              ),
            ),

            // Count + percent stays intrinsic
            Text(
              '$count (${(percentage * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Full‑width bar
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurface,
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
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'Loading buildings...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait while we fetch building data',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
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

  Widget _buildBuildingsList() {
    List<BuildingData> filteredBuildings = _getFilteredBuildings();

    // Sort buildings based on selected criteria
    filteredBuildings.sort((a, b) {
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

    if (filteredBuildings.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No buildings found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredBuildings.length,
      itemBuilder: (context, index) {
        final building = filteredBuildings[index];
        final plusCode = _generatePlusCode(building);
        return _buildBuildingListItem(building, plusCode, index + 1);
      },
    );
  }

  Widget _buildBuildingListItem(BuildingData building, String plusCode, int index) {
    final confidenceColor = building.confidenceScore > 0.8
        ? Colors.blue
        : building.confidenceScore > 0.5
        ? Colors.blue.withOpacity(0.7)
        : Colors.blue.withOpacity(0.5);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      color: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: confidenceColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: confidenceColor.withOpacity(0.3)),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plusCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'monospace',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Building #$index',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: confidenceColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: confidenceColor.withOpacity(0.3)),
              ),
              child: Text(
                '${(building.confidenceScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: confidenceColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Icon(Icons.square_foot, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '${building.area.toStringAsFixed(0)} m²',
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.scatter_plot, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '${building.polygonPoints.length} pts',
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
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
              icon: const Icon(Icons.visibility, size: 20),
              tooltip: 'View on map',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 4),
            // Send individual building to LG
            Consumer<LGService>(
              builder: (context, lgService, child) {
                final isConnected = lgService.isConnected;
                return IconButton(
                  onPressed: isConnected
                      ? () => _sendIndividualBuildingToLG(building, lgService)
                      : null,
                  icon: const Icon(Icons.send, size: 20),
                  tooltip: isConnected ? 'Send to LG' : 'LG not connected',
                  style: IconButton.styleFrom(
                    backgroundColor: isConnected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.outline.withOpacity(0.05),
                    foregroundColor: isConnected
                        ? AppColors.primary
                        : AppColors.outline,
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

  // Add this method to create an info panel for the rightmost screen:

  String _createBuildingInfoPanel(BuildingData building) {
    final center = _calculateBuildingCenter(building);
    final plusCode = _generatePlusCode(building);

    // Determine confidence level text and color
    String confidenceLevel = "High";
    String confidenceColor = "#4CAF50";
    if (building.confidenceScore <= 0.5) {
      confidenceLevel = "Low";
      confidenceColor = "#F44336";
    } else if (building.confidenceScore <= 0.8) {
      confidenceLevel = "Medium";
      confidenceColor = "#FF9800";
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document id="info_panel">
    <n>Building Information Panel</n>
    <ScreenOverlay>
      <n>Building Info</n>
      <Icon>
        <href>data:text/html,
          <html>
            <head>
              <style>
                body {
                  font-family: 'Roboto', Arial, sans-serif;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  color: white;
                  margin: 0;
                  padding: 20px;
                  width: 350px;
                  height: 500px;
                  box-sizing: border-box;
                }
                .header {
                  text-align: center;
                  border-bottom: 2px solid rgba(255,255,255,0.3);
                  padding-bottom: 15px;
                  margin-bottom: 20px;
                }
                .title {
                  font-size: 24px;
                  font-weight: bold;
                  margin: 0;
                  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                .subtitle {
                  font-size: 14px;
                  opacity: 0.9;
                  margin: 5px 0 0 0;
                }
                .info-grid {
                  display: grid;
                  gap: 15px;
                }
                .info-card {
                  background: rgba(255,255,255,0.15);
                  padding: 15px;
                  border-radius: 10px;
                  backdrop-filter: blur(10px);
                  border: 1px solid rgba(255,255,255,0.2);
                }
                .info-label {
                  font-size: 12px;
                  opacity: 0.8;
                  margin-bottom: 5px;
                  text-transform: uppercase;
                  letter-spacing: 1px;
                }
                .info-value {
                  font-size: 18px;
                  font-weight: bold;
                  margin: 0;
                }
                .plus-code {
                  font-family: 'Courier New', monospace;
                  font-size: 20px;
                  background: rgba(0,0,0,0.3);
                  padding: 8px;
                  border-radius: 5px;
                  text-align: center;
                  letter-spacing: 2px;
                }
                .confidence-high { color: #4CAF50; }
                .confidence-medium { color: #FF9800; }
                .confidence-low { color: #F44336; }
                .stats-row {
                  display: flex;
                  justify-content: space-between;
                  margin-top: 10px;
                }
                .stat-item {
                  text-align: center;
                  flex: 1;
                }
                .stat-number {
                  font-size: 24px;
                  font-weight: bold;
                  display: block;
                }
                .stat-label {
                  font-size: 10px;
                  opacity: 0.8;
                }
                .footer {
                  margin-top: 20px;
                  text-align: center;
                  font-size: 11px;
                  opacity: 0.7;
                  border-top: 1px solid rgba(255,255,255,0.2);
                  padding-top: 15px;
                }
              </style>
            </head>
            <body>
              <div class="header">
                <h1 class="title">🏢 Building Analysis</h1>
                <p class="subtitle">Google Open Buildings Dataset</p>
              </div>
              
              <div class="info-grid">
                <div class="info-card">
                  <div class="info-label">Plus Code Location</div>
                  <div class="plus-code">$plusCode</div>
                </div>
                
                <div class="info-card">
                  <div class="info-label">Confidence Score</div>
                  <div class="info-value confidence-${confidenceLevel.toLowerCase()}">
                    ${(building.confidenceScore * 100).toStringAsFixed(1)}% ($confidenceLevel)
                  </div>
                  <div class="stats-row">
                    <div class="stat-item">
                      <span class="stat-number">${building.area.toStringAsFixed(0)}</span>
                      <span class="stat-label">m² AREA</span>
                    </div>
                    <div class="stat-item">
                      <span class="stat-number">${building.polygonPoints.length}</span>
                      <span class="stat-label">POINTS</span>
                    </div>
                  </div>
                </div>
                
                <div class="info-card">
                  <div class="info-label">Geographic Center</div>
                  <div class="info-value" style="font-size: 14px;">
                    📍 ${center.latitude.toStringAsFixed(6)}<br>
                    📍 ${center.longitude.toStringAsFixed(6)}
                  </div>
                </div>
                
                <div class="info-card">
                  <div class="info-label">Building Classification</div>
                  <div class="info-value">
                    ${building.area > 1000 ? '🏢 Large Structure' : building.area > 100 ? '🏠 Medium Building' : '🏘️ Small Structure'}
                  </div>
                </div>
              </div>
              
              <div class="footer">
                🌍 Visualized on Liquid Galaxy<br>
                Data: Google Open Buildings Initiative
              </div>
            </body>
          </html>
        </href>
      </Icon>
      <overlayXY x="1" y="1" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.98" y="0.98" xunits="fraction" yunits="fraction"/>
      <size x="0" y="0" xunits="fraction" yunits="fraction"/>
    </ScreenOverlay>
  </Document>
</kml>''';
  }

// Enhanced method to send building with info panel





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

      // Create enhanced building KML with both polygon and marker
      String buildingKML = _createIndividualBuildingKML(building);

      // Create info panel KML for rightmost screen
      String infoPanelKML = _createBuildingInfoPanel(building);

      // Get building center coordinates
      final center = _calculateBuildingCenter(building);

      // Send both the building visualization and info panel
      await lgService.sendBuildingWithInfoPanel(
          buildingKML,
          infoPanelKML,
          center.latitude,
          center.longitude
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Building sent to Liquid Galaxy with info panel!'),
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



  // Replace your current _sendAllBuildingsToLG method with:
  Future<void> _sendAllBuildingsToLG(LGService lgService) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Fetching KML for ${widget.buildings.length} buildings...'),
              SizedBox(height: 8),
              Text(
                'Loading from server...',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );

      // Fetch KML from your API for the same region
      String kmlContent = await _fetchKMLFromAPI();

      // Calculate region center for camera positioning
      final regionCenter = _calculateRegionCenter();

      // Send the KML content to LG
      await lgService.sendKMLToLG(
        kmlContent,
        regionCenter.latitude,
        regionCenter.longitude,
      );

      // Close loading dialog and show success
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${widget.buildings.length} buildings sent to Liquid Galaxy!'),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send buildings to LG: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Add this method to your SelectedRegionBottomSheet class:
  Future<String> _fetchKMLFromAPI() async {
    try {
      // Use the same API endpoint but request KML format
      final uri = Uri.parse('https://web-production-928c.up.railway.app/fetch-buildings').replace(
        queryParameters: {
          'min_lng': widget.selectedOverlay.bounds.southWest.longitude.toString(),
          'min_lat': widget.selectedOverlay.bounds.southWest.latitude.toString(),
          'max_lng': widget.selectedOverlay.bounds.northEast.longitude.toString(),
          'max_lat': widget.selectedOverlay.bounds.northEast.latitude.toString(),
          'format': 'kml', // Request KML instead of JSON
        },
      );

      print('Fetching KML from: $uri');

      final response = await http.get(uri).timeout(
        const Duration(seconds: 45),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        print('✅ KML data fetched: ${response.body.length} characters');

        if (response.body.isEmpty || response.body.trim() == '') {
          throw Exception('Empty KML response from API');
        }

        return response.body;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }

    } catch (e) {
      print('❌ Error fetching KML: $e');
      rethrow;
    }
  }

// Add this helper method to calculate region center:
  LatLng _calculateRegionCenter() {
    final bounds = widget.selectedOverlay.bounds;
    final centerLat = (bounds.northEast.latitude + bounds.southWest.latitude) / 2;
    final centerLng = (bounds.northEast.longitude + bounds.southWest.longitude) / 2;
    return LatLng(centerLat, centerLng);
  }

  // Add this method to create the rightmost screen info panel:

  String _createRightmostInfoPanel(List<BuildingData> buildings, {BuildingData? selectedBuilding}) {
    // Calculate statistics
    final totalBuildings = buildings.length;
    final averageArea = _getAverageArea();
    final averageConfidence = _getAverageConfidence();
    final regionArea = _getRegionArea();
    final buildingDensity = _getBuildingDensity();

    // If a specific building is selected, show its details
    String selectedBuildingInfo = '';
    if (selectedBuilding != null) {
      final center = _calculateBuildingCenter(selectedBuilding);
      final plusCode = _generatePlusCode(selectedBuilding);

      selectedBuildingInfo = '''
      <div class="selected-building">
        <div class="selected-header">🎯 Selected Building</div>
        <div class="selected-content">
          <div class="plus-code">${plusCode}</div>
          <div class="building-stats">
            <div class="stat-row">
              <span class="stat-label">Area:</span>
              <span class="stat-value">${selectedBuilding.area.toStringAsFixed(0)} m²</span>
            </div>
            <div class="stat-row">
              <span class="stat-label">Confidence:</span>
              <span class="stat-value confidence-${selectedBuilding.confidenceScore > 0.8 ? 'high' : selectedBuilding.confidenceScore > 0.5 ? 'medium' : 'low'}">${(selectedBuilding.confidenceScore * 100).toStringAsFixed(1)}%</span>
            </div>
            <div class="stat-row">
              <span class="stat-label">Complexity:</span>
              <span class="stat-value">${selectedBuilding.polygonPoints.length} points</span>
            </div>
            <div class="stat-row">
              <span class="stat-label">Center:</span>
              <span class="stat-value coordinates">${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}</span>
            </div>
          </div>
        </div>
      </div>
    ''';
    }

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document id="building_info_panel">
    <name>Building Information Panel</name>
    <ScreenOverlay>
      <name>Building Info</name>
      <Icon>
        <href>data:text/html,
          <html>
            <head>
              <style>
                body {
                  font-family: 'Segoe UI', Arial, sans-serif;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  color: white;
                  margin: 0;
                  padding: 20px;
                  width: 350px;
                  height: 600px;
                  box-sizing: border-box;
                  overflow-y: auto;
                }
                
                .header {
                  text-align: center;
                  border-bottom: 2px solid rgba(255,255,255,0.3);
                  padding-bottom: 15px;
                  margin-bottom: 20px;
                }
                
                .title {
                  font-size: 22px;
                  font-weight: bold;
                  margin: 0;
                  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                
                .subtitle {
                  font-size: 12px;
                  opacity: 0.9;
                  margin: 5px 0 0 0;
                }
                
                .selected-building {
                  background: rgba(255,255,255,0.2);
                  border-radius: 12px;
                  padding: 15px;
                  margin-bottom: 20px;
                  border: 2px solid rgba(255,255,255,0.3);
                  animation: pulse 2s infinite;
                }
                
                @keyframes pulse {
                  0% { box-shadow: 0 0 0 0 rgba(255,255,255,0.4); }
                  70% { box-shadow: 0 0 0 10px rgba(255,255,255,0); }
                  100% { box-shadow: 0 0 0 0 rgba(255,255,255,0); }
                }
                
                .selected-header {
                  font-size: 16px;
                  font-weight: bold;
                  margin-bottom: 10px;
                  text-align: center;
                }
                
                .plus-code {
                  font-family: 'Courier New', monospace;
                  font-size: 18px;
                  background: rgba(0,0,0,0.3);
                  padding: 8px;
                  border-radius: 6px;
                  text-align: center;
                  margin-bottom: 15px;
                  letter-spacing: 2px;
                  border: 1px solid rgba(255,255,255,0.2);
                }
                
                .stat-row {
                  display: flex;
                  justify-content: space-between;
                  margin: 8px 0;
                  padding: 5px 0;
                  border-bottom: 1px solid rgba(255,255,255,0.1);
                }
                
                .stat-label {
                  font-size: 12px;
                  opacity: 0.8;
                  text-transform: uppercase;
                  letter-spacing: 1px;
                }
                
                .stat-value {
                  font-weight: bold;
                  font-size: 13px;
                }
                
                .coordinates {
                  font-family: 'Courier New', monospace;
                  font-size: 11px;
                }
                
                .confidence-high { color: #4CAF50; }
                .confidence-medium { color: #FF9800; }
                .confidence-low { color: #F44336; }
                
                .stats-grid {
                  display: grid;
                  grid-template-columns: 1fr 1fr;
                  gap: 12px;
                  margin-bottom: 20px;
                }
                
                .stat-card {
                  background: rgba(255,255,255,0.15);
                  padding: 12px;
                  border-radius: 8px;
                  text-align: center;
                  border: 1px solid rgba(255,255,255,0.2);
                }
                
                .stat-number {
                  font-size: 20px;
                  font-weight: bold;
                  display: block;
                  margin-bottom: 5px;
                }
                
                .stat-label-card {
                  font-size: 10px;
                  opacity: 0.8;
                  text-transform: uppercase;
                  letter-spacing: 1px;
                }
                
                .info-section {
                  background: rgba(255,255,255,0.1);
                  padding: 15px;
                  border-radius: 8px;
                  margin-bottom: 15px;
                  border: 1px solid rgba(255,255,255,0.2);
                }
                
                .section-title {
                  font-size: 14px;
                  font-weight: bold;
                  margin-bottom: 10px;
                  text-align: center;
                  color: #FFE082;
                }
                
                .footer {
                  text-align: center;
                  font-size: 10px;
                  opacity: 0.7;
                  margin-top: 20px;
                  padding-top: 15px;
                  border-top: 1px solid rgba(255,255,255,0.2);
                }
              </style>
            </head>
            <body>
              <div class="header">
                <h1 class="title">🏙️ Building Analysis</h1>
                <p class="subtitle">Region Overview & Selection</p>
              </div>
              
              ${selectedBuildingInfo.isNotEmpty ? selectedBuildingInfo : '<div class="info-section"><div class="section-title">📍 Click a building to view details</div><p style="text-align: center; opacity: 0.7; font-size: 12px;">Select any building polygon to see detailed information here</p></div>'}
              
              <div class="info-section">
                <div class="section-title">📊 Regional Statistics</div>
                <div class="stats-grid">
                  <div class="stat-card">
                    <span class="stat-number">$totalBuildings</span>
                    <span class="stat-label-card">Total Buildings</span>
                  </div>
                  <div class="stat-card">
                    <span class="stat-number">${averageArea.toStringAsFixed(0)}</span>
                    <span class="stat-label-card">Avg Area (m²)</span>
                  </div>
                  <div class="stat-card">
                    <span class="stat-number">${averageConfidence.toStringAsFixed(1)}%</span>
                    <span class="stat-label-card">Avg Confidence</span>
                  </div>
                  <div class="stat-card">
                    <span class="stat-number">${buildingDensity.toStringAsFixed(1)}</span>
                    <span class="stat-label-card">Buildings/km²</span>
                  </div>
                </div>
              </div>
              
              <div class="info-section">
                <div class="section-title">🌍 Coverage Details</div>
                <div class="stat-row">
                  <span class="stat-label">Region Size</span>
                  <span class="stat-value">${regionArea.toStringAsFixed(2)} km²</span>
                </div>
                <div class="stat-row">
                  <span class="stat-label">Data Source</span>
                  <span class="stat-value">Google Open Buildings</span>
                </div>
                <div class="stat-row">
                  <span class="stat-label">Building Density</span>
                  <span class="stat-value">${buildingDensity.toStringAsFixed(1)}/km²</span>
                </div>
              </div>
              
              <div class="footer">
                🌍 Visualized on Liquid Galaxy<br>
                📊 Live Building Data Analysis
              </div>
            </body>
          </html>
        </href>
      </Icon>
      <overlayXY x="1" y="1" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.98" y="0.98" xunits="fraction" yunits="fraction"/>
      <size x="0" y="0" xunits="fraction" yunits="fraction"/>
    </ScreenOverlay>
  </Document>
</kml>''';
  }


  // Add these methods to your SelectedRegionBottomSheet class:

// Create KML for all buildings in the region
  // Replace your _createBulkBuildingsKML method with this fixed version:

  String _createBulkBuildingsKML(List<BuildingData> buildings) {
    final StringBuffer kmlBuffer = StringBuffer();

    // KML Header
    kmlBuffer.write('''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="bulk_buildings_${DateTime.now().millisecondsSinceEpoch}">
    <name>Regional Building Analysis</name>
    <description>
      <![CDATA[
        <h3>📊 Regional Building Footprints</h3>
        <p><strong>Total Buildings:</strong> ${buildings.length}</p>
        <p><strong>Average Area:</strong> ${_getAverageArea().toStringAsFixed(0)} m²</p>
        <p><strong>Data Source:</strong> Google Open Buildings</p>
      ]]>
    </description>
    <open>1</open>
    
    <!-- FIXED: Shared Styles with Proper Colors -->
    <Style id="building_high_confidence">
      <LineStyle>
        <color>ff00ff00</color>
        <width>2</width>
      </LineStyle>
      <PolyStyle>
        <color>4d00ff00</color>
        <fill>1</fill>
        <outline>1</outline>
      </PolyStyle>
    </Style>
    
    <Style id="building_medium_confidence">
      <LineStyle>
        <color>ff00aaff</color>
        <width>2</width>
      </LineStyle>
      <PolyStyle>
        <color>4d00aaff</color>
        <fill>1</fill>
        <outline>1</outline>
      </PolyStyle>
    </Style>
    
    <Style id="building_low_confidence">
      <LineStyle>
        <color>ff0000ff</color>
        <width>2</width>
      </LineStyle>
      <PolyStyle>
        <color>4d0000ff</color>
        <fill>1</fill>
        <outline>1</outline>
      </PolyStyle>
    </Style>
    
    <!-- High Confidence Buildings Folder -->
    <Folder>
      <name>🟢 High Confidence Buildings (>80%)</name>
      <open>1</open>
''');

    // Group buildings by confidence for better organization
    final highConfidenceBuildings = buildings.where((b) => b.confidenceScore > 0.8).toList();
    final mediumConfidenceBuildings = buildings.where((b) => b.confidenceScore > 0.5 && b.confidenceScore <= 0.8).toList();
    final lowConfidenceBuildings = buildings.where((b) => b.confidenceScore <= 0.5).toList();

    // Add high confidence buildings
    for (int i = 0; i < highConfidenceBuildings.length; i++) {
      kmlBuffer.write(_createBuildingPlacemark(highConfidenceBuildings[i], i + 1, 'building_high_confidence'));
    }

    kmlBuffer.write('''
    </Folder>
    
    <!-- Medium Confidence Buildings Folder -->
    <Folder>
      <name>🟡 Medium Confidence Buildings (50-80%)</name>
      <open>0</open>
''');

    // Add medium confidence buildings
    for (int i = 0; i < mediumConfidenceBuildings.length; i++) {
      kmlBuffer.write(_createBuildingPlacemark(mediumConfidenceBuildings[i], i + 1, 'building_medium_confidence'));
    }

    kmlBuffer.write('''
    </Folder>
    
    <!-- Low Confidence Buildings Folder -->
    <Folder>
      <name>🔴 Low Confidence Buildings (<50%)</name>
      <open>0</open>
''');

    // Add low confidence buildings
    for (int i = 0; i < lowConfidenceBuildings.length; i++) {
      kmlBuffer.write(_createBuildingPlacemark(lowConfidenceBuildings[i], i + 1, 'building_low_confidence'));
    }

    kmlBuffer.write('''
    </Folder>
  </Document>
</kml>''');

    return kmlBuffer.toString();
  }

// Create a single building placemark (optimized for bulk operations)
  String _createBuildingPlacemark(BuildingData building, int index, String styleId) {
    final center = _calculateBuildingCenter(building);
    final plusCode = _generatePlusCode(building);

    // Create coordinates string for the polygon
    String coordinates = building.polygonPoints
        .map((point) => '${point.longitude},${point.latitude},0')
        .join(' ');

    // Close the polygon
    if (building.polygonPoints.isNotEmpty) {
      final firstPoint = building.polygonPoints.first;
      coordinates += ' ${firstPoint.longitude},${firstPoint.latitude},0';
    }

    return '''
      <Placemark>
        <name>$plusCode</name>
        <description>
          <![CDATA[
            <table style="font-family: Arial; font-size: 12px;">
              <tr><td><b>Plus Code:</b></td><td>$plusCode</td></tr>
              <tr><td><b>Area:</b></td><td>${building.area.toStringAsFixed(0)} m²</td></tr>
              <tr><td><b>Confidence:</b></td><td>${(building.confidenceScore * 100).toStringAsFixed(1)}%</td></tr>
              <tr><td><b>Points:</b></td><td>${building.polygonPoints.length}</td></tr>
            </table>
          ]]>
        </description>
        <styleUrl>#$styleId</styleUrl>
        <Polygon>
          <extrude>0</extrude>
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

  // Create KML for individual building

  String _createIndividualBuildingKML(BuildingData building) {
    final center = _calculateBuildingCenter(building);
    final plusCode = _generatePlusCode(building);

    // Create coordinates string for the polygon
    String coordinates = building.polygonPoints
        .map((point) => '${point.longitude},${point.latitude},0')
        .join(' ');

    // Close the polygon by adding the first point at the end
    if (building.polygonPoints.isNotEmpty) {
      final firstPoint = building.polygonPoints.first;
      coordinates += ' ${firstPoint.longitude},${firstPoint.latitude},0';
    }

    // Determine confidence color
    String confidenceColor = 'ff00ff00'; // Green for high confidence
    String markerIcon = 'http://maps.google.com/mapfiles/kml/paddle/grn-circle.png';
    if (building.confidenceScore <= 0.5) {
      confidenceColor = 'ff0000ff'; // Red for low confidence
      markerIcon = 'http://maps.google.com/mapfiles/kml/paddle/red-circle.png';
    } else if (building.confidenceScore <= 0.8) {
      confidenceColor = 'ff00aaff'; // Orange for medium confidence
      markerIcon = 'http://maps.google.com/mapfiles/kml/paddle/orange-circle.png';
    }

    // Create the main building placemark with polygon
    String buildingPlacemark = '''
    <Placemark>
      <name>Building: $plusCode</name>
      <description>
        <![CDATA[
          <div style="font-family: Arial, sans-serif; width: 300px;">
            <h3 style="color: #1976d2; margin: 0;">🏢 Building Information</h3>
            <hr style="margin: 10px 0;">
            <table style="width: 100%; border-collapse: collapse;">
              <tr><td style="font-weight: bold; color: #666;">Plus Code:</td><td style="font-family: monospace; color: #1976d2;">$plusCode</td></tr>
              <tr><td style="font-weight: bold; color: #666;">Area:</td><td>${building.area.toStringAsFixed(0)} m²</td></tr>
              <tr><td style="font-weight: bold; color: #666;">Confidence:</td><td style="color: ${building.confidenceScore > 0.8 ? 'green' : building.confidenceScore > 0.5 ? 'orange' : 'red'}; font-weight: bold;">${(building.confidenceScore * 100).toStringAsFixed(1)}%</td></tr>
              <tr><td style="font-weight: bold; color: #666;">Complexity:</td><td>${building.polygonPoints.length} points</td></tr>
              <tr><td style="font-weight: bold; color: #666;">Center:</td><td>${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}</td></tr>
            </table>
            <hr style="margin: 10px 0;">
            <p style="font-size: 12px; color: #888; margin: 5px 0;">📊 Data from Google Open Buildings</p>
          </div>
        ]]>
      </description>
      <Style>
        <LineStyle>
          <color>$confidenceColor</color>
          <width>3</width>
        </LineStyle>
        <PolyStyle>
          <color>4d${confidenceColor.substring(2)}</color>
          <fill>1</fill>
          <outline>1</outline>
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

    // Create the center marker
    String centerMarker = '''
    <Placemark>
      <name>📍 $plusCode</name>
      <description>
        <![CDATA[
          <h4>Building Center Point</h4>
          <p><strong>Plus Code:</strong> $plusCode</p>
          <p><strong>Confidence:</strong> ${(building.confidenceScore * 100).toStringAsFixed(1)}%</p>
        ]]>
      </description>
      <Style>
        <IconStyle>
          <Icon>
            <href>$markerIcon</href>
          </Icon>
          <scale>1.2</scale>
        </IconStyle>
        <LabelStyle>
          <color>ffffffff</color>
          <scale>0.8</scale>
        </LabelStyle>
      </Style>
      <Point>
        <coordinates>${center.longitude},${center.latitude},0</coordinates>
      </Point>
    </Placemark>
  ''';

    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="building_${DateTime.now().millisecondsSinceEpoch}">
    <name>Building: $plusCode</name>
    <open>1</open>
    <Folder>
      <name>Building Visualization</name>
      <open>1</open>
      $buildingPlacemark
      $centerMarker
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

  double _getAverageArea() {
    if (widget.buildings.isEmpty) return 0.0;
    return _getTotalArea() / widget.buildings.length;
  }

  double _getAverageConfidence() {
    if (widget.buildings.isEmpty) return 0.0;
    double totalConfidence = widget.buildings.fold(
      0.0,
          (sum, building) => sum + building.confidenceScore,
    );
    return (totalConfidence / widget.buildings.length) * 100;
  }

  double _getAverageComplexity() {
    if (widget.buildings.isEmpty) return 0.0;
    double totalPoints = widget.buildings.fold(
      0.0,
          (sum, building) => sum + building.polygonPoints.length.toDouble(),
    );
    return totalPoints / widget.buildings.length;
  }

  double _getRegionArea() {
    // Calculate approximate area in km²
    final latDiff = widget.selectedOverlay.bounds.northEast.latitude -
        widget.selectedOverlay.bounds.southWest.latitude;
    final lngDiff = widget.selectedOverlay.bounds.northEast.longitude -
        widget.selectedOverlay.bounds.southWest.longitude;

    // Rough approximation: 1 degree ≈ 111 km
    return latDiff * lngDiff * 111 * 111;
  }

  double _getBuildingDensity() {
    final regionArea = _getRegionArea();
    return regionArea > 0 ? widget.buildings.length / regionArea : 0.0;
  }
}

// Import this class if it doesn't exist in your models
class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}