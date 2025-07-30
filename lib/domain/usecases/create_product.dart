// lib/domain/usecases/create_product.dart

import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

class CreateProductUseCase implements UseCase<void, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<void> call({Product? params}) async {
    // A real app would have better error handling for a null product.
    return await repository.createProduct(params!);
  }
}
