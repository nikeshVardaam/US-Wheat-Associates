import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';
import '../../provider/calculator_provider.dart';
import '../../utils/app_colors.dart';

class MetersYardsFeet extends StatelessWidget {
  const MetersYardsFeet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Meters = Yards = Feet",
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
              "Input and convert values from Meters to Yards and Feet.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.cFFFFFF,
                  ),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, cp, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meters Input
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("METERS (m)", style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.meterController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) => cp.convertFromMeter(val),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: AppColors.c656e79,
                          size: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.meterController.text));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(AppStrings.equals,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.c656e79,
                            fontStyle: FontStyle.italic,
                          )),

                  // Yards Output
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("YARDS (yd)", style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.yardController,
                          onChanged: (val) => cp.convertFromYard(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: AppColors.c656e79,
                          size: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.yardController.text));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("FEET (ft)", style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.feetController,
                          onChanged: (val) => cp.convertFromFeet(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: AppColors.c656e79,
                          size: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.feetController.text));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                            "Calculation:\n1 m = 1.09361 yd\n1 m = 3.28084 ft",
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
                            Clipboard.setData(const ClipboardData(
                              text: "1 m = 1.09361 yd\n1 m = 3.28084 ft",
                            ));
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Clear button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          cp.clearMeterYardFeet();
                        },
                        child: AppButtons().outLineMiniButton(false, AppStrings.clear, context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
