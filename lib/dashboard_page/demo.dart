// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uswheat/utils/app_box_decoration.dart';
// import 'package:uswheat/utils/app_text_field.dart';
//
// import '../provider/calculator_provider.dart';
// import '../utils/app_colors.dart';
//
// class Demo extends StatefulWidget {
//   const Demo({super.key});
//
//   @override
//   _DemoState createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<CalculatorProvider>(builder: (context, cp, child) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                         Container(
//                           decoration: AppBoxDecoration.greyBorder(context),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "Land Area Conversion",
//                                         style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.c353d4a),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.swap_vert, size: 24, color: Colors.blueAccent),
//                                       onPressed: cp.swapLand,
//                                     ),
//                                   ],
//                                 ),
//                                 cp.isAcresOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Acres",
//                                   controller: cp.acresController,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "Hectares",
//                                   controller: cp.hectaresController,
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isAcresOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Hectares",
//                                   controller: cp.hectaresController,
//                                   readOnly: true,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "Acres",
//                                   controller: cp.acresController,
//                                   readOnly: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           decoration: AppBoxDecoration.greyBorder(context),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "Yield Conversion",
//                                         style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.c353d4a),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.swap_vert, size: 24, color: Colors.blueAccent),
//                                       onPressed: cp.swapYield,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isBushelsOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Bushels/acre",
//                                   controller: cp.bushelsPerAcre,
//                                 )
//                                     : AppTextField.textField(context, label: "Tons/hectare", controller: cp.tonsPerHectare),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 cp.isBushelsOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Tons/hectare",
//                                   controller: cp.tonsPerHectare,
//                                   readOnly: true,
//                                 )
//                                     : AppTextField.textField(context, label: "Bushels/acre", controller: cp.bushelsPerAcre, readOnly: true),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           decoration: AppBoxDecoration.greyBorder(context),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "Wheat Protein",
//                                         style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.c353d4a),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.swap_vert, size: 24, color: Colors.blueAccent),
//                                       onPressed: cp.swapProtein,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isProteinMbOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "12% mb",
//                                   controller: cp.proteinMb,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "Dry Basis",
//                                   controller: cp.proteinDry,
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isProteinMbOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Dry Basis",
//                                   controller: cp.proteinDry,
//                                   readOnly: true,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "12% mb",
//                                   controller: cp.proteinMb,
//                                   readOnly: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           decoration: AppBoxDecoration.greyBorder(context),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         "Temperature",
//                                         style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppColors.c353d4a),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.swap_vert, size: 24, color: Colors.blueAccent),
//                                       onPressed: () {},
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isFahrenheitOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Fahrenheit",
//                                   controller: cp.fahrenheit,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "Celsius",
//                                   controller: cp.celsius,
//                                 ),
//                                 const SizedBox(height: 10),
//                                 cp.isFahrenheitOnTop
//                                     ? AppTextField.textField(
//                                   context,
//                                   label: "Celsius",
//                                   controller: cp.celsius,
//                                   readOnly: true,
//                                 )
//                                     : AppTextField.textField(
//                                   context,
//                                   label: "Fahrenheit",
//                                   controller: cp.fahrenheit,
//                                   readOnly: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
