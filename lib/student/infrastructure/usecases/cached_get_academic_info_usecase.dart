import 'package:injectable/injectable.dart';
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart';
import 'package:sigapp/student/domain/value_objects/academic_info_data.dart';

@Singleton(as: GetAcademicInfoUseCase)
class CachedGetAcademicInfoUseCase implements GetAcademicInfoUseCase {
  final GetAcademicInfoUseCase _inner;
  AcademicInfoData? _cache;

  CachedGetAcademicInfoUseCase(
    @Named('getAcademicInfoUseCaseImpl') this._inner,
  );

  @override
  Future<AcademicInfoData> execute() async {
    if (_cache != null) {
      return _cache!;
    }

    final result = await _inner.execute();
    _cache = result;
    return result;
  }

  @override
  void clearCache() {
    _cache = null;
  }
}
