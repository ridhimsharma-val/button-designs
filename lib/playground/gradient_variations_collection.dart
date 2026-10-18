import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_gradient_button.dart';

/// Scrollable collection of all 5 Gradient button variations for Design 04.
/// All 5 buttons display the exact label "Button" with no extra icons or text.
///
/// Variations:
/// A. Sunset Blend ("Button")
/// B. Liquid Gradient ("Button")
/// C. Glow Press ("Button")
/// D. Gradient Shift ("Button")
/// E. Glass Gradient ("Button")
class GradientVariationsCollection extends StatelessWidget {
  const GradientVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Designs 01-03
          Center(
            child: Text(
              'GRADIENT VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Sunset Blend
          _buildItem(
            label: 'Sunset Blend',
            button: ReusableGradientButton(
              key: const ValueKey('var_sunset_blend'),
              label: 'Button',
              style: GradientStyle.sunsetBlend,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Liquid Gradient
          _buildItem(
            label: 'Liquid Gradient',
            button: ReusableGradientButton(
              key: const ValueKey('var_liquid_gradient'),
              label: 'Button',
              style: GradientStyle.liquidGradient,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Glow Press
          _buildItem(
            label: 'Glow Press',
            button: ReusableGradientButton(
              key: const ValueKey('var_glow_press'),
              label: 'Button',
              style: GradientStyle.glowPress,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Gradient Shift
          _buildItem(
            label: 'Gradient Shift',
            button: ReusableGradientButton(
              key: const ValueKey('var_gradient_shift'),
              label: 'Button',
              style: GradientStyle.gradientShift,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant E — Glass Gradient
          _buildItem(
            label: 'Glass Gradient',
            button: ReusableGradientButton(
              key: const ValueKey('var_glass_gradient'),
              label: 'Button',
              style: GradientStyle.glassGradient,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
