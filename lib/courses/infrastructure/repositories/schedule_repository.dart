import 'package:injectable/injectable.dart';
import 'package:sigapp/core/infrastructure/http/siga_client.dart';
import 'package:sigapp/courses/domain/repositories/schedule_repository.dart';
import 'package:sigapp/courses/domain/value-objects/raw_class_schedule.dart';
import 'package:sigapp/courses/infrastructure/models/get_class_schedule.dart';

@LazySingleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final SigaClient _sigaClient;

  ScheduleRepositoryImpl(this._sigaClient);

  @override
  Future<List<RawClassSchedule>> getClassSchedule(String semesterId) async {
    // {"results":[{"ExtensionData":{},"HoraFinal":"\/Date(1307539800000)\/","HoraInicio":"\/Date(1307534400000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"DERECHO INFORMATICO ? PII-A14-4P","Sabado":"","Viernes":"SISTEMAS DE INFORMACION GERENCIAL ? I-6"},{"ExtensionData":{},"HoraFinal":"\/Date(1307545200000)\/","HoraInicio":"\/Date(1307539800000)\/","Jueves":"","Lunes":"","Martes":"SISTEMAS DE INFORMACION GERENCIAL ? I-6","Miercoles":"","Sabado":"","Viernes":"DERECHO INFORMATICO ? PII-A14-4P"},{"ExtensionData":{},"HoraFinal":"\/Date(1307552400000)\/","HoraInicio":"\/Date(1307545200000)\/","Jueves":"DERECHO INFORMATICO ? PII-A14-4P","Lunes":"SISTEMAS DE INFORMACION GERENCIAL ? I-6","Martes":"","Miercoles":"","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307556000000)\/","HoraInicio":"\/Date(1307552400000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"INGENIERIA DE SOFTWARE ? PII-A14-4P","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307559600000)\/","HoraInicio":"\/Date(1307552400000)\/","Jueves":"QUIMICA GENERAL ? PII-A02-1P","Lunes":"INGENIERIA DE SOFTWARE ? PII-A14-4P","Martes":"INGENIERIA DE SOFTWARE ? PII-A14-4P","Miercoles":"","Sabado":"","Viernes":"QUIMICA GENERAL ? PII-A02-1P"},{"ExtensionData":{},"HoraFinal":"\/Date(1307559600000)\/","HoraInicio":"\/Date(1307556000000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"QUIMICA GENERAL ? PII-A02-1P","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307563200000)\/","HoraInicio":"\/Date(1307559600000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"LOGISTICA EMPRESARIAL ? PII-A10-3P","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307566800000)\/","HoraInicio":"\/Date(1307559600000)\/","Jueves":"ANALISIS DE ALGORITMOS ? PII-A10-3P","Lunes":"LOGISTICA EMPRESARIAL ? PII-A10-3P","Martes":"LOGISTICA EMPRESARIAL ? PII-A10-3P","Miercoles":"","Sabado":"","Viernes":"ANALISIS DE ALGORITMOS ? PII-A10-3P"},{"ExtensionData":{},"HoraFinal":"\/Date(1307566800000)\/","HoraInicio":"\/Date(1307563200000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"ANALISIS DE ALGORITMOS ? PII-A10-3P","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307572200000)\/","HoraInicio":"\/Date(1307566800000)\/","Jueves":"SISTEMAS OPERATIVOS ? PII-A02-1P","Lunes":"","Martes":"","Miercoles":"","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307577600000)\/","HoraInicio":"\/Date(1307572200000)\/","Jueves":"","Lunes":"SISTEMAS OPERATIVOS ? PII-A02-1P","Martes":"","Miercoles":"","Sabado":"","Viernes":""},{"ExtensionData":{},"HoraFinal":"\/Date(1307584800000)\/","HoraInicio":"\/Date(1307577600000)\/","Jueves":"","Lunes":"","Martes":"","Miercoles":"","Sabado":"","Viernes":"SISTEMAS OPERATIVOS ? PII-A02-1P"}],"total":12}
    final response = await _sigaClient.http.post(
      '/Academico/ListarHorario',
      data: {'semestre': semesterId},
    );
    final models =
        (response.data['results'] as List)
            .map((json) => GetClassScheduleModel.fromJson(json))
            .toList();
    return models
        .map(
          (model) => RawClassSchedule(
            startHour: model.HoraInicio,
            endHour: model.HoraFinal,
            monday: model.Lunes,
            tuesday: model.Martes,
            wednesday: model.Miercoles,
            thursday: model.Jueves,
            friday: model.Viernes,
            saturday: model.Sabado,
          ),
        )
        .toList();
  }
}
