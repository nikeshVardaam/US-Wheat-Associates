import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/utils/app_buttons.dart';
import 'package:uswheat/utils/app_strings.dart';
import 'package:uswheat/utils/app_text_field.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_colors.dart';

class BushelsMetricTons extends StatelessWidget {
  const BushelsMetricTons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          AppStrings.bushelsMetricTons,
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
              AppStrings.inputAndConvertValues,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.cFFFFFF,
                  ),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(builder: (context, cp, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    AppStrings.bushels,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.c000000,
                        ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.bushelController,
                        onChanged: (val) => cp.convertBushelToMT(val),
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
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
                        Clipboard.setData(ClipboardData(text: cp.bushelController.text));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.equals,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.c656e79, fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    AppStrings.metricTons,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.c000000,
                        ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField.textField(
                        context,
                        controller: cp.metricTonController,
                        onChanged: (val) => cp.convertMTToBushel(val),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
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
                        Clipboard.setData(ClipboardData(text: cp.metricTonController.text));
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
                          child: Text(AppStrings.calculationBu,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.c000000,
                                  ))),
                      IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: AppColors.c656e79,
                          size: 18,
                        ),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: AppStrings.bu));
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
                          cp.clearFields();
                        },
                        child: AppButtons().outLineMiniButton(false, AppStrings.clear, context)),
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
