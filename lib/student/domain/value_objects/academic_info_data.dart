import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';

class AcademicInfoData {
  final AcademicReport academicReport;
  final SemesterContext semesterContext;

  AcademicInfoData({
    required this.academicReport,
    required this.semesterContext,
  });
}

/// FACULTAD DE AGRONOMÍA
/// - Agronomía
/// - Ingeniería Agrícola
///
/// FACULTAD DE ARQUITECTURA Y URBANISMO
/// - Arquitectura y Urbanismo
///
/// FACULTAD DE CIENCIAS ADMINISTRATIVAS
/// - Ciencias Administrativas
///
/// FACULTAD DE CIENCIAS CONTABLES Y FINANCIERAS
/// - Ciencias Contables y Financieras
///
/// FACULTAD DE CIENCIAS
/// - Física
/// - Ciencias Biológicas
/// - Matemática
/// - Ingeniería Electrónica y Telecomunicaciones
/// - Estadística
///
/// FACULTAD DE CIENCIAS DE LA SALUD
/// - Medicina Humana
/// - Enfermería
/// - Estomatología
/// - Obstetricia
/// - Psicología
///
/// FACULTAD DE CIENCIAS SOCIALES Y EDUCACIÓN
/// - Historia y Geografía
/// - Lengua y Literatura
/// - Educación Inicial
/// - Educación Primaria
/// - Ciencias de la Comunicación
///
/// FACULTAD DE DERECHO Y CIENCIAS POLITICAS
/// - Derecho y Ciencias Políticas
///
/// FACULTAD DE ECONOMÍA
/// - Economía
///
/// FACULTAD DE INGENIERÍA CIVIL
/// - Ingeniería Civil
///
/// FACULTAD DE INGENIERÍA INDUSTRIAL
/// - Ingeniería Industrial
/// - Ingeniería Informática
/// - Ingeniería Industrial e Industrias Alimentarias
/// - Ingeniería Mecatrónica
///
/// FACULTAD DE INGENIERÍA DE MINAS
/// - Ingeniería de Minas
/// - Ingeniería Geológica
/// - Ingeniería de Petróleo
/// - Ingeniería Química
/// - Ingeniería de Ambiental y Seguridad Industrial
///
/// FACULTAD DE INGENIERÍA PESQUERA
/// - Ingeniería Pesquera
///
/// FACULTAD DE INGENIERÍA ZOOTECNIA
/// - Ingeniería Zootecnia
/// - Medicina Veterinaria
enum Faculty {
  agronomy,
  architectureUrban,
  administrativeSciences,
  accountingFinancial,
  sciences,
  healthSciences,
  socialSciencesEducation,
  lawPoliticalSciences,
  economics,
  civilEngineering,
  industrialEngineering,
  miningEngineering,
  fishingEngineering,
  zootechnicsEngineering,
}

class FacultyIdentifier {
  static Faculty? identifyFaculty(String facultyName) {
    // Normalize the input string: lowercase, remove accents, trim spaces
    final normalizedName = _normalizeString(facultyName);

    // Try to match with each faculty
    if (_matchAgronomy(normalizedName)) return Faculty.agronomy;
    if (_matchArchitectureUrban(normalizedName)) {
      return Faculty.architectureUrban;
    }
    if (_matchAdministrativeSciences(normalizedName)) {
      return Faculty.administrativeSciences;
    }
    if (_matchAccountingFinancial(normalizedName)) {
      return Faculty.accountingFinancial;
    }
    if (_matchSciences(normalizedName)) return Faculty.sciences;
    if (_matchHealthSciences(normalizedName)) return Faculty.healthSciences;
    if (_matchSocialSciencesEducation(normalizedName)) {
      return Faculty.socialSciencesEducation;
    }
    if (_matchLawPoliticalSciences(normalizedName)) {
      return Faculty.lawPoliticalSciences;
    }
    if (_matchEconomics(normalizedName)) return Faculty.economics;
    if (_matchCivilEngineering(normalizedName)) return Faculty.civilEngineering;
    if (_matchIndustrialEngineering(normalizedName)) {
      return Faculty.industrialEngineering;
    }
    if (_matchMiningEngineering(normalizedName)) {
      return Faculty.miningEngineering;
    }
    if (_matchFishingEngineering(normalizedName)) {
      return Faculty.fishingEngineering;
    }
    if (_matchZootechnicsEngineering(normalizedName)) {
      return Faculty.zootechnicsEngineering;
    }

    // If no match was found, return null
    return null;
  }

  static String _normalizeString(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[áàäâã]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöôõ]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'ñ'), 'n');
  }

  // Matching methods for each faculty

  static bool _matchAgronomy(String input) {
    return RegExp(r'^agronomia$').hasMatch(input);
  }

  static bool _matchArchitectureUrban(String input) {
    return RegExp(r'arquitectura y urbanismo').hasMatch(input) ||
        RegExp(r'arquitectura.*urbanismo').hasMatch(input);
  }

  static bool _matchAdministrativeSciences(String input) {
    return RegExp(r'ciencias administrativas').hasMatch(input);
  }

  static bool _matchAccountingFinancial(String input) {
    return RegExp(r'ciencias contables y financieras').hasMatch(input) ||
        RegExp(r'contables.*financieras').hasMatch(input);
  }

  static bool _matchSciences(String input) {
    return RegExp(
      r'^ciencias(?!\s+(administrativas|contables|sociales|de la salud|politicas))',
    ).hasMatch(input);
  }

  static bool _matchHealthSciences(String input) {
    return RegExp(r'ciencias de la salud').hasMatch(input);
  }

  static bool _matchSocialSciencesEducation(String input) {
    return RegExp(r'ciencias sociales y educacion').hasMatch(input);
  }

  static bool _matchLawPoliticalSciences(String input) {
    return RegExp(r'derecho y ciencias politicas').hasMatch(input) ||
        RegExp(r'derecho.*politicas').hasMatch(input);
  }

  static bool _matchEconomics(String input) {
    return RegExp(r'^economia$').hasMatch(input);
  }

  static bool _matchCivilEngineering(String input) {
    return RegExp(r'ingenieria civil').hasMatch(input) ||
        RegExp(r'^civil$').hasMatch(input);
  }

  static bool _matchIndustrialEngineering(String input) {
    return RegExp(r'ingenieria industrial').hasMatch(input) ||
        RegExp(r'^industrial$').hasMatch(input);
  }

  static bool _matchMiningEngineering(String input) {
    return RegExp(r'ingenieria de minas').hasMatch(input) ||
        RegExp(r'^minas$').hasMatch(input);
  }

  static bool _matchFishingEngineering(String input) {
    return RegExp(r'ingenieria pesquera').hasMatch(input) ||
        RegExp(r'^pesquera$').hasMatch(input);
  }

  static bool _matchZootechnicsEngineering(String input) {
    return RegExp(r'ingenieria zootecnia').hasMatch(input) ||
        RegExp(r'^zootecnia$').hasMatch(input);
  }
}
