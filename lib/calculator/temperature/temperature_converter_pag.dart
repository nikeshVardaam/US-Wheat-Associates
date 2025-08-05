import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class TemperatureConverterPage extends StatelessWidget {
  const TemperatureConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text("Fahrenheit = Celsius", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF)),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Convert between °F and °C temperature units.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, cp, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fahrenheit to Celsius
                Text("FAHRENHEIT (°F)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.fahrenheitController,
                        onChanged: (val) => cp.convertFahrenheitToCelsius(val),
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
                        Clipboard.setData(ClipboardData(text: cp.fahrenheitController.text));
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
                const SizedBox(height: 8),
                Text("CELSIUS (°C)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.celsiusFromFahrenheitController,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: AppColors.c656e79,
                        size: 18,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.celsiusFromFahrenheitController.text));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Celsius to Fahrenheit

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
                          "Calculation:\n"
                          "°F to °C = (°F - 32) × 5/9\n"
                          "°C to °F = (°C × 9/5) + 32",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
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
                            text: "°F to °C = (°F - 32) × 5/9\n°C to °F = (°C × 9/5) + 32",
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        cp.clearTemperatureFields();
                      },
                      child: AppButtons().outLineMiniButton(false, AppStrings.clear, context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
