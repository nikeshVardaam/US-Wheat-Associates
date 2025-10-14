import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedDatePickerPopup extends StatefulWidget {
  const AnimatedDatePickerPopup({super.key});

  @override
  State<AnimatedDatePickerPopup> createState() => _AnimatedDatePickerPopupState();
}

class _AnimatedDatePickerPopupState extends State<AnimatedDatePickerPopup> {
  DateTime _selectedDate = DateTime(2000, 1, 1);

  void _showCupertinoDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child:  const Text("Cancel",style: TextStyle(fontSize: 16, color: Colors.grey),),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text("Confirm",style: TextStyle(fontSize: 16, color: Colors.grey),),
                  onPressed: () => Navigator.pop(context, _selectedDate),
                ),
              ],
            )
          ],
        ),
      ),
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate is DateTime) {
        setState(() => _selectedDate = pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext perentContext) {
    return Center(
      child: GestureDetector(
        onTap: _showCupertinoDatePicker,
        child: Text(
          "${_selectedDate.toLocal()}".split(' ')[0],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
