import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:screenshot_modes/screenshot_modes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'api_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future pushHome(BuildContext context) async {
  Navigator.of(navigatorKey.currentContext!)
      .push(DirectPageRouteBuilder(builder: (_) => HomePage()));
}

Future pushFirst(BuildContext context) async {
  Navigator.of(navigatorKey.currentContext!)
      .push(DirectPageRouteBuilder(builder: (_) => FirstPage()));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

Future pushSecond(BuildContext context) async {
  // we could get data from server;
  final data = await ApiService.getData();
  Navigator.of(navigatorKey.currentContext!).push(DirectPageRouteBuilder(
      builder: (_) => SecondPage(
            nums: data,
          )));
  // we use wait if we have animations in our page so wait until animation end then take screenshot;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale2 = DevicePreview.locale(context);
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        // useInheritedMediaQuery: true,
        navigatorKey: navigatorKey,
        locale: locale2,
        supportedLocales: [if (locale2 != null) locale2, Locale('en', 'US')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page ${Localizations.localeOf(context).toString()}"),
      ),
      body: Center(child: Text("Home Page")),
    );
  }
}

class FirstPage extends StatelessWidget {
  FirstPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FirstPage ${Localizations.localeOf(context).toString()}"),
      ),
      body: Center(child: Text("FirstPage")),
    );
  }
}

class SecondPage extends StatelessWidget {
  final List nums;
  SecondPage({
    Key? key,
    required this.nums,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SecondPage ${Localizations.localeOf(context).toString()}"),
      ),
      body: Center(
          child: Column(
        children: [Text("SecondPage"), ...nums.map((e) => Text(e.toString()))],
      )),
    );
  }
}
