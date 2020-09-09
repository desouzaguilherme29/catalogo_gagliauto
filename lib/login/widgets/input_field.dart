import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;

  InputField({this.hint, this.obscure, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.white24,
        width: 0.5,
      ))),
      child: TextFormField(
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20,
                letterSpacing: 0.9,
                fontFamily: "Tahoma"),
            contentPadding:
                EdgeInsets.only(top: 30, right: 30, bottom: 30, left: 5)),
      ),
    );
  }
}
