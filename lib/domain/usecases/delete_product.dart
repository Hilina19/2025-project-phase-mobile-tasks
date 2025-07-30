// lib/domain/usecases/delete_product.dart

import '../repositories/product_repository.dart';
import 'base_usecase.dart';

class DeleteProductUseCase implements UseCase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call({String? params}) async {
    return await repository.deleteProduct(params!);
  }
}
