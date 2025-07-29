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
  static Widget loading() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.cFFFFFF,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.c464646,
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CupertinoActivityIndicator(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static appSnackBar({required BuildContext context, required String text, required Color color}) {


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF, fontWeight: FontWeight.w500),
      ),
      backgroundColor: color,
    ));
  }
  static topSnackBar({required BuildContext context, required String message, required Color color}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.cFFFFFF),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

}