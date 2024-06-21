import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pedometer_2/pedometer_2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app.dart';

const notificationChannelId = 'walkmeter_notification';
const notificationId = 666; // Deadly!

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (await Permission.activityRecognition.request().isGranted) {
    await initializeService();
    runApp(const App());
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,
          // auto start service
          autoStart: true,
          isForegroundMode: true,
          // this must match with notification channel you created above.
          foregroundServiceNotificationId: notificationId,
          initialNotificationTitle: 'Walkmeter',
          initialNotificationContent: 'Running'),
      iosConfiguration: IosConfiguration());
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  Stream<int> pedometerStepCount = Pedometer().stepCountStream();
  Stream<PedestrianStatus> pedestrianStatusStream =
      Pedometer().pedestrianStatusStream();

  Timer.periodic(const Duration(seconds: 1), (timer) {
    service.invoke(
      'updateDuration',
      {},
    );
  });

  pedometerStepCount.listen((steps) {
    service.invoke(
      'updateSteps',
      {
        "steps": steps.toString(),
      },
    );
  }).onError((event) => service.invoke(
        'updateSteps',
        {
          "steps": 'error',
        },
      ));

  pedestrianStatusStream
      .listen((status) => service.invoke(
            'updateStatus',
            {
              "status": status.name.toString(),
            },
          ))
      .onError((event) => service.invoke(
            'updateStatus',
            {
              "status": 'error',
            },
          ));

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}
