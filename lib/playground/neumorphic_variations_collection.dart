import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_neumorphic_button.dart';

/// Scrollable collection of all 5 Neumorphic button variations for Design 03.
/// All 5 buttons display the exact label "Button" with no extra icons or text.
///
/// Variations:
/// A. Soft Clay ("Button")
/// B. Deep Press ("Button")
/// C. Float & Settle ("Button")
/// D. Terracotta Clay ("Button")
/// E. Ripple Press ("Button")
class NeumorphicVariationsCollection extends StatelessWidget {
  const NeumorphicVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Design 01 & 02
          Center(
            child: Text(
              'NEUMORPHIC VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Soft Clay
          _buildItem(
            label: 'Soft Clay',
            button: ReusableNeumorphicButton(
              key: const ValueKey('var_soft_clay'),
              label: 'Button',
              style: NeumorphicStyle.softClay,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Deep Press
          _buildItem(
            label: 'Deep Press',
            button: ReusableNeumorphicButton(
              key: const ValueKey('var_deep_press'),
              label: 'Button',
              style: NeumorphicStyle.deepPress,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Float & Settle
          _buildItem(
            label: 'Float & Settle',
            button: ReusableNeumorphicButton(
              key: const ValueKey('var_float_settle'),
              label: 'Button',
              style: NeumorphicStyle.floatAndSettle,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Terracotta Clay
          _buildItem(
            label: 'Terracotta Clay',
            button: ReusableNeumorphicButton(
              key: const ValueKey('var_terracotta_clay'),
              label: 'Button',
              style: NeumorphicStyle.terracottaClay,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant E — Ripple Press
          _buildItem(
            label: 'Ripple Press',
            button: ReusableNeumorphicButton(
              key: const ValueKey('var_ripple_press'),
              label: 'Button',
              style: NeumorphicStyle.ripplePress,
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
