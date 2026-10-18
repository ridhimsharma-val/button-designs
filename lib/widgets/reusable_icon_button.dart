import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Distinct personality variants for the Icon button family.
enum IconButtonVariant {
  /// Polished horizontal button with leading icon + "Button" label that deepens on press.
  iconAndLabel,

  /// Starts with "Button", smoothly reveals a trailing icon on interaction.
  iconReveal,

  /// Compact circular action button with semantic tooltip and icon-only presentation.
  iconOnly,

  /// Micro-animated icon (tasteful rotation) while text stays stationary.
  animatedIcon,

  /// Interactive state-toggle cross-fading between primary and confirmation icons.
  iconSwap,
}

/// A high-performance, reusable Flutter icon button component.
///
/// Features:
/// - Leading, trailing, revealing, animated, and state-swapping icon arrangements
/// - Zero-latency touch response via [Listener] + [GestureDetector]
/// - Safe gesture cancellation and rapid repeated-tap handling
/// - Reduced-motion accessibility support
class ReusableIconButton extends StatefulWidget {
  const ReusableIconButton({
    super.key,
    this.label = 'Button',
    this.variant = IconButtonVariant.iconAndLabel,
    this.icon = Icons.send_rounded,
    this.secondaryIcon = Icons.check_rounded,
    this.iconSize = 19.0,
    this.iconSpacing = 8.0,
    this.backgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.shadows,
    this.tooltip,
    this.semanticLabel,
    this.labelStyle,
    this.onPressed,
    this.enabled = true,
    this.hapticFeedback = true,
    this.pressDuration = const Duration(milliseconds: 110),
    this.releaseDuration = const Duration(milliseconds: 240),
    this.pressCurve = Curves.easeOutCubic,
    this.releaseCurve = const _TastefulSpringCurve(overshoot: 0.045),
  });

  /// Text label displayed inside the button (defaults to "Button", omitted for [IconButtonVariant.iconOnly]).
  final String label;

  /// Variant personality of the icon button.
  final IconButtonVariant variant;

  /// Primary icon displayed.
  final IconData icon;

  /// Secondary icon used for [IconButtonVariant.iconSwap].
  final IconData secondaryIcon;

  /// Icon size. Defaults to 19.
  final double iconSize;

  /// Horizontal spacing between icon and text.
  final double iconSpacing;

  /// Button surface background color.
  final Color? backgroundColor;

  /// Color overlay or replacement when pressed.
  final Color? pressedBackgroundColor;

  /// Icon and text color.
  final Color? foregroundColor;

  /// Border outline.
  final BoxBorder? border;

  /// Corner radius.
  final BorderRadius? borderRadius;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Resting drop shadows.
  final List<BoxShadow>? shadows;

  /// Semantic tooltip for accessibility.
  final String? tooltip;

  /// Semantic label for screen readers.
  final String? semanticLabel;

  /// Text style for [label].
  final TextStyle? labelStyle;

  /// Callback executed when tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether to fire light haptic feedback on press.
  final bool hapticFeedback;

  /// Duration to compress on press.
  final Duration pressDuration;

  /// Duration to spring back to rest on release.
  final Duration releaseDuration;

  /// Animation curve when transitioning into the pressed state.
  final Curve pressCurve;

  /// Animation curve when returning to the resting state.
  final Curve releaseCurve;

  @override
  State<ReusableIconButton> createState() => _ReusableIconButtonState();
}

class _ReusableIconButtonState extends State<ReusableIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _disableAnimations = false;
  bool _isSwapped = false;

  @override
  void initState() {
    super.initState();
    _pressController =
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
  void didUpdateWidget(covariant ReusableIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressDuration != widget.pressDuration ||
        oldWidget.releaseDuration != widget.releaseDuration) {
      _pressController.duration = widget.pressDuration;
      _pressController.reverseDuration = widget.releaseDuration;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _pressIn() {
    if (!mounted || !widget.enabled || widget.onPressed == null) return;

    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (_disableAnimations) {
      _pressController.value = 1.0;
    } else {
      _pressController.animateTo(
        1.0,
        duration: widget.pressDuration,
        curve: widget.pressCurve,
      );
    }
  }

  void _triggerRelease() {
    if (!mounted) return;

    if (_disableAnimations) {
      _pressController.value = 0.0;
      return;
    }

    _pressController.animateBack(
      0.0,
      duration: widget.releaseDuration,
      curve: widget.releaseCurve,
    );
  }

  void _handleTap() {
    if (!widget.enabled) return;

    if (widget.variant == IconButtonVariant.iconSwap) {
      setState(() {
        _isSwapped = !_isSwapped;
      });
    }

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;
    final double animValue = _pressController.value;

    // 1. Calculate Scale
    double currentScale;
    if (_pressController.status == AnimationStatus.reverse) {
      final double progress = 1.0 - animValue;
      final double wave = progress < 0.8
          ? math.sin(progress * math.pi) * 0.03
          : 0.0;
      currentScale = 1.0 - (0.048 * animValue) + wave;
    } else {
      currentScale = 1.0 - (0.048 * animValue);
    }

    // 2. Resolve Colors
    final Color defaultBg =
        widget.backgroundColor ?? AppTheme.primaryTerracotta;
    final Color defaultPressedBg =
        widget.pressedBackgroundColor ?? AppTheme.darkTerracotta;

    final Color effectiveBg = isInteractive
        ? (animValue > 0.05
              ? Color.lerp(defaultBg, defaultPressedBg, animValue)!
              : defaultBg)
        : defaultBg.withValues(alpha: 0.5);

    final Color effectiveFg = isInteractive
        ? (widget.foregroundColor ?? Colors.white)
        : (widget.foregroundColor ?? Colors.white).withValues(alpha: 0.55);

    final BorderRadius radius = widget.variant == IconButtonVariant.iconOnly
        ? BorderRadius.circular(999)
        : (widget.borderRadius ?? BorderRadius.circular(16));

    // 3. Resolve Shadows
    List<BoxShadow> effectiveShadows =
        widget.shadows ??
        [
          BoxShadow(
            color: AppTheme.primaryTerracotta.withValues(
              alpha: (0.26 - animValue * 0.08).clamp(0.1, 1.0),
            ),
            offset: Offset(0, 5 - animValue * 2),
            blurRadius: 14 - animValue * 4,
            spreadRadius: 0,
          ),
        ];

    // 4. Build Variant-Specific Inner Content
    final Widget content = _buildContent(
      animValue: animValue,
      effectiveFg: effectiveFg,
    );

    final Widget buttonWidget = Listener(
      onPointerDown: isInteractive ? (_) => _pressIn() : null,
      onPointerUp: isInteractive ? (_) => _triggerRelease() : null,
      onPointerCancel: isInteractive ? (_) => _triggerRelease() : null,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: isInteractive ? _handleTap : null,
        behavior: HitTestBehavior.opaque,
        child: Transform.scale(
          scale: currentScale,
          alignment: Alignment.center,
          child: Container(
            width: widget.variant == IconButtonVariant.iconOnly
                ? (widget.width ?? 52.0)
                : widget.width,
            height: widget.variant == IconButtonVariant.iconOnly
                ? (widget.height ?? 52.0)
                : widget.height,
            padding: widget.variant == IconButtonVariant.iconOnly
                ? EdgeInsets.zero
                : (widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 16)),
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: radius,
              border: widget.border,
              boxShadow: effectiveShadows,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );

    if (widget.tooltip != null || widget.semanticLabel != null) {
      return Tooltip(
        message: widget.tooltip ?? widget.semanticLabel ?? '',
        child: Semantics(
          label: widget.semanticLabel ?? widget.tooltip,
          button: true,
          enabled: widget.enabled,
          child: buttonWidget,
        ),
      );
    }

    return buttonWidget;
  }

  Widget _buildContent({
    required double animValue,
    required Color effectiveFg,
  }) {
    final TextStyle textStyle =
        (widget.labelStyle ??
                const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ))
            .copyWith(color: effectiveFg);

    switch (widget.variant) {
      case IconButtonVariant.iconAndLabel:
        // Horizontal arrangement: leading icon + "Button" label
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: widget.iconSize, color: effectiveFg),
            SizedBox(width: widget.iconSpacing),
            Text(widget.label, style: textStyle),
          ],
        );

      case IconButtonVariant.iconReveal:
        // Starts with "Button", slides in trailing arrow on press
        final double revealProgress = animValue;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.label, style: textStyle),
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: revealProgress,
                child: Opacity(
                  opacity: revealProgress.clamp(0.0, 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: widget.iconSpacing * revealProgress),
                      Icon(
                        widget.icon,
                        size: widget.iconSize,
                        color: effectiveFg,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      case IconButtonVariant.iconOnly:
        // Compact circular action button
        return Icon(widget.icon, size: widget.iconSize + 3, color: effectiveFg);

      case IconButtonVariant.animatedIcon:
        // Micro-animated icon: rotates 90 degrees on press while text stays stationary
        final double rotationAngle = animValue * (math.pi / 2);
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: rotationAngle,
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: effectiveFg,
              ),
            ),
            SizedBox(width: widget.iconSpacing),
            Text(widget.label, style: textStyle),
          ],
        );

      case IconButtonVariant.iconSwap:
        // Smooth scale-and-fade swap between primary and confirmation icons
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                _isSwapped ? widget.secondaryIcon : widget.icon,
                key: ValueKey<bool>(_isSwapped),
                size: widget.iconSize,
                color: effectiveFg,
              ),
            ),
            SizedBox(width: widget.iconSpacing),
            Text(widget.label, style: textStyle),
          ],
        );
    }
  }
}

/// Spring curve with controlled overshoot.
class _TastefulSpringCurve extends Curve {
  const _TastefulSpringCurve({this.overshoot = 0.05});

  final double overshoot;

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;
    final double decay = math.exp(-4.5 * t);
    final double osc = math.cos(t * math.pi * 2.0);
    return 1.0 - (decay * osc * (1.0 + overshoot));
  }
}
