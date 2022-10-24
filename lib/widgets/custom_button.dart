// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:translator_app/config/presentation/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    this.radius = 0.0,
    this.backgroundColor = AppColor.primaryColor,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final double radius;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: const BorderSide(
                color: AppColor.primaryColor,
                strokeAlign: StrokeAlign.inside,
              ),
            ),
          ),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
