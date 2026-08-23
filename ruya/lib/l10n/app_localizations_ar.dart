// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTagline => 'التراث المصري · بإرشاد الذكاء الاصطناعي';

  @override
  String get appName => 'رؤيا';

  @override
  String get appSubtitle => 'دع الماضي ينبض بالحياة';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'أحمد حسن';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'ahmed@example.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHintMin => '8 أحرف على الأقل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get signingIn => 'جارٍ تسجيل الدخول...';

  @override
  String get creatingAccount => 'جارٍ إنشاء حسابك...';

  @override
  String get loadingJourney => 'جارٍ تحميل رحلتك المصرية...';

  @override
  String get settingUpProfile => 'جارٍ إعداد ملفك الشخصي...';

  @override
  String welcomeBack(String name) {
    return 'أهلاً بعودتك، $name!';
  }

  @override
  String get signInSuccessSubtitle =>
      'تم تسجيل الدخول بنجاح. جارٍ نقلك إلى صفحة الاستكشاف...';

  @override
  String get accountCreatedTitle => 'تم إنشاء الحساب بنجاح!';

  @override
  String get accountCreatedSubtitle =>
      'مرحبًا بك في رؤيا. جارٍ إعادة توجيهك الآن...';

  @override
  String get incorrectCredentialsTitle =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get incorrectCredentialsSubtitle =>
      'يرجى التحقق من بياناتك والمحاولة مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get fixErrorsBanner => 'يرجى تصحيح الأخطاء أدناه للمتابعة.';

  @override
  String get fullNameRequiredError => 'الاسم الكامل مطلوب';

  @override
  String get invalidEmailError => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get passwordMinError => 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get forgetPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgetPasswordSubtitle =>
      'أدخل عنوان البريد الإلكتروني المرتبط بحسابك';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get recoverPasswordBtn => 'استعادة كلمة المرور';

  @override
  String get getYourCodeTitle => 'احصل على الرمز الخاص بك';

  @override
  String get getYourCodeSubtitle =>
      'يرجى إدخال الرمز المكون من ٦ أرقام المرسل إلى بريدك الإلكتروني';

  @override
  String get resendCodeText => 'إذا لم تتلق الرمز! ';

  @override
  String get resendCodeLink => 'إعادة الإرسال';

  @override
  String get verifyAndProceedBtn => 'تحقق ومتابعة';

  @override
  String get enterNewPasswordTitle => 'أدخل كلمة المرور الجديدة';

  @override
  String get enterNewPasswordSubtitle =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور المستخدمة سابقاً';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get continueBtn => 'استمرار';

  @override
  String get back => 'رجوع';

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get preferredLanguageLabel => 'اللغة المفضلة';

  @override
  String get knowledgeLevelLabel => 'مستوى المعرفة';

  @override
  String get knowledgeLevelBeginner => 'مبتدئ';

  @override
  String get knowledgeLevelIntermediate => 'متوسط';

  @override
  String get knowledgeLevelAdvanced => 'متقدم';

  @override
  String resendCooldown(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get loggedOut => 'تم تسجيل الخروج بنجاح.';

  @override
  String get tabDiscover => 'اكتشف';

  @override
  String get tabChat => 'دردشة';

  @override
  String get tabMemories => 'ذكريات';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get searchHint => 'ابحث عن المعالم، المناطق، أو القصص...';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get editDisplayName => 'تعديل الاسم';

  @override
  String get updateEmail => 'تحديث البريد الإلكتروني';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get secureLogOut => 'تسجيل خروج آمن';

  @override
  String get appPreferences => 'تفضيلات التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get gpsNarration => 'السرد عبر نظام تحديد المواقع';

  @override
  String get autoNarrateNearSites => 'سرد تلقائي عند الاقتراب من المواقع';

  @override
  String get en => 'EN';

  @override
  String get ar => 'AR';

  @override
  String get hours => 'ساعات العمل';

  @override
  String get adult => 'بالغ';

  @override
  String get location => 'الموقع';

  @override
  String get viewMap => 'عرض الخريطة';

  @override
  String get crowds => 'الازدحام';

  @override
  String get low => 'منخفض';

  @override
  String get ruyaSuggests => 'رؤيا تقترح';

  @override
  String get ruyaSuggestsDescription =>
      'لديك ساعتان فراغ. هل تريد إضافة وادي الملوك القريب إلى مسار رحلتك؟';

  @override
  String get addToItinerary => '+ أضف إلى مسار الرحلة';

  @override
  String get bookEntryTicket => 'حجز تذكرة الدخول';

  @override
  String get reserveEntry => 'حجز الدخول';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get avail => 'متاح';

  @override
  String get filling => 'يمتلئ';

  @override
  String get sold => 'مباع';

  @override
  String get student => 'طالب';

  @override
  String get foreigner => 'أجنبي';

  @override
  String get local => 'محلي';

  @override
  String get total => 'المجموع';

  @override
  String get tickets => 'تذاكر';

  @override
  String get confirmProcessTicket => 'تأكيد وإصدار التذكرة';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز!';

  @override
  String get bookingConfirmedSubtitle =>
      'تم تأمين تذاكرك. يرجى إبراز رمز الاستجابة السريعة عند بوابة الدخول.';

  @override
  String get scanAtGate => 'امسح عند البوابة';

  @override
  String get refNum => 'رقم المرجع';

  @override
  String get site => 'الموقع';

  @override
  String get date => 'التاريخ';

  @override
  String get timeSlot => 'فترة الدخول';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get chatHistory => 'سجل الدردشة';

  @override
  String get recentConversations => 'المحادثات الأخيرة';

  @override
  String get startNewConversation => 'بدء محادثة جديدة';

  @override
  String get deleteChatConfirmTitle => 'حذف الدردشة';

  @override
  String get deleteChatConfirmBody => 'هل أنت متأكد أنك تريد حذف هذه المحادثة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get activeKarnakMode => 'نشط - وضع الكرنك';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get numberOfTickets => 'عدد التذاكر';

  @override
  String get selectVisitDateHint => 'اختر تاريخ الزيارة للمتابعة';

  @override
  String get saveAsPdf => 'حفظ كملف PDF';

  @override
  String get saveAsImage => 'حفظ كصورة';

  @override
  String get ticketSaved => 'تم حفظ التذكرة بنجاح.';

  @override
  String get ticketSaveFailed => 'تعذر حفظ التذكرة. يرجى المحاولة مرة أخرى.';

  @override
  String get backToDiscover => 'العودة إلى الاستكشاف';

  @override
  String get listening => 'جارٍ الاستماع...';

  @override
  String get releaseToSend => 'اترك للإرسال';

  @override
  String get recording => 'جارٍ التسجيل...';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get attachImage => 'إرفاق صورة';

  @override
  String get removeImage => 'إزالة الصورة';

  @override
  String get micPermissionRequired => 'مطلوب إذن الميكروفون والتعرف على الصوت';

  @override
  String get micPermissionRationale =>
      'تحتاج رؤيا إلى إذن استخدام الميكروفون والتعرف على الصوت لتتمكن من التحدث إلى المرشد الذكي. يرجى تفعيلها من إعدادات التطبيق.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get speechNotAvailable => 'التعرف على الصوت غير متوفر على هذا الجهاز.';

  @override
  String get imageTooLarge => 'حجم الصورة كبير جدًا (الحد الأقصى ١٠ ميغابايت).';

  @override
  String get imageDefaultQuestion => 'ماذا يمكنك أن تخبرني عن هذا؟';

  @override
  String get visionBadge => 'رؤية بالذكاء الاصطناعي';

  @override
  String get replayAudio => 'استمع';

  @override
  String get noMessagesYet => 'اسأل رؤيا أي شيء عن التاريخ المصري...';

  @override
  String get noConversations => 'لا توجد محادثات حتى الآن';

  @override
  String get errorLoadingConversations => 'فشل تحميل سجل المحادثات.';

  @override
  String get errorLoadingMessages => 'فشل تحميل الرسائل.';

  @override
  String get failedToSendMessage => 'فشل إرسال الرسالة.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get viewArtifact => 'عرض المعلم';

  @override
  String get memoryVault => 'خزينة الذكريات';

  @override
  String get yourJourneyArchive => 'أرشيف رحلاتك';

  @override
  String tripsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رحلة',
      many: '$count رحلة',
      few: '$count رحلات',
      two: 'رحلتان',
      one: 'رحلة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get routeTimeline => 'الجدول الزمني للرحلة';

  @override
  String get shareJourney => 'مشاركة الرحلة';

  @override
  String get downloadPdf => 'تحميل PDF';

  @override
  String get addNewMoment => 'إضافة لحظة جديدة';

  @override
  String get createMomentTitle => 'إنشاء ألبوم ذكريات';

  @override
  String get momentTitleLabel => 'عنوان الرحلة / الألبوم';

  @override
  String get momentTitleHint => 'مثال: الأقصر ووادي الملوك';

  @override
  String get tripDateLabel => 'شهر وسنة البدء';

  @override
  String get tripDateHint => 'مثال: يناير ٢٠٢٦';

  @override
  String get coverPhotoLabel => 'صورة الغلاف';

  @override
  String get tapToSelectCover => 'انقر لاختيار صورة الغلاف';

  @override
  String get photosSectionTitle => 'صور الرحلة';

  @override
  String get addPhotosButton => 'إضافة صور';

  @override
  String get createMomentBtn => 'إنشاء الألبوم';

  @override
  String get momentCreatedSuccess => 'تم إنشاء ألبوم الذكريات بنجاح!';

  @override
  String get titleRequiredError => 'العنوان مطلوب';

  @override
  String get dateRequiredError => 'شهر وسنة البدء مطلوبة';

  @override
  String get coverRequiredError => 'يرجى اختيار صورة الغلاف';

  @override
  String get noPhotosAddedYet => 'لم تتم إضافة أي صور بعد';

  @override
  String get scanTitle => 'جارٍ المسح';

  @override
  String get scanCapturePrompt => 'وجّه الكاميرا نحو المعالم أو الآثار القديمة';

  @override
  String get postCaptureTitle => 'تم التقاط الصورة';

  @override
  String get postCaptureSubtitle => 'ماذا تود أن تفعل بهذه الصورة؟';

  @override
  String get addToChatOption => 'اسأل الذكاء الاصطناعي في الدردشة';

  @override
  String get addToChatOptionDesc =>
      'ابدأ محادثة ذكية لتحليل الصورة واكتشاف معلومات تاريخية';

  @override
  String get addToMemoriesOption => 'إضافة إلى الذكريات';

  @override
  String get addToMemoriesOptionDesc =>
      'احفظ هذه الصورة في ألبوم ذكريات حالي أو جديد';

  @override
  String get selectAlbum => 'اختر الألبوم';

  @override
  String get selectAlbumToAddTo =>
      'اختر الألبوم الذي تريد إضافة هذه الصورة إليه:';

  @override
  String get confirmAddToAlbumTitle => 'إضافة الصورة إلى الألبوم؟';

  @override
  String confirmAddToAlbumBody(String albumTitle) {
    return 'هل أنت متأكد أنك تريد إضافة هذه الصورة إلى \"$albumTitle\"؟';
  }

  @override
  String get photoAddedSuccess => 'تمت إضافة الصورة إلى الألبوم بنجاح!';

  @override
  String get createNewAlbum => 'إنشاء ألبوم جديد';

  @override
  String get confirm => 'تأكيد';

  @override
  String get pdfSavedSuccess => 'تم تجهيز مستند PDF بنجاح!';

  @override
  String get deletePhotoConfirmTitle => 'حذف الصورة؟';

  @override
  String get deletePhotoConfirmBody =>
      'هل أنت متأكد أنك تريد حذف هذه الصورة من الألبوم؟';

  @override
  String get photoDeletedSuccess => 'تمت إزالة الصورة من الألبوم بنجاح!';

  @override
  String get editMomentTitle => 'تعديل ألبوم الذكريات';

  @override
  String get editMomentBtn => 'حفظ التغييرات';

  @override
  String get momentUpdatedSuccess => 'تم تحديث ألبوم الذكريات بنجاح!';

  @override
  String get confirmEditAlbumTitle => 'حفظ تغييرات الألبوم؟';

  @override
  String get confirmEditAlbumBody =>
      'هل أنت متأكد أنك تريد حفظ التغييرات على هذا الألبوم؟';

  @override
  String get editAlbumTooltip => 'تعديل الألبوم';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get setReminder => 'تعيين تذكير';

  @override
  String get remindMeOnVisitDay => 'تذكيري في يوم الزيارة';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get reminderScheduled => 'تمت جدولة التذكير بنجاح!';

  @override
  String get reminderCancelled => 'تم إلغاء التذكير';

  @override
  String get pickAFutureTime => 'يرجى تحديد وقت قادم للتذكير.';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get noBookingsYet => 'لا توجد حجوزات حتى الآن';

  @override
  String get cancelBookingConfirmTitle => 'إلغاء الحجز؟';

  @override
  String cancelBookingConfirmBody(String siteName) {
    return 'هل أنت متأكد من رغبتك في إلغاء حجز $siteName؟';
  }

  @override
  String get bookingCancelled => 'تم إلغاء الحجز بنجاح';

  @override
  String get bookingReminderNotifTitle => 'تذكير بزيارتك القادمة 🏛️';

  @override
  String bookingReminderNotifBody(String siteName, String referenceNumber) {
    return 'زيارتك إلى $siteName اليوم! رقم الحجز: $referenceNumber';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get filterGiza => 'الجيزة';

  @override
  String get filterLuxor => 'الأقصر';

  @override
  String get filterAswan => 'أسوان';

  @override
  String get filterCairo => 'القاهرة';

  @override
  String get crowdLow => 'ازدحام قليل';

  @override
  String get crowdModerate => 'ازدحام متوسط';

  @override
  String get crowdHigh => 'ازدحام شديد';

  @override
  String get noMonumentsFound => 'لم يتم العثور على معالم.';
}
