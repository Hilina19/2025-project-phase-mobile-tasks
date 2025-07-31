import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package/mockito/mockito.dart';

import 'package:your_app_name/core/error/exceptions.dart'; // Replace with your app name
import 'package:your_app_name/core/network/network_info.dart';
import 'package:your_app_name/features/product/data/datasources/product_local_data_source.dart';
import 'package:your_app_name/features/product/data/datasources/product_remote_data_source.dart';
import 'package:your_app_name/features/product/data/models/product_model.dart';
import 'package:your_app_name/features/product/data/repositories/product_repository_impl.dart';

// Generate mocks for the dependencies.
@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])
import 'product_repository_impl_test.mocks.dart'; // This file will be generated

// The rest of the test code will go below...
