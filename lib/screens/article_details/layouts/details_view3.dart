import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/app_settings_provider.dart';
import 'package:news_app/screens/article_details/bookmark_button.dart';
import 'package:news_app/screens/article_details/date_and_reading_time.dart';
import 'package:news_app/screens/article_details/like_button.dart';
import 'package:news_app/screens/article_details/post_share_button.dart';

import '../../../components/html_body.dart';
import '../../../services/app_service.dart';
import '../../../utils/cache_image_filter.dart';
import '../article_summary.dart';
import '../article_tags.dart';
import '../author_info.dart';
import '../comments_button.dart';
import '../likes_count.dart';
import '../post_source_button.dart';
import '../related_articles.dart';
import '../views_count.dart';

class ArticleDetailsView3 extends ConsumerWidget {
  const ArticleDetailsView3({super.key, required this.article, this.heroTag});

  final Article article;
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: null,
        body: SafeArea(
          bottom: true,
          top: false,
          maintainBottomViewPadding: true,
          child: Stack(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: HeroMode(
                      enabled: heroTag != null,
                      child: Hero(
                        tag: heroTag ?? '',
                        child: CustomCacheImageWithDarkFilterBottom(
                            imageUrl: article.thumbnailUrl, radius: 0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            backgroundColor: Theme.of(context).primaryColor,
                            labelPadding:
                                const EdgeInsets.only(left: 10, right: 10),
                            side: BorderSide.none,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            label: Text(article.category?.name
                                    .toString()
                                    .toUpperCase() ??
                                ''),
                            labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppService.getNormalText(article.title),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    wordSpacing: 1.5,
                                    letterSpacing: -0.3,
                                    color: Colors.white,
                                    fontSize: 22),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              ViewsCount(
                                  article: article, textColor: Colors.white),
                              const SizedBox(width: 20),
                              LikesCount(
                                  article: article, textColor: Colors.white),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                          )
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.arrow_back_ios_sharp,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const Spacer(),
                            ref.read(appSettingsProvider)?.likes == false
                                ? const SizedBox.shrink()
                                : CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    child: LikeButton(
                                        article: article, iconSize: 22),
                                  ),
                            const SizedBox(width: 10),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              child: BookmarkButton(
                                  article: article, iconSize: 22),
                            ),
                            PostSourceButton(article: article, leftPadding: 10),
                            const SizedBox(width: 10),
                            PostShareButton(article: article),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Align(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.50,
                  minChildSize: 0.50,
                  builder: ((context, scrollController) {
                    return SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                              top: 15, bottom: 20, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              DateAndReadingTime(
                                article: article,
                                bottomPadding: 0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AuthorInfo(article: article),
                                  CommentsButton(article: article, ref: ref),
                                ],
                              ),
                              ArticleSummary(article: article),
                              HtmlBody(description: article.description),
                              const SizedBox(height: 20),
                              ArticleTags(article: article),
                              RelatedArticles(article: article),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
