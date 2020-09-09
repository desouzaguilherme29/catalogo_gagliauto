import 'package:catalogo_gagliauto/homepage/widgets/fade_container.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {

  final AnimationController controller;

  StaggerAnimation({@required this.controller}) :
        fadeAnimation = ColorTween(
          begin: Color.fromRGBO(38, 36, 99, 1.0),
          end: Color.fromRGBO(38, 36, 99, 0.0),
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.decelerate)
        );

  final Animation<Color> fadeAnimation;

  Widget _buildAnimation(BuildContext context, Widget child){
    return Stack(
      children: <Widget>[
        IgnorePointer(
          child: FadeContainer(
            fadeAnimation: fadeAnimation,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
            animation: controller,
            builder: _buildAnimation
        ),
      ),
    );
  }
}
