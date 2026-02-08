import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {

  final String label;
  final Widget? leading;
  const FormFieldLabel(this.label, {super.key,  this.leading });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [

          if (leading != null)
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: leading,
            ),

          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}
