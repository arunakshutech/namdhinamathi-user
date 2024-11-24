import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/components/article_tiles/article_tile5.dart';
import 'package:news_app/configs/app_assets.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/all_articles/articles_view.dart';
import 'package:news_app/screens/search/search_view.dart';
import 'package:news_app/screens/tabs/podcast_tab.dart/podcast_provider.dart';
import 'package:news_app/utils/empty_animation.dart';
import 'package:news_app/utils/loading_widget.dart';
import 'package:news_app/utils/next_screen.dart';
import '../../../components/loading_list_tile.dart';

class PodcastTab extends ConsumerStatefulWidget {
  const PodcastTab({super.key});

  @override
  ConsumerState<PodcastTab> createState() => _PodcastTabState();
}

class _PodcastTabState extends ConsumerState<PodcastTab>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _controller;
  final textCtlr = TextEditingController();

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: 0.0);
    _controller.addListener(_scrollListener);
    super.initState();
    Future.microtask(() => ref.read(podcastsProvider.notifier).getData(ref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _scrollListener() async {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      ref.read(podcastsProvider.notifier).getData(ref);
    }
  }

  _onRefresh() async {
    ref.read(hasPodcastsProvider.notifier).update((state) => false);
    ref.read(isPodcastsLoadingProvider.notifier).update((state) => true);
    ref.invalidate(podcastsProvider);
    await ref.read(podcastsProvider.notifier).getData(ref);
  }

  _onOrderChanged(ArticlesBy newOrder) async {
    ref.read(podcastArticlesOrder.notifier).update((state) => newOrder);
    await _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final articles = ref.watch(podcastsProvider);
    final hasData = ref.watch(hasPodcastsProvider);
    final isLoading = ref.watch(isPodcastsLoadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: const Text('podcasts').tr(),
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w600),
        actions: [
          IconButton(
              onPressed: () async =>
                  NextScreen.normal(context, const SearchScreen()),
              icon: const Icon(FeatherIcons.search, size: 22)),
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            initialValue: ArticlesBy.latest,
            onSelected: (value) => _onOrderChanged(value),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: ArticlesBy.latest,
                  child: Text(
                    'latest',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ).tr(),
                ),
                PopupMenuItem(
                  value: ArticlesBy.popular,
                  child: Text(
                    'popular',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ).tr(),
                )
              ];
            },
          )
        ],
      ),
      body: isLoading
          ? const LoadingListTile(
              height: 200,
            )
          : articles.isEmpty
              ? EmptyAnimation(
                  animationString: emptyAnimation, title: 'no-articles'.tr())
              : RefreshIndicator(
                  onRefresh: () async => await _onRefresh(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 50, top: 15),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    child: Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: articles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (BuildContext context, int index) {
                            final Article article = articles[index];
                            return Column(
                              children: [
                                ArticleTile5(article: article),
                              ],
                            );
                          },
                        ),
                        Opacity(
                          opacity: hasData ? 1.0 : 0.0,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: LoadingIndicatorWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
