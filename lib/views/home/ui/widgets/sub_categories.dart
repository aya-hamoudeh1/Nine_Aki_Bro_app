import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/widgets/appbar/appbar.dart';
import '../../../../core/widgets/images/t_rounded_image.dart';
import '../../../../core/widgets/products/product_cards/product_card_horizontal.dart';
import '../../../../core/widgets/texts/section_heading.dart';
import '../../../../core/constants/sizes.dart';
import '../../logic/cubit/home_cubit.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeCubit>().getProductsByCategory(widget.category.categoryId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  TAppBar(
        title: Text(widget.category.title),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
               TRoundedImage(
                width: double.infinity,
                imageUrl: widget.category.imgUrl,
                applyImageRadius: true,
                 isNetworkImage: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sub-Categories
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final filteredProducts =
                      context.read<HomeCubit>().categoryProduct;
                  return state is GetDataLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            /// Heading
                            TSectionHeading(
                              title: widget.category.title,
                              showActionButton: false,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 2),

                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                itemCount: filteredProducts.length,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: TSizes.spaceBtwItems),
                                itemBuilder: (context, index) =>
                                    TProductCardHorizontal(
                                  productModel: filteredProducts[index],
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
