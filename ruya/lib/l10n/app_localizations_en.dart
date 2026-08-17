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

  @override
  String get forgetPasswordTitle => 'Forget Password';

  @override
  String get forgetPasswordSubtitle =>
      'Enter the email address associated with your account';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get recoverPasswordBtn => 'Recover Password';

  @override
  String get getYourCodeTitle => 'Get Your Code';

  @override
  String get getYourCodeSubtitle =>
      'Please enter the 6-digit code sent to your email';

  @override
  String get resendCodeText => 'if you don\'t receive code! ';

  @override
  String get resendCodeLink => 'Resend';

  @override
  String get verifyAndProceedBtn => 'verify and Proceed';

  @override
  String get enterNewPasswordTitle => 'Enter New Password';

  @override
  String get enterNewPasswordSubtitle =>
      'Your new password must be different from last used password';

  @override
  String get confirmPasswordLabel => 'confirm Password';

  @override
  String get continueBtn => 'continue';

  @override
  String get back => 'Back';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get passwordResetSuccess => 'Password Reset Successfully!';

  @override
  String get preferredLanguageLabel => 'Preferred Language';

  @override
  String get knowledgeLevelLabel => 'Knowledge Level';

  @override
  String get knowledgeLevelBeginner => 'Beginner';

  @override
  String get knowledgeLevelIntermediate => 'Intermediate';

  @override
  String get knowledgeLevelAdvanced => 'Advanced';

  @override
  String resendCooldown(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get loggedOut => 'Logged out successfully.';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabChat => 'Chat';

  @override
  String get tabMemories => 'Memories';

  @override
  String get tabProfile => 'Profile';

  @override
  String get searchHint => 'Search monuments, regions, or stories...';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get editDisplayName => 'Edit Display Name';

  @override
  String get updateEmail => 'Update Email';

  @override
  String get changePassword => 'Change Password';

  @override
  String get secureLogOut => 'Secure Log Out';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get language => 'Language';

  @override
  String get gpsNarration => 'GPS Narration';

  @override
  String get autoNarrateNearSites => 'Auto-narrate when near sites';

  @override
  String get en => 'EN';

  @override
  String get ar => 'AR';

  @override
  String get hours => 'Hours';

  @override
  String get adult => 'Adult';

  @override
  String get location => 'Location';

  @override
  String get viewMap => 'View Map';

  @override
  String get crowds => 'Crowds';

  @override
  String get low => 'Low';

  @override
  String get ruyaSuggests => 'Ruya Suggests';

  @override
  String get ruyaSuggestsDescription =>
      'You have 2 hours free. Add the nearby Valley of the Kings to your itinerary?';

  @override
  String get addToItinerary => '+ Add to Itinerary';

  @override
  String get bookEntryTicket => 'Book Entry Ticket';

  @override
  String get reserveEntry => 'Reserve Entry';

  @override
  String get selectDate => 'Select Date';

  @override
  String get avail => 'Avail';

  @override
  String get filling => 'Filling';

  @override
  String get sold => 'Sold';

  @override
  String get student => 'Student';

  @override
  String get foreigner => 'Foreigner';

  @override
  String get local => 'Local';

  @override
  String get total => 'Total';

  @override
  String get tickets => 'tickets';

  @override
  String get confirmProcessTicket => 'Confirm & Process Ticket';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get bookingConfirmedSubtitle =>
      'Your tickets have been secured. Present the QR code at the entrance gate.';

  @override
  String get scanAtGate => 'Scan at gate';

  @override
  String get refNum => 'Ref #';

  @override
  String get site => 'Site';

  @override
  String get date => 'Date';

  @override
  String get timeSlot => 'Time Slot';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get recentConversations => 'RECENT CONVERSATIONS';

  @override
  String get startNewConversation => 'Start New Conversation';

  @override
  String get deleteChatConfirmTitle => 'Delete Chat';

  @override
  String get deleteChatConfirmBody =>
      'Are you sure you want to delete this conversation?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get activeKarnakMode => 'ACTIVE - KARNAK MODE';

  @override
  String get typeMessage => 'Type a message...';
}
