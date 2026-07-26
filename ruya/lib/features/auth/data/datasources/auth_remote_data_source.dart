import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> register({required String name, required String email, required String password});
}

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    if (email == 'ahmed@example.com' && password == 'password123') {
      return const UserModel(
        id: '1',
        name: 'Ahmed Hassan',
        email: 'ahmed@example.com',
      );
    } else {
      throw ServerFailure('Incorrect email or password');
    }
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency

    return UserModel(
      id: '2',
      name: name,
      email: email,
    );
  }
}
