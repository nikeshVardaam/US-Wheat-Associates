import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/change_password_provider.dart';
import '../utils/app_buttons.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_field.dart';

class ChangePassword extends StatefulWidget {
  final Function() onTap;

  const ChangePassword({super.key, required this.onTap});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext perentContext) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ChangePasswordProvider>(builder: (context, cp, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.createNewPassword,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.c45413b),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.newPasswordHint,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c45413b),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.password,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                        ),
                        const SizedBox(height: 4),
                        AppTextField.textField(
                          controller: cp.passwordController,
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
                          AppStrings.newPassword,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                        ),
                        const SizedBox(height: 4),
                        AppTextField.textField(
                          controller: cp.newPasswordController,
                          context,
                          keyboardType: TextInputType.text,
                          obscureText: !cp.newPasswordVisible,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          cursorColor: AppColors.c000000,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: cp.newPasswordVisible
                                ? GestureDetector(
                                    onTap: () {
                                      cp.setNewPasswordVisibility();
                                    },
                                    child: Icon(
                                      Icons.visibility_off,
                                      color: AppColors.c464646,
                                      size: 16,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      cp.setNewPasswordVisibility();
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
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppStrings.confirmPassword,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                        ),
                        const SizedBox(height: 4),
                        const SizedBox(height: 4),
                        AppTextField.textField(
                          controller: cp.confirmPasswordController,
                          context,
                          keyboardType: TextInputType.text,
                          obscureText: !cp.confirmPasswordVisible,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          cursorColor: AppColors.c000000,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: cp.confirmPasswordVisible
                                ? GestureDetector(
                                    onTap: () {
                                      cp.setNewPasswordVisibility();
                                    },
                                    child: Icon(
                                      Icons.visibility_off,
                                      color: AppColors.c464646,
                                      size: 16,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      cp.setConfirmPasswordVisibility();
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
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       AppStrings.bothPasswordsMustMatch,
                  //       style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.c45413b),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 36,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: InkWell(
                      onTap: () async {
                        cp.changePassword(context: context);
                      },
                      child: AppButtons().filledButton(true, AppStrings.resetPassword, context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
