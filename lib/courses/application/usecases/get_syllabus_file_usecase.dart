import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/application/exceptions/regeva_authentication_exception.dart';
import 'package:sigapp/courses/application/services/student_session_service.dart';
import 'package:sigapp/courses/domain/repositories/local_syllabus_repository.dart';
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart';
import 'package:sigapp/courses/domain/value-objects/syllabus_download_data.dart';

@lazySingleton
class GetSyllabusFileUsecase {
  final RegevaRepository _regevaRepository;
  final StudentSessionService _studentSessionService;
  final LocalSyllabusRepository _localSyllabusRepository;
  final Logger _logger;

  GetSyllabusFileUsecase(
    this._regevaRepository,
    this._studentSessionService,
    this._localSyllabusRepository,
    this._logger,
  );

  Future<File?> execute(String scheduledCourseId, {bool? forceDownload}) async {
    File? cached;

    if (forceDownload != true) {
      // Try to get the syllabus file from the local repository
      cached = await _localSyllabusRepository.get(scheduledCourseId);
      return cached;
    }

    // If the file is not cached, download it
    final downloadedFile = await _downloadFile(scheduledCourseId);
    if (downloadedFile == null) return null;

    // Save the downloaded file
    cached = await _localSyllabusRepository.replaceOrCreate(
      scheduledCourseId,
      downloadedFile.data,
      downloadedFile.contentType!,
    );

    return cached;
  }

  Future<SyllabusDownloadData?> _downloadFile(String scheduledCourseId) async {
    // Try to get the syllabus file
    try {
      return await _regevaRepository.downloadSyllabus(scheduledCourseId);
    } catch (e, s) {
      _logger.e(
        '[DOMAIN] Error downloading syllabus file: $e',
        error: e,
        stackTrace: s,
      );
      if (e is! RegevaAuthenticationException) rethrow;
    }

    // If the user is not authenticated, authenticate and try again
    final credentials = await _studentSessionService.getInfo();
    await _regevaRepository.authenticate(
      sigaToken1: credentials.regevaToken1,
      sigaToken2: credentials.regevaToken2,
      studentCode: credentials.studentCode,
    );
    return await _regevaRepository.downloadSyllabus(scheduledCourseId);
  }
}
