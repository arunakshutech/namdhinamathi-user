import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/components/drawer_menu.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/utils/next_screen.dart';
import '../../../components/app_logo.dart';
import '../../notifications/notifications.dart';
import 'tab0/tab0.dart';

class HomeTabWithoutTabs extends ConsumerWidget {
  const HomeTabWithoutTabs({super.key, required this.settings});

  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      drawer: Visibility(visible: settings.drawerMenu ?? true, child: CustomDrawer(settings: settings)),
      key: scaffoldKey,
      body: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: settings.logoAtCenter ?? false,
            titleSpacing: settings.drawerMenu == true ? 0 : 20,
            title:Center( child: const AppLogo(width:200),),
            leading: Visibility(
              visible: settings.drawerMenu ?? true,
              child: IconButton(
                icon: const Icon(
                  EvaIcons.menu_2,
                  size: 28,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
            ),
            elevation: 1,
            actions: <Widget>[
              // IconButton(
              //   icon: const Icon(FeatherIcons.search, size: 22),
              //   onPressed: () => NextScreen.normal(context, const SearchScreen()),
              // ),
              // const SizedBox(width: 3),
              IconButton(
                padding: const EdgeInsets.only(right: 8),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  LineIcons.bell,
                  // size: 22,
                ),
                onPressed: () => NextScreen.normal(context, const Notifications()),
              ),
            ],
            pinned: true,
            floating: true,
            forceElevated: innerBoxIsScrolled,
          ),
        ];
      }, body: Builder(
        builder: (BuildContext context) {
          final ScrollController innerScrollController = PrimaryScrollController.of(context);
          return Tab0(sc: innerScrollController, settings: settings);
        },
      )),
    );
  }
}
