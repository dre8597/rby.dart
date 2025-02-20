import 'package:flutter/material.dart';
import 'package:rby/rby.dart';

class RbyListCard extends StatelessWidget {
  const RbyListCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.border,
    this.color,
    this.onTap,
    this.enabled = true,
    this.contentPadding,
    this.leadingPadding,
    this.trailingPadding,
    this.verticalAlignment = CrossAxisAlignment.center,
    this.multilineTitle = false,
    this.multilineSubtitle = true,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  final Border? border;
  final Color? color;
  final VoidCallback? onTap;
  final bool enabled;

  final EdgeInsets? contentPadding;
  final EdgeInsets? leadingPadding;
  final EdgeInsets? trailingPadding;
  final CrossAxisAlignment verticalAlignment;
  final bool multilineTitle;
  final bool multilineSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use card color from theme if none provided, fallback to surface color
    final backgroundColor =
        this.color ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: theme.shape.borderRadius,
        border: border,
        // Ensure we always have a non-transparent background for contrast
        color: enabled ? backgroundColor : backgroundColor.withAlpha(128),
      ),
      child: RbyListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        borderRadius: theme.shape.borderRadius,
        color: backgroundColor,
        onTap: onTap,
        enabled: enabled,
        contentPadding: contentPadding,
        leadingPadding: leadingPadding,
        trailingPadding: trailingPadding,
        verticalAlignment: verticalAlignment,
        multilineTitle: multilineTitle,
        multilineSubtitle: multilineSubtitle,
      ),
    );
  }
}
