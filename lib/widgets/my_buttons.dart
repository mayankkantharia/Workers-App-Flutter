import 'package:flutter/material.dart';
import 'package:work_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class MyMaterialButton extends StatelessWidget {
  const MyMaterialButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.textSize,
    this.mainAxisSize,
  }) : super(key: key);
  final Function onPressed;
  final String text;
  final IconData? icon;
  final Color? color;
  final double? textSize;
  final MainAxisSize? mainAxisSize;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onPressed.call();
      },
      elevation: 8,
      color: color ?? pink[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: [
          Text(
            text,
            style: TextStyle(
              color: white,
              fontSize: textSize ?? 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon != null ? 10.widthBox : 0.widthBox,
          icon != null
              ? Icon(
                  icon,
                  color: white,
                  size: 30,
                )
              : 0.heightBox,
        ],
      ).py(12),
    );
  }
}
