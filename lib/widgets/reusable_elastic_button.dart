import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Personality styles for elastic button physics.
enum ElasticPhysicsStyle {
  /// Noticeable compression (~0.90) with slight overshoot rebound settling smoothly.
  elasticBounce,

  /// Stretches horizontally while compressing vertically on press, returns cleanly.
  horizontalStretch,

  /// Subtle scale + shape deformation on press with soft 2-phase damped jelly wobble on release.
  jelly,

  /// Compress on press with expressive stretch-and-snap spring on release.
  rubberBand,

  /// Gentle compression with minimal spring rebound.
  softRebound,
}

/// A high-performance, reusable Flutter button component with tactile
/// elastic physics, supporting 2D scaling, jelly wobble, and spring rebounds.
class ReusableElasticButton extends StatefulWidget {
  const ReusableElasticButton({
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
    this.pressedBackgroundColor,
    this.physicsStyle = ElasticPhysicsStyle.elasticBounce,
    this.pressDuration = const Duration(milliseconds: 110),
    this.releaseDuration = const Duration(milliseconds: 380),
    this.onPressed,
    this.enabled = true,
    this.width,
    this.height,
    this.hapticFeedback = true,
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

  /// Background color overlay or replacement when pressed.
  final Color? pressedBackgroundColor;

  /// Animation personality (elasticBounce, horizontalStretch, jelly, rubberBand, softRebound).
  final ElasticPhysicsStyle physicsStyle;

  /// Duration to compress down.
  final Duration pressDuration;

  /// Duration to spring back and settle.
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

  @override
  State<ReusableElasticButton> createState() => _ReusableElasticButtonState();
}

class _ReusableElasticButtonState extends State<ReusableElasticButton>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _releaseController;

  bool _disableAnimations = false;
  double _releaseIntensity = 1.0;

  @override
  void initState() {
    super.initState();
    _pressController =
        AnimationController(vsync: this, duration: widget.pressDuration)
          ..addListener(() {
            if (mounted) setState(() {});
          });

    _releaseController =
        AnimationController(vsync: this, duration: widget.releaseDuration)
          ..addListener(() {
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
  void didUpdateWidget(covariant ReusableElasticButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressDuration != widget.pressDuration) {
      _pressController.duration = widget.pressDuration;
    }
    if (oldWidget.releaseDuration != widget.releaseDuration) {
      _releaseController.duration = widget.releaseDuration;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _releaseController.dispose();
    super.dispose();
  }

  void _pressIn() {
    if (!mounted || !widget.enabled || widget.onPressed == null) return;

    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    _releaseController.stop();

    if (_disableAnimations) {
      _pressController.value = 1.0;
    } else {
      _pressController.animateTo(
        1.0,
        duration: widget.pressDuration,
        curve: Curves.easeOutQuad,
      );
    }
  }

  void _triggerRelease() {
    if (!mounted) return;

    if (_disableAnimations) {
      _pressController.value = 0.0;
      _releaseController.value = 1.0;
      return;
    }

    _releaseIntensity = _pressController.value;
    _pressController.reset();
    _releaseController.forward(from: 0.0);
  }

  /// Evaluates an underdamped spring response with initial displacement.
  ///
  /// Formula: displacement * e^(-decay * t) * (cos(omega * t) - beta * sin(omega * t))
  double _springResponse({
    required double t,
    required double initialDisplacement,
    required double decay,
    required double omega,
    required double beta,
  }) {
    if (t >= 1.0) return 0.0;
    final double env = math.exp(-decay * t);
    final double osc = math.cos(omega * t) - (beta * math.sin(omega * t));
    return initialDisplacement * env * osc;
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;

    // Calculate scaleX and scaleY based on active phase
    double scaleX = 1.0;
    double scaleY = 1.0;
    double currentCompression = 0.0;

    if (_pressController.isAnimating ||
        (_pressController.value > 0.0 && !_releaseController.isAnimating)) {
      final double p = _pressController.value;
      currentCompression = p;

      switch (widget.physicsStyle) {
        case ElasticPhysicsStyle.elasticBounce:
          scaleX = 1.0 - (0.10 * p);
          scaleY = scaleX;
        case ElasticPhysicsStyle.horizontalStretch:
          scaleX = 1.0 + (0.09 * p);
          scaleY = 1.0 - (0.10 * p);
        case ElasticPhysicsStyle.jelly:
          scaleX = 1.0 + (0.065 * p);
          scaleY = 1.0 - (0.085 * p);
        case ElasticPhysicsStyle.rubberBand:
          scaleX = 1.0 - (0.12 * p);
          scaleY = scaleX;
        case ElasticPhysicsStyle.softRebound:
          scaleX = 1.0 - (0.045 * p);
          scaleY = scaleX;
      }
    } else if (_releaseController.isAnimating) {
      final double t = _releaseController.value;
      final double intensity = _releaseIntensity;
      currentCompression = (1.0 - t) * intensity;

      switch (widget.physicsStyle) {
        case ElasticPhysicsStyle.elasticBounce:
          final double offset = _springResponse(
            t: t,
            initialDisplacement: -0.10 * intensity,
            decay: 5.2,
            omega: math.pi * 3.2,
            beta: 1.35,
          );
          scaleX = 1.0 + offset;
          scaleY = scaleX;

        case ElasticPhysicsStyle.horizontalStretch:
          final double offsetX = _springResponse(
            t: t,
            initialDisplacement: 0.09 * intensity,
            decay: 5.8,
            omega: math.pi * 2.8,
            beta: 1.1,
          );
          final double offsetY = _springResponse(
            t: t,
            initialDisplacement: -0.10 * intensity,
            decay: 5.8,
            omega: math.pi * 2.8,
            beta: 1.1,
          );
          scaleX = 1.0 + offsetX;
          scaleY = 1.0 + offsetY;

        case ElasticPhysicsStyle.jelly:
          // Multi-phase damped wobble between X and Y in opposition
          final double offsetX = _springResponse(
            t: t,
            initialDisplacement: 0.065 * intensity,
            decay: 4.6,
            omega: math.pi * 4.2,
            beta: 1.2,
          );
          final double offsetY = _springResponse(
            t: t,
            initialDisplacement: -0.085 * intensity,
            decay: 4.6,
            omega: math.pi * 4.2,
            beta: 1.2,
          );
          scaleX = 1.0 + offsetX;
          scaleY = 1.0 + offsetY;

        case ElasticPhysicsStyle.rubberBand:
          // Snappy snap-and-stretch
          final double offset = _springResponse(
            t: t,
            initialDisplacement: -0.12 * intensity,
            decay: 5.0,
            omega: math.pi * 3.4,
            beta: 1.6,
          );
          scaleX = 1.0 + offset;
          scaleY = scaleX;

        case ElasticPhysicsStyle.softRebound:
          final double offset = _springResponse(
            t: t,
            initialDisplacement: -0.045 * intensity,
            decay: 7.0,
            omega: math.pi * 2.4,
            beta: 0.8,
          );
          scaleX = 1.0 + offset;
          scaleY = scaleX;
      }
    }

    // Effective Colors
    final Color defaultBg =
        widget.backgroundColor ?? AppTheme.primaryTerracotta;
    final Color effectiveBg = isInteractive
        ? (widget.pressedBackgroundColor != null && currentCompression > 0.05
              ? Color.lerp(
                  defaultBg,
                  widget.pressedBackgroundColor!,
                  currentCompression,
                )!
              : defaultBg)
        : defaultBg.withValues(alpha: 0.5);

    final Color effectiveFg = isInteractive
        ? (widget.foregroundColor ?? AppTheme.whiteSurface)
        : (widget.foregroundColor ?? AppTheme.whiteSurface).withValues(
            alpha: 0.55,
          );

    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(16);

    // Dynamic shadow calculation reacting to vertical scale
    final double shadowScaleFactor = (((scaleX + scaleY) / 2.0) - 0.7) / 0.3;
    final double clampedShadowFactor = shadowScaleFactor.clamp(0.2, 1.15);

    List<BoxShadow> effectiveShadows = [];
    if (widget.shadows != null) {
      effectiveShadows = widget.shadows!.map((s) {
        return BoxShadow(
          color: s.color.withValues(
            alpha: (s.color.a * clampedShadowFactor).clamp(0.0, 1.0),
          ),
          offset: Offset(
            s.offset.dx * clampedShadowFactor,
            s.offset.dy * clampedShadowFactor,
          ),
          blurRadius: s.blurRadius * clampedShadowFactor,
          spreadRadius: s.spreadRadius * clampedShadowFactor,
        );
      }).toList();
    } else if (widget.gradient != null ||
        widget.backgroundColor == AppTheme.primaryTerracotta) {
      effectiveShadows = [
        BoxShadow(
          color: AppTheme.primaryTerracotta.withValues(
            alpha: 0.28 * clampedShadowFactor,
          ),
          offset: Offset(0, 5 * clampedShadowFactor),
          blurRadius: 12 * clampedShadowFactor,
          spreadRadius: 0,
        ),
      ];
    }

    // Assemble child content
    Widget content;
    if (widget.child != null) {
      content = widget.child!;
    } else {
      final List<Widget> rowItems = [];
      if (widget.icon != null && !widget.iconTrailing) {
        rowItems.add(
          IconTheme(
            data: IconThemeData(color: effectiveFg, size: 19),
            child: widget.icon!,
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

      if (widget.icon != null && widget.iconTrailing) {
        rowItems.add(SizedBox(width: widget.iconSpacing));
        rowItems.add(
          IconTheme(
            data: IconThemeData(color: effectiveFg, size: 19),
            child: widget.icon!,
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
        child: Transform(
          transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
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
