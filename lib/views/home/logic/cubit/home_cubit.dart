import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/api/api_services.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/models/favorite_model.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/models/purchase_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final ApiServices _apiServices = ApiServices();
  final String userId = Supabase.instance.client.auth.currentUser!.id;

  List<ProductModel> products = [];
  List<ProductModel> searchResults = [];
  bool isSearching = false;
  List<ProductModel> categoryProduct = [];
  List<CategoryModel> categories = [];

  /// Get All Product
  Future<void> getProducts() async {
    emit(GetDataLoading());
    try {
      var response = await _apiServices.getData(
        'products?select=*,favorite(*),purchase(*),product_variants(*)',
      );
      List<ProductModel> newProducts = [];
      for (var product in response.data) {
        newProducts.add(ProductModel.fromJson(product));
      }
      products.clear();
      searchResults.clear();
      userOrders.clear();

      products = newProducts;

      await getCategories();
      getFavoriteProduct();
      getUserOrders();
      emit(GetDataSuccess(products: products, categories: categories));
    } catch (e) {
      log(e.toString());
      emit(GetDataError());
    }
  }

  /// Search
  void search(String? query) {
    searchResults.clear();
    if (query != null && query.isNotEmpty) {
      isSearching = true;
      for (var product in products) {
        if (product.productName!.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(product);
        }
      }
      emit(GetDataSuccess(products: products, categories: categories));
    } else {
      isSearching = false;
      searchResults.clear();
      emit(GetDataSuccess(products: products, categories: categories));
    }
  }

  /// Get Categories
  Future<void> getCategories() async {
    try {
      var response = await _apiServices.getData('category');
      categories = List<CategoryModel>.from(
        response.data.map((category) => CategoryModel.fromJson(category)),
      );
      emit(GetDataSuccess(products: products, categories: categories));
    } catch (e) {
      log(e.toString());
      emit(GetDataError());
    }
  }

  /// Get Product By Category
  void getProductsByCategory(String? categoryId) {
    emit(GetCategoryProductLoading());
    try {
      categoryProduct.clear();
      if (categoryId != null) {
        for (var product in products) {
          if (product.categoryId == categoryId) {
            categoryProduct.add(product);
          }
        }
      }
      log("Filtered Products: ${categoryProduct.length}");
      emit(GetCategoryProductSuccess());
    } catch (e) {
      log(e.toString());
      emit(GetCategoryProductFailure(errMessage: e.toString()));
    }
  }

  void onCategorySelected(String categoryId) {
    getProductsByCategory(categoryId);
  }

  /// Add To Favorite
  Map<String, bool> favoriteProduct = {};
  Future<void> addToFavorite(String productId) async {
    try {
      await _apiServices.postData('favorite', {
        'is_favorite': true,
        'for_user': userId,
        'for_product': productId,
      });
      favoriteProduct[productId] = true;
      if (!favoriteProductList.any((p) => p.productId == productId)) {
        final product = products.firstWhere((p) => p.productId == productId);
        favoriteProductList.add(product);
      }
      emit(GetDataSuccess(products: products, categories: categories));
    } catch (e) {
      log(e.toString());
      emit(AddToFavoriteError());
    }
  }

  bool checkIsFavorite(String productId) {
    return favoriteProduct.containsKey(productId);
  }

  /// Remove From Favorite
  Future<void> removeFromFavorite(String productId) async {
    try {
      await _apiServices.deleteData(
        'favorite?for_user=eq.$userId&for_product=eq.$productId',
      );
      favoriteProduct.remove(productId);
      favoriteProductList.removeWhere(
        (product) => product.productId == productId,
      );
      emit(GetDataSuccess(products: products, categories: categories));
    } catch (e) {
      log(e.toString());
      emit(RemoveFavoriteError());
    }
  }

  /// Get Favorite Product
  List<ProductModel> favoriteProductList = [];
  void getFavoriteProduct() {
    favoriteProductList.clear();
    favoriteProduct.clear();
    for (ProductModel product in products) {
      if (product.favoriteProduct != null &&
          product.favoriteProduct!.isNotEmpty) {
        for (Favorite favorite in product.favoriteProduct!) {
          if (favorite.forUser == userId) {
            favoriteProductList.add(product);
            favoriteProduct.addAll({product.productId!: true});
          }
        }
      }
    }
  }

  /// Buy Product
  Future<void> buyProduct({required String productId}) async {
    emit(BuyProductLoading());
    try {
      await _apiServices.postData('purchase', {
        "for_user": userId,
        "is_bought": true,
        "for_product": productId,
      });
      emit(BuyProductSuccess());
    } catch (e) {
      log(e.toString());
      emit(BuyProductError());
    }
  }

  /// Get User Order Product
  List<ProductModel> userOrders = [];
  void getUserOrders() {
    for (ProductModel product in products) {
      if (product.purchase != null && product.purchase!.isNotEmpty) {
        for (Purchase userOrder in product.purchase!) {
          if (userOrder.forUser == userId) {
            userOrders.add(product);
          }
        }
      }
    }
  }
}
