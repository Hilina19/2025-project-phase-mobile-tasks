// lib/domain/usecases/view_product.dart

import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

class ViewProductUseCase implements UseCase<Product, String> {
  final ProductRepository repository;

  ViewProductUseCase(this.repository);

  @override
  Future<Product> call({String? params}) async {
    // A real app would have better error handling for a null id.
    return await repository.getProduct(params!);
  }
}
