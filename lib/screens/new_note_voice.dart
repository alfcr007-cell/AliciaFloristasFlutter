
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../utils.dart';
import '../db.dart';

class NewNoteVoiceScreen extends StatefulWidget {
  const NewNoteVoiceScreen({super.key});

  @override
  State<NewNoteVoiceScreen> createState() => _NewNoteVoiceScreenState();
}

class _NewNoteVoiceScreenState extends State<NewNoteVoiceScreen> {
  final _orderCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  late stt.SpeechToText _speech;
  bool _listening = false;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _toggleListen() async {
    if (!_listening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _listening = true);
        _speech.listen(onResult: (r) {
          setState(() {
            _transcript = r.recognizedWords;
            final parsed = VoiceParser.parseFromTranscript(_transcript);
            _orderCtrl.text = parsed['orderNumber'] ?? '';
            _nameCtrl.text = parsed['customerName'] ?? '';
            _detailsCtrl.text = parsed['details'] ?? '';
          });
        });
      }
    } else {
      await _speech.stop();
      setState(() => _listening = false);
    }
  }

  Future<void> _save() async {
    final db = await AppDb().database;
    await db.insert('orders', {
      'orderNumber': _orderCtrl.text.trim(),
      'customerName': _nameCtrl.text.trim(),
      'details': _detailsCtrl.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota guardada')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva nota (voz)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _toggleListen,
              icon: Icon(_listening ? Icons.stop : Icons.mic),
              label: Text(_listening ? 'Detener' : 'Dictar'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _orderCtrl, decoration: const InputDecoration(labelText: 'Número de pedido (ej. 29/17)')),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del cliente')),
            TextField(controller: _detailsCtrl, decoration: const InputDecoration(labelText: 'Detalle del pedido'), maxLines: 4),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
