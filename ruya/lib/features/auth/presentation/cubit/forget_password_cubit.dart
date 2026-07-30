import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordState());

  void requestOtp(String email) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading, errorMessage: null, email: email));
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Accept any email for mock purposes
    emit(state.copyWith(status: ForgetPasswordStatus.success));
  }

  void verifyOtp(String otp) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading, errorMessage: null));
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (otp == '1234') {
      emit(state.copyWith(status: ForgetPasswordStatus.success, otp: otp));
    } else {
      emit(state.copyWith(status: ForgetPasswordStatus.error, errorMessage: 'Invalid OTP code. Try 1234.'));
    }
  }

  void resetPassword(String newPassword, String confirmPassword) async {
    emit(state.copyWith(status: ForgetPasswordStatus.loading, errorMessage: null));
    
    if (newPassword != confirmPassword) {
      emit(state.copyWith(status: ForgetPasswordStatus.error, errorMessage: 'Passwords do not match.'));
      return;
    }
    
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: ForgetPasswordStatus.success));
  }

  void resetError() {
    if (state.status == ForgetPasswordStatus.error) {
      emit(state.copyWith(status: ForgetPasswordStatus.initial, errorMessage: null));
    }
  }
}
