//material imports
import 'package:flutter/material.dart';

Widget headerCell(String text, {int flex = 1}) {
  //returns a header cell widget for stock table
  return Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget tableCell(
  //returns a standard table cell widget for stock table
  String text, {
  int flex = 1,
  TextAlign align = TextAlign.center,
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
      style: const TextStyle(color: Colors.white),
    ),
  );
}
