import 'package:sigapp/student/domain/entities/student_academic_report.dart';
import 'package:sigapp/student/domain/value_objects/semester_context.dart';

class AcademicInfoData {
  final AcademicReport academicReport;
  final SemesterContext semesterContext;
  final AcademicProgram? academicProgram;

  AcademicInfoData({
    required this.academicReport,
    required this.semesterContext,
    required this.academicProgram,
  });
}

enum AcademicProgram {
  administration,
  agricultural,
  agroindustrialFood,
  agronomy,
  environmental,
  architecture,
  biology,
  civil,
  communication,
  accounting,
  law,
  economics,
  initialEducation,
  primaryEducation,
  electronic,
  nursing,
  statistics,
  stomatology,
  physics,
  geological,
  historyGeography,
  industrial,
  informatics,
  languageLiterature,
  mathematics,
  mechatronics,
  medicine,
  mining,
  obstetrics,
  fishing,
  petroleum,
  psychology,
  chemistry,
  veterinary,
  zootechnics,
}

class AcademicProgramIdentifier {
  static AcademicProgram? identifyProgram(String programName) {
    // Normalize the input string: lowercase, remove accents, trim spaces
    final normalizedName = _normalizeString(programName);

    // Try to match with each academic program
    if (_matchAdministration(normalizedName)) {
      return AcademicProgram.administration;
    }
    if (_matchAgricultural(normalizedName)) return AcademicProgram.agricultural;
    if (_matchAgroindustrialFood(normalizedName)) {
      return AcademicProgram.agroindustrialFood;
    }
    if (_matchAgronomy(normalizedName)) return AcademicProgram.agronomy;
    if (_matchEnvironmental(normalizedName)) {
      return AcademicProgram.environmental;
    }
    if (_matchArchitecture(normalizedName)) return AcademicProgram.architecture;
    if (_matchBiology(normalizedName)) return AcademicProgram.biology;
    if (_matchCivil(normalizedName)) return AcademicProgram.civil;
    if (_matchCommunication(normalizedName)) {
      return AcademicProgram.communication;
    }
    if (_matchAccounting(normalizedName)) return AcademicProgram.accounting;
    if (_matchLaw(normalizedName)) return AcademicProgram.law;
    if (_matchEconomics(normalizedName)) return AcademicProgram.economics;
    if (_matchInitialEducation(normalizedName)) {
      return AcademicProgram.initialEducation;
    }
    if (_matchPrimaryEducation(normalizedName)) {
      return AcademicProgram.primaryEducation;
    }
    if (_matchElectronic(normalizedName)) return AcademicProgram.electronic;
    if (_matchNursing(normalizedName)) return AcademicProgram.nursing;
    if (_matchStatistics(normalizedName)) return AcademicProgram.statistics;
    if (_matchStomatology(normalizedName)) return AcademicProgram.stomatology;
    if (_matchPhysics(normalizedName)) return AcademicProgram.physics;
    if (_matchGeological(normalizedName)) return AcademicProgram.geological;
    if (_matchHistoryGeography(normalizedName)) {
      return AcademicProgram.historyGeography;
    }
    if (_matchIndustrial(normalizedName)) return AcademicProgram.industrial;
    if (_matchInformatics(normalizedName)) return AcademicProgram.informatics;
    if (_matchLanguageLiterature(normalizedName)) {
      return AcademicProgram.languageLiterature;
    }
    if (_matchMathematics(normalizedName)) return AcademicProgram.mathematics;
    if (_matchMechatronics(normalizedName)) return AcademicProgram.mechatronics;
    if (_matchMedicine(normalizedName)) return AcademicProgram.medicine;
    if (_matchMining(normalizedName)) return AcademicProgram.mining;
    if (_matchObstetrics(normalizedName)) return AcademicProgram.obstetrics;
    if (_matchFishing(normalizedName)) return AcademicProgram.fishing;
    if (_matchPetroleum(normalizedName)) return AcademicProgram.petroleum;
    if (_matchPsychology(normalizedName)) return AcademicProgram.psychology;
    if (_matchChemistry(normalizedName)) return AcademicProgram.chemistry;
    if (_matchVeterinary(normalizedName)) return AcademicProgram.veterinary;
    if (_matchZootechnics(normalizedName)) return AcademicProgram.zootechnics;

    // If no match was found, return null
    return null;
  }

  // Helper method to normalize strings for better matching
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

  // Three regexp patterns for each academic program

  static bool _matchAdministration(String input) {
    return RegExp(r'administra(c|t)i(o|ó)n').hasMatch(input) ||
        RegExp(r'admin\b').hasMatch(input) ||
        RegExp(r'gesti(o|ó)n empresarial').hasMatch(input);
  }

  static bool _matchAgricultural(String input) {
    return RegExp(r'agr(i|í)cola').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a agr(i|í)cola').hasMatch(input) ||
        RegExp(r'agricultura').hasMatch(input);
  }

  static bool _matchAgroindustrialFood(String input) {
    return RegExp(r'agroindustrial').hasMatch(input) ||
        RegExp(r'industria alimentaria').hasMatch(input) ||
        RegExp(r'aliment(o|a)s').hasMatch(input);
  }

  static bool _matchAgronomy(String input) {
    return RegExp(r'agronom(i|í)a').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a agr(o|ó)noma').hasMatch(input) ||
        RegExp(r'agron(o|ó)m').hasMatch(input);
  }

  static bool _matchEnvironmental(String input) {
    return RegExp(r'ambient(e|al)').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a ambiental').hasMatch(input) ||
        RegExp(r'ecolog(i|í)a').hasMatch(input);
  }

  static bool _matchArchitecture(String input) {
    return RegExp(r'arquitectura').hasMatch(input) ||
        RegExp(r'urbanismo').hasMatch(input) ||
        RegExp(r'dise(n|ñ)o arquitect(o|ó)nico').hasMatch(input);
  }

  static bool _matchBiology(String input) {
    return RegExp(r'biolog(i|í)a').hasMatch(input) ||
        RegExp(r'ciencias biol(o|ó)gicas').hasMatch(input) ||
        RegExp(r'biol(o|ó)g').hasMatch(input);
  }

  static bool _matchCivil(String input) {
    return RegExp(r'civil').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a civil').hasMatch(input) ||
        RegExp(r'construcci(o|ó)n').hasMatch(input);
  }

  static bool _matchCommunication(String input) {
    return RegExp(r'comunicaci(o|ó)n').hasMatch(input) ||
        RegExp(r'ciencias de la comunicaci(o|ó)n').hasMatch(input) ||
        RegExp(r'periodismo').hasMatch(input);
  }

  static bool _matchAccounting(String input) {
    return RegExp(r'contabilidad').hasMatch(input) ||
        RegExp(r'contable').hasMatch(input) ||
        RegExp(r'contador').hasMatch(input);
  }

  static bool _matchLaw(String input) {
    return RegExp(r'derecho').hasMatch(input) ||
        RegExp(r'ciencias pol(i|í)ticas').hasMatch(input) ||
        RegExp(r'leyes').hasMatch(input);
  }

  static bool _matchEconomics(String input) {
    return RegExp(r'econom(i|í)a').hasMatch(input) ||
        RegExp(r'econ(o|ó)mic').hasMatch(input) ||
        RegExp(r'finanzas').hasMatch(input);
  }

  static bool _matchInitialEducation(String input) {
    return RegExp(r'educaci(o|ó)n inicial').hasMatch(input) ||
        RegExp(r'educaci(o|ó)n infantil').hasMatch(input) ||
        RegExp(r'jardin').hasMatch(input);
  }

  static bool _matchPrimaryEducation(String input) {
    return RegExp(r'educaci(o|ó)n primaria').hasMatch(input) ||
        RegExp(r'educaci(o|ó)n b(a|á)sica').hasMatch(input) ||
        RegExp(r'primaria').hasMatch(input);
  }

  static bool _matchElectronic(String input) {
    return RegExp(r'electr(o|ó)nic').hasMatch(input) ||
        RegExp(r'telecomunicaciones').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a electr(o|ó)nica').hasMatch(input);
  }

  static bool _matchNursing(String input) {
    return RegExp(r'enfermer(i|í)a').hasMatch(input) ||
        RegExp(r'enferm\w+').hasMatch(input) ||
        RegExp(r'salud').hasMatch(input) && RegExp(r'cuidados').hasMatch(input);
  }

  static bool _matchStatistics(String input) {
    return RegExp(r'estad(i|í)stica').hasMatch(input) ||
        RegExp(r'estad(i|í)stic').hasMatch(input) ||
        RegExp(r'probabilidad').hasMatch(input);
  }

  static bool _matchStomatology(String input) {
    return RegExp(r'estomatolog(i|í)a').hasMatch(input) ||
        RegExp(r'odontolog(i|í)a').hasMatch(input) ||
        RegExp(r'dental').hasMatch(input);
  }

  static bool _matchPhysics(String input) {
    return RegExp(r'f(i|í)sica').hasMatch(input) ||
        RegExp(r'ciencias f(i|í)sicas').hasMatch(input) ||
        RegExp(r'f(i|í)sic').hasMatch(input);
  }

  static bool _matchGeological(String input) {
    return RegExp(r'geol(o|ó)gica').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a geol(o|ó)gica').hasMatch(input) ||
        RegExp(r'geolog(i|í)a').hasMatch(input);
  }

  static bool _matchHistoryGeography(String input) {
    return RegExp(r'historia y geograf(i|í)a').hasMatch(input) ||
        RegExp(r'historia').hasMatch(input) &&
            RegExp(r'geograf(i|í)a').hasMatch(input) ||
        RegExp(r'hist(o|ó)rico-geogr(a|á)f').hasMatch(input);
  }

  static bool _matchIndustrial(String input) {
    return RegExp(r'industrial(?!\s+alimentaria)').hasMatch(input) ||
        RegExp(
          r'ing(e|é)nier(i|í)a industrial(?!\s+alimentaria)',
        ).hasMatch(input) ||
        RegExp(r'producci(o|ó)n industrial').hasMatch(input);
  }

  static bool _matchInformatics(String input) {
    return RegExp(r'inform(a|á)tica').hasMatch(input) ||
        RegExp(r'computaci(o|ó)n').hasMatch(input) ||
        RegExp(r'sistemas(?!\s+electr(o|ó)nic)').hasMatch(input);
  }

  static bool _matchLanguageLiterature(String input) {
    return RegExp(r'lengua y literatura').hasMatch(input) ||
        RegExp(r'letras').hasMatch(input) ||
        RegExp(r'ling(u|ü)(i|í)stica').hasMatch(input);
  }

  static bool _matchMathematics(String input) {
    return RegExp(r'matem(a|á)tica').hasMatch(input) ||
        RegExp(r'matem(a|á)tic').hasMatch(input) ||
        RegExp(r'c(a|á)lculo').hasMatch(input);
  }

  static bool _matchMechatronics(String input) {
    return RegExp(r'mecatr(o|ó)nica').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a mecatr(o|ó)nica').hasMatch(input) ||
        RegExp(r'rob(o|ó)tica').hasMatch(input);
  }

  static bool _matchMedicine(String input) {
    return RegExp(r'medicina(?!\s+veterinaria)').hasMatch(input) ||
        RegExp(r'medicina humana').hasMatch(input) ||
        RegExp(r'm(e|é)dic').hasMatch(input);
  }

  static bool _matchMining(String input) {
    return RegExp(r'minas').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a de minas').hasMatch(input) ||
        RegExp(r'miner(i|í)a').hasMatch(input);
  }

  static bool _matchObstetrics(String input) {
    return RegExp(r'obstetricia').hasMatch(input) ||
        RegExp(r'obst(e|é)tr').hasMatch(input) ||
        RegExp(r'parto').hasMatch(input);
  }

  static bool _matchFishing(String input) {
    return RegExp(r'pesquera').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a pesquera').hasMatch(input) ||
        RegExp(r'pesca(?!d)').hasMatch(input);
  }

  static bool _matchPetroleum(String input) {
    return RegExp(r'petr(o|ó)leo').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a de petr(o|ó)leo').hasMatch(input) ||
        RegExp(r'petrol(i|í)fer').hasMatch(input);
  }

  static bool _matchPsychology(String input) {
    return RegExp(r'psicolog(i|í)a').hasMatch(input) ||
        RegExp(r'psic(o|ó)log').hasMatch(input) ||
        RegExp(r'salud mental').hasMatch(input);
  }

  static bool _matchChemistry(String input) {
    return RegExp(r'qu(i|í)mica(?!\s+farmac)').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a qu(i|í)mica').hasMatch(input) ||
        RegExp(r'qu(i|í)mic').hasMatch(input);
  }

  static bool _matchVeterinary(String input) {
    return RegExp(r'veterinaria').hasMatch(input) ||
        RegExp(r'medicina veterinaria').hasMatch(input) ||
        RegExp(r'cl(i|í)nica animal').hasMatch(input);
  }

  static bool _matchZootechnics(String input) {
    return RegExp(r'zootecnia').hasMatch(input) ||
        RegExp(r'ing(e|é)nier(i|í)a zootecnia').hasMatch(input) ||
        RegExp(r'producci(o|ó)n animal').hasMatch(input);
  }
}
