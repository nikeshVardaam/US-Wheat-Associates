import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_strings.dart';

class YearSelector extends StatefulWidget {
  final List<int> yearList;

  const YearSelector({super.key, required this.yearList});

  @override
  State<YearSelector> createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  late int selectedIndex;
  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();

    final currentYear = DateTime.now().year;
    selectedIndex = widget.yearList.indexOf(currentYear);
    if (selectedIndex == -1) selectedIndex = 0;

    scrollController = FixedExtentScrollController(initialItem: selectedIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateToItem(
        selectedIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext perentContext) {
    final bgColor = CupertinoColors.systemGrey6.resolveFrom(perentContext);
    return Container(
      height: MediaQuery.of(perentContext).size.height / 5,
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
                  "${AppStrings.select} ${AppStrings.year}",
                  style: Theme.of(perentContext).textTheme.labelLarge,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(
                        perentContext, widget.yearList[selectedIndex]);
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
              scrollController: scrollController,
              onSelectedItemChanged: (index) {
                setState(() => selectedIndex = index);
              },
              children: List.generate(
                widget.yearList.length,
                    (index) => Text(
                  widget.yearList[index].toString(),
                  style: Theme.of(perentContext).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
