
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finorix 2-Candle',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F8CFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final rng = Random();
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
      price += (rng.nextDouble() - .48) * 1.4;
      refreshes++;
      history.insert(
        0,
        '${DateTime.now().toLocal().toString().substring(11,19)}  •  '
        'Candle +1: $direction  •  Candle +2: ${up ? "UP" : "DOWN"}  •  $confidence%',
      );
      if (history.length > 8) history.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final up = direction == 'UP';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finorix 2-Candle'),
        actions: [
          IconButton(
            onPressed: forecast,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF121A30),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BTC / USD', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  Container(
                    height: 145,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1427),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: CustomPaint(painter: ChartPainter(seed: refreshes)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            color: const Color(0xFF121A30),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('2-Candle Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(up ? Icons.trending_up : Icons.trending_down,
                        size: 42, color: up ? Colors.greenAccent : Colors.redAccent),
                      const SizedBox(width: 12),
                      Text(up ? 'UP' : 'DOWN',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                          color: up ? Colors.greenAccent : Colors.redAccent)),
                      const Spacer(),
                      Text('$confidence%',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Candle +1  →  next candle'),
                  Text('Candle +2  →  following candle'),
                  const SizedBox(height: 10),
                  Text('Signal refresh #$refreshes',
                    style: const TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: forecast,
            icon: const Icon(Icons.auto_graph),
            label: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('GENERATE 2-CANDLE SIGNAL'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Signal History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (history.isEmpty)
            const Text('Generate a signal to see history.',
              style: TextStyle(color: Colors.white54))
          else
            ...history.map((x) => Card(
              color: const Color(0xFF121A30),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(x),
              ),
            )),
          const SizedBox(height: 16),
          const Text(
            'IMPORTANT: This is a probability-based demo forecast, not a guarantee. '
            'Markets cannot be predicted with certainty. No real Quotex orders are placed.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 12),
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
      y = (y + (r.nextDouble() - .5) * 35).clamp(15, size.height - 15);
      path.lineTo(size.width * i / 12, y);
    }
    canvas.drawPath(path, line);
  }
  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) => oldDelegate.seed != seed;
}
