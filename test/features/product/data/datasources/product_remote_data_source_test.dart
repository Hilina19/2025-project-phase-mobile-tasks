import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce_app/core/api/api_client.dart'; // <-- Import new client
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

// Manual Mock for ApiClient
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = ProductRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  // Helper for creating a product list fixture
  Map<String, dynamic> productListFixture() {
    final products = [
      {
        "id": 1,
        "title": "iPhone 9",
        "description": "An apple mobile which is nothing like apple",
        "price": 549,
        "thumbnail": "url1"
      },
    ];
    return {'products': products};
  }

  group('getAllProducts', () {
    final tProductModels = [
      ProductModel.fromJson(productListFixture()['products']![0])
    ];

    test(
      'should call apiClient.get with the correct endpoint',
      () async {
        // arrange
        when(mockApiClient.get(any))
            .thenAnswer((_) async => productListFixture());
        // act
        await dataSource.getAllProducts();
        // assert
        verify(mockApiClient.get('/products'));
      },
    );

    test(
      'should return List<ProductModel> when the call is successful',
      () async {
        // arrange
        when(mockApiClient.get(any))
            .thenAnswer((_) async => productListFixture());
        // act
        final result = await dataSource.getAllProducts();
        // assert
        expect(result, equals(tProductModels));
      },
    );

    test(
      'should throw a ServerException when the call is unsuccessful',
      () async {
        // arrange
        when(mockApiClient.get(any)).thenThrow(ServerException());
        // act
        final call = dataSource.getAllProducts;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
