import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../constants/colors.dart';

class TNotificationCounterIcon extends StatelessWidget {
  const TNotificationCounterIcon({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
    this.counter,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final Color? iconColor, counterBgColor, counterTextColor;
  final int? counter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.notification,
            color: iconColor,
          ),
        ),
        if (counter != null && counter! > 0)
          Positioned(
            right: 0,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: counterBgColor ?? TColors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  counter!.toString(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: counterTextColor ?? TColors.primary,
                        fontSize: 10,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
