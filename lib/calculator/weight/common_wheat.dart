import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_field.dart';

class CommonWheat extends StatefulWidget {
  const CommonWheat({super.key});

  @override
  State<CommonWheat> createState() => _CommonWheatState();
}

class _CommonWheatState extends State<CommonWheat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Test Weight",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8.0),
            child: Text(
              "Convert wheat test weight between lb/bu and kg/hl",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.cFFFFFF),
            ),
          ),
        ),
      ),
      body: Consumer<CalculatorProvider>(builder: (context, cp, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("COMMON WHEAT", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.commonLbController,
                      label: "lb/bu",
                      onChanged: (val) => cp.convertCommonLbToKg(val),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.commonLbController.text));
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.commonKgController,
                      label: "kg/hl",
                      onChanged: (val) => cp.convertCommonKgToLb(val),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.commonKgController.text));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                        "Calculation:\n(lb/bu × 1.292) + 1.419 = kg/hl",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: "(lb/bu × 1.292) + 1.419 = kg/hl",
                        ));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Durum Wheat
              Text("DURUM WHEAT", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.durumLbController,
                      label: "lb/bu",
                      onChanged: (val) => cp.convertDurumLbToKg(val),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.durumLbController.text));
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField.textField(
                      context,
                      controller: cp.durumKgController,
                      label: "kg/hl",
                      onChanged: (val) => cp.convertDurumKgToLb(val),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: cp.durumKgController.text));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

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
                        "Calculation:\n(lb/bu × 1.292) + 0.630 = kg/hl",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: "(lb/bu × 1.292) + 0.630 = kg/hl",
                        ));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Clear button
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      cp.clearTestWeight();
                    },
                    child: AppButtons().outLineMiniButton(false, "Clear", context),
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
