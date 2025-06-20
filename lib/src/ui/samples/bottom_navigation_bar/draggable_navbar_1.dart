import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/src/base/utils/constants/color_constant.dart';
import 'package:flutter_boilerplate/src/base/utils/constants/fontsize_constant.dart';

class DraggableNavbar1 extends StatefulWidget {
  const DraggableNavbar1({Key? key}) : super(key: key);
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(0, isSelected ? -25 : 0, 0),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? whiteColor : Colors.transparent,
            width: 4,
          ),
          color: isSelected ? redColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 30, color: whiteColor),
      ),
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
