import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';

abstract class GetAcademicInfoUseCase {
  Future<AcademicInfoData> execute({bool? forceRefresh});
}
