
import 'package:flutter/material.dart';
import 'new_note_photo.dart';
import 'new_note_voice.dart';
import 'search_order.dart';
import 'export_excel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text('Floristas Alicia', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black87, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16, runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _btn(context, '📸 Nueva nota', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewNotePhotoScreen()))),
                  _btn(context, '🎤 Dictado', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewNoteVoiceScreen()))),
                  _btn(context, '🔍 Pedido', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchOrderScreen()))),
                  _btn(context, '📊 Excel', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportExcelScreen()))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(BuildContext c, String label, VoidCallback onTap) {
    return SizedBox(
      width: 240, height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
