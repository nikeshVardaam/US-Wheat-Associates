import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/miscellaneous.dart';

class AppWidgets {
  static Widget initial(BuildContext context, String title, Color color,) {
    // return Consumer<BaseActivityProvider>(builder: (context, bap, child) {
       final initials = title.isNotEmpty ? Miscellaneous.getInitials(title) : Miscellaneous.getInitials( "");

      return CircleAvatar(
        maxRadius: 18,
        backgroundColor: color,
        child: Text(
          initials,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.cFFFFFF,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
  }
}