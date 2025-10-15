
import 'package:flutter/material.dart';
import '../db.dart';

class SearchOrderScreen extends StatefulWidget {
  const SearchOrderScreen({super.key});

  @override
  State<SearchOrderScreen> createState() => _SearchOrderScreenState();
}

class _SearchOrderScreenState extends State<SearchOrderScreen> {
  final _queryCtrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  Future<void> _search() async {
    final db = await AppDb().database;
    final q = _queryCtrl.text.trim();
    if (q.isEmpty) return;
    _results = await db.query('orders',
        where: 'orderNumber LIKE ? OR customerName LIKE ?',
        whereArgs: ['%$q%', '%$q%'],
        orderBy: 'createdAt DESC');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _queryCtrl, decoration: const InputDecoration(labelText: 'Número de pedido o nombre')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _search, child: const Text('Buscar')),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: _results.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, i) {
                  final r = _results[i];
                  return ListTile(
                    title: Text('${r['orderNumber']} - ${r['customerName']}'),
                    subtitle: Text(r['details'] ?? ''),
                    trailing: Text(DateTime.parse(r['createdAt']).toLocal().toString().split('.').first),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
