import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  
  const CustomCard({
    Key? key,
    required this.child,
    this.margin,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      shape: borderColor != null
          ? RoundedRectangleBorder(
              side: BorderSide(color: borderColor!, width: 1),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}