import 'package:flutter/material.dart';
class CircularButton extends StatelessWidget {
  final String letter;

  CircularButton({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ShaderMask(
        shaderCallback: (bounds) => RadialGradient(
          center: Alignment.center,
          radius: 0.5,
          colors: <Color>[Colors.white, Colors.white,  Colors.grey],
          tileMode: TileMode.mirror,
        ).createShader(bounds),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.transparent,
              width: 10,
            ),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}