import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_details/post_category.dart';
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
import '../../../models/custom_ad_model.dart';
import '../../../services/ads_service.dart';
import '../../../services/app_service.dart';
import '../../../utils/custom_cached_image.dart';
import '../article_tags.dart';
import '../comments_button.dart';
import '../date_and_reading_time.dart';
import '../views_count.dart';

class ArticleDetailsView1 extends ConsumerWidget {
  const ArticleDetailsView1({super.key, required this.article, this.heroTag});

  final Article article;
  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('state rebuild');

    // Determine whether it's mobile or web view
    bool isWebView = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: false,
        maintainBottomViewPadding: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              automaticallyImplyLeading: false,
              expandedHeight: 290,
              flexibleSpace: FlexibleSpaceBar(
                background: HeroMode(
                  enabled: heroTag != null,
                  child: Hero(
                    tag: heroTag ?? '',
                    child: CustomCacheImage(
                      imageUrl: article.thumbnailUrl,
                      radius: 0.0,
                    ),
                  ),
                ),
              ),
              actions: [
                const PostBackButton(),
                const Spacer(),
                PostSourceButton(article: article),
                const SizedBox(width: 10),
                PostShareButton(article: article),
                const SizedBox(width: 10),
              ],
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
                child: isWebView
                    // Web layout: Two columns
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    children: <Widget>[
                                      PostCategory(article: article),
                                      const Spacer(),
                                      LikeButton(article: article),
                                      BookmarkButton(article: article),
                                    ],
                                  ),
                                ),
                                DateAndReadingTime(article: article),
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
                                Divider(
                                  color: Theme.of(context).primaryColor,
                                  endIndent: 280,
                                  thickness: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      ViewsCount(article: article),
                                      const SizedBox(width: 20),
                                      LikesCount(article: article),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AuthorInfo(article: article),
                                    CommentsButton(article: article, ref: ref),
                                  ],
                                ),
                                // // Add Custom Ads Section
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       vertical: 10.0),
                                //   child: FutureBuilder<List<CustomAdModel>>(
                                //     future: AdService().fetchCustomAds(),
                                //     builder: (context, snapshot) {
                                //       if (snapshot.connectionState ==
                                //           ConnectionState.waiting) {
                                //         return Center(
                                //             child: CircularProgressIndicator());
                                //       } else if (snapshot.hasError) {
                                //         return Center(
                                //             child: Text(
                                //                 'Error: ${snapshot.error}'));
                                //       } else if (!snapshot.hasData ||
                                //           snapshot.data!.isEmpty) {
                                //         return Center(
                                //             child: Text('No ads available'));
                                //       }

                                //       final ads = snapshot.data!;
                                //       return Column(
                                //         children: ads.map((ad) {
                                //           return Card(
                                //             margin: EdgeInsets.symmetric(
                                //                 vertical: 5),
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 if (ad.imageUrl != null)
                                //                   ClipRRect(
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             5),
                                //                     child: SizedBox(
                                //                       height: 200,
                                //                       width: double.infinity,
                                //                       child: CustomCacheImage(
                                //                         imageUrl: ad.imageUrl,
                                //                         fit: BoxFit.cover,
                                //                         radius: 22,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 Padding(
                                //                   padding: const EdgeInsets.all(
                                //                       16.0),
                                //                   child: Column(
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment
                                //                             .start,
                                //                     children: [
                                //                       Text(
                                //                         ad.title ?? '',
                                //                         style: TextStyle(
                                //                             fontWeight:
                                //                                 FontWeight
                                //                                     .bold),
                                //                       ),
                                //                       SizedBox(height: 8),
                                //                       ElevatedButton(
                                //                         onPressed: () {
                                //                           // Handle ad click
                                //                         },
                                //                         child: Text(
                                //                             ad.actionButtonText ??
                                //                                 'Learn More'),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           );
                                //         }).toList(),
                                //       );
                                //     },
                                //   ),
                                // ),
                                const SizedBox(height: 15),
                                ArticleSummary(article: article),
                                HtmlBody(description: article.description),
                                const SizedBox(height: 20),
                                ArticleTags(article: article),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right column for related articles and ads
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                RelatedArticles(article: article),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: FutureBuilder<List<CustomAdModel>>(
                                    future: AdService().fetchCustomAds(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                            child: Text('No ads available'));
                                      }

                                      final ads = snapshot.data!;
                                      return Column(
                                        children: ads.map((ad) {
                                          return Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (ad.imageUrl != null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: SizedBox(
                                                      height: 200,
                                                      width: double.infinity,
                                                      child: CustomCacheImage(
                                                        imageUrl: ad.imageUrl,
                                                        fit: BoxFit.cover,
                                                        radius: 22,
                                                      ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ad.title ?? '',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(height: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          // Handle ad click
                                                        },
                                                        child: Text(
                                                            ad.actionButtonText ??
                                                                'Learn More'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    // Mobile layout: Single column
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                PostCategory(article: article),
                                const Spacer(),
                                LikeButton(article: article),
                                BookmarkButton(article: article),
                              ],
                            ),
                          ),
                          DateAndReadingTime(article: article),
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
                          Divider(
                            color: Theme.of(context).primaryColor,
                            endIndent: 280,
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                ViewsCount(article: article),
                                const SizedBox(width: 20),
                                LikesCount(article: article),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AuthorInfo(article: article),
                              CommentsButton(article: article, ref: ref),
                            ],
                          ),
                          // Add Custom Ads Section (as before)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: FutureBuilder<List<CustomAdModel>>(
                              future: AdService().fetchCustomAds(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No ads available'));
                                }

                                final ads = snapshot.data!;
                                return Column(
                                  children: ads.map((ad) {
                                    return Card(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (ad.imageUrl != null)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CustomCacheImage(
                                                  imageUrl: ad.imageUrl,
                                                  fit: BoxFit.cover,
                                                  radius: 22,
                                                ),
                                              ),
                                            ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ad.title ?? '',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 8),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Handle ad click
                                                  },
                                                  child: Text(
                                                      ad.actionButtonText ??
                                                          'Learn More'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          ArticleSummary(article: article),
                          HtmlBody(description: article.description),
                          const SizedBox(height: 20),
                          ArticleTags(article: article),
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
