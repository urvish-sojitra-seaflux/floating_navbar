import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/ui/home/home_nav_items.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Nav bar dimensions and padding
  static const double navBarWidth = 220;
  static const double navBarHeight = 60;
  static const double horizontalPadding = 10.0;

  // Circle indicator size
  static const double circleDiameter = 40;

  final List<Widget> _pages = [
    Center(child: Text('Notifications', style: TextStyle(fontSize: 24))),
    Center(child: Text('Compass', style: TextStyle(fontSize: 24))),
    Center(child: Text('Favorites', style: TextStyle(fontSize: 24))),
  ];

  final List<NavItemData> _navItems = [
    NavItemData(icon: Icons.notifications),
    NavItemData(imageAsset: 'assets/icons/compass.png'),
    NavItemData(icon: Icons.favorite),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNavIcon(NavItemData item, bool isSelected) {
    final color = isSelected ? Colors.white : Colors.blue;
    if (item.imageAsset != null) {
      final isSvg = item.imageAsset!.endsWith('.svg');
      return isSvg
          ? SvgPicture.asset(item.imageAsset!,
              width: 25, height: 25, color: color)
          : Image.asset(item.imageAsset!, width: 25, height: 25, color: color);
    }
    return Icon(item.icon, size: 25, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final int itemCount = _navItems.length;
    // Inner width inside padding
    final double innerWidth = navBarWidth - 2 * horizontalPadding;
    // Each segment width for an item
    final double segmentWidth = innerWidth / itemCount;
    // Vertical position for the circle
    final double circleTop = (navBarHeight - circleDiameter) / 2;
    // Horizontal offset inside padded area
    final double circleLeft =
        segmentWidth * _currentIndex + (segmentWidth - circleDiameter) / 2;

    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),

          // Navigation bar
          Positioned(
            left: (MediaQuery.of(context).size.width - navBarWidth) / 2,
            bottom: 30,
            child: Container(
              width: navBarWidth,
              height: navBarHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Stack(
                  children: [
                    // Sliding circle indicator
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      top: circleTop,
                      left: circleLeft,
                      child: Container(
                        width: circleDiameter,
                        height: circleDiameter,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Icons row
                    Row(
                      children: List.generate(itemCount, (index) {
                        return SizedBox(
                          width: segmentWidth,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => _onTabTapped(index),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedNavItem(
                                isSelected: _currentIndex == index,
                                icon: _buildNavIcon(
                                  _navItems[index],
                                  _currentIndex == index,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
