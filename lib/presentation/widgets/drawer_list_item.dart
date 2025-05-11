import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerListItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final int index;

  const DrawerListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    required this.index,
  });

  @override
  State<DrawerListItem> createState() => _DrawerListItemState();
}

class _DrawerListItemState extends State<DrawerListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                widget.isDestructive
                    ? theme.colorScheme.errorContainer.withOpacity(0.2)
                    : theme.colorScheme.surfaceContainerHighest.withOpacity(
                      0.5,
                    ),
          ),
          child: ListTile(
            leading: Icon(
              widget.icon,
              color:
                  widget.isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
            ),
            title: Text(
              widget.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color:
                    widget.isDestructive
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
          ),
        ),
      ),
    );
  }
}
