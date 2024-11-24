import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String id, title, body;
  final String? thumbnail, articleId, notificationType, contentType;
  final DateTime recievedAt;
  bool? read;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.recievedAt,
    this.read,
    this.thumbnail,
    this.articleId,
    this.contentType,
    this.notificationType,
  });

  factory NotificationModel.fromRemoteMessage(RemoteMessage d) {
    return NotificationModel(
      id: d.messageId.toString(),
      title: d.notification?.title ?? '',
      recievedAt: DateTime.now(),
      body: d.data['description'] ?? '',
      thumbnail: d.data['image_url'],
      articleId: d.data['article_id'],
      contentType: d.data['content_type'],
      notificationType: d.data['notification_type'],
    );
  }

  factory NotificationModel.fromHive(dynamic d) {
    return NotificationModel(
      id: d['id'],
      title: d['title'],
      recievedAt: d['recieved_at'],
      body: d['description'],
      read: d['read'] ?? false,
      thumbnail: d['image_url'],
      articleId: d['article_id'],
      contentType: d['content_type'],
      notificationType: d['notification_type'],
    );
  }

  static Map<String, dynamic> getMap(NotificationModel d) {
    return {
      'id': d.id,
      'title': d.title,
      'description': d.body,
      'recieved_at': d.recievedAt,
      'read': d.read,
      'image_url': d.thumbnail,
      'article_id': d.articleId,
      'content_type': d.contentType,
      'notification_type': d.notificationType,
    };
  }
}