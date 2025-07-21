import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/image_text_widget/vertical_image_text.dart';
import '../../../../core/models/category_model.dart';
import '../../logic/cubit/home_cubit.dart';
import 'sub_categories.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key, required this.categories});
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final categories = context.read<HomeCubit>().categories;
          return state is GetDataLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  final category = categories[index];
                  return TVerticalImageText(
                    image: category.imgUrl,
                    title: category.title,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SubCategoriesScreen(category: category),
                        ),
                      );
                    },
                  );
                },
              );
        },
      ),
    );
  }
}
