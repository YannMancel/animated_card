import 'package:color_card/animated_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required String title,
  }) : _title = title;

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedCard(
              colors: const <Color>[
                Colors.purpleAccent,
                Colors.blueAccent,
              ],
              child: SizedBox.fromSize(
                size: const Size.fromHeight(200.0),
                child: const Center(
                  child: Text(
                    'Card 1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox.square(dimension: 16.0),
            AnimatedCard(
              colors: const <Color>[
                Color(0xFF163D8A),
                Color(0xFF99ACD3),
              ],
              child: SizedBox.fromSize(
                size: const Size.fromHeight(200.0),
                child: const Center(
                  child: Text(
                    'Card 2',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
