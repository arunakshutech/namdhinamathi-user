import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../models/notification_model.dart';
import '../screens/notifications/custom_notification_details.dart';
import '../utils/next_screen.dart';
import '../utils/snackbars.dart';
import 'hive_service.dart';
import 'sp_service.dart';

final nProvider = StateProvider<bool>((ref) => false);

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Check if notification permission is granted
  Future<bool?> _checkPermission() async {
    bool? accepted;
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await _fcm.getNotificationSettings().then((NotificationSettings settings) async {
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        accepted = true;
      } else {
        accepted = false;
      }
    });
    return accepted;
  }

    // Subscribe to notification topic
bool isWebPlatform() => kIsWeb;

Future<void> _subscribe() async {
  if (isWebPlatform()) {
    debugPrint('Topic subscription is not supported on web clients.');
    return;
  }
  try {
    await _fcm.subscribeToTopic(notificationTopicForAll);
    debugPrint('Subscribed to topic: $notificationTopicForAll');
  } catch (e) {
    debugPrint('Error subscribing to topic: $e');
  }
}

Future<void> _unsubscribe() async {
  if (isWebPlatform()) {
    debugPrint('Topic unsubscription is not supported on web clients.');
    return;
  }
  try {
    await _fcm.unsubscribeFromTopic(notificationTopicForAll);
    debugPrint('Unsubscribed from topic: $notificationTopicForAll');
  } catch (e) {
    debugPrint('Error unsubscribing from topic: $e');
  }
}


  // Check and manage notification subscription
  Future checkNotificationSubscription(WidgetRef ref) async {
    final bool value = await SPService().getNotificationSubscription();
    if (value) {
      await _subscribe();
      ref.read(nProvider.notifier).update((state) => true);
    } else {
      await _unsubscribe();
      ref.read(nProvider.notifier).update((state) => false);
    }
  }

  // Handle subscription changes
  void handleSubscription(context, bool newValue, WidgetRef ref) async {
    if (newValue) {
      final bool? accepted = await _checkPermission();
      if (accepted != null && accepted) {
        ref.read(nProvider.notifier).update((state) => true);
        openSnackbar(context, 'notifications-enabled'.tr());
        await _subscribe();
        await SPService().setNotificationSubscription(newValue);
      } else {
        openNotificationPermissionDialog(context);
      }
    } else {
      ref.read(nProvider.notifier).update((state) => false);
      openSnackbar(context, 'notifications-disabled'.tr());
      await _unsubscribe();
      await SPService().setNotificationSubscription(newValue);
    }
  }

  // Request notification permission
  Future _handleNotificationPermission(WidgetRef ref) async {
    NotificationSettings settings = await _fcm.requestPermission(provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      ref.read(nProvider.notifier).update((state) => true);
      SPService().setNotificationSubscription(true);
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  // Initialize Firebase push notifications
  Future initFirebasePushNotification(BuildContext context, WidgetRef ref) async {
    await _handleNotificationPermission(ref);

    // Handle notification when the app is launched by clicking on it
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    debugPrint('Initial message: $initialMessage');
    if (initialMessage != null) {
      await HiveService().saveNotificationData(initialMessage).then((value) {
        if (!context.mounted) return;
        _navigateToDetailsScreen(context, initialMessage);
      });
    }

    // Handle notifications when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('onMessage: ${message.data}');
      await HiveService().saveNotificationData(message).then((value) {
        if (!context.mounted) return;
        _openNotificationDialog(context, message);
      });
    });

    // Handle notifications when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('onMessageOpenedApp: ${message.data}');
      await HiveService().saveNotificationData(message).then((value) {
        if (!context.mounted) return;
        _navigateToDetailsScreen(context, message);
      });
    });
  }

  // Show popup notification dialog
  Future _openNotificationDialog(BuildContext context, RemoteMessage message) async {
    final NotificationModel notificationModel = NotificationModel.fromRemoteMessage(message);
    notificationDialog(context, notificationModel);
  }

  // Navigate to the notification details screen
  _navigateToDetailsScreen(BuildContext context, RemoteMessage message) async {
    final NotificationModel notification = NotificationModel.fromRemoteMessage(message);
    HiveService().setNotificationRead(notification);
    NextScreen.normal(context, CustomNotificationDeatils(notificationModel: notification));
  }
}

// Notification Dialog Widget
Future<void> notificationDialog(BuildContext context, NotificationModel notificationModel) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(notificationModel.title),
        content: Text(notificationModel.body),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('View Details'),
            onPressed: () {
              Navigator.of(context).pop();
              NextScreen.normal(context, CustomNotificationDeatils(notificationModel: notificationModel));
            },
          ),
        ],
      );
    },
  );
}

// Notification Permission Dialog
Future<void> openNotificationPermissionDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notification Permission'),
        content: Text('This app needs notification permission to send you alerts.'),
        actions: <Widget>[
          TextButton(
            child: Text('Deny'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Allow'),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to app settings or request permission again
            },
          ),
        ],
      );
    },
  );
}
