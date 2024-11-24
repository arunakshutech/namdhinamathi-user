import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import '../../services/firebase_service.dart';

final customCategoryArticlesProvider = StateNotifierProvider.autoDispose<ArticleData, List<Article>>((ref) => ArticleData());

final hasDataCustomCategoryProvider = StateProvider.autoDispose<bool>((ref) => false);

final isLoadingCustomCategoryProvider = StateProvider.autoDispose<bool>((ref) => true);

class ArticleData extends StateNotifier<List<Article>> {
  ArticleData() : super([]);

  DocumentSnapshot? lastDocument;

  getData(String categoryId, WidgetRef ref) async {
    if (lastDocument == null) {
      await FirebaseService().getArticlesSnapshotByCategory(categoryId: categoryId).then((QuerySnapshot snapshot) {
        state = snapshot.docs.map((e) => Article.fromFirestore(e)).toList();
        lastDocument = snapshot.docs.last;
        ref.read(isLoadingCustomCategoryProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    } else {
      ref.read(hasDataCustomCategoryProvider.notifier).update((state) => true);
      await FirebaseService().getArticlesSnapshotByCategory(categoryId: categoryId, lastDocument: lastDocument).then((QuerySnapshot? snapshot) {
        state.addAll(snapshot!.docs.map((e) => Article.fromFirestore(e)).toList());
        lastDocument = snapshot.docs.last;
        ref.read(hasDataCustomCategoryProvider.notifier).update((state) => false);
      }).catchError((e) => _handleError(ref, e.toString()));
    }
  }

  _handleError(ref, String error) {
    ref.read(isLoadingCustomCategoryProvider.notifier).update((state) => false);
    ref.read(hasDataCustomCategoryProvider.notifier).update((state) => false);
    debugPrint(error);
  }
}
