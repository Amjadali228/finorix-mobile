import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FinorixApp());
}

class FinorixApp extends StatelessWidget {
  const FinorixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finorix 2-Candle',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F8CFF),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random rng = Random();

  double price = 102.45;
  String direction = 'UP';
  int confidence = 74;
  int refreshes = 0;

  final List<String> history = [];

  void forecast() {
    setState(() {
      final up = rng.nextBool();

      direction = up ? 'UP' : 'DOWN';
      confidence = 62 + rng.nextInt(28);
      price += (rng.nextDouble() - 0.48) * 1.4;
      refreshes++;

      history.insert(
        0,
        'Candle +1: $direction • Confidence: $confidence%',
      );

      if (history.length > 8) {
        history.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool up = direction == 'UP';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finorix 2-Candle'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: forecast,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BTC / USD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 145,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomPaint(
                      painter: ChartPainter(seed: refreshes),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2-Candle Forecast',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        up ? Icons.trending_up : Icons.trending_down,
                        size: 42,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        up ? 'UP' : 'DOWN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: up ? Colors.green : Colors.red,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$confidence%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Candle +1 → ${up ? 'Bullish' : 'Bearish'}',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: forecast,
                      icon: const Icon(Icons.auto_graph),
                      label: const Text('GENERATE FORECAST'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          if (history.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Forecasts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...history.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(item),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          const Text(
            'IMPORTANT: This is a probability-based demo. '
            'Markets cannot be predicted with certainty.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final int seed;

  ChartPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final r = Random(seed + 7);

    final line = Paint()
      ..color = const Color(0xFF4F8CFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    double y = size.height * .62;
    path.moveTo(0, y);

    for (int i = 1; i <= 12; i++) {
      y = (y + (r.nextDouble() - .5) * 35)
          .clamp(15.0, size.height - 15.0);

      path.lineTo(size.width * i / 12, y);
    }

    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}
