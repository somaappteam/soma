// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'یاد بگیر. رقابت کن. تسلط پیدا کن';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'ثبت نام';

  @override
  String get signIn => 'ورود';

  @override
  String get skipForNow => 'الان رد شو';

  @override
  String get authFillAllFields => 'لطفاً تمام فیلدها را پر کنید';

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
  String get authSignUpConfirmTitle => 'Confirm your email';

  @override
  String authSignUpConfirmBody(Object email) {
    return 'We sent a SOMA confirmation email to $email. Please confirm your email before continuing.';
  }

  @override
  String get authEmailResent => 'Confirmation email resent.';

  @override
  String authEmailResendFailed(Object error) {
    return 'Could not resend confirmation email: $error';
  }

  @override
  String get resend => 'Resend';

  @override
  String authError(Object error) {
    return 'خطا: $error';
  }

  @override
  String get authEmail => 'ایمیل';

  @override
  String get authPassword => 'رمز عبور';

  @override
  String get authUsername => 'نام کاربری';

  @override
  String get authContinue => 'ادامه';

  @override
  String get authSigningIn => 'در حال ورود...';

  @override
  String get authCreateAccount => 'ایجاد حساب';

  @override
  String get authCreating => 'در حال ایجاد...';

  @override
  String get authNeedAccount => 'حساب ندارید؟ ';

  @override
  String get authHaveAccount => 'قبلاً حساب دارید؟ ';

  @override
  String get dialogAuthRequiredTitle => 'برای دسترسی به Circles وارد شوید';

  @override
  String get dialogAuthRequiredBody =>
      'Circles اتاق‌های چند کاربره هستند. برای پیوستن به بازی‌های زنده، دعوت دوستان و ذخیره پیشرفت، حساب بسازید.';

  @override
  String get notNow => 'الان نه';

  @override
  String get navHome => 'خانه';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'پروفایل';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'دوره حذف شود؟';

  @override
  String removeCourseBody(Object course) {
    return '$course از لیست شما حذف می‌شود';
  }

  @override
  String get cancel => 'لغو';

  @override
  String get remove => 'حذف';

  @override
  String welcomeBack(Object name) {
    return 'خوش برگشتی، $name!';
  }

  @override
  String get editCourses => 'ویرایش دوره‌ها';

  @override
  String get done => 'انجام شد';

  @override
  String get noCoursesToEdit => 'دوره‌ای برای ویرایش نیست';

  @override
  String get addCourse => 'افزودن دوره';

  @override
  String get unknown => 'نامشخص';

  @override
  String get iSpeak => 'من صحبت می‌کنم';

  @override
  String get iWantToLearn => 'می‌خواهم یاد بگیرم';

  @override
  String get chooseYourLanguage => 'زبان خود را انتخاب کنید';

  @override
  String get chooseLearningLanguage => 'زبان یادگیری را انتخاب کنید';

  @override
  String get chooseTwoDifferentLanguages => 'لطفاً دو زبان مختلف انتخاب کنید';

  @override
  String get createCourse => 'ایجاد دوره';

  @override
  String get soloCourseTitle => 'دوره انفرادی';

  @override
  String get searchLanguage => 'جستجوی زبان';

  @override
  String get noMatches => 'تطابقی وجود ندارد';

  @override
  String get chooseCourseType => 'نوع دوره را انتخاب کنید';

  @override
  String get soloStudyDescription =>
      'به تنهایی با آزمون‌های مشابه Circles مطالعه کنید - اما بدون اتاق، چت، تماشاگر یا گزینه‌های میزبان';

  @override
  String get soloModeVocabulary => 'واژگان';

  @override
  String get soloModeSentences => 'جملات';

  @override
  String get soloModeReview => 'بازبینی';

  @override
  String get soloModeVocabularySubtitle =>
      'چند گزینه‌ای، معانی، مترادف‌ها، کاربرد';

  @override
  String get soloModeSentencesSubtitle => 'پر کردن جای خالی + ترجمه + خواندن';

  @override
  String get soloModeReviewDescription =>
      'تمرین آموخته‌ها: کلمات ضعیف، اشتباهات اخیر و تکرار فاصله‌دار';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'شروع بازبینی';

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
    return 'تنظیمات $mode';
  }

  @override
  String get difficulty => 'سختی';

  @override
  String get numberOfQuestions => 'تعداد سوالات';

  @override
  String get timerPerQuestion => 'زمان‌سنج برای هر سوال';

  @override
  String get noTimer => 'بدون زمان‌سنج';

  @override
  String get start => 'شروع';

  @override
  String get profileTitle => 'پروفایل';

  @override
  String get profileSignInToMessage => 'برای ارسال پیام وارد شوید';

  @override
  String get profileThatsYourProfile => 'این پروفایل شماست';

  @override
  String get profileSignInToAddFriends => 'برای افزودن دوستان وارد شوید';

  @override
  String get profileCantAddYourself => 'نمی‌توانید خودتان را اضافه کنید';

  @override
  String profileRequestSent(Object username) {
    return 'درخواست به @$username ارسال شد';
  }

  @override
  String get profileRequestFailed => 'ارسال درخواست ناموفق بود';

  @override
  String get profileDefaultDisplayName => 'کاربر جدید';

  @override
  String get profileDefaultBio => 'آماده یادگیری!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'مهمان';

  @override
  String get guestUsername => 'مهمان';

  @override
  String get guestSessionLabel => 'جلسه مهمان';

  @override
  String get unlockFullProfile => 'بازکردن پروفایل کامل';

  @override
  String get guestBenefitSync => 'همگام‌سازی پیشرفت در همه دستگاه‌ها';

  @override
  String get guestBenefitCircles => 'پیوستن به Circles و بازی زنده';

  @override
  String get guestBenefitNotifications => 'دریافت اعلان‌ها و درخواست‌های دوستی';

  @override
  String get progressStaysOnDevice =>
      'پیشرفت روی این دستگاه می‌ماند تا وارد شوید';

  @override
  String profileGoalLabel(Object minutes) {
    return 'هدف: $minutes دقیقه';
  }

  @override
  String get profileXpProgress => 'پیشرفت XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'برد‌ها';

  @override
  String get profileStreak => 'پی‌درپی';

  @override
  String get profileFriendsTitle => 'دوستان';

  @override
  String get profileViewAll => 'مشاهده همه';

  @override
  String get profileAchievementsTitle => 'دستاوردها';

  @override
  String get profileNoAchievements => 'هنوز دستاوردی نیست';

  @override
  String get profileRequested => 'درخواست ارسال شد';

  @override
  String get profileSending => 'در حال ارسال...';

  @override
  String get profileAddFriend => 'افزودن دوست';

  @override
  String get profileConnectTitle => 'ارتباط';

  @override
  String get profileMessage => 'پیام';

  @override
  String get profileSnapshot => 'عکس پروفایل';

  @override
  String get profileLocationHidden => 'موقعیت مخفی شده';

  @override
  String get profileBioHidden => 'بیوگرافی مخفی شده';

  @override
  String profileDailyGoal(Object minutes) {
    return 'هدف روزانه $minutes دقیقه';
  }

  @override
  String get circleInviteTitle => 'دعوتنامه Circle';

  @override
  String circleIdLabel(Object id) {
    return 'شناسه Circle: $id';
  }

  @override
  String get signInToJoin => 'برای پیوستن وارد شوید';

  @override
  String get joiningCircle => 'در حال پیوستن...';

  @override
  String get joinCircle => 'پیوستن به Circle';

  @override
  String get circleJoinedAsPlayer => 'به عنوان بازیکن پیوستید';

  @override
  String get circleJoinedAsSpectator => 'به عنوان تماشاگر پیوستید';

  @override
  String get accept => 'قبول';

  @override
  String get decline => 'رد';

  @override
  String get open => 'باز کردن';

  @override
  String get circleCountdownTitle => 'آماده شوید';

  @override
  String get circleCountdownSubtitle => 'Circle در حال شروع...';

  @override
  String get userFallbackName => 'کاربر';

  @override
  String get micOff => 'میکروفون خاموش';

  @override
  String get micOn => 'میکروفون روشن';

  @override
  String get roleHost => 'میزبان';

  @override
  String get roleSpectator => 'تماشاگر';

  @override
  String get tagHost => 'میزبان';

  @override
  String get tagYou => 'شما';

  @override
  String get statusCorrect => 'درست';

  @override
  String get statusWrong => 'اشتباه';

  @override
  String get statusWaiting => 'در انتظار';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'امتیاز';

  @override
  String get pointsLabel => 'امتیازها';

  @override
  String get statCorrect => 'درست';

  @override
  String get statAnswers => 'پاسخ‌ها';

  @override
  String get statTotal => 'کل';

  @override
  String get statQuestions => 'سوالات';

  @override
  String get statAccuracy => 'دقت';

  @override
  String get statRate => 'نرخ';

  @override
  String get statRank => 'رتبه';

  @override
  String get statPosition => 'موقعیت';

  @override
  String get statMode => 'حالت';

  @override
  String get statType => 'نوع';

  @override
  String get next => 'بعدی';

  @override
  String get submit => 'ارسال';

  @override
  String get continueLabel => 'ادامه';

  @override
  String get save => 'ذخیره';

  @override
  String get playAgain => 'بازی دوباره';

  @override
  String get backToCourse => 'بازگشت به دوره';

  @override
  String get resultsTitle => 'نتایج';

  @override
  String get shareLater => 'بعداً به اشتراک بگذارید';

  @override
  String get delete => 'حذف';

  @override
  String get ok => 'باشه';

  @override
  String minutesShort(Object minutes) {
    return '$minutes دقیقه';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count دق';
  }

  @override
  String timeShortHours(Object count) {
    return '$count ساعت';
  }

  @override
  String timeShortDays(Object count) {
    return '$count روز';
  }

  @override
  String get timeJustNow => 'همین الان';

  @override
  String timeMinutesAgo(Object count) {
    return '$count دقیقه پیش';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count ساعت پیش';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count روز پیش';
  }

  @override
  String get liveQuizWaitingForHost => 'در انتظار میزبان...';

  @override
  String get liveQuizJoinRequestSent => 'درخواست پیوستن ارسال شد';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'ارسال درخواست ناموفق بود: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'کنترل‌های میزبان';

  @override
  String get liveQuizSpectatorModeTitle => 'حالت تماشاگر';

  @override
  String get liveQuizHostControlsSubtitle =>
      'دور‌ها به طور خودکار پیش می‌روند وقتی همه پاسخ دهند یا زمان تمام شود';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'سوالات و جدول امتیازات را به صورت زنده تماشا کنید. نمی‌توانید پاسخ دهید';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'سوال $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'درخواست ارسال شد';

  @override
  String get liveQuizRequestToJoin => 'درخواست پیوستن';

  @override
  String get liveQuizSpectatorFooter =>
      'شما دارید زنده تماشا می‌کنید. از سوالات و جدول امتیازات لذت ببرید';

  @override
  String get circleNotFound => 'Circle یافت نشد';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'شروع مسابقه مجدد ناموفق بود: $error';
  }

  @override
  String get resultsMatchTitle => 'نتایج مسابقه';

  @override
  String resultsNiceWork(Object name) {
    return 'کار خوبی بود، $name';
  }

  @override
  String get resultsPlaceFirst => 'مقام اول';

  @override
  String get resultsPlaceSecond => 'مقام دوم';

  @override
  String get resultsPlaceThird => 'مقام سوم';

  @override
  String resultsPlaceNth(Object rank) {
    return 'مقام $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'از $players بازیکن';
  }

  @override
  String get resultsHighlightChampion => 'قهرمان! شما در این دور تسلط داشتید';

  @override
  String get resultsHighlightGreatAccuracy => 'دقت عالی - نزدیک قله هستید!';

  @override
  String get resultsHighlightKeepGoing =>
      'ادامه دهید - پایداری بر سرعت غلبه می‌کند';

  @override
  String get resultsLeaderboardTitle => 'جدول امتیازات';

  @override
  String resultsPlayersCount(Object count) {
    return '$count بازیکن';
  }

  @override
  String get resultsBackToCircles => 'بازگشت به Circles';

  @override
  String get resultsRematch => 'مسابقه مجدد';

  @override
  String get resultsPlayAgain => 'بازی دوباره';

  @override
  String get leaderboardGlobalTitle => 'رتبه‌بندی جهانی';

  @override
  String get leaderboardEmpty => 'هنوز رتبه‌بندی نیست';

  @override
  String get aboutTitle => 'درباره برنامه';

  @override
  String aboutVersion(Object version) {
    return 'نسخه $version';
  }

  @override
  String get aboutDescription =>
      'SOMA یک پلتفرم یادگیری زبان بازی‌سازی‌شده است که تسلط بر زبان‌های جدید را جذاب و اجتماعی می‌کند. در Circles رقابت کنید، به تنهایی تمرین کنید و پیشرفتتان را دنبال کنید.';

  @override
  String get aboutTerms => 'شرایط استفاده';

  @override
  String get aboutPrivacy => 'سیاست حفظ حریم خصوصی';

  @override
  String get aboutOpenSource => 'مجوزهای متن‌باز';

  @override
  String get addFriendTitle => 'افزودن دوست';

  @override
  String get addFriendFindByUsername => 'جستجو با نام کاربری';

  @override
  String get addFriendUsernameHint => 'نام کاربری را وارد کنید...';

  @override
  String get addFriendTip =>
      'نکته: پشتیبانی کد QR + شناسه دوست بعداً اضافه می‌شود';

  @override
  String get addFriendSending => 'در حال ارسال...';

  @override
  String get addFriendSendRequest => 'ارسال درخواست';

  @override
  String addFriendUserNotFound(Object username) {
    return 'کاربر @$username یافت نشد';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'عمل ناموفق بود یا قبلاً ارسال شده: $error';
  }

  @override
  String get friendsTitle => 'دوستان';

  @override
  String get searchFriendsHint => 'جستجوی دوستان...';

  @override
  String get somaLearnerSubtitle => 'یادگیرنده Soma';

  @override
  String get friendRequestLabel => 'درخواست';

  @override
  String get friendRequestSentLabel => 'درخواست ارسال شد';

  @override
  String get friendIncomingRequestLabel => 'درخواست ورودی';

  @override
  String get friendRequestsSection => 'درخواست‌ها';

  @override
  String get friendPendingSection => 'در انتظار';

  @override
  String get friendAllSection => 'همه دوستان';

  @override
  String get friendsEmptyState =>
      'هنوز دوستی ندارید. اولین دوستتان را اضافه کنید!';

  @override
  String get friendsEmptyShort => 'هنوز دوستی نیست';

  @override
  String noMatchForQuery(Object query) {
    return 'تطابقی برای \\\"$query\\\" یافت نشد';
  }

  @override
  String get inboxTitle => 'صندوق ورودی';

  @override
  String get searchChatsHint => 'جستجوی گفتگوها...';

  @override
  String get inboxEmptyState => 'هنوز گفتگویی نیست. با دوستی گفتگو شروع کنید!';

  @override
  String get newMessageTitle => 'پیام جدید';

  @override
  String get chatCallLater => 'تماس صوتی بعداً (صدای Circle بعدی است)';

  @override
  String errorWithDetails(Object error) {
    return 'خطا: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'به $name سلام کنید!';
  }

  @override
  String get chatMessageHint => 'پیام...';

  @override
  String get notificationsTitle => 'اعلان‌ها';

  @override
  String get notificationsTabAll => 'همه';

  @override
  String get notificationsTabCourses => 'دوره‌ها';

  @override
  String get notificationsTabSocial => 'اجتماعی';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'سیستم';

  @override
  String get notificationsEmpty => 'اعلانی نیست';

  @override
  String get notificationsDeleted => 'اعلان حذف شد';

  @override
  String get notificationTitleFallback => 'اعلان';

  @override
  String get notificationTypeCourse => 'دوره';

  @override
  String get notificationTypeSocial => 'اجتماعی';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'سیستم';

  @override
  String get notificationsFriendAccepted => 'درخواست دوستی پذیرفته شد';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'پذیرش درخواست دوستی ناموفق بود: $error';
  }

  @override
  String get notificationsFriendDeclined => 'درخواست دوستی رد شد';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'رد درخواست دوستی ناموفق بود: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'پیوستن به Circle ناموفق بود: $error';
  }

  @override
  String get notificationsOpening => 'در حال باز کردن';

  @override
  String get notificationsOpened => 'باز شد';

  @override
  String notificationsActionMessage(Object action) {
    return '$action اعلان';
  }

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get settingsSectionAccount => 'حساب';

  @override
  String get settingsEditProfile => 'ویرایش پروفایل';

  @override
  String get settingsPrivacy => 'حریم خصوصی';

  @override
  String get settingsSecurity => 'امنیت';

  @override
  String get settingsSectionGameplay => 'بازی';

  @override
  String get settingsShowTranslationLine => 'نمایش خط ترجمه';

  @override
  String get settingsShowReadingLine => 'نمایش خواندن (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'زمان‌سنج پیش‌فرض هر سوال';

  @override
  String get settingsMatchDifficulty => 'سختی مسابقه';

  @override
  String get settingsMatchDifficultyAdaptive => 'تطبیقی';

  @override
  String get settingsSectionSoundFeel => 'صدا و احساس';

  @override
  String get settingsMusic => 'موسیقی';

  @override
  String get settingsSoundEffects => 'جلوه‌های صوتی';

  @override
  String get settingsHaptics => 'لرزش';

  @override
  String get settingsSectionNotifications => 'اعلان‌ها';

  @override
  String get settingsPushNotifications => 'اعلا‌ن‌های فشاری';

  @override
  String get settingsDailyReminder => 'یادآوری روزانه';

  @override
  String get settingsSectionAppearance => 'ظاهر';

  @override
  String get settingsTheme => 'تم';

  @override
  String get settingsUiLanguage => 'زبان رابط کاربری';

  @override
  String get settingsSectionAbout => 'درباره';

  @override
  String get settingsVersion => 'نسخه';

  @override
  String get settingsTermsPrivacy => 'شرایط و حریم خصوصی';

  @override
  String get settingsSupport => 'پشتیبانی';

  @override
  String get settingsLogout => 'خروج';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeDark => 'تاریک';

  @override
  String get themeLight => 'روشن';

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
  String get languagePersian => 'فارسی';

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
  String get editProfileUpdated => 'پروفایل به‌روز شد';

  @override
  String get editProfileTitle => 'ویرایش پروفایل';

  @override
  String get editProfilePhotoLabel => 'عکس پروفایل';

  @override
  String get editProfilePhotoSubtitle =>
      'انتخاب آواتار از طریق Supabase Storage به زودی';

  @override
  String get editProfileChangePhoto => 'تغییر';

  @override
  String get editProfileAvatarUploadSoon => 'بارگذاری آواتار به زودی';

  @override
  String get editProfileDisplayNameLabel => 'نام نمایشی';

  @override
  String get editProfileDisplayNameHint => 'نام شما';

  @override
  String get editProfileDisplayNameRequired => 'نام خود را وارد کنید';

  @override
  String get editProfileDisplayNameTooShort => 'خیلی کوتاه';

  @override
  String get editProfileUsernameLabel => 'نام کاربری';

  @override
  String get editProfileUsernameHint => 'علی_یادگیرنده';

  @override
  String get editProfileUsernameRequired => 'نام کاربری را وارد کنید';

  @override
  String get editProfileUsernameTooShort => 'حداقل 3 کاراکتر';

  @override
  String get editProfileUsernameInvalid => 'فقط حروف، اعداد، _';

  @override
  String get editProfileBioLabel => 'بیوگرافی';

  @override
  String get editProfileBioHint => 'یک بیوگرافی کوتاه...';

  @override
  String get editProfileBioTooLong => 'حداکثر 120 کاراکتر';

  @override
  String get editProfileLocationLabel => 'موقعیت';

  @override
  String get editProfileLocationHint => 'شهر / کشور';

  @override
  String get editProfileDailyGoalTitle => 'هدف روزانه';

  @override
  String get editProfileDailyGoalSubtitle =>
      'انتخاب کنید چند دقیقه در روز می‌خواهید مطالعه کنید';

  @override
  String get securityTitle => 'امنیت';

  @override
  String get securitySectionPassword => 'رمز عبور';

  @override
  String get securityChangePasswordTitle => 'تغییر رمز عبور';

  @override
  String get securityChangePasswordSubtitle =>
      'رمز عبور خود را به طور منظم به‌روز کنید';

  @override
  String get securitySectionTwoFactor => 'احراز هویت دو مرحله‌ای';

  @override
  String get securityEnable2faTitle => 'فعال کردن 2FA';

  @override
  String get securityEnable2faSubtitle => 'حفاظت اضافی هنگام ورود';

  @override
  String get securitySectionAppLock => 'قفل برنامه';

  @override
  String get securityBiometricTitle => 'باز کردن قفل بیومتریک';

  @override
  String get securityBiometricSubtitle =>
      'از FaceID/TouchID برای باز کردن SOMA استفاده کنید';

  @override
  String get securityAppLockTitle => 'قفل برنامه';

  @override
  String get securityAppLockSubtitle => 'SOMA را هنگام خروج از برنامه قفل کنید';

  @override
  String get securitySectionSessions => 'جلسات فعال';

  @override
  String get securityNoSessions => 'جلسه فعالی یافت نشد';

  @override
  String get securityThisDevice => 'این دستگاه';

  @override
  String get securityDevice => 'دستگاه';

  @override
  String get securityActiveLabel => 'فعال';

  @override
  String get securitySignInToEnable2fa => 'برای فعال کردن 2FA وارد شوید';

  @override
  String securityEnable2faFailed(Object error) {
    return 'فعال کردن 2FA ناموفق بود: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'غیرفعال کردن 2FA ناموفق بود: $error';
  }

  @override
  String get securitySetup2faTitle => 'راه‌اندازی 2FA';

  @override
  String get securitySecretKeyLabel => 'کلید مخفی';

  @override
  String get securityCodeHint => 'کد 6 رقمی';

  @override
  String get security2faEnabled => '2FA فعال شد';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'تأیید کد ناموفق بود: $error';
  }

  @override
  String get securityVerifying => 'در حال تأیید...';

  @override
  String get securityVerify => 'تأیید';

  @override
  String get securityCurrentPasswordHint => 'رمز عبور فعلی';

  @override
  String get securityNewPasswordHint => 'رمز عبور جدید (حداقل 8 کاراکتر)';

  @override
  String get securityConfirmPasswordHint => 'تأیید رمز عبور جدید';

  @override
  String get securitySignInToChangePassword => 'برای تغییر رمز عبور وارد شوید';

  @override
  String get securityEnterCurrentPassword => 'رمز عبور فعلی خود را وارد کنید';

  @override
  String get securityPasswordMinLength =>
      'رمز عبور جدید باید حداقل 8 کاراکتر داشته باشد';

  @override
  String get securityPasswordsDoNotMatch => 'رمزهای عبور مطابقت ندارند';

  @override
  String get securityPasswordUpdated => 'رمز عبور به‌روز شد';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'به‌روزرسانی رمز عبور ناموفق بود: $error';
  }

  @override
  String get securityAutoLockAfter => 'قفل خودکار پس از';

  @override
  String get privacyTitle => 'حریم خصوصی';

  @override
  String get privacySectionVisibility => 'نمایش';

  @override
  String get privacyProfileVisibilityTitle => 'نمایش پروفایل';

  @override
  String get privacyVisibilityPublic => 'عمومی';

  @override
  String get privacyVisibilityFriends => 'دوستان';

  @override
  String get privacyVisibilityPrivate => 'خصوصی';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'همه می‌توانند پروفایل شما را ببینند';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'فقط دوستان می‌توانند پروفایل شما را ببینند';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'فقط شما می‌توانید پروفایل خود را ببینید';

  @override
  String get privacySectionActivity => 'فعالیت';

  @override
  String get privacyShowOnlineTitle => 'نمایش وضعیت آنلاین';

  @override
  String get privacyShowOnlineSubtitle =>
      'به دیگران اجازه دهید وقتی آنلاین هستید ببینند';

  @override
  String get privacyShowActivityTitle => 'نمایش فعالیت یادگیری';

  @override
  String get privacyShowActivitySubtitle => 'نمایش پی‌درپی، XP و پیشرفت اخیر';

  @override
  String get privacySectionSocial => 'اجتماعی';

  @override
  String get privacyAllowRequestsTitle => 'اجازه درخواست‌های دوستی';

  @override
  String get privacyAllowRequestsSubtitle =>
      'به افراد اجازه دهید درخواست دوستی بفرستند';

  @override
  String get privacyWhoCanDmTitle => 'چه کسی می‌تواند DM بفرستد';

  @override
  String get privacyDmEveryone => 'همه';

  @override
  String get privacyDmFriends => 'دوستان';

  @override
  String get privacyDmNoOne => 'هیچ‌کس';

  @override
  String get privacyDmEveryoneSubtitle => 'هر کسی می‌تواند به شما پیام دهد';

  @override
  String get privacyDmFriendsSubtitle =>
      'فقط دوستان می‌توانند به شما پیام دهند';

  @override
  String get privacyDmNoOneSubtitle => 'هیچ‌کس نمی‌تواند به شما پیام دهد';

  @override
  String get privacySectionBlockedUsers => 'کاربران مسدود شده';

  @override
  String get privacyBlockedUsersComingSoon =>
      'مدیریت کاربران مسدود شده به زودی';

  @override
  String get privacySectionDataControls => 'کنترل‌های داده';

  @override
  String get privacyExportDataTitle => 'صدور داده‌های من';

  @override
  String get privacyExportDataSubtitle =>
      'فعالیت و دوره‌های خود را دانلود کنید';

  @override
  String get privacyExportInfoTitle => 'صدور داده';

  @override
  String get privacyExportInfoBody =>
      'مرحله بعد: ایجاد صدور JSON/CSV و ایمیل یا دانلود محلی';

  @override
  String get privacyDeleteAccountTitle => 'حذف حساب';

  @override
  String get privacyDeleteAccountSubtitle =>
      'این کار حساب و داده‌های شما را برای همیشه حذف می‌کند';

  @override
  String get privacyDeleteConfirmTitle => 'حذف حساب؟';

  @override
  String get privacyDeleteConfirmBody =>
      'این عمل قابل بازگشت نیست. پروفایل، دوره‌ها، دوستان و پیام‌های شما حذف خواهند شد';

  @override
  String get privacyDeleteComingSoon => 'حذف بعداً به Supabase متصل می‌شود';

  @override
  String get soloLabel => 'انفرادی';

  @override
  String get soloResultsCompletedTitle => 'جلسه انفرادی تکمیل شد';

  @override
  String get soloResultsFeedbackElite => 'عملکرد ممتاز - سلسله را حفظ کنید';

  @override
  String get soloResultsFeedbackStrong => 'کار قوی - به سرعت بهتر می‌شوید';

  @override
  String get soloResultsFeedbackProgress =>
      'پیشرفت خوب - اشتباهات را بررسی و دوباره امتحان کنید';

  @override
  String get soloResultsFeedbackTryAgain =>
      'فشاری نیست - با سوالات کمتر دوباره امتحان کنید و تمرکز کنید';

  @override
  String get soloResultsPerfectScore => 'امتیاز کامل! اشتباهی برای بررسی نیست';

  @override
  String get soloResultsReviewPrompt =>
      'برای یادگیری سریع‌تر اشتباهات را بررسی کنید. پاسخ‌های اشتباه شما در زیر است';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'بررسی اشتباهات ($count)';
  }

  @override
  String get authNotSignedIn => 'وارد نشده‌اید';

  @override
  String get genericUser => 'کاربر';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get edit => 'ویرایش';

  @override
  String get send => 'ارسال';

  @override
  String get join => 'پیوستن';

  @override
  String get leave => 'خروج';

  @override
  String get ready => 'آماده';

  @override
  String get levelBeginner => 'مبتدی';

  @override
  String get levelIntermediate => 'متوسط';

  @override
  String get levelAdvanced => 'پیشرفته';

  @override
  String questionsShort(Object count) {
    return '$count سوال';
  }

  @override
  String secondsShort(Object count) {
    return '$count ثانیه';
  }

  @override
  String get circlesAllCourses => 'همه دوره‌ها';

  @override
  String get circlesAllModes => 'همه حالت‌ها';

  @override
  String get circlesAllLevels => 'همه سطوح';

  @override
  String get circlesAddNewCourse => 'افزودن دوره جدید';

  @override
  String get circlesCoursesTitle => 'دوره‌ها';

  @override
  String get circlesModeTitle => 'حالت';

  @override
  String get circlesLevelTitle => 'سطح';

  @override
  String get circlesNoActiveForFilters => 'Circle فعالی برای این فیلترها نیست';

  @override
  String get circlesUnknownRoom => 'اتاق نامشخص';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'ایجاد Circle';

  @override
  String get circlesCircleName => 'نام Circle';

  @override
  String get circlesEnterName => 'نام را وارد کنید';

  @override
  String get circlesLanguages => 'زبان‌ها';

  @override
  String get circlesRoomSetup => 'تنظیمات اتاق';

  @override
  String get circlesPlayers => 'بازیکنان';

  @override
  String get circlesEmptySlot => 'جای خالی';

  @override
  String get circlesPlayersRange => '1-5 بازیکن';

  @override
  String get circlesQuestions => 'سوالات';

  @override
  String get circlesQuestionsSubtitle => 'تعداد سوالات';

  @override
  String get circlesTimePerQuestion => 'زمان هر سوال';

  @override
  String get circlesSecondsPerQuestion => 'ثانیه هر سوال';

  @override
  String get circlesAdvanced => 'پیشرفته';

  @override
  String get circlesAllowSpectators => 'اجازه تماشاگران';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Let others watch without playing.';

  @override
  String get circlesLiveVoiceChat => 'چت صوتی زنده';

  @override
  String get circlesLiveVoiceChatSubtitle => 'فعال کردن ارتباط صوتی در مسابقات';

  @override
  String get circlesLiveTextChat => 'چت متنی زنده';

  @override
  String get circlesLiveTextChatSubtitle => 'فعال کردن چت در مسابقات';

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
  String get circlesCreatedSuccess => 'Circle ایجاد شد';

  @override
  String circlesCreateError(Object error) {
    return 'ایجاد Circle ناموفق بود: $error';
  }

  @override
  String get circlesHostTip =>
      'نکته: می‌توانید بعد از ایجاد دوستان را دعوت کنید';

  @override
  String circlesJoinError(Object error) {
    return 'پیوستن به Circle ناموفق بود: $error';
  }

  @override
  String get circlesLobbyTitle => 'لابی Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'کد: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'تنظیمات مسابقه';

  @override
  String circlesLevelWithValue(Object level) {
    return 'سطح $level';
  }

  @override
  String get circlesDifficulty => 'سختی';

  @override
  String get circlesPerQuestionShort => 'هر سوال';

  @override
  String get circlesInvite => 'دعوت';

  @override
  String get circlesCopyId => 'کپی شناسه';

  @override
  String get circlesCopiedId => 'شناسه کپی شد';

  @override
  String get circlesMatchInProgress => 'مسابقه در حال انجام';

  @override
  String get circlesSpectatorQueuedBody =>
      'مسابقه در حال انجام. به عنوان تماشاگر پیوست خواهید شد';

  @override
  String get circlesHostStartWhenReady =>
      'میزبان وقتی همه آماده باشند شروع می‌کند';

  @override
  String get circlesSpectators => 'تماشاگران';

  @override
  String get circlesSpectator => 'تماشاگر';

  @override
  String get circlesSpectatorCanWatch => 'تماشاگران می‌توانند زنده تماشا کنند';

  @override
  String get circlesJoinRequests => 'درخواست‌های پیوستن';

  @override
  String get circlesAcceptSpectatorsHint =>
      'تماشاگران را قبل از شروع مسابقه بپذیرید';

  @override
  String get circlesStartGame => 'شروع بازی';

  @override
  String get circlesWaitingForPlayers => 'در انتظار بازیکنان';

  @override
  String get circlesLeaveCircle => 'ترک Circle';

  @override
  String get circlesRequestSent => 'درخواست ارسال شد';

  @override
  String get circlesRequestToJoin => 'درخواست پیوستن';

  @override
  String get circlesWatchLive => 'تماشای زنده';

  @override
  String get circlesPlayerTip =>
      'وقتی آماده شدید آماده را بزنید. میزبان مسابقه را شروع می‌کند';

  @override
  String get circlesSpectatorTip =>
      'شما تماشا می‌کنید. وقتی میزبان شروع کند زنده تماشا کنید';

  @override
  String get circlesHostControls => 'کنترل‌های میزبان';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'انتقال میزبان ناموفق بود: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'پایان Circle ناموفق بود: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'کاربر @$username یافت نشد';
  }

  @override
  String get circlesInvalidUser => 'کاربر نامعتبر';

  @override
  String get circlesCantInviteSelf => 'نمی‌توانید خودتان را دعوت کنید';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username قبلاً در Circle است';
  }

  @override
  String get circlesDefaultHost => 'میزبان';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'دعوت با نام کاربری';

  @override
  String circlesInviteSent(Object username) {
    return 'دعوتنامه به @$username ارسال شد';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'ارسال دعوتنامه ناموفق بود: $error';
  }

  @override
  String get circlesJoinRequestSent => 'درخواست پیوستن ارسال شد';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'ارسال درخواست ناموفق بود: $error';
  }

  @override
  String get circlesFull => 'Circle پر است';

  @override
  String get circlesSpectatorAdded => 'تماشاگر اضافه شد';

  @override
  String circlesApproveFailed(Object error) {
    return 'تأیید درخواست ناموفق بود: $error';
  }

  @override
  String get circlesRequestDeclined => 'درخواست رد شد';

  @override
  String circlesDeclineFailed(Object error) {
    return 'رد درخواست ناموفق بود: $error';
  }

  @override
  String get circlesParticipant => 'شرکت‌کننده';

  @override
  String get circlesLeavePromptTitle => 'ترک Circle؟';

  @override
  String get circlesLeavePromptTransfer =>
      'لطفاً قبل از ترک میزبان را منتقل کنید';

  @override
  String get circlesLeavePromptEndOnly => 'پایان Circle و خروج';

  @override
  String get circlesTransferHost => 'انتقال میزبان';

  @override
  String get circlesEndCircle => 'پایان Circle';

  @override
  String get circlesTransferHostTitle => 'انتقال میزبان';

  @override
  String circlesShareId(Object id) {
    return 'شناسه Circle: $id';
  }

  @override
  String incomingCallFrom(Object name) {
    return 'Incoming call from $name';
  }

  @override
  String get declineCall => 'Decline';

  @override
  String get acceptCall => 'Accept';

  @override
  String get voiceCall => 'Voice call';

  @override
  String inCallWith(Object name) {
    return 'In call • $name';
  }

  @override
  String get authBenefitLiveCircles => 'Live circles with real learners';

  @override
  String get authBenefitVoiceRooms => 'Voice rooms with instant practice';

  @override
  String get authBenefitFriendChallenges =>
      'Friend challenges and saved progress';
}
