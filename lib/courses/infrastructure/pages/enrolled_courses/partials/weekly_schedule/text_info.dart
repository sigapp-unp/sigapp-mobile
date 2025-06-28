import 'package:flutter/material.dart';

class TextInfoWidget extends StatelessWidget {
  final Widget? leftText;
  final Widget? rightText;

  const TextInfoWidget({super.key, this.leftText, this.rightText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          leftText != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
      children: [
        if (leftText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: leftText!,
          ),
        if (rightText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: rightText!,
          ),
      ],
    );
  }
}
