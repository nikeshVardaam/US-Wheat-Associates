import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class LongMetricTonPage extends StatelessWidget {
  const LongMetricTonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "British Tons = Metric Tons",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Convert British (Long) Tons to Metric Tons (Tonnes).",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(
        builder: (context, cp, child) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BRITISH TONS (LONG)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.longTonController,
                          onChanged: (val) => cp.convertLongToMetricTon(val),keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.longTonController.text));
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
                  Text("METRIC TONS (TONNES)", style: Theme.of(context).textTheme.bodySmall),const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.longToMetricController,
                          readOnly: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.longToMetricController.text));
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
                            "Calculation:\n1 long ton = 1.01604691 metric tons",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppColors.c656e79,size: 18,),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                              text: "1 long ton = 1.01604691 metric tons\n1 metric ton = 0.98420653 long tons",
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
                        onTap: () => cp.clearLongMetricTons(),
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
