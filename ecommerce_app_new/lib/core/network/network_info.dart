// This is the contract for our network info service.
// It ensures that any implementation will have a way to check for a connection.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
