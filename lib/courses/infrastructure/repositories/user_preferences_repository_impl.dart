import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart';
import 'package:sigapp/courses/domain/entities/global_preferences.dart';
import 'package:sigapp/courses/domain/entities/semester_preferences.dart';
import 'package:sigapp/courses/infrastructure/models/global_preferences_model.dart';
import 'package:sigapp/courses/infrastructure/models/semester_preferences_model.dart';
import 'package:sigapp/courses/infrastructure/mappers/global_preferences_mapper.dart';
import 'package:sigapp/courses/infrastructure/mappers/semester_preferences_mapper.dart';

@LazySingleton(as: UserPreferencesRepository)
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  UserPreferencesRepositoryImpl(this._firestore, this._logger);

  // ===== SEMESTER-SPECIFIC PREFERENCES =====

  /// Gets typed collection reference for semester preferences
  CollectionReference<SemesterPreferencesModel> _getSemesterPreferencesRef(
    String studentCode,
  ) {
    return _firestore
        .collection('students')
        .doc(studentCode)
        .collection('preferences')
        .doc('_semesters') // Documento "contenedor" para la subcolección
        .collection('data')
        .withConverter<SemesterPreferencesModel>(
          fromFirestore:
              (snap, _) => SemesterPreferencesModel.fromJson(snap.data()!),
          toFirestore: (prefs, _) => prefs.toJson(),
        );
  }

  /// Gets typed document reference for global preferences
  DocumentReference<GlobalPreferencesModel> _getGlobalPreferencesRef(
    String studentCode,
  ) {
    return _firestore
        .collection('students')
        .doc(studentCode)
        .collection('preferences')
        .doc('global')
        .withConverter<GlobalPreferencesModel>(
          fromFirestore:
              (snap, _) => GlobalPreferencesModel.fromJson(snap.data()!),
          toFirestore: (prefs, _) => prefs.toJson(),
        );
  }

  @override
  Future<SemesterPreferences> getSemesterPreferences({
    required String studentCode,
    required String semesterId,
  }) async {
    try {
      final semesterPrefsRef = _getSemesterPreferencesRef(studentCode);
      final doc = await semesterPrefsRef.doc(semesterId).get();

      if (!doc.exists) {
        return SemesterPreferencesMapper.toDomain(
          const SemesterPreferencesModel(),
        );
      }

      return SemesterPreferencesMapper.toDomain(doc.data()!);
    } catch (e, s) {
      _logger.e(
        'Error getting semester preferences for $semesterId',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<SemesterPreferences> updateSemesterPreferences({
    required String studentCode,
    required String semesterId,
    required SemesterPreferences preferences,
  }) async {
    try {
      final semesterPrefsRef = _getSemesterPreferencesRef(studentCode);
      final model = SemesterPreferencesMapper.toInfrastructure(preferences);

      await semesterPrefsRef.doc(semesterId).set(model);
      return preferences;
    } catch (e, s) {
      _logger.e(
        'Error updating semester preferences for $semesterId',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> addSemesterHiddenScheduleEvent({
    required String studentCode,
    required String semesterId,
    required String eventId,
  }) async {
    try {
      final semesterPrefsRef = _getSemesterPreferencesRef(studentCode);

      await semesterPrefsRef.doc(semesterId).update({
        'scheduleHiddenEvents': FieldValue.arrayUnion([eventId]),
      });
    } catch (e, s) {
      _logger.e(
        'Error adding hidden schedule event to semester $semesterId',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  @override
  Future<void> removeSemesterHiddenScheduleEvent({
    required String studentCode,
    required String semesterId,
    required String eventId,
  }) async {
    try {
      final semesterPrefsRef = _getSemesterPreferencesRef(studentCode);

      await semesterPrefsRef.doc(semesterId).update({
        'scheduleHiddenEvents': FieldValue.arrayRemove([eventId]),
      });
    } catch (e, s) {
      _logger.e(
        'Error removing hidden schedule event from semester $semesterId',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  // ===== NEW METHODS FOR GLOBAL PREFERENCES =====

  @override
  Future<GlobalPreferences> getGlobalPreferences({
    required String studentCode,
  }) async {
    try {
      final globalPrefsRef = _getGlobalPreferencesRef(studentCode);
      final doc = await globalPrefsRef.get();

      if (!doc.exists) {
        return GlobalPreferencesMapper.toDomain(const GlobalPreferencesModel());
      }

      return GlobalPreferencesMapper.toDomain(doc.data()!);
    } catch (e, s) {
      _logger.e('Error getting global preferences', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<GlobalPreferences> updateGlobalPreferences({
    required String studentCode,
    required GlobalPreferences preferences,
  }) async {
    try {
      final globalPrefsRef = _getGlobalPreferencesRef(studentCode);
      final model = GlobalPreferencesMapper.toInfrastructure(preferences);

      await globalPrefsRef.set(model);
      return preferences;
    } catch (e, s) {
      _logger.e('Error updating global preferences', error: e, stackTrace: s);
      rethrow;
    }
  }
}
