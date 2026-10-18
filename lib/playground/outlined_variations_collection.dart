import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_outlined_button.dart';

/// Scrollable collection of all 5 Outlined button variations for Design 05.
/// All 5 buttons display the exact label "Button" with no extra icons or text.
///
/// Variations:
/// A. Classic Outline ("Button")
/// B. Fill on Press ("Button")
/// C. Border Draw ("Button")
/// D. Double Outline ("Button")
/// E. Dash & Glow ("Button")
class OutlinedVariationsCollection extends StatelessWidget {
  const OutlinedVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Designs 01-04
          Center(
            child: Text(
              'OUTLINED VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Classic Outline
          _buildItem(
            label: 'Classic Outline',
            button: ReusableOutlinedButton(
              key: const ValueKey('var_classic_outline'),
              label: 'Button',
              style: OutlineStyle.classic,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Fill on Press
          _buildItem(
            label: 'Fill on Press',
            button: ReusableOutlinedButton(
              key: const ValueKey('var_fill_on_press'),
              label: 'Button',
              style: OutlineStyle.fillOnPress,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Border Draw
          _buildItem(
            label: 'Border Draw',
            button: ReusableOutlinedButton(
              key: const ValueKey('var_border_draw'),
              label: 'Button',
              style: OutlineStyle.borderDraw,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Double Outline
          _buildItem(
            label: 'Double Outline',
            button: ReusableOutlinedButton(
              key: const ValueKey('var_double_outline'),
              label: 'Button',
              style: OutlineStyle.doubleOutline,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant E — Dash & Glow
          _buildItem(
            label: 'Dash & Glow',
            button: ReusableOutlinedButton(
              key: const ValueKey('var_dash_glow'),
              label: 'Button',
              style: OutlineStyle.dashAndGlow,
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
