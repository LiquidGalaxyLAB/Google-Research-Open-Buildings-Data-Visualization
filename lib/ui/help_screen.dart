import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        AppColors.updateThemeState(themeProvider.isDarkMode);

        return Scaffold(
          backgroundColor: AppColors.currentBackground,
          appBar: AppBar(
            backgroundColor: AppColors.currentSurface,
            elevation: 0,
            title: Text(
              localizations.help_title,
              style: TextStyle(
                color: AppColors.currentOnSurface,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.045,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.currentOnSurface,
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
                  localizations.help_app_title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w700,
                    color: AppColors.currentOnBackground,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  localizations.help_app_description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: AppColors.currentOnSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Step 1
                _buildHelpStep(
                  context,
                  stepNumber: '1',
                  title: localizations.help_step1_title,
                  description: localizations.help_step1_description,
                  icon: Icons.zoom_in_map_rounded,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Step 2
                _buildHelpStep(
                  context,
                  stepNumber: '2',
                  title: localizations.help_step2_title,
                  description: localizations.help_step2_description,
                  icon: Icons.touch_app_rounded,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Step 3
                _buildHelpStep(
                  context,
                  stepNumber: '3',
                  title: localizations.help_step3_title,
                  description: localizations.help_step3_description,
                  icon: Icons.view_list_rounded,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Step 4
                _buildHelpStep(
                  context,
                  stepNumber: '4',
                  title: localizations.help_step4_title,
                  description: localizations.help_step4_description,
                  icon: Icons.business_rounded,
                ),

                SizedBox(height: screenHeight * 0.04),

                // Additional info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: AppColors.currentSurfaceContainer,
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.currentPrimary,
                            size: screenWidth * 0.05,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            localizations.help_confidence_title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: AppColors.currentOnSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        localizations.help_confidence_description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: AppColors.currentOnSurfaceVariant,
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
                    color: AppColors.currentPrimary.withOpacity(0.1),
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
      },);
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
        Container(
          width: screenWidth * 0.12,
          height: screenWidth * 0.12,
          decoration: BoxDecoration(
            color: AppColors.currentPrimary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: TextStyle(
                color: AppColors.currentOnPrimary,
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
                    color: AppColors.currentPrimary,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: AppColors.currentOnBackground,
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
                  color: AppColors.currentOnSurfaceVariant,
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