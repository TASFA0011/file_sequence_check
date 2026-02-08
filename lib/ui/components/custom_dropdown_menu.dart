import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends DropdownButtonFormField<T> {

  CustomDropdownMenu({
    super.key, 
    super.value,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    super.onChanged,
    String? labelText,
    String? hintText,
    String? errorText,
    bool isDense = true,
    bool filled = true,
    OutlineInputBorder border = const OutlineInputBorder(borderSide: BorderSide.none)
  }): super(
        items: List.generate(items.length, (index) => DropdownMenuItem(value: items[index], child: itemBuilder(items[index])), growable: false),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: border,
          filled: filled,
          isDense: isDense,
          errorText: errorText          
        ),
        // style: const TextStyle(
        //   fontWeight: FontWeight.w600,
        //   color: Colors.black87
        // )
      );
}
