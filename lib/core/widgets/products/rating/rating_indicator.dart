import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

// class TRatingBarIndicator extends StatelessWidget {
//   const TRatingBarIndicator({
//     super.key, required this.rating,
//   });
//
//   final double? rating;
//
//   @override
//   Widget build(BuildContext context) {
//     return RatingBarIndicator(
//       rating: rating ?? 0,
//       itemSize: 20,
//       unratedColor: TColors.grey,
//       itemBuilder: (_, __) => const Icon(Iconsax.star1, color: TColors.primary),
//     );
//   }
// }

class TRatingBarSelector extends StatelessWidget {
  const TRatingBarSelector({
    super.key,
    required this.initialRating,
    required this.onRatingUpdate,
    this.isReadOnly = false,
  });

  final double initialRating;
  final void Function(double) onRatingUpdate;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      maxRating: 5,
      itemCount: 5,
      itemSize: 30,
      unratedColor: TColors.grey,
      allowHalfRating: false,
      itemBuilder: (context, _) =>
          const Icon(Iconsax.star1, color: Colors.amber),
      onRatingUpdate: isReadOnly ? (_) {} : onRatingUpdate,
      ignoreGestures: isReadOnly,
    );
  }
}
