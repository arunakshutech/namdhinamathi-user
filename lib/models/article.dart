import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author.dart';
import 'article_category.dart';

class Article {
  final String id, title, priceStatus, description;
  final String? thumbnailUrl, summary, videoUrl, audioUrl, sourceUrl;
  final DateTime createdAt;
  // ignore: prefer_typing_uninitialized_variables
  var updatedAt;
  List? tagIDs;
  final Author? author;
  final int? likes, views;
  bool? isFeatured, isCommentsEnabled;
  final String contentType;
  String status;
  final ArticleCategory? category;

  Article({
    required this.id,
    this.thumbnailUrl,
    this.videoUrl,
    required this.createdAt,
    this.updatedAt,
    this.tagIDs,
    required this.status,
    required this.author,
    this.likes,
    required this.priceStatus,
    this.isFeatured,
    required this.title,
    this.summary,
    this.audioUrl,
    this.views,
    required this.contentType,
    required this.description,
    this.isCommentsEnabled,
    this.sourceUrl,
    required this.category,
  });

  factory Article.fromFirestore(DocumentSnapshot snap) {
    Map d = snap.data() as Map<String, dynamic>;
    return Article(
      id: snap.id,
      title: d['title'],
      thumbnailUrl: d['image_url'],
      createdAt: (d['created_at'] as Timestamp).toDate(),
      updatedAt: d['updated_at'],
      videoUrl: d['video_url'],
      tagIDs: d['tag_ids'] ?? [],
      status: d['status'],
      author: d['author'] != null ? Author.fromMap(d['author']) : null,
      priceStatus: d['price_status'],
      isFeatured: d['featured'] ?? false,
      isCommentsEnabled: d['comments'] ?? true,
      contentType: d['content_type'],
      description: d['description'],
      summary: d['summary'],
      audioUrl: d['audio_url'],
      views: d['views'] ?? 0,
      likes: d['likes'] ?? 0,
      sourceUrl: d['source'],
      category: d['category'] != null ? ArticleCategory.fromMap(d['category']) : null,
      
    );
  }

}