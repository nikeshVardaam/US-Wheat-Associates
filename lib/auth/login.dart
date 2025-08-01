import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/login_provider.dart';
import 'package:uswheat/utils/app_assets.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Consumer<LoginProvider>(builder: (context, lp, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Image.asset(
                          AppAssets.logo,
                          scale: 5,
                        )),
                        const SizedBox(height: 32),
                        Text(
                          AppStrings.logInToYourAccount,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.c45413b),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          AppStrings.email,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                        ),
                        const SizedBox(height: 4),
                        AppTextField.textField(
                          controller: lp.emailController,
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
                          controller: lp.passwordController,
                          context,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          cursorColor: AppColors.c000000,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: const Icon(Icons.password),
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

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () async {
                      lp.logIn(context: context);
                    },
                    child: AppButtons().filledButton(true, AppStrings.logIn, context),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAnAccount,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c666666),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.signUp,
                        );
                      },
                      child: Text(
                        AppStrings.signUp,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c45413b, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
