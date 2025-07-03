import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_strings.dart';

import '../utils/app_assets.dart';

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
              width: MediaQuery.of(context).size.width / 4,
              color: AppColors.c95795d.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.region,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
                          ),
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.c353d4a.withOpacity(0.7),
                    ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              color: AppColors.c95795d.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.classs,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
                          ),
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
                "HRS 14.0% (15.9% dry matter basis) Min",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.c353d4a.withOpacity(0.7),
                    ),
              ),
            ),
          ],
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              color: AppColors.c95795d.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
                          ),
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
                " APRIL - 2024",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.c353d4a.withOpacity(0.7),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 16,
                color: AppColors.c666666,
                width: 0.5,
              ),
            ),
            Icon(
              Icons.arrow_drop_up_outlined,
              color: AppColors.c709e58,
            ),
            Text(
              " 2.75 | \$280/MT",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.c709e58,
                  ),
            ),
          ],
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Expanded(
          child: Image.asset(
            AppAssets.chart,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          color: AppColors.c95795d.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.nearby,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c95795d,
                      ),
                ),
                Text(
                  "FOB \$/BU 7.00",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c95795d,
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Container(
          color: AppColors.c95795d.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        AppStrings.weekChange,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.c95795d,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$/BU -0.04",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.cd4582d,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 16,
                    color: AppColors.c666666,
                    width: 0.5,
                  ),
                ),
                Text(
                  "\$/MT -2",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.cd4582d,
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Container(
          color: AppColors.c95795d.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        AppStrings.oneYearAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.c95795d,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$/MT 282",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c353d4a.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Container(
          color: AppColors.c95795d.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        AppStrings.lastPrDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.c95795d,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "APRIL 11, /2025",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c353d4a.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: AppColors.cB6B6B6,
        ),
        Container(
          color: AppColors.c95795d.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.fwdPrice,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.c95795d,
                          ),
                    ),
                  ],
                ),
                Text(
                  "MAY: \$280/MT",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c353d4a.withOpacity(0.7),
                      ),
                ),
                Text(
                  "JUNE: \$280/MT",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c353d4a.withOpacity(0.7),
                      ),
                ),
                Text(
                  "JULY: \$280/MT",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.c353d4a.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
