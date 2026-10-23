import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'device_probes.dart';
import 'probe.dart';

void main() => runApp(const MaterialApp(home: ProbeScreen()));

/// Экран проб этапа 7. Кнопка «Скопировать отчёт» кладёт весь журнал в буфер обмена,
/// чтобы прислать его в чат.
class ProbeScreen extends StatefulWidget {
  const ProbeScreen({super.key});

  @override
  State<ProbeScreen> createState() => _ProbeScreenState();
}

class _ProbeScreenState extends State<ProbeScreen> {
  final _log = <String>[];
  String _heard = '';
  bool _listening = false;

  void _add(String line) {
    final t = DateTime.now().toIso8601String().substring(11, 19);
    setState(() => _log.add('$t $line'));
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      _add('ОШИБКА: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _add('Устройство: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
    _run(() async {
      final r = await runProbe();
      _add('P2 база: $r');
    });
  }

  Widget _button(String label, Future<void> Function() action) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FilledButton.tonal(onPressed: () => _run(action), child: Text(label)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пробы этапа 7')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('P4 · Уведомления', style: TextStyle(fontWeight: FontWeight.bold)),
          _button('1. Запросить разрешения', () => requestNotificationPermission(_add)),
          _button('2. Уведомление через 60 с (сверните приложение)', () => scheduleIn(const Duration(seconds: 60), _add)),
          _button('3. Проверить лимит очереди (70)', () => checkPendingLimit(_add)),
          const SizedBox(height: 8),
          const Text('P5 · Распознавание речи', style: TextStyle(fontWeight: FontWeight.bold)),
          _button('Проверить доступность и языки', () => initSpeech(_add)),
          Row(children: [
            Expanded(child: _button('Слушать (на устройстве)', () async {
              setState(() => _listening = true);
              await listen(onDevice: true, log: _add, onText: (t) => setState(() => _heard = t));
            })),
            const SizedBox(width: 8),
            Expanded(child: _button('Слушать (любой режим)', () async {
              setState(() => _listening = true);
              await listen(onDevice: false, log: _add, onText: (t) => setState(() => _heard = t));
            })),
          ]),
          if (_listening)
            _button('Стоп', () async {
              await stopListening();
              setState(() => _listening = false);
            }),
          if (_heard.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('Слышу: $_heard')),
          const Text('P6 · Скорость шифрования', style: TextStyle(fontWeight: FontWeight.bold)),
          _button('Замерить (займёт до минуты)', () => measureCrypto(_add)),
          const Divider(height: 32),
          Row(children: [
            const Expanded(child: Text('Журнал', style: TextStyle(fontWeight: FontWeight.bold))),
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: _log.join('\n')));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Отчёт скопирован')));
                }
              },
              child: const Text('Скопировать отчёт'),
            ),
          ]),
          SelectableText(_log.join('\n'), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
        ],
      ),
    );
  }
}
