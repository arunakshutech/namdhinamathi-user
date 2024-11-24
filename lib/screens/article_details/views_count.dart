import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/firebase_service.dart';
import '../../providers/app_settings_provider.dart';

final viewsStreamProvider = StreamProvider.autoDispose.family<DocumentSnapshot, String>((ref, articleId) {
  return FirebaseFirestore.instance.collection('articles').doc(articleId).snapshots();
});

class ViewsCount extends ConsumerStatefulWidget {
  final Article article;
  final Color? textColor;

  const ViewsCount({super.key, required this.article, this.textColor});

  @override
  ConsumerState<ViewsCount> createState() => _ViewsCountState();
}

class _ViewsCountState extends ConsumerState<ViewsCount> {
  @override
  void initState() {
    _updateViews();
    super.initState();
  }

  _updateViews() async {
    await Future.delayed(const Duration(seconds: 3));
    FirebaseService().updateViewsCount(widget.article.id);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(appSettingsProvider);
    if (settings?.views == false) return const SizedBox.shrink();

    final snapshot = ref.watch(viewsStreamProvider(widget.article.id));

    return snapshot.when(
      skipError: true,
      loading: () => _text(0),
      error: (error, stackTrace) => _text(0),
      data: (doc) {
        final Article article = Article.fromFirestore(doc);
        return _text(article.views ?? 0);
      },
    );
  }

  Row _text(int count) {
    return Row(
      children: [
        Icon(Icons.remove_red_eye, size: 20, color: widget.textColor ?? Colors.grey),
        const SizedBox(width: 3),
        Text(
          'count-views',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: widget.textColor ?? Colors.grey),
        ).tr(args: [count.toString()]),
      ],
    );
  }
}
