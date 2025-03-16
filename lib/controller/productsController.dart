// ignore_for_file: file_names

import 'package:delivery_app/core/Apis/ExceptionsHandle.dart';
import 'package:delivery_app/core/Apis/Network.dart';
import 'package:delivery_app/core/Apis/Urls.dart';
import 'package:delivery_app/core/constant/route.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

abstract class ProductsController extends GetxController {
  goToDiscribtion({
    required String productName,
    required String productImage,
    required int categoryId,
    required int storeId,
    required int productId,
    required String storeName,
  });
}

class ProductsControllerImp extends ProductsController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  
 Future<void> fetchProductsByStoreId(int categoryId, int storeId) async {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    dio.Response response = await Network.getData(
      url: Urls.getProductsByStores(categoryId, storeId),
    );
    if (response.statusCode == 200) {
      var productsData = response.data['data'];
      if (productsData != null) {
        products.value = List<Map<String, dynamic>>.from(productsData);
       
      } else {
        errorMessage.value = 'لا توجد منتجات.';
      }
    } else {
      errorMessage.value = 'فشل في جلب المنتجات. حاول مرة أخرى.';
    }
  } on DioException catch (e) {
    errorMessage.value = exceptionsHandle(error: e);
  } catch (e) {
    errorMessage.value = 'حدث خطأ غير متوقع: $e';
  } finally {
    isLoading.value = false;
  }
}
  List<Map<String, dynamic>> searchProducts(String query) {
 
  var filteredProducts = products.where((product) {
    
    String productName = product['name'].toLowerCase().trim();
    bool match = productName.contains(query.toLowerCase().trim());
   
    return match;
  }).toList();

  return filteredProducts;
}

  
  @override
  goToDiscribtion({
    required String productName,
    required String productImage,
    required int categoryId,
    required int storeId,
    required int productId,
    required String storeName,
  }) {
    Get.toNamed(
      Approute.discribtion,
      arguments: {
        'productName': productName,
        'productImage': productImage,
        'categoryId': categoryId,
        'storeId': storeId,
        'productId': productId,
        'storeName': storeName,
      },
    );
  }
}
