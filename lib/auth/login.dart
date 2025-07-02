import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset(
                      AppAssets.logo,
                      scale: 8,
                    )),
                    const SizedBox(height: 16),
                    Text(
                      "To sign up to receive our bi-weekly newsletter, Wheat Letter , weekly Price Report  and/or weekly Harvest Report fill in the following fields and hit submit..",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c666666),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.email,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                    ),
                    const SizedBox(height: 4),
                    AppTextField.textField(
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
                      AppStrings.company,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                    ),
                    const SizedBox(height: 4),
                    AppTextField.textField(
                      context,
                      keyboardType: TextInputType.emailAddress,
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
                      AppStrings.fullName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                    ),
                    const SizedBox(height: 4),
                    AppTextField.textField(
                      context,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                      cursorColor: AppColors.c000000,

                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.country,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646),
                    ),
                    const SizedBox(height: 4),
                    AppTextField.textField(
                      context,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                      cursorColor: AppColors.c000000,

                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.imInterested,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.c5B8EDC,
                          checkColor: AppColors.cFFFFFF,
                          value: true,
                          onChanged: (val) {},
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppStrings.harvestReports,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.c5B8EDC,
                          checkColor: AppColors.cFFFFFF,
                          value: true,
                          onChanged: (val) {},
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppStrings.price,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.c5B8EDC,
                          checkColor: AppColors.cFFFFFF,
                          value: true,
                          onChanged: (val) {},
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppStrings.wheatLetter,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.subscriberConsent,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c464646, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.c5B8EDC,
                          checkColor: AppColors.cFFFFFF,
                          value: true,
                          onChanged: (val) {},
                        ),
                        const SizedBox(width: 10),
                        Text(
                          AppStrings.iConsentToReceivingEmail,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                          activeColor: AppColors.c5B8EDC,
                          checkColor: AppColors.cFFFFFF,
                          value: true,
                          onChanged: (val) {},
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppStrings.iConsentToHavingMySubscriber,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.c464646),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 49),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.dashboard,
                          );
                        },
                        child: AppButtons().filledButton(true, AppStrings.subscribe, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
