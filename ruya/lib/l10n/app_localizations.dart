import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'EGYPTIAN HERITAGE · AI GUIDED'**
  String get appTagline;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ruya'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See the past come alive'**
  String get appSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Hassan'**
  String get fullNameHint;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'ahmed@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHintMin.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get passwordHintMin;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account...'**
  String get creatingAccount;

  /// No description provided for @loadingJourney.
  ///
  /// In en, this message translates to:
  /// **'Loading your Egyptian journey...'**
  String get loadingJourney;

  /// No description provided for @settingUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Setting up your profile...'**
  String get settingUpProfile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// No description provided for @signInSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in successful. Taking you to Explore...'**
  String get signInSuccessSubtitle;

  /// No description provided for @accountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedTitle;

  /// No description provided for @accountCreatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ruya. Redirecting you now...'**
  String get accountCreatedSubtitle;

  /// No description provided for @incorrectCredentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get incorrectCredentialsTitle;

  /// No description provided for @incorrectCredentialsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your credentials and try again.'**
  String get incorrectCredentialsSubtitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @fixErrorsBanner.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors below to continue.'**
  String get fixErrorsBanner;

  /// No description provided for @fullNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequiredError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @passwordMinError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinError;

  /// No description provided for @forgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPasswordTitle;

  /// No description provided for @forgetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account'**
  String get forgetPasswordSubtitle;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @recoverPasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPasswordBtn;

  /// No description provided for @getYourCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Your Code'**
  String get getYourCodeTitle;

  /// No description provided for @getYourCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit code sent to your email'**
  String get getYourCodeSubtitle;

  /// No description provided for @resendCodeText.
  ///
  /// In en, this message translates to:
  /// **'if you don\'t receive code! '**
  String get resendCodeText;

  /// No description provided for @resendCodeLink.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendCodeLink;

  /// No description provided for @verifyAndProceedBtn.
  ///
  /// In en, this message translates to:
  /// **'verify and Proceed'**
  String get verifyAndProceedBtn;

  /// No description provided for @enterNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get enterNewPasswordTitle;

  /// No description provided for @enterNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from last used password'**
  String get enterNewPasswordSubtitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'continue'**
  String get continueBtn;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @preferredLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguageLabel;

  /// No description provided for @knowledgeLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Level'**
  String get knowledgeLevelLabel;

  /// No description provided for @knowledgeLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get knowledgeLevelBeginner;

  /// No description provided for @knowledgeLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get knowledgeLevelIntermediate;

  /// No description provided for @knowledgeLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get knowledgeLevelAdvanced;

  /// No description provided for @resendCooldown.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendCooldown(int seconds);

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully.'**
  String get loggedOut;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tabChat;

  /// No description provided for @tabMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get tabMemories;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search monuments, regions, or stories...'**
  String get searchHint;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @editDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Edit Display Name'**
  String get editDisplayName;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @secureLogOut.
  ///
  /// In en, this message translates to:
  /// **'Secure Log Out'**
  String get secureLogOut;

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @gpsNarration.
  ///
  /// In en, this message translates to:
  /// **'GPS Narration'**
  String get gpsNarration;

  /// No description provided for @autoNarrateNearSites.
  ///
  /// In en, this message translates to:
  /// **'Auto-narrate when near sites'**
  String get autoNarrateNearSites;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get en;

  /// No description provided for @ar.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get ar;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @adult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adult;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @viewMap.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get viewMap;

  /// No description provided for @crowds.
  ///
  /// In en, this message translates to:
  /// **'Crowds'**
  String get crowds;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @ruyaSuggests.
  ///
  /// In en, this message translates to:
  /// **'Ruya Suggests'**
  String get ruyaSuggests;

  /// No description provided for @ruyaSuggestsDescription.
  ///
  /// In en, this message translates to:
  /// **'You have 2 hours free. Add the nearby Valley of the Kings to your itinerary?'**
  String get ruyaSuggestsDescription;

  /// No description provided for @addToItinerary.
  ///
  /// In en, this message translates to:
  /// **'+ Add to Itinerary'**
  String get addToItinerary;

  /// No description provided for @bookEntryTicket.
  ///
  /// In en, this message translates to:
  /// **'Book Entry Ticket'**
  String get bookEntryTicket;

  /// No description provided for @reserveEntry.
  ///
  /// In en, this message translates to:
  /// **'Reserve Entry'**
  String get reserveEntry;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @avail.
  ///
  /// In en, this message translates to:
  /// **'Avail'**
  String get avail;

  /// No description provided for @filling.
  ///
  /// In en, this message translates to:
  /// **'Filling'**
  String get filling;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @foreigner.
  ///
  /// In en, this message translates to:
  /// **'Foreigner'**
  String get foreigner;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'tickets'**
  String get tickets;

  /// No description provided for @confirmProcessTicket.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Process Ticket'**
  String get confirmProcessTicket;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @bookingConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your tickets have been secured. Present the QR code at the entrance gate.'**
  String get bookingConfirmedSubtitle;

  /// No description provided for @scanAtGate.
  ///
  /// In en, this message translates to:
  /// **'Scan at gate'**
  String get scanAtGate;

  /// No description provided for @refNum.
  ///
  /// In en, this message translates to:
  /// **'Ref #'**
  String get refNum;

  /// No description provided for @site.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get site;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @timeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time Slot'**
  String get timeSlot;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// No description provided for @recentConversations.
  ///
  /// In en, this message translates to:
  /// **'RECENT CONVERSATIONS'**
  String get recentConversations;

  /// No description provided for @startNewConversation.
  ///
  /// In en, this message translates to:
  /// **'Start New Conversation'**
  String get startNewConversation;

  /// No description provided for @deleteChatConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChatConfirmTitle;

  /// No description provided for @deleteChatConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation?'**
  String get deleteChatConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @activeKarnakMode.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE - KARNAK MODE'**
  String get activeKarnakMode;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @numberOfTickets.
  ///
  /// In en, this message translates to:
  /// **'Number of Tickets'**
  String get numberOfTickets;

  /// No description provided for @selectVisitDateHint.
  ///
  /// In en, this message translates to:
  /// **'Select a visit date to continue'**
  String get selectVisitDateHint;

  /// No description provided for @saveAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get saveAsPdf;

  /// No description provided for @saveAsImage.
  ///
  /// In en, this message translates to:
  /// **'Save as Image'**
  String get saveAsImage;

  /// No description provided for @ticketSaved.
  ///
  /// In en, this message translates to:
  /// **'Ticket saved successfully.'**
  String get ticketSaved;

  /// No description provided for @ticketSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the ticket. Please try again.'**
  String get ticketSaveFailed;

  /// No description provided for @backToDiscover.
  ///
  /// In en, this message translates to:
  /// **'Back to Discover'**
  String get backToDiscover;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @releaseToSend.
  ///
  /// In en, this message translates to:
  /// **'Release to send'**
  String get releaseToSend;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attachImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @micPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone & Speech Permission Required'**
  String get micPermissionRequired;

  /// No description provided for @micPermissionRationale.
  ///
  /// In en, this message translates to:
  /// **'Ruya needs microphone and speech recognition permissions to let you talk to the AI guide. Please enable them in app settings.'**
  String get micPermissionRationale;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @speechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get speechNotAvailable;

  /// No description provided for @imageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image file is too large (maximum size is 10MB).'**
  String get imageTooLarge;

  /// No description provided for @imageDefaultQuestion.
  ///
  /// In en, this message translates to:
  /// **'What can you tell me about this?'**
  String get imageDefaultQuestion;

  /// No description provided for @visionBadge.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get visionBadge;

  /// No description provided for @replayAudio.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get replayAudio;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'Ask Ruya anything about Egyptian history...'**
  String get noMessagesYet;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversations;

  /// No description provided for @errorLoadingConversations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load chat history.'**
  String get errorLoadingConversations;

  /// No description provided for @errorLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages.'**
  String get errorLoadingMessages;

  /// No description provided for @failedToSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message.'**
  String get failedToSendMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @viewArtifact.
  ///
  /// In en, this message translates to:
  /// **'View Artifact'**
  String get viewArtifact;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
