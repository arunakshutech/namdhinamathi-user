import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import '../../services/firebase_service.dart';

final latestArticlesProvider = StateNotifierProvider<ArticleData, List<Article>>((ref) => ArticleData());

final isLoadingLatestArticlesProvider = StateProvider<bool>((ref) => true);

class ArticleData extends StateNotifier<List<Article>> {
  ArticleData() : super([]);

  DocumentSnapshot? lastDocument;

  getData(WidgetRef ref) async {
    if (lastDocument == null) {
      await FirebaseService().getArticlesSnapshotByLatest().then((QuerySnapshot snapshot) {
        state = snapshot.docs.map((e) => Article.fromFirestore(e)).toList();
        lastDocument = snapshot.docs.last;
        ref.read(isLoadingLatestArticlesProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    } else {
      ref.read(isLoadingLatestArticlesProvider.notifier).update((state) => true);
      await FirebaseService().getArticlesSnapshotByLatest(lastDocument: lastDocument).then((QuerySnapshot? snapshot) {
        state.addAll(snapshot!.docs.map((e) => Article.fromFirestore(e)).toList());
        lastDocument = snapshot.docs.last;
        ref.read(isLoadingLatestArticlesProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    }
  }

  _handleError(ref, String error) {
    ref.read(isLoadingLatestArticlesProvider.notifier).update((state) => false);
    debugPrint(error);
  }
}
