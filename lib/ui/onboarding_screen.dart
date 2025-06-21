import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  final Widget homeScreen;

  const OnboardingScreen({Key? key, required this.homeScreen}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: "Liquid Galaxy Integration",
      description: "Send building data to Liquid Galaxy for immersive visualization experience",
      icon: Icons.integration_instructions,
      colors: [Colors.blue, Colors.red, Colors.orange, Colors.blue, Colors.green],
    ),
    OnboardingData(
      title: "Liquid Galaxy Open Buildings Explorer",
      description: "Explore building footprints across the globe with interactive visualization",
      icon: Icons.explore,
      colors: [Colors.blue, Colors.red, Colors.orange, Colors.blue, Colors.green],
      hasSecondaryIcon: true,
    ),
    OnboardingData(
      title: "Interactive Map",
      description: "Select regions to visualize building density and footprints in real-time",
      icon: Icons.map,
      colors: [Colors.blue, Colors.red, Colors.orange, Colors.blue, Colors.green],
      hasSecondaryIcon: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "9:30",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                ],
              ),
            ),

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
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                          (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.blue
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
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
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        currentIndex == onboardingPages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Home indicator
                  Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
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
    final isSmallScreen = screenSize.height < 700;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.08,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo and icon section
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Liquid Galaxy logo
                Container(
                  height: isSmallScreen ? 60 : 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: data.colors.map((color) {
                      int index = data.colors.indexOf(color);
                      return Container(
                        width: isSmallScreen ? 12 : 16,
                        height: isSmallScreen ? 50 : 70,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY((index - 2) * 0.2),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "liquid galaxy",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 24,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),

                if (data.hasSecondaryIcon) ...[
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  // Secondary icon (star-like shape with code symbol)
                  Container(
                    width: isSmallScreen ? 80 : 100,
                    height: isSmallScreen ? 80 : 100,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Star background
                        CustomPaint(
                          size: Size(isSmallScreen ? 80 : 100, isSmallScreen ? 80 : 100),
                          painter: StarPainter(),
                        ),
                        // Code icon
                        Container(
                          width: isSmallScreen ? 40 : 50,
                          height: isSmallScreen ? 40 : 50,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.code,
                            color: Colors.white,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    fontSize: isSmallScreen ? 20 : 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey.shade600,
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

// Custom painter for star shape
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.shade300
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.6;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Data model for onboarding pages
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final bool hasSecondaryIcon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.colors,
    this.hasSecondaryIcon = false,
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
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(homeScreen: widget.child);
    }

    return widget.child;
  }
}