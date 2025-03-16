import 'package:delivery_app/core/Apis/ExceptionsHandle.dart';
import 'package:delivery_app/core/Apis/Network.dart';
import 'package:delivery_app/core/Apis/Urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

abstract class FavoriteController extends GetxController {
  AddToFavorite({
    required int storeId,
    required int productId,
  });
  fetchFavorites();
   deleteFavorite(int id);
}

class FavoriteControllerImp extends FavoriteController {
  var favorites = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isFavorite = false.obs;

  Future<void> AddToFavorite({
    required int storeId,
    required int productId,
  }) async {
    try {
      final response = await Network.postData(
        url: "${Urls.auth}/add/favourites",
        data: {
          "store_id": storeId.toString(),
          "product_id": productId.toString(),
        },
      );

      if (response.statusCode == 201 && response.data['successful']) {
        isFavorite.value = true;
        update();
        Get.snackbar(
          "snackBar2".tr,
          response.data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "snackBar3".tr,
          response.data['message'] ?? "فشل في إضافة المنتج إلى المفضلة",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "snackBar3".tr,
        "snackBar11".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Future<void> fetchFavorites() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await Network.getData(
        url: '${Urls.auth}/get/favourites',
      );
      if (response.data['successful'] == true) {
        favorites.value =
            List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        errorMessage.value =
            response.data['message'] ?? 'Failed to load favorites.';
      }
    } on DioException catch (e) {
      errorMessage.value = exceptionsHandle(error: e);
    } catch (e) {
      errorMessage.value = 'An unknown error occurred.';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> deleteFavorite(int id) async {
  try {
    final response = await Network.deleteData(
      url: '${Urls.auth}/delete/favourite/$id',
    );
    if (response.data['successful'] == true) {
      favorites.removeWhere((item) => item['id'] == id);
      Get.snackbar(
        'snackBar2'.tr,
        'snackBar12'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'snackBar3'.tr,
        response.data['message'] ?? 'فشل في حذف المنتج.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'snackBar3'.tr,
      'حدث خطأ أثناء حذف المنتج.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

}
