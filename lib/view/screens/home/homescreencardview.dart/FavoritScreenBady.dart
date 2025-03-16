import 'package:delivery_app/controller/favoriteController.dart';
import 'package:delivery_app/core/Apis/Network.dart';
import 'package:delivery_app/core/Apis/Urls.dart';
import 'package:delivery_app/core/constant/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FavoritScreenBady extends StatelessWidget {
  final String productName;
  final String productImage;
  final int categoryId;
  final int storeId;
  final int productId;
  final String storeName;
  final int id;
  const FavoritScreenBady(
      {super.key,
      required this.productName,
      required this.productImage,
      required this.categoryId,
      required this.storeId,
      required this.productId,
      required this.storeName,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (categoryId != null && storeId != null && productId != null) {
          Network.getData(
            url: Urls.getDicikrebtionByProducts(
              categoryId,
              storeId,
              productId,
            ),
          );
          Get.toNamed(
            Approute.discribtion,
            arguments: {
              "categoryId": categoryId,
              "storeId": storeId,
              "productId": productId,
            },
          );
        }
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.grey[300],
              height: 200,
            ),
            Image.network(
              productImage,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 190,
              child: Container(
                width: 490,
                height: 54,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    productName,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 200,
              right: 2,
              child: IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'تأكيد الحذف',
                    middleText:
                        'هل أنت متأكد أنك تريد حذف هذا المنتج من المفضلة؟',
                    textCancel: 'إلغاء',
                    textConfirm: 'حذف',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      final FavoriteControllerImp favoriteController =
                          Get.find();
                      favoriteController.deleteFavorite(id);
                      Get.back();
                    },
                  );
                },
                icon: const Icon(Icons.heart_broken),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
