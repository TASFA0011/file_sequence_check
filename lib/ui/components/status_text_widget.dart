import 'package:flutter/material.dart';
// import 'package:school_management_app/constants/user_role.dart';

class StatusTextWidget extends StatelessWidget {

  final String text;
  final Color color;

  const StatusTextWidget(this.text, {super.key, 
    this.color = Colors.black
  });

  factory StatusTextWidget.fromUserRole(label) {
    return StatusTextWidget(
      label,
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: ShapeDecoration(
        color: color.withValues(alpha:  0.25),
        shape: const StadiumBorder()
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12.0,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
