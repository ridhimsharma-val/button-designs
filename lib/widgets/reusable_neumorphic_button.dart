import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Distinct personality styles for the Neumorphic button family.
enum NeumorphicStyle {
  /// Soft cream molded clay, transitioning raised outer shadows into a subtle inset appearance.
  softClay,

  /// High-contrast tactile sinking from raised to a deep recessed state with opposing inner shadows.
  deepPress,

  /// Lightweight, ambient floating elevation with restrained spring-back upon release.
  floatAndSettle,

  /// Sculpted terracotta surface with warm, muted highlights and dark terracotta shadows.
  terracottaClay,

  /// Contained inner tonal wave / radial highlight bloom on press with soft inset transition.
  ripplePress,
}

/// A high-performance, reusable Flutter neumorphic button component.
///
/// Features:
/// - True dual opposing light and dark shadows
/// - Photorealistic, hardware-accelerated inset / recessed shadows
/// - Contained inner ripple / tonal wave for [NeumorphicStyle.ripplePress]
/// - Zero-latency touch response via [Listener] + [GestureDetector]
/// - Safe gesture cancellation and rapid repeated-tap handling
/// - Reduced-motion accessibility support
class ReusableNeumorphicButton extends StatefulWidget {
  const ReusableNeumorphicButton({
    super.key,
    this.label = 'Button',
    this.child,
    this.style = NeumorphicStyle.softClay,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.labelStyle,
    this.onPressed,
    this.enabled = true,
    this.hapticFeedback = true,
    this.pressDuration = const Duration(milliseconds: 120),
    this.releaseDuration = const Duration(milliseconds: 260),
  });

  /// Text label displayed inside the button (defaults to "Button").
  final String label;

  /// Custom child widget. Replaces [label] if provided.
  final Widget? child;

  /// Neumorphic visual and animation personality style.
  final NeumorphicStyle style;

  /// Custom surface background color. Defaults according to [style].
  final Color? backgroundColor;

  /// Text and element tint color. Defaults according to [style].
  final Color? foregroundColor;

  /// Corner radius of the button surface. Defaults to 16.
  final BorderRadius? borderRadius;

  /// Internal padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Text style applied to [label].
  final TextStyle? labelStyle;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether to fire a light haptic impact on press.
  final bool hapticFeedback;

  /// Duration to transition into the pressed / recessed state.
  final Duration pressDuration;

  /// Duration to return smoothly to the raised resting state.
  final Duration releaseDuration;

  @override
  State<ReusableNeumorphicButton> createState() =>
      _ReusableNeumorphicButtonState();
}

class _ReusableNeumorphicButtonState extends State<ReusableNeumorphicButton>
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
  void didUpdateWidget(covariant ReusableNeumorphicButton oldWidget) {
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

    final Curve reverseCurve = switch (widget.style) {
      NeumorphicStyle.floatAndSettle => const _FloatRestrainedSpringCurve(
        overshoot: 0.045,
      ),
      _ => Curves.easeOutCubic,
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
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(16);

    // 1. Resolve Surface & Foreground Colors
    final Color defaultBg = switch (widget.style) {
      NeumorphicStyle.terracottaClay => AppTheme.primaryTerracotta,
      _ => widget.backgroundColor ?? AppTheme.mainBackground,
    };

    final Color defaultFg = switch (widget.style) {
      NeumorphicStyle.terracottaClay => AppTheme.mainBackground,
      _ => widget.foregroundColor ?? AppTheme.primaryTerracotta,
    };

    Color effectiveBg = defaultBg;
    if (widget.style == NeumorphicStyle.deepPress && animValue > 0) {
      // Subtly sink surface tint on deep press
      effectiveBg = Color.lerp(defaultBg, const Color(0xFFF5ECE2), animValue)!;
    }

    final Color effectiveFg = isInteractive
        ? defaultFg
        : defaultFg.withValues(alpha: 0.55);

    // 2. Calculate Animated Scale
    double currentScale;
    if (_controller.status == AnimationStatus.reverse &&
        widget.style == NeumorphicStyle.floatAndSettle) {
      // Gentle restrained spring overshoot on rising
      final double progress = 1.0 - animValue;
      final double wave = progress < 0.85
          ? math.sin(progress * math.pi) * 0.016
          : 0.0;
      currentScale = 1.0 - (0.035 * animValue) + wave;
    } else {
      final double maxCompression = switch (widget.style) {
        NeumorphicStyle.softClay => 0.028,
        NeumorphicStyle.deepPress => 0.038,
        NeumorphicStyle.floatAndSettle => 0.035,
        NeumorphicStyle.terracottaClay => 0.042,
        NeumorphicStyle.ripplePress => 0.032,
      };
      currentScale = 1.0 - (maxCompression * animValue);
    }

    // 3. Compute Outer Raised Shadows
    final List<BoxShadow> outerShadows = _computeOuterShadows(
      style: widget.style,
      t: animValue,
    );

    // 4. Inset Shadow Configuration
    final _InsetShadowConfig insetConfig = _computeInsetShadowConfig(
      style: widget.style,
      t: animValue,
    );

    // 5. Button Text Content
    final Widget labelWidget =
        widget.child ??
        Text(
          widget.label,
          style:
              (widget.labelStyle ??
                      const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.15,
                      ))
                  .copyWith(color: effectiveFg),
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
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: radius,
              boxShadow: outerShadows,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Layer A: Inset / Inner Shadow Painter
                  if (insetConfig.progress > 0.005)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _NeumorphicInnerShadowPainter(
                          borderRadius: radius,
                          progress: insetConfig.progress,
                          topLeftColor: insetConfig.topLeftColor,
                          bottomRightColor: insetConfig.bottomRightColor,
                          blurRadius: insetConfig.blurRadius,
                          depth: insetConfig.depth,
                        ),
                      ),
                    ),

                  // Layer B: Ripple / Inner Tonal Wave Painter (Variant E)
                  if (widget.style == NeumorphicStyle.ripplePress &&
                      animValue > 0.005)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _NeumorphicRipplePainter(
                          borderRadius: radius,
                          progress: animValue,
                          rippleColor: Colors.white,
                        ),
                      ),
                    ),

                  // Layer C: Button Content Padding & Label
                  Padding(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                    child: labelWidget,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Calculates the outer raised shadows for each neumorphic personality style.
  List<BoxShadow> _computeOuterShadows({
    required NeumorphicStyle style,
    required double t,
  }) {
    switch (style) {
      case NeumorphicStyle.softClay:
        // Warm opposing shadows that deflate on press
        final double factor = (1.0 - t * 0.88).clamp(0.08, 1.0);
        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.95 * factor),
            offset: Offset(-3.5 * factor, -3.5 * factor),
            blurRadius: 7 * factor,
            spreadRadius: 0.5 * factor,
          ),
          BoxShadow(
            color: AppTheme.warmNeutral.withValues(alpha: 0.80 * factor),
            offset: Offset(4 * factor, 5 * factor),
            blurRadius: 9 * factor,
            spreadRadius: 0.5 * factor,
          ),
        ];

      case NeumorphicStyle.deepPress:
        // Outer shadows almost vanish as button sinks into the surface
        final double factor = (1.0 - t * 0.96).clamp(0.04, 1.0);
        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.95 * factor),
            offset: Offset(-3.5 * factor, -3.5 * factor),
            blurRadius: 7 * factor,
            spreadRadius: 0.5 * factor,
          ),
          BoxShadow(
            color: AppTheme.warmNeutral.withValues(alpha: 0.82 * factor),
            offset: Offset(4 * factor, 5 * factor),
            blurRadius: 9 * factor,
            spreadRadius: 0.5 * factor,
          ),
        ];

      case NeumorphicStyle.floatAndSettle:
        // Elevated floating shadows that contract toward the surface on press
        final double elevation = (1.0 - t * 0.85).clamp(0.12, 1.0);
        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.98 * elevation),
            offset: Offset(-5 * elevation, -5 * elevation),
            blurRadius: 13 * elevation,
            spreadRadius: 0.5 * elevation,
          ),
          BoxShadow(
            color: AppTheme.warmNeutral.withValues(alpha: 0.85 * elevation),
            offset: Offset(5 * elevation, 7 * elevation),
            blurRadius: 15 * elevation,
            spreadRadius: 0.5 * elevation,
          ),
          BoxShadow(
            color: AppTheme.primaryTerracotta.withValues(
              alpha: 0.07 * elevation,
            ),
            offset: Offset(0, 6 * elevation),
            blurRadius: 14 * elevation,
            spreadRadius: 0,
          ),
        ];

      case NeumorphicStyle.terracottaClay:
        // Sculpted terracotta with warm lighter highlight and dark terracotta shadow
        final double factor = (1.0 - t * 0.82).clamp(0.15, 1.0);
        return [
          BoxShadow(
            color: const Color(0xFFE58866).withValues(alpha: 0.50 * factor),
            offset: Offset(-3.5 * factor, -3.5 * factor),
            blurRadius: 7 * factor,
            spreadRadius: 0.5 * factor,
          ),
          BoxShadow(
            color: AppTheme.darkTerracotta.withValues(alpha: 0.55 * factor),
            offset: Offset(4 * factor, 5 * factor),
            blurRadius: 11 * factor,
            spreadRadius: 0.5 * factor,
          ),
        ];

      case NeumorphicStyle.ripplePress:
        // Soft raised shadows that deflate as inner ripple blooms
        final double factor = (1.0 - t * 0.82).clamp(0.12, 1.0);
        return [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.95 * factor),
            offset: Offset(-3.5 * factor, -3.5 * factor),
            blurRadius: 7 * factor,
            spreadRadius: 0.5 * factor,
          ),
          BoxShadow(
            color: AppTheme.warmNeutral.withValues(alpha: 0.78 * factor),
            offset: Offset(4 * factor, 5 * factor),
            blurRadius: 9 * factor,
            spreadRadius: 0.5 * factor,
          ),
        ];
    }
  }

  /// Calculates the inner / recessed shadow parameters.
  _InsetShadowConfig _computeInsetShadowConfig({
    required NeumorphicStyle style,
    required double t,
  }) {
    switch (style) {
      case NeumorphicStyle.softClay:
        return _InsetShadowConfig(
          progress: t,
          topLeftColor: AppTheme.warmNeutral.withValues(alpha: 0.70),
          bottomRightColor: Colors.white.withValues(alpha: 0.88),
          depth: 3.0,
          blurRadius: 5.5,
        );

      case NeumorphicStyle.deepPress:
        return _InsetShadowConfig(
          progress: t,
          topLeftColor: const Color(0xFFB8A294).withValues(alpha: 0.80),
          bottomRightColor: Colors.white.withValues(alpha: 0.95),
          depth: 4.0,
          blurRadius: 7.0,
        );

      case NeumorphicStyle.floatAndSettle:
        // Float and settle does not become deeply inset; it flattens to the floor
        return const _InsetShadowConfig(
          progress: 0.0,
          topLeftColor: Colors.transparent,
          bottomRightColor: Colors.transparent,
          depth: 0,
          blurRadius: 0,
        );

      case NeumorphicStyle.terracottaClay:
        return _InsetShadowConfig(
          progress: t,
          topLeftColor: AppTheme.darkTerracotta.withValues(alpha: 0.70),
          bottomRightColor: const Color(0xFFE58866).withValues(alpha: 0.45),
          depth: 3.2,
          blurRadius: 5.5,
        );

      case NeumorphicStyle.ripplePress:
        return _InsetShadowConfig(
          progress: t * 0.75,
          topLeftColor: AppTheme.warmNeutral.withValues(alpha: 0.55),
          bottomRightColor: Colors.white.withValues(alpha: 0.75),
          depth: 2.6,
          blurRadius: 4.8,
        );
    }
  }
}

/// Parameters for rendering an inset / recessed shadow.
class _InsetShadowConfig {
  const _InsetShadowConfig({
    required this.progress,
    required this.topLeftColor,
    required this.bottomRightColor,
    required this.depth,
    required this.blurRadius,
  });

  final double progress;
  final Color topLeftColor;
  final Color bottomRightColor;
  final double depth;
  final double blurRadius;
}

/// Custom painter that renders true, soft inset shadows inside an [RRect].
class _NeumorphicInnerShadowPainter extends CustomPainter {
  const _NeumorphicInnerShadowPainter({
    required this.borderRadius,
    required this.progress,
    required this.topLeftColor,
    required this.bottomRightColor,
    required this.blurRadius,
    required this.depth,
  });

  final BorderRadius borderRadius;
  final double progress;
  final Color topLeftColor;
  final Color bottomRightColor;
  final double blurRadius;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.005) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    final double activeBlur = blurRadius * progress;
    final double activeDepth = depth * progress;

    final Path rrectPath = Path()..addRRect(rrect);
    final Path outerPath = Path()
      ..addRect(rect.inflate(activeBlur * 3.5 + activeDepth * 2));
    final Path diff = Path.combine(
      PathOperation.difference,
      outerPath,
      rrectPath,
    );

    // 1. Top-left dark inset shadow
    if (topLeftColor.a > 0) {
      final Paint topPaint = Paint()
        ..color = topLeftColor.withValues(alpha: topLeftColor.a * progress)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, activeBlur);

      canvas.save();
      canvas.translate(activeDepth, activeDepth);
      canvas.drawPath(diff, topPaint);
      canvas.restore();
    }

    // 2. Bottom-right light inset highlight
    if (bottomRightColor.a > 0) {
      final Paint bottomPaint = Paint()
        ..color = bottomRightColor.withValues(
          alpha: bottomRightColor.a * progress,
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, activeBlur);

      canvas.save();
      canvas.translate(-activeDepth, -activeDepth);
      canvas.drawPath(diff, bottomPaint);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeumorphicInnerShadowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.topLeftColor != topLeftColor ||
        oldDelegate.bottomRightColor != bottomRightColor;
  }
}

/// Custom painter that renders a soft expanding radial highlight bloom inside the button.
class _NeumorphicRipplePainter extends CustomPainter {
  const _NeumorphicRipplePainter({
    required this.borderRadius,
    required this.progress,
    required this.rippleColor,
  });

  final BorderRadius borderRadius;
  final double progress;
  final Color rippleColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.005) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height) * 0.55;
    final double currentRadius = maxRadius * (0.2 + 0.8 * progress);

    final double alpha = (0.22 * (1.0 - progress * 0.4)).clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..shader = RadialGradient(
        colors: [
          rippleColor.withValues(alpha: alpha),
          rippleColor.withValues(alpha: alpha * 0.4),
          rippleColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius));

    canvas.drawCircle(center, currentRadius, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NeumorphicRipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.rippleColor != rippleColor;
  }
}

/// Spring curve with restrained overshoot for a gentle rising motion.
class _FloatRestrainedSpringCurve extends Curve {
  const _FloatRestrainedSpringCurve({this.overshoot = 0.045});

  final double overshoot;

  @override
  double transformInternal(double t) {
    if (t >= 1.0) return 1.0;
    if (t <= 0.0) return 0.0;
    final double decay = math.exp(-4.2 * t);
    final double osc = math.cos(t * math.pi * 2.0);
    return 1.0 - (decay * osc * (1.0 + overshoot));
  }
}
