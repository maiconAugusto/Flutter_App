import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestaoApp/screens/home/index.dart';
import 'package:gestaoApp/screens/login/index.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _Main createState() => _Main();
}

class _Main extends State<Main> {
  bool islogged;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    oneSignal();
    verifyLogger();
  }

  oneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("90ceaff5-50af-4f2e-8b86-d59a7b3a6c70", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  verifyLogger() async {
    final prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('@TOKEN');
    if (value == null) {
      setState(() {
        loading = false;
        islogged = false;
      });
    } else {
      setState(() {
        loading = false;
        islogged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('pt'),
        ],
        debugShowCheckedModeBanner: false,
        home: Container(
          child: Center(
            child: Builder(
              // ignore: missing_return
              builder: (context) {
                if (loading == true) {
                  return Container(
                    color: Colors.red[800],
                  );
                } else {
                  return islogged == false ? Login() : Home();
                }
              },
            ),
          ),
        ));
  }
}
