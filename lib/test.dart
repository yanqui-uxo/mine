import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final row = TableRow(
        children: List.generate(
            5,
            (i) => SizedBox(
                width: 25, // arbitrary numbers
                height: 25,
                child: FittedBox(child: Text(i.toString())))));

    return Table(
        border: TableBorder.all(),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [row, row, row]);
  }
}
