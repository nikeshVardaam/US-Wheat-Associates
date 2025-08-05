import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppBoxDecoration {
  static BoxDecoration greyBorder(BuildContext context) {
    return BoxDecoration(
      color: AppColors.cFFFFFF,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: AppColors.cDFDEDE,
        width: 1,
      ),
    );
  }

  static BoxDecoration blueRounded() {
    return BoxDecoration(
      color: AppColors.cab865a,
      borderRadius: BorderRadius.circular(4),
    );
  }

  static BoxDecoration lightContainer() {
    return BoxDecoration(
      color: AppColors.cAB865A.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
