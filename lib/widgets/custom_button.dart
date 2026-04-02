import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(text),
            )
          : FilledButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(text),
            ),
    );
  }
}
