// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'سیکھیں۔ مقابلہ کریں۔ حکمرانی کریں';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'سائن اپ';

  @override
  String get signIn => 'سائن ان';

  @override
  String get skipForNow => 'ابھی چھوڑ دیں';

  @override
  String get authFillAllFields => 'براہ کرم تمام خانے پُر کریں';

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
    return 'خرابی: $error';
  }

  @override
  String get authEmail => 'ای میل';

  @override
  String get authPassword => 'پاس ورڈ';

  @override
  String get authUsername => 'صارف نام';

  @override
  String get authContinue => 'جاری رکھیں';

  @override
  String get authSigningIn => 'سائن ان ہو رہا ہے...';

  @override
  String get authCreateAccount => 'اکاؤنٹ بنائیں';

  @override
  String get authCreating => 'بنایا جا رہا ہے...';

  @override
  String get authNeedAccount => 'اکاؤنٹ نہیں ہے؟ ';

  @override
  String get authHaveAccount => 'پہلے سے اکاؤنٹ ہے؟ ';

  @override
  String get dialogAuthRequiredTitle => 'Circles تک رسائی کے لیے سائن ان کریں';

  @override
  String get dialogAuthRequiredBody =>
      'Circles کثیر صارف کمرے ہیں۔ لائیو میچز میں شامل ہونے، دوستوں کو مدعو کرنے اور پیشرفت محفوظ کرنے کے لیے اکاؤنٹ بنائیں۔';

  @override
  String get notNow => 'ابھی نہیں';

  @override
  String get navHome => 'ہوم';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'کورس ہٹائیں؟';

  @override
  String removeCourseBody(Object course) {
    return '$course آپ کی فہرست سے ہٹایا جائے گا';
  }

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get remove => 'ہٹائیں';

  @override
  String welcomeBack(Object name) {
    return 'خوش آمدید، $name!';
  }

  @override
  String get editCourses => 'کورسز میں ترمیم کریں';

  @override
  String get done => 'مکمل';

  @override
  String get noCoursesToEdit => 'ترمیم کے لیے کوئی کورس نہیں';

  @override
  String get addCourse => 'کورس شامل کریں';

  @override
  String get unknown => 'نامعلوم';

  @override
  String get iSpeak => 'میں بولتا ہوں';

  @override
  String get iWantToLearn => 'میں سیکھنا چاہتا ہوں';

  @override
  String get chooseYourLanguage => 'اپنی زبان منتخب کریں';

  @override
  String get chooseLearningLanguage => 'سیکھنے کی زبان منتخب کریں';

  @override
  String get chooseTwoDifferentLanguages =>
      'براہ کرم دو مختلف زبانیں منتخب کریں';

  @override
  String get createCourse => 'کورس بنائیں';

  @override
  String get soloCourseTitle => 'سولو کورس';

  @override
  String get searchLanguage => 'زبان تلاش کریں';

  @override
  String get noMatches => 'کوئی مماثلت نہیں';

  @override
  String get chooseCourseType => 'کورس کی قسم منتخب کریں';

  @override
  String get soloStudyDescription =>
      'Circles جیسے ہی کوئزز کے ساتھ اکیلے مطالعہ کریں - لیکن کمروں، چیٹ، ناظرین یا میزبان کے اختیارات کے بغیر';

  @override
  String get soloModeVocabulary => 'الفاظ';

  @override
  String get soloModeSentences => 'جملے';

  @override
  String get soloModeReview => 'نظرثانی';

  @override
  String get soloModeVocabularySubtitle =>
      'کثیر انتخاب، معنی، مترادفات، استعمال';

  @override
  String get soloModeSentencesSubtitle => 'خالی جگہ پُر کریں + ترجمہ + پڑھنا';

  @override
  String get soloModeReviewDescription =>
      'سیکھے ہوئے کی مشق کریں: کمزور الفاظ، حالیہ غلطیاں، اور وقفہ دہرائی';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'نظرثانی شروع کریں';

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
    return '$mode سیٹ اپ';
  }

  @override
  String get difficulty => 'مشکل';

  @override
  String get numberOfQuestions => 'سوالات کی تعداد';

  @override
  String get timerPerQuestion => 'فی سوال ٹائمر';

  @override
  String get noTimer => 'کوئی ٹائمر نہیں';

  @override
  String get start => 'شروع کریں';

  @override
  String get profileTitle => 'پروفائل';

  @override
  String get profileSignInToMessage => 'پیغام بھیجنے کے لیے سائن ان کریں';

  @override
  String get profileThatsYourProfile => 'یہ آپ کا پروفائل ہے';

  @override
  String get profileSignInToAddFriends => 'دوست شامل کرنے کے لیے سائن ان کریں';

  @override
  String get profileCantAddYourself => 'آپ خود کو شامل نہیں کر سکتے';

  @override
  String profileRequestSent(Object username) {
    return 'درخواست @$username کو بھیجی گئی';
  }

  @override
  String get profileRequestFailed => 'درخواست بھیجنے میں ناکامی';

  @override
  String get profileDefaultDisplayName => 'نیا صارف';

  @override
  String get profileDefaultBio => 'سیکھنے کے لیے تیار!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'مہمان';

  @override
  String get guestUsername => 'مہمان';

  @override
  String get guestSessionLabel => 'مہمان سیشن';

  @override
  String get unlockFullProfile => 'مکمل پروفائل کھولیں';

  @override
  String get guestBenefitSync => 'تمام آلات پر پیشرفت ہم آہنگ کریں';

  @override
  String get guestBenefitCircles => 'Circles میں شامل ہوں اور لائیو کھیلیں';

  @override
  String get guestBenefitNotifications =>
      'اطلاعات اور دوستی کی درخواستیں حاصل کریں';

  @override
  String get progressStaysOnDevice =>
      'پیشرفت اس آلہ پر رہتی ہے جب تک آپ سائن ان نہیں کرتے';

  @override
  String profileGoalLabel(Object minutes) {
    return 'ہدف: $minutes منٹ';
  }

  @override
  String get profileXpProgress => 'XP پیشرفت';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'جیتیں';

  @override
  String get profileStreak => 'لگاتار';

  @override
  String get profileFriendsTitle => 'دوست';

  @override
  String get profileViewAll => 'سب دیکھیں';

  @override
  String get profileAchievementsTitle => 'کامیابیاں';

  @override
  String get profileNoAchievements => 'ابھی تک کوئی کامیابیاں نہیں';

  @override
  String get profileRequested => 'درخواست بھیجی گئی';

  @override
  String get profileSending => 'بھیجا جا رہا ہے...';

  @override
  String get profileAddFriend => 'دوست شامل کریں';

  @override
  String get profileConnectTitle => 'جڑیں';

  @override
  String get profileMessage => 'پیغام';

  @override
  String get profileSnapshot => 'پروفائل سنیپ شاٹ';

  @override
  String get profileLocationHidden => 'مقام چھپایا گیا';

  @override
  String get profileBioHidden => 'تعارف چھپایا گیا';

  @override
  String profileDailyGoal(Object minutes) {
    return 'روزانہ $minutes منٹ کا ہدف';
  }

  @override
  String get circleInviteTitle => 'Circle دعوت نامہ';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'شامل ہونے کے لیے سائن ان کریں';

  @override
  String get joiningCircle => 'شامل ہو رہے ہیں...';

  @override
  String get joinCircle => 'Circle میں شامل ہوں';

  @override
  String get circleJoinedAsPlayer => 'کھلاڑی کے طور پر شامل ہوئے';

  @override
  String get circleJoinedAsSpectator => 'ناظر کے طور پر شامل ہوئے';

  @override
  String get accept => 'قبول کریں';

  @override
  String get decline => 'انکار کریں';

  @override
  String get open => 'کھولیں';

  @override
  String get circleCountdownTitle => 'تیار ہو جائیں';

  @override
  String get circleCountdownSubtitle => 'Circle شروع ہو رہا ہے...';

  @override
  String get userFallbackName => 'صارف';

  @override
  String get micOff => 'مائیک بند';

  @override
  String get micOn => 'مائیک آن';

  @override
  String get roleHost => 'میزبان';

  @override
  String get roleSpectator => 'ناظر';

  @override
  String get tagHost => 'میزبان';

  @override
  String get tagYou => 'آپ';

  @override
  String get statusCorrect => 'درست';

  @override
  String get statusWrong => 'غلط';

  @override
  String get statusWaiting => 'منتظر';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'پوائنٹس';

  @override
  String get pointsLabel => 'پوائنٹس';

  @override
  String get statCorrect => 'درست';

  @override
  String get statAnswers => 'جوابات';

  @override
  String get statTotal => 'کل';

  @override
  String get statQuestions => 'سوالات';

  @override
  String get statAccuracy => 'درستگی';

  @override
  String get statRate => 'شرح';

  @override
  String get statRank => 'درجہ';

  @override
  String get statPosition => 'پوزیشن';

  @override
  String get statMode => 'موڈ';

  @override
  String get statType => 'قسم';

  @override
  String get next => 'اگلا';

  @override
  String get submit => 'جمع کرائیں';

  @override
  String get continueLabel => 'جاری رکھیں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get playAgain => 'دوبارہ کھیلیں';

  @override
  String get backToCourse => 'کورس پر واپس';

  @override
  String get resultsTitle => 'نتائج';

  @override
  String get shareLater => 'بعد میں شیئر کریں';

  @override
  String get delete => 'حذف کریں';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String minutesShort(Object minutes) {
    return '$minutes منٹ';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count منٹ';
  }

  @override
  String timeShortHours(Object count) {
    return '$count گھنٹے';
  }

  @override
  String timeShortDays(Object count) {
    return '$count دن';
  }

  @override
  String get timeJustNow => 'ابھی ابھی';

  @override
  String timeMinutesAgo(Object count) {
    return '$count منٹ پہلے';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count گھنٹے پہلے';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count دن پہلے';
  }

  @override
  String get liveQuizWaitingForHost => 'میزبان کا انتظار...';

  @override
  String get liveQuizJoinRequestSent => 'شامل ہونے کی درخواست بھیجی گئی';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'درخواست بھیجنے میں ناکامی: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'میزبان کنٹرول';

  @override
  String get liveQuizSpectatorModeTitle => 'ناظر موڈ';

  @override
  String get liveQuizHostControlsSubtitle =>
      'راؤنڈز خودکار طور پر آگے بڑھتے ہیں جب سب جواب دیں یا وقت ختم ہو';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'سوالات اور لیڈر بورڈ لائیو دیکھیں۔ آپ جواب نہیں دے سکتے';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'سوال $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'درخواست بھیجی گئی';

  @override
  String get liveQuizRequestToJoin => 'شامل ہونے کی درخواست';

  @override
  String get liveQuizSpectatorFooter =>
      'آپ لائیو دیکھ رہے ہیں۔ سوالات اور لیڈر بورڈ سے لطف اندوز ہوں';

  @override
  String get circleNotFound => 'Circle نہیں ملا';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'دوبارہ مقابلہ شروع کرنے میں ناکامی: $error';
  }

  @override
  String get resultsMatchTitle => 'میچ کے نتائج';

  @override
  String resultsNiceWork(Object name) {
    return 'اچھا کام، $name';
  }

  @override
  String get resultsPlaceFirst => 'پہلی جگہ';

  @override
  String get resultsPlaceSecond => 'دوسری جگہ';

  @override
  String get resultsPlaceThird => 'تیسری جگہ';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankویں جگہ';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players کھلاڑیوں میں سے';
  }

  @override
  String get resultsHighlightChampion => 'چیمپئن! آپ نے اس دائرے پر غلبہ پایا';

  @override
  String get resultsHighlightGreatAccuracy =>
      'زبردست درستگی - آپ چوٹی کے قریب ہیں!';

  @override
  String get resultsHighlightKeepGoing =>
      'جاری رکھیں - مستقل مزاجی نے رفتار کو شکست دی';

  @override
  String get resultsLeaderboardTitle => 'لیڈر بورڈ';

  @override
  String resultsPlayersCount(Object count) {
    return '$count کھلاڑی';
  }

  @override
  String get resultsBackToCircles => 'Circles پر واپس';

  @override
  String get resultsRematch => 'دوبارہ مقابلہ';

  @override
  String get resultsPlayAgain => 'دوبارہ کھیلیں';

  @override
  String get leaderboardGlobalTitle => 'عالمی درجہ بندی';

  @override
  String get leaderboardEmpty => 'ابھی تک کوئی درجہ بندی نہیں';

  @override
  String get aboutTitle => 'ایپ کے بارے میں';

  @override
  String aboutVersion(Object version) {
    return 'ورژن $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ایک گیمیفائیڈ زبان سیکھنے کا پلیٹ فارم ہے جو نئی زبانوں میں مہارت حاصل کرنا دلچسپ اور سماجی بناتا ہے۔ Circles میں مقابلہ کریں، اکیلے مشق کریں، اور اپنی پیشرفت کو ٹریک کریں۔';

  @override
  String get aboutTerms => 'استعمال کی شرائط';

  @override
  String get aboutPrivacy => 'رازداری کی پالیسی';

  @override
  String get aboutOpenSource => 'اوپن سورس لائسنس';

  @override
  String get addFriendTitle => 'دوست شامل کریں';

  @override
  String get addFriendFindByUsername => 'صارف نام سے تلاش کریں';

  @override
  String get addFriendUsernameHint => 'صارف نام درج کریں...';

  @override
  String get addFriendTip =>
      'تجویز: QR کوڈ + دوست ID سپورٹ بعد میں شامل کیا جائے گا';

  @override
  String get addFriendSending => 'بھیجا جا رہا ہے...';

  @override
  String get addFriendSendRequest => 'درخواست بھیجیں';

  @override
  String addFriendUserNotFound(Object username) {
    return 'صارف @$username نہیں ملا';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'عمل ناکام ہوا یا پہلے سے بھیجا گیا: $error';
  }

  @override
  String get friendsTitle => 'دوست';

  @override
  String get searchFriendsHint => 'دوست تلاش کریں...';

  @override
  String get somaLearnerSubtitle => 'Soma سیکھنے والا';

  @override
  String get friendRequestLabel => 'درخواست';

  @override
  String get friendRequestSentLabel => 'درخواست بھیجی گئی';

  @override
  String get friendIncomingRequestLabel => 'آنے والی درخواست';

  @override
  String get friendRequestsSection => 'درخواستیں';

  @override
  String get friendPendingSection => 'زیر التوا';

  @override
  String get friendAllSection => 'تمام دوست';

  @override
  String get friendsEmptyState =>
      'ابھی تک کوئی دوست نہیں۔ اپنا پہلا دوست شامل کریں!';

  @override
  String get friendsEmptyShort => 'ابھی تک کوئی دوست نہیں';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\" کے لیے کوئی مماثلت نہیں';
  }

  @override
  String get inboxTitle => 'ان باکس';

  @override
  String get searchChatsHint => 'چیٹس تلاش کریں...';

  @override
  String get inboxEmptyState =>
      'ابھی تک کوئی گفتگو نہیں۔ کسی دوست کے ساتھ چیٹ شروع کریں!';

  @override
  String get newMessageTitle => 'نیا پیغام';

  @override
  String get chatCallLater => 'آواز کال بعد میں (Circle voice اگلی ہے)';

  @override
  String errorWithDetails(Object error) {
    return 'خرابی: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name کو سلام کہیں!';
  }

  @override
  String get chatMessageHint => 'پیغام...';

  @override
  String get notificationsTitle => 'اطلاعات';

  @override
  String get notificationsTabAll => 'تمام';

  @override
  String get notificationsTabCourses => 'کورسز';

  @override
  String get notificationsTabSocial => 'سوشل';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'سسٹم';

  @override
  String get notificationsEmpty => 'کوئی اطلاعات نہیں';

  @override
  String get notificationsDeleted => 'اطلاع حذف کر دی گئی';

  @override
  String get notificationTitleFallback => 'اطلاع';

  @override
  String get notificationTypeCourse => 'کورس';

  @override
  String get notificationTypeSocial => 'سوشل';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'سسٹم';

  @override
  String get notificationsFriendAccepted => 'دوستی کی درخواست قبول کی گئی';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'دوستی کی درخواست قبول کرنے میں ناکامی: $error';
  }

  @override
  String get notificationsFriendDeclined => 'دوستی کی درخواست مسترد کی گئی';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'دوستی کی درخواست مسترد کرنے میں ناکامی: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle میں شامل ہونے میں ناکامی: $error';
  }

  @override
  String get notificationsOpening => 'کھل رہا ہے';

  @override
  String get notificationsOpened => 'کھولا گیا';

  @override
  String notificationsActionMessage(Object action) {
    return '$action اطلاع';
  }

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsSectionAccount => 'اکاؤنٹ';

  @override
  String get settingsEditProfile => 'پروفائل میں ترمیم کریں';

  @override
  String get settingsPrivacy => 'رازداری';

  @override
  String get settingsSecurity => 'سیکیورٹی';

  @override
  String get settingsSectionGameplay => 'گیم پلے';

  @override
  String get settingsShowTranslationLine => 'ترجمہ لائن دکھائیں';

  @override
  String get settingsShowReadingLine => 'پڑھنا دکھائیں (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'ڈیفالٹ فی سوال ٹائمر';

  @override
  String get settingsMatchDifficulty => 'میچ کی مشکل';

  @override
  String get settingsMatchDifficultyAdaptive => 'اڈاپٹیو';

  @override
  String get settingsSectionSoundFeel => 'آواز اور احساس';

  @override
  String get settingsMusic => 'موسیقی';

  @override
  String get settingsSoundEffects => 'آواز کے اثرات';

  @override
  String get settingsHaptics => 'ہیپٹکس';

  @override
  String get settingsSectionNotifications => 'اطلاعات';

  @override
  String get settingsPushNotifications => 'پش اطلاعات';

  @override
  String get settingsDailyReminder => 'روزانہ یاد دہانی';

  @override
  String get settingsSectionAppearance => 'شکل و صورت';

  @override
  String get settingsTheme => 'تھیم';

  @override
  String get settingsUiLanguage => 'UI زبان';

  @override
  String get settingsSectionAbout => 'کے بارے میں';

  @override
  String get settingsVersion => 'ورژن';

  @override
  String get settingsTermsPrivacy => 'شرائط اور رازداری';

  @override
  String get settingsSupport => 'سپورٹ';

  @override
  String get settingsLogout => 'لاگ آؤٹ';

  @override
  String get themeSystem => 'سسٹم';

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
  String get editProfileUpdated => 'پروفائل اپ ڈیٹ ہو گیا';

  @override
  String get editProfileTitle => 'پروفائل میں ترمیم کریں';

  @override
  String get editProfilePhotoLabel => 'پروفائل تصویر';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage کے ذریعے اوتار انتخاب جلد آ رہا ہے';

  @override
  String get editProfileChangePhoto => 'تبدیل کریں';

  @override
  String get editProfileAvatarUploadSoon => 'اوتار اپ لوڈ جلد آ رہا ہے';

  @override
  String get editProfileDisplayNameLabel => 'ڈسپلے نام';

  @override
  String get editProfileDisplayNameHint => 'آپ کا نام';

  @override
  String get editProfileDisplayNameRequired => 'اپنا نام درج کریں';

  @override
  String get editProfileDisplayNameTooShort => 'بہت چھوٹا';

  @override
  String get editProfileUsernameLabel => 'صارف نام';

  @override
  String get editProfileUsernameHint => 'احمد_سیکھنے_والا';

  @override
  String get editProfileUsernameRequired => 'صارف نام درج کریں';

  @override
  String get editProfileUsernameTooShort => 'کم از کم 3 حروف';

  @override
  String get editProfileUsernameInvalid => 'صرف حروف، اعداد، _';

  @override
  String get editProfileBioLabel => 'تعارف';

  @override
  String get editProfileBioHint => 'ایک مختصر تعارف...';

  @override
  String get editProfileBioTooLong => 'زیادہ سے زیادہ 120 حروف';

  @override
  String get editProfileLocationLabel => 'مقام';

  @override
  String get editProfileLocationHint => 'شہر / ملک';

  @override
  String get editProfileDailyGoalTitle => 'روزانہ ہدف';

  @override
  String get editProfileDailyGoalSubtitle =>
      'منتخب کریں کہ آپ روزانہ کتنے منٹ مطالعہ کرنا چاہتے ہیں';

  @override
  String get securityTitle => 'سیکیورٹی';

  @override
  String get securitySectionPassword => 'پاس ورڈ';

  @override
  String get securityChangePasswordTitle => 'پاس ورڈ تبدیل کریں';

  @override
  String get securityChangePasswordSubtitle =>
      'اپنا پاس ورڈ باقاعدگی سے اپ ڈیٹ کریں';

  @override
  String get securitySectionTwoFactor => 'دو عنصری تصدیق';

  @override
  String get securityEnable2faTitle => '2FA فعال کریں';

  @override
  String get securityEnable2faSubtitle => 'سائن ان کرتے وقت اضافی تحفظ';

  @override
  String get securitySectionAppLock => 'ایپ لاک';

  @override
  String get securityBiometricTitle => 'بائیو میٹرک ان لاک';

  @override
  String get securityBiometricSubtitle =>
      'SOMA کھولنے کے لیے FaceID/TouchID استعمال کریں';

  @override
  String get securityAppLockTitle => 'ایپ لاک';

  @override
  String get securityAppLockSubtitle => 'ایپ سے باہر جاتے وقت SOMA کو لاک کریں';

  @override
  String get securitySectionSessions => 'فعال سیشنز';

  @override
  String get securityNoSessions => 'کوئی فعال سیشن نہیں ملا';

  @override
  String get securityThisDevice => 'یہ آلہ';

  @override
  String get securityDevice => 'آلہ';

  @override
  String get securityActiveLabel => 'فعال';

  @override
  String get securitySignInToEnable2fa => '2FA فعال کرنے کے لیے سائن ان کریں';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA فعال کرنے میں ناکامی: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA غیر فعال کرنے میں ناکامی: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA سیٹ اپ';

  @override
  String get securitySecretKeyLabel => 'خفیہ کلید';

  @override
  String get securityCodeHint => '6 ہندسوں کا کوڈ';

  @override
  String get security2faEnabled => '2FA فعال ہے';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'کوڈ کی تصدیق میں ناکامی: $error';
  }

  @override
  String get securityVerifying => 'تصدیق ہو رہی ہے...';

  @override
  String get securityVerify => 'تصدیق کریں';

  @override
  String get securityCurrentPasswordHint => 'موجودہ پاس ورڈ';

  @override
  String get securityNewPasswordHint => 'نیا پاس ورڈ (کم از کم 8 حروف)';

  @override
  String get securityConfirmPasswordHint => 'نئے پاس ورڈ کی تصدیق کریں';

  @override
  String get securitySignInToChangePassword =>
      'پاس ورڈ تبدیل کرنے کے لیے سائن ان کریں';

  @override
  String get securityEnterCurrentPassword => 'اپنا موجودہ پاس ورڈ درج کریں';

  @override
  String get securityPasswordMinLength =>
      'نئے پاس ورڈ میں کم از کم 8 حروف ہونے چاہئیں';

  @override
  String get securityPasswordsDoNotMatch => 'پاس ورڈ مماثل نہیں ہیں';

  @override
  String get securityPasswordUpdated => 'پاس ورڈ اپ ڈیٹ ہو گیا';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'پاس ورڈ اپ ڈیٹ کرنے میں ناکامی: $error';
  }

  @override
  String get securityAutoLockAfter => 'اس کے بعد خودکار لاک';

  @override
  String get privacyTitle => 'رازداری';

  @override
  String get privacySectionVisibility => 'مرئیت';

  @override
  String get privacyProfileVisibilityTitle => 'پروفائل کی مرئیت';

  @override
  String get privacyVisibilityPublic => 'عوامی';

  @override
  String get privacyVisibilityFriends => 'دوست';

  @override
  String get privacyVisibilityPrivate => 'نجی';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'ہر کوئی آپ کا پروفائل دیکھ سکتا ہے';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'صرف دوست آپ کا پروفائل دیکھ سکتے ہیں';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'صرف آپ اپنا پروفائل دیکھ سکتے ہیں';

  @override
  String get privacySectionActivity => 'سرگرمی';

  @override
  String get privacyShowOnlineTitle => 'آن لائن سٹیٹس دکھائیں';

  @override
  String get privacyShowOnlineSubtitle =>
      'دوسروں کو دیکھنے دیں جب آپ آن لائن ہوں';

  @override
  String get privacyShowActivityTitle => 'سیکھنے کی سرگرمی دکھائیں';

  @override
  String get privacyShowActivitySubtitle =>
      'لگاتار، XP، اور حالیہ پیشرفت دکھائیں';

  @override
  String get privacySectionSocial => 'سوشل';

  @override
  String get privacyAllowRequestsTitle => 'دوستی کی درخواستوں کی اجازت دیں';

  @override
  String get privacyAllowRequestsSubtitle =>
      'لوگوں کو آپ کو دوستی کی درخواستیں بھیجنے دیں';

  @override
  String get privacyWhoCanDmTitle => 'کون DM بھیج سکتا ہے';

  @override
  String get privacyDmEveryone => 'ہر کوئی';

  @override
  String get privacyDmFriends => 'دوست';

  @override
  String get privacyDmNoOne => 'کوئی نہیں';

  @override
  String get privacyDmEveryoneSubtitle => 'کوئی بھی آپ کو پیغام بھیج سکتا ہے';

  @override
  String get privacyDmFriendsSubtitle => 'صرف دوست آپ کو پیغام بھیج سکتے ہیں';

  @override
  String get privacyDmNoOneSubtitle => 'کوئی بھی آپ کو پیغام نہیں بھیج سکتا';

  @override
  String get privacySectionBlockedUsers => 'مسدود صارفین';

  @override
  String get privacyBlockedUsersComingSoon =>
      'مسدود صارفین کا انتظام جلد آ رہا ہے';

  @override
  String get privacySectionDataControls => 'ڈیٹا کنٹرولز';

  @override
  String get privacyExportDataTitle => 'میرا ڈیٹا برآمد کریں';

  @override
  String get privacyExportDataSubtitle => 'اپنی سرگرمی اور کورسز ڈاؤن لوڈ کریں';

  @override
  String get privacyExportInfoTitle => 'ڈیٹا برآمد';

  @override
  String get privacyExportInfoBody =>
      'اگلا قدم: JSON/CSV برآمد بنائیں اور ای میل کریں یا مقامی طور پر ڈاؤن لوڈ کریں';

  @override
  String get privacyDeleteAccountTitle => 'اکاؤنٹ حذف کریں';

  @override
  String get privacyDeleteAccountSubtitle =>
      'یہ آپ کا اکاؤنٹ اور ڈیٹا مستقل طور پر حذف کر دے گا';

  @override
  String get privacyDeleteConfirmTitle => 'اکاؤنٹ حذف کریں؟';

  @override
  String get privacyDeleteConfirmBody =>
      'یہ عمل واپس نہیں ہو سکتا۔ آپ کا پروفائل، کورسز، دوست، اور پیغامات حذف ہو جائیں گے';

  @override
  String get privacyDeleteComingSoon =>
      'حذف کرنا Supabase سے بعد میں منسلک ہوگا';

  @override
  String get soloLabel => 'سولو';

  @override
  String get soloResultsCompletedTitle => 'سولو سیشن مکمل';

  @override
  String get soloResultsFeedbackElite =>
      'اعلیٰ کارکردگی - اپنا سلسلہ برقرار رکھیں';

  @override
  String get soloResultsFeedbackStrong =>
      'مضبوط کام - آپ تیزی سے بہتر ہو رہے ہیں';

  @override
  String get soloResultsFeedbackProgress =>
      'اچھی پیشرفت - غلطیوں کا جائزہ لیں اور دوبارہ کوشش کریں';

  @override
  String get soloResultsFeedbackTryAgain =>
      'کوئی دباؤ نہیں - کم سوالات کے ساتھ دوبارہ کوشش کریں اور توجہ مرکوز کریں';

  @override
  String get soloResultsPerfectScore =>
      'کامل سکور! جائزہ لینے کے لیے کوئی غلطیاں نہیں';

  @override
  String get soloResultsReviewPrompt =>
      'تیزی سے سیکھنے کے لیے غلطیوں کا جائزہ لیں۔ آپ کے غلط جوابات نیچے ہیں';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'غلطیوں کا جائزہ لیں ($count)';
  }

  @override
  String get authNotSignedIn => 'آپ سائن ان نہیں ہیں';

  @override
  String get genericUser => 'صارف';

  @override
  String get loading => 'لوڈ ہو رہا ہے...';

  @override
  String get edit => 'ترمیم کریں';

  @override
  String get send => 'بھیجیں';

  @override
  String get join => 'شامل ہوں';

  @override
  String get leave => 'چھوڑیں';

  @override
  String get ready => 'تیار';

  @override
  String get levelBeginner => 'ابتدائی';

  @override
  String get levelIntermediate => 'درمیانی';

  @override
  String get levelAdvanced => 'اعلیٰ';

  @override
  String questionsShort(Object count) {
    return '$count سوالات';
  }

  @override
  String secondsShort(Object count) {
    return '$count سیکنڈ';
  }

  @override
  String get circlesAllCourses => 'تمام کورسز';

  @override
  String get circlesAllModes => 'تمام موڈز';

  @override
  String get circlesAllLevels => 'تمام سطحیں';

  @override
  String get circlesAddNewCourse => 'نیا کورس شامل کریں';

  @override
  String get circlesCoursesTitle => 'کورسز';

  @override
  String get circlesModeTitle => 'موڈ';

  @override
  String get circlesLevelTitle => 'سطح';

  @override
  String get circlesNoActiveForFilters =>
      'ان فلٹرز کے لیے کوئی فعال Circles نہیں';

  @override
  String get circlesUnknownRoom => 'نامعلوم کمرہ';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle بنائیں';

  @override
  String get circlesCircleName => 'Circle کا نام';

  @override
  String get circlesEnterName => 'نام درج کریں';

  @override
  String get circlesLanguages => 'زبانیں';

  @override
  String get circlesRoomSetup => 'کمرے کا سیٹ اپ';

  @override
  String get circlesPlayers => 'کھلاڑی';

  @override
  String get circlesEmptySlot => 'خالی جگہ';

  @override
  String get circlesPlayersRange => '1-5 کھلاڑی';

  @override
  String get circlesQuestions => 'سوالات';

  @override
  String get circlesQuestionsSubtitle => 'سوالات کی تعداد';

  @override
  String get circlesTimePerQuestion => 'فی سوال وقت';

  @override
  String get circlesSecondsPerQuestion => 'سیکنڈ فی سوال';

  @override
  String get circlesAdvanced => 'اعلیٰ درجہ';

  @override
  String get circlesAllowSpectators => 'ناظرین کی اجازت دیں';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'دوسروں کو بغیر کھیلے دیکھنے دیں';

  @override
  String get circlesLiveVoiceChat => 'لائیو آواز چیٹ';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'میچز کے دوران آواز کی بات چیت فعال کریں';

  @override
  String get circlesLiveTextChat => 'لائیو ٹیکسٹ چیٹ';

  @override
  String get circlesLiveTextChatSubtitle => 'میچز کے دوران چیٹ فعال کریں';

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
  String get circlesCreatedSuccess => 'Circle بنایا گیا';

  @override
  String circlesCreateError(Object error) {
    return 'Circle بنانے میں ناکامی: $error';
  }

  @override
  String get circlesHostTip =>
      'تجویز: آپ بنانے کے بعد دوستوں کو مدعو کر سکتے ہیں';

  @override
  String circlesJoinError(Object error) {
    return 'Circle میں شامل ہونے میں ناکامی: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle لابی';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'کوڈ: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'میچ کی ترتیبات';

  @override
  String circlesLevelWithValue(Object level) {
    return 'سطح $level';
  }

  @override
  String get circlesDifficulty => 'مشکل';

  @override
  String get circlesPerQuestionShort => 'فی سوال';

  @override
  String get circlesInvite => 'مدعو کریں';

  @override
  String get circlesCopyId => 'ID کاپی کریں';

  @override
  String get circlesCopiedId => 'ID کاپی ہو گئی';

  @override
  String get circlesMatchInProgress => 'میچ جاری ہے';

  @override
  String get circlesSpectatorQueuedBody =>
      'میچ جاری ہے۔ آپ بطور ناظر شامل ہوں گے';

  @override
  String get circlesHostStartWhenReady => 'میزبان شروع کرے گا جب سب تیار ہوں';

  @override
  String get circlesSpectators => 'ناظرین';

  @override
  String get circlesSpectator => 'ناظر';

  @override
  String get circlesSpectatorCanWatch => 'ناظرین لائیو دیکھ سکتے ہیں';

  @override
  String get circlesJoinRequests => 'شامل ہونے کی درخواستیں';

  @override
  String get circlesAcceptSpectatorsHint =>
      'میچ شروع کرنے سے پہلے ناظرین کو قبول کریں';

  @override
  String get circlesStartGame => 'کھیل شروع کریں';

  @override
  String get circlesWaitingForPlayers => 'کھلاڑیوں کا انتظار';

  @override
  String get circlesLeaveCircle => 'Circle چھوڑیں';

  @override
  String get circlesRequestSent => 'درخواست بھیجی گئی';

  @override
  String get circlesRequestToJoin => 'شامل ہونے کی درخواست';

  @override
  String get circlesWatchLive => 'لائیو دیکھیں';

  @override
  String get circlesPlayerTip =>
      'تیار ہونے پر تیار دبائیں۔ میزبان میچ شروع کرے گا';

  @override
  String get circlesSpectatorTip =>
      'آپ دیکھ رہے ہیں۔ میزبان کے شروع کرنے پر لائیو دیکھیں';

  @override
  String get circlesHostControls => 'میزبان کنٹرولز';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'میزبان منتقل کرنے میں ناکامی: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle ختم کرنے میں ناکامی: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'صارف @$username نہیں ملا';
  }

  @override
  String get circlesInvalidUser => 'غلط صارف';

  @override
  String get circlesCantInviteSelf => 'آپ خود کو مدعو نہیں کر سکتے';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username پہلے سے Circle میں ہے';
  }

  @override
  String get circlesDefaultHost => 'میزبان';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'صارف نام سے مدعو کریں';

  @override
  String circlesInviteSent(Object username) {
    return 'دعوت نامہ @$username کو بھیجا گیا';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'دعوت نامہ بھیجنے میں ناکامی: $error';
  }

  @override
  String get circlesJoinRequestSent => 'شامل ہونے کی درخواست بھیجی گئی';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'درخواست بھیجنے میں ناکامی: $error';
  }

  @override
  String get circlesFull => 'Circle بھر گیا';

  @override
  String get circlesSpectatorAdded => 'ناظر شامل کیا گیا';

  @override
  String circlesApproveFailed(Object error) {
    return 'درخواست منظور کرنے میں ناکامی: $error';
  }

  @override
  String get circlesRequestDeclined => 'درخواست مسترد کر دی گئی';

  @override
  String circlesDeclineFailed(Object error) {
    return 'درخواست مسترد کرنے میں ناکامی: $error';
  }

  @override
  String get circlesParticipant => 'شریک';

  @override
  String get circlesLeavePromptTitle => 'Circle چھوڑیں؟';

  @override
  String get circlesLeavePromptTransfer =>
      'براہ کرم چھوڑنے سے پہلے میزبان منتقل کریں';

  @override
  String get circlesLeavePromptEndOnly => 'Circle ختم کریں اور چھوڑیں';

  @override
  String get circlesTransferHost => 'میزبان منتقل کریں';

  @override
  String get circlesEndCircle => 'Circle ختم کریں';

  @override
  String get circlesTransferHostTitle => 'میزبان منتقل کریں';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
