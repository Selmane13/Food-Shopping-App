import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/base/custom_loader.dart';
import 'package:food_delivery_app/pages/auth/sign_up_page.dart';
import 'package:food_delivery_app/routes/route_helper.dart';
import 'package:get/get.dart';

import '../../base/show_custom_snackbar.dart';
import '../../data/controllers/auth_controller.dart';
import '../../utils/app_text_field.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    void _login(AuthController authController) {
      String password = passwordController.text.trim();
      String email = emailController.text.trim();

      if (email.isEmpty) {
        showCustomSnackBar("Type in your email address",
            title: "Email address");
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in a valid email address",
            title: "Valid email address");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 6) {
        showCustomSnackBar("Password can not be less than six chacarcters",
            title: "Password");
      } else {
        authController.login(email, password).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar("You don't have an existing account");
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (_authController) {
          return _authController.isLoading
              ? const CustomLoader()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      Container(
                        height: Dimensions.screenHeight * 0.25,
                        child: const Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                AssetImage("assets/images/logo.jpg"),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Dimensions.width20),
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                  fontSize: Dimensions.font20 * 3 +
                                      Dimensions.font20 / 2,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Sign into your account",
                              style: TextStyle(
                                  fontSize: Dimensions.font20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                          textController: emailController,
                          hintText: "Email",
                          icon: Icons.email),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      AppTextField(
                        textController: passwordController,
                        hintText: "Password",
                        icon: Icons.password_sharp,
                        isObscure: true,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _login(_authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 2,
                          height: Dimensions.screenHeight / 13,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.raduis30),
                              color: AppColors.mainColor),
                          child: Center(
                            child: BigText(
                              text: "Sign in",
                              size: Dimensions.font20 + Dimensions.font20 / 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Don't have an account ?",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.font20),
                              children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => SignUpPage(),
                                    transition: Transition.fade),
                              text: " Create",
                              style: TextStyle(
                                  color: AppColors.mainBlackColor,
                                  fontSize: Dimensions.font20),
                            )
                          ])),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
