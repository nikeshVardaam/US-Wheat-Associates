import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/sign_provider.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SignUpProvider>(builder: (context, sup, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Image.asset(
                        AppAssets.logo,
                        scale: 5,
                      )),
                      const SizedBox(height: 32),
                      Text(
                        AppStrings.createYourAccount,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.c45413b),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppStrings.name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                      ),
                      const SizedBox(height: 4),
                      AppTextField.textField(
                        controller: sup.nameController,
                        context,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                        cursorColor: AppColors.c000000,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.cFFFFFF,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.email,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                      ),
                      const SizedBox(height: 4),
                      AppTextField.textField(
                        controller: sup.emailController,
                        context,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                        cursorColor: AppColors.c000000,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.cFFFFFF,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.password,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                      ),
                      const SizedBox(height: 4),
                      AppTextField.textField(
                        controller: sup.passwordController,
                        context,
                        keyboardType: TextInputType.text,
                        obscureText: !sup.passwordIsVisible,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                        cursorColor: AppColors.c000000,
                        decoration: InputDecoration(
                          filled: true,
                          suffixIcon: sup.passwordIsVisible
                              ? GestureDetector(
                                  onTap: () {
                                    sup.setPasswordVisibility();
                                  },
                                  child: Icon(
                                    Icons.visibility_off,
                                    color: AppColors.c464646,
                                    size: 16,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    sup.setPasswordVisibility();
                                  },
                                  child: Icon(
                                    Icons.visibility,
                                    color: AppColors.c464646,
                                    size: 16,
                                  ),
                                ),
                          fillColor: AppColors.cFFFFFF,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.confirmPassword,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                      ),
                      const SizedBox(height: 4),
                      AppTextField.textField(
                        controller: sup.confirmPasswordController,
                        context,
                        keyboardType: TextInputType.text,
                        obscureText: !sup.confirmPasswordIsVisible,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                        cursorColor: AppColors.c000000,
                        decoration: InputDecoration(
                          filled: true,
                          suffixIcon: sup.confirmPasswordIsVisible
                              ? GestureDetector(
                                  onTap: () {
                                    sup.setConfirmPasswordVisibility();
                                  },
                                  child: Icon(
                                    Icons.visibility_off,
                                    color: AppColors.c464646,
                                    size: 16,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    sup.setConfirmPasswordVisibility();
                                  },
                                  child: Icon(
                                    Icons.visibility,
                                    color: AppColors.c464646,
                                    size: 16,
                                  ),
                                ),
                          fillColor: AppColors.cFFFFFF,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.cDFDEDE, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        sup.createAccount(context: context);
                      },
                      child: AppButtons().filledButton(true, AppStrings.signUp, context),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c666666),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: Text(
                          AppStrings.signIn,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c45413b, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
