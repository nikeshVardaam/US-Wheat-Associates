import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_strings.dart';
import '../../modal/model_region.dart';

class ReportsSelector extends StatefulWidget {
  final List<dynamic> reportList;

  const ReportsSelector({super.key, required this.reportList});

  @override
  State<ReportsSelector> createState() => _ReportsSelectorState();
}

class _ReportsSelectorState extends State<ReportsSelector> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bgColor = CupertinoColors.systemGrey6.resolveFrom(context);
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppStrings.select} ${AppStrings.reports}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context, widget.reportList[selectedIndex]);
                  },
                  child: const Text(
                    AppStrings.done,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoPicker(
                backgroundColor: bgColor,
                itemExtent: 32,
                scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                onSelectedItemChanged: (index) {
                  setState(() => selectedIndex = index);
                },
                children: List.generate(
                  widget.reportList.length,
                  (index) {
                    var data = widget.reportList[index];

                    return Text(
                      data["report_type"][0]["name"],
                      style: Theme.of(context).textTheme.labelLarge,
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
