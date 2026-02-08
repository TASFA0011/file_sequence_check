import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

class GeneratePdf {
  static Future<String?> saveFile(Uint8List data,
      [String? suggestedName]) async {
    final String? path = await getSavePath(
        suggestedName: suggestedName,
        acceptedTypeGroups: const [
          XTypeGroup(label: "Fichiers PDF", extensions: ['pdf'])
        ]);

    if (path == null) {
      return null;
    }

    await File(path).writeAsBytes(data);
    return path;
  }

  static Future<String?> saveMultipleFiles(List<Uint8List> filesData, List<String> suggestedNames) async {
    if (filesData.isEmpty || filesData.length != suggestedNames.length) {
      log("Erreur : Liste de fichiers et noms incompatibles.");
      return null;
    }

    try {
      // Demande à l'utilisateur de choisir un dossier
      final String? directoryPath = await getDirectoryPath();

      if (directoryPath == null) {
        log("Opération annulée par l'utilisateur.");
        return null;
      }

      List<String> savedPaths = [];

      for (int i = 0; i < filesData.length; i++) {
        if (filesData[i].isEmpty) continue; // Ignore les fichiers vides

        String filePath = '$directoryPath/${suggestedNames[i]}.pdf';
        final File file = File(filePath);

        await file.writeAsBytes(filesData[i], flush: true);
        savedPaths.add(filePath);
      }

      return directoryPath; // Retourne la liste des fichiers enregistrés
    } catch (e) {
      log("Erreur lors de l'enregistrement des fichiers PDF : $e");
      return null;
    }
  }
}
