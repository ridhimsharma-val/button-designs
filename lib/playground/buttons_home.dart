import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'central_button.dart';
import 'elastic_variations_collection.dart';
import 'glass_variations_collection.dart';
import 'gradient_variations_collection.dart';
import 'icon_variations_collection.dart';
import 'minimal_variations_collection.dart';
import 'neumorphic_variations_collection.dart';
import 'outlined_variations_collection.dart';
import 'squishy_variations_collection.dart';
import 'top_design_selector.dart';

/// Full-screen mobile animated button showcase matching the reference composition:
/// 1. Compact 2-row design selector near the top.
/// 2. Single interactive button reading "Button" centered in the available space.
/// 3. Small circular terracotta accent floating near the bottom edge.
class ButtonsHome extends StatefulWidget {
  const ButtonsHome({super.key});

  @override
  State<ButtonsHome> createState() => _ButtonsHomeState();
}

class _ButtonsHomeState extends State<ButtonsHome> {
  String _selectedDesignId = '01';

  void _onSelectDesign(String id) {
    if (_selectedDesignId != id) {
      setState(() {
        _selectedDesignId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWideDesktop = screenSize.width > 500;

    final Widget mobileCanvas = Container(
      width: isWideDesktop ? 390 : double.infinity,
      height: isWideDesktop ? 844 : double.infinity,
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 880),
      decoration: BoxDecoration(
        color: AppTheme.mainBackground,
        borderRadius: isWideDesktop
            ? BorderRadius.circular(36)
            : BorderRadius.zero,
        boxShadow: isWideDesktop
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  offset: const Offset(0, 10),
                  blurRadius: 36,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppTheme.primaryTerracotta.withValues(alpha: 0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Main layout Column
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // 1. Top Compact 2-Row Design Selector
                TopDesignSelector(
                  selectedId: _selectedDesignId,
                  onSelectDesign: _onSelectDesign,
                ),

                // 2. Showcase Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.96,
                            end: 1.0,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _selectedDesignId == '01'
                        ? const SquishyVariationsCollection(
                            key: ValueKey('design_01_collection'),
                          )
                        : _selectedDesignId == '02'
                        ? const ElasticVariationsCollection(
                            key: ValueKey('design_02_collection'),
                          )
                        : _selectedDesignId == '03'
                        ? const NeumorphicVariationsCollection(
                            key: ValueKey('design_03_collection'),
                          )
                        : _selectedDesignId == '04'
                        ? const GradientVariationsCollection(
                            key: ValueKey('design_04_collection'),
                          )
                        : _selectedDesignId == '05'
                        ? const OutlinedVariationsCollection(
                            key: ValueKey('design_05_collection'),
                          )
                        : _selectedDesignId == '06'
                        ? const IconVariationsCollection(
                            key: ValueKey('design_06_collection'),
                          )
                        : _selectedDesignId == '07'
                        ? const MinimalVariationsCollection(
                            key: ValueKey('design_07_collection'),
                          )
                        : _selectedDesignId == '08'
                        ? const GlassVariationsCollection(
                            key: ValueKey('design_08_collection'),
                          )
                        : Center(
                            key: ValueKey('central_button_$_selectedDesignId'),
                            child: CentralButtonView(
                              designId: _selectedDesignId,
                            ),
                          ),
                  ),
                ),

                // Spacing to keep distance from bottom
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 3. Bottom floating circular terracotta accent matching reference layout (non-interactive)
          Positioned(
            bottom: -22,
            right: 48,
            child: IgnorePointer(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppTheme.primaryTerracotta,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryTerracotta.withValues(alpha: 0.32),
                      offset: const Offset(0, 4),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (isWideDesktop) {
      return Scaffold(
        backgroundColor: AppTheme.desktopBackdrop,
        body: Center(child: mobileCanvas),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.mainBackground,
      body: mobileCanvas,
    );
  }
}
