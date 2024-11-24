import 'package:flutter/material.dart';

import '../configs/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width});
  final double? width;

  @override
  Widget build(BuildContext context) {
    final String appLogo = Theme.of(context).brightness == Brightness.light ? logo : logoDark;
    return Image.asset(
      appLogo,
      height: 60,
      width: width ?? 110,
    );
  }
}
