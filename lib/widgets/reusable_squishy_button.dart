import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Style variants of squishy physics behavior.
enum SquishPhysicsStyle {
  /// Controlled compression (0.95) with subtle spring-back.
  classic,

  /// More expressive compression (0.92) with lively spring bounce.
  elastic,

  /// Subtle compression (0.97) paired with tactile shadow depression.
  softNeumorphic,

  /// Minimal compression (0.97) with crisp, immediate recovery.
  subtle,
}

/// A high-performance, reusable Flutter button component with tactile
/// squish compression and spring-back physics.
///
/// Features:
/// - Smooth interpolation between resting and pressed scales
/// - Touch cancellation detection (releasing finger outside button)
/// - Rapid repeated tap immunity without animation desync
/// - Configurable shadows, borders, gradients, and icons
/// - Respects platform reduced-motion preferences
class ReusableSquishyButton extends StatefulWidget {
  const ReusableSquishyButton({
    super.key,
    this.label,
    this.child,
    this.icon,
    this.iconTrailing = false,
    this.iconSpacing = 8.0,
    this.labelStyle,
    this.backgroundColor,
    this.gradient,
    this.foregroundColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.shadows,
    this.pressedShadows,
    this.pressedBackgroundColor,
    this.pressedScale,
    this.physicsStyle = SquishPhysicsStyle.classic,
    this.pressDuration = const Duration(milliseconds: 110),
    this.releaseDuration = const Duration(milliseconds: 240),
    this.onPressed,
    this.enabled = true,
    this.width,
    this.height,
    this.hapticFeedback = true,
    this.enableIconSquish = false,
    this.isNeumorphic = false,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided',
       );

  /// Primary text label. If null, [child] must be provided.
  final String? label;

  /// Custom child widget. Replaces [label] if provided.
  final Widget? child;

  /// Optional icon displayed alongside the label.
  final Widget? icon;

  /// If true, places icon after the label instead of before.
  final bool iconTrailing;

  /// Spacing between icon and label.
  final double iconSpacing;

  /// Style applied to the label text.
  final TextStyle? labelStyle;

  /// Background color in resting state. Ignored if [gradient] is set.
  final Color? backgroundColor;

  /// Optional background gradient.
  final Gradient? gradient;

  /// Text and icon tint color.
  final Color? foregroundColor;

  /// Border outline for the button.
  final BoxBorder? border;

  /// Corner radius of the button surface.
  final BorderRadius? borderRadius;

  /// Internal padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Shadows rendered in the resting state.
  final List<BoxShadow>? shadows;

  /// Shadows rendered when fully compressed.
  final List<BoxShadow>? pressedShadows;

  /// Background color overlay or replacement when pressed.
  final Color? pressedBackgroundColor;

  /// Target scale when compressed. Defaults to physicsStyle preset if null.
  final double? pressedScale;

  /// Animation personality (classic, elastic, softNeumorphic, subtle).
  final SquishPhysicsStyle physicsStyle;

  /// Duration to compress down.
  final Duration pressDuration;

  /// Duration to spring back to rest.
  final Duration releaseDuration;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Whether to fire a light haptic tap on press.
  final bool hapticFeedback;

  /// Whether the icon itself does a secondary micro-bounce on press.
  final bool enableIconSquish;

  /// Whether to apply dual soft neumorphic shadows that deflate on press.
  final bool isNeumorphic;

  @override
  State<ReusableSquishyButton> createState() => _ReusableSquishyButtonState();
}

class _ReusableSquishyButtonState extends State<ReusableSquishyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shadowFactorAnimation;
  bool _disableAnimations = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.pressDuration,
      reverseDuration: widget.releaseDuration,
    );

    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  }

  void _setupAnimations() {
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    _shadowFactorAnimation = Tween<double>(
      begin: 1.0,
      end: 0.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));
  }

  @override
  void didUpdateWidget(covariant ReusableSquishyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.physicsStyle != widget.physicsStyle ||
        oldWidget.pressedScale != widget.pressedScale ||
        oldWidget.pressDuration != widget.pressDuration ||
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
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _triggerRelease() {
    if (!mounted) return;
    if (_disableAnimations) {
      _controller.value = 0.0;
      return;
    }

    final Curve reverseCurve = switch (widget.physicsStyle) {
      SquishPhysicsStyle.classic => const _TastefulSpringCurve(overshoot: 0.05),
      SquishPhysicsStyle.elastic => const _TastefulSpringCurve(
        overshoot: 0.12,
        bounces: 1.5,
      ),
      SquishPhysicsStyle.softNeumorphic => Curves.easeOutQuad,
      SquishPhysicsStyle.subtle => Curves.easeOutCubic,
    };

    _controller.animateBack(
      0.0,
      duration: widget.releaseDuration,
      curve: reverseCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;
    final double animValue = _controller.value;

    // Effective Colors
    final Color defaultBg = widget.isNeumorphic
        ? AppTheme.mainBackground
        : (widget.backgroundColor ?? AppTheme.primaryTerracotta);
    final Color effectiveBg = isInteractive
        ? (widget.pressedBackgroundColor != null && animValue > 0.05
              ? Color.lerp(
                  defaultBg,
                  widget.pressedBackgroundColor!,
                  animValue,
                )!
              : defaultBg)
        : defaultBg.withValues(alpha: 0.5);

    final Color effectiveFg = isInteractive
        ? (widget.foregroundColor ??
              (widget.isNeumorphic
                  ? AppTheme.primaryTerracotta
                  : AppTheme.whiteSurface))
        : (widget.foregroundColor ?? AppTheme.whiteSurface).withValues(
            alpha: 0.55,
          );

    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(16);

    // Compute animated scale
    final double targetScale =
        widget.pressedScale ??
        switch (widget.physicsStyle) {
          SquishPhysicsStyle.classic => 0.945,
          SquishPhysicsStyle.elastic => 0.915,
          SquishPhysicsStyle.softNeumorphic => 0.965,
          SquishPhysicsStyle.subtle => 0.960,
        };

    // Calculate current scale with possible spring overshoot when reversing
    double currentScale;
    if (_controller.status == AnimationStatus.reverse) {
      // Allow slight overshoot when springing back
      final double progress = 1.0 - animValue; // 0.0 to 1.0
      final double overshootAmount = switch (widget.physicsStyle) {
        SquishPhysicsStyle.classic => 0.035,
        SquishPhysicsStyle.elastic => 0.075,
        _ => 0.0,
      };

      if (overshootAmount > 0 && progress < 0.8) {
        final double wave = math.sin(progress * math.pi) * overshootAmount;
        currentScale = 1.0 - (1.0 - targetScale) * animValue + wave;
      } else {
        currentScale = 1.0 - (1.0 - targetScale) * animValue;
      }
    } else {
      currentScale = 1.0 - (1.0 - targetScale) * animValue;
    }

    // Shadow calculation
    List<BoxShadow> effectiveShadows = [];
    if (widget.isNeumorphic) {
      // Soft neumorphic dual shadows (warm white top-left, warm neutral bottom-right)
      final double factor = (1.0 - animValue * 0.75).clamp(0.1, 1.0);
      effectiveShadows = [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.95 * factor),
          offset: Offset(-3 * factor, -3 * factor),
          blurRadius: 7 * factor,
          spreadRadius: 0.5 * factor,
        ),
        BoxShadow(
          color: AppTheme.warmNeutral.withValues(alpha: 0.8 * factor),
          offset: Offset(4 * factor, 5 * factor),
          blurRadius: 10 * factor,
          spreadRadius: 0.5 * factor,
        ),
      ];
    } else if (widget.shadows != null) {
      final double factor = _shadowFactorAnimation.value;
      effectiveShadows = widget.shadows!.map((s) {
        return BoxShadow(
          color: s.color.withValues(alpha: s.color.a * factor),
          offset: Offset(s.offset.dx * factor, s.offset.dy * factor),
          blurRadius: s.blurRadius * factor,
          spreadRadius: s.spreadRadius * factor,
        );
      }).toList();
    } else if (widget.gradient != null ||
        widget.backgroundColor == AppTheme.primaryTerracotta) {
      // Default clean terracotta shadow
      final double factor = (1.0 - animValue * 0.7).clamp(0.2, 1.0);
      effectiveShadows = [
        BoxShadow(
          color: AppTheme.primaryTerracotta.withValues(alpha: 0.28 * factor),
          offset: Offset(0, 5 * factor),
          blurRadius: 12 * factor,
          spreadRadius: 0,
        ),
      ];
    }

    // Icon micro-scale animation when enableIconSquish is true
    Widget? iconWidget = widget.icon;
    if (iconWidget != null && widget.enableIconSquish && animValue > 0) {
      iconWidget = Transform.scale(
        scale: 1.0 + (animValue * 0.12),
        child: iconWidget,
      );
    }

    // Content assembly
    Widget content;
    if (widget.child != null) {
      content = widget.child!;
    } else {
      final List<Widget> rowItems = [];
      if (iconWidget != null && !widget.iconTrailing) {
        rowItems.add(
          IconTheme(
            data: IconThemeData(color: effectiveFg, size: 19),
            child: iconWidget,
          ),
        );
        rowItems.add(SizedBox(width: widget.iconSpacing));
      }

      rowItems.add(
        Text(
          widget.label ?? '',
          style:
              (widget.labelStyle ??
                      const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ))
                  .copyWith(color: effectiveFg),
        ),
      );

      if (iconWidget != null && widget.iconTrailing) {
        rowItems.add(SizedBox(width: widget.iconSpacing));
        rowItems.add(
          IconTheme(
            data: IconThemeData(color: effectiveFg, size: 19),
            child: iconWidget,
          ),
        );
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowItems,
      );
    }

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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: widget.width,
            height: widget.height,
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            decoration: BoxDecoration(
              color: widget.gradient == null ? effectiveBg : null,
              gradient: widget.gradient,
              borderRadius: radius,
              border: widget.border,
              boxShadow: effectiveShadows,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// Damped spring curve with controlled overshoot for a tactile rebound feel.
class _TastefulSpringCurve extends Curve {
  const _TastefulSpringCurve({this.overshoot = 0.05, this.bounces = 1.0});

  final double overshoot;
  final double bounces;

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;
    // Uses damped sine wave: settles smoothly to 1.0
    final double decay = math.exp(-4.5 * t);
    final double oscillation = math.cos(t * math.pi * bounces * 2);
    return 1.0 - (decay * oscillation * (1.0 + overshoot));
  }
}
