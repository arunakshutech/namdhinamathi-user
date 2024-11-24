import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/components/article_tiles/article_tile1.dart';
import 'package:news_app/providers/latest_articles_provider.dart';
import '../../../../models/article.dart';
import '../../../../utils/loading_widget.dart';

class LattestArticles extends ConsumerStatefulWidget {
  const LattestArticles(this.sc, {super.key});

  final ScrollController sc;

  @override
  ConsumerState<LattestArticles> createState() => _LattestArticlesState();
}

class _LattestArticlesState extends ConsumerState<LattestArticles> {
  @override
  void initState() {
    super.initState();
    widget.sc.addListener(_scrollListener); // Listen for scroll events
    Future.microtask(() {
      ref
          .read(latestArticlesProvider.notifier)
          .getData(ref); // Initial data load
    });
  }

  // Scroll Listener
  _scrollListener() {
    bool isEnd = true;

    // If we're at the end of the scroll, fetch more data
    if (isEnd && !ref.read(isLoadingLatestArticlesProvider)) {
      ref.read(latestArticlesProvider.notifier).getData(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingLatestArticlesProvider);
    final articles = ref.watch(latestArticlesProvider);

    // Check if we're on a web view (large screen)
    bool isWebView = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 0),
          child: Row(
            children: [
              Container(
                height: 23,
                width: 4,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(width: 5),
              Text(
                'latest-articles',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ).tr(),
            ],
          ),
        ),
        articles.isEmpty
            ? Container()
            : isWebView
                ? GridView.builder(
                    controller: widget.sc, // Attach scroll controller here
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // 5 columns for the web view
                      crossAxisSpacing: 10, // Horizontal spacing between items
                      mainAxisSpacing: 20, // Vertical spacing between items
                      childAspectRatio: 0.6, // Aspect ratio of grid items
                    ),
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(15),
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Article article = articles[index];
                      return ArticleTile(
                          article: article); // Display article in tile
                    },
                  )
                : ListView.separated(
                    controller: widget.sc, // Attach scroll controller here
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    itemCount: articles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (BuildContext context, int index) {
                      final Article article = articles[index];
                      return Column(
                        children: [
                          ArticleTile(article: article),
                        ],
                      );
                    },
                  ),
        Opacity(
          opacity: isLoading == true ? 1.0 : 0.0,
          child: const LoadingIndicatorWidget(), // Show loading indicator
        ),
      ],
    );
  }
}
