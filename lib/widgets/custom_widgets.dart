import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/design_system.dart';

class StyleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isSecondary;

  const StyleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isSecondary ? null : DesignSystem.primaryGradient,
        borderRadius: DesignSystem.outerBorderRadius,
        color: isSecondary ? Colors.transparent : null,
        border: isSecondary
            ? Border.all(color: DesignSystem.primaryGradientStart, width: 2)
            : null,
        boxShadow: isSecondary ? null : DesignSystem.premiumShadow,
      ),
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: DesignSystem.outerBorderRadius,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isSecondary
                          ? DesignSystem.primaryGradientStart
                          : Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: isSecondary
                          ? DesignSystem.primaryGradientStart
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class StyleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const StyleCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(
          borderRadius ?? DesignSystem.borderRadius,
        ),
        boxShadow: boxShadow ?? DesignSystem.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.selectionClick();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(
            borderRadius ?? DesignSystem.borderRadius,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMd),
            child: child,
          ),
        ),
      ),
    );
  }
}

class StyleTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const StyleTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<StyleTextField> createState() => _StyleTextFieldState();
}

class _StyleTextFieldState extends State<StyleTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.8),
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: const ShimmerAnimation(),
      ),
    );
  }
}

class ShimmerAnimation extends StatefulWidget {
  const ShimmerAnimation({super.key});

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(_controller.value * 2 - 1, 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0),
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: StyleCard(
            borderRadius: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    DesignSystem.primaryGradientStart,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
