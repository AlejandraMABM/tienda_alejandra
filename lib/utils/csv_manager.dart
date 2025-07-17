import 'dart:io';
import 'package:csv/csv.dart';

class CsvManager {
  final String filePath;
  CsvManager(this.filePath);

  static const List<String> _headers = [
    'id',
    'nombre',
    'precio',
    'cantidad',
    'categoria',
    'imagenUrl',
  ];

  Future<List<Map<String, dynamic>>> readProducts() async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('${_headers.join(",")}\n');
      return [];
    }

    final txt = await file.readAsString();

    if (txt.trim().isEmpty) return [];

    final rows = const CsvToListConverter(eol: '\n').convert(txt);

    if (rows.isEmpty || rows.length < 2) return [];

    final fileHeaders = rows.first.map((e) => e.toString().trim()).toList();

    return rows.skip(1).map((row) {
      final map = <String, dynamic>{};
      for (int i = 0; i < _headers.length; i++) {
        final key = _headers[i];
        final colIndex = fileHeaders.indexOf(key);
        map[key] = (colIndex != -1 && colIndex < row.length)
            ? row[colIndex].toString().trim()
            : '';
      }
      return map;
    }).toList();
  }

  Future<void> writeProducts(List<Map<String, dynamic>> data) async {
    final file = File(filePath);

    if (data.isEmpty) {
      await file.writeAsString('${_headers.join(",")}\n');
      return;
    }

    final rows = <List<dynamic>>[];
    rows.add(_headers); // Agregar encabezados

    for (final item in data) {
      final row = _headers.map((h) => item[h]?.toString() ?? '').toList();
      rows.add(row);
    }

    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }
}

