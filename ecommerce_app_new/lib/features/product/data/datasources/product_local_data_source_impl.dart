import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

const CACHED_PRODUCTS = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) {
    // 1. Convert List<ProductModel> to List<Map<String, dynamic>>
    final productListJson =
        productsToCache.map((product) => product.toJson()).toList();
    // 2. Encode the list into a JSON string and save it.
    return sharedPreferences.setString(
      CACHED_PRODUCTS,
      json.encode(productListJson),
    );
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(CACHED_PRODUCTS);
    if (jsonString != null) {
      // 1. Decode the string back to a List<dynamic> (which is List<Map<String, dynamic>>)
      final List<dynamic> jsonList = json.decode(jsonString);
      // 2. Map the list of JSON objects to a list of ProductModel objects.
      final products = jsonList
          .map((jsonProduct) => ProductModel.fromJson(jsonProduct))
          .toList();
      return Future.value(products);
    } else {
      // If no data is cached, throw an exception.
      throw CacheException();
    }
  }
}
