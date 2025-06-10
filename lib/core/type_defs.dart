import 'package:fpdart/fpdart.dart';
import 'package:temp_flutter_fix/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
