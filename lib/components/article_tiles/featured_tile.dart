import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/components/premium_tag.dart';
import 'package:news_app/utils/next_screen.dart';
import '../../models/article.dart';
import '../../providers/app_settings_provider.dart';
import '../../services/app_service.dart';
import '../../utils/custom_cached_image.dart';
import '../media_icon.dart';

class FeaturedTile extends ConsumerWidget {
  final Article article;
  const FeaturedTile({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(appSettingsProvider);

    final heroTag = UniqueKey();
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5)),
                    child: CustomCacheImage(imageUrl: article.thumbnailUrl, radius: 5),
                  ),
                  MediaIcon(article: article, iconSize: 50),
                ],
              ),
            ),
            PremiumTag(article: article, topMargin: 50),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                decoration: const BoxDecoration(
                    color: Colors.black26, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppService.getNormalText(article.title),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    settings?.date == false
                        ? const SizedBox.shrink()
                        : Row(
                            children: <Widget>[
                              const Icon(CupertinoIcons.time, size: 16, color: Colors.white),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppService.getDate(article.createdAt),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade200),
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).primaryColor.withOpacity(0.7)),
                      child: const Text(
                        'featured',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ).tr(),
                    ),
                    const Spacer(),
                    settings?.likes == false
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                            height: 30,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black45),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.favorite,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  article.likes.toString(),
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => NextScreen().handlePostNavigation(context, article, heroTag, false, ref),
    );
  }
}
