import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

class Prices extends StatefulWidget {
  const Prices({super.key});

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.c95795d,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        AppStrings.price,
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
        Row(
          children: [
            Container(
              color: AppColors.c95795d.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.region,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500, color: AppColors.c95795d),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.c95795d,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.gulfOfMexico,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600,color: AppColors.c353d4a.withOpacity(0.7)  ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
