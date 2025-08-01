// test/features/product/data/datasources/product_local_data_source_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

// This annotation generates a mock class for SharedPreferences
@GenerateMocks([SharedPreferences])
import 'product_local_data_source_test.mocks.dart';

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    // Initialize the mock and the data source before each test
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  // A helper function to create a list of product models
  final tProductModels = [
    ProductModel(
        id: '1',
        name: 'Product 1',
        description: 'Desc 1',
        price: 10,
        imageUrl: 'url1'),
    ProductModel(
        id: '2',
        name: 'Product 2',
        description: 'Desc 2',
        price: 20,
        imageUrl: 'url2'),
  ];

  // A helper function to create the fixture (the raw JSON string)
  String fixture(String name) {
    // For this test, we can just create the JSON string directly
    return json.encode(tProductModels.map((p) => p.toJson()).toList());
  }

  group('getLastProducts', () {
    final tProductsJsonString = fixture('products.json');
    final tProductModelList = tProductModels;

    test(
      'should return List<ProductModel> from SharedPreferences when there is one in the cache',
      () async {
        // Arrange: Setup the mock to return the JSON string when getString is called
        when(mockSharedPreferences.getString(any))
            .thenReturn(tProductsJsonString);

        // Act: Call the method we are testing
        final result = await dataSource.getLastProducts();

        // Assert: Check that the result is what we expect
        expect(result, equals(tProductModelList));
        // Verify that getString was called with the correct key
        verify(mockSharedPreferences.getString(CACHED_PRODUCTS));
      },
    );

    test(
      'should throw a CacheException when there is no cached value',
      () async {
        // Arrange: Setup the mock to return null
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // Act: The call to the method
        final call = dataSource.getLastProducts;

        // Assert: Expect the call to throw the specific exception
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheProducts', () {
    final tProductModelList = tProductModels;

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // Arrange: Setup the mock to successfully complete the `setString` operation
        // Since setString returns a Future<bool>, we use thenReturn(Future.value(true))
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // Act: Call the method we are testing
        await dataSource.cacheProducts(tProductModelList);

        // Assert: Verify that setString was called with the correct key and data
        final expectedJsonString = json.encode(
          tProductModelList.map((product) => product.toJson()).toList(),
        );
        verify(mockSharedPreferences.setString(
          CACHED_PRODUCTS,
          expectedJsonString,
        ));
      },
    );
  });
}
