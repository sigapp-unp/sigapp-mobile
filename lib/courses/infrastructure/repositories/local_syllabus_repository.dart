import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import 'package:sigapp/courses/domain/repositories/local_syllabus_repository.dart';

@Singleton(as: LocalSyllabusRepository)
class LocalSyllabusRepositoryImpl implements LocalSyllabusRepository {
  Future<Directory> _getLocalDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final syllabusDir = Directory('${directory.path}/syllabus');
    if (!await syllabusDir.exists()) {
      await syllabusDir.create(recursive: true);
    }
    return syllabusDir;
  }

  Future<File?> _getFile(String scheduledCourseId) async {
    final directory = await _getLocalDirectory();
    final files = directory.listSync();
    for (var file in files) {
      if (file is File && file.path.contains(scheduledCourseId)) {
        return file;
      }
    }
    return null;
  }

  Future<String> _createFilePath(
    String scheduledCourseId,
    String? mimeType,
  ) async {
    final directory = await _getLocalDirectory();
    final extension = mimeType != null ? extensionFromMime(mimeType) : null;
    return '${directory.path}/$scheduledCourseId${extension != null ? '.$extension' : ''}';
  }

  @override
  Future<File> replaceOrCreate(
    String scheduledCourseId,
    Uint8List fileBytes,
    String? mimeType,
  ) async {
    final file = await _getFile(scheduledCourseId);
    if (file != null) await file.delete();
    return await File(
      await _createFilePath(scheduledCourseId, mimeType),
    ).writeAsBytes(fileBytes);
  }

  @override
  Future<File?> get(String scheduledCourseId) async {
    return await _getFile(scheduledCourseId);
  }
}
