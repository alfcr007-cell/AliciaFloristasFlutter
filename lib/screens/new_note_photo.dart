
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils.dart';
import '../db.dart';

class NewNotePhotoScreen extends StatefulWidget {
  const NewNotePhotoScreen({super.key});

  @override
  State<NewNotePhotoScreen> createState() => _NewNotePhotoScreenState();
}

class _NewNotePhotoScreenState extends State<NewNotePhotoScreen> {
  File? _image;
  final _orderCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();

  Future<void> _pick(bool camera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? x = await (camera ? picker.pickImage(source: ImageSource.camera) : picker.pickImage(source: ImageSource.gallery));
    if (x == null) return;
    setState(() => _image = File(x.path));
    final text = await OcrParser.recognizeText(x.path);
    final parsed = OcrParser.parseFromText(text);
    _orderCtrl.text = parsed['orderNumber'] ?? '';
    _nameCtrl.text = parsed['customerName'] ?? '';
    _detailsCtrl.text = parsed['details'] ?? '';
  }

  Future<void> _save() async {
    final db = await AppDb().database;
    await db.insert('orders', {
      'orderNumber': _orderCtrl.text.trim(),
      'customerName': _nameCtrl.text.trim(),
      'details': _detailsCtrl.text.trim(),
      'photoNotePath': _image?.path,
      'createdAt': DateTime.now().toIso8601String(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota guardada')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva nota (foto)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(onPressed: () => _pick(true), icon: const Icon(Icons.photo_camera), label: const Text('Cámara')),
                const SizedBox(width: 12),
                OutlinedButton.icon(onPressed: () => _pick(false), icon: const Icon(Icons.photo), label: const Text('Galería')),
              ],
            ),
            const SizedBox(height: 12),
            if (_image != null) Image.file(_image!, height: 220),
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
