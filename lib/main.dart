import 'dart:ui';

import 'package:flutter/material.dart';

// Replace these with your actual constants
const Color blackColor = Colors.black;
const Color whiteColor = Colors.white;
const Color transparentColor = Colors.transparent;
const double fontSize20 = 20.0;
const FontWeight fontWeightSemiBold = FontWeight.w600;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Animation NavBar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DraggableNavbar1(),
    );
  }
}

class DraggableNavbar1 extends StatefulWidget {
  const DraggableNavbar1({super.key});
  @override
  State<DraggableNavbar1> createState() => _DraggableNavbar1State();
}

class _DraggableNavbar1State extends State<DraggableNavbar1> {
  int _selectedIndex = 0;

  final List<String> titles = [
    'Home',
    'Search',
    'Add',
    'Messages',
    'Profile',
  ];
  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.add_circle_outline,
    Icons.message,
    Icons.person,
  ];

  final GlobalKey _barKey = GlobalKey();
  double _navBarWidth = 0;
  final double _navBarPadding = 20;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_navBarWidth == 0) return;

    final localPosition = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);
    final double dx = localPosition.dx;

    final int newIndex = (dx / (_navBarWidth / titles.length))
        .clamp(0, titles.length - 1)
        .toInt();

    if (newIndex != _selectedIndex) {
      setState(() => _selectedIndex = newIndex);
    }
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    Widget iconContent = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? whiteColor : transparentColor,
          width: 4,
        ),
        color:
            isSelected ? Colors.red.withValues(alpha: 0.4) : transparentColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 30, color: whiteColor),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(0, isSelected ? -25 : 0, 0),
      curve: Curves.easeOut,
      child: isSelected
          ? ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: iconContent,
              ),
            )
          : iconContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Measure nav bar width once rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _barKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        _navBarWidth = box.size.width + (_navBarPadding * 2);
      }
    });

    return Scaffold(
      backgroundColor: blackColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero)
                      .animate(animation),
              child: child,
            ),
          );
        },
        key: ValueKey<int>(_selectedIndex),
        child: page(titles[_selectedIndex]),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _navBarPadding),
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: Container(
              key: _barKey,
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                selectedFontSize: 0,
                unselectedFontSize: 0,
                elevation: 0,
                items: List.generate(icons.length, (index) {
                  return BottomNavigationBarItem(
                    icon: _buildIcon(icons[index], index),
                    label: '',
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget page(String title) {
    return Container(
      key: ValueKey(title),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: whiteColor,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: blackColor,
            fontSize: fontSize20,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      ),
    );
  }
}
