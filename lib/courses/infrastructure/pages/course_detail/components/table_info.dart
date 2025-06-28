import 'package:flutter/material.dart';

class TableInfoWidget extends StatelessWidget {
  const TableInfoWidget(this.info, {super.key});

  final List<List<String>> info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          info
              .map(
                (e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(e[0]), Text(e[1])],
                ),
              )
              .toList(),
    );
  }
}
