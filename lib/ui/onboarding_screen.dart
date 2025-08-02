import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../providers/theme_provider.dart';

class OnboardingScreen extends StatefulWidget {
  final Widget homeScreen;

  const OnboardingScreen({Key? key, required this.homeScreen}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentIndex = 0;


  List<OnboardingData> get onboardingPages {
    final localizations = AppLocalizations.of(context)!;
    return [
      OnboardingData(
        title: localizations.onboarding_lg_integration_title,
        description: localizations.onboarding_lg_integration_description,
        imagePath: "assets/logos/lg_logo.png",
      ),
      OnboardingData(
        title: localizations.onboarding_explorer_title,
        description: localizations.onboarding_explorer_description,
        imagePath: "assets/logos/gsoc_logo.png",
      ),
      OnboardingData(
        title: localizations.onboarding_interactive_map_title,
        description: localizations.onboarding_interactive_map_description,
        imagePath: "assets/logos/logo.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: onboardingPages[index],
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                          (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                        width: currentIndex == index ? screenWidth * 0.06 : screenWidth * 0.02,
                        height: screenHeight * 0.01,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(screenWidth * 0.01),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentIndex == onboardingPages.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        currentIndex == onboardingPages.length - 1
                            ? localizations.onboarding_get_started  // CHANGED: Localized
                            : localizations.onboarding_next,       // CHANGED: Localized
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.025),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.homeScreen),
    );
  }
}
// Individual Onboarding Page Widget
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Responsive sizing
    final isSmallScreen = screenHeight < 700;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: screenHeight * 0.025,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo section
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main logo image
                Container(
                  width: screenWidth * (isSmallScreen ? 0.4 : 0.5),
                  height: screenHeight * (isSmallScreen ? 0.2 : 0.25),
                  child: Image.asset(
                    data.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // Text content section
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * (isSmallScreen ? 0.05 : 0.065),
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                    height: 1.2,
                  ),
                ),

                SizedBox(height: screenHeight * (isSmallScreen ? 0.015 : 0.02)),

                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * (isSmallScreen ? 0.035 : 0.04),
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for onboarding pages
class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// Wrapper widget to check if onboarding should be shown
class OnboardingWrapper extends StatefulWidget {
  final Widget child;

  const OnboardingWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _OnboardingWrapperState createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;

    setState(() {
      _showOnboarding = isFirstTime;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(homeScreen: widget.child);
    }

    return widget.child;
  }
}