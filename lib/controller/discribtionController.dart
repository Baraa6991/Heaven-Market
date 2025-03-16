// ignore_for_file: file_names

import 'package:delivery_app/controller/cardController.dart';
import 'package:delivery_app/core/Apis/ExceptionsHandle.dart';
import 'package:delivery_app/core/Apis/Network.dart';
import 'package:delivery_app/core/Apis/Urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

abstract class DiscribtionController extends GetxController {
  fetchProductDetails(int categoryId, int storeId, int productId);
}

class DiscribtionControllerImp extends DiscribtionController {
 
  //  var isLoading = true.obs;
  // var errorMessage = ''.obs;
  // var productDescription = ''.obs;
  // var productPrice = ''.obs;
  // var availableQuantity = 0.obs; 
  var isLoading = false.obs;


  var errorMessage = ''.obs;

  
  var productName = ''.obs;
  var productImage = ''.obs;
  var productDescription = ''.obs;
  var productPrice = ''.obs;


  var availableQuantity = 0.obs;


  var isFavorite = false.obs;

  
  var storeName = ''.obs;

  // @override
  // Future<void> fetchProductDetails(
  //     int categoryId, int storeId, int productId) async {
  //   try {
  //     dio.Response response = await Network.getData(
  //       url: Urls.getDicikrebtionByProducts(categoryId, storeId, productId),
        
  //     );

  //     if (response.statusCode == 200) {
  //       productDescription.value =
  //           response.data['data']['description'] ?? 'No description available';
  //       productPrice.value =
  //           (double.tryParse(response.data['data']['price']) ?? 0.0).toString();

        
  //       availableQuantity.value = response.data['data']['quantity'] ?? 0;
  //     } else {
  //       errorMessage.value = 'فشل في جلب تفاصيل المنتج. حاول مرة أخرى.';
  //     }
  //   } on DioException catch (e) {
  //     errorMessage.value = exceptionsHandle(error: e);
  //   } catch (e) {
  //     errorMessage.value = 'حدث خطأ غير متوقع: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  @override
Future<void> fetchProductDetails(int categoryId, int storeId, int productId) async {
  try {
    isLoading.value = true; 
    dio.Response response = await Network.getData(
      url: Urls.getDicikrebtionByProducts(categoryId, storeId, productId),
    );

    if (response.statusCode == 200) {
      final data = response.data['data'];
      productDescription.value = data['description'] ?? 'No description available';
      productPrice.value = (double.tryParse(data['price']) ?? 0.0).toString();
      productName.value = data['name'] ?? 'Unknown Product';
      productImage.value = data['image'] ?? 'assets/logo.jpg';
      storeName.value = data['name_of_store'] ?? 'Unknown Store';
      availableQuantity.value = data['quantity'] ?? 0;
      isFavorite.value = data['favorite'] ?? false;
    } else {
      errorMessage.value = 'Failed to fetch product details. Try again.';
    }
  } on DioException catch (e) {
    errorMessage.value = exceptionsHandle(error: e);
  } catch (e) {
    errorMessage.value = 'Unexpected error occurred: $e';
  } finally {
    isLoading.value = false; 
  }
}


 
  Future<void> addToCartWithQuantity(
      int quantity, int productId, int storeId, String productName,
      String productImage, double productPrice) async {
    if (quantity > availableQuantity.value) {
     
      Get.snackbar(
        "snackBar3".tr,
        "snackBar10".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; 
    }
   
    await CardControllerControllerImp().AddToCard(
      quantity: quantity,
      storeId: storeId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      productPrice: productPrice,
      availableQuantity: availableQuantity.value,
    );
  }
}
