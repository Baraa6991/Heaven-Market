// ignore_for_file: file_names

import 'package:delivery_app/controller/cardController.dart';
import 'package:delivery_app/controller/discribtionController.dart';
import 'package:delivery_app/controller/favoriteController.dart';
import 'package:delivery_app/core/constant/image.dart';
import 'package:delivery_app/view/wedgets/floatingActionButtonPositioned.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// class Discribtion extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // استدعاء البيانات المرسلة كـ arguments
//     final arguments = Get.arguments;
//     final String storeName = arguments?['storeName'] ?? 'Default Store';
//     final String productName = arguments?['productName'] ?? 'Default Product';
//     final String productImage = arguments?['productImage'] ?? 'assets/logo.jpg';
//     final int productId = arguments?['productId'] ?? 0;
//     final int categoryId = arguments?['categoryId'] ?? 1;
//     final int storeId = arguments?['storeId'] ?? 3;

//     // إنشاء المتحكمات
//     final DiscribtionControllerImp controllerImp =
//         Get.put(DiscribtionControllerImp());
//     final FavoriteControllerImp favoriteController =
//         Get.put(FavoriteControllerImp());

//     // تحميل تفاصيل المنتج
//     controllerImp.fetchProductDetails(categoryId, storeId, productId).then((_) {
//       favoriteController.isFavorite.value =
//           favoriteController.favorites.any((item) => item['id'] == productId);
//     });

//     // صندوق إدخال الكمية
//     TextEditingController quantityController = TextEditingController();

//     return Scaffold(
//       floatingActionButton: Stack(
//         children: [
//           // زر الإضافة إلى المفضلة
//           Obx(() {
//             return FloatingActionButtonPositioned(
//               bottom: 16,
//               right: 16,
//               color: Colors.orange,
//               iconData: favoriteController.isFavorite.value
//                   ? Icons.star
//                   : Icons.star_border,
//               onPressed: () async {
//                 if (favoriteController.isFavorite.value) {
//                   await favoriteController.deleteFavorite(productId);
//                 } else {
//                   await favoriteController.AddToFavorite(
//                     storeId: storeId,
//                     productId: productId,
//                   );
//                 }
//               },
//             );
//           }),
//           // زر الإضافة إلى السلة
//           FloatingActionButtonPositioned(
//             bottom: 16,
//             right: 90,
//             color: Colors.blue,
//             iconData: Icons.shopping_basket_outlined,
//             onPressed: () {
//               final quantity = int.tryParse(quantityController.text) ?? 1;

//               final cardController = Get.put(CardControllerControllerImp());
//               final availableQuantity = controllerImp.availableQuantity.value;

//               cardController.AddToCard(
//                 quantity: quantity,
//                 storeId: storeId,
//                 productId: productId,
//                 productName: productName,
//                 productImage: productImage,
//                 productPrice:
//                     double.tryParse(controllerImp.productPrice.value) ?? 0.0,
//                 availableQuantity: availableQuantity,
//               );
//             },
//           ),
//         ],
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: Text(
//             storeName,
//             style: Theme.of(context).textTheme.displayLarge!.copyWith(
//                   color: Colors.grey[800],
//                 ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // صورة المنتج
//             Image.network(
//               productImage,
//               height: 300,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 20),
//             // اسم المنتج
//             Text(
//               productName,
//               style: Theme.of(context).textTheme.displayLarge,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             // وصف المنتج
//             Text(
//               "Description".tr,
//               style: const TextStyle(fontSize: 40, color: Colors.orange),
//             ),
//             const SizedBox(height: 20),
//             Obx(() {
//               if (controllerImp.isLoading.value) {
//                 return Center(
//                   child: Lottie.asset(
//                     ImageAssets.loading,
//                     width: 250,
//                     height: 250,
//                   ),
//                 );
//               }
//               if (controllerImp.errorMessage.isNotEmpty) {
//                 return Text(controllerImp.errorMessage.value);
//               }
//               return Column(
//                 children: [
//                   Text(
//                     controllerImp.productDescription.value,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 30, color: Colors.black),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Price: \$${controllerImp.productPrice.value}",
//                     style: const TextStyle(fontSize: 30, color: Colors.green),
//                   ),
//                 ],
//               );
//             }),
//             const SizedBox(height: 40),
//             // إدخال الكمية
//             Padding(
//               padding: const EdgeInsets.only(right: 200, left: 10),
//               child: TextField(
//                 controller: quantityController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   helperStyle: const TextStyle(fontSize: 9),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 5,
//                     horizontal: 40,
//                   ),
//                   labelText: "Quantity",
//                   suffixStyle: Theme.of(context).textTheme.bodyLarge,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class Discribtion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final int productId = arguments?['productId'] ?? 0;
    final int categoryId = arguments?['categoryId'] ?? 1;
    final int storeId = arguments?['storeId'] ?? 3;

    final DiscribtionControllerImp controllerImp = Get.put(DiscribtionControllerImp());
    final FavoriteControllerImp favoriteController = Get.put(FavoriteControllerImp());

    // تحميل تفاصيل المنتج
    controllerImp.fetchProductDetails(categoryId, storeId, productId);

    TextEditingController quantityController = TextEditingController();

    return Scaffold(
      floatingActionButton: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // زر الإضافة إلى المفضلة
            FloatingActionButtonPositioned(
              bottom: 16,
              right: 16,
              color: Colors.orange,
              iconData: controllerImp.isFavorite.value ? Icons.star : Icons.star_border,
              onPressed: () async {
                if (controllerImp.isFavorite.value) {
                  await favoriteController.deleteFavorite(productId);
                } else {
                  await favoriteController.AddToFavorite(
                    storeId: storeId,
                    productId: productId,
                  );
                }
              },
            ),
           const SizedBox(width: 10,),
            // زر الإضافة إلى السلة
            FloatingActionButtonPositioned(
              bottom: 16,
              right: 90,
              color: Colors.blue,
              iconData: Icons.shopping_basket_outlined,
              onPressed: () {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final cardController = Get.put(CardControllerControllerImp());

                cardController.AddToCard(
                  quantity: quantity,
                  storeId: storeId,
                  productId: productId,
                  productName: controllerImp.productName.value,
                  productImage: controllerImp.productImage.value,
                  productPrice: double.tryParse(controllerImp.productPrice.value) ?? 0.0,
                  availableQuantity: controllerImp.availableQuantity.value,
                );
              },
            ),
          ],
        );
      }),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Obx(() => Text(
              controllerImp.storeName.value,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.grey[800]),
            )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controllerImp.isLoading.value) {
          return Center(
            child: Lottie.asset(
              ImageAssets.loading,
              width: 250,
              height: 250,
            ),
          );
        }
        if (controllerImp.errorMessage.isNotEmpty) {
          return Center(child: Text(controllerImp.errorMessage.value));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // صورة المنتج
              Image.network(
                controllerImp.productImage.value,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              // اسم المنتج
              Text(
                controllerImp.productName.value,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // وصف المنتج
              Text(
                "Description".tr,
                style: const TextStyle(fontSize: 40, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              Text(
                controllerImp.productDescription.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30, color: Colors.black),
              ),
              const SizedBox(height: 20),
              // السعر
              Text(
                "Price: \$${controllerImp.productPrice.value}",
                style: const TextStyle(fontSize: 30, color: Colors.green),
              ),
              const SizedBox(height: 40),
              // إدخال الكمية
               Padding(
              padding: const EdgeInsets.only(right: 200, left: 10),
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperStyle: const TextStyle(fontSize: 9),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 40,
                  ),
                  labelText: "Quantity",
                  suffixStyle: Theme.of(context).textTheme.bodyLarge,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            ],
          ),
        );
      }),
    );
  }
}
