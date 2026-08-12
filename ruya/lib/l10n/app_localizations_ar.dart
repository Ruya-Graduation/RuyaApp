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
      'يرجى إدخال الرمز المكون من ٤ أرقام المرسل إلى بريدك الإلكتروني';

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
}
