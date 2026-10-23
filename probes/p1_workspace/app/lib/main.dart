import 'package:flutter/material.dart';

import 'probe.dart';

void main() => runApp(const ProbeApp());

class ProbeApp extends StatelessWidget {
  const ProbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: FutureBuilder<Map<String, Object?>>(
            future: runProbe(),
            builder: (context, snap) {
              final text = snap.hasError
                  ? 'Ошибка: ${snap.error}'
                  : snap.hasData
                      ? snap.data!.entries.map((e) => '${e.key}: ${e.value}').join('\n')
                      : 'Проверка…';
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(text, style: const TextStyle(fontSize: 18)),
              );
            },
          ),
        ),
      ),
    );
  }
}
