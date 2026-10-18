import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_squishy_button.dart';

/// Renders the single central interactive button configured for the active design (01–07).
/// Its label is always strictly "Button".
class CentralButtonView extends StatelessWidget {
  const CentralButtonView({super.key, required this.designId, this.onPressed});

  final String designId;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const String buttonLabel = 'Button';
    final VoidCallback handlePress = onPressed ?? () {};

    switch (designId) {
      // Design 01 — Squishy (Solid terracotta fill, cream text, soft shadow, 0.95 scale)
      case '01':
        return ReusableSquishyButton(
          key: const ValueKey('design_01_button'),
          label: buttonLabel,
          backgroundColor: AppTheme.primaryTerracotta,
          foregroundColor: AppTheme.mainBackground,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          physicsStyle: SquishPhysicsStyle.classic,
          pressedScale: 0.948,
          shadows: [
            BoxShadow(
              color: AppTheme.primaryTerracotta.withValues(alpha: 0.28),
              offset: const Offset(0, 6),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
          onPressed: handlePress,
        );

      // Design 02 — Elastic (Deep terracotta gradient, lively 0.915 compression with overshoot)
      case '02':
        return ReusableSquishyButton(
          key: const ValueKey('design_02_button'),
          label: buttonLabel,
          gradient: AppTheme.terracottaGradient,
          foregroundColor: AppTheme.mainBackground,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          physicsStyle: SquishPhysicsStyle.elastic,
          pressedScale: 0.915,
          pressDuration: const Duration(milliseconds: 120),
          releaseDuration: const Duration(milliseconds: 280),
          shadows: [
            BoxShadow(
              color: AppTheme.darkTerracotta.withValues(alpha: 0.32),
              offset: const Offset(0, 6),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
          onPressed: handlePress,
        );

      // Design 03 — Neumorphic (Cream surface, tactile dual shadows that deflate on press)
      case '03':
        return ReusableSquishyButton(
          key: const ValueKey('design_03_button'),
          label: buttonLabel,
          isNeumorphic: true,
          backgroundColor: AppTheme.mainBackground,
          foregroundColor: AppTheme.primaryTerracotta,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 17),
          physicsStyle: SquishPhysicsStyle.softNeumorphic,
          pressedScale: 0.965,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.7),
            width: 1.2,
          ),
          onPressed: handlePress,
        );

      // Design 04 — Gradient (Warm terracotta radiant gradient with smooth scale)
      case '04':
        return ReusableSquishyButton(
          key: const ValueKey('design_04_button'),
          label: buttonLabel,
          gradient: AppTheme.softWarmGradient,
          foregroundColor: AppTheme.mainBackground,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          physicsStyle: SquishPhysicsStyle.classic,
          pressedScale: 0.940,
          shadows: [
            BoxShadow(
              color: AppTheme.primaryTerracotta.withValues(alpha: 0.30),
              offset: const Offset(0, 5),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
          onPressed: handlePress,
        );

      // Design 05 — Outlined (Transparent/cream fill, terracotta border, warm press wash)
      case '05':
        return ReusableSquishyButton(
          key: const ValueKey('design_05_button'),
          label: buttonLabel,
          backgroundColor: AppTheme.mainBackground,
          pressedBackgroundColor: AppTheme.lightTerracotta,
          foregroundColor: AppTheme.primaryTerracotta,
          border: Border.all(color: AppTheme.primaryTerracotta, width: 2.0),
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 17),
          physicsStyle: SquishPhysicsStyle.subtle,
          pressedScale: 0.955,
          shadows: [
            BoxShadow(
              color: AppTheme.primaryTerracotta.withValues(alpha: 0.08),
              offset: const Offset(0, 3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          onPressed: handlePress,
        );

      // Design 06 — Icon (Terracotta fill, cream text, small micro-bounce icon)
      case '06':
        return ReusableSquishyButton(
          key: const ValueKey('design_06_button'),
          label: buttonLabel,
          icon: const Icon(Icons.touch_app_rounded, size: 18),
          enableIconSquish: true,
          backgroundColor: AppTheme.primaryTerracotta,
          foregroundColor: AppTheme.mainBackground,
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          physicsStyle: SquishPhysicsStyle.classic,
          pressedScale: 0.945,
          shadows: [
            BoxShadow(
              color: AppTheme.primaryTerracotta.withValues(alpha: 0.28),
              offset: const Offset(0, 5),
              blurRadius: 14,
              spreadRadius: 0,
            ),
          ],
          onPressed: handlePress,
        );

      // Design 07 — Minimal (Clean white surface, warm neutral border, terracotta text)
      case '07':
      default:
        return ReusableSquishyButton(
          key: const ValueKey('design_07_button'),
          label: buttonLabel,
          backgroundColor: AppTheme.whiteSurface,
          pressedBackgroundColor: const Color(0xFFFAF3EC),
          foregroundColor: AppTheme.primaryTerracotta,
          border: Border.all(color: AppTheme.warmNeutral, width: 1.2),
          borderRadius: BorderRadius.circular(18),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          physicsStyle: SquishPhysicsStyle.subtle,
          pressedScale: 0.962,
          shadows: [
            BoxShadow(
              color: AppTheme.primaryTerracotta.withValues(alpha: 0.06),
              offset: const Offset(0, 3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          onPressed: handlePress,
        );
    }
  }
}
