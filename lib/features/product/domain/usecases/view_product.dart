import '../../../../core/usecases/base_usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUseCase implements UseCase<Product, String> {
  final ProductRepository repository;

  ViewProductUseCase(this.repository);

  @override
  Future<Product> call({String? params}) async {
    return await repository.getProduct(params!);
  }
}
