import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_colors.dart';

class AppButtons {
  Widget filledButton(bool isEnable, String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isEnable ? AppColors.c45413b : AppColors.cDFDEDE.withOpacity(0.4),
        //border: Border.all(color: isEnable ? AppColors().blue : AppColors().greyExtraLight.withOpacity(0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 9),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isEnable ? AppColors.cFFFFFF : AppColors.cB6B6B6,
                ),
          ),
        ),
      ),
    );
  }

  Widget outLineMiniButton(bool isEnable, String text, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isEnable ? AppColors.c0A64A4 : AppColors.caebbc8, width: 1),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isEnable ? AppColors.c0A64A4 : AppColors.c000000,
                ),
          ),
        ),
      ),
    );
  }
}
