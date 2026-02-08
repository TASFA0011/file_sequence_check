import 'package:flutter/material.dart';

class MyOutlineTextField extends TextFormField {
  MyOutlineTextField(
      {super.key,
      super.readOnly,
      super.keyboardType,
      super.inputFormatters,
      super.onChanged,
      super.initialValue,
      super.obscureText,
      super.textAlign,
      super.controller,
      super.enabled,
      String? labelText,
      String? errorText,
      Widget? prefixIcon,
      Widget? suffixIcon,
      Widget? suffix,
      bool isDense = false,
      String? helperText})
      : super(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: labelText,
                errorText: errorText,
                helperText: helperText,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                suffix: suffix,
                errorMaxLines: 2,
                helperMaxLines: 2,
                isDense: isDense));
}
