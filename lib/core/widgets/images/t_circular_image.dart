import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
import '../../helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: image,
        fit: fit,
        placeholder: (context, url) => LoadingWidget(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder:
            (context, imageProvider) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(width / 2),
                image: DecorationImage(image: imageProvider, fit: fit),
              ),
            ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          // if image background color is null then switch it to light and dark mode color design.
          color:
              backgroundColor ??
              (THelperFunction.isDarkMode(context)
                  ? TColors.black
                  : TColors.white),
          borderRadius: BorderRadius.circular(width / 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(width / 2),
          child: Image(
            fit: fit,
            image: AssetImage(image) as ImageProvider,
            color: overlayColor,
          ),
        ),
      );
    }
  }
}
