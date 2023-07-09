// ignore_for_file: prefer_const_constructors

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/data/controllers/popular_product_controller.dart';
import 'package:food_delivery_app/data/controllers/recommended_product_controller.dart';
import 'package:food_delivery_app/models/products_models.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/app_column.dart';
import 'package:food_delivery_app/widgets/big_text.dart';
import 'package:food_delivery_app/widgets/icon_and_text_widget.dart';
import 'package:food_delivery_app/widgets/small_text.dart';
import 'package:get/get.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  var _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(
      () {
        setState(() {
          _currPageValue = pageController.page!;
        });
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<PopularProductController>(builder: (popularProduct) {
          return popularProduct.isLoaded
              ? Container(
                  height: Dimensions.pageView,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: popularProduct.popularProductList.isEmpty
                          ? 1
                          : popularProduct.popularProductList.length,
                      itemBuilder: (context, position) {
                        return _buildPageItem(position,
                            popularProduct.popularProductList[position]);
                      }),
                )
              : CircularProgressIndicator(
                  color: AppColors.mainColor,
                );
        }),
        GetBuilder<PopularProductController>(builder: (popularProduct) {
          return DotsIndicator(
            dotsCount: popularProduct.popularProductList.isEmpty
                ? 1
                : popularProduct.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        SizedBox(
          height: Dimensions.height30,
        ),
        Container(
            margin: EdgeInsets.only(left: Dimensions.width30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BigText(text: 'Recommended'),
                SizedBox(
                  width: Dimensions.width10,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 3),
                  child: BigText(
                    text: ".",
                    color: Colors.black26,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width10,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child: SmallText(text: "Food pairing"),
                )
              ],
            )),
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct) {
          return recommendedProduct.isLoaded
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recommendedProduct.recommendedProductList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            RouteHelper.getRecommendedFood(index, "home"));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                            bottom: Dimensions.height10),
                        child: Row(
                          children: [
                            Container(
                              height: Dimensions.listViewImgSize,
                              width: Dimensions.listViewImgSize,
                              decoration: BoxDecoration(
                                  color: Colors.white38,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.raduis20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        AppConstants.BASE_URL +
                                            AppConstants.UPLOAD_URL +
                                            recommendedProduct
                                                .recommendedProductList[index]
                                                .img!,
                                      ),
                                      fit: BoxFit.cover)),
                            ),
                            Expanded(
                              child: Container(
                                height: Dimensions.listViewTextContSize,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            Dimensions.raduis20),
                                        bottomRight: Radius.circular(
                                            Dimensions.raduis20)),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Dimensions.width10,
                                      right: Dimensions.width10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BigText(
                                          text: recommendedProduct
                                              .recommendedProductList[index]
                                              .name!),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      SmallText(
                                          text: recommendedProduct
                                              .recommendedProductList[index]
                                              .description!),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        children: [
                                          IconAndTextWidget(
                                              icon: Icons.circle_sharp,
                                              text: 'Normal',
                                              iconColor: AppColors.iconColor1),
                                          IconAndTextWidget(
                                              icon: Icons.location_on,
                                              text: '1.7km',
                                              iconColor: AppColors.mainColor),
                                          IconAndTextWidget(
                                              icon: Icons.access_time_rounded,
                                              text: '32min',
                                              iconColor: AppColors.iconColor2)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : CircularProgressIndicator(
                  color: AppColors.mainColor,
                );
        })
      ],
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 0);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getPopularFood(index, "home"));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.raduis30),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(AppConstants.BASE_URL +
                          AppConstants.UPLOAD_URL +
                          popularProduct.img!))),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.raduis20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5)),
                    BoxShadow(color: Colors.white, offset: Offset(-5, 0)),
                    BoxShadow(color: Colors.white, offset: Offset(5, 0))
                  ]),
              child: Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height15,
                      left: Dimensions.width15,
                      right: Dimensions.width15),
                  child: AppColumn(
                    text: popularProduct.name!,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
