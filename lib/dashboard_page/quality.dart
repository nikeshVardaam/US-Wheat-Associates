import 'package:flutter/cupertino.dart';

class Quality extends StatefulWidget {
  const Quality({super.key});

  @override
  State<Quality> createState() => _QualityState();
}

class _QualityState extends State<Quality> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Qualitys")
      ],
    );
  }
}
