import 'package:catalogo_gagliauto/homepage/homepage.dart';
import 'package:catalogo_gagliauto/login/widgets/form_container.dart';
import 'package:catalogo_gagliauto/login/widgets/signupbottom.dart';
import 'package:catalogo_gagliauto/login/widgets/stagger_animation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/fundo_login.png"),
                fit: BoxFit.cover)),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 32),
                      child: Image.asset(
                        "imagens/logo_empresa.png",
                        width: 600,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),
                    FormContainer(),
                    SignUpButton()
                  ],
                ),
                StaggerAnimation(controller: _animationController.view)
              ],
            )
          ],
        ),
      ),
    );
  }
}
