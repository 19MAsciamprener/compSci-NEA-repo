import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext context, DateTime? dateOfBirth) async {
  //function to pick date of birth
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate:
        dateOfBirth ??
        DateTime.now(), //default to current date if not previously set
    firstDate: DateTime(1900), //earliest date selectable
    lastDate: DateTime.now(), //latest date selectable is current date
  );
  if (selectedDate != null) {
    //if a date is selected, update the state
    dateOfBirth = selectedDate;
  }
  return dateOfBirth;
}
