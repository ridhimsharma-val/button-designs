import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Distinct personality styles for the Liquid Glass button family.
enum GlassStyle {
  /// Frosted glass capsule with reflective white-to-terracotta rim and top gloss.
  frostedGlass,

  /// Translucent glass with an animated luminous light streak along the border on press.
  liquidGlow,

  /// Milky glass with shifting pearlescent champagne and peach iridescent reflections.
  prismGlass,

  /// Deep smoked charcoal-brown translucent glass with warm terracotta edge illumination.
  smokedGlass,

  /// Translucent cream glass with fluid inner expanding ripple wave from touch point.
  liquidRipple,
}

/// A high-performance, reusable Flutter liquid-glass button component with genuine
/// optical reflections, distinct specular highlights, translucent layering,
/// and physical glass touch physics.
class ReusableGlassButton extends StatefulWidget {
  const ReusableGlassButton({
    super.key,
    this.label = 'Button',
    this.child,
    this.style = GlassStyle.frostedGlass,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.labelStyle,
    this.onPressed,
    this.enabled = true,
    this.hapticFeedback = true,
    this.pressDuration = const Duration(milliseconds: 180),
    this.releaseDuration = const Duration(milliseconds: 280),
  });

  /// Text label displayed inside the button (defaults to "Button").
  final String label;

  /// Custom child widget. Replaces [label] if provided.
  final Widget? child;

  /// Liquid glass visual and interaction personality.
  final GlassStyle style;

  /// Corner radius of the button surface. Defaults to 20 or circular pill.
  final BorderRadius? borderRadius;

  /// Internal padding for the button.
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Text style applied to [label].
  final TextStyle? labelStyle;

  /// Callback executed when tapped.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// Whether to fire a light haptic impact on press.
  final bool hapticFeedback;

  /// Duration to compress on press.
  final Duration pressDuration;

  /// Duration to spring back to rest on release.
  final Duration releaseDuration;

  @override
  State<ReusableGlassButton> createState() => _ReusableGlassButtonState();
}

class _ReusableGlassButtonState extends State<ReusableGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _disableAnimations = false;
  Offset _localTouchPoint = const Offset(100, 26);

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
  void didUpdateWidget(covariant ReusableGlassButton oldWidget) {
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

  void _pressIn(Offset localPosition) {
    if (!mounted || !widget.enabled || widget.onPressed == null) return;

    _localTouchPoint = localPosition;

    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

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
      return;
    }

    _pressController.animateBack(
      0.0,
      duration: widget.releaseDuration,
      curve: const _TastefulSpringCurve(overshoot: 0.035),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = widget.enabled && widget.onPressed != null;
    final double animValue = _pressController.value;
    final BorderRadius radius =
        widget.borderRadius ?? BorderRadius.circular(20);

    // 1. Calculate Scale Compression
    double currentScale;
    if (_pressController.status == AnimationStatus.reverse) {
      final double progress = 1.0 - animValue;
      final double wave = progress < 0.8
          ? math.sin(progress * math.pi) * 0.02
          : 0.0;
      currentScale = 1.0 - (0.04 * animValue) + wave;
    } else {
      currentScale = 1.0 - (0.04 * animValue);
    }

    // 2. Resolve Text Foreground
    final Color textColor = widget.style == GlassStyle.smokedGlass
        ? const Color(0xFFFFF8F2)
        : AppTheme.primaryTerracotta;

    final Color effectiveFg = isInteractive
        ? textColor
        : textColor.withValues(alpha: 0.5);

    // 3. Resolve Specular Shadows & Ambient Glass Depth
    final List<BoxShadow> effectiveShadows = _computeShadows(
      style: widget.style,
      t: animValue,
    );

    // 4. Resolve Base Translucent Gradient
    final Gradient baseGradient = _computeBaseGradient(
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
                      TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.25,
                        shadows: widget.style == GlassStyle.smokedGlass
                            ? [
                                Shadow(
                                  color: AppTheme.primaryTerracotta.withValues(
                                    alpha: 0.6 + animValue * 0.35,
                                  ),
                                  blurRadius: 8 + animValue * 4,
                                ),
                              ]
                            : [
                                Shadow(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                ),
                              ],
                      ))
                  .copyWith(color: effectiveFg),
        );

    // 6. Build the Glass Surface Container with layered CustomPainters
    Widget transformedContainer = Transform.scale(
      scale: currentScale,
      alignment: Alignment.center,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: effectiveShadows,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            // Subtle frosted backdrop blur across the canvas
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: baseGradient,
                borderRadius: radius,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- Layer 1: Glass Optical Chamfer & Rim Painter (All Styles) ---
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GlassOpticalRimPainter(
                        borderRadius: radius,
                        style: widget.style,
                        t: animValue,
                      ),
                    ),
                  ),

                  // --- Layer 2: Variant-Specific Glass Personalities ---

                  // Variant A: Frosted Glass — Curved Specular Lens Highlight
                  if (widget.style == GlassStyle.frostedGlass)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _FrostedGlassLensPainter(
                          borderRadius: radius,
                          t: animValue,
                        ),
                      ),
                    ),

                  // Variant B: Liquid Glow — Luminous Traveling Perimeter Streak
                  if (widget.style == GlassStyle.liquidGlow)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LightStreakPainter(
                          borderRadius: radius,
                          progress: animValue,
                          streakColor: const Color(0xFFFFF3EB),
                          glowColor: AppTheme.primaryTerracotta,
                        ),
                      ),
                    ),

                  // Variant C: Prism Glass — Iridescent Champagne / Peach Specular Sheen
                  if (widget.style == GlassStyle.prismGlass)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PrismGlassSpecularPainter(
                          borderRadius: radius,
                          t: animValue,
                        ),
                      ),
                    ),

                  // Variant D: Smoked Glass — Inner Obsidian Depth & Terracotta Horizon Reflection
                  if (widget.style == GlassStyle.smokedGlass)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SmokedGlassDepthPainter(
                          borderRadius: radius,
                          t: animValue,
                        ),
                      ),
                    ),

                  // Variant E: Liquid Ripple — Fluid Refractive Wave & Touch Highlight
                  if (widget.style == GlassStyle.liquidRipple)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _FluidGlassRipplePainter(
                          borderRadius: radius,
                          progress: animValue,
                          touchPoint: _localTouchPoint,
                          rippleColor: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),

                  // --- Layer 3: Interactive Text Label ---
                  Padding(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(
                          horizontal: 42,
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

    // Apply 3D Perspective Rotation specifically for Prism Glass
    if (widget.style == GlassStyle.prismGlass && animValue > 0.0) {
      transformedContainer = Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          ..rotateX(-animValue * 0.045)
          ..rotateY(animValue * 0.05),
        alignment: Alignment.center,
        child: transformedContainer,
      );
    }

    return Listener(
      onPointerDown: isInteractive
          ? (details) => _pressIn(details.localPosition)
          : null,
      onPointerUp: isInteractive ? (_) => _triggerRelease() : null,
      onPointerCancel: isInteractive ? (_) => _triggerRelease() : null,
      behavior: HitTestBehavior.opaque,
      child: GestureDetector(
        onTap: isInteractive ? widget.onPressed : null,
        behavior: HitTestBehavior.opaque,
        child: transformedContainer,
      ),
    );
  }

  /// Calculates outer shadows creating genuine elevated glass depth.
  List<BoxShadow> _computeShadows({
    required GlassStyle style,
    required double t,
  }) {
    switch (style) {
      case GlassStyle.frostedGlass:
        return [
          // Soft warm ambient drop
          BoxShadow(
            color: const Color(0xFF6B4538)
                .withValues(alpha: (0.11 - t * 0.03).clamp(0.04, 1.0)),
            offset: Offset(0, 7 - t * 2.5),
            blurRadius: 18 - t * 4,
            spreadRadius: -2,
          ),
          // Direct bottom contact occlusion
          BoxShadow(
            color: AppTheme.primaryTerracotta.withValues(
              alpha: (0.07 - t * 0.02).clamp(0.02, 1.0),
            ),
            offset: Offset(0, 2 - t * 0.5),
            blurRadius: 5,
          ),
        ];

      case GlassStyle.liquidGlow:
        // Subtle resting shadow; on press, an elegant thin edge glow emerges
        final double glowAlpha = (0.12 + t * 0.38).clamp(0.0, 1.0);
        return [
          BoxShadow(
            color: AppTheme.primaryTerracotta.withValues(alpha: glowAlpha),
            offset: Offset(0, 3 + t * 1.5),
            blurRadius: 12 + t * 8,
            spreadRadius: 0.5 + t * 1.2,
          ),
          BoxShadow(
            color: const Color(0xFF6B4538)
                .withValues(alpha: (0.09 - t * 0.02).clamp(0.03, 1.0)),
            offset: Offset(0, 5 - t * 2),
            blurRadius: 14 - t * 3,
            spreadRadius: -2,
          ),
        ];

      case GlassStyle.prismGlass:
        return [
          BoxShadow(
            color: const Color(0xFF6B4538)
                .withValues(alpha: (0.10 - t * 0.03).clamp(0.04, 1.0)),
            offset: Offset(0, 6 - t * 2),
            blurRadius: 16 - t * 4,
            spreadRadius: -2,
          ),
          // Shifting peach-champagne rim reflection glow on press
          BoxShadow(
            color: const Color(0xFFE89674)
                .withValues(alpha: (0.08 + t * 0.20).clamp(0.0, 1.0)),
            offset: Offset(t * 3, 2),
            blurRadius: 10 + t * 4,
          ),
        ];

      case GlassStyle.smokedGlass:
        return [
          // Deep obsidian dark glass drop
          BoxShadow(
            color: const Color(0xFF140B07)
                .withValues(alpha: (0.32 - t * 0.06).clamp(0.12, 1.0)),
            offset: Offset(0, 8 - t * 3),
            blurRadius: 20 - t * 5,
            spreadRadius: -1,
          ),
          // Interactive intense terracotta edge glow on press
          BoxShadow(
            color: AppTheme.primaryTerracotta.withValues(
              alpha: (0.20 + t * 0.45).clamp(0.0, 1.0),
            ),
            offset: Offset(0, 2 + t * 2),
            blurRadius: 12 + t * 12,
            spreadRadius: 0.8 + t * 2.5,
          ),
        ];

      case GlassStyle.liquidRipple:
        return [
          BoxShadow(
            color: const Color(0xFF6B4538)
                .withValues(alpha: (0.11 - t * 0.03).clamp(0.04, 1.0)),
            offset: Offset(0, 7 - t * 2.5),
            blurRadius: 18 - t * 4,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Colors.white.withValues(
              alpha: (0.60 - t * 0.20).clamp(0.0, 1.0),
            ),
            offset: const Offset(0, -1),
            blurRadius: 3,
          ),
        ];
    }
  }

  /// Calculates the translucent glass base fill gradient per style.
  Gradient _computeBaseGradient({
    required GlassStyle style,
    required double t,
  }) {
    switch (style) {
      case GlassStyle.frostedGlass:
        // Visibly translucent semi-transparent glass with subtle warm tint
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.46 - t * 0.06),
            const Color(0xFFFAF3EC).withValues(alpha: 0.22 - t * 0.04),
            AppTheme.lightTerracotta.withValues(alpha: 0.28 + t * 0.08),
          ],
          stops: const [0.0, 0.55, 1.0],
        );

      case GlassStyle.liquidGlow:
        // Crisp resting glass with inner light warming on press
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.48),
            const Color(0xFFFAF2EB).withValues(alpha: 0.25),
            Color.lerp(
              const Color(0xFFF7E3D8).withValues(alpha: 0.28),
              AppTheme.primaryTerracotta.withValues(alpha: 0.22),
              t,
            )!,
          ],
          stops: const [0.0, 0.50, 1.0],
        );

      case GlassStyle.prismGlass:
        // Milky pearlescent glass surface with delicate champagne tint
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.52 - t * 0.05),
            const Color(0xFFFFF2E6).withValues(alpha: 0.32),
            const Color(0xFFFCE4D6).withValues(alpha: 0.38 + t * 0.08),
          ],
          stops: const [0.0, 0.50, 1.0],
        );

      case GlassStyle.smokedGlass:
        // Dramatic dark translucent charcoal-brown glass with rich refractive depth
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF382620).withValues(alpha: 0.72 - t * 0.04),
            const Color(0xFF241510).withValues(alpha: 0.85),
            Color.lerp(
              const Color(0xFF1B0E0A).withValues(alpha: 0.92),
              const Color(0xFF472116).withValues(alpha: 0.94),
              t,
            )!,
          ],
          stops: const [0.0, 0.48, 1.0],
        );

      case GlassStyle.liquidRipple:
        // Translucent liquid water-glass
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.45 - t * 0.05),
            const Color(0xFFFBF4ED).withValues(alpha: 0.24),
            AppTheme.lightTerracotta.withValues(alpha: 0.26 + t * 0.06),
          ],
          stops: const [0.0, 0.52, 1.0],
        );
    }
  }
}

/// Custom painter for the optical glass rim with chamfered specular edge.
/// Draws a bright top highlight rim, fine reflective perimeter, and darker grounded bottom rim.
class _GlassOpticalRimPainter extends CustomPainter {
  const _GlassOpticalRimPainter({
    required this.borderRadius,
    required this.style,
    required this.t,
  });

  final BorderRadius borderRadius;
  final GlassStyle style;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect outerRRect = borderRadius.toRRect(rect.deflate(0.6));

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style == GlassStyle.smokedGlass ? 1.4 : 1.25;

    switch (style) {
      case GlassStyle.frostedGlass:
        // Brighter top-edge highlight, darker warm lower edge
        borderPaint.shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: (0.95 - t * 0.15).clamp(0.0, 1.0)),
            Colors.white.withValues(alpha: 0.35),
            AppTheme.primaryTerracotta.withValues(
              alpha: (0.28 + t * 0.15).clamp(0.0, 1.0),
            ),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect);
        canvas.drawRRect(outerRRect, borderPaint);
        break;

      case GlassStyle.liquidGlow:
        // Thin illuminated edge: white resting rim, smooth terracotta glow transition on press
        borderPaint.shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.90),
            Color.lerp(
              Colors.white.withValues(alpha: 0.45),
              AppTheme.primaryTerracotta.withValues(alpha: 0.85),
              t,
            )!,
            Color.lerp(
              const Color(0xFFE9D5C5).withValues(alpha: 0.40),
              AppTheme.darkTerracotta.withValues(alpha: 0.90),
              t,
            )!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect);
        canvas.drawRRect(outerRRect, borderPaint);
        break;

      case GlassStyle.prismGlass:
        // Reflective pearlescent rim shifting angle with touch
        borderPaint.shader = SweepGradient(
          center: Alignment(0.0 + t * 0.4, -0.2),
          colors: [
            Colors.white.withValues(alpha: 0.95),
            const Color(0xFFFDE8DD).withValues(alpha: 0.85),
            Colors.white.withValues(alpha: 0.40),
            const Color(0xFFF3C2AF).withValues(alpha: 0.65),
            Colors.white.withValues(alpha: 0.95),
          ],
          stops: const [0.0, 0.28, 0.55, 0.82, 1.0],
        ).createShader(rect);
        canvas.drawRRect(outerRRect, borderPaint);
        break;

      case GlassStyle.smokedGlass:
        // Thin glowing terracotta rim that responds dynamically to touch
        borderPaint.shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: (0.45 + t * 0.25).clamp(0.0, 1.0)),
            Color.lerp(
              AppTheme.primaryTerracotta.withValues(alpha: 0.45),
              AppTheme.primaryTerracotta.withValues(alpha: 0.95),
              t,
            )!,
            Color.lerp(
              AppTheme.darkTerracotta.withValues(alpha: 0.55),
              const Color(0xFFE26D45).withValues(alpha: 1.0),
              t,
            )!,
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(rect);
        canvas.drawRRect(outerRRect, borderPaint);
        break;

      case GlassStyle.liquidRipple:
        // Clear curved crystal rim with responsive top specular gleam
        borderPaint.shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: (0.92 - t * 0.12).clamp(0.0, 1.0)),
            Colors.white.withValues(alpha: 0.30),
            const Color(0xFFE5C3B3)
                .withValues(alpha: (0.35 + t * 0.10).clamp(0.0, 1.0)),
          ],
          stops: const [0.0, 0.50, 1.0],
        ).createShader(rect);
        canvas.drawRRect(outerRRect, borderPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _GlassOpticalRimPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.style != style ||
        oldDelegate.borderRadius != borderRadius;
  }
}

/// Custom painter for Variant A: Frosted Glass.
/// Renders an authentic curved glass lens reflection highlight that shifts on press.
class _FrostedGlassLensPainter extends CustomPainter {
  const _FrostedGlassLensPainter({required this.borderRadius, required this.t});

  final BorderRadius borderRadius;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // 1. Top Specular Glare (curved glass meniscus)
    final double glareHeight = size.height * (0.46 - t * 0.08);
    final Path glarePath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, glareHeight * 0.5)
      ..quadraticBezierTo(
        size.width * 0.5,
        glareHeight * (1.15 + t * 0.25),
        0,
        glareHeight * 0.5,
      )
      ..close();

    final Paint glarePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: (0.58 - t * 0.15).clamp(0.0, 1.0)),
          Colors.white.withValues(alpha: (0.16 - t * 0.06).clamp(0.0, 1.0)),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, glareHeight));

    canvas.drawPath(glarePath, glarePaint);

    // 2. Subtle Bottom Frosted Glow
    final Rect bottomRect = Rect.fromLTWH(
      0,
      size.height * 0.65,
      size.width,
      size.height * 0.35,
    );
    final Paint bottomGlow = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryTerracotta.withValues(alpha: 0.0),
          AppTheme.primaryTerracotta.withValues(
            alpha: (0.09 + t * 0.08).clamp(0.0, 1.0),
          ),
        ],
      ).createShader(bottomRect);

    canvas.drawRect(bottomRect, bottomGlow);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FrostedGlassLensPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.borderRadius != borderRadius;
  }
}

/// Custom painter for Variant B: Liquid Glow.
/// Renders an illuminated light streak traveling along the button border on tap.
class _LightStreakPainter extends CustomPainter {
  const _LightStreakPainter({
    required this.borderRadius,
    required this.progress,
    required this.streakColor,
    required this.glowColor,
  });

  final BorderRadius borderRadius;
  final double progress; // 0.0 to 1.0
  final Color streakColor;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.005) return;

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect.deflate(0.7));

    final Path path = Path()..addRRect(rrect);
    final PathMetric metric = path.computeMetrics().first;
    final double totalLength = metric.length;

    // Smooth traveling streak around the border
    final double streakLength = totalLength * 0.35;
    final double start = (progress * totalLength * 1.5) % totalLength;
    final double end = start + streakLength;

    final double opacity = (math.sin(progress * math.pi)).clamp(0.0, 1.0);

    // Thin illuminated edge with soft glow
    final Paint glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.75 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

    final Paint corePaint = Paint()
      ..color = streakColor.withValues(alpha: 0.98 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;

    if (end <= totalLength) {
      final Path segment = metric.extractPath(start, end);
      canvas.drawPath(segment, glowPaint);
      canvas.drawPath(segment, corePaint);
    } else {
      final Path seg1 = metric.extractPath(start, totalLength);
      final Path seg2 = metric.extractPath(0.0, end - totalLength);
      canvas.drawPath(seg1, glowPaint);
      canvas.drawPath(seg2, glowPaint);
      canvas.drawPath(seg1, corePaint);
      canvas.drawPath(seg2, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LightStreakPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom painter for Variant C: Prism Glass.
/// Renders dynamic peach & champagne refractive bands and a glossy curved highlight that moves on interaction.
class _PrismGlassSpecularPainter extends CustomPainter {
  const _PrismGlassSpecularPainter({
    required this.borderRadius,
    required this.t,
  });

  final BorderRadius borderRadius;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // 1. Moving Refractive Peach/Champagne Waves across the surface
    final double shiftX = (t - 0.5) * size.width * 0.45;
    final Rect waveRect = Rect.fromCenter(
      center: Offset(size.width * 0.5 + shiftX, size.height * 0.5),
      width: size.width * 1.4,
      height: size.height * 1.4,
    );

    final Paint prismPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.0),
          const Color(0xFFFEE8DC).withValues(alpha: 0.32 + t * 0.18),
          const Color(0xFFFFD9C5).withValues(alpha: 0.38 + t * 0.20),
          const Color(0xFFF9EDD9).withValues(alpha: 0.25 + t * 0.15),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.32, 0.54, 0.76, 1.0],
      ).createShader(waveRect);

    canvas.drawRect(rect, prismPaint);

    // 2. Glossy Curved Highlight that changes position and angle during interaction
    final double curveApexY = size.height * (0.35 + t * 0.20);
    final Path highlightPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * (0.50 + t * 0.15),
        curveApexY,
        0,
        size.height * (0.28 - t * 0.08),
      )
      ..close();

    final Paint highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: (0.62 - t * 0.18).clamp(0.0, 1.0)),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.85],
      ).createShader(Rect.fromLTWH(0, 0, size.width, curveApexY));

    canvas.drawPath(highlightPath, highlightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PrismGlassSpecularPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.borderRadius != borderRadius;
  }
}

/// Custom painter for Variant D: Smoked Glass.
/// Renders dramatic obsidian optical depth, bright upper reflection, and touch-responsive terracotta horizon glow.
class _SmokedGlassDepthPainter extends CustomPainter {
  const _SmokedGlassDepthPainter({required this.borderRadius, required this.t});

  final BorderRadius borderRadius;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // 1. Bright Upper Specular Reflection (Mirror-like glass gloss)
    final double glossHeight = size.height * 0.44;
    final Path glossPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, glossHeight * 0.40)
      ..quadraticBezierTo(
        size.width * 0.5,
        glossHeight * (1.05 - t * 0.15),
        0,
        glossHeight * 0.40,
      )
      ..close();

    final Paint glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: (0.42 - t * 0.10).clamp(0.0, 1.0)),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, glossHeight));

    canvas.drawPath(glossPath, glossPaint);

    // 2. Dramatic Touch-Responsive Terracotta Horizon Flare along bottom edge
    final double horizonHeight = size.height * (0.42 + t * 0.20);
    final Rect horizonRect = Rect.fromLTWH(
      0,
      size.height - horizonHeight,
      size.width,
      horizonHeight,
    );

    final Paint horizonPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0.0, 1.0 + t * 0.2),
        radius: 0.85 + t * 0.45,
        colors: [
          AppTheme.primaryTerracotta.withValues(
            alpha: (0.45 + t * 0.45).clamp(0.0, 1.0),
          ),
          AppTheme.darkTerracotta.withValues(
            alpha: (0.22 + t * 0.30).clamp(0.0, 1.0),
          ),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(horizonRect);

    canvas.drawRect(horizonRect, horizonPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SmokedGlassDepthPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.borderRadius != borderRadius;
  }
}

/// Custom painter for Variant E: Liquid Ripple.
/// Renders an expanding fluid ripple wave blooming from the exact touch point,
/// combined with a glass-surface specular distortion highlight.
class _FluidGlassRipplePainter extends CustomPainter {
  const _FluidGlassRipplePainter({
    required this.borderRadius,
    required this.progress,
    required this.touchPoint,
    required this.rippleColor,
  });

  final BorderRadius borderRadius;
  final double progress; // 0.0 to 1.0
  final Offset touchPoint;
  final Color rippleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    // 1. Moving Top Specular Highlight
    final double topHighlightAlpha = (0.50 - progress * 0.15).clamp(0.0, 1.0);
    final Paint topHighlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: topHighlightAlpha),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.42],
      ).createShader(rect);
    canvas.drawRect(rect, topHighlightPaint);

    // 2. Expanding Fluid Touch Wave (if active)
    if (progress > 0.005) {
      final double maxRadius = math.sqrt(
        math.pow(math.max(touchPoint.dx, size.width - touchPoint.dx), 2) +
            math.pow(math.max(touchPoint.dy, size.height - touchPoint.dy), 2),
      );
      final double currentRadius = maxRadius * progress;
      final double waveAlpha = (0.38 * (1.0 - progress)).clamp(0.0, 1.0);

      // Core bloom
      final Paint innerBloom = Paint()
        ..color = rippleColor.withValues(alpha: waveAlpha * 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
      canvas.drawCircle(touchPoint, currentRadius * 0.6, innerBloom);

      // Refractive wavefront crest
      final Paint wavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4 * (1.0 - progress * 0.4)
        ..shader = RadialGradient(
          center: Alignment(
            (touchPoint.dx / size.width) * 2 - 1,
            (touchPoint.dy / size.height) * 2 - 1,
          ),
          radius: (currentRadius / size.width).clamp(0.01, 2.5),
          colors: [
            rippleColor.withValues(alpha: waveAlpha * 0.1),
            rippleColor.withValues(alpha: waveAlpha),
            rippleColor.withValues(alpha: 0.0),
          ],
          stops: const [0.65, 0.90, 1.0],
        ).createShader(rect);

      canvas.drawCircle(touchPoint, currentRadius, wavePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FluidGlassRipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.touchPoint != touchPoint;
  }
}

/// Spring curve with controlled overshoot.
class _TastefulSpringCurve extends Curve {
  const _TastefulSpringCurve({this.overshoot = 0.035});

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
