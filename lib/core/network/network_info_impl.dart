import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'network_info.dart';

// The concrete implementation of the NetworkInfo contract using the internet_connection_checker package.
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
