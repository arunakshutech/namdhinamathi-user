import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import '../../../services/firebase_service.dart';
import '../../all_articles/articles_view.dart';

final videosProvider = StateNotifierProvider<VideoArticlesData, List<Article>>((ref) => VideoArticlesData());

final hasVideosProvider = StateProvider<bool>((ref) => false);

final isVideosLoadingProvider = StateProvider<bool>((ref) => true);

final videoArticlesOrder = StateProvider<ArticlesBy>((ref) => ArticlesBy.latest);

class VideoArticlesData extends StateNotifier<List<Article>> {
  VideoArticlesData() : super([]);

  DocumentSnapshot? lastDocument;

  getData(WidgetRef ref) async {
    final orderBy = ref.watch(videoArticlesOrder);
    if (lastDocument == null) {
      await FirebaseService().getVideoArticlesSnapshot(articlesBy: orderBy).then((QuerySnapshot snapshot) {
        state = snapshot.docs.map((e) => Article.fromFirestore(e)).toList();
        lastDocument = snapshot.docs.last;
        ref.read(isVideosLoadingProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    } else {
      ref.read(hasVideosProvider.notifier).update((state) => true);
      await FirebaseService().getVideoArticlesSnapshot(lastDocument: lastDocument, articlesBy: orderBy).then((QuerySnapshot? snapshot) {
        state.addAll(snapshot!.docs.map((e) => Article.fromFirestore(e)).toList());
        lastDocument = snapshot.docs.last;
        ref.read(hasVideosProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    }
  }

  _handleError(ref, String error) {
    ref.read(isVideosLoadingProvider.notifier).update((state) => false);
    ref.read(hasVideosProvider.notifier).update((state) => false);
    debugPrint(error);
  }
}
