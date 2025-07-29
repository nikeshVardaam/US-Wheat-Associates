import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_box_decoration.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_routes.dart';
import 'package:uswheat/utils/app_strings.dart';

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                AppStrings.distanceArea,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.milesKilometer,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MILES = KILOMETERS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.squareFeetToSquareMeter,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SQUARE FEET = SQUARE METERS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.metersYardsFeet,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "METERS = YARDS = FEET",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.acresHectaresMu,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ACRES = HECTARES = MU",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Weight",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.bushelsMetricTons,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BUSHELS = METRIC TONS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.shortMetricTonPage,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SHORT TONS = METRIC TONS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.longMetricTonPage,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BRITISH TONS (LONG TON)= METRIC TONS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.shortTonToPoundPage,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AMERICAN TONS (SHORT TON) = POUNDS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.metricTonToKgPoundPage,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "METRIC TONS = KILOGRAMS = POUNDS",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Temperature",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.temperatureConverterPage,
                );
              },
              child: Container(
                decoration: AppBoxDecoration.blueRounded(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "FEHRENHEIT = CELSIUS ",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
