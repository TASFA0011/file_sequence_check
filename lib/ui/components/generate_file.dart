import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

class GenerateFile {
  static Future<String?> saveFile(Uint8List data,
      [String? suggestedName]) async {
    final String? path = await getSavePath(
        suggestedName: suggestedName,
        acceptedTypeGroups: const [
          XTypeGroup(label: "Fichiers XLSX", extensions: ['xlsx'])
        ]);

    if (path == null) {
      return null;
    }

    await File(path).writeAsBytes(data);
    return path;
  }
}
