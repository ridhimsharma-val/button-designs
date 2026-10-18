import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Personality styles for the Outlined button family.
enum OutlineStyle {
  /// Cream fill, crisp terracotta border, subtle press tint and compression.
  classic,

  /// Smoothly floods to solid terracotta fill with white text on press.
  fillOnPress,

  /// Animated terracotta stroke travels and draws around the rounded perimeter.
  borderDraw,

  /// Concentric double terracotta-toned borders that tighten spacing on press.
  doubleOutline,

  /// Evenly spaced dashed outline with a warm ambient glow that intensifies on press.
  dashAndGlow,
}

/// A high-performance, reusable Flutter outlined button component.
///
/// Features:
/// - Crisp vector border treatments (single, double, dashed, and dynamic traveling stroke)
/// - Zero-latency touch response via [Listener] + [GestureDetector]
/// - Safe gesture cancellation and rapid repeated-tap handling
/// - Reduced-motion accessibility support
class ReusableOutlinedButton extends StatefulWidget {
  const ReusableOutlinedButton({
    super.key,
    this.label = 'Button',
    this.child,
    this.style = OutlineStyle.classic,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.borderWidth = 1.8,
    this.labelStyle,
    this.onPressed,
    this.enabled = true,
    this.hapticFeedback = true,
    this.pressDuration = const Duration(milliseconds: 110),
    this.releaseDuration = const Duration(milliseconds: 240),
  });

  /// Text label displayed inside the button (defaults to "Button").
  final String label;

  /// Custom child widget. Replaces [label] if provided.
  final Widget? child;

  /// Outlined visual and animation style.
  final OutlineStyle style;

  /// Corner radius of the button surface. Defaults to 16.
  final BorderRadius? borderRadius;

  /// Internal padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Stroke width of the primary border. Defaults to 1.8.
  final double borderWidth;

  /// Text style applied to [label].
  final TextStyle? labelStyle;

  /// Callback executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether to fire a light haptic impact on press.
  final bool hapticFeedback;

  /// Duration to compress down on press.
  final Duration pressDuration;

  /// Duration to spring back to rest on release.
  final Duration releaseDuration;

  @override
  State<ReusableOutlinedButton> createState() => _ReusableOutlinedButtonState();
}

class _ReusableOutlinedButtonState extends State<ReusableOutlinedButton>
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
  void didUpdateWidget(covariant ReusableOutlinedButton oldWidget) {
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

    _controller.animateBack(
      0.0,
      duration: widget.releaseDuration,
      curve: const _TastefulSpringCurve(overshoot: 0.045),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;
    final double animValue = _controller.value;
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(16);

    // 1. Calculate Scale
    double currentScale;
    if (_controller.status == AnimationStatus.reverse) {
      final double progress = 1.0 - animValue;
      final double wave = progress < 0.8
          ? math.sin(progress * math.pi) * 0.026
          : 0.0;
      currentScale = 1.0 - (0.046 * animValue) + wave;
    } else {
      currentScale = 1.0 - (0.046 * animValue);
    }

    // 2. Compute Colors based on style and interaction
    Color effectiveBg = AppTheme.mainBackground;
    Color effectiveFg = AppTheme.primaryTerracotta;

    switch (widget.style) {
      case OutlineStyle.classic:
        // Subtle warm press wash
        effectiveBg = Color.lerp(
          AppTheme.mainBackground,
          AppTheme.lightTerracotta.withValues(alpha: 0.55),
          animValue,
        )!;
        effectiveFg = Color.lerp(
          AppTheme.primaryTerracotta,
          AppTheme.darkTerracotta,
          animValue,
        )!;

      case OutlineStyle.fillOnPress:
        // Flood transition from outlined cream to solid terracotta with white text
        effectiveBg = Color.lerp(
          AppTheme.mainBackground,
          AppTheme.primaryTerracotta,
          animValue,
        )!;
        effectiveFg = Color.lerp(
          AppTheme.primaryTerracotta,
          Colors.white,
          animValue,
        )!;

      case OutlineStyle.borderDraw:
        effectiveBg = Color.lerp(
          AppTheme.mainBackground,
          const Color(0xFFFAF3EC),
          animValue,
        )!;
        effectiveFg = AppTheme.primaryTerracotta;

      case OutlineStyle.doubleOutline:
        effectiveBg = Color.lerp(
          AppTheme.mainBackground,
          const Color(0xFFFAF3EC),
          animValue,
        )!;
        effectiveFg = AppTheme.primaryTerracotta;

      case OutlineStyle.dashAndGlow:
        effectiveBg = Color.lerp(
          AppTheme.mainBackground,
          const Color(0xFFFAF3EC),
          animValue,
        )!;
        effectiveFg = AppTheme.primaryTerracotta;
    }

    if (!isInteractive) {
      effectiveFg = effectiveFg.withValues(alpha: 0.5);
    }

    // 3. Compute Shadows (especially for Dash & Glow and Classic)
    List<BoxShadow> effectiveShadows = [];
    if (widget.style == OutlineStyle.dashAndGlow) {
      final double glowAlpha = (0.08 + (animValue * 0.40)).clamp(0.0, 1.0);
      final double glowBlur = 8.0 + (animValue * 12.0);
      final double glowSpread = animValue * 1.5;
      effectiveShadows = [
        BoxShadow(
          color: AppTheme.primaryTerracotta.withValues(alpha: glowAlpha),
          offset: const Offset(0, 3),
          blurRadius: glowBlur,
          spreadRadius: glowSpread,
        ),
      ];
    } else if (widget.style == OutlineStyle.classic ||
        widget.style == OutlineStyle.fillOnPress) {
      effectiveShadows = [
        BoxShadow(
          color: AppTheme.primaryTerracotta.withValues(
            alpha: (0.06 + (animValue * 0.12)).clamp(0.0, 1.0),
          ),
          offset: Offset(0, 3 + animValue * 2),
          blurRadius: 8 + animValue * 4,
          spreadRadius: 0,
        ),
      ];
    }

    // 4. Border Decoration
    BoxBorder? standardBorder;
    if (widget.style == OutlineStyle.classic ||
        widget.style == OutlineStyle.fillOnPress) {
      standardBorder = Border.all(
        color: AppTheme.primaryTerracotta,
        width: widget.borderWidth,
      );
    }

    // 5. Text Label
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
              border: standardBorder,
              boxShadow: effectiveShadows,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Layer A: Border Draw Painter (Variant C)
                  if (widget.style == OutlineStyle.borderDraw)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BorderDrawPainter(
                          borderRadius: radius,
                          progress: animValue,
                          baseColor: AppTheme.primaryTerracotta.withValues(
                            alpha: 0.35,
                          ),
                          activeColor: AppTheme.primaryTerracotta,
                          strokeWidth: widget.borderWidth,
                        ),
                      ),
                    ),

                  // Layer B: Double Outline Painter (Variant D)
                  if (widget.style == OutlineStyle.doubleOutline)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DoubleOutlinePainter(
                          borderRadius: radius,
                          progress: animValue,
                          outerColor: AppTheme.primaryTerracotta,
                          innerColor: AppTheme.darkTerracotta.withValues(
                            alpha: 0.75,
                          ),
                          strokeWidth: 1.3,
                        ),
                      ),
                    ),

                  // Layer C: Dash & Glow Outline Painter (Variant E)
                  if (widget.style == OutlineStyle.dashAndGlow)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DashedOutlinePainter(
                          borderRadius: radius,
                          progress: animValue,
                          color: AppTheme.primaryTerracotta,
                          strokeWidth: widget.borderWidth,
                        ),
                      ),
                    ),

                  // Layer D: Button Content Padding & Label
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
}

/// Painter that draws an animated border that travels around the rounded perimeter.
class _BorderDrawPainter extends CustomPainter {
  const _BorderDrawPainter({
    required this.borderRadius,
    required this.progress,
    required this.baseColor,
    required this.activeColor,
    required this.strokeWidth,
  });

  final BorderRadius borderRadius;
  final double progress; // 0.0 to 1.0
  final Color baseColor;
  final Color activeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect.deflate(strokeWidth / 2));

    final Path path = Path()..addRRect(rrect);
    final PathMetric metric = path.computeMetrics().first;
    final double totalLength = metric.length;

    // 1. Draw subtle resting border
    final Paint basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, basePaint);

    // 2. Draw animated traveling stroke based on interaction progress
    // When progress > 0, stroke grows from 0 to complete perimeter with bright tip
    final double drawLength = totalLength * (0.15 + (progress * 0.85));
    final double start = (progress * totalLength * 0.35) % totalLength;
    final double end = start + drawLength;

    final Paint activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth + (progress * 0.6);

    if (end <= totalLength) {
      canvas.drawPath(metric.extractPath(start, end), activePaint);
    } else {
      canvas.drawPath(metric.extractPath(start, totalLength), activePaint);
      canvas.drawPath(metric.extractPath(0.0, end - totalLength), activePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderDrawPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.baseColor != baseColor;
  }
}

/// Painter that renders two concentric, carefully spaced borders.
class _DoubleOutlinePainter extends CustomPainter {
  const _DoubleOutlinePainter({
    required this.borderRadius,
    required this.progress,
    required this.outerColor,
    required this.innerColor,
    required this.strokeWidth,
  });

  final BorderRadius borderRadius;
  final double progress; // 0.0 to 1.0
  final Color outerColor;
  final Color innerColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    // Outer border
    final RRect outerRRect = borderRadius.toRRect(
      rect.deflate(strokeWidth / 2),
    );
    final Paint outerPaint = Paint()
      ..color = outerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + (progress * 0.3);
    canvas.drawRRect(outerRRect, outerPaint);

    // Inner border: spacing tightens from 3.2px to 2.2px on press
    final double spacing = 3.2 - (progress * 1.0);
    final RRect innerRRect = borderRadius.toRRect(
      rect.deflate(strokeWidth + spacing),
    );
    final Paint innerPaint = Paint()
      ..color = Color.lerp(innerColor, outerColor, progress)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(innerRRect, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DoubleOutlinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.outerColor != outerColor ||
        oldDelegate.innerColor != innerColor;
  }
}

/// Painter that renders an evenly spaced dashed rounded border.
class _DashedOutlinePainter extends CustomPainter {
  const _DashedOutlinePainter({
    required this.borderRadius,
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final BorderRadius borderRadius;
  final double progress; // 0.0 to 1.0
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect.deflate(strokeWidth / 2));

    final Path path = Path()..addRRect(rrect);
    final PathMetric metric = path.computeMetrics().first;
    final double totalLength = metric.length;

    const double dashWidth = 6.0;
    const double dashSpace = 4.0;
    const double step = dashWidth + dashSpace;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth + (progress * 0.4);

    final double phaseShift = progress * step * 0.8;
    double distance = phaseShift;

    while (distance < totalLength) {
      final double end = math.min(distance + dashWidth, totalLength);
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance += step;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedOutlinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
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
