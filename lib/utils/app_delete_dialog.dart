import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uswheat/provider/dashboard_provider.dart';
import 'package:uswheat/utils/app_box_decoration.dart';
import 'package:uswheat/utils/app_colors.dart';
import 'package:uswheat/utils/app_text_field.dart';
import 'app_strings.dart';

class AppDeleteDialog extends StatefulWidget {
  const AppDeleteDialog({
    super.key,
  });

  @override
  State<AppDeleteDialog> createState() => _AppDeleteDialogState();
}

class _AppDeleteDialogState extends State<AppDeleteDialog> {
  @override
  Widget build(BuildContext perentContext) {
    return Consumer<DashboardProvider>(builder: (context, dp, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.accountDeletion,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  Text(
                    AppStrings.onceYouDeleteYourAccountThereIsNoWayBackMakeSureYouWantToDoThis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextField.textField(
                    context,
                    controller: dp.deleteController,
                    hintText: "Confirm by typing DELETE",
                    style: TextStyle(
                      color: AppColors.cDFDEDE,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: AppBoxDecoration.filledContainer(
                        AppColors.cDFDEDE,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          AppStrings.cancel,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      dp.confirmDelete(context: context);
                    },
                    child: Container(
                      decoration: AppBoxDecoration.filledContainer(
                        AppColors.cd63a3a,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          AppStrings.yesDeleteMyAccount,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.cFFFFFF,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
