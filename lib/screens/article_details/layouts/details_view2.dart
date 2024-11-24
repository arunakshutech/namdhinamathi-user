import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_details/article_summary.dart';
import 'package:news_app/screens/article_details/author_info.dart';
import 'package:news_app/screens/article_details/bookmark_button.dart';
import 'package:news_app/screens/article_details/like_button.dart';
import 'package:news_app/screens/article_details/likes_count.dart';
import 'package:news_app/screens/article_details/post_back_button.dart';
import 'package:news_app/screens/article_details/post_share_button.dart';
import 'package:news_app/screens/article_details/post_source_button.dart';
import 'package:news_app/screens/article_details/related_articles.dart';

import '../../../components/html_body.dart';
import '../../../services/app_service.dart';
import '../../../utils/custom_cached_image.dart';
import '../article_tags.dart';
import '../comments_button.dart';
import '../date_and_reading_time.dart';
import '../views_count.dart';

class ArticleDetailsView2 extends ConsumerWidget {
  const ArticleDetailsView2({super.key, required this.article, this.heroTag});

  final Article article;
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: null,
      body: SafeArea(
        bottom: true,
        top: false,
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              elevation: 0,
              actions: [
                const PostBackButton(),
                const Spacer(),
                LikeButton(article: article),
                BookmarkButton(article: article),
                PostSourceButton(
                    article: article, iconSize: 25, hasCircle: false),
                PostShareButton(
                    article: article, hasCircle: false, iconSize: 25),
                const SizedBox(width: 10),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            article.category?.name.toUpperCase() ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: 10),
                        DateAndReadingTime(article: article),
                      ],
                    ),
                    Text(
                      AppService.getNormalText(article.title),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              wordSpacing: 1.5,
                              letterSpacing: -0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Row(
                        children: [
                          ViewsCount(article: article),
                          const SizedBox(width: 20),
                          LikesCount(article: article),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 230,
                      child: HeroMode(
                        enabled: heroTag != null,
                        child: Hero(
                          tag: heroTag ?? '',
                          child: CustomCacheImage(
                              imageUrl: article.thumbnailUrl, radius: 5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AuthorInfo(article: article),
                        CommentsButton(article: article, ref: ref),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ArticleSummary(article: article),
                    HtmlBody(description: article.description),
                    const SizedBox(height: 20),
                    ArticleTags(article: article),
                    RelatedArticles(article: article),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
