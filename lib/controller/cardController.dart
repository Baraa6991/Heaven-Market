// ignore_for_file: unnecessary_import, non_constant_identifier_names, file_names, avoid_renaming_method_parameters, annotate_overrides, avoid_print, prefer_const_declarations, prefer_const_constructors, unused_element, deprecated_member_use, unused_local_variable
import 'package:delivery_app/core/Apis/ExceptionsHandle.dart';
import 'package:delivery_app/core/Apis/Network.dart';
import 'package:delivery_app/core/Apis/Urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class CardController extends GetxController {
  Future<void> AddToCard({
    required int quantity,
    required int storeId,
    required int productId,
    required String productName,
    required String productImage,
    required double productPrice,
    required int availableQuantity,
  });
  Confirmorder();
  DeletProduct(int cartId);
  UpDateQuantity({
    required int cartId,
    required int newQuantity,
  });
  fetchCartItems();
  fetchOldReceipts();
}

class CardControllerControllerImp extends CardController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;
  RxDouble totalPrice = 0.0.obs;
  var priceee = ''.obs;
  var orders = <Map<String, dynamic>>[].obs;

  @override
  Future<void> AddToCard({
    required int quantity,
    required int storeId,
    required int productId,
    required String productName,
    required String productImage,
    required double productPrice,
    required int availableQuantity,
  }) async {
    isLoading.value = true;

    try {
      if (quantity > availableQuantity) {
        Get.snackbar(
          "Error",
          "snackBar".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final existingItemIndex = cartItems.indexWhere(
        (item) => item['productId'] == productId && item['storeId'] == storeId,
      );

      if (existingItemIndex != -1) {
        Get.snackbar(
          "Notice",
          "snackBar1".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        final response = await Network.postData(
          url: "${Urls.auth}/cart",
          data: {
            "quantity": quantity.toString(),
            "store_id": storeId.toString(),
            "product_id": productId.toString(),
          },
        );

        if (response.statusCode == 200 && response.data['successful']) {
          final cartItem = response.data['data'];
          final cartId = cartItem['id'];
          final userId = cartItem['user_id'];
          final storeProductId = cartItem['store_product_id'];
          final quantityStr = cartItem['quantity']?.toString();
          var totalPriceResponse = cartItem['total_price'];

          if (totalPriceResponse is int) {
            totalPriceResponse = totalPriceResponse.toDouble();
          }

          int quantity = 0;
          if (quantityStr != null && quantityStr.isNotEmpty) {
            quantity = int.tryParse(quantityStr) ?? 0;
          }

          cartItems.add({
            "id": cartId,
            "productId": productId,
            "storeId": storeId,
            "userId": userId,
            "productName": productName,
            "productImage": productImage,
            "quantity": quantity,
            "productPrice": productPrice,
            "totalPrice": totalPriceResponse,
          });

          totalPrice.value = totalPriceResponse;

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
            response.data['message'] ?? "Failed to add item to cart",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } on DioException catch (e) {
      String errorMessage = exceptionsHandle(error: e);
      Get.snackbar(
        "snackBar3".tr,
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkQuantityAvailability(
      String storeProductId, int quantity) async {
    try {
      final response = await Network.getData(
        url: "${Urls.auth}/product/$storeProductId",
      );

      if (response.statusCode == 200 && response.data['successful']) {
        final remainingStock = response.data['data']['remaining_stock'] as int;
        return quantity <= remainingStock;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "snackBar3".tr,
        "snackBar4".tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void showEditQuantityDialog(BuildContext context,
      CardControllerControllerImp controller, int cartId) {
    final TextEditingController quantityController = TextEditingController();

    Get.defaultDialog(
      title: "Daialog".tr,
      content: Column(
        children: [
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Daialog1".tr,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: "OK",
      textCancel: "cansel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        final newQuantity = int.tryParse(quantityController.text);

        if (newQuantity == null || newQuantity <= 0) {
          Get.snackbar(
            "snackBar3".tr,
            "snackBar5".tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        await controller.UpDateQuantity(
          cartId: cartId,
          newQuantity: newQuantity,
        );
      },
    );
  }

  @override
  Future<void> UpDateQuantity({
    required int cartId,
    required int newQuantity,
  }) async {
    isLoading.value = true;

    try {
      final updateResponse = await Network.putData(
        url: "${Urls.auth}/cart/$cartId",
        data: {
          "quantity": newQuantity,
        },
      );

      if (updateResponse.statusCode == 200 &&
          updateResponse.data['successful']) {
        final updatedCartItem =
            updateResponse.data['data']['updated_cart_item'];

        int index = cartItems.indexWhere(
          (item) => item['id'] == cartId,
        );

        if (index != -1) {
          cartItems[index]['quantity'] = updatedCartItem['quantity'];
          cartItems[index]['total_price'] = updatedCartItem['total_price'];
        }

        updateTotalPrice();

        Get.snackbar(
          "snackBar2".tr,
          "snackBar6".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "snackBar3".tr,
          updateResponse.data['message'] ?? "فشل في تحديث الكمية",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "snackBar3".tr,
        "حدث خطأ أثناء تحديث الكمية: ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  DeletProduct(int cartId) async {
    isLoading.value = true;

    try {
      final response = await Network.deleteData(
        url: "${Urls.auth}/cart/$cartId",
      );

      if (response.statusCode == 200 && response.data['successful']) {
        cartItems.removeWhere((item) => item['id'] == cartId);

        updateTotalPrice();

        Get.snackbar(
          "snackBar2".tr,
          "snackBar7".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "snackBar3".tr,
          response.data['message'] ?? "Failed to remove item from cart",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "snackBar3".tr,
        "An error occurred",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['total_price'] ?? 0.0),
    );
  }

  Future<void> fetchCartItems() async {
    isLoading.value = true;
    var url = '${Urls.auth}/show/cart';

    try {
      final response = await Network.getData(url: url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['successful'] == true) {
          final productList = data['data'][0] as List;
          cartItems.value = productList.map((product) {
            return {
              'id': product['id'],
              'productName': product['product_name'],
              'productImage': product['product_image'],
              'quantity': product['quantity'],
              'total_price': (product['price'] is int)
                  ? (product['price'] as int).toDouble()
                  : product['price'],
            };
          }).toList();

          final total = data['data'][1]['total_price'];
          totalPrice.value = total;
        } else {
          Get.snackbar("snackBar3".tr, "snackBar8".tr);
        }
      } else {
        Get.snackbar("snackBar3".tr, "API Error: ${response.statusCode}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> Confirmorder() async {
    isLoading.value = true;
    update();

    try {
      final response = await Network.postData(
        url: "${Urls.auth}/order",
        data: {
          "cart_items": cartItems.map((item) {
            return {
              "store_product_id": item['store_product_id'],
              "quantity": item['quantity'],
            };
          }).toList(),
        },
      );

      if (response.statusCode == 200 && response.data['successful']) {
        Get.snackbar(
          "snackBar9".tr,
          response.data['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        cartItems.clear();
        totalPrice.value = 0.0;
        update();
      } else {
        Get.snackbar(
          "snackBar3".tr,
          response.data['message'] ?? "Failed to confirm order",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = exceptionsHandle(error: e);
      Get.snackbar(
        "snackBar3".tr,
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> fetchOldReceipts() async {
    try {
      isLoading.value = true;
      final response = await Network.getData(url: '${Urls.auth}/orders');
      print("Response Data: ${response.data}");
      if (response.statusCode == 200 && response.data['successful']) {
        final fetchedOrders = response.data['data']['orders'] as List;
        orders.value = fetchedOrders.map((order) {
          return {
            "id": order['id'],
            "total_price": order['total_price'].toString(),
            "cart_items": List<Map<String, dynamic>>.from(order['cart_items']),
          };
        }).toList();
      } else {
        Get.snackbar(
          "snackBar3".tr,
          response.data['message'] ?? "Failed to fetch orders.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
