import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_strings.dart';

class AppLogoutDialogs extends StatefulWidget {
  final Function() onTap;
  const AppLogoutDialogs({super.key, required this.onTap});

  @override
  State<AppLogoutDialogs> createState() => _AppLogoutDialogsState();
}
class _AppLogoutDialogsState extends State<AppLogoutDialogs> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        AppStrings.logout,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      content: Text(
        AppStrings.areYouSureYouWantToLogout,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppStrings.cancel,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        TextButton(
          onPressed: widget.onTap,
          child: Text(
            AppStrings.logout,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
