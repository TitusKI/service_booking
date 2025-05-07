import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            errorStyle: TextStyle(color: theme.colorScheme.error, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
