import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

class EstimateHardRedWinter extends StatefulWidget {
  const EstimateHardRedWinter({super.key});

  @override
  State<EstimateHardRedWinter> createState() => _EstimateHardRedWinterState();
}

class _EstimateHardRedWinterState extends State<EstimateHardRedWinter> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          color: AppColors.c2a8741,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        AppStrings.quality,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      AppStrings.favoritePrice,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.star_border_outlined,
                      color: AppColors.cFFFFFF,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
