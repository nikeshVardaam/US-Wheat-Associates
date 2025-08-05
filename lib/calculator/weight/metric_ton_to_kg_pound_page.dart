import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class MetricTonToKgPoundPage extends StatefulWidget {
  const MetricTonToKgPoundPage({super.key});

  @override
  State<MetricTonToKgPoundPage> createState() => _MetricTonToKgPoundPageState();
}

class _MetricTonToKgPoundPageState extends State<MetricTonToKgPoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Metric Ton = Kg = Pounds",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Convert Metric Tons to Kilograms and Pounds.",
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
                Text("METRIC TONS", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.metricTonInputController,
                        onChanged: (val) => cp.convertMetricTonToKgAndPound(val),keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.metricTonInputController.text));
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
                Text("KILOGRAMS (kg)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.kgOutputController,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.kgOutputController.text));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("POUNDS (lbs)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.poundOutputController,
                        readOnly: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cp.poundOutputController.text));
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
                          "Calculation:\n"
                          "1 metric ton = 1000 kilograms\n"
                          "1 kilogram = 2.20462262 pounds\n"
                          "→ 1 metric ton = 2204.62262 pounds",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(
                            text: "1 metric ton = 1000 kilograms\n1 kilogram = 2.20462262 pounds\n1 metric ton = 2204.62262 pounds",
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
                        cp.clearMetricTonKgPound();
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
