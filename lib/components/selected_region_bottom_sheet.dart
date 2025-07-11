// components/selected_region_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/map_overlay.dart';
import '../models/building_data.dart';
import '../services/lg_service.dart';
import '../ui/settings_screen.dart';
import '../utils/colors.dart';


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
                onPressed: lgService.isConnected ? widget.onSendToLiquidGalaxy : () {
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
              onPressed: widget.onVisualizeHistoricalChanges,
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

    String placemark = '''
      <Placemark>
        <name>Building: $plusCode</name>
        <description>
          <![CDATA[
            <b>Building Information:</b><br/>
            Plus Code: $plusCode<br/>
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
    <name>Individual Building: $plusCode</name>
    <open>1</open>
    <Folder>
      <name>Selected Building</name>
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