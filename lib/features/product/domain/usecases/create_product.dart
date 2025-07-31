import '../../../../core/usecases/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<void> call({Product? params}) async {
    return await repository.createProduct(params!);
  }
}
