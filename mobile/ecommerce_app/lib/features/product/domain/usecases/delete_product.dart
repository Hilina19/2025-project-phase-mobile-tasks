import '../../../../core/usecases/base_usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call({String? params}) async {
    return await repository.deleteProduct(params!);
  }
}
