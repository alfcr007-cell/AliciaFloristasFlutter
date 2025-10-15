
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrParser {
  /// Extracts order number (pattern like 29/17), customer name && details heuristic.
  static Map<String, String> parseFromText(String text) {
    final lines = text.split(RegExp(r'\r?\n')).map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    String orderNumber = '';
    final orderRegex = RegExp(r'\b(\d{1,2})\s*/\s*(\d{1,3})\b');
    for (final l in lines) {
      final m = orderRegex.firstMatch(l);
      if (m != null) { orderNumber = '${m.group(1)}/${m.group(2)}'; break; }
    }
    String customerName = '';
    if (lines.isNotEmpty) customerName = lines.firstWhere((l) => l.toLowerCase().contains('cliente') == false && l.contains('/') == false, orElse: () => '');
    String details = lines.join(' ');
    return {
      'orderNumber': orderNumber,
      'customerName': customerName,
      'details': details,
    };
  }

  static Future<String> recognizeText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();
    final recognized = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognized.text;
  }
}

class VoiceParser {
  /// Expect phrases like: "Pedido 31 barra 2, cliente Ana López, ramo de rosas rojas"
  static Map<String, String> parseFromTranscript(String t) {
    String orderNumber = '';
    final orderRegex = RegExp(r'(\d{1,2})\s*(?:/|barra)\s*(\d{1,3})', caseSensitive: false);
    final m = orderRegex.firstMatch(t);
    if (m != null) orderNumber = '${m.group(1)}/${m.group(2)}';
    String customerName = '';
    final custRegex = RegExp(r'(?:cliente|para)\s+([a-záéíóúüñ]+(?:\s+[a-záéíóúüñ]+){0,3})', caseSensitive: false);
    final mc = custRegex.firstMatch(t);
    if (mc != null) customerName = mc.group(1) ?? '';
    final details = t.replaceAll(RegExp(r'pedido.*?,', caseSensitive:false), '').replaceAll(RegExp(r'(cliente|para)\s+[^,]+,', caseSensitive:false), '').trim();
    return {'orderNumber': orderNumber, 'customerName': customerName, 'details': details};
  }
}
