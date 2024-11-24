import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/all_articles/articles_view.dart';
import '../../../services/firebase_service.dart';

final podcastsProvider = StateNotifierProvider<PodcastData, List<Article>>((ref) => PodcastData());

final hasPodcastsProvider = StateProvider<bool>((ref) => false);

final isPodcastsLoadingProvider = StateProvider<bool>((ref) => true);

final podcastArticlesOrder = StateProvider<ArticlesBy>((ref) => ArticlesBy.latest);

class PodcastData extends StateNotifier<List<Article>> {
  PodcastData() : super([]);

  DocumentSnapshot? lastDocument;

  getData(WidgetRef ref) async {
    final orderBy = ref.watch(podcastArticlesOrder);
    if (lastDocument == null) {
      await FirebaseService().getPodcastArticlesSnapshot(articlesBy: orderBy).then((QuerySnapshot snapshot) {
        state = snapshot.docs.map((e) => Article.fromFirestore(e)).toList();
        lastDocument = snapshot.docs.last;
        ref.read(isPodcastsLoadingProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    } else {
      ref.read(hasPodcastsProvider.notifier).update((state) => true);
      await FirebaseService().getPodcastArticlesSnapshot(lastDocument: lastDocument, articlesBy: orderBy).then((QuerySnapshot? snapshot) {
        state.addAll(snapshot!.docs.map((e) => Article.fromFirestore(e)).toList());
        lastDocument = snapshot.docs.last;
        ref.read(hasPodcastsProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    }
  }

  _handleError(ref, String error) {
    ref.read(isPodcastsLoadingProvider.notifier).update((state) => false);
    ref.read(hasPodcastsProvider.notifier).update((state) => false);
    debugPrint(error);
  }
}
