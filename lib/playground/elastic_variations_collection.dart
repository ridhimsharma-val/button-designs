import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_elastic_button.dart';

/// Scrollable collection of all 5 Elastic button variations for Design 02.
/// All 5 buttons display the exact label "Button".
///
/// Variations:
/// A. Elastic Bounce ("Button")
/// B. Horizontal Stretch ("Button")
/// C. Jelly Button ("Button")
/// D. Rubber Band ("Button")
/// E. Soft Rebound ("Button")
class ElasticVariationsCollection extends StatelessWidget {
  const ElasticVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Design 01 style
          Center(
            child: Text(
              'ELASTIC VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Elastic Bounce
          _buildItem(
            label: 'Elastic Bounce',
            button: ReusableElasticButton(
              key: const ValueKey('var_elastic_bounce'),
              label: 'Button',
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: AppTheme.mainBackground,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              physicsStyle: ElasticPhysicsStyle.elasticBounce,
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

          // Variant B — Horizontal Stretch
          _buildItem(
            label: 'Horizontal Stretch',
            button: ReusableElasticButton(
              key: const ValueKey('var_horizontal_stretch'),
              label: 'Button',
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: AppTheme.mainBackground,
              borderRadius: BorderRadius.circular(999),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              physicsStyle: ElasticPhysicsStyle.horizontalStretch,
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

          // Variant C — Jelly Button
          _buildItem(
            label: 'Jelly Button',
            button: ReusableElasticButton(
              key: const ValueKey('var_jelly_button'),
              label: 'Button',
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: AppTheme.mainBackground,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
              physicsStyle: ElasticPhysicsStyle.jelly,
              releaseDuration: const Duration(milliseconds: 460),
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

          // Variant D — Rubber Band
          _buildItem(
            label: 'Rubber Band',
            button: ReusableElasticButton(
              key: const ValueKey('var_rubber_band'),
              label: 'Button',
              gradient: AppTheme.terracottaGradient,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              physicsStyle: ElasticPhysicsStyle.rubberBand,
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

          // Variant E — Soft Rebound
          _buildItem(
            label: 'Soft Rebound',
            button: ReusableElasticButton(
              key: const ValueKey('var_soft_rebound'),
              label: 'Button',
              backgroundColor: AppTheme.whiteSurface,
              pressedBackgroundColor: const Color(0xFFFAF3EC),
              foregroundColor: AppTheme.primaryTerracotta,
              border: Border.all(color: AppTheme.warmNeutral, width: 1.2),
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              physicsStyle: ElasticPhysicsStyle.softRebound,
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
