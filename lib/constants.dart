

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

Color mainColor =  ThemeData().primaryColor;


convertToDateOnly(DateTime data) {
  try {
    return DateFormat('dd MMM yyyy')
        .format(data);
  } catch (e) {
    return '';
  }
}




/// Convert string to Uppercase and title type string
/// i.e "how are you"=> How Are You
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

void printred(String text) {

    print('\x1B[31m$text\x1B[0m');

}

void printgreen(String text) {

    print('\x1B[32m$text\x1B[0m');

}

void printyellow(String text) {

    print('\x1B[33m$text\x1B[0m');

}

void printblue(String text) {

    print('\x1B[38m$text\x1B[0m');

}

void printwhite(String text) {

    print('\x1B[37m$text\x1B[0m');

}



void printWrapped(String text) {
  final pattern = RegExp('.{1,2000}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}