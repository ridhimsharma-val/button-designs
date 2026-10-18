import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_glass_button.dart';

/// Scrollable collection of all 5 Liquid Glass button variations for Design 08.
/// All 5 buttons display the exact label "Button" with no extra icons or text.
///
/// Variations:
/// A. Frosted Glass ("Button")
/// B. Liquid Glow ("Button")
/// C. Prism Glass ("Button")
/// D. Smoked Glass ("Button")
/// E. Liquid Ripple ("Button")
class GlassVariationsCollection extends StatelessWidget {
  const GlassVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Designs 01-07
          Center(
            child: Text(
              'LIQUID GLASS VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Frosted Glass
          _buildItem(
            label: 'Frosted Glass',
            button: ReusableGlassButton(
              key: const ValueKey('var_frosted_glass'),
              label: 'Button',
              style: GlassStyle.frostedGlass,
              borderRadius: BorderRadius.circular(999),
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Liquid Glow
          _buildItem(
            label: 'Liquid Glow',
            button: ReusableGlassButton(
              key: const ValueKey('var_liquid_glow'),
              label: 'Button',
              style: GlassStyle.liquidGlow,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Prism Glass
          _buildItem(
            label: 'Prism Glass',
            button: ReusableGlassButton(
              key: const ValueKey('var_prism_glass'),
              label: 'Button',
              style: GlassStyle.prismGlass,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Smoked Glass
          _buildItem(
            label: 'Smoked Glass',
            button: ReusableGlassButton(
              key: const ValueKey('var_smoked_glass'),
              label: 'Button',
              style: GlassStyle.smokedGlass,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant E — Liquid Ripple
          _buildItem(
            label: 'Liquid Ripple',
            button: ReusableGlassButton(
              key: const ValueKey('var_liquid_ripple'),
              label: 'Button',
              style: GlassStyle.liquidRipple,
              borderRadius: BorderRadius.circular(999),
              padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
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
