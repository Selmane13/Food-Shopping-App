import 'package:food_delivery_app/pages/account/account_page.dart';
import 'package:food_delivery_app/pages/account/location_page.dart';
import 'package:food_delivery_app/pages/auth/sign_in_page.dart';
import 'package:food_delivery_app/pages/auth/sign_up_page.dart';
import 'package:food_delivery_app/pages/cart/cart_page.dart';
import 'package:food_delivery_app/pages/food/popular_food_detail.dart';
import 'package:food_delivery_app/pages/food/recommended_food_detail.dart';
import 'package:food_delivery_app/pages/home/home_page.dart';
import 'package:food_delivery_app/pages/splash/splash_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String splashPage = "/splash_page";
  static const String initial = "/";
  static const String popularFood = "/popular_food";
  static const String recommendedFood = "/recommended_food";
  static const String cartPage = "/cart_page";
  static const String signInPage = "/sign_in_page";
  static const String signUpPage = "/sign_up_page";
  static const String accountPage = "/account_page";
  static const String locationPage = "/location_page";

  static String getSplashPage() => "$splashPage";

  static String getSignInPage() => "$signInPage";

  static String getSignUpPage() => "$signUpPage";

  static String getInitial() => "$initial";

  static String getPopularFood(int pageId, String page) =>
      "$popularFood?pageId=$pageId&page=$page";

  static String getRecommendedFood(int pageId, String page) =>
      "$recommendedFood?pageId=$pageId&page=$page";

  static String getCartPage() => "$cartPage";
  static String getAccountPage() => "$accountPage";
  static String getLocationPage() => "$locationPage";

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: splashPage, page: () => SplashScreen()),
    GetPage(
        name: popularFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return PopularFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: recommendedFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters['page'];
          return RecommendedFoodPage(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: cartPage,
        page: () => const CartPage(),
        transition: Transition.fadeIn),
    GetPage(
        name: signInPage,
        page: () {
          return const SignInPage();
        },
        transition: Transition.fade),
    GetPage(
        name: signUpPage,
        page: () {
          return const SignUpPage();
        },
        transition: Transition.fade),
    GetPage(
        name: accountPage,
        page: () {
          return const AccountPage();
        },
        transition: Transition.fadeIn),
    GetPage(
        name: locationPage,
        page: () {
          return const LocationPage();
        },
        transition: Transition.fadeIn)
  ];
}
