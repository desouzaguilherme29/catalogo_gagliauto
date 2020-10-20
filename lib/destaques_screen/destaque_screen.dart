import 'package:catalogo_gagliauto/destaques_screen/widgets/stagger_animation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DestaquesScreen extends StatefulWidget {
  String name_user;
  String cpf_user;

  DestaquesScreen({@required this.name_user, @required this.cpf_user});

  @override
  _DestaquesScreenState createState() => _DestaquesScreenState();
}

class _DestaquesScreenState extends State<DestaquesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String name_user;

  _getNomeUser() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    name_user = prefs.getString("name_user");
  }

  @override
  void initState() {
    super.initState();
    _getNomeUser();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StaggerAnimation(controller: _controller.view, name_user: "oi",);
  }
}
