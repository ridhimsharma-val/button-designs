import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_squishy_button.dart';

/// Scrollable collection of all 8 Squishy button variations for Design 01.
/// All 8 buttons display the exact label "Button".
///
/// Variations:
/// A. Classic Squish ("Button")
/// B. Elastic Squish ("Button")
/// C. Soft Neumorphic Squish ("Button")
/// D. Gradient Squish ("Button")
/// E. Outlined Squish ("Button")
/// F. Icon Squish ("Button" + checkmark)
/// G. Pill Squish ("Button")
/// H. Minimal Squish ("Button")
class SquishyVariationsCollection extends StatelessWidget {
  const SquishyVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label
          Center(
            child: Text(
              'SQUISHY VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // A. Classic Squish
          _buildItem(
            label: 'Classic Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_classic_squish'),
              label: 'Button',
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: AppTheme.mainBackground,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              physicsStyle: SquishPhysicsStyle.classic,
              pressedScale: 0.948,
              shadows: [
                BoxShadow(
                  color: AppTheme.primaryTerracotta.withValues(alpha: 0.28),
                  offset: const Offset(0, 5),
                  blurRadius: 14,
                  spreadRadius: 0,
                ),
              ],
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // B. Elastic Squish
          _buildItem(
            label: 'Elastic Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_elastic_squish'),
              label: 'Button',
              gradient: const LinearGradient(
                colors: [
                  AppTheme.darkTerracotta,
                  AppTheme.primaryTerracotta,
                  Color(0xFFE28B6A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              physicsStyle: SquishPhysicsStyle.elastic,
              pressedScale: 0.915,
              pressDuration: const Duration(milliseconds: 120),
              releaseDuration: const Duration(milliseconds: 280),
              shadows: [
                BoxShadow(
                  color: AppTheme.darkTerracotta.withValues(alpha: 0.32),
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // C. Soft Neumorphic Squish
          _buildItem(
            label: 'Soft Neumorphic Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_neumorphic_squish'),
              label: 'Button',
              isNeumorphic: true,
              backgroundColor: AppTheme.mainBackground,
              foregroundColor: AppTheme.primaryTerracotta,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              physicsStyle: SquishPhysicsStyle.softNeumorphic,
              pressedScale: 0.965,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.75),
                width: 1.2,
              ),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // D. Gradient Squish
          _buildItem(
            label: 'Gradient Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_gradient_squish'),
              label: 'Button',
              gradient: AppTheme.softWarmGradient,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              physicsStyle: SquishPhysicsStyle.classic,
              pressedScale: 0.940,
              shadows: [
                BoxShadow(
                  color: AppTheme.primaryTerracotta.withValues(alpha: 0.28),
                  offset: const Offset(0, 5),
                  blurRadius: 14,
                  spreadRadius: 0,
                ),
              ],
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // E. Outlined Squish
          _buildItem(
            label: 'Outlined Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_outlined_squish'),
              label: 'Button',
              backgroundColor: AppTheme.mainBackground,
              pressedBackgroundColor: AppTheme.lightTerracotta,
              foregroundColor: AppTheme.primaryTerracotta,
              border: Border.all(color: AppTheme.primaryTerracotta, width: 2.0),
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
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
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // F. Icon Squish
          _buildItem(
            label: 'Icon Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_icon_squish'),
              label: 'Button',
              icon: const Icon(Icons.check_rounded, size: 18),
              enableIconSquish: true,
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
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
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // G. Pill Squish
          _buildItem(
            label: 'Pill Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_pill_squish'),
              label: 'Button',
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(999),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              physicsStyle: SquishPhysicsStyle.classic,
              pressedScale: 0.948,
              shadows: [
                BoxShadow(
                  color: AppTheme.primaryTerracotta.withValues(alpha: 0.28),
                  offset: const Offset(0, 5),
                  blurRadius: 14,
                  spreadRadius: 0,
                ),
              ],
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // H. Minimal Squish
          _buildItem(
            label: 'Minimal Squish',
            button: ReusableSquishyButton(
              key: const ValueKey('var_minimal_squish'),
              label: 'Button',
              backgroundColor: AppTheme.whiteSurface,
              pressedBackgroundColor: const Color(0xFFFAF3EC),
              foregroundColor: AppTheme.primaryTerracotta,
              border: Border.all(color: AppTheme.warmNeutral, width: 1.2),
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
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
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildItem({required String label, required Widget button}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppTheme.secondaryText,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        button,
      ],
    );
  }
}
