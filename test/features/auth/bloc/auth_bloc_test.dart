import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_event.dart';
import 'package:dcc_mobile/features/auth/bloc/auth_state.dart';

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc();
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial()', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    // Note: To fully test AuthBloc, we need to inject AuthService.
    // Currently, AuthService uses static methods and singletons.
    // In the future, refactor AuthService to be injectable for deeper testing.
  });
}
