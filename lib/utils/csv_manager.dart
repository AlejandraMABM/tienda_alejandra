import 'dart:io';
import 'package:csv/csv.dart';

class CsvManager {
  final String filePath;
  CsvManager(this.filePath);

  Future<List<Map<String, dynamic>>> readProducts() async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('id,nombre,precio,cantidad,categoria\n');
      return [];
    }
    final txt = await file.readAsString();
    if (txt.trim().isEmpty) return [];
    final rows = const CsvToListConverter(eol: '\n').convert(txt);
    if (rows.length < 2) return [];
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    return rows.skip(1).map((row) {
      final map = <String, dynamic>{};
      for (int i = 0; i < headers.length; i++) {
        map[headers[i]] = row.length > i ? row[i].toString() : '';
      }
      return map;
    }).toList();
  }

  Future<void> writeProducts(List<Map<String, dynamic>> data) async {
    final file = File(filePath);
    if (data.isEmpty) {
      await file.writeAsString('id,nombre,precio,cantidad,categoria\n');
      return;
    }
    final headers = data.first.keys.toList();
    final rows = <List<dynamic>>[headers];
    for (final item in data) {
      rows.add(headers.map((h) => item[h] ?? '').toList());
    }
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }
}
