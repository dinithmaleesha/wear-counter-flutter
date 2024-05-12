import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const textInputDecoration = InputDecoration(
  fillColor: tileSecondColor,
  filled: true,
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: customRed),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: tileColor, width: 2.0),
  ),
  hintStyle: TextStyle(color: Colors.white54),
  labelStyle: TextStyle(color: Colors.white),
  errorStyle: TextStyle(color: customRed),
);

void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    // backgroundColor: Colors.black.withOpacity(0.7),
    backgroundColor: tileColor,
    textColor: Colors.white,
  );
}

const Color mainColor = Color.fromRGBO(0, 43, 56, 1);
const Color tileColor = Color.fromRGBO(1, 64, 82, 1);
const Color tileSecondColor = Color.fromRGBO(0, 118, 131, 1);
const Color customRed = Color.fromRGBO(254, 57, 95, 1);
