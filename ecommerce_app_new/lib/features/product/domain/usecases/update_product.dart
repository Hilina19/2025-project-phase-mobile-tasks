import '../../../../core/usecases/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<void> call({Product? params}) async {
    return await repository.updateProduct(params!);
  }
}
