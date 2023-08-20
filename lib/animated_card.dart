import 'package:color_card/animated_background.dart';
import 'package:flutter/material.dart';

class AnimatedCard extends StatelessWidget {
  const AnimatedCard({
    super.key,
    required List<Color> colors,
    required Widget child,
  })  : _colors = colors,
        _child = child;

  final List<Color> _colors;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedBackground(
        colors: _colors,
        child: _child,
      ),
    );
  }
}
