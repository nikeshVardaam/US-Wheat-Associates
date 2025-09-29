import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class BuAcreMtHectare extends StatefulWidget {
  const BuAcreMtHectare({super.key});

  @override
  State<BuAcreMtHectare> createState() => _BuAcreMtHectareState();
}

class _BuAcreMtHectareState extends State<BuAcreMtHectare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Bushels/Acre  =  Metric Tons/Hectare",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
        ),
        leading: const BackButton(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Convert Bushels per Acre to Metric Tons per Hectare.",
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
                  // Bushels per Acre input
                  Text("BUSHELS PER ACRE (Bu/ac)", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.buAcreController,
                          onChanged: (val) => cp.convertBuAcreToMtHectare(val),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.buAcreController.text));
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

                  // Metric Tons per Hectare output
                  Text("METRIC TONS PER HECTARE (MT/ha)", style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.mtHectareController,
                          onChanged: (val) => cp.convertMtHectareToBuAcre(val),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: cp.mtHectareController.text));
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
                                "1 Bu/ac ≈ 0.06725 MT/ha\n"
                                "1 MT/ha ≈ 14.87 Bu/ac",
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.c000000),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppColors.c656e79, size: 18),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                              text: "1 Bu/ac = 0.06725 MT/ha\n1 MT/ha = 14.87 Bu/ac",
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
                          cp.clearBuAcreMtHectare();
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
