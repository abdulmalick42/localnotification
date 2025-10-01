import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:screen_state/screen_state.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Screen? screen;

  @override
  void initState() {
    super.initState();
    _listenScreenEvents();
  }

  
  

  /// Show notification
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  /// Listen to screen lock/unlock events
  void _listenScreenEvents() {
    screen = Screen();
    final stream = screen?.screenStateStream;
    if (stream != null) {
      stream.listen((event) {
        if (event == ScreenStateEvent.SCREEN_ON) {
          _showNotification("Welcome Back!", "You just unlocked your phone.");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Notification Demo")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Button press -> show notification
              _showNotification("Button Pressed", "This is your notification.");
            },
            child: const Text("Show Notification "),
          ),
        ),
      ),
    );
  }
}
