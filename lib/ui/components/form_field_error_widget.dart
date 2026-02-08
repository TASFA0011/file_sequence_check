import 'package:flutter/material.dart';

class FormFieldErrorWidget extends StatelessWidget {

  final String message;
  const FormFieldErrorWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.red[700]
        ),
      ),
    );
  }
}
