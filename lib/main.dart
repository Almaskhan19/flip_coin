import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  const CoinFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  String _result = 'Tap to Flip!';
  bool _isHeads = true;
  bool _nextIsHeads = true;
  double _targetAngle = 0;
  final Random _random = Random();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  void _flipCoin() {
    if (_controller.isAnimating) return;

    _nextIsHeads = _random.nextBool();
    _targetAngle = 6 * pi + (_nextIsHeads ? 0 : pi);
    setState(() => _result = 'Flipping...');

    _controller.forward(from: 0.0).then((_) {
      if (!mounted) return;
      setState(() {
        _isHeads = _nextIsHeads;
        _result = _isHeads ? 'Heads!' : 'Tails!';
      });
    });
  }

  Widget _buildCoinFace(bool isHeads) {
    return Container(
      width: 184,
      height: 184,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
        ),
        border: Border.all(color: const Color(0xFF9A6700), width: 6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isHeads ? Icons.star_rounded : Icons.change_history_rounded,
            size: 64,
            color: const Color(0xFF805500),
          ),
          Text(
            isHeads ? 'HEADS' : 'TAILS',
            style: const TextStyle(
              color: Color(0xFF805500),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flip a Coin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final angle = _animation.value * _targetAngle;
                final showingHeads = cos(angle) >= 0;
                final jumpHeight = 90 * sin(pi * _controller.value);
                return Transform.translate(
                  offset: Offset(0, -jumpHeight),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0015)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scaleX: showingHeads ? 1 : -1,
                      child: _buildCoinFace(showingHeads),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              _result,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _controller.isAnimating ? null : _flipCoin,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              child: const Text('Flip Now', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}