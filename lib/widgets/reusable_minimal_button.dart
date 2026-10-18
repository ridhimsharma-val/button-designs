import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Personality styles for the Minimal button family.
enum MinimalStyle {
  /// Simple terracotta text on cream, tiny scale-down on press.
  pureMinimal,

  /// Animates a thin terracotta underline expanding beneath the label on press.
  underlinePress,

  /// Smoothly introduces a subtle light-terracotta background tint on press.
  softTint,

  /// Moves the label subtly downward on press and smoothly restores position.
  textShift,

  /// Slightly reduces text opacity and scales down on press.
  fadeAndPress,
}

/// A high-performance, reusable Flutter minimal button component.
///
/// Features:
/// - Restrained typography-focused interactions (pure scale, underline expand, soft tint, text shift, fade & press)
/// - Zero-latency touch response via [Listener] + [GestureDetector]
/// - Safe gesture cancellation and rapid repeated-tap handling
/// - Reduced-motion accessibility support
class ReusableMinimalButton extends StatefulWidget {
  const ReusableMinimalButton({
    super.key,
    this.label = 'Button',
    this.child,
    this.style = MinimalStyle.pureMinimal,
    this.textColor,
    this.tintColor,
    this.underlineColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.labelStyle,
    this.onPressed,
    this.enabled = true,
    this.hapticFeedback = true,
    this.pressDuration = const Duration(milliseconds: 160),
    this.releaseDuration = const Duration(milliseconds: 220),
    this.pressCurve = Curves.easeOutCubic,
    this.releaseCurve = Curves.easeInOutCubic,
  });

  /// Text label displayed inside the button (defaults to "Button").
  final String label;

  /// Custom child widget. Replaces [label] if provided.
  final Widget? child;

  /// Minimal interaction and visual personality.
  final MinimalStyle style;

  /// Label text color. Defaults to [AppTheme.primaryTerracotta].
  final Color? textColor;

  /// Tint background color for [MinimalStyle.softTint].
  final Color? tintColor;

  /// Underline stroke color for [MinimalStyle.underlinePress].
  final Color? underlineColor;

  /// Corner radius for tinted container.
  final BorderRadius? borderRadius;

  /// Internal padding for touch target comfort.
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Text style for [label].
  final TextStyle? labelStyle;

  /// Callback executed when tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether to fire light haptic feedback on press.
  final bool hapticFeedback;

  /// Duration to transition into the pressed state.
  final Duration pressDuration;

  /// Duration to return to the resting state.
  final Duration releaseDuration;

  /// Animation curve when transitioning into the pressed state.
  final Curve pressCurve;

  /// Animation curve when returning to the resting state.
  final Curve releaseCurve;

  @override
  State<ReusableMinimalButton> createState() => _ReusableMinimalButtonState();
}

class _ReusableMinimalButtonState extends State<ReusableMinimalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _disableAnimations = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: widget.pressDuration,
          reverseDuration: widget.releaseDuration,
        )..addListener(() {
          if (mounted) setState(() {});
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  @override
  void didUpdateWidget(covariant ReusableMinimalButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressDuration != widget.pressDuration ||
        oldWidget.releaseDuration != widget.releaseDuration) {
      _controller.duration = widget.pressDuration;
      _controller.reverseDuration = widget.releaseDuration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pressIn() {
    if (!mounted || !widget.enabled || widget.onPressed == null) return;

    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (_disableAnimations) {
      _controller.value = 1.0;
    } else {
      _controller.animateTo(
        1.0,
        duration: widget.pressDuration,
        curve: widget.pressCurve,
      );
    }
  }

  void _triggerRelease() {
    if (!mounted) return;

    if (_disableAnimations) {
      _controller.value = 0.0;
      return;
    }

    _controller.animateBack(
      0.0,
      duration: widget.releaseDuration,
      curve: widget.releaseCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;
    final double animValue = _controller.value;

    final Color effectiveFg = (widget.textColor ?? AppTheme.primaryTerracotta)
        .withValues(alpha: isInteractive ? 1.0 : 0.5);

    final TextStyle textStyle =
        (widget.labelStyle ??
                const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ))
            .copyWith(color: effectiveFg);

    // 1. Calculate Scale Compression
    double currentScale = 1.0;
    switch (widget.style) {
      case MinimalStyle.pureMinimal:
        currentScale = 1.0 - (0.045 * animValue);
      case MinimalStyle.underlinePress:
        currentScale = 1.0 - (0.025 * animValue);
      case MinimalStyle.softTint:
        currentScale = 1.0 - (0.035 * animValue);
      case MinimalStyle.textShift:
        currentScale = 1.0 - (0.020 * animValue);
      case MinimalStyle.fadeAndPress:
        currentScale = 1.0 - (0.045 * animValue);
    }

    // 2. Build Content per Style
    Widget content;
    switch (widget.style) {
      case MinimalStyle.pureMinimal:
        content = Text(widget.label, style: textStyle);

      case MinimalStyle.underlinePress:
        final Color uColor =
            widget.underlineColor ?? AppTheme.primaryTerracotta;
        content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.label, style: textStyle),
            const SizedBox(height: 3),
            // Smoothly expanding underline centered beneath label
            SizedBox(
              height: 2.0,
              child: FractionallySizedBox(
                widthFactor: animValue.clamp(0.0, 1.0),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: uColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ],
        );

      case MinimalStyle.softTint:
        final Color tColor =
            widget.tintColor ??
            AppTheme.lightTerracotta.withValues(alpha: 0.65);
        final Color currentBg = Color.lerp(
          Colors.transparent,
          tColor,
          animValue,
        )!;
        content = AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: currentBg,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          child: Text(widget.label, style: textStyle),
        );

      case MinimalStyle.textShift:
        // Restrained downward shift of 2.2 logical pixels on press
        content = Transform.translate(
          offset: Offset(0, 2.2 * animValue),
          child: Text(widget.label, style: textStyle),
        );

      case MinimalStyle.fadeAndPress:
        final double opacity = (1.0 - (0.35 * animValue)).clamp(0.0, 1.0);
        content = Opacity(
          opacity: opacity,
          child: Text(widget.label, style: textStyle),
        );
    }

    // For styles other than softTint, apply padding outside the content
    final Widget paddedContent = widget.style == MinimalStyle.softTint
        ? content
        : Padding(
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            child: content,
          );

    return Listener(
      onPointerDown: isInteractive ? (_) => _pressIn() : null,
      onPointerUp: isInteractive ? (_) => _triggerRelease() : null,
      onPointerCancel: isInteractive ? (_) => _triggerRelease() : null,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: isInteractive ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: Transform.scale(
          scale: currentScale,
          alignment: Alignment.center,
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: paddedContent,
          ),
        ),
      ),
    );
  }
}
