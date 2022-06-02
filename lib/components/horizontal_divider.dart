import 'package:flutter/material.dart';
import 'package:billboardoo/data/constant.dart';

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      width: pageWidth,
      color: Colors.grey,
    );
  }
}
