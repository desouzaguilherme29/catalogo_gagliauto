import 'package:catalogo_gagliauto/login/login.dart';
import 'package:catalogo_gagliauto/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Model/localsettings.dart';
import 'homepage/homepage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catalogo Gagliauto',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(38, 36, 99, 1.0),
          accentColor: Color(0xff25D366)),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', ''),
      ],
      home:
      AnimatedSplashScreen.withScreenFunction(
        splash: "imagens/logo_empresa.png",
        duration: 3000,
        // ignore: missing_return
        screenFunction: () async{
          LocalSettings settings = LocalSettings();
          await settings.getInstance();
          print(settings.preferences.containsKey('isconected'));

          if (!settings.preferences.containsKey('isconected'))
            return Login();
          else
            return HomePage();
        },
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.rightToLeftWithFade,
          backgroundColor: Color.fromRGBO(38, 36, 99, 1.0)
      ),
    );
  }
}
