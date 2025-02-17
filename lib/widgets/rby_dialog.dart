import 'package:flutter/material.dart';
import 'package:rby/rby.dart';
import 'package:rby/theme/spacing_scheme.dart';

class RbyDialog extends StatelessWidget {
  const RbyDialog({
    this.title,
    this.stickyContent,
    this.content,
    this.actions,
    this.clipBehavior = Clip.none,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
  });

  final Widget? title;
  final Widget? stickyContent;
  final Widget? content;
  final List<Widget>? actions;

  final Clip clipBehavior;

  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? titleWidget;

    if (title != null) {
      titleWidget = Center(
        child: Padding(
          padding:
              titlePadding ??
              EdgeInsets.only(
                top: theme.spacingScheme.xl,
                left: theme.spacingScheme.xl,
                right: theme.spacingScheme.xl,
              ),
          child: DefaultTextStyle(
            style: theme.textTheme.titleLarge!,
            textAlign: TextAlign.center,
            child: title!,
          ),
        ),
      );
    }

    return Unfocus(
      child: Dialog(
        clipBehavior: clipBehavior,
        child: RbyAnimatedSize(
          curve: Curves.easeInOut,
          alignment: AlignmentDirectional.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (titleWidget != null) titleWidget,
                if (stickyContent != null) stickyContent!,
                Flexible(
                  child: Padding(
                    padding: contentPadding ?? theme.spacing.edgeInsets,
                    child: DefaultTextStyle(
                      style: theme.textTheme.titleSmall!,
                      child: SingleChildScrollView(child: content),
                    ),
                  ),
                ),
                if (actions != null)
                  RbyDialogActionBar(
                    actions: actions!,
                    padding: actionsPadding,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a list of [actions] (usually buttons) in an [OverflowBar].
class RbyDialogActionBar extends StatelessWidget {
  const RbyDialogActionBar({required this.actions, this.padding});

  final List<Widget> actions;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? theme.spacing.edgeInsets.copyWith(top: 0),
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceAround,
        spacing: theme.spacing.base,
        overflowSpacing: theme.spacing.small,
        overflowAlignment: OverflowBarAlignment.center,
        children: actions,
      ),
    );
  }
}
