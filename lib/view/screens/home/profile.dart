// ignore_for_file: deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:delivery_app/controller/profilController.dart';
import 'package:delivery_app/core/localization/changedlocal.dart';
import 'package:delivery_app/view/wedgets/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ProfilContollerImp contollerImp = Get.put(ProfilContollerImp());
    contollerImp.ProfilePhotoAndHistory();
    LocalController localController =Get.put(LocalController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          'iconNavBar2'.tr,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.grey[800],
              ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: [
            
            Obx(() {
              return Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/image-1.jpg'),
                    foregroundImage:
                        contollerImp.userProfileImage.value.isNotEmpty
                            ? NetworkImage(contollerImp.userProfileImage.value)
                            : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.orange),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        File newImage = File(pickedFile.path);
                        await contollerImp.UpdateProfile(
                          name: contollerImp.fullName.value,
                          image: newImage,
                          userId: contollerImp.userId.value,
                        );
                        await contollerImp.ProfilePhotoAndHistory();
                      }
                    },
                  ),
                ],
              );
            }),
            SizedBox(height: 30),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    contollerImp.fullName.value.isNotEmpty
                        ? contollerImp.fullName.value
                        : 'Name',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      TextEditingController nameController =
                          TextEditingController(
                              text: contollerImp.fullName.value);
                      Get.defaultDialog(
                        title: "Change Name",
                        content: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "New Name",
                          ),
                        ),
                        textConfirm: "Update",
                        textCancel: "Cancel",
                        onConfirm: () async {
                          Get.back();
                          await contollerImp.UpdateProfile(
                            name: nameController.text,
                            userId: contollerImp.userId.value,
                          );
                          await contollerImp.ProfilePhotoAndHistory();
                        },
                      );
                    },
                  ),
                ],
              );
            }),
            SizedBox(height: 20),

            
            Obx(() {
              return Text(
                contollerImp.accountCreationDate.value.isNotEmpty
                    ? 'Account created on: ${contollerImp.accountCreationDate.value}'
                    : 'History of creating account',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    child: LogInButton(
                      () {
                        Get.defaultDialog(
                          title: "Confirm Logout",
                          middleText: "Are you sure you want to logout?",
                          textCancel: "Cancel",
                          textConfirm: "OK",
                          confirmTextColor: Colors.blue,
                          onConfirm: () {
                            Get.back();
                            contollerImp.LogOut();
                          },
                          onCancel: () {
                            Get.back();
                          },
                        );
                      },
                      title: "profil1".tr,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 150,
                    height: 100,
                    child: LogInButton(
                      () {
                        Get.defaultDialog(
                          title: "اختر اللغة", 
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  localController.changeLang('ar');
                                  Get.back();
                                },
                                child: Text(
                                  "عربي",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  localController.changeLang('en');
                                  Get.back();
                                },
                                child: Text(
                                  "English",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      title: "profil2".tr,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    child: LogInButton(
                      () {
                        contollerImp.OldFatorasFunction();
                      },
                      title: "profil4".tr,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 150,
                    height: 100,
                    child: LogInButton(
                      () {
                        contollerImp.GoToFavoriteScreen();
                      },
                      title: "profil3".tr,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
