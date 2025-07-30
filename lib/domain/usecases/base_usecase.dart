// lib/domain/usecases/base_usecase.dart

// A simple base class for use cases.
abstract class UseCase<Type, Params> {
  Future<Type> call({Params params});
}

// Used for use cases that don't require any parameters.
class NoParams {}
