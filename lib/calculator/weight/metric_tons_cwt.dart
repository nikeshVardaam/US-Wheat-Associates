import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class MetricTonsCwt extends StatefulWidget {
  const MetricTonsCwt({super.key});

  @override
  State<MetricTonsCwt> createState() => _MetricTonsCwtState();
}

class _MetricTonsCwtState extends State<MetricTonsCwt> {
  @override
  Widget build(BuildContext perentContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Metric Ton = Hundred Weight (CWT)",
          style: Theme.of(perentContext).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Convert Metric Tons to Hundred Weight (CWT) and vice versa.",
              style: Theme.of(perentContext).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
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
                  // Metric Ton input
                  Text("METRIC TONS", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.metricController, // ✅ correct one
                          onChanged: (val) => cp.convertMetricTonToCwt(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.metricController.text));
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

                  // CWT input
                  Text("HUNDREDWEIGHT (CWT)", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.cwtInputController,
                          onChanged: (val) => cp.convertCwtToMetricTon(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.cwtInputController.text));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Formula box
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
                                "1 metric ton = 22.046 CWT\n"
                                "1 CWT = 0.045359 metric ton",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                              text: "1 metric ton = 2204.62262 pounds\n1 CWT = 100 pounds\n1 metric ton = 22.046 CWT\n1 CWT = 0.045359 metric ton",
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
                          cp.clearMetricTonCwt();
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
