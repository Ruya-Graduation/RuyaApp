import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ruya/features/auth/presentation/cubit/sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;

  SignInCubit(this._signInUseCase) : super(const SignInState());

  void signIn(String email, String password) async {
    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null, fieldErrors: {}));
    
    final result = await _signInUseCase(email: email, password: password);
    
    result.fold(
      (failure) => emit(state.copyWith(status: SignInStatus.error, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: SignInStatus.success, user: user)),
    );
  }

  void validateFields(Map<String, String?> fieldErrors) {
    if (fieldErrors.values.any((error) => error != null)) {
      emit(state.copyWith(status: SignInStatus.error, fieldErrors: fieldErrors, errorMessage: null));
    } else {
      emit(state.copyWith(status: SignInStatus.initial, fieldErrors: {}));
    }
  }

  void resetError() {
    if (state.status == SignInStatus.error) {
      emit(state.copyWith(status: SignInStatus.initial, errorMessage: null));
    }
  }
}

