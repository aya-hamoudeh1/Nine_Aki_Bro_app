import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper_functions.dart';

// class TCircularIcon extends StatelessWidget {
//   const TCircularIcon({
//     super.key,
//     this.width,
//     this.height,
//     this.size = TSizes.lg,
//     required this.icon,
//     this.color,
//     this.backgroundColor,
//     this.onPressed,
//   });
//
//   final double? width, height, size;
//   final IconData icon;
//   final Color? color;
//   final Color? backgroundColor;
//   final VoidCallback? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     bool dark = THelperFunction.isDarkMode(context);
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: backgroundColor != null
//             ? backgroundColor!
//             : dark
//                 ? TColors.black.withOpacity(0.9)
//                 : TColors.white.withOpacity(0.9),
//       ),
//       child: IconButton(
//         onPressed: onPressed,
//         icon: Icon(icon, color: color, size: size),
//       ),
//     );
//   }
// }

// file: animated_circular_icon.dart

class AnimatedCircularIcon extends StatefulWidget {
  const AnimatedCircularIcon({
    super.key,
    required this.icon,
    this.onPressed,
    this.width,
    this.height,
    this.size = TSizes.lg,
    this.color,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;

  @override
  State<AnimatedCircularIcon> createState() => _AnimatedCircularIconState();
}

class _AnimatedCircularIconState extends State<AnimatedCircularIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.85,
      upperBound: 1.2,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _runAnimation() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return ScaleTransition(
      scale: _controller,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: dark ? TColors.primary : TColors.grey
            // widget.backgroundColor != null
            //     ? widget.backgroundColor!
            //     : dark
            //         ? TColors.black.withOpacity(0.9)
            //         : TColors.white.withOpacity(0.9),
            ),
        child: IconButton(
          icon: Icon(widget.icon, color: widget.color, size: widget.size),
          onPressed: () {
            _runAnimation();
            widget.onPressed!();
          },
        ),
      ),
    );
  }
}
