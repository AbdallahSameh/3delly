import 'package:flutter/material.dart';

class GoldenButton extends StatelessWidget {
  final Widget? child;
  final Function()? onPressed;
  final Size? size;
  const GoldenButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        iconColor: Colors.black,
        elevation: 12,
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          border: BoxBorder.all(width: 1),
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Color(0xFFf9e6c0), Color(0xffdfc38d), Color(0xffa6814f)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: size?.width ?? 48,
            minHeight: size?.height ?? 24,
          ),

          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
