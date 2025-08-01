import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;  // ADD THIS
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          localizations.help_title,  // CHANGED: 'Help' → localized
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
              localizations.help_app_title,  // CHANGED: 'Open Buildings Explorer' → localized
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              localizations.help_app_description,  // CHANGED: Description → localized
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
              title: localizations.help_step1_title,         // CHANGED: Localized
              description: localizations.help_step1_description,  // CHANGED: Localized
              icon: Icons.zoom_in_map_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 2
            _buildHelpStep(
              context,
              stepNumber: '2',
              title: localizations.help_step2_title,         // CHANGED: Localized
              description: localizations.help_step2_description,  // CHANGED: Localized
              icon: Icons.touch_app_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 3
            _buildHelpStep(
              context,
              stepNumber: '3',
              title: localizations.help_step3_title,         // CHANGED: Localized
              description: localizations.help_step3_description,  // CHANGED: Localized
              icon: Icons.view_list_rounded,
            ),

            SizedBox(height: screenHeight * 0.03),

            // Step 4
            _buildHelpStep(
              context,
              stepNumber: '4',
              title: localizations.help_step4_title,         // CHANGED: Localized
              description: localizations.help_step4_description,  // CHANGED: Localized
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
                        localizations.help_confidence_title,  // CHANGED: Localized
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
                    localizations.help_confidence_description,  // CHANGED: Localized
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

  // _buildHelpStep method stays the same - title and description are passed as parameters
  Widget _buildHelpStep(
      BuildContext context, {
        required String stepNumber,
        required String title,      // This will receive localized text
        required String description, // This will receive localized text
        required IconData icon,
      }) {
    // Method implementation stays exactly the same
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      title,  // This will be localized text
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
                description,  // This will be localized text
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