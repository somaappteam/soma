// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'ਸਿੱਖੋ। ਮੁਕਾਬਲਾ ਕਰੋ। ਮਾਹਰ ਬਣੋ।';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'ਸਾਈਨ ਅੱਪ';

  @override
  String get signIn => 'ਸਾਈਨ ਇਨ';

  @override
  String get skipForNow => 'ਹੁਣ ਲਈ ਛੱਡੋ';

  @override
  String get authFillAllFields => 'ਕਿਰਪਾ ਕਰਕੇ ਸਾਰੇ ਖੇਤਰ ਭਰੋ';

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
    return 'ਗਲਤੀ: $error';
  }

  @override
  String get authEmail => 'ਈਮੇਲ';

  @override
  String get authPassword => 'ਪਾਸਵਰਡ';

  @override
  String get authUsername => 'ਯੂਜ਼ਰਨੇਮ';

  @override
  String get authContinue => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get authSigningIn => 'ਸਾਈਨ ਇਨ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get authCreateAccount => 'ਖਾਤਾ ਬਣਾਓ';

  @override
  String get authCreating => 'ਬਣਾਇਆ ਜਾ ਰਿਹਾ ਹੈ...';

  @override
  String get authNeedAccount => 'ਖਾਤਾ ਨਹੀਂ ਹੈ? ';

  @override
  String get authHaveAccount => 'ਪਹਿਲਾਂ ਹੀ ਖਾਤਾ ਹੈ? ';

  @override
  String get dialogAuthRequiredTitle => 'Circles ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get dialogAuthRequiredBody =>
      'Circles ਮਲਟੀਪਲੇਅਰ ਕਮਰੇ ਹਨ। ਲਾਈਵ ਮੈਚਾਂ ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ, ਦੋਸਤਾਂ ਨੂੰ ਸੱਦਾ ਦੇਣ ਅਤੇ ਤਰੱਕੀ ਨੂੰ ਸੁਰੱਖਿਅਤ ਕਰਨ ਲਈ ਖਾਤਾ ਬਣਾਓ।';

  @override
  String get notNow => 'ਹੁਣ ਨਹੀਂ';

  @override
  String get navHome => 'ਹੋਮ';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get removeCourseTitle => 'ਕੋਰਸ ਹਟਾਉਣਾ ਹੈ?';

  @override
  String removeCourseBody(Object course) {
    return '$course ਤੁਹਾਡੀ ਸੂਚੀ ਵਿੱਚੋਂ ਹਟਾ ਦਿੱਤਾ ਜਾਵੇਗਾ';
  }

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

  @override
  String get remove => 'ਹਟਾਓ';

  @override
  String welcomeBack(Object name) {
    return 'ਵਾਪਸੀ \'ਤੇ ਸੁਆਗਤ ਹੈ, $name!';
  }

  @override
  String get editCourses => 'ਕੋਰਸ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get done => 'ਹੋ ਗਿਆ';

  @override
  String get noCoursesToEdit => 'ਸੰਪਾਦਿਤ ਕਰਨ ਲਈ ਕੋਈ ਕੋਰਸ ਨਹੀਂ';

  @override
  String get addCourse => 'ਕੋਰਸ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get unknown => 'ਅਣਜਾਣ';

  @override
  String get iSpeak => 'ਮੈਂ ਬੋਲਦਾ/ਬੋਲਦੀ ਹਾਂ';

  @override
  String get iWantToLearn => 'ਮੈਂ ਸਿੱਖਣਾ ਚਾਹੁੰਦਾ/ਚਾਹੁੰਦੀ ਹਾਂ';

  @override
  String get chooseYourLanguage => 'ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get chooseLearningLanguage => 'ਸਿੱਖਣ ਵਾਲੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get chooseTwoDifferentLanguages =>
      'ਕਿਰਪਾ ਕਰਕੇ ਦੋ ਵੱਖਰੀਆਂ ਭਾਸ਼ਾਵਾਂ ਚੁਣੋ';

  @override
  String get createCourse => 'ਕੋਰਸ ਬਣਾਓ';

  @override
  String get soloCourseTitle => 'ਸੋਲੋ ਕੋਰਸ';

  @override
  String get searchLanguage => 'ਭਾਸ਼ਾ ਖੋਜੋ';

  @override
  String get noMatches => 'ਕੋਈ ਮੇਲ ਨਹੀਂ';

  @override
  String get chooseCourseType => 'ਕੋਰਸ ਦੀ ਕਿਸਮ ਚੁਣੋ';

  @override
  String get soloStudyDescription =>
      'Circles ਵਰਗੇ ਹੀ ਕਵਿਜ਼ਾਂ ਨਾਲ ਇਕੱਲੇ ਅਭਿਆਸ ਕਰੋ - ਪਰ ਬਿਨਾਂ ਕਮਰੇ, ਚੈਟ, ਦਰਸ਼ਕ ਜਾਂ ਹੋਸਟ ਵਿਕਲਪਾਂ ਦੇ';

  @override
  String get soloModeVocabulary => 'ਸ਼ਬਦਾਵਲੀ';

  @override
  String get soloModeSentences => 'ਵਾਕ';

  @override
  String get soloModeReview => 'ਸਮੀਖਿਆ';

  @override
  String get soloModeVocabularySubtitle => 'ਬਹੁ-ਵਿਕਲਪੀ, ਅਰਥ, ਸਮਾਨਾਰਥੀ, ਵਰਤੋਂ';

  @override
  String get soloModeSentencesSubtitle => 'ਖਾਲੀ ਥਾਂ ਭਰੋ + ਅਨੁਵਾਦ + ਪੜ੍ਹਨਾ';

  @override
  String get soloModeReviewDescription =>
      'ਜੋ ਸਿੱਖਿਆ ਹੈ ਉਸਦਾ ਅਭਿਆਸ ਕਰੋ: ਕਮਜ਼ੋਰ ਸ਼ਬਦ, ਤਾਜ਼ਾ ਗਲਤੀਆਂ ਅਤੇ ਦੁਹਰਾਓ';

  @override
  String get startReview => 'ਸਮੀਖਿਆ ਸ਼ੁਰੂ ਕਰੋ';

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
    return '$mode ਸੈੱਟਅੱਪ';
  }

  @override
  String get difficulty => 'ਮੁਸ਼ਕਲ ਪੱਧਰ';

  @override
  String get numberOfQuestions => 'ਸਵਾਲਾਂ ਦੀ ਗਿਣਤੀ';

  @override
  String get timerPerQuestion => 'ਪ੍ਰਤੀ ਸਵਾਲ ਟਾਈਮਰ';

  @override
  String get noTimer => 'ਕੋਈ ਟਾਈਮਰ ਨਹੀਂ';

  @override
  String get start => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get profileTitle => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get profileSignInToMessage => 'ਸੁਨੇਹਾ ਭੇਜਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get profileThatsYourProfile => 'ਇਹ ਤੁਹਾਡਾ ਪ੍ਰੋਫਾਈਲ ਹੈ';

  @override
  String get profileSignInToAddFriends => 'ਦੋਸਤੋ ਨੂੰ ਸ਼ਾਮਲ ਕਰਨ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get profileCantAddYourself => 'ਤੁਸੀਂ ਆਪਣੇ ਆਪ ਨੂੰ ਸ਼ਾਮਲ ਨਹੀਂ ਕਰ ਸਕਦੇ';

  @override
  String profileRequestSent(Object username) {
    return '@$username ਨੂੰ ਬੇਨਤੀ ਭੇਜੀ ਗਈ';
  }

  @override
  String get profileRequestFailed => 'ਬੇਨਤੀ ਭੇਜਣ ਵਿੱਚ ਅਸਫਲ';

  @override
  String get profileDefaultDisplayName => 'ਨਵਾਂ ਯੂਜ਼ਰ';

  @override
  String get profileDefaultBio => 'ਸਿੱਖਣ ਲਈ ਤਿਆਰ!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'ਮਹਿਮਾਨ';

  @override
  String get guestUsername => 'ਮਹਿਮਾਨ';

  @override
  String get guestSessionLabel => 'ਮਹਿਮਾਨ ਸੈਸ਼ਨ';

  @override
  String get unlockFullProfile => 'ਪੂਰਾ ਪ੍ਰੋਫਾਈਲ ਅਨਲੌਕ ਕਰੋ';

  @override
  String get guestBenefitSync => 'ਸਾਰੇ ਡਿਵਾਈਸਾਂ \'ਤੇ ਤਰੱਕੀ ਸਿੰਕ ਕਰੋ';

  @override
  String get guestBenefitCircles => 'Circles ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ ਅਤੇ ਲਾਈਵ ਖੇਡੋ';

  @override
  String get guestBenefitNotifications =>
      'ਸੂਚਨਾਵਾਂ ਅਤੇ ਦੋਸਤੀ ਬੇਨਤੀਆਂ ਪ੍ਰਾਪਤ ਕਰੋ';

  @override
  String get progressStaysOnDevice =>
      'ਤਰੱਕੀ ਇਸ ਡਿਵਾਈਸ \'ਤੇ ਰਹਿੰਦੀ ਹੈ ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਸਾਈਨ ਇਨ ਨਹੀਂ ਕਰਦੇ';

  @override
  String profileGoalLabel(Object minutes) {
    return 'ਟੀਚਾ: $minutes ਮਿੰਟ';
  }

  @override
  String get profileXpProgress => 'XP ਤਰੱਕੀ';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'ਜਿੱਤਾਂ';

  @override
  String get profileStreak => 'ਲਗਾਤਾਰ';

  @override
  String get profileFriendsTitle => 'ਦੋਸਤ';

  @override
  String get profileViewAll => 'ਸਾਰੇ ਵੇਖੋ';

  @override
  String get profileAchievementsTitle => 'ਪ੍ਰਾਪਤੀਆਂ';

  @override
  String get profileNoAchievements => 'ਅਜੇ ਕੋਈ ਪ੍ਰਾਪਤੀ ਨਹੀਂ';

  @override
  String get profileRequested => 'ਬੇਨਤੀ ਕੀਤੀ';

  @override
  String get profileSending => 'ਭੇਜਿਆ ਜਾ ਰਿਹਾ ਹੈ...';

  @override
  String get profileAddFriend => 'ਦੋਸਤ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get profileConnectTitle => 'ਜੁੜੋ';

  @override
  String get profileMessage => 'ਸੁਨੇਹਾ';

  @override
  String get profileSnapshot => 'ਪ੍ਰੋਫਾਈਲ ਸਨੈਪਸ਼ਾਟ';

  @override
  String get profileLocationHidden => 'ਟਿਕਾਣਾ ਲੁਕਿਆ ਹੋਇਆ';

  @override
  String get profileBioHidden => 'ਬਾਇਓ ਲੁਕਿਆ ਹੋਇਆ';

  @override
  String profileDailyGoal(Object minutes) {
    return 'ਰੋਜ਼ਾਨਾ ਟੀਚਾ $minutes ਮਿੰਟ';
  }

  @override
  String get circleInviteTitle => 'Circle ਸੱਦਾ';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'ਸ਼ਾਮਲ ਹੋਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get joiningCircle => 'ਸ਼ਾਮਲ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get joinCircle => 'Circle ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get circleJoinedAsPlayer => 'ਖਿਡਾਰੀ ਵਜੋਂ ਸ਼ਾਮਲ ਹੋਏ';

  @override
  String get circleJoinedAsSpectator => 'ਦਰਸ਼ਕ ਵਜੋਂ ਸ਼ਾਮਲ ਹੋਏ';

  @override
  String get accept => 'ਸਵੀਕਾਰ ਕਰੋ';

  @override
  String get decline => 'ਅਸਵੀਕਾਰ ਕਰੋ';

  @override
  String get open => 'ਖੋਲ੍ਹੋ';

  @override
  String get circleCountdownTitle => 'ਤਿਆਰ ਰਹੋ';

  @override
  String get circleCountdownSubtitle => 'Circle ਸ਼ੁਰੂ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get userFallbackName => 'ਯੂਜ਼ਰ';

  @override
  String get micOff => 'ਮਾਈਕ ਬੰਦ';

  @override
  String get micOn => 'ਮਾਈਕ ਚਾਲੂ';

  @override
  String get roleHost => 'ਹੋਸਟ';

  @override
  String get roleSpectator => 'ਦਰਸ਼ਕ';

  @override
  String get tagHost => 'ਹੋਸਟ';

  @override
  String get tagYou => 'ਤੁਸੀਂ';

  @override
  String get statusCorrect => 'ਸਹੀ';

  @override
  String get statusWrong => 'ਗਲਤ';

  @override
  String get statusWaiting => 'ਉਡੀਕ';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'ਅੰਕ';

  @override
  String get pointsLabel => 'ਅੰਕ';

  @override
  String get statCorrect => 'ਸਹੀ';

  @override
  String get statAnswers => 'ਜਵਾਬ';

  @override
  String get statTotal => 'ਕੁੱਲ';

  @override
  String get statQuestions => 'ਸਵਾਲ';

  @override
  String get statAccuracy => 'ਸ਼ੁੱਧਤਾ';

  @override
  String get statRate => 'ਦਰ';

  @override
  String get statRank => 'ਰੈਂਕ';

  @override
  String get statPosition => 'ਸਥਿਤੀ';

  @override
  String get statMode => 'ਮੋਡ';

  @override
  String get statType => 'ਕਿਸਮ';

  @override
  String get next => 'ਅਗਲਾ';

  @override
  String get submit => 'ਜਮ੍ਹਾਂ ਕਰੋ';

  @override
  String get continueLabel => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get save => 'ਸੁਰੱਖਿਅਤ ਕਰੋ';

  @override
  String get playAgain => 'ਦੁਬਾਰਾ ਖੇਡੋ';

  @override
  String get backToCourse => 'ਕੋਰਸ \'ਤੇ ਵਾਪਸ';

  @override
  String get resultsTitle => 'ਨਤੀਜੇ';

  @override
  String get shareLater => 'ਬਾਅਦ ਵਿੱਚ ਸਾਂਝਾ ਕਰੋ';

  @override
  String get delete => 'ਹਟਾਓ';

  @override
  String get ok => 'ਠੀਕ ਹੈ';

  @override
  String minutesShort(Object minutes) {
    return '$minutes ਮਿੰਟ';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count ਮਿੰਟ';
  }

  @override
  String timeShortHours(Object count) {
    return '$count ਘੰਟੇ';
  }

  @override
  String timeShortDays(Object count) {
    return '$count ਦਿਨ';
  }

  @override
  String get timeJustNow => 'ਹੁਣੇ';

  @override
  String timeMinutesAgo(Object count) {
    return '$count ਮਿੰਟ ਪਹਿਲਾਂ';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count ਘੰਟੇ ਪਹਿਲਾਂ';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count ਦਿਨ ਪਹਿਲਾਂ';
  }

  @override
  String get liveQuizWaitingForHost => 'ਹੋਸਟ ਦੀ ਉਡੀਕ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ...';

  @override
  String get liveQuizJoinRequestSent => 'ਸ਼ਾਮਲ ਹੋਣ ਦੀ ਬੇਨਤੀ ਭੇਜੀ ਗਈ';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'ਬੇਨਤੀ ਭੇਜਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'ਹੋਸਟ ਕੰਟਰੋਲ';

  @override
  String get liveQuizSpectatorModeTitle => 'ਦਰਸ਼ਕ ਮੋਡ';

  @override
  String get liveQuizHostControlsSubtitle =>
      'ਜਦੋਂ ਹਰ ਕੋਈ ਜਵਾਬ ਦਿੰਦਾ ਹੈ ਜਾਂ ਸਮਾਂ ਸਮਾਪਤ ਹੁੰਦਾ ਹੈ ਤਾਂ ਰਾਊਂਡ ਆਪਣੇ ਆਪ ਅੱਗੇ ਵਧਦੇ ਹਨ';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'ਸਵਾਲਾਂ ਅਤੇ ਲੀਡਰਬੋਰਡਾਂ ਨੂੰ ਲਾਈਵ ਦੇਖੋ। ਤੁਸੀਂ ਜਵਾਬ ਨਹੀਂ ਦੇ ਸਕਦੇ';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'ਸਵਾਲ $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'ਬੇਨਤੀ ਭੇਜੀ ਗਈ';

  @override
  String get liveQuizRequestToJoin => 'ਸ਼ਾਮਲ ਹੋਣ ਲਈ ਬੇਨਤੀ';

  @override
  String get liveQuizSpectatorFooter =>
      'ਤੁਸੀਂ ਲਾਈਵ ਦੇਖ ਰਹੇ ਹੋ। ਸਵਾਲਾਂ ਅਤੇ ਲੀਡਰਬੋਰਡਾਂ ਦਾ ਅਨੰਦ ਲਓ';

  @override
  String get circleNotFound => 'Circle ਨਹੀਂ ਮਿਲਿਆ';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'ਰੀਮੈਚ ਸ਼ੁਰੂ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get resultsMatchTitle => 'ਮੈਚ ਦੇ ਨਤੀਜੇ';

  @override
  String resultsNiceWork(Object name) {
    return 'ਵਧੀਆ ਕੰਮ, $name';
  }

  @override
  String get resultsPlaceFirst => 'ਪਹਿਲਾ ਸਥਾਨ';

  @override
  String get resultsPlaceSecond => 'ਦੂਜਾ ਸਥਾਨ';

  @override
  String get resultsPlaceThird => 'ਤੀਜਾ ਸਥਾਨ';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankਵਾਂ ਸਥਾਨ';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players ਖਿਡਾਰੀਆਂ ਵਿੱਚੋਂ';
  }

  @override
  String get resultsHighlightChampion =>
      'ਚੈਂਪੀਅਨ! ਤੁਸੀਂ ਇਸ ਰਾਊਂਡ ਵਿੱਚ ਸ਼ਾਨਦਾਰ ਪ੍ਰਦਰਸ਼ਨ ਕੀਤਾ';

  @override
  String get resultsHighlightGreatAccuracy => 'ਸ਼ਾਨਦਾਰ ਸ਼ੁੱਧਤਾ - ਕਾਫੀ ਸਹੀ!';

  @override
  String get resultsHighlightKeepGoing =>
      'ਜਾਰੀ ਰੱਖੋ - ਸਥਿਰਤਾ ਗਤੀ ਨੂੰ ਹਰਾਉਂਦੀ ਹੈ';

  @override
  String get resultsLeaderboardTitle => 'ਲੀਡਰਬੋਰਡ';

  @override
  String resultsPlayersCount(Object count) {
    return '$count ਖਿਡਾਰੀ';
  }

  @override
  String get resultsBackToCircles => 'Circles \'ਤੇ ਵਾਪਸ';

  @override
  String get resultsRematch => 'ਰੀਮੈਚ';

  @override
  String get resultsPlayAgain => 'ਦੁਬਾਰਾ ਖੇਡੋ';

  @override
  String get leaderboardGlobalTitle => 'ਗਲੋਬਲ ਲੀਡਰਬੋਰਡ';

  @override
  String get leaderboardEmpty => 'ਅਜੇ ਕੋਈ ਦਰਜਾਬੰਦੀ ਨਹੀਂ';

  @override
  String get aboutTitle => 'ਬਾਰੇ';

  @override
  String aboutVersion(Object version) {
    return 'ਵਰਜਨ $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ਇੱਕ ਖੇਡ-ਅਧਾਰਿਤ ਭਾਸ਼ਾ ਸਿੱਖਣ ਪਲੇਟਫਾਰਮ ਹੈ ਜੋ ਨਵੀਆਂ ਭਾਸ਼ਾਵਾਂ ਵਿੱਚ ਮੁਹਾਰਤ ਹਾਸਲ ਕਰਨ ਨੂੰ ਮਜ਼ੇਦਾਰ ਅਤੇ ਸਮਾਜਿਕ ਬਣਾਉਂਦਾ ਹੈ। Circles ਵਿੱਚ ਮੁਕਾਬਲਾ ਕਰੋ, ਇਕੱਲੇ ਅਭਿਆਸ ਕਰੋ ਅਤੇ ਆਪਣੀ ਤਰੱਕੀ ਨੂੰ ਟਰੈਕ ਕਰੋ।';

  @override
  String get aboutTerms => 'ਵਰਤੋਂ ਦੀਆਂ ਸ਼ਰਤਾਂ';

  @override
  String get aboutPrivacy => 'ਪਰਦੇਦਾਰੀ ਨੀਤੀ';

  @override
  String get aboutOpenSource => 'ਓਪਨ ਸੋਰਸ ਲਾਇਸੰਸ';

  @override
  String get addFriendTitle => 'ਦੋਸਤ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get addFriendFindByUsername => 'ਯੂਜ਼ਰਨੇਮ ਦੁਆਰਾ ਲੱਭੋ';

  @override
  String get addFriendUsernameHint => 'ਯੂਜ਼ਰਨੇਮ ਭਰੋ...';

  @override
  String get addFriendTip => 'ਸੁਝਾਅ: QR ਕੋਡ + ਦੋਸਤ ID ਸਹਾਇਤਾ ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get addFriendSending => 'ਭੇਜਿਆ ਜਾ ਰਿਹਾ ਹੈ...';

  @override
  String get addFriendSendRequest => 'ਬੇਨਤੀ ਭੇਜੋ';

  @override
  String addFriendUserNotFound(Object username) {
    return 'ਯੂਜ਼ਰ @$username ਨਹੀਂ ਮਿਲਿਆ';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'ਕਾਰਵਾਈ ਅਸਫਲ ਰਹੀ ਜਾਂ ਪਹਿਲਾਂ ਹੀ ਭੇਜੀ ਗਈ: $error';
  }

  @override
  String get friendsTitle => 'ਦੋਸਤ';

  @override
  String get searchFriendsHint => 'ਦੋਸਤਾਂ ਨੂੰ ਲੱਭੋ...';

  @override
  String get somaLearnerSubtitle => 'Soma ਸਿਖਿਆਰਥੀ';

  @override
  String get friendRequestLabel => 'ਬੇਨਤੀ';

  @override
  String get friendRequestSentLabel => 'ਬੇਨਤੀ ਭੇਜੀ ਗਈ';

  @override
  String get friendIncomingRequestLabel => 'ਆ ਰਹੀ ਬੇਨਤੀ';

  @override
  String get friendRequestsSection => 'ਬੇਨਤੀਆਂ';

  @override
  String get friendPendingSection => 'ਲੰਬਿਤ';

  @override
  String get friendAllSection => 'ਸਾਰੇ ਦੋਸਤ';

  @override
  String get friendsEmptyState =>
      'ਅਜੇ ਕੋਈ ਦੋਸਤ ਨਹੀਂ। ਆਪਣਾ ਪਹਿਲਾ ਦੋਸਤ ਸ਼ਾਮਲ ਕਰੋ!';

  @override
  String get friendsEmptyShort => 'ਅਜੇ ਕੋਈ ਦੋਸਤ ਨਹੀਂ';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\" ਲਈ ਕੋਈ ਮੇਲ ਨਹੀਂ ਮਿਲਿਆ';
  }

  @override
  String get inboxTitle => 'ਇਨਬਾਕਸ';

  @override
  String get searchChatsHint => 'ਚੈਟ ਖੋਜੋ...';

  @override
  String get inboxEmptyState =>
      'ਅਜੇ ਕੋਈ ਚੈਟ ਨਹੀਂ। ਕਿਸੇ ਦੋਸਤ ਨਾਲ ਗੱਲਬਾਤ ਸ਼ੁਰੂ ਕਰੋ!';

  @override
  String get newMessageTitle => 'ਨਵਾਂ ਸੁਨੇਹਾ';

  @override
  String get chatCallLater => 'ਵਾਇਸ ਕਾਲ ਜਲਦੀ (ਅਗਲੇ Circle ਦੀ ਆਵਾਜ਼)';

  @override
  String errorWithDetails(Object error) {
    return 'ਗਲਤੀ: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name ਨੂੰ ਹੈਲੋ ਕਹੋ!';
  }

  @override
  String get chatMessageHint => 'ਸੁਨੇਹਾ...';

  @override
  String get notificationsTitle => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get notificationsTabAll => 'ਸਭ';

  @override
  String get notificationsTabCourses => 'ਕੋਰਸ';

  @override
  String get notificationsTabSocial => 'ਸੋਸ਼ਲ';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'ਸਿਸਟਮ';

  @override
  String get notificationsEmpty => 'ਕੋਈ ਸੂਚਨਾਵਾਂ ਨਹੀਂ';

  @override
  String get notificationsDeleted => 'ਸੂਚਨਾ ਹਟਾਈ ਗਈ';

  @override
  String get notificationTitleFallback => 'ਸੂਚਨਾ';

  @override
  String get notificationTypeCourse => 'ਕੋਰਸ';

  @override
  String get notificationTypeSocial => 'ਸੋਸ਼ਲ';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'ਸਿਸਟਮ';

  @override
  String get notificationsFriendAccepted => 'ਦੋਸਤੀ ਦੀ ਬੇਨਤੀ ਸਵੀਕਾਰ ਕੀਤੀ ਗਈ';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'ਦੋਸਤੀ ਦੀ ਬੇਨਤੀ ਸਵੀਕਾਰ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get notificationsFriendDeclined => 'ਦੋਸਤੀ ਦੀ ਬੇਨਤੀ ਅਸਵੀਕਾਰ ਕੀਤੀ ਗਈ';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'ਦੋਸਤੀ ਦੀ ਬੇਨਤੀ ਅਸਵੀਕਾਰ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get notificationsOpening => 'ਖੁੱਲ੍ਹ ਰਿਹਾ ਹੈ';

  @override
  String get notificationsOpened => 'ਖੁੱਲ੍ਹ ਗਿਆ';

  @override
  String notificationsActionMessage(Object action) {
    return '$action ਸੂਚਨਾ';
  }

  @override
  String get settingsTitle => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get settingsSectionAccount => 'ਖਾਤਾ';

  @override
  String get settingsEditProfile => 'ਪ੍ਰੋਫਾਈਲ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get settingsPrivacy => 'ਪਰਦੇਦਾਰੀ';

  @override
  String get settingsSecurity => 'ਸੁਰੱਖਿਆ';

  @override
  String get settingsSectionGameplay => 'ਗੇਮਪਲੇ';

  @override
  String get settingsShowTranslationLine => 'ਅਨੁਵਾਦ ਲਾਈਨ ਦਿਖਾਓ';

  @override
  String get settingsShowReadingLine => 'ਪੜ੍ਹਨਾ ਦਿਖਾਓ (ਪਿਨਯਿਨ/ਰੋਮਾਜੀ)';

  @override
  String get settingsDefaultTimerPerQuestion => 'ਪ੍ਰਤੀ ਸਵਾਲ ਡਿਫਾਲਟ ਟਾਈਮਰ';

  @override
  String get settingsMatchDifficulty => 'ਮੈਚ ਦੀ ਮੁਸ਼ਕਲ';

  @override
  String get settingsMatchDifficultyAdaptive => 'ਅਨੁਕੂਲ';

  @override
  String get settingsSectionSoundFeel => 'ਆਵਾਜ਼ ਅਤੇ ਮਹਿਸੂਸ';

  @override
  String get settingsMusic => 'ਸੰਗੀਤ';

  @override
  String get settingsSoundEffects => 'ਧੁਨੀ ਪ੍ਰਭਾਵ';

  @override
  String get settingsHaptics => 'ਹੈਪਟਿਕਸ';

  @override
  String get settingsSectionNotifications => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get settingsPushNotifications => 'ਪੁਸ਼ ਸੂਚਨਾਵਾਂ';

  @override
  String get settingsDailyReminder => 'ਰੋਜ਼ਾਨਾ ਰੀਮਾਈਂਡਰ';

  @override
  String get settingsSectionAppearance => 'ਦਿੱਖ';

  @override
  String get settingsTheme => 'ਥੀਮ';

  @override
  String get settingsUiLanguage => 'UI ਭਾਸ਼ਾ';

  @override
  String get settingsSectionAbout => 'ਬਾਰੇ';

  @override
  String get settingsVersion => 'ਵਰਜਨ';

  @override
  String get settingsTermsPrivacy => 'ਸ਼ਰਤਾਂ ਅਤੇ ਪਰਦੇਦਾਰੀ';

  @override
  String get settingsSupport => 'ਸਹਾਇਤਾ';

  @override
  String get settingsLogout => 'ਲੌਗ ਆਉਟ';

  @override
  String get themeSystem => 'ਸਿਸਟਮ';

  @override
  String get themeDark => 'ਡਾਰਕ';

  @override
  String get themeLight => 'ਲਾਈਟ';

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
  String get languagePunjabi => 'ਪੰਜਾਬੀ';

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
  String get editProfileUpdated => 'ਪ੍ਰੋਫਾਈਲ ਅੱਪਡੇਟ ਕੀਤਾ ਗਿਆ';

  @override
  String get editProfileTitle => 'ਪ੍ਰੋਫਾਈਲ ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get editProfilePhotoLabel => 'ਪ੍ਰੋਫਾਈਲ ਫੋਟੋ';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage ਰਾਹੀਂ ਅਵਤਾਰ ਚੋਣ ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get editProfileChangePhoto => 'ਬਦਲੋ';

  @override
  String get editProfileAvatarUploadSoon => 'ਅਵਤਾਰ ਅਪਲੋਡ ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get editProfileDisplayNameLabel => 'ਡਿਸਪਲੇ ਨਾਮ';

  @override
  String get editProfileDisplayNameHint => 'ਤੁਹਾਡਾ ਨਾਮ';

  @override
  String get editProfileDisplayNameRequired => 'ਆਪਣਾ ਨਾਮ ਦਰਜ ਕਰੋ';

  @override
  String get editProfileDisplayNameTooShort => 'ਬਹੁਤ ਛੋਟਾ';

  @override
  String get editProfileUsernameLabel => 'ਯੂਜ਼ਰਨੇਮ';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'ਯੂਜ਼ਰਨੇਮ ਦਰਜ ਕਰੋ';

  @override
  String get editProfileUsernameTooShort => 'ਘੱਟੋ ਘੱਟ 3 ਅੱਖਰ';

  @override
  String get editProfileUsernameInvalid => 'ਸਿਰਫ ਅੱਖਰ, ਨੰਬਰ, _';

  @override
  String get editProfileBioLabel => 'ਬਾਇਓ';

  @override
  String get editProfileBioHint => 'ਇੱਕ ਛੋਟਾ ਬਾਇਓ...';

  @override
  String get editProfileBioTooLong => 'ਵੱਧ ਤੋਂ ਵੱਧ 120 ਅੱਖਰ';

  @override
  String get editProfileLocationLabel => 'ਟਿਕਾਣਾ';

  @override
  String get editProfileLocationHint => 'ਸ਼ਹਿਰ / ਦੇਸ਼';

  @override
  String get editProfileDailyGoalTitle => 'ਰੋਜ਼ਾਨਾ ਟੀਚਾ';

  @override
  String get editProfileDailyGoalSubtitle =>
      'ਚੁਣੋ ਕਿ ਤੁਸੀਂ ਰੋਜ਼ਾਨਾ ਕਿੰਨੇ ਮਿੰਟ ਅਧਿਐਨ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ';

  @override
  String get securityTitle => 'ਸੁਰੱਖਿਆ';

  @override
  String get securitySectionPassword => 'ਪਾਸਵਰਡ';

  @override
  String get securityChangePasswordTitle => 'ਪਾਸਵਰਡ ਬਦਲੋ';

  @override
  String get securityChangePasswordSubtitle =>
      'ਆਪਣੇ ਪਾਸਵਰਡ ਨੂੰ ਨਿਯਮਿਤ ਤੌਰ \'ਤੇ ਅੱਪਡੇਟ ਕਰੋ';

  @override
  String get securitySectionTwoFactor => 'ਦੋ-ਕਾਰਕ ਪ੍ਰਮਾਣਿਕਤਾ';

  @override
  String get securityEnable2faTitle => '2FA ਯੋਗ ਕਰੋ';

  @override
  String get securityEnable2faSubtitle => 'ਸਾਈਨ ਇਨ ਕਰਨ ਵੇਲੇ ਵਾਧੂ ਸੁਰੱਖਿਆ';

  @override
  String get securitySectionAppLock => 'ਐਪ ਲੌਕ';

  @override
  String get securityBiometricTitle => 'ਬਾਇਓਮੀਟ੍ਰਿਕ ਅਨਲੌਕ';

  @override
  String get securityBiometricSubtitle =>
      'SOMA ਨੂੰ ਅਨਲੌਕ ਕਰਨ ਲਈ FaceID/TouchID ਦੀ ਵਰਤੋਂ ਕਰੋ';

  @override
  String get securityAppLockTitle => 'ਐਪ ਲੌਕ';

  @override
  String get securityAppLockSubtitle => 'ਜਦੋਂ ਤੁਸੀਂ ਐਪ ਛੱਡੋ ਤਾਂ SOMA ਲੌਕ ਕਰੋ';

  @override
  String get securitySectionSessions => 'ਸਰਗਰਮ ਸੈਸ਼ਨ';

  @override
  String get securityNoSessions => 'ਕੋਈ ਸਰਗਰਮ ਸੈਸ਼ਨ ਨਹੀਂ ਮਿਲਿਆ';

  @override
  String get securityThisDevice => 'ਇਹ ਡਿਵਾਈਸ';

  @override
  String get securityDevice => 'ਡਿਵਾਈਸ';

  @override
  String get securityActiveLabel => 'ਸਰਗਰਮ';

  @override
  String get securitySignInToEnable2fa => '2FA ਯੋਗ ਕਰਨ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA ਯੋਗ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA ਅਯੋਗ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA ਸੈੱਟਅੱਪ';

  @override
  String get securitySecretKeyLabel => 'ਗੁਪਤ ਕੁੰਜੀ';

  @override
  String get securityCodeHint => '6-ਅੰਕ ਦਾ ਕੋਡ';

  @override
  String get security2faEnabled => '2FA ਯੋਗ ਕੀਤਾ ਗਿਆ';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'ਕੋਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get securityVerifying => 'ਪੁਸ਼ਟੀ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ...';

  @override
  String get securityVerify => 'ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get securityCurrentPasswordHint => 'ਮੌਜੂਦਾ ਪਾਸਵਰਡ';

  @override
  String get securityNewPasswordHint => 'ਨਵਾਂ ਪਾਸਵਰਡ (ਘੱਟੋ-ਘੱਟ 8 ਅੱਖਰ)';

  @override
  String get securityConfirmPasswordHint => 'ਨਵੇਂ ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get securitySignInToChangePassword => 'ਪਾਸਵਰਡ ਬਦਲਣ ਲਈ ਸਾਈਨ ਇਨ ਕਰੋ';

  @override
  String get securityEnterCurrentPassword => 'ਆਪਣਾ ਮੌਜੂਦਾ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ';

  @override
  String get securityPasswordMinLength =>
      'ਨਵੇਂ ਪਾਸਵਰਡ ਵਿੱਚ ਘੱਟੋ-ਘੱਟ 8 ਅੱਖਰ ਹੋਣੇ ਚਾਹੀਦੇ ਹਨ';

  @override
  String get securityPasswordsDoNotMatch => 'ਪਾਸਵਰਡ ਮੇਲ ਨਹੀਂ ਖਾਂਦੇ';

  @override
  String get securityPasswordUpdated => 'ਪਾਸਵਰਡ ਅੱਪਡੇਟ ਕੀਤਾ ਗਿਆ';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'ਪਾਸਵਰਡ ਅੱਪਡੇਟ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get securityAutoLockAfter => 'ਇਸ ਤੋਂ ਬਾਅਦ ਆਟੋ ਲੌਕ';

  @override
  String get privacyTitle => 'ਪਰਦੇਦਾਰੀ';

  @override
  String get privacySectionVisibility => 'ਦਿੱਖ';

  @override
  String get privacyProfileVisibilityTitle => 'ਪ੍ਰੋਫਾਈਲ ਦਿੱਖ';

  @override
  String get privacyVisibilityPublic => 'ਸਾਰਵਜਨਿਕ';

  @override
  String get privacyVisibilityFriends => 'ਦੋਸਤ';

  @override
  String get privacyVisibilityPrivate => 'ਨਿੱਜੀ';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'ਹਰ ਕੋਈ ਤੁਹਾਡਾ ਪ੍ਰੋਫਾਈਲ ਦੇਖ ਸਕਦਾ ਹੈ';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'ਕੇਵਲ ਦੋਸਤ ਤੁਹਾਡਾ ਪ੍ਰੋਫਾਈਲ ਦੇਖ ਸਕਦੇ ਹਨ';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'ਕੇਵਲ ਤੁਸੀਂ ਆਪਣਾ ਪ੍ਰੋਫਾਈਲ ਦੇਖ ਸਕਦੇ ਹੋ';

  @override
  String get privacySectionActivity => 'ਗਤੀਵਿਧੀ';

  @override
  String get privacyShowOnlineTitle => 'ਔਨਲਾਈਨ ਸਥਿਤੀ ਦਿਖਾਓ';

  @override
  String get privacyShowOnlineSubtitle =>
      'ਖਿਡਾਰੀਆਂ ਨੂੰ ਇਹ ਦੇਖਣ ਦਿਓ ਕਿ ਤੁਸੀਂ ਕਦੋਂ ਔਨਲਾਈਨ ਹੋ';

  @override
  String get privacyShowActivityTitle => 'ਸਿੱਖਣ ਦੀ ਗਤੀਵਿਧੀ ਦਿਖਾਓ';

  @override
  String get privacyShowActivitySubtitle => 'ਲਗਾਤਾਰ, XP ਅਤੇ ਹਾਲੀਆ ਤਰੱਕੀ ਦਿਖਾਓ';

  @override
  String get privacySectionSocial => 'ਸੋਸ਼ਲ';

  @override
  String get privacyAllowRequestsTitle => 'ਦੋਸਤੀ ਦੀਆਂ ਬੇਨਤੀਆਂ ਦੀ ਆਗਿਆ ਦਿਓ';

  @override
  String get privacyAllowRequestsSubtitle =>
      'ਲੋਕਾਂ ਨੂੰ ਤੁਹਾਨੂੰ ਦੋਸਤੀ ਦੀਆਂ ਬੇਨਤੀਆਂ ਭੇਜਣ ਦਿਓ';

  @override
  String get privacyWhoCanDmTitle => 'ਕੌਣ DM ਭੇਜ ਸਕਦਾ ਹੈ';

  @override
  String get privacyDmEveryone => 'ਹਰ ਕੋਈ';

  @override
  String get privacyDmFriends => 'ਦੋਸਤ';

  @override
  String get privacyDmNoOne => 'ਕੋਈ ਨਹੀਂ';

  @override
  String get privacyDmEveryoneSubtitle => 'ਕੋਈ ਵੀ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਭੇਜ ਸਕਦਾ ਹੈ';

  @override
  String get privacyDmFriendsSubtitle => 'ਕੇਵਲ ਦੋਸਤ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਭੇਜ ਸਕਦੇ ਹਨ';

  @override
  String get privacyDmNoOneSubtitle => 'ਕੋਈ ਵੀ ਤੁਹਾਨੂੰ ਸੁਨੇਹਾ ਨਹੀਂ ਭੇਜ ਸਕਦਾ';

  @override
  String get privacySectionBlockedUsers => 'ਬਲੌਕ ਕੀਤੇ ਯੂਜ਼ਰ';

  @override
  String get privacyBlockedUsersComingSoon =>
      'ਬਲੌਕ ਕੀਤੇ ਯੂਜ਼ਰਾਂ ਦਾ ਪ੍ਰਬੰਧਨ ਜਲਦੀ ਆ ਰਿਹਾ ਹੈ';

  @override
  String get privacySectionDataControls => 'ਡਾਟਾ ਕੰਟਰੋਲ';

  @override
  String get privacyExportDataTitle => 'ਮੇਰਾ ਡਾਟਾ ਐਕਸਪੋਰਟ ਕਰੋ';

  @override
  String get privacyExportDataSubtitle =>
      'ਆਪਣੀ ਗਤੀਵਿਧੀ ਅਤੇ ਕੋਰਸਾਂ ਨੂੰ ਡਾਊਨਲੋਡ ਕਰੋ';

  @override
  String get privacyExportInfoTitle => 'ਡਾਟਾ ਐਕਸਪੋਰਟ';

  @override
  String get privacyExportInfoBody =>
      'ਅਗਲਾ ਕਦਮ: JSON/CSV ਐਕਸਪੋਰਟ ਬਣਾਉਣਾ ਅਤੇ ਈਮੇਲ ਜਾਂ ਲੋਕਲ ਡਾਊਨਲੋਡ';

  @override
  String get privacyDeleteAccountTitle => 'ਖਾਤਾ ਮਿਟਾਓ';

  @override
  String get privacyDeleteAccountSubtitle =>
      'ਇਹ ਤੁਹਾਡੇ ਖਾਤੇ ਅਤੇ ਡਾਟਾ ਨੂੰ ਪੱਕੇ ਤੌਰ \'ਤੇ ਹਟਾ ਦਿੰਦਾ ਹੈ';

  @override
  String get privacyDeleteConfirmTitle => 'ਖਾਤਾ ਮਿਟਾਉਣਾ ਹੈ?';

  @override
  String get privacyDeleteConfirmBody =>
      'ਇਹ ਕਾਰਵਾਈ ਵਾਪਸ ਨਹੀਂ ਲਈ ਜਾ ਸਕਦੀ। ਤੁਹਾਡਾ ਪ੍ਰੋਫਾਈਲ, ਕੋਰਸ, ਦੋਸਤ ਅਤੇ ਸੁਨੇਹੇ ਹਟਾ ਦਿੱਤੇ ਜਾਣਗੇ';

  @override
  String get privacyDeleteComingSoon =>
      'ਮਿਟਾਉਣਾ ਬਾਅਦ ਵਿੱਚ Supabase ਨਾਲ ਜੁੜਿਆ ਜਾਵੇਗਾ';

  @override
  String get soloLabel => 'ਸੋਲੋ';

  @override
  String get soloResultsCompletedTitle => 'ਸੋਲੋ ਸੈਸ਼ਨ ਪੂਰਾ ਹੋਇਆ';

  @override
  String get soloResultsFeedbackElite => 'ਵਧੀਆ ਪ੍ਰਦਰਸ਼ਨ - ਸਟ੍ਰੀਕ ਜਾਰੀ ਰੱਖੋ';

  @override
  String get soloResultsFeedbackStrong =>
      'ਮਜ਼ਬੂਤ ਕੰਮ - ਤੇਜ਼ੀ ਨਾਲ ਸੁਧਾਰ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String get soloResultsFeedbackProgress =>
      'ਚੰਗੀ ਤਰੱਕੀ - ਗਲਤੀਆਂ ਦੀ ਸਮੀਖਿਆ ਕਰੋ ਅਤੇ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get soloResultsFeedbackTryAgain =>
      'ਕੋਈ ਦਬਾਅ ਨਹੀਂ - ਘੱਟ ਸਵਾਲਾਂ ਨਾਲ ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ ਅਤੇ ਫੋਕਸ ਕਰੋ';

  @override
  String get soloResultsPerfectScore =>
      'ਪੂਰਾ ਸਕੋਰ! ਸਮੀਖਿਆ ਕਰਨ ਲਈ ਕੋਈ ਗਲਤੀ ਨਹੀਂ';

  @override
  String get soloResultsReviewPrompt =>
      'ਤੇਜ਼ੀ ਨਾਲ ਸਿੱਖਣ ਲਈ ਗਲਤੀਆਂ ਦੀ ਸਮੀਖਿਆ ਕਰੋ। ਤੁਹਾਡੇ ਗਲਤ ਜਵਾਬ ਹੇਠਾਂ ਹਨ';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'ਗਲਤੀਆਂ ਦੀ ਸਮੀਖਿਆ ($count)';
  }

  @override
  String get authNotSignedIn => 'ਸਾਈਨ ਇਨ ਨਹੀਂ ਕੀਤਾ';

  @override
  String get genericUser => 'ਯੂਜ਼ਰ';

  @override
  String get loading => 'ਲੋਡ ਹੋ ਰਿਹਾ ਹੈ...';

  @override
  String get edit => 'ਸੰਪਾਦਿਤ ਕਰੋ';

  @override
  String get send => 'ਭੇਜੋ';

  @override
  String get join => 'ਸ਼ਾਮਲ ਹੋਵੋ';

  @override
  String get leave => 'ਛੱਡੋ';

  @override
  String get ready => 'ਤਿਆਰ';

  @override
  String get levelBeginner => 'ਸ਼ੁਰੂਆਤੀ';

  @override
  String get levelIntermediate => 'ਦਰਮਿਆਨਾ';

  @override
  String get levelAdvanced => 'ਉੱਨਤ';

  @override
  String questionsShort(Object count) {
    return '$count ਸਵਾਲ';
  }

  @override
  String secondsShort(Object count) {
    return '$count ਸਕਿੰਟ';
  }

  @override
  String get circlesAllCourses => 'ਸਾਰੇ ਕੋਰਸ';

  @override
  String get circlesAllModes => 'ਸਾਰੇ ਮੋਡ';

  @override
  String get circlesAllLevels => 'ਸਾਰੇ ਪੱਧਰ';

  @override
  String get circlesAddNewCourse => 'ਨਵਾਂ ਕੋਰਸ ਸ਼ਾਮਲ ਕਰੋ';

  @override
  String get circlesCoursesTitle => 'ਕੋਰਸ';

  @override
  String get circlesModeTitle => 'ਮੋਡ';

  @override
  String get circlesLevelTitle => 'ਪੱਧਰ';

  @override
  String get circlesNoActiveForFilters =>
      'ਇਹਨਾਂ ਫਿਲਟਰਾਂ ਲਈ ਕੋਈ ਸਰਗਰਮ Circle ਨਹੀਂ';

  @override
  String get circlesUnknownRoom => 'ਅਣਜਾਣ ਕਮਰਾ';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle ਬਣਾਓ';

  @override
  String get circlesCircleName => 'Circle ਦਾ ਨਾਮ';

  @override
  String get circlesEnterName => 'ਨਾਮ ਦਰਜ ਕਰੋ';

  @override
  String get circlesLanguages => 'ਭਾਸ਼ਾਵਾਂ';

  @override
  String get circlesRoomSetup => 'ਕਮਰਾ ਸੈੱਟਅੱਪ';

  @override
  String get circlesPlayers => 'ਖਿਡਾਰੀ';

  @override
  String get circlesEmptySlot => 'ਖਾਲੀ ਥਾਂ';

  @override
  String get circlesPlayersRange => '1-5 ਖਿਡਾਰੀ';

  @override
  String get circlesQuestions => 'ਸਵਾਲ';

  @override
  String get circlesQuestionsSubtitle => 'ਸਵਾਲਾਂ ਦੀ ਗਿਣਤੀ';

  @override
  String get circlesTimePerQuestion => 'ਸਮਾਂ ਪ੍ਰਤੀ ਸਵਾਲ';

  @override
  String get circlesSecondsPerQuestion => 'ਸਕਿੰਟ ਪ੍ਰਤੀ ਸਵਾਲ';

  @override
  String get circlesAdvanced => 'ਉੱਨਤ';

  @override
  String get circlesAllowSpectators => 'ਦਰਸ਼ਕਾਂ ਦੀ ਆਗਿਆ ਦਿਓ';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Let others watch without playing.';

  @override
  String get circlesLiveVoiceChat => 'ਲਾਈਵ ਵਾਇਸ ਚੈਟ';

  @override
  String get circlesLiveVoiceChatSubtitle => 'ਮੈਚਾਂ ਦੌਰਾਨ ਆਵਾਜ਼ ਸੰਚਾਰ ਯੋਗ ਕਰੋ';

  @override
  String get circlesLiveTextChat => 'ਲਾਈਵ ਟੈਕਸਟ ਚੈਟ';

  @override
  String get circlesLiveTextChatSubtitle => 'ਮੈਚਾਂ ਦੌਰਾਨ ਚੈਟ ਯੋਗ ਕਰੋ';

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
  String get circlesCreatedSuccess => 'Circle ਬਣਾਇਆ ਗਿਆ';

  @override
  String circlesCreateError(Object error) {
    return 'Circle ਬਣਾਉਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get circlesHostTip =>
      'ਸੁਝਾਅ: ਤੁਸੀਂ ਬਣਾਉਣ ਤੋਂ ਬਾਅਦ ਦੋਸਤਾਂ ਨੂੰ ਸੱਦਾ ਦੇ ਸਕਦੇ ਹੋ';

  @override
  String circlesJoinError(Object error) {
    return 'Circle ਵਿੱਚ ਸ਼ਾਮਲ ਹੋਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle ਲਾਬੀ';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'ਕੋਡ: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'ਮੈਚ ਸੈਟਿੰਗਾਂ';

  @override
  String circlesLevelWithValue(Object level) {
    return 'ਪੱਧਰ $level';
  }

  @override
  String get circlesDifficulty => 'ਮੁਸ਼ਕਲ';

  @override
  String get circlesPerQuestionShort => 'ਪ੍ਰਤੀ ਸਵਾਲ';

  @override
  String get circlesInvite => 'ਸੱਦਾ';

  @override
  String get circlesCopyId => 'ID ਕਾਪੀ ਕਰੋ';

  @override
  String get circlesCopiedId => 'ID ਕਾਪੀ ਕੀਤੀ ਗਈ';

  @override
  String get circlesMatchInProgress => 'ਮੈਚ ਚੱਲ ਰਿਹਾ ਹੈ';

  @override
  String get circlesSpectatorQueuedBody =>
      'ਮੈਚ ਚੱਲ ਰਿਹਾ ਹੈ। ਤੁਸੀਂ ਦਰਸ਼ਕ ਵਜੋਂ ਸ਼ਾਮਲ ਹੋਵੋਗੇ';

  @override
  String get circlesHostStartWhenReady =>
      'ਜਦੋਂ ਹਰ ਕੋਈ ਤਿਆਰ ਹੋਵੇਗਾ ਤਾਂ ਹੋਸਟ ਸ਼ੁਰੂ ਕਰੇਗਾ';

  @override
  String get circlesSpectators => 'ਦਰਸ਼ਕ';

  @override
  String get circlesSpectator => 'ਦਰਸ਼ਕ';

  @override
  String get circlesSpectatorCanWatch => 'ਦਰਸ਼ਕ ਲਾਈਵ ਦੇਖ ਸਕਦੇ ਹਨ';

  @override
  String get circlesJoinRequests => 'ਸ਼ਾਮਲ ਹੋਣ ਦੀਆਂ ਬੇਨਤੀਆਂ';

  @override
  String get circlesAcceptSpectatorsHint =>
      'ਮੈਚ ਸ਼ੁਰੂ ਕਰਨ ਤੋਂ ਪਹਿਲਾਂ ਦਰਸ਼ਕਾਂ ਨੂੰ ਸਵੀਕਾਰ ਕਰੋ';

  @override
  String get circlesStartGame => 'ਗੇਮ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get circlesWaitingForPlayers => 'ਖਿਡਾਰੀਆਂ ਦੀ ਉਡੀਕ ਕੀਤੀ ਜਾ ਰਹੀ ਹੈ';

  @override
  String get circlesLeaveCircle => 'Circle ਛੱਡੋ';

  @override
  String get circlesRequestSent => 'ਬੇਨਤੀ ਭੇਜੀ ਗਈ';

  @override
  String get circlesRequestToJoin => 'ਸ਼ਾਮਲ ਹੋਣ ਲਈ ਬੇਨਤੀ';

  @override
  String get circlesWatchLive => 'ਲਾਈਵ ਦੇਖੋ';

  @override
  String get circlesPlayerTip =>
      'ਜਦੋਂ ਤੁਸੀਂ ਤਿਆਰ ਹੋਵੋ ਤਾਂ ਤਿਆਰ ਦਬਾਓ। ਹੋਸਟ ਮੈਚ ਸ਼ੁਰੂ ਕਰੇਗਾ';

  @override
  String get circlesSpectatorTip =>
      'ਤੁਸੀਂ ਦੇਖ ਰਹੇ ਹੋ। ਜਦੋਂ ਹੋਸਟ ਸ਼ੁਰੂ ਕਰਦਾ ਹੈ ਤਾਂ ਲਾਈਵ ਦੇਖੋ';

  @override
  String get circlesHostControls => 'ਹੋਸਟ ਕੰਟਰੋਲ';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'ਹੋਸਟ ਟ੍ਰਾਂਸਫਰ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle ਖਤਮ ਕਰਨ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'ਯੂਜ਼ਰ @$username ਨਹੀਂ ਮਿਲਿਆ';
  }

  @override
  String get circlesInvalidUser => 'ਅਵੈਧ ਯੂਜ਼ਰ';

  @override
  String get circlesCantInviteSelf => 'ਤੁਸੀਂ ਆਪਣੇ ਆਪ ਨੂੰ ਸੱਦਾ ਨਹੀਂ ਦੇ ਸਕਦੇ';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username ਪਹਿਲਾਂ ਹੀ Circle ਵਿੱਚ ਹੈ';
  }

  @override
  String get circlesDefaultHost => 'ਹੋਸਟ';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'ਯੂਜ਼ਰਨੇਮ ਦੁਆਰਾ ਸੱਦਾ ਦਿਓ';

  @override
  String circlesInviteSent(Object username) {
    return '@$username ਨੂੰ ਸੱਦਾ ਭੇਜਿਆ ਗਿਆ';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'ਸੱਦਾ ਭੇਜਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get circlesJoinRequestSent => 'ਸ਼ਾਮਲ ਹੋਣ ਦੀ ਬੇਨਤੀ ਭੇਜੀ ਗਈ';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'ਬੇਨਤੀ ਭੇਜਣ ਵਿੱਚ ਅਸਫਲ: $error';
  }

  @override
  String get circlesFull => 'Circle ਭਰ ਗਿਆ ਹੈ';

  @override
  String get circlesSpectatorAdded => 'ਦਰਸ਼ਕ ਸ਼ਾਮਲ ਕੀਤਾ ਗਿਆ';

  @override
  String circlesApproveFailed(Object error) {
    return 'ਮਨਜ਼ੂਰੀ ਅਸਫਲ: $error';
  }

  @override
  String get circlesRequestDeclined => 'ਬੇਨਤੀ ਅਸਵੀਕਾਰ ਕੀਤੀ ਗਈ';

  @override
  String circlesDeclineFailed(Object error) {
    return 'ਅਸਵੀਕਾਰ ਕਰਨਾ ਅਸਫਲ: $error';
  }

  @override
  String get circlesParticipant => 'ਭਾਗੀਦਾਰ';

  @override
  String get circlesLeavePromptTitle => 'Circle ਛੱਡਣਾ ਹੈ?';

  @override
  String get circlesLeavePromptTransfer =>
      'ਕਿਰਪਾ ਕਰਕੇ ਛੱਡਣ ਤੋਂ ਪਹਿਲਾਂ ਹੋਸਟ ਟ੍ਰਾਂਸਫਰ ਕਰੋ';

  @override
  String get circlesLeavePromptEndOnly => 'Circle ਖਤਮ ਕਰੋ ਅਤੇ ਬਾਹਰ ਜਾਓ';

  @override
  String get circlesTransferHost => 'ਹੋਸਟ ਟ੍ਰਾਂਸਫਰ ਕਰੋ';

  @override
  String get circlesEndCircle => 'Circle ਖਤਮ ਕਰੋ';

  @override
  String get circlesTransferHostTitle => 'ਹੋਸਟ ਟ੍ਰਾਂਸਫਰ';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
