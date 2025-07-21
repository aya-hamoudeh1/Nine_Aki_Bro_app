import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_aki_bro_app/core/widgets/loaders/loading_widget.dart';
import 'package:nine_aki_bro_app/generated/local_keys.g.dart';
import 'package:nine_aki_bro_app/views/store/widgets/category_tab.dart';
import '../../core/widgets/appbar/appbar.dart';
import '../../core/widgets/appbar/tabbar.dart';
import '../../core/widgets/custom_shapes/containers/search_container.dart';
import '../../core/widgets/products/cart/cart_menu_icon.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/sizes.dart';
import '../../core/helpers/helper_functions.dart';
import '../home/logic/cubit/home_cubit.dart';
import '../home/ui/search_view.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    if (_homeCubit.products.isEmpty || _homeCubit.categories.isEmpty) {
      _homeCubit.getProducts();
    } else {
      _setupTabController(_homeCubit.categories.length);
    }
  }

  void _setupTabController(int length) {
    if (length == 0) return;
    _tabController = TabController(length: length, vsync: this);
    if (_homeCubit.categories.isNotEmpty) {
      _homeCubit.getProductsByCategory(_homeCubit.categories.first.categoryId);
    }
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) {
        final categoryId =
            _homeCubit.categories[_tabController.index].categoryId;
        _homeCubit.getProductsByCategory(categoryId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark : TColors.light,
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) => current is GetDataSuccess,
        listener: (context, state) {
          if (state is GetDataSuccess) {
            _setupTabController(state.categories.length);
          }
        },
        builder: (context, state) {
          if (_homeCubit.categories.isEmpty || state is GetDataLoading) {
            return LoadingWidget();
          }
          return NestedScrollView(
            /// Header
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  snap: true,
                  backgroundColor: dark ? TColors.black : TColors.white,
                  expandedHeight: 220,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        /// Appbar
                        TAppBar(
                          title: Text(
                            LocaleKeys.store.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: dark ? TColors.white : TColors.primary,
                            ),
                          ),
                          actions: [TCartCounterIcon(onPressed: () {})],
                        ),

                        /// Search bar
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TSearchContainer(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchView(),
                              ),
                            );
                          },
                          enableTextField: false,
                          text: LocaleKeys.search_in_store.tr(),
                          showBorder: true,
                          showBackground: false,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  /// Tabs
                  bottom: TTabBar(
                    controller: _tabController,
                    tabs:
                        _homeCubit.categories
                            .map((category) => Tab(text: category.title))
                            .toList(),
                  ),
                ),
              ];
            },

            /// Body
            body: TabBarView(
              controller: _tabController,
              children:
                  _homeCubit.categories.map((_) => TCategoryTab()).toList(),
            ),
          );
        },
      ),
    );
  }
}
