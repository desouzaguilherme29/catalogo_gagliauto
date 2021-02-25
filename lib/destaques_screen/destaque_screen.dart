import 'package:catalogo_gagliauto/destaques_screen/widgets/stagger_animation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DestaquesScreen extends StatefulWidget {

  DestaquesScreen();

  @override
  _DestaquesScreenState createState() => _DestaquesScreenState();
}

class _DestaquesScreenState extends State<DestaquesScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
    return StaggerAnimation(controller: _controller.view, name_user: 'Guilherme',);
  }
}
