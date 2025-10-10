import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/app_strings.dart';

class CategorySelector extends StatefulWidget {
  final List<dynamic> categoryList;

  const CategorySelector({super.key, required this.categoryList});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
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
                  "${AppStrings.select} ${AppStrings.category}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context, widget.categoryList[selectedIndex]);
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
                scrollController:
                    FixedExtentScrollController(initialItem: selectedIndex),
                onSelectedItemChanged: (index) {
                  setState(() => selectedIndex = index);
                },
                children: List.generate(
                  widget.categoryList.length,
                  (index) {
                    var data = widget.categoryList[index];

                    return Text(
                      data["name"] ?? [],
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
