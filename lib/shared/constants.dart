import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(63, 81, 181, 1), width: 2.0),
  ),
);

void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.7),
    textColor: Colors.white,
  );
}

const Color mainColor = Color.fromRGBO(0, 43, 56, 1);
const Color tileColor = Color.fromRGBO(1, 64, 82, 1);
const Color tileSecondColor = Color.fromRGBO(0, 118, 131, 1);
