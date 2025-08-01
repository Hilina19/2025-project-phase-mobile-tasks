import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

// Generate a MockClient using the Mockito package.
@GenerateMocks([http.Client])
import 'product_remote_data_source_test.mocks.dart';

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String fixture) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture, 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  // Helper for creating a product list fixture
  String productListFixture() {
    final products = [
      {
        "id": 1,
        "title": "iPhone 9",
        "description": "An apple mobile which is nothing like apple",
        "price": 549,
        "thumbnail": "url1"
      },
    ];
    // DummyJSON wraps the list in a "products" key
    return json.encode({'products': products});
  }

  // Helper for a single product fixture
  String singleProductFixture() {
    return json.encode({
      "id": 1,
      "title": "iPhone 9",
      "description": "An apple mobile which is nothing like apple",
      "price": 549,
      "thumbnail": "url1"
    });
  }

  group('getAllProducts', () {
    final tProductModels = [
      ProductModel.fromJson(json.decode(singleProductFixture()))
    ];

    test(
      'should perform a GET request on a URL with products being the endpoint',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(productListFixture());
        // act
        await dataSource.getAllProducts();
        // assert
        verify(mockHttpClient.get(
          Uri.parse('${ProductRemoteDataSourceImpl.BASE_URL}/products'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return List<ProductModel> when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200(productListFixture());
        // act
        final result = await dataSource.getAllProducts();
        // assert
        expect(result, equals(tProductModels));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getAllProducts;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });

  // You would continue this pattern for getProduct, createProduct, updateProduct, and deleteProduct...
}
