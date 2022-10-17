import 'package:flutter/material.dart';
import 'package:translator_app/config/presentation/app_color.dart';

class CustomIconButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final double borderRadius;
  final VoidCallback onTap;
  
  const CustomIconButton({
    Key? key,
    required this.onTap,
    this.backgroundColor = AppColor.primaryColor,
    this.iconData = Icons.arrow_back_ios_outlined,
    this.iconColor = Colors.white,
    this.borderRadius = 40.0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: borderRadius,
        width: borderRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }
}