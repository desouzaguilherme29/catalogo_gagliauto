import 'package:catalogo_gagliauto/Model/localsettings.dart';
import 'package:catalogo_gagliauto/Model/url_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final TextEditingController controllerUser;
  final TextEditingController controllerPass;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  StaggerAnimation(
      {@required this.controller,
      @required this.controllerUser,
      @required this.controllerPass,
      @required this.formKey})
      : buttonSqueeze = Tween(begin: 320.0, end: 60.0).animate(
            CurvedAnimation(parent: controller, curve: Interval(0.0, 0.150))),
        buttonZoomOut = Tween(
          begin: 60.0,
          end: 1000.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 1, curve: Curves.bounceOut),
        ));

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;

  _getDataUser() {}

  Widget _builderAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: InkWell(
        onTap: () {
          if (formKey.currentState.validate()) {
            _getDadosLogin(context);
          }
        },
        child: Hero(
            tag: "fade",
            child: buttonZoomOut.value == 60
                ? Container(
                    width: buttonSqueeze.value,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(38, 36, 99, 1.0),
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: _buildInside(context),
                  )
                : Container(
                    width: buttonZoomOut.value,
                    height: buttonZoomOut.value,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(38, 36, 99, 1.0),
                        shape: buttonZoomOut.value < 500
                            ? BoxShape.circle
                            : BoxShape.rectangle),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _builderAnimation,
      animation: controller,
    );
  }

  _buildInside(BuildContext context) {
    if (buttonSqueeze.value > 75) {
      return Text(
        "Entrar",
        style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    }
  }

  Future _getDadosLogin(BuildContext context) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    FocusScope.of(context).requestFocus(new FocusNode());
    var response = await http.get(
        getUrlLogin(usuario: controllerUser.text, senha: controllerPass.text));

    if (response.statusCode == 200) {
      var dados = json.decode(response.body);
      print(dados);
      if (dados[0]["logado"].toString() == "1") {
        prefs.setBool("isconected", true);
        prefs.setString("name_user", dados[0]["nome01_cli"].toString());
        prefs.setString("cpf_user", dados[0]["cpf001_cli"].toString());
        controller.forward();
      }
    } else {
      prefs.setBool("isconected", false);
      prefs.setString("name_user", "");
      prefs.setString("cpf_user", "");
      return false;
    }
  }
}
