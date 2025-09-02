import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/calculator_provider.dart';
import '../../utils/app_buttons.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_field.dart';

class AcresHectaresMu extends StatelessWidget {
  const AcresHectaresMu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c45413b,
        title: Text(
          "Acres = Hectares = Mu",
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
              "Input and convert values from Acres to Hectares and MU.",
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
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Acres
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("ACRES",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.c000000,
                            )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.acreController,
                          onChanged: (val) => cp.convertFromAcre(val),
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
                          Clipboard.setData(ClipboardData(text: cp.acreController.text));
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

                  // Hectares
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("HECTARES",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.c000000,
                            )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.hectareController,
                          onChanged: (val) => cp.convertFromHectare(val),
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
                          Clipboard.setData(ClipboardData(text: cp.hectareController.text));
                        },
                      ),
                    ],
                  ),

                  // Mu
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("MU",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.c000000,
                            )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField.textField(
                          context,
                          controller: cp.muController,
                          onChanged: (val) => cp.convertFromMu(val),
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
                          Clipboard.setData(ClipboardData(text: cp.muController.text));
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
                            "Calculation:\n1 acre = 0.404686 ha\n1 acre = 6.07 MU",
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
                              text: "1 acre = 0.404686 ha\n1 acre = 15.99 MU",
                            ));
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
                        onTap: () => cp.clearAcresHectaresMu(),
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
