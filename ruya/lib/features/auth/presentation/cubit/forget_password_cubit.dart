import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruya/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ruya/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_state.dart';

/// Cubit for the 3-step forgot-password flow:
///   1. [requestOtp]  → POST /api/Auth/forgot-password
///   2. [verifyOtp]   → POST /api/Auth/verify-otp   (returns resetToken)
///   3. [resetPassword] → POST /api/Auth/reset-password
///
/// Resend is handled by [resendOtp] which re-calls the same forgot-password
/// endpoint (no separate /resend-otp endpoint exists on the backend).
/// A 30-second client-side cooldown prevents the user from hammering the
/// endpoint before the backend's own 429 rate-limit kicks in.
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  Timer? _cooldownTimer;

  ForgetPasswordCubit({
    required this.forgotPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.resendOtpUseCase,
  }) : super(const ForgetPasswordState());


  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }

  // ---------------------------------------------------------------------------
  // Step 1 — Request OTP
  // ---------------------------------------------------------------------------

  Future<void> requestOtp(String email) async {
    emit(state.copyWith(
      status: ForgetPasswordStatus.loading,
      errorMessage: null,
      email: email,
    ));

    final result = await forgotPasswordUseCase(email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ForgetPasswordStatus.success)),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 2 — Verify OTP
  // ---------------------------------------------------------------------------

  Future<void> verifyOtp(String code) async {
    emit(state.copyWith(
      status: ForgetPasswordStatus.loading,
      errorMessage: null,
    ));

    final result = await verifyOtpUseCase(email: state.email, code: code);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (otpResult) => emit(state.copyWith(
        status: ForgetPasswordStatus.success,
        resetToken: otpResult.resetToken,
      )),
    );
  }

  // ---------------------------------------------------------------------------
  // Step 3 — Reset password
  // ---------------------------------------------------------------------------

  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: 'Passwords do not match.',
      ));
      return;
    }

    emit(state.copyWith(
      status: ForgetPasswordStatus.loading,
      errorMessage: null,
    ));

    final result = await resetPasswordUseCase(
      email: state.email,
      resetToken: state.resetToken ?? '',
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: ForgetPasswordStatus.success)),
    );
  }

  // ---------------------------------------------------------------------------
  // Resend OTP (with 30s cooldown)
  // ---------------------------------------------------------------------------

  Future<void> resendOtp() async {
    if (state.resendCooldownSeconds > 0) return; // already in cooldown

    emit(state.copyWith(
      status: ForgetPasswordStatus.loading,
      errorMessage: null,
    ));

    final result = await resendOtpUseCase(state.email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ForgetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        // Start 30-second cooldown.
        emit(state.copyWith(
          status: ForgetPasswordStatus.success,
          resendCooldownSeconds: 30,
        ));
        _startCooldownTimer();
      },
    );
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendCooldownSeconds - 1;
      if (remaining <= 0) {
        timer.cancel();
        emit(state.copyWith(resendCooldownSeconds: 0));
      } else {
        emit(state.copyWith(resendCooldownSeconds: remaining));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Misc
  // ---------------------------------------------------------------------------

  void resetError() {
    if (state.status == ForgetPasswordStatus.error) {
      emit(state.copyWith(
        status: ForgetPasswordStatus.initial,
        errorMessage: null,
      ));
    }
  }
}
