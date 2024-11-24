import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/bookmarks.dart';
import 'package:news_app/utils/next_screen.dart';
import '../providers/package_provider.dart';
import '../services/app_service.dart';
import 'app_logo.dart';



class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.settings});

  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleMedium;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            SafeArea(
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      child: const AppLogo(
                        width: 180,
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final packageInfo = ref.watch(packageInfoProvider).value;
                        final String version = packageInfo?.version ?? '1.0.0';
                        return Text(
                          'V$version',
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),

            const Divider(height: 30),

            // Social Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.bookmark,
                      size: 22,
                    ),
                    horizontalTitleGap: 10,
                    title: Text('bookmarks', style: titleTextStyle).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      NextScreen.normal(context, const Bookmarks());
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.lock,
                      size: 22,
                    ),
                    horizontalTitleGap: 10,
                    title: Text('privacy-policy', style: titleTextStyle).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openLinkWithCustomTab(settings.privacyUrl.toString());
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.email_outlined,
                      size: 22,
                    ),
                    horizontalTitleGap: 10,
                    title: Text('contact-us', style: titleTextStyle).tr(),
                    onTap: () {
                      Navigator.pop(context);
                      AppService().openEmailSupport(settings.supportEmail.toString());
                    },
                  ),
                  Visibility(
                    visible: settings.social?.fb?.isNotEmpty ?? false,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        FeatherIcons.facebook,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('facebook', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(settings.social?.fb ?? '');
                      },
                    ),
                  ),
                  Visibility(
                    visible: settings.social?.youtube?.isNotEmpty ?? false,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        FeatherIcons.youtube,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('youtube', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(settings.social?.youtube ?? '');
                      },
                    ),
                  ),
                  Visibility(
                    visible: settings.social?.twitter?.isNotEmpty ?? false,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        FontAwesome.x_twitter_brand,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('twitter', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(settings.social?.twitter ?? '');
                      },
                    ),
                  ),
                  Visibility(
                    visible: settings.social?.instagram?.isNotEmpty ?? false,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        FeatherIcons.instagram,
                        size: 22,
                      ),
                      horizontalTitleGap: 10,
                      title: Text('instagram', style: titleTextStyle).tr(),
                      onTap: () {
                        Navigator.pop(context);
                        AppService().openLink(settings.social?.instagram ?? '');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
