import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/providers/latest_articles_provider.dart';
import 'package:news_app/screens/tabs/home_tab/tab0/featured_articles.dart';
import 'package:news_app/screens/tabs/home_tab/tab0/latest_articles.dart';
import 'package:news_app/screens/tabs/home_tab/tab0/popular_articles.dart';

import 'search_container.dart';

class Tab0 extends ConsumerWidget {
  const Tab0({super.key, required this.sc, required this.settings});
  final ScrollController sc;
  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future _onRefresh() async {
      if (settings.featured ?? true) {
        ref.invalidate(featuredArticlesProvider);
        ref.invalidate(featuredPageIndexProvider);
      }
      if (settings.popular ?? true) {
        ref.invalidate(popularArticlesProvider);
      }
      if (settings.latestArticles ?? true) {
        ref.invalidate(latestArticlesProvider);
        ref.read(latestArticlesProvider.notifier).getData(ref);
      }
    }

    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      color: Colors.white,
      onRefresh: () async => await _onRefresh(),
      child: SingleChildScrollView(
        key: const PageStorageKey('key0'),
        padding: const EdgeInsets.all(0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            settings.searchBox == true ? const SearchContainer() : const SizedBox.shrink(),
            settings.featured == true ? FeaturedArticles(settings: settings) : const SizedBox.shrink(),
            settings.popular == true ? const PopularArticles() : const SizedBox.shrink(),
            settings.latestArticles == true ? LattestArticles(sc) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
