
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import '../db.dart';

class ExportExcelScreen extends StatefulWidget {
  const ExportExcelScreen({super.key});

  @override
  State<ExportExcelScreen> createState() => _ExportExcelScreenState();
}

class _ExportExcelScreenState extends State<ExportExcelScreen> {
  DateTimeRange? _range;
  String? _lastFilePath;

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showDateRangePicker(context: context, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 1), initialDateRange: DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now));
    if (r != null) setState(() => _range = r);
  }

  Future<void> _export() async {
    final db = await AppDb().database;
    String where = '';
    List<dynamic> args = [];
    if (_range != null) {
      where = 'createdAt BETWEEN ? AND ?';
      args = [_range!.start.toIso8601String(), _range!.end.toIso8601String()];
    }
    final rows = await db.query('orders', where: where.isEmpty ? null : where, whereArgs: args, orderBy: 'createdAt ASC, orderNumber ASC');
    final excel = Excel.createExcel();
    final sheet = excel['Pedidos'];
    sheet.appendRow(['Fecha', 'Nº Pedido', 'Cliente', 'Detalle', 'Ubicación']);
    int line = 1;
    for (final r in rows) {
      sheet.appendRow([r['createdAt'], r['orderNumber'], r['customerName'], r['details'], r['location'] ?? '']);
      line++;
      // The 25-lines-per-page specification would be for printing; Excel file will contain data; page breaks can be added later if needed.
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/pedidos_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final bytes = excel.encode();
    final file = File(path)..createSync(recursive: true);
    await file.writeAsBytes(bytes!);
    setState(() => _lastFilePath = path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Excel guardado: $path')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exportar a Excel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: _pickRange, child: Text(_range == null ? 'Elegir rango de fechas' : 'Rango: ${_range!.start.toLocal().toString().split(" ").first} - ${_range!.end.toLocal().toString().split(" ").first}')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _export, child: const Text('Generar Excel (.xlsx)')),
            if (_lastFilePath != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text('Último archivo: $_lastFilePath')),
          ],
        ),
      ),
    );
  }
}
