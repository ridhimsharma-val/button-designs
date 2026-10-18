import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Data model representing a design choice in the top selector.
class SelectorItem {
  const SelectorItem({required this.id, required this.label});

  final String id;
  final String label;
}

/// The compact 2-row design selector recreated from the user's reference screenshot.
///
/// Layout:
/// - Row 1: 01 Squishy, 02 Elastic, 03 Neumorphic, 04 Gradient
/// - Row 2: 05 Outlined, 06 Icon, 07 Minimal
/// - Active item: White pill highlight with soft shadow and terracotta text.
/// - Inactive items: Muted warm-gray text on soft neutral background.
class TopDesignSelector extends StatelessWidget {
  const TopDesignSelector({
    super.key,
    required this.selectedId,
    required this.onSelectDesign,
  });

  final String selectedId;
  final ValueChanged<String> onSelectDesign;

  static const List<SelectorItem> row1 = [
    SelectorItem(id: '01', label: '01 Squishy'),
    SelectorItem(id: '02', label: '02 Elastic'),
    SelectorItem(id: '03', label: '03 Neumorphic'),
    SelectorItem(id: '04', label: '04 Gradient'),
  ];

  static const List<SelectorItem> row2 = [
    SelectorItem(id: '05', label: '05 Outlined'),
    SelectorItem(id: '06', label: '06 Icon'),
    SelectorItem(id: '07', label: '07 Minimal'),
    SelectorItem(id: '08', label: '08 Liquid Glass'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.selectorBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.selectorBorder, width: 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 4 items
          Row(
            children: row1.map((item) {
              return Expanded(
                child: _SelectorPill(
                  label: item.label,
                  isSelected: item.id == selectedId,
                  onTap: () => onSelectDesign(item.id),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          // Row 2: 4 items
          Row(
            children: row2.map((item) {
              return Expanded(
                child: _SelectorPill(
                  label: item.label,
                  isSelected: item.id == selectedId,
                  onTap: () => onSelectDesign(item.id),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SelectorPill extends StatelessWidget {
  const _SelectorPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.whiteSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppTheme.selectorTextActive
                : AppTheme.selectorTextInactive,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
