import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';

String getFacultyImagePath(Faculty faculty) {
  switch (faculty) {
    case Faculty.agronomy:
      return 'assets/img/facultad-agronomia.png';
    case Faculty.architectureUrban:
      return 'assets/img/facultad-arquitectura-y-urbanismo.png';
    case Faculty.administrativeSciences:
      return 'assets/img/facultad-ciencias-administrativas.png';
    case Faculty.accountingFinancial:
      return 'assets/img/facultad-ciencias-contables-financieras.png';
    case Faculty.sciences:
      return 'assets/img/facultad-ciencias.png';
    case Faculty.healthSciences:
      return 'assets/img/facultad-ciencias-salud.png';
    case Faculty.socialSciencesEducation:
      return 'assets/img/facultad-ciencias-sociales-educacion.png';
    case Faculty.lawPoliticalSciences:
      return 'assets/img/facultad-derecho-ciencias-politicas.png';
    case Faculty.economics:
      return 'assets/img/facultad-economia.png';
    case Faculty.civilEngineering:
      return 'assets/img/facultad-ingenieria-civil.png';
    case Faculty.industrialEngineering:
      return 'assets/img/facultad-ingenieria-industrial.png';
    case Faculty.miningEngineering:
      return 'assets/img/facultad-ingenieria-minas.png';
    case Faculty.fishingEngineering:
      return 'assets/img/facultad-ingenieria-pesquera.png';
    case Faculty.zootechnicsEngineering:
      return 'assets/img/facultad-ingenieria-zootecnia.png';
  }
}
