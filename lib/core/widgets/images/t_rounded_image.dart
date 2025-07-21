import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.width,
    this.height,
    this.imageUrl,
    this.applyImageRadius = true,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.border,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
  });

  final double? width, height;
  final String? imageUrl;
  final bool applyImageRadius;
  final Color? backgroundColor;
  final BoxFit? fit;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius:
              applyImageRadius
                  ? BorderRadius.circular(borderRadius)
                  : BorderRadius.zero,
          child:
              (imageUrl == null || imageUrl!.isEmpty)
                  ? Center(
                    child: Icon(Icons.image_not_supported, color: TColors.grey),
                  ) // Show placeholder
                  : Image(
                    image:
                        isNetworkImage
                            ? NetworkImage(imageUrl!)
                            : AssetImage(imageUrl!) as ImageProvider,
                    fit: fit,
                    // Add error builder for network images
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error_outline, color: TColors.grey),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
