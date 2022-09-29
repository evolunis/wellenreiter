import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:wellenflieger/models/settings.dart';
import 'package:wellenflieger/models/time_series.dart';
import 'package:wellenflieger/models/devices.dart';
import 'package:wellenflieger/screens/devices/devices.dart';

import 'package:wellenflieger/service_locator.dart';
import 'package:wellenflieger/services/firebase_notifications.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:wellenflieger/utils/local_storage.dart' as prefs;
import 'package:http/http.dart' as http;
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var url =
      "https://us-central1-wellenflieger-ef341.cloudfunctions.net/testCalled";
  http.get(Uri.parse(url));
  //await Firebase.initializeApp();
  //prefs.reload();
  //await prefs.save("message", message.messageId.toString());

  //print("Handling a background message: ${message.messageId}");
}*/

void main() async {
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Hive.initFlutter();

  //Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setUp();
  serviceLocator.allReady().then((value) {
    //FirebaseNotifications notifications = FirebaseNotifications();
    //notifications.init().then((token) {
    runApp(const MyApp());
    //});
  });

/*
  setUp();
  serviceLocator.allReady().then((value) {
    runApp(MyApp(token: token));
  });*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.token});
  final String? token;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsModel()),
        ChangeNotifierProvider(create: (context) => DevicesModel()),
        ChangeNotifierProvider(create: (context) => TimeSeriesModel())
      ],
      child: MaterialApp(
        title: 'Wellenflieger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF3399FF),
        ),
        home: const DevicesPage(),
      ),
    );
  }
}

/*
class SnackBarModel extends ChangeNotifier {
  String message = "";

  showMessage(String message) {
    message = message;
    notifyListeners();
  }

  getMessage() {
    return message;
  }
}
*/