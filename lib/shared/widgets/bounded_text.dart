import 'package:flutter/material.dart';

class BoundedText extends StatelessWidget {
  const BoundedText(
    this.text, {
    super.key,
    this.style,
    this.icon,
    this.maxLines = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    this.color,
  });

  final String text;
  final TextStyle? style;
  final IconData? icon;
  final int maxLines;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? scheme.surfaceContainerHighest.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
