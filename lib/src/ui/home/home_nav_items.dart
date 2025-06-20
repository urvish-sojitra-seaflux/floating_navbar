import 'package:flutter/material.dart';

class NavItemData {
  final IconData? icon;
  final String? imageAsset;

  NavItemData({this.icon, this.imageAsset})
      : assert(icon != null || imageAsset != null,
            'Provide either icon or imageAsset');
}

class AnimatedNavItem extends StatefulWidget {
  final Widget icon;
  final bool isSelected;
  final Duration duration;

  const AnimatedNavItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<AnimatedNavItem> createState() => AnimatedNavItemState();
}

class AnimatedNavItemState extends State<AnimatedNavItem>
    with TickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final AnimationController _scaleController;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.25), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.25, end: 0.25), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.25, end: -0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _shakeController.forward(from: 0).whenComplete(() {
        _scaleController.forward(from: 0);
      });
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeController, _scaleController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.icon,
    );
  }
}
