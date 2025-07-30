import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Help',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.045,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            Text(
              'Open Buildings Explorer',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Explore building footprints across the globe with Liquid Galaxy integration',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Step 1
            _buildHelpStep(
              context,
              stepNumber: '1',
              title: 'Select Map Area',
              description: 'Use the controls on the right side of the map to modify and select the area of tiles you want to explore.',
              icon: Icons.zoom_in_map_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 2
            _buildHelpStep(
              context,
              stepNumber: '2',
              title: 'Choose a Tile',
              description: 'Click on a specific tile within your selected area to fetch building data from the Open Buildings dataset.',
              icon: Icons.touch_app_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 3
            _buildHelpStep(
              context,
              stepNumber: '3',
              title: 'View Results',
              description: 'Once data is fetched, a bottom sheet will appear showing the results. You can send all data to Liquid Galaxy for visualization.',
              icon: Icons.view_list_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 4
            _buildHelpStep(
              context,
              stepNumber: '4',
              title: 'Explore Buildings',
              description: 'Switch to the Buildings tab to see individual building details, including plus codes and confidence scores.',
              icon: Icons.business_rounded,
            ),

            SizedBox(height: screenHeight * 0.04),

            // Additional info
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'About Confidence Scores',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Each building shows a confidence score that indicates how reliable the data from the Open Buildings dataset is for that particular structure.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Static image container
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/splash_kml.png'),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpStep(
      BuildContext context, {
        required String stepNumber,
        required String title,
        required String description,
        required IconData icon,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step number circle
        Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.12,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ),

        SizedBox(width: screenWidth * 0.04),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.primary,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                description,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}