import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? color;
  final IconData? icon;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.color,
    this.icon,
    this.type = ButtonType.filled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    final isActive = !(isLoading || isDisabled);

    switch (type) {
      case ButtonType.filled:
        return ElevatedButton(
          onPressed: isActive ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isActive
                    ? (color ?? theme.colorScheme.primary)
                    : theme.disabledColor,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
            elevation: 0,
          ),
          child: _buildButtonContent(theme),
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isActive ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor:
                isActive
                    ? (color ?? theme.colorScheme.primary)
                    : theme.disabledColor,
            side: BorderSide(
              color:
                  isActive
                      ? (color ?? theme.colorScheme.primary)
                      : theme.disabledColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: _buildButtonContent(theme),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isActive ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor:
                isActive
                    ? (color ?? theme.colorScheme.primary)
                    : theme.disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: _buildButtonContent(theme),
        );
    }
  }

  Widget _buildButtonContent(ThemeData theme) {
    return isLoading
        ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color:
                type == ButtonType.filled
                    ? theme.colorScheme.onPrimary
                    : (color ?? theme.colorScheme.primary),
            strokeWidth: 2,
          ),
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
  }
}

enum ButtonType { filled, outlined, text }
