import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/reusable_icon_button.dart';

/// Scrollable collection of all 5 Icon button variations for Design 06.
/// Every variant that includes a visible text label displays strictly "Button".
///
/// Variations:
/// A. Icon + Label ("Button")
/// B. Icon Reveal ("Button")
/// C. Icon Only (Action circle with semantic label "Add")
/// D. Animated Icon ("Button")
/// E. Icon Swap ("Button")
class IconVariationsCollection extends StatelessWidget {
  const IconVariationsCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Small unobtrusive section label matching Designs 01-05
          Center(
            child: Text(
              'ICON VARIATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.secondaryText.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Variant A — Icon + Label
          _buildItem(
            label: 'Icon + Label',
            button: ReusableIconButton(
              key: const ValueKey('var_icon_and_label'),
              label: 'Button',
              variant: IconButtonVariant.iconAndLabel,
              icon: Icons.bookmark_rounded,
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant B — Icon Reveal
          _buildItem(
            label: 'Icon Reveal',
            button: ReusableIconButton(
              key: const ValueKey('var_icon_reveal'),
              label: 'Button',
              variant: IconButtonVariant.iconReveal,
              icon: Icons.arrow_forward_rounded,
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              pressDuration: const Duration(milliseconds: 380),
              releaseDuration: const Duration(milliseconds: 400),
              pressCurve: Curves.easeOutCubic,
              releaseCurve: Curves.easeInOutCubic,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant C — Icon Only
          _buildItem(
            label: 'Icon Only',
            button: ReusableIconButton(
              key: const ValueKey('var_icon_only'),
              variant: IconButtonVariant.iconOnly,
              icon: Icons.add_rounded,
              tooltip: 'Add',
              semanticLabel: 'Add',
              backgroundColor: AppTheme.whiteSurface,
              foregroundColor: AppTheme.primaryTerracotta,
              border: Border.all(color: AppTheme.warmNeutral, width: 1.5),
              shadows: [
                BoxShadow(
                  color: AppTheme.primaryTerracotta.withValues(alpha: 0.10),
                  offset: const Offset(0, 3),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 22),

          // Variant D — Animated Icon
          _buildItem(
            label: 'Animated Icon',
            button: ReusableIconButton(
              key: const ValueKey('var_animated_icon'),
              label: 'Button',
              variant: IconButtonVariant.animatedIcon,
              icon: Icons.refresh_rounded,
              backgroundColor: AppTheme.mainBackground,
              foregroundColor: AppTheme.primaryTerracotta,
              border: Border.all(color: AppTheme.primaryTerracotta, width: 1.8),
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
              pressDuration: const Duration(milliseconds: 400),
              releaseDuration: const Duration(milliseconds: 420),
              pressCurve: Curves.easeOutCubic,
              releaseCurve: Curves.easeInOutCubic,
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

          // Variant E — Icon Swap
          _buildItem(
            label: 'Icon Swap',
            button: ReusableIconButton(
              key: const ValueKey('var_icon_swap'),
              label: 'Button',
              variant: IconButtonVariant.iconSwap,
              icon: Icons.arrow_forward_rounded,
              secondaryIcon: Icons.check_rounded,
              backgroundColor: AppTheme.primaryTerracotta,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
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
