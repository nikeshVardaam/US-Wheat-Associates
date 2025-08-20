import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_colors.dart';

class MilesKilometer extends StatelessWidget {
  const MilesKilometer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Miles = Kilometers",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.cFFFFFF,
              ),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Input and convert values between Miles and Kilometers.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.cFFFFFF,
                  ),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(builder: (context, cp, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label for Miles
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "MILES (mi)",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.c000000,
                      ),
                ),
              ),

              // Miles Input
              Row(
                children: [
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.milesController,
                      onChanged: (val) => cp.convertFromMiles(val),
                      readOnly: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: AppColors.c656e79,
                      size: 18,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.milesController.text));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Equals Text
              Text(
                AppStrings.equals,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.c656e79,
                      fontStyle: FontStyle.italic,
                    ),
              ),

              // Label for Kilometers
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "KILOMETERS (km)",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.c000000,
                      ),
                ),
              ),

              // Kilometer Output
              Row(
                children: [
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.kilometerController,
                      onChanged: (val) => cp.convertFromKilometers(val),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      color: AppColors.c656e79,
                      size: 18,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.kilometerController.text));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Calculation Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cEFEEED.withOpacity(0.6),
                  border: Border.all(color: Colors.white38),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Calculation:\n1 Mile = 1.60934 Kilometers",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.c000000,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: AppColors.c656e79,
                        size: 18,
                      ),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(text: "1 Mile = 1.60934 Kilometers"));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Clear Button
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      cp.clearMilesKilometer();
                    },
                    child: AppButtons().outLineMiniButton(false, AppStrings.clear, context),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
