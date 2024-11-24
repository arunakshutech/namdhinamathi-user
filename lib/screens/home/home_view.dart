import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/tabs/categories_tab/categories_tab.dart';
import 'package:news_app/screens/tabs/home_tab/home_tab.dart';
import 'package:news_app/screens/tabs/home_tab/home_tab_without_tabs.dart';
import 'package:news_app/screens/tabs/podcast_tab.dart/podcast_tab.dart';
import 'package:news_app/screens/tabs/videos_tab/videos_tab.dart';
import '../tabs/profile_tab/profile_tab.dart';
import 'home_bottom_bar.dart';

final homeTabControllerProvider = StateProvider<PageController>((ref) => PageController(initialPage: 0));

class HomeView extends ConsumerWidget {
  const HomeView({super.key, required this.settings});

  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(homeTabControllerProvider);

    return Scaffold(
      bottomNavigationBar: BottomBar(settings: settings),
      body: PageView(
        allowImplicitScrolling: true,
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _childrens(),
      ),
    );
  }

  List<Widget> _childrens() {
    final homeTab = settings.homeCategories?.isEmpty ?? true ? HomeTabWithoutTabs(settings: settings) : HomeTab(settings: settings);

    List<Widget> tabs = [homeTab, const CategoriesTab(), const ProfileTab()];

    bool audioTabEnabled = settings.audioTab ?? false;
    bool videoTabEnabled = settings.videoTab ?? false;

    if (!audioTabEnabled && !videoTabEnabled) {
      return tabs;
    } else if (!videoTabEnabled) {
      tabs.insert(1, const PodcastTab());
    } else if (!audioTabEnabled) {
      tabs.insert(1, const VideosTab());
    } else {
      tabs.insert(1, const VideosTab());
      tabs.insert(2, const PodcastTab());
    }

    return tabs;
  }
}
