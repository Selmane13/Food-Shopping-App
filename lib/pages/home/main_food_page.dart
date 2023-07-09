import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/controllers/map_controller.dart';
import 'package:food_delivery_app/pages/home/food_page_body.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../data/controllers/popular_product_controller.dart';
import '../../data/controllers/recommended_product_controller.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> _loadRessources() async {
      await Get.find<PopularProductController>().getPopularProductList();
      await Get.find<RecommendedProductController>()
          .getRecommendedProductList();
    }

    return RefreshIndicator(
        onRefresh: _loadRessources,
        child: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height45, bottom: Dimensions.height15),
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          BigText(
                            text: Get.find<AddressController>().myCountry,
                            color: AppColors.mainColor,
                          ),
                          Row(
                            children: [
                              SmallText(
                                text:  Get.find<AddressController>().myCity,
                                color: Colors.black54,
                              ),
                              const Icon(Icons.location_on,size: 20,)
                            ],
                          )
                        ],
                      ),
                      Center(
                        child: Container(
                          width: Dimensions.width45,
                          height: Dimensions.height45,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF89dad0)),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: Dimensions.iconSize24,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            const Expanded(
                child: SingleChildScrollView(
              child: FoodPageBody(),
            )),
          ],
        ));
  }
}
