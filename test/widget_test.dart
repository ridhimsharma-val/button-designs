import 'package:button_lab/app.dart';
import 'package:button_lab/playground/elastic_variations_collection.dart';
import 'package:button_lab/playground/glass_variations_collection.dart';
import 'package:button_lab/playground/gradient_variations_collection.dart';
import 'package:button_lab/playground/icon_variations_collection.dart';
import 'package:button_lab/playground/minimal_variations_collection.dart';
import 'package:button_lab/playground/neumorphic_variations_collection.dart';
import 'package:button_lab/playground/outlined_variations_collection.dart';
import 'package:button_lab/playground/squishy_variations_collection.dart';
import 'package:button_lab/playground/top_design_selector.dart';
import 'package:button_lab/widgets/reusable_elastic_button.dart';
import 'package:button_lab/widgets/reusable_glass_button.dart';
import 'package:button_lab/widgets/reusable_gradient_button.dart';
import 'package:button_lab/widgets/reusable_icon_button.dart';
import 'package:button_lab/widgets/reusable_minimal_button.dart';
import 'package:button_lab/widgets/reusable_neumorphic_button.dart';
import 'package:button_lab/widgets/reusable_outlined_button.dart';
import 'package:button_lab/widgets/reusable_squishy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ButtonLab Mobile Showcase UI Tests', () {
    testWidgets(
      'Design 01 renders all 8 Squishy variations in a scrollable collection',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Verify TopDesignSelector exists
        expect(find.byType(TopDesignSelector), findsOneWidget);

        // Verify all 8 selector options exist across the 2 rows
        expect(find.text('01 Squishy'), findsOneWidget);
        expect(find.text('02 Elastic'), findsOneWidget);
        expect(find.text('03 Neumorphic'), findsOneWidget);
        expect(find.text('04 Gradient'), findsOneWidget);
        expect(find.text('05 Outlined'), findsOneWidget);
        expect(find.text('06 Icon'), findsOneWidget);
        expect(find.text('07 Minimal'), findsOneWidget);
        expect(find.text('08 Liquid Glass'), findsOneWidget);

        // Verify no unwanted header, description, or old cards
        expect(find.text('ButtonLab'), findsNothing);
        expect(find.text('01 · Squishy Buttons'), findsNothing);

        // Verify Design 01 collection is displayed
        expect(find.byType(SquishyVariationsCollection), findsOneWidget);
        expect(find.text('SQUISHY VARIATIONS'), findsOneWidget);

        // Verify all 8 Squishy variations are present
        expect(
          find.byKey(const ValueKey('var_classic_squish'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_elastic_squish'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_neumorphic_squish'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_gradient_squish'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_outlined_squish'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_icon_squish'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_pill_squish'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_minimal_squish'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 8 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableSquishyButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(8),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Classic Squish'), findsOneWidget);
        expect(find.text('Elastic Squish'), findsOneWidget);
        expect(find.text('Soft Neumorphic Squish'), findsOneWidget);
        expect(find.text('Gradient Squish'), findsOneWidget);
        expect(find.text('Outlined Squish'), findsOneWidget);
        expect(find.text('Icon Squish'), findsOneWidget);
        expect(find.text('Pill Squish'), findsOneWidget);
        expect(find.text('Minimal Squish'), findsOneWidget);
      },
    );

    testWidgets(
      'Design 02 renders all 5 Elastic variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 02 Elastic
        await tester.tap(find.text('02 Elastic'));
        await tester.pumpAndSettle();

        // Verify Design 02 collection is displayed
        expect(find.byType(ElasticVariationsCollection), findsOneWidget);
        expect(find.text('ELASTIC VARIATIONS'), findsOneWidget);

        // Verify all 5 Elastic variations are present
        expect(
          find.byKey(const ValueKey('var_elastic_bounce'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_horizontal_stretch'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_jelly_button'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_rubber_band'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_soft_rebound'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableElasticButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Elastic Bounce'), findsOneWidget);
        expect(find.text('Horizontal Stretch'), findsOneWidget);
        expect(find.text('Jelly Button'), findsOneWidget);
        expect(find.text('Rubber Band'), findsOneWidget);
        expect(find.text('Soft Rebound'), findsOneWidget);

        // Verify tapping each elastic button triggers interaction smoothly
        await tester.tap(
          find.byKey(const ValueKey('var_elastic_bounce'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_jelly_button'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Design 03 renders all 5 Neumorphic variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 03 Neumorphic
        await tester.tap(find.text('03 Neumorphic'));
        await tester.pumpAndSettle();

        // Verify Design 03 collection is displayed
        expect(find.byType(NeumorphicVariationsCollection), findsOneWidget);
        expect(find.text('NEUMORPHIC VARIATIONS'), findsOneWidget);

        // Verify all 5 Neumorphic variations are present
        expect(
          find.byKey(const ValueKey('var_soft_clay'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_deep_press'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_float_settle'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_terracotta_clay'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_ripple_press'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableNeumorphicButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Soft Clay'), findsOneWidget);
        expect(find.text('Deep Press'), findsOneWidget);
        expect(find.text('Float & Settle'), findsOneWidget);
        expect(find.text('Terracotta Clay'), findsOneWidget);
        expect(find.text('Ripple Press'), findsOneWidget);

        // Verify interactive press and release on each variant
        await tester.tap(
          find.byKey(const ValueKey('var_soft_clay'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_deep_press'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_ripple_press'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Design 04 renders all 5 Gradient variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 04 Gradient
        await tester.tap(find.text('04 Gradient'));
        await tester.pumpAndSettle();

        // Verify Design 04 collection is displayed
        expect(find.byType(GradientVariationsCollection), findsOneWidget);
        expect(find.text('GRADIENT VARIATIONS'), findsOneWidget);

        // Verify all 5 Gradient variations are present
        expect(
          find.byKey(const ValueKey('var_sunset_blend'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_liquid_gradient'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_glow_press'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_gradient_shift'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_glass_gradient'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableGradientButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Sunset Blend'), findsOneWidget);
        expect(find.text('Liquid Gradient'), findsOneWidget);
        expect(find.text('Glow Press'), findsOneWidget);
        expect(find.text('Gradient Shift'), findsOneWidget);
        expect(find.text('Glass Gradient'), findsOneWidget);

        // Verify interactive press and release on gradient buttons
        await tester.tap(
          find.byKey(const ValueKey('var_sunset_blend'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_glow_press'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_glass_gradient'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Design 05 renders all 5 Outlined variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 05 Outlined
        await tester.tap(find.text('05 Outlined'));
        await tester.pumpAndSettle();

        // Verify Design 05 collection is displayed
        expect(find.byType(OutlinedVariationsCollection), findsOneWidget);
        expect(find.text('OUTLINED VARIATIONS'), findsOneWidget);

        // Verify all 5 Outlined variations are present
        expect(
          find.byKey(
            const ValueKey('var_classic_outline'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_fill_on_press'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_border_draw'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_double_outline'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_dash_glow'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableOutlinedButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Classic Outline'), findsOneWidget);
        expect(find.text('Fill on Press'), findsOneWidget);
        expect(find.text('Border Draw'), findsOneWidget);
        expect(find.text('Double Outline'), findsOneWidget);
        expect(find.text('Dash & Glow'), findsOneWidget);

        // Verify interactive press and release on outlined buttons
        await tester.tap(
          find.byKey(
            const ValueKey('var_classic_outline'),
            skipOffstage: false,
          ),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_fill_on_press'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_border_draw'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_dash_glow'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Design 06 renders all 5 Icon variations with appropriate labels and tooltips',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 06 Icon
        await tester.tap(find.text('06 Icon'));
        await tester.pumpAndSettle();

        // Verify Design 06 collection is displayed
        expect(find.byType(IconVariationsCollection), findsOneWidget);
        expect(find.text('ICON VARIATIONS'), findsOneWidget);

        // Verify all 5 Icon variations are present
        expect(
          find.byKey(const ValueKey('var_icon_and_label'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_icon_reveal'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_icon_only'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_animated_icon'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_icon_swap'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that the 4 text-bearing variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableIconButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(4),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Icon + Label'), findsOneWidget);
        expect(find.text('Icon Reveal'), findsOneWidget);
        expect(find.text('Icon Only'), findsOneWidget);
        expect(find.text('Animated Icon'), findsOneWidget);
        expect(find.text('Icon Swap'), findsOneWidget);

        // Verify Icon Only action button has semantic label/tooltip "Add"
        expect(find.byTooltip('Add'), findsOneWidget);

        // Verify interactive press and release on icon buttons
        await tester.tap(
          find.byKey(const ValueKey('var_icon_and_label'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_icon_reveal'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_animated_icon'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        // Test Icon Swap state toggle
        expect(find.byIcon(Icons.arrow_forward_rounded), findsWidgets);
        await tester.tap(
          find.byKey(const ValueKey('var_icon_swap'), skipOffstage: false),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'Design 07 renders all 5 Minimal variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 07 Minimal
        await tester.tap(find.text('07 Minimal'));
        await tester.pumpAndSettle();

        // Verify Design 07 collection is displayed
        expect(find.byType(MinimalVariationsCollection), findsOneWidget);
        expect(find.text('MINIMAL VARIATIONS'), findsOneWidget);

        // Verify all 5 Minimal variations are present
        expect(
          find.byKey(const ValueKey('var_pure_minimal'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(
            const ValueKey('var_underline_press'),
            skipOffstage: false,
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_soft_tint'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_text_shift'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_fade_press'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableMinimalButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Pure Minimal'), findsOneWidget);
        expect(find.text('Underline Press'), findsOneWidget);
        expect(find.text('Soft Tint'), findsOneWidget);
        expect(find.text('Text Shift'), findsOneWidget);
        expect(find.text('Fade & Press'), findsOneWidget);

        // Verify interactive press and release on minimal buttons
        await tester.tap(
          find.byKey(const ValueKey('var_pure_minimal'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(
            const ValueKey('var_underline_press'),
            skipOffstage: false,
          ),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_soft_tint'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_text_shift'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_fade_press'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Design 08 renders all 5 Liquid Glass variations in a scrollable collection with Button labels',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // Switch to Design 08 Liquid Glass
        await tester.tap(find.text('08 Liquid Glass'));
        await tester.pumpAndSettle();

        // Verify Design 08 collection is displayed
        expect(find.byType(GlassVariationsCollection), findsOneWidget);
        expect(find.text('LIQUID GLASS VARIATIONS'), findsOneWidget);

        // Verify all 5 Liquid Glass variations are present
        expect(
          find.byKey(const ValueKey('var_frosted_glass'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_liquid_glow'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_prism_glass'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_smoked_glass'), skipOffstage: false),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey('var_liquid_ripple'), skipOffstage: false),
          findsOneWidget,
        );

        // Verify that all 5 variations display the exact label "Button"
        expect(
          find.widgetWithText(
            ReusableGlassButton,
            'Button',
            skipOffstage: false,
          ),
          findsNWidgets(5),
        );

        // Verify variant titles displayed above buttons
        expect(find.text('Frosted Glass'), findsOneWidget);
        expect(find.text('Liquid Glow'), findsOneWidget);
        expect(find.text('Prism Glass'), findsOneWidget);
        expect(find.text('Smoked Glass'), findsOneWidget);
        expect(find.text('Liquid Ripple'), findsOneWidget);

        // Verify interactive press and release on liquid glass buttons
        await tester.tap(
          find.byKey(const ValueKey('var_frosted_glass'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_liquid_glow'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_prism_glass'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_smoked_glass'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const ValueKey('var_liquid_ripple'), skipOffstage: false),
        );
        await tester.pump(const Duration(milliseconds: 60));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Switching across all designs 01 through 08 maintains layout consistency and displays collections',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ButtonLabApp());
        await tester.pumpAndSettle();

        // 01 Squishy
        expect(find.byType(SquishyVariationsCollection), findsOneWidget);

        // 02 Elastic
        await tester.tap(find.text('02 Elastic'));
        await tester.pumpAndSettle();
        expect(find.byType(ElasticVariationsCollection), findsOneWidget);

        // 03 Neumorphic
        await tester.tap(find.text('03 Neumorphic'));
        await tester.pumpAndSettle();
        expect(find.byType(NeumorphicVariationsCollection), findsOneWidget);

        // 04 Gradient
        await tester.tap(find.text('04 Gradient'));
        await tester.pumpAndSettle();
        expect(find.byType(GradientVariationsCollection), findsOneWidget);

        // 05 Outlined
        await tester.tap(find.text('05 Outlined'));
        await tester.pumpAndSettle();
        expect(find.byType(OutlinedVariationsCollection), findsOneWidget);

        // 06 Icon
        await tester.tap(find.text('06 Icon'));
        await tester.pumpAndSettle();
        expect(find.byType(IconVariationsCollection), findsOneWidget);

        // 07 Minimal
        await tester.tap(find.text('07 Minimal'));
        await tester.pumpAndSettle();
        expect(find.byType(MinimalVariationsCollection), findsOneWidget);

        // 08 Liquid Glass
        await tester.tap(find.text('08 Liquid Glass'));
        await tester.pumpAndSettle();
        expect(find.byType(GlassVariationsCollection), findsOneWidget);

        // Select back to 07 Minimal
        await tester.tap(find.text('07 Minimal'));
        await tester.pumpAndSettle();
        expect(find.byType(MinimalVariationsCollection), findsOneWidget);
        expect(find.byType(GlassVariationsCollection), findsNothing);

        // Select back to 01 Squishy
        await tester.tap(find.text('01 Squishy'));
        await tester.pumpAndSettle();
        expect(find.byType(SquishyVariationsCollection), findsOneWidget);
        expect(find.byType(MinimalVariationsCollection), findsNothing);
      },
    );
  });
}
