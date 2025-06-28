import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static Future<void> shareAssetsFile(
    BuildContext context, {
    required String assetPath,
    String? mimeType,
    String? name,
    String? text,
  }) async {
    try {
      // 1. Cargar la imagen desde assets
      final bytes = await rootBundle.load(assetPath);
      final list = bytes.buffer.asUint8List();

      // // 2. Guardarla en un directorio temporal
      // final tempDir = await getTemporaryDirectory();
      // final file = await File('${tempDir.path}/imagen.png').create();
      // await file.writeAsBytes(list);

      // 3. Compartir la imagen con una descripción
      await Share.shareXFiles([
        XFile.fromData(list, mimeType: mimeType, name: name),
      ], text: text);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al compartir la imagen')));
    }
  }
}
