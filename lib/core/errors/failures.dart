import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class ServerFailure extends Failure {
  final String message;
  final String code;
  final StackTrace? stackTrace;

  ServerFailure({
    required this.message,
    required this.code,
    this.stackTrace,
  }) : super([message, code, stackTrace]);
}

class NoInternetFailure extends Failure {}
