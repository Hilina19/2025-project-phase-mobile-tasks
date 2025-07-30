// lib/domain/usecases/view_all_products.dart

import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'base_usecase.dart';

class ViewAllProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;

  ViewAllProductsUseCase(this.repository);

  @override
  Future<List<Product>> call({NoParams? params}) async {
    return await repository.getAllProducts();
  }
}
