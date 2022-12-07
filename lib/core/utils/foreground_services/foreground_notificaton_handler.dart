import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'foreground_location_handler.dart';

class ForegroundNotificationHandler {
  ForegroundNotificationHandler._();

  static final ForegroundNotificationHandler instance = ForegroundNotificationHandler._();

  ReceivePort? _receivePort;

  void initTrackerService() {
    log("Init Notification model");
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'red_cat_check_in',
        channelName: 'Check In',
        channelDescription: 'User checked in',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(
            id: 'stopButton',
            text: 'Stop Tracking',
          ),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 3000,
        autoRunOnBoot: false,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.

    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted = await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
      }
    }

    bool reqResult;
    if (await FlutterForegroundTask.isRunningService) {
      reqResult = await FlutterForegroundTask.restartService();
    } else {
      reqResult = await FlutterForegroundTask.startService(
        notificationTitle: 'RedCat Check In',
        notificationText: 'Checked in',
        callback: startCallback,
      );
    }

    ReceivePort? receivePort;
    if (reqResult) {
      receivePort = await FlutterForegroundTask.receivePort;
    }
    return registerReceivePort(receivePort);
  }

  bool registerReceivePort(ReceivePort? receivePort) {
    _closeReceivePort();
    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        if (message is Map<String, dynamic>) {
          switch (message["event"]) {
            case "stop_tracking":
              final dt = message["data"];
              if (dt["success"]) {}
              break;
            default:
              break;
          }
        }
      });
      return true;
    }
    return false;
  }

  void stopForegroundService() {
    log("App in foreground");
    FlutterForegroundTask.stopService();
    _closeReceivePort();
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundLocationHandler());
}
