// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'EGYPTIAN HERITAGE · AI GUIDED';

  @override
  String get appName => 'Ruya';

  @override
  String get appSubtitle => 'See the past come alive';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Ahmed Hassan';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'ahmed@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHintMin => 'Min. 8 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get creatingAccount => 'Creating your account...';

  @override
  String get loadingJourney => 'Loading your Egyptian journey...';

  @override
  String get settingUpProfile => 'Setting up your profile...';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get signInSuccessSubtitle =>
      'Sign in successful. Taking you to Explore...';

  @override
  String get accountCreatedTitle => 'Account created successfully!';

  @override
  String get accountCreatedSubtitle =>
      'Welcome to Ruya. Redirecting you now...';

  @override
  String get incorrectCredentialsTitle => 'Incorrect email or password';

  @override
  String get incorrectCredentialsSubtitle =>
      'Please check your credentials and try again.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get fixErrorsBanner => 'Please fix the errors below to continue.';

  @override
  String get fullNameRequiredError => 'Full name is required';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get passwordMinError => 'Password must be at least 8 characters';
}
