import 'package:flutter/material.dart';

import 'playground/buttons_home.dart';
import 'theme/app_theme.dart';

/// The root application widget for ButtonLab.
class ButtonLabApp extends StatelessWidget {
  const ButtonLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ButtonLab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const ButtonsHome(),
    );
  }
}
