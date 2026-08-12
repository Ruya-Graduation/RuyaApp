import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/core/error/failure.dart';
import 'package:ruya/features/auth/domain/usecases/register_usecase.dart';
import 'package:ruya/features/auth/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(const RegisterState());

  void register({
    required String name,
    required String email,
    required String password,
    required String preferredLanguage,
    required String knowledgeLevel,
  }) async {
    emit(state.copyWith(
      status: RegisterStatus.loading,
      errorMessage: null,
      fieldErrors: {},
    ));

    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
      preferredLanguage: preferredLanguage,
      knowledgeLevel: knowledgeLevel,
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          // Map server field names (e.g. "Password") to the cubit's field keys.
          // The server uses PascalCase; we store lowercase keys.
          final mapped = <String, String?>{};
          failure.fieldErrors.forEach((field, messages) {
            mapped[field.toLowerCase()] = messages.isNotEmpty ? messages.first : null;
          });
          emit(state.copyWith(
            status: RegisterStatus.error,
            fieldErrors: mapped,
            errorMessage: null,
          ));
        } else {
          emit(state.copyWith(
            status: RegisterStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
      (user) => emit(state.copyWith(status: RegisterStatus.success, user: user)),
    );
  }

  void validateFields(Map<String, String?> fieldErrors) {
    if (fieldErrors.values.any((error) => error != null)) {
      emit(state.copyWith(
        status: RegisterStatus.error,
        fieldErrors: fieldErrors,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(status: RegisterStatus.initial, fieldErrors: {}));
    }
  }

  void resetError() {
    if (state.status == RegisterStatus.error) {
      emit(state.copyWith(status: RegisterStatus.initial, errorMessage: null));
    }
  }
}
