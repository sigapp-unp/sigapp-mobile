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
  Future<AcademicInfoData> execute({bool? forceRefresh}) async {
    if (_cache != null && forceRefresh != true) {
      return _cache!;
    }

    final result = await _inner.execute(forceRefresh: forceRefresh);
    _cache = result;
    return result;
  }
}
