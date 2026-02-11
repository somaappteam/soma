// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'تعلّم. نافس. أتقن.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get skipForNow => 'تخطي الآن';

  @override
  String get authFillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authForgotPasswordTitle => 'Reset password';

  @override
  String get authForgotPasswordBody =>
      'Enter the email linked to your account. We\'ll send a secure reset link.';

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String get authResetSentTitle => 'Check your email';

  @override
  String get authResetSentBody =>
      'We sent a password reset link. Follow the instructions to set a new password.';

  @override
  String get authResetFailedTitle => 'Reset failed';

  @override
  String authError(Object error) {
    return 'خطأ: $error';
  }

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authUsername => 'اسم المستخدم';

  @override
  String get authContinue => 'متابعة';

  @override
  String get authSigningIn => 'جارٍ تسجيل الدخول...';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authCreating => 'جارٍ الإنشاء...';

  @override
  String get authNeedAccount => 'ليس لديك حساب؟ ';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get dialogAuthRequiredTitle => 'سجّل الدخول للوصول إلى Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles هي غرف متعددة اللاعبين. أنشئ حسابًا للانضمام إلى المباريات المباشرة ودعوة الأصدقاء وحفظ التقدم.';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get removeCourseTitle => 'إزالة الدورة؟';

  @override
  String removeCourseBody(Object course) {
    return 'سيتم إزالة $course من قائمة الرئيسية.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get remove => 'إزالة';

  @override
  String welcomeBack(Object name) {
    return 'مرحبًا بعودتك، $name!';
  }

  @override
  String get editCourses => 'تعديل الدورات';

  @override
  String get done => 'تم';

  @override
  String get noCoursesToEdit => 'لا توجد دورات للتعديل.';

  @override
  String get addCourse => 'إضافة دورة';

  @override
  String get unknown => 'غير معروف';

  @override
  String get iSpeak => 'أتحدث';

  @override
  String get iWantToLearn => 'أريد تعلم';

  @override
  String get chooseYourLanguage => 'اختر لغتك';

  @override
  String get chooseLearningLanguage => 'اختر اللغة التي تريد تعلمها';

  @override
  String get chooseTwoDifferentLanguages => 'اختر لغتين مختلفتين.';

  @override
  String get createCourse => 'إنشاء دورة';

  @override
  String get soloCourseTitle => 'دورة فردية';

  @override
  String get searchLanguage => 'بحث عن لغة';

  @override
  String get noMatches => 'لا توجد نتائج';

  @override
  String get chooseCourseType => 'اختر نوع الدورة';

  @override
  String get soloStudyDescription =>
      'ادرس بمفردك بنفس أسلوب اختبار Circles - لكن بدون غرف أو محادثة أو متفرجين أو خيارات المضيف.';

  @override
  String get soloModeVocabulary => 'المفردات';

  @override
  String get soloModeSentences => 'الجمل';

  @override
  String get soloModeReview => 'المراجعة';

  @override
  String get soloModeVocabularySubtitle =>
      'اختيار متعدد للمعاني والمرادفات والاستخدام';

  @override
  String get soloModeSentencesSubtitle => 'ملء الفراغات + الترجمة + القراءة';

  @override
  String get soloModeReviewDescription =>
      'تدرّب على ما تعلمته: الكلمات الضعيفة والأخطاء الأخيرة والتكرار المتباعد.';

  @override
  String get startReview => 'بدء المراجعة';

  @override
  String get soloReviewModeTitle => 'Review mode';

  @override
  String get soloReviewOptionsTitle => 'Review options';

  @override
  String get soloReviewScopeAllLearned => 'All learned';

  @override
  String get soloReviewScopeStruggling => 'Struggling items';

  @override
  String get soloReviewScopeStrugglingDescription =>
      'Prioritize items you recently got wrong.';

  @override
  String get soloReviewScopeAllLearnedDescription =>
      'Review all learned content for this course.';

  @override
  String soloSetupTitle(Object mode) {
    return 'إعداد $mode';
  }

  @override
  String get difficulty => 'الصعوبة';

  @override
  String get numberOfQuestions => 'عدد الأسئلة';

  @override
  String get timerPerQuestion => 'المؤقت لكل سؤال';

  @override
  String get noTimer => 'بدون مؤقت';

  @override
  String get start => 'ابدأ';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileSignInToMessage => 'سجّل الدخول لإرسال رسالة';

  @override
  String get profileThatsYourProfile => 'هذا ملفك الشخصي';

  @override
  String get profileSignInToAddFriends => 'سجّل الدخول لإضافة أصدقاء';

  @override
  String get profileCantAddYourself => 'لا يمكنك إضافة نفسك';

  @override
  String profileRequestSent(Object username) {
    return 'تم إرسال الطلب إلى @$username';
  }

  @override
  String get profileRequestFailed => 'فشل إرسال الطلب';

  @override
  String get profileDefaultDisplayName => 'مستخدم جديد';

  @override
  String get profileDefaultBio => 'مستعد للتعلم!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'ضيف';

  @override
  String get guestUsername => 'ضيف';

  @override
  String get guestSessionLabel => 'جلسة ضيف';

  @override
  String get unlockFullProfile => 'افتح ملفك الشخصي الكامل';

  @override
  String get guestBenefitSync => 'زامن التقدم على جميع الأجهزة';

  @override
  String get guestBenefitCircles => 'انضم إلى Circles والعب مباشرة';

  @override
  String get guestBenefitNotifications => 'احصل على إشعارات وطلبات صداقة';

  @override
  String get progressStaysOnDevice =>
      'يبقى التقدم على هذا الجهاز حتى تسجل الدخول.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'الهدف: $minutesد';
  }

  @override
  String get profileXpProgress => 'تقدم XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'الانتصارات';

  @override
  String get profileStreak => 'السلسلة';

  @override
  String get profileFriendsTitle => 'أصدقائي';

  @override
  String get profileViewAll => 'عرض الكل';

  @override
  String get profileAchievementsTitle => 'الإنجازات';

  @override
  String get profileNoAchievements => 'لا توجد إنجازات بعد.';

  @override
  String get profileRequested => 'مطلوب';

  @override
  String get profileSending => 'جارٍ الإرسال...';

  @override
  String get profileAddFriend => 'إضافة صديق';

  @override
  String get profileConnectTitle => 'اتصل';

  @override
  String get profileMessage => 'رسالة';

  @override
  String get profileSnapshot => 'لقطة الملف الشخصي';

  @override
  String get profileLocationHidden => 'الموقع مخفي';

  @override
  String get profileBioHidden => 'السيرة الذاتية مخفية';

  @override
  String profileDailyGoal(Object minutes) {
    return 'الهدف اليومي $minutesد';
  }

  @override
  String get circleInviteTitle => 'دعوة Circle';

  @override
  String circleIdLabel(Object id) {
    return 'معرّف Circle: $id';
  }

  @override
  String get signInToJoin => 'سجّل الدخول للانضمام';

  @override
  String get joiningCircle => 'جارٍ الانضمام...';

  @override
  String get joinCircle => 'انضم إلى Circle';

  @override
  String get circleJoinedAsPlayer => 'انضممت كلاعب';

  @override
  String get circleJoinedAsSpectator => 'انضممت كمتفرج';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رفض';

  @override
  String get open => 'فتح';

  @override
  String get circleCountdownTitle => 'استعد';

  @override
  String get circleCountdownSubtitle => 'Circle يبدأ...';

  @override
  String get userFallbackName => 'مستخدم';

  @override
  String get micOff => 'الميكروفون متوقف';

  @override
  String get micOn => 'الميكروفون يعمل';

  @override
  String get roleHost => 'المضيف';

  @override
  String get roleSpectator => 'متفرج';

  @override
  String get tagHost => 'المضيف';

  @override
  String get tagYou => 'أنت';

  @override
  String get statusCorrect => 'صحيح';

  @override
  String get statusWrong => 'خطأ';

  @override
  String get statusWaiting => 'انتظار';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'نقاط';

  @override
  String get pointsLabel => 'النقاط';

  @override
  String get statCorrect => 'صحيح';

  @override
  String get statAnswers => 'الإجابات';

  @override
  String get statTotal => 'الإجمالي';

  @override
  String get statQuestions => 'الأسئلة';

  @override
  String get statAccuracy => 'الدقة';

  @override
  String get statRate => 'المعدل';

  @override
  String get statRank => 'الترتيب';

  @override
  String get statPosition => 'الموقع';

  @override
  String get statMode => 'الوضع';

  @override
  String get statType => 'النوع';

  @override
  String get next => 'التالي';

  @override
  String get submit => 'إرسال';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get save => 'حفظ';

  @override
  String get playAgain => 'العب مرة أخرى';

  @override
  String get backToCourse => 'العودة إلى الدورة';

  @override
  String get resultsTitle => 'النتائج';

  @override
  String get shareLater => 'مشاركة لاحقًا';

  @override
  String get delete => 'حذف';

  @override
  String get ok => 'حسنًا';

  @override
  String minutesShort(Object minutes) {
    return '$minutesد';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$countد';
  }

  @override
  String timeShortHours(Object count) {
    return '$countس';
  }

  @override
  String timeShortDays(Object count) {
    return '$countي';
  }

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutesAgo(Object count) {
    return 'منذ $countد';
  }

  @override
  String timeHoursAgo(Object count) {
    return 'منذ $countس';
  }

  @override
  String timeDaysAgo(Object count) {
    return 'منذ $countي';
  }

  @override
  String get liveQuizWaitingForHost => 'انتظار المضيف...';

  @override
  String get liveQuizJoinRequestSent => 'تم إرسال طلب الانضمام';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'فشل الطلب: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'عناصر تحكم المضيف';

  @override
  String get liveQuizSpectatorModeTitle => 'وضع المتفرج';

  @override
  String get liveQuizHostControlsSubtitle =>
      'تتقدم الجولات تلقائيًا عندما يجيب الجميع أو ينتهي الوقت.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'شاهد الأسئلة ولوحة المتصدرين مباشرة. لا يمكنك الإجابة.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'السؤال $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'تم إرسال الطلب';

  @override
  String get liveQuizRequestToJoin => 'طلب الانضمام';

  @override
  String get liveQuizSpectatorFooter =>
      'أنت تشاهد مباشرة. استمتع بالأسئلة ولوحة المتصدرين.';

  @override
  String get circleNotFound => 'لم يتم العثور على Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'فشل بدء المباراة الإعادية: $error';
  }

  @override
  String get resultsMatchTitle => 'نتائج المباراة';

  @override
  String resultsNiceWork(Object name) {
    return 'عمل رائع، $name';
  }

  @override
  String get resultsPlaceFirst => 'المركز الأول';

  @override
  String get resultsPlaceSecond => 'المركز الثاني';

  @override
  String get resultsPlaceThird => 'المركز الثالث';

  @override
  String resultsPlaceNth(Object rank) {
    return 'المركز $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'من $players لاعبين';
  }

  @override
  String get resultsHighlightChampion => 'بطل! لقد هيمنت على هذا Circle.';

  @override
  String get resultsHighlightGreatAccuracy => 'دقة رائعة. أنت قريب من القمة!';

  @override
  String get resultsHighlightKeepGoing => 'استمر - الاتساق يتفوق على السرعة.';

  @override
  String get resultsLeaderboardTitle => 'لوحة المتصدرين';

  @override
  String resultsPlayersCount(Object count) {
    return '$count لاعبين';
  }

  @override
  String get resultsBackToCircles => 'العودة إلى Circles';

  @override
  String get resultsRematch => 'إعادة المباراة';

  @override
  String get resultsPlayAgain => 'العب مرة أخرى';

  @override
  String get leaderboardGlobalTitle => 'لوحة المتصدرين العالمية';

  @override
  String get leaderboardEmpty => 'لا توجد لوحة متصدرين بعد.';

  @override
  String get aboutTitle => 'حول';

  @override
  String aboutVersion(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutDescription =>
      'SOMA هي منصة تعليم لغات قائمة على الألعاب تجعل إتقان اللغات الجديدة ممتعًا واجتماعيًا. انضم إلى Circles، تدرّب بمفردك، وتابع تقدمك.';

  @override
  String get aboutTerms => 'شروط الخدمة';

  @override
  String get aboutPrivacy => 'سياسة الخصوصية';

  @override
  String get aboutOpenSource => 'تراخيص المصادر المفتوحة';

  @override
  String get addFriendTitle => 'إضافة صديق';

  @override
  String get addFriendFindByUsername => 'البحث باسم المستخدم';

  @override
  String get addFriendUsernameHint => 'أدخل اسم المستخدم...';

  @override
  String get addFriendTip =>
      'نصيحة: لاحقًا يمكننا دعم رمز QR + معرّف الأصدقاء.';

  @override
  String get addFriendSending => 'جارٍ الإرسال...';

  @override
  String get addFriendSendRequest => 'إرسال طلب';

  @override
  String addFriendUserNotFound(Object username) {
    return 'لم يتم العثور على @$username';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'فشل الإجراء أو تم إرساله بالفعل: $error';
  }

  @override
  String get friendsTitle => 'الأصدقاء';

  @override
  String get searchFriendsHint => 'البحث عن الأصدقاء...';

  @override
  String get somaLearnerSubtitle => 'متعلم Soma';

  @override
  String get friendRequestLabel => 'طلب';

  @override
  String get friendRequestSentLabel => 'تم إرسال الطلب';

  @override
  String get friendIncomingRequestLabel => 'طلب وارد';

  @override
  String get friendRequestsSection => 'الطلبات';

  @override
  String get friendPendingSection => 'قيد الانتظار';

  @override
  String get friendAllSection => 'جميع الأصدقاء';

  @override
  String get friendsEmptyState => 'لا يوجد أصدقاء بعد. أضف صديقك الأول!';

  @override
  String get friendsEmptyShort => 'لا يوجد أصدقاء بعد.';

  @override
  String noMatchForQuery(Object query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get inboxTitle => 'صندوق الوارد';

  @override
  String get searchChatsHint => 'البحث في المحادثات...';

  @override
  String get inboxEmptyState => 'لا توجد محادثات بعد. ابدأ الدردشة مع صديق!';

  @override
  String get newMessageTitle => 'رسالة جديدة';

  @override
  String get chatCallLater => 'مكالمة صوتية لاحقًا (لغة Circle قريبًا)';

  @override
  String errorWithDetails(Object error) {
    return 'خطأ: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'قل مرحبًا لـ $name!';
  }

  @override
  String get chatMessageHint => 'رسالة...';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsTabAll => 'الكل';

  @override
  String get notificationsTabCourses => 'الدورات';

  @override
  String get notificationsTabSocial => 'الاجتماعية';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'النظام';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات هنا.';

  @override
  String get notificationsDeleted => 'تم حذف الإشعار';

  @override
  String get notificationTitleFallback => 'إشعار';

  @override
  String get notificationTypeCourse => 'دورة';

  @override
  String get notificationTypeSocial => 'اجتماعي';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'النظام';

  @override
  String get notificationsFriendAccepted => 'تم قبول طلب الصداقة';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'فشل قبول طلب الصداقة: $error';
  }

  @override
  String get notificationsFriendDeclined => 'تم رفض طلب الصداقة';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'فشل رفض طلب الصداقة: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'فشل الانضمام إلى Circle: $error';
  }

  @override
  String get notificationsOpening => 'فتح';

  @override
  String get notificationsOpened => 'تم الفتح';

  @override
  String notificationsActionMessage(Object action) {
    return '$action إشعار';
  }

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionAccount => 'الحساب';

  @override
  String get settingsEditProfile => 'تعديل الملف الشخصي';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsSecurity => 'الأمان';

  @override
  String get settingsSectionGameplay => 'اللعب';

  @override
  String get settingsShowTranslationLine => 'إظهار سطر الترجمة';

  @override
  String get settingsShowReadingLine => 'إظهار القراءة (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'المؤقت الافتراضي لكل سؤال';

  @override
  String get settingsMatchDifficulty => 'صعوبة المباراة';

  @override
  String get settingsMatchDifficultyAdaptive => 'تكيفية';

  @override
  String get settingsSectionSoundFeel => 'الصوت والإحساس';

  @override
  String get settingsMusic => 'الموسيقى';

  @override
  String get settingsSoundEffects => 'المؤثرات الصوتية';

  @override
  String get settingsHaptics => 'الاهتزاز';

  @override
  String get settingsSectionNotifications => 'الإشعارات';

  @override
  String get settingsPushNotifications => 'الإشعارات الفورية';

  @override
  String get settingsDailyReminder => 'التذكير اليومي';

  @override
  String get settingsSectionAppearance => 'المظهر';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsUiLanguage => 'لغة الواجهة';

  @override
  String get settingsSectionAbout => 'حول';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsTermsPrivacy => 'الشروط والخصوصية';

  @override
  String get settingsSupport => 'الدعم';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageChinese => '中文';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageThai => 'ไทย';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageDutch => 'Nederlands';

  @override
  String get languagePersian => 'Persian';

  @override
  String get languagePunjabi => 'Punjabi';

  @override
  String get languageTamil => 'Tamil';

  @override
  String get languageTelugu => 'Telugu';

  @override
  String get languageSwahili => 'Swahili';

  @override
  String get languageMalay => 'Malay';

  @override
  String get languageRomanian => 'Romanian';

  @override
  String get languageGreek => 'Greek';

  @override
  String get languageHungarian => 'Hungarian';

  @override
  String get languageCzech => 'Czech';

  @override
  String get languageSwedish => 'Swedish';

  @override
  String get languageHebrew => 'Hebrew';

  @override
  String get languageNorwegian => 'Norwegian';

  @override
  String get languageDanish => 'Danish';

  @override
  String get languageFinnish => 'Finnish';

  @override
  String get editProfileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfilePhotoLabel => 'صورة الملف الشخصي';

  @override
  String get editProfilePhotoSubtitle =>
      'اختيار الصورة الرمزية عبر Supabase Storage قريبًا.';

  @override
  String get editProfileChangePhoto => 'تغيير';

  @override
  String get editProfileAvatarUploadSoon => 'تحميل الصورة الرمزية متاح قريبًا';

  @override
  String get editProfileDisplayNameLabel => 'الاسم المعروض';

  @override
  String get editProfileDisplayNameHint => 'اسمك';

  @override
  String get editProfileDisplayNameRequired => 'أدخل اسمك';

  @override
  String get editProfileDisplayNameTooShort => 'قصير جدًا';

  @override
  String get editProfileUsernameLabel => 'اسم المستخدم';

  @override
  String get editProfileUsernameHint => 'ali_mutaalim';

  @override
  String get editProfileUsernameRequired => 'أدخل اسم المستخدم';

  @override
  String get editProfileUsernameTooShort => '3 أحرف على الأقل';

  @override
  String get editProfileUsernameInvalid => 'أحرف وأرقام و _ فقط';

  @override
  String get editProfileBioLabel => 'السيرة الذاتية';

  @override
  String get editProfileBioHint => 'سيرة ذاتية قصيرة...';

  @override
  String get editProfileBioTooLong => '120 حرفًا كحد أقصى';

  @override
  String get editProfileLocationLabel => 'الموقع';

  @override
  String get editProfileLocationHint => 'المدينة / البلد';

  @override
  String get editProfileDailyGoalTitle => 'الهدف اليومي';

  @override
  String get editProfileDailyGoalSubtitle =>
      'اختر عدد الدقائق التي تريد أن تدرس فيها كل يوم.';

  @override
  String get securityTitle => 'الأمان';

  @override
  String get securitySectionPassword => 'كلمة المرور';

  @override
  String get securityChangePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get securityChangePasswordSubtitle => 'حدّث كلمة المرور بانتظام.';

  @override
  String get securitySectionTwoFactor => 'المصادقة الثنائية';

  @override
  String get securityEnable2faTitle => 'تمكين 2FA';

  @override
  String get securityEnable2faSubtitle => 'حماية إضافية عند تسجيل الدخول.';

  @override
  String get securitySectionAppLock => 'قفل التطبيق';

  @override
  String get securityBiometricTitle => 'فتح القفل البيومتري';

  @override
  String get securityBiometricSubtitle =>
      'استخدم FaceID/TouchID لفتح قفل SOMA.';

  @override
  String get securityAppLockTitle => 'قفل التطبيق';

  @override
  String get securityAppLockSubtitle => 'اقفل SOMA عند الخروج من التطبيق.';

  @override
  String get securitySectionSessions => 'الجلسات النشطة';

  @override
  String get securityNoSessions => 'لم يتم العثور على جلسات نشطة.';

  @override
  String get securityThisDevice => 'هذا الجهاز';

  @override
  String get securityDevice => 'الجهاز';

  @override
  String get securityActiveLabel => 'نشط';

  @override
  String get securitySignInToEnable2fa => 'سجّل الدخول لتمكين 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'فشل تمكين 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'فشل تعطيل 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'إعداد 2FA';

  @override
  String get securitySecretKeyLabel => 'المفتاح السري';

  @override
  String get securityCodeHint => 'رمز مكون من 6 أرقام';

  @override
  String get security2faEnabled => 'تم تمكين 2FA';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'فشل التحقق من الرمز: $error';
  }

  @override
  String get securityVerifying => 'جارٍ التحقق...';

  @override
  String get securityVerify => 'تحقق';

  @override
  String get securityCurrentPasswordHint => 'كلمة المرور الحالية';

  @override
  String get securityNewPasswordHint =>
      'كلمة المرور الجديدة (8 أحرف على الأقل)';

  @override
  String get securityConfirmPasswordHint => 'تأكيد كلمة المرور الجديدة';

  @override
  String get securitySignInToChangePassword => 'سجّل الدخول لتغيير كلمة المرور';

  @override
  String get securityEnterCurrentPassword => 'أدخل كلمة المرور الحالية';

  @override
  String get securityPasswordMinLength =>
      'يجب أن تحتوي كلمة المرور الجديدة على 8 أحرف على الأقل';

  @override
  String get securityPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get securityPasswordUpdated => 'تم تحديث كلمة المرور';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'فشل تحديث كلمة المرور: $error';
  }

  @override
  String get securityAutoLockAfter => 'القفل التلقائي بعد';

  @override
  String get privacyTitle => 'الخصوصية';

  @override
  String get privacySectionVisibility => 'الرؤية';

  @override
  String get privacyProfileVisibilityTitle => 'رؤية الملف الشخصي';

  @override
  String get privacyVisibilityPublic => 'عام';

  @override
  String get privacyVisibilityFriends => 'الأصدقاء';

  @override
  String get privacyVisibilityPrivate => 'خاص';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'يمكن لأي شخص رؤية ملفك الشخصي.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'يمكن للأصدقاء فقط رؤية ملفك الشخصي.';

  @override
  String get privacyVisibilityPrivateSubtitle => 'يمكنك فقط رؤية ملفك الشخصي.';

  @override
  String get privacySectionActivity => 'النشاط';

  @override
  String get privacyShowOnlineTitle => 'إظهار الحالة على الإنترنت';

  @override
  String get privacyShowOnlineSubtitle =>
      'السماح للآخرين برؤية متى تكون متصلاً.';

  @override
  String get privacyShowActivityTitle => 'إظهار نشاط التعلم';

  @override
  String get privacyShowActivitySubtitle => 'عرض السلسلة وXP والتقدم الحالي.';

  @override
  String get privacySectionSocial => 'الاجتماعية';

  @override
  String get privacyAllowRequestsTitle => 'السماح بطلبات الصداقة';

  @override
  String get privacyAllowRequestsSubtitle =>
      'السماح للأشخاص بإرسال طلبات صداقة.';

  @override
  String get privacyWhoCanDmTitle => 'من يمكنه إرسال رسائل';

  @override
  String get privacyDmEveryone => 'الجميع';

  @override
  String get privacyDmFriends => 'الأصدقاء';

  @override
  String get privacyDmNoOne => 'لا أحد';

  @override
  String get privacyDmEveryoneSubtitle => 'يمكن لأي شخص إرسال رسائل.';

  @override
  String get privacyDmFriendsSubtitle => 'يمكن للأصدقاء فقط إرسال رسائل.';

  @override
  String get privacyDmNoOneSubtitle => 'لا يمكن لأحد إرسال رسائل.';

  @override
  String get privacySectionBlockedUsers => 'المستخدمون المحظورون';

  @override
  String get privacyBlockedUsersComingSoon =>
      'إدارة المستخدمين المحظورين متاحة قريبًا.';

  @override
  String get privacySectionDataControls => 'عناصر التحكم في البيانات';

  @override
  String get privacyExportDataTitle => 'تصدير بياناتي';

  @override
  String get privacyExportDataSubtitle => 'نزّل نشاطك ودوراتك.';

  @override
  String get privacyExportInfoTitle => 'تصدير البيانات';

  @override
  String get privacyExportInfoBody =>
      'الخطوة التالية: إنشاء تصدير JSON/CSV وإرساله عبر البريد الإلكتروني أو تنزيله محليًا.';

  @override
  String get privacyDeleteAccountTitle => 'حذف الحساب';

  @override
  String get privacyDeleteAccountSubtitle =>
      'سيؤدي هذا إلى إزالة حسابك وبياناتك نهائيًا.';

  @override
  String get privacyDeleteConfirmTitle => 'حذف الحساب؟';

  @override
  String get privacyDeleteConfirmBody =>
      'هذا الإجراء دائم. سيتم إزالة ملفك الشخصي ودوراتك وأصدقائك ورسائلك.';

  @override
  String get privacyDeleteComingSoon => 'سيتم توصيل الحذف بـ Supabase لاحقًا';

  @override
  String get soloLabel => 'فردي';

  @override
  String get soloResultsCompletedTitle => 'اكتملت الجلسة الفردية';

  @override
  String get soloResultsFeedbackElite => 'أداء نخبوي. حافظ على السلسلة';

  @override
  String get soloResultsFeedbackStrong => 'عمل قوي. أنت تتحسن بسرعة.';

  @override
  String get soloResultsFeedbackProgress => 'تقدم جيد. راجع الأخطاء وكرر.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'لا توتر. حاول مرة أخرى بأسئلة أقل وتركيز.';

  @override
  String get soloResultsPerfectScore => 'نتيجة مثالية! لا توجد أخطاء للمراجعة.';

  @override
  String get soloResultsReviewPrompt =>
      'راجع الأخطاء للتعلم بشكل أسرع. سنعرض الإجابات الخاطئة أدناه.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'مراجعة الأخطاء ($count)';
  }

  @override
  String get authNotSignedIn => 'لم تسجل الدخول';

  @override
  String get genericUser => 'مستخدم';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get edit => 'تعديل';

  @override
  String get send => 'إرسال';

  @override
  String get join => 'انضم';

  @override
  String get leave => 'مغادرة';

  @override
  String get ready => 'جاهز';

  @override
  String get levelBeginner => 'مبتدئ';

  @override
  String get levelIntermediate => 'متوسط';

  @override
  String get levelAdvanced => 'متقدم';

  @override
  String questionsShort(Object count) {
    return '$count س';
  }

  @override
  String secondsShort(Object count) {
    return '$countث';
  }

  @override
  String get circlesAllCourses => 'جميع الدورات';

  @override
  String get circlesAllModes => 'جميع الأوضاع';

  @override
  String get circlesAllLevels => 'جميع المستويات';

  @override
  String get circlesAddNewCourse => 'إضافة دورة جديدة';

  @override
  String get circlesCoursesTitle => 'الدورات';

  @override
  String get circlesModeTitle => 'الوضع';

  @override
  String get circlesLevelTitle => 'المستوى';

  @override
  String get circlesNoActiveForFilters => 'لا يوجد Circles نشطة لهذه الفلاتر.';

  @override
  String get circlesUnknownRoom => 'غرفة غير معروفة';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'إنشاء Circle';

  @override
  String get circlesCircleName => 'اسم Circle';

  @override
  String get circlesEnterName => 'أدخل الاسم';

  @override
  String get circlesLanguages => 'اللغات';

  @override
  String get circlesRoomSetup => 'إعداد الغرفة';

  @override
  String get circlesPlayers => 'اللاعبون';

  @override
  String get circlesEmptySlot => 'مكان فارغ';

  @override
  String get circlesPlayersRange => '1-5 لاعبين';

  @override
  String get circlesQuestions => 'الأسئلة';

  @override
  String get circlesQuestionsSubtitle => 'عدد الأسئلة';

  @override
  String get circlesTimePerQuestion => 'الوقت لكل سؤال';

  @override
  String get circlesSecondsPerQuestion => 'ثواني لكل سؤال';

  @override
  String get circlesAdvanced => 'متقدم';

  @override
  String get circlesAllowSpectators => 'السماح بالمتفرجين';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'السماح للآخرين بالمشاهدة دون اللعب.';

  @override
  String get circlesLiveVoiceChat => 'محادثة صوتية مباشرة';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'تمكين الصوت المباشر أثناء المباريات.';

  @override
  String get circlesLiveTextChat => 'محادثة نصية مباشرة';

  @override
  String get circlesLiveTextChatSubtitle => 'تمكين المحادثة أثناء المباريات.';

  @override
  String get circlesRoomLocked => 'Room locked';

  @override
  String get circlesRoomUnlocked => 'Room unlocked';

  @override
  String get circlesSettingsSaved => 'Room settings saved';

  @override
  String circlesUpdateFailed(Object error) {
    return 'Couldn\'t update room: $error';
  }

  @override
  String get circlesLiveChatTitle => 'Live chat';

  @override
  String get circlesLiveChatPlaceholder => 'Type a message';

  @override
  String get circlesLiveChatEmpty => 'No messages yet. Start the chat!';

  @override
  String get circlesLiveChatUnavailable =>
      'Live chat is available inside active circles.';

  @override
  String get circlesCreateHelpTitle => 'Create a circle';

  @override
  String get circlesCreateHelpBody =>
      'Choose your languages, mode, and difficulty, then set room limits. Spectators can watch, and live chat lets everyone talk during the match.';

  @override
  String get circlesCreatedSuccess => 'تم إنشاء Circle';

  @override
  String circlesCreateError(Object error) {
    return 'فشل إنشاء Circle: $error';
  }

  @override
  String get circlesHostTip => 'نصيحة: يمكنك دعوة الأصدقاء بعد الإنشاء.';

  @override
  String circlesJoinError(Object error) {
    return 'فشل الانضمام إلى Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'ردهة Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'الرمز: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'إعدادات المباراة';

  @override
  String circlesLevelWithValue(Object level) {
    return 'المستوى $level';
  }

  @override
  String get circlesDifficulty => 'الصعوبة';

  @override
  String get circlesPerQuestionShort => 'لكل سؤال';

  @override
  String get circlesInvite => 'دعوة';

  @override
  String get circlesCopyId => 'نسخ المعرّف';

  @override
  String get circlesCopiedId => 'تم نسخ المعرّف';

  @override
  String get circlesMatchInProgress => 'المباراة جارية';

  @override
  String get circlesSpectatorQueuedBody => 'المباراة جارية. ستنضم كمتفرج.';

  @override
  String get circlesHostStartWhenReady =>
      'المضيف يبدأ عندما يكون الجميع جاهزين.';

  @override
  String get circlesSpectators => 'المتفرجون';

  @override
  String get circlesSpectator => 'متفرج';

  @override
  String get circlesSpectatorCanWatch => 'يمكن للمتفرجين المشاهدة مباشرة.';

  @override
  String get circlesJoinRequests => 'طلبات الانضمام';

  @override
  String get circlesAcceptSpectatorsHint => 'اقبل المتفرجين قبل بدء المباراة.';

  @override
  String get circlesStartGame => 'بدء اللعبة';

  @override
  String get circlesWaitingForPlayers => 'انتظار اللاعبين';

  @override
  String get circlesLeaveCircle => 'مغادرة Circle';

  @override
  String get circlesRequestSent => 'تم إرسال الطلب';

  @override
  String get circlesRequestToJoin => 'طلب الانضمام';

  @override
  String get circlesWatchLive => 'مشاهدة مباشرة';

  @override
  String get circlesPlayerTip =>
      'اضغط على جاهز عندما تكون مستعدًا. سيبدأ المضيف المباراة.';

  @override
  String get circlesSpectatorTip =>
      'أنت تشاهد. شاهد مباشرة بمجرد أن يبدأ المضيف.';

  @override
  String get circlesHostControls => 'عناصر تحكم المضيف';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'فشل نقل المضيف: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'فشل إنهاء Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'لم يتم العثور على @$username';
  }

  @override
  String get circlesInvalidUser => 'مستخدم غير صالح';

  @override
  String get circlesCantInviteSelf => 'لا يمكنك دعوة نفسك';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username موجود بالفعل في Circle';
  }

  @override
  String get circlesDefaultHost => 'المضيف';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'الدعوة باسم المستخدم';

  @override
  String circlesInviteSent(Object username) {
    return 'تم إرسال الدعوة إلى @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'فشل إرسال الدعوة: $error';
  }

  @override
  String get circlesJoinRequestSent => 'تم إرسال طلب الانضمام';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'فشل الطلب: $error';
  }

  @override
  String get circlesFull => 'Circle ممتلئ';

  @override
  String get circlesSpectatorAdded => 'تمت إضافة متفرج';

  @override
  String circlesApproveFailed(Object error) {
    return 'فشل الموافقة على الطلب: $error';
  }

  @override
  String get circlesRequestDeclined => 'تم رفض الطلب';

  @override
  String circlesDeclineFailed(Object error) {
    return 'فشل رفض الطلب: $error';
  }

  @override
  String get circlesParticipant => 'مشارك';

  @override
  String get circlesLeavePromptTitle => 'مغادرة Circle؟';

  @override
  String get circlesLeavePromptTransfer => 'انقل المضيف قبل المغادرة.';

  @override
  String get circlesLeavePromptEndOnly => 'أنهِ Circle وغادر.';

  @override
  String get circlesTransferHost => 'نقل المضيف';

  @override
  String get circlesEndCircle => 'إنهاء Circle';

  @override
  String get circlesTransferHostTitle => 'نقل المضيف';

  @override
  String circlesShareId(Object id) {
    return 'معرّف Circle: $id';
  }
}
