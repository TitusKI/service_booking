import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeToggleButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;

  const ThemeToggleButton({
    super.key,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color lightIconColor = theme.colorScheme.secondary;
    Color darkIconColor = theme.colorScheme.onSurfaceVariant;
    Color iconColor = widget.isDark ? darkIconColor : lightIconColor;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onTap();
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              key: ValueKey<bool>(widget.isDark),
              widget.isDark ? Icons.nightlight_round : Icons.wb_sunny,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
