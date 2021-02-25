import 'package:catalogo_gagliauto/login/login.dart';
import 'package:catalogo_gagliauto/login2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        splashIconSize: 240,
        duration: 2000,
        // ignore: missing_return
        screenFunction: () async{
          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
          final SharedPreferences prefs = await _prefs;

          if (prefs.getBool("isconected")== true)
            return HomePage();
          else
            return Login();
        },
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.upToDown,
          backgroundColor: Colors.white//Color.fromRGBO(38, 36, 99, 1.0)
      ),
    );
  }
}
