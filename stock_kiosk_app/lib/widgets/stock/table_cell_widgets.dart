//material imports
import 'package:flutter/material.dart';

Widget headerCell(String text, {int flex = 1, TextStyle? style}) {
  //returns a header cell widget for stock table
  return Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style:
            style ??
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget tableCell(
  //returns a standard table cell widget for stock table
  String text, {
  int flex = 1,
  TextAlign align = TextAlign.center,
  TextStyle? style,
}) {
  return Expanded(
    // expanded widget to fill available space (avoids overflow errors)
    flex: flex,
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow
          .ellipsis, // ellipsis for overflowed text (so that it doesn't wrap and break layout)
      softWrap: false,
      textAlign: align,
      style: style ?? const TextStyle(color: Colors.white),
    ),
  );
}
