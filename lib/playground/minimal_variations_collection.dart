import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_minimal_button.dart';

/// Scrollable collection of all 5 Minimal button variations for Design 07.
/// Every variant displays strictly the label "Button".
///
/// Variations:
/// A. Pure Minimal ("Button")
/// B. Underline Press ("Button")
/// C. Soft Tint ("Button")
/// D. Text Shift ("Button")
/// E. Fade & Press ("Button")
class MinimalVariationsCollection extends StatelessWidget {
  const MinimalVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Designs 01-06
          Center(
            child: Text(
              'MINIMAL VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Pure Minimal
          _buildItem(
            label: 'Pure Minimal',
            button: ReusableMinimalButton(
              key: const ValueKey('var_pure_minimal'),
              label: 'Button',
              style: MinimalStyle.pureMinimal,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Underline Press
          _buildItem(
            label: 'Underline Press',
            button: ReusableMinimalButton(
              key: const ValueKey('var_underline_press'),
              label: 'Button',
              style: MinimalStyle.underlinePress,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Soft Tint
          _buildItem(
            label: 'Soft Tint',
            button: ReusableMinimalButton(
              key: const ValueKey('var_soft_tint'),
              label: 'Button',
              style: MinimalStyle.softTint,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Text Shift
          _buildItem(
            label: 'Text Shift',
            button: ReusableMinimalButton(
              key: const ValueKey('var_text_shift'),
              label: 'Button',
              style: MinimalStyle.textShift,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant E — Fade & Press
          _buildItem(
            label: 'Fade & Press',
            button: ReusableMinimalButton(
              key: const ValueKey('var_fade_press'),
              label: 'Button',
              style: MinimalStyle.fadeAndPress,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
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
