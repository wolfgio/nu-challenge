import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkUtils {
  Future<bool> get hasInternetAccess;
}

class NetworkUtilsImpl implements NetworkUtils {
  final InternetConnectionChecker connectionChecker;

  NetworkUtilsImpl({required this.connectionChecker});

  @override
  Future<bool> get hasInternetAccess => connectionChecker.hasConnection;
}
