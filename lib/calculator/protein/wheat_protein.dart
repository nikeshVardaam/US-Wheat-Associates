import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class WheatProtein extends StatefulWidget {
  const WheatProtein({super.key});

  @override
  State<WheatProtein> createState() => _WheatProteinState();
}

class _WheatProteinState extends State<WheatProtein> {
  @override
  Widget build(BuildContext perentContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Moisture Basis = Dry Basis",
          style: Theme.of(perentContext).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8.0),
            child: Text(
              "Convert protein level from a 12% moisture basis to dry basis and vice versa",
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
                  // MB input
                  Text("PROTEIN ON A 12% MOISTURE BASIS ", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.mbController,
                          onChanged: (val) => cp.convertMbToDb(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.mbController.text));
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
                  Text("PROTEIN ON A DRY MOISTURE BASIS (%)", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.dbController,
                          onChanged: (val) => cp.convertDbToMb(val),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.dbController.text));
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
                            "DB = MB ÷ 0.88\n"
                            "MB = DB × 0.88",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                              text: "DB = MB ÷ 0.88\nMB = DB × 0.88",
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
                          cp.clearProtein();
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



