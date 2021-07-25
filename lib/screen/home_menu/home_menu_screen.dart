import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:practical_assignment/common/app_theme.dart';
import 'package:practical_assignment/screen/home_menu/home_controller.dart';

class HomeMenuScreen extends StatelessWidget {

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.getProducts();
    return Scaffold(
      body: Obx(() {
        return Container(
          child: homeController.listOfProduct.length >0 ?  ListView.builder(
              itemCount: homeController.listOfProduct.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/images/fruits.png", height: 100.0, width: 100.0,),
                        Text(homeController.listOfProduct[index].productName, style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.blackColor
                        ),),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                homeController.doLike(homeController.listOfProduct[index].productId);
                                if(homeController.listOfProduct[index].isLiked) {
                                  homeController.listOfProduct[index].isLiked = false;
                                  homeController.listOfProduct.refresh();
                                } else {
                                  homeController.listOfProduct[index].isLiked = true;
                                  homeController.listOfProduct.refresh();
                                }
                              },
                              child: Icon(homeController.listOfProduct[index].isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                                size: 25.0, color: AppTheme.redColor
                                ,),
                            ),
                            SizedBox(height: 40.0,),
                            InkWell(
                              onTap: () {
                                homeController.doCart(homeController.listOfProduct[index].productId);
                                if(homeController.listOfProduct[index].isCart) {
                                  homeController.listOfProduct[index].isCart = false;
                                  homeController.listOfProduct.refresh();
                                } else {
                                  homeController.listOfProduct[index].isCart = true;
                                  homeController.listOfProduct.refresh();
                                }

                              },
                              child: Card(
                                child: Container(
                                  color: homeController.listOfProduct[index].isCart ? AppTheme.redColor : AppTheme.GreenColor,
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(homeController.listOfProduct[index].isCart ? "Remove from Cart" : "Add To Cart", style: TextStyle(
                                      color: AppTheme.whiteColor
                                  ),),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }) : Center(child: CircularProgressIndicator()),
        );
      })
    );
  }


}
