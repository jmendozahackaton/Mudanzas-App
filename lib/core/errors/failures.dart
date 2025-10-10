import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message); // ← Super parameter
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message); // ← Super parameter
}

class CacheFailure extends Failure {
  const CacheFailure(super.message); // ← Super parameter
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message); // ← Super parameter
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message); // ← Super parameter
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message); // ← Super parameter
}
