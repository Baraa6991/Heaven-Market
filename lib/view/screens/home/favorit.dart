import 'package:delivery_app/controller/favoriteController.dart';
import 'package:delivery_app/view/screens/home/homescreencardview.dart/FavoritScreenBady.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favorit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoriteControllerImp favoritesController =
        Get.put(FavoriteControllerImp());

    favoritesController.fetchFavorites();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'Favorites',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.grey[800],
              ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (favoritesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        if (favoritesController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              favoritesController.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (favoritesController.favorites.isEmpty) {
          return const Center(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 SizedBox(height: 20),
                 Text(
                  'لا توجد منتجات مفضلة حالياً.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: favoritesController.favorites.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1.4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) {
            final favoritItem = favoritesController.favorites[index];
            return FavoritScreenBady(
              productName: favoritItem['name'] ?? 'Unknown Product',
              productImage: favoritItem['image'] ?? '',
              categoryId: favoritItem['category_id'] ?? 0,
              storeId: favoritItem['store_id'] ?? 0,
              productId: favoritItem['product_id'] ?? 0,
              storeName: '',
              id: favoritItem['id'] ?? 0,
            );
          },
        );
      }),
    );
  }
}
