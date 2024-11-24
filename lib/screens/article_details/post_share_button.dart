import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:share_plus/share_plus.dart';

import '../../configs/app_config.dart';
import '../../providers/package_provider.dart';

class PostShareButton extends ConsumerWidget {
  const PostShareButton(
      {super.key,
      required this.article,
      this.bgColor,
      this.hasCircle,
      this.iconSize});

  final Article article;
  final Color? bgColor;
  final bool? hasCircle;
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final button = IconButton(
      icon: Icon(FeatherIcons.share2, size: iconSize ?? 18),
      onPressed: () {
        // Android
        final packageInfo = ref.read(packageInfoProvider).value;
        final String androidPackageName = packageInfo?.packageName ?? '';

        final String shareTextAndroid =
            "${article.title}\nCheckout more on ${AppConfig.appName} App: https://play.google.com/store/apps/details?id=$androidPackageName";

        // iOS
        final String shareTextiOS =
            "${article.title}\nCheckout more on ${AppConfig.appName} App: https://play.google.com/store/apps/details?id=${AppConfig.iosAppID}";

        final String shareText =
            Platform.isAndroid ? shareTextAndroid : shareTextiOS;

        Share.share(shareText);
      },
    );

    if (hasCircle == null || hasCircle == true) {
      return CircleAvatar(
        backgroundColor: bgColor ?? Theme.of(context).cardColor,
        radius: 18,
        child: button,
      );
    } else {
      return button;
    }
  }
}
