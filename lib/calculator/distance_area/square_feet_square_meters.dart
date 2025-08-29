import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_colors.dart';



class SquareFeetToSquareMeter extends StatelessWidget {
  const SquareFeetToSquareMeter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Square Feet = Square Meters",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.cFFFFFF,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0,left: 16),
            child: Text(
              "Input and convert values between Square Feet and Square Meters.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.cFFFFFF,
              ),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(builder: (context, cp, child) {
        return SingleChildScrollView(
         physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Square Feet Label
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "SQUARE FEET (ft²)",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.c000000,
                    ),
                  ),
                ),

                // Square Feet Input
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.sqFeetController,
                        onChanged: (val) => cp.convertFromSqFeet(val),

                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.sqFeetController.text));
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  AppStrings.equals,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.c656e79,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                // Square Meter Label
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "SQUARE METERS (m²)",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.c000000,
                    ),
                  ),
                ),

                // Square Meter Output
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.sqMeterController,
                        onChanged: (val) => cp.convertFromSqMeter(val),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.sqMeterController.text));
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
                          "Calculation:\n1 ft² = 0.092903 m²",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.c000000,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: "1 ft² = 0.092903 m²"));
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
                        cp.clearSqFeetSqMeter();
                      },
                      child: AppButtons().outLineMiniButton(false, AppStrings.clear, context),
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
