import 'package:flutter/material.dart';

class WidgetNumberView extends StatelessWidget {
  final Widget widget;
  final int number;

  const WidgetNumberView(this.widget, this.number, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == 1) {
      return widget;
    } else {
      return SizedBox(
          width: 4,
          height: 4,
          child: Stack(fit: StackFit.passthrough, children: [
            FittedBox(child: widget),
            Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                    width: 1,
                    height: 1,
                    child: FittedBox(child: Text(number.toString()))))
          ]));
    }
  }
}
