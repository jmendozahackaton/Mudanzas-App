import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../provider/domain/entities/provider_entities.dart';
import '../repositories/admin_repository.dart';

class GetProvidersUseCase {
  final AdminRepository repository;

  GetProvidersUseCase(this.repository);

  Future<Either<Failure, ProviderListEntity>> call(
      GetProvidersParams params) async {
    return await repository.getProviders(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetProvidersParams {
  final int page;
  final int limit;

  GetProvidersParams({required this.page, required this.limit});
}
