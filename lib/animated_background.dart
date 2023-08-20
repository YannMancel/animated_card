import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({
    super.key,
    required List<Color> colors,
    Duration duration = const Duration(seconds: 1000),
    required Widget child,
  })  : _colors = colors,
        _duration = duration,
        _child = child;

  final List<Color> _colors;
  final Duration _duration;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _AnimatedView(
        colors: _colors,
        duration: _duration,
        child: _child,
      ),
    );
  }
}

class _AnimatedView extends StatefulWidget {
  const _AnimatedView({
    required List<Color> colors,
    required Duration duration,
    required Widget child,
  })  : _colors = colors,
        _duration = duration,
        _child = child;

  final List<Color> _colors;
  final Duration _duration;
  final Widget _child;

  @override
  State<_AnimatedView> createState() => _AnimatedViewState();
}

class _AnimatedViewState extends State<_AnimatedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<WaveConfiguration> _waveConfigurations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget._duration,
      upperBound: widget._duration.inSeconds.toDouble(),
    )..forward();

    _waveConfigurations = List<WaveConfiguration>.generate(
      math.Random().nextInt(5) + 1,
      (_) => WaveConfiguration(
        seed: math.Random().nextDouble() * 10.0 + 2.0,
        horizontalOffset: 1.0 / (math.Random().nextInt(5) + 1).toDouble(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget._duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(
        controller: _controller,
        colors: widget._colors,
        waveConfigurations: _waveConfigurations,
      ),
      child: widget._child,
    );
  }
}

final class WaveConfiguration {
  const WaveConfiguration({
    required this.seed,
    required this.horizontalOffset,
  });

  final double seed;
  final double horizontalOffset;
}

class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter({
    required AnimationController controller,
    required List<Color> colors,
    required List<WaveConfiguration> waveConfigurations,
    int count = 50,
  })  : _controller = controller,
        _colors = colors,
        _waveConfigurations = waveConfigurations,
        _count = count,
        super(repaint: controller);

  final AnimationController _controller;
  final List<Color> _colors;
  final List<WaveConfiguration> _waveConfigurations;
  final int _count;

  double _waveFunction(
    double x, {
    required double halfAmplitude,
    required double period,
    required double horizontalOffset,
    required double verticalOffset,
  }) {
    return halfAmplitude * math.sin(period * x + horizontalOffset) +
        verticalOffset;
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0.0, size.height),
        Offset(size.width, 0.0),
        _colors,
      );

    canvas.drawRect(rect, paint);
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double halfAmplitude,
    required double period,
    required double horizontalOffset,
    required double verticalOffset,
  }) {
    final path = Path()..moveTo(0, size.height);
    for (int i = 0; i <= _count; i++) {
      final x = i.toDouble() * (size.width / _count.toDouble());

      path.lineTo(
        x,
        size.height *
            (1.0 -
                _waveFunction(
                  x,
                  halfAmplitude: halfAmplitude,
                  period: period,
                  horizontalOffset: horizontalOffset,
                  verticalOffset: verticalOffset,
                )),
      );
    }
    path
      ..lineTo(size.width, size.height)
      ..close();

    final paint = Paint()..color = Colors.white.withOpacity(0.2);

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);

    for (final configuration in _waveConfigurations) {
      _drawWave(
        canvas,
        size,
        halfAmplitude: 1.0 / configuration.seed,
        period: 1.0 / 100.0,
        horizontalOffset: _controller.value * configuration.horizontalOffset,
        verticalOffset: 1.0 / configuration.seed,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return oldDelegate._controller != _controller ||
        oldDelegate._colors != _colors ||
        oldDelegate._waveConfigurations != _waveConfigurations ||
        oldDelegate._count != _count;
  }
}
