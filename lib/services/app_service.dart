import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:reading_time/reading_time.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/app_assets.dart';
import '../configs/app_config.dart';
import '../models/comment.dart';
import '../models/user_model.dart';
import '../utils/toasts.dart';

class AppService {
  final InAppReview inAppReview = InAppReview.instance;
  Future openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Can't launch the url");
    }
  }

  Future openEmailSupport(String supportEmail) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=About ${AppConfig.appName}&body=',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1("Can't open the email app");
    }
  }
    static String getYouTubeVideoId(String url) {
    final Uri uri = Uri.parse(url);
    if (uri.host.contains('youtube.com') && uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v']!;
    }
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.last;
    }
    throw FormatException("Invalid YouTube URL");
  }
  Future openCommentReportEmail(
      context, Comment comment, UserModel? user, String supportEmail) async {
    final String userName = user != null ? user.name : 'An user';
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query:
          'subject=${AppConfig.appName} - Comment Report&body=$userName has reported on a Comment on ${comment.articleTitle}.\n\nReported Comment: ${comment.comment}\nUser Id: ${user?.id}\nUser Email: ${user?.email}\n',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      openToast1("Can't open the email app");
    }
  }

  Future openLinkWithCustomTab(String url) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: const CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.system,
          //addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    } catch (e) {
      openToast1('Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future launchAppReview(context, WidgetRef ref) async {
    // final packageInfo = ref.read(packageInfoProvider).value;
    //final String androidPackageName = packageInfo?.packageName ?? '';
    await inAppReview.openStoreListing(appStoreId: AppConfig.iosAppID);
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
    if (Platform.isIOS) {
      if (AppConfig.iosAppID == '000000') {
        openToast("The iOS version is not available on the AppStore yet");
      }
    }
  }

  static String getVideoType(String videoSource) {
    if (videoSource.contains('youtu')) {
      return 'youtube';
    } else if (videoSource.contains('vimeo')) {
      return 'vimeo';
    } else {
      return 'network';
    }
  }

  static void confiugureStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  static String getDateTime(DateTime dateTime) {
    var format = DateFormat('dd MMMM, yyyy hh:mm a');
    return format.format(dateTime.toLocal());
  }

  static String getDate(DateTime date) {
    var format = DateFormat('dd MMMM yyyy');
    return format.format(date.toLocal());
  }

  static bool isDarkMode(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  static bool isHTML(String str) {
    final RegExp htmlRegExp =
        RegExp('<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlRegExp.hasMatch(str);
  }

  static String getTodaysID() {
    return DateTime.now().toUtc().toString().split(' ')[0].replaceAll('-', '');
  }

  static void svgPrecacheImage() {
    // SVG Images
    const svgImages = [
      introImage1,
      introImage2,
      introImage3,
    ];

    for (String element in svgImages) {
      var loader = SvgAssetLoader(element);
      svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    }
  }

  static getNormalText(String text) {
    return HtmlUnescape().convert(parse(text).documentElement!.text);
  }

  static String getReadingTime(String text) {
    if (text == '') {
      return '';
    } else {
      var reader = readingTime(getNormalText(text));
      return reader.msg;
    }
  }
}
