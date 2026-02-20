// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'கற்க. போட்டியிட. தேர்ச்சி பெற.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'பதிவு செய்';

  @override
  String get signIn => 'உள்நுழைக';

  @override
  String get skipForNow => 'இப்போதைக்குத் தவிர்';

  @override
  String get authFillAllFields => 'தயவுசெய்து எல்லா புலங்களையும் நிரப்புக';

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
    return 'பிழை: $error';
  }

  @override
  String get authEmail => 'மின்னஞ்சல்';

  @override
  String get authPassword => 'கடவுச்சொல்';

  @override
  String get authUsername => 'பயனர்பெயர்';

  @override
  String get authContinue => 'தொடரவும்';

  @override
  String get authSigningIn => 'உள்நுழைகிறது...';

  @override
  String get authCreateAccount => 'கணக்கை உருவாக்கு';

  @override
  String get authCreating => 'உருவாக்குகிறது...';

  @override
  String get authNeedAccount => 'கணக்கு இல்லையா? ';

  @override
  String get authHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get dialogAuthRequiredTitle => 'Circles-ல் சேர உள்நுழையவும்';

  @override
  String get dialogAuthRequiredBody =>
      'Circles பல்விளையாட்டு அறைகள். நேரலை போட்டிகளில் சேரவும், நண்பர்களை அழைக்கவும், முன்னேற்றத்தைச் சேமிக்கவும் கணக்கை உருவாக்கவும்.';

  @override
  String get notNow => 'இப்போது இல்லை';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'பாடத்திட்டத்தை நீக்கவா?';

  @override
  String removeCourseBody(Object course) {
    return '$course உங்கள் பட்டியலில் இருந்து நீக்கப்படும்';
  }

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get remove => 'நீக்கு';

  @override
  String welcomeBack(Object name) {
    return 'மீண்டும் வருக, $name!';
  }

  @override
  String get editCourses => 'பாடத்திட்டங்களைத் தொகு';

  @override
  String get done => 'முடிந்தது';

  @override
  String get noCoursesToEdit => 'தொகுக்க பாடத்திட்டங்கள் இல்லை';

  @override
  String get addCourse => 'பாடத்திட்டத்தைச் சேர்';

  @override
  String get unknown => 'தெரியாத';

  @override
  String get iSpeak => 'நான் பேசுவது';

  @override
  String get iWantToLearn => 'நான் கற்க விரும்புவது';

  @override
  String get chooseYourLanguage => 'உங்கள் மொழியைத் தேர்வுசெய்க';

  @override
  String get chooseLearningLanguage => 'கற்கும் மொழியைத் தேர்வுசெய்க';

  @override
  String get chooseTwoDifferentLanguages =>
      'தயவுசெய்து இரண்டு வெவ்வேறு மொழிகளைத் தேர்வுசெய்க';

  @override
  String get createCourse => 'பாடத்திட்டத்தை உருவாக்கு';

  @override
  String get soloCourseTitle => 'தனிப் பாடத்திட்டம்';

  @override
  String get searchLanguage => 'மொழியைத் தேடு';

  @override
  String get noMatches => 'பொருத்தங்கள் இல்லை';

  @override
  String get chooseCourseType => 'பாடத்திட்ட வகையைத் தேர்வுசெய்க';

  @override
  String get soloStudyDescription =>
      'Circles போன்ற வினாடி வினாக்களுடன் தனியாகப் பயிற்சி செய்யுங்கள் - ஆனால் அறைகள், அரட்டை, பார்வையாளர்கள் அல்லது தொகுப்பாளர் விருப்பங்கள் இல்லாமல்';

  @override
  String get soloModeVocabulary => 'சொற்களஞ்சியம்';

  @override
  String get soloModeSentences => 'வாக்கியங்கள்';

  @override
  String get soloModeReview => 'மதிப்பாய்வு';

  @override
  String get soloModeVocabularySubtitle =>
      'பல தேர்வு, பொருள்கள், ஒத்தச்சொற்கள், பயன்பாடு';

  @override
  String get soloModeSentencesSubtitle =>
      'காலியிடங்களை நிரப்பு + மொழிபெயர்ப்பு + வாசிப்பு';

  @override
  String get soloModeReviewDescription =>
      'கற்றவற்றைப் பயிற்சி செய்யுங்கள்: பலவீனமான சொற்கள், சமீபத்திய பிழைகள் மற்றும் இடைவெளி முறையிலான மறுலாய்வு';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'மதிப்பாய்வைத் துவங்கு';

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
    return '$mode அமைப்பு';
  }

  @override
  String get difficulty => 'கடினத்தன்மை';

  @override
  String get numberOfQuestions => 'கேள்விகள் எண்ணிக்கை';

  @override
  String get timerPerQuestion => 'கேள்விக்கான நேரம்';

  @override
  String get noTimer => 'நேரம் இல்லை';

  @override
  String get start => 'துவங்கு';

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get profileSignInToMessage => 'செய்தி அனுப்ப உள்நுழையவும்';

  @override
  String get profileThatsYourProfile => 'இது உங்கள் சுயவிவரம்';

  @override
  String get profileSignInToAddFriends => 'நண்பர்களைச் சேர்க்க உள்நுழையவும்';

  @override
  String get profileCantAddYourself => 'உங்களை நீங்களே சேர்க்க முடியாது';

  @override
  String profileRequestSent(Object username) {
    return '@$username-க்கு கோரிக்கை அனுப்பப்பட்டது';
  }

  @override
  String get profileRequestFailed => 'கோரிக்கை அனுப்புவதில் தோல்வி';

  @override
  String get profileDefaultDisplayName => 'புதிய பயனர்';

  @override
  String get profileDefaultBio => 'கற்கத் தயார்!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'விருந்தினர்';

  @override
  String get guestUsername => 'விருந்தினர்';

  @override
  String get guestSessionLabel => 'விருந்தினர் அமர்வு';

  @override
  String get unlockFullProfile => 'முழு சுயவிவரத்தைத் திற';

  @override
  String get guestBenefitSync =>
      'எல்லா சாதனங்களிலும் முன்னேற்றத்தை ஒத்திசைக்கவும்';

  @override
  String get guestBenefitCircles => 'Circles-ல் சேரவும் நேரலையில் விளையாடவும்';

  @override
  String get guestBenefitNotifications =>
      'அறிவிப்புகள் மற்றும் நட்பு கோரிக்கைகளைப் பெறவும்';

  @override
  String get progressStaysOnDevice =>
      'நீங்கள் உள்நுழையும் வரை முன்னேற்றம் இந்த சாதனத்தில் இருக்கும்';

  @override
  String profileGoalLabel(Object minutes) {
    return 'இலக்கு: $minutes நிமி';
  }

  @override
  String get profileXpProgress => 'XP முன்னேற்றம்';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'வெற்றிகள்';

  @override
  String get profileStreak => 'தொடர்';

  @override
  String get profileFriendsTitle => 'நண்பர்கள்';

  @override
  String get profileViewAll => 'எல்லாவற்றையும் பார்';

  @override
  String get profileAchievementsTitle => 'சாதனைகள்';

  @override
  String get profileNoAchievements => 'இன்னும் சாதனைகள் இல்லை';

  @override
  String get profileRequested => 'கோரப்பட்டது';

  @override
  String get profileSending => 'அனுப்புகிறது...';

  @override
  String get profileAddFriend => 'நண்பரைச் சேர்';

  @override
  String get profileConnectTitle => 'இணை';

  @override
  String get profileMessage => 'செய்தி';

  @override
  String get profileSnapshot => 'சுயவிவரப் படம்';

  @override
  String get profileLocationHidden => 'இடம் மறைக்கப்பட்டது';

  @override
  String get profileBioHidden => 'வாழ்க்கைக்குறிப்பு மறைக்கப்பட்டது';

  @override
  String profileDailyGoal(Object minutes) {
    return 'தினசரி இலக்கு $minutes நிமி';
  }

  @override
  String get circleInviteTitle => 'Circle அழைப்பு';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ஐடி: $id';
  }

  @override
  String get signInToJoin => 'சேர உள்நுழையவும்';

  @override
  String get joiningCircle => 'சேருகிறது...';

  @override
  String get joinCircle => 'Circles-ல் சேரவும்';

  @override
  String get circleJoinedAsPlayer => 'வீரராகச் சேர்ந்தார்';

  @override
  String get circleJoinedAsSpectator => 'பார்வையாளராகச் சேர்ந்தார்';

  @override
  String get accept => 'ஏற்றுக்கொள்';

  @override
  String get decline => 'நிராகரி';

  @override
  String get open => 'திற';

  @override
  String get circleCountdownTitle => 'தயாராகுங்கள்';

  @override
  String get circleCountdownSubtitle => 'Circle துவங்குகிறது...';

  @override
  String get userFallbackName => 'பயனர்';

  @override
  String get micOff => 'மைக் ஆஃப்';

  @override
  String get micOn => 'மைக் ஆன்';

  @override
  String get roleHost => 'தொகுப்பாளர்';

  @override
  String get roleSpectator => 'பார்வையாளர்';

  @override
  String get tagHost => 'ஹோஸ்ட்';

  @override
  String get tagYou => 'நீங்கள்';

  @override
  String get statusCorrect => 'சரி';

  @override
  String get statusWrong => 'தவறு';

  @override
  String get statusWaiting => 'காத்திருக்கிறது';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pts';

  @override
  String get pointsLabel => 'புள்ளிகள்';

  @override
  String get statCorrect => 'சரி';

  @override
  String get statAnswers => 'பதில்கள்';

  @override
  String get statTotal => 'மொத்தம்';

  @override
  String get statQuestions => 'கேள்விகள்';

  @override
  String get statAccuracy => 'துல்லியம்';

  @override
  String get statRate => 'விகிதம்';

  @override
  String get statRank => 'தரவரிசை';

  @override
  String get statPosition => 'நிலை';

  @override
  String get statMode => 'பயன்முறை';

  @override
  String get statType => 'வகை';

  @override
  String get next => 'அடுத்து';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get continueLabel => 'தொடரவும்';

  @override
  String get save => 'சேமி';

  @override
  String get playAgain => 'மீண்டும் விளையாடு';

  @override
  String get backToCourse => 'பாடத்திட்டத்திற்குத் திரும்பு';

  @override
  String get resultsTitle => 'முடிவுகள்';

  @override
  String get shareLater => 'பிறகு பகிரவும்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get ok => 'சரி';

  @override
  String minutesShort(Object minutes) {
    return '$minutes நிமி';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count நிமி';
  }

  @override
  String timeShortHours(Object count) {
    return '$count மணி';
  }

  @override
  String timeShortDays(Object count) {
    return '$count நாட்கள்';
  }

  @override
  String get timeJustNow => 'இப்போதுதான்';

  @override
  String timeMinutesAgo(Object count) {
    return '$count நிமி முன்';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count மணி முன்';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count நாட்கள் முன்';
  }

  @override
  String get liveQuizWaitingForHost => 'தொகுப்பாளருக்காகக் காத்திருக்கிறது...';

  @override
  String get liveQuizJoinRequestSent => 'சேரும் கோரிக்கை அனுப்பப்பட்டது';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'கோரிக்கை அனுப்புவதில் தோல்வி: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'தொகுப்பாளர் கட்டுப்பாடுகள்';

  @override
  String get liveQuizSpectatorModeTitle => 'பார்வையாளர் பயன்முறை';

  @override
  String get liveQuizHostControlsSubtitle =>
      'அனைவரும் பதிலளிக்கும்போது அல்லது நேரம் முடியும்போது சுற்றுகள் தானாகவே முன்னேறும்';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'கேள்விகள் மற்றும் லீடர்போர்டுகளை நேரலையில் பாருங்கள். உங்களால் பதிலளிக்க முடியாது';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'கேள்வி $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'கோரிக்கை அனுப்பப்பட்டது';

  @override
  String get liveQuizRequestToJoin => 'சேரக் கோரிக்கை';

  @override
  String get liveQuizSpectatorFooter =>
      'நீங்கள் நேரலையில் பார்க்கிறீர்கள். கேள்விகள் மற்றும் லீடர்போர்டுகளை ரசியுங்கள்';

  @override
  String get circleNotFound => 'Circle காணப்படவில்லை';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'மீண்டும் விளையாடத் துவங்குவதில் தோல்வி: $error';
  }

  @override
  String get resultsMatchTitle => 'போட்டி முடிவுகள்';

  @override
  String resultsNiceWork(Object name) {
    return 'நன்று, $name';
  }

  @override
  String get resultsPlaceFirst => 'முதல் இடம்';

  @override
  String get resultsPlaceSecond => 'இரண்டாம் இடம்';

  @override
  String get resultsPlaceThird => 'மூன்றாம் இடம்';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank-ம் இடம்';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players வீரர்களில்';
  }

  @override
  String get resultsHighlightChampion =>
      'சாம்பியன்! இந்தச் சுற்றில் நீங்கள் ஆதிக்கம் செலுத்தினீர்கள்';

  @override
  String get resultsHighlightGreatAccuracy =>
      'சிறந்த துல்லியம் - மிகவும் துல்லியமாக!';

  @override
  String get resultsHighlightKeepGoing =>
      'தொடருங்கள் - நிலைத்தன்மையும் வேகத்தை வெல்கிறது';

  @override
  String get resultsLeaderboardTitle => 'லீடர்போர்டு';

  @override
  String resultsPlayersCount(Object count) {
    return '$count வீரர்கள்';
  }

  @override
  String get resultsBackToCircles => 'Circles-க்குத் திரும்பு';

  @override
  String get resultsRematch => 'மீண்டும் விளையாடு';

  @override
  String get resultsPlayAgain => 'மீண்டும் விளையாடு';

  @override
  String get leaderboardGlobalTitle => 'உலகளாவிய லீடர்போர்டு';

  @override
  String get leaderboardEmpty => 'தரவரிசை இன்னும் இல்லை';

  @override
  String get aboutTitle => 'விவரம்';

  @override
  String aboutVersion(Object version) {
    return 'பதிப்பு $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ஒரு விளையாட்டு சார்ந்த மொழி கற்றல் தளம், புதிய மொழிகளில் தேர்ச்சி பெறுவதை வேடிக்கையாகவும் சமூகமாகவும் மாற்றுகிறது. Circles-ல் போட்டியிடவும், தனியாகப் பயிற்சி செய்யவும் மற்றும் உங்கள் முன்னேற்றத்தைக் கண்காணிக்கவும்.';

  @override
  String get aboutTerms => 'பயன்பாட்டு விதிமுறைகள்';

  @override
  String get aboutPrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get aboutOpenSource => 'திறந்த மூல உரிமங்கள்';

  @override
  String get addFriendTitle => 'நண்பரைச் சேர்';

  @override
  String get addFriendFindByUsername => 'பயனர்பெயர் மூலம் கண்டுபிடி';

  @override
  String get addFriendUsernameHint => 'பயனர்பெயரை உள்ளிடவும்...';

  @override
  String get addFriendTip =>
      'குறிப்பு: QR குறியீடு + நண்பர் ஐடி ஆதரவு விரைவில் வரும்';

  @override
  String get addFriendSending => 'அனுப்புகிறது...';

  @override
  String get addFriendSendRequest => 'கோரிக்கையை அனுப்பு';

  @override
  String addFriendUserNotFound(Object username) {
    return 'பயனர் @$username காணப்படவில்லை';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'செயல் தோல்வியடைந்தது அல்லது ஏற்கனவே அனுப்பப்பட்டது: $error';
  }

  @override
  String get friendsTitle => 'நண்பர்கள்';

  @override
  String get searchFriendsHint => 'நண்பர்களைத் தேடு...';

  @override
  String get somaLearnerSubtitle => 'Soma கற்பவர்';

  @override
  String get friendRequestLabel => 'கோரிக்கை';

  @override
  String get friendRequestSentLabel => 'கோரிக்கை அனுப்பப்பட்டது';

  @override
  String get friendIncomingRequestLabel => 'வரும் கோரிக்கை';

  @override
  String get friendRequestsSection => 'கோரிக்கைகள்';

  @override
  String get friendPendingSection => 'நிலுவையில்';

  @override
  String get friendAllSection => 'எல்லா நண்பர்களும்';

  @override
  String get friendsEmptyState =>
      'இன்னும் நண்பர்கள் இல்லை. உங்கள் முதல் நண்பரைச் சேர்க்கவும்!';

  @override
  String get friendsEmptyShort => 'இன்னும் நண்பர்கள் இல்லை';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\"-க்குப் பொருத்தங்கள் இல்லை';
  }

  @override
  String get inboxTitle => 'இன்பாக்ஸ்';

  @override
  String get searchChatsHint => 'அரட்டைகளைத் தேடு...';

  @override
  String get inboxEmptyState =>
      'இன்னும் அரட்டைகள் இல்லை. நண்பருடன் உரையாடலைத் துவங்குங்கள்!';

  @override
  String get newMessageTitle => 'புதிய செய்தி';

  @override
  String get chatCallLater => 'குரல் அழைப்பு விரைவில் (அடுத்த Circle குரல்)';

  @override
  String errorWithDetails(Object error) {
    return 'பிழை: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name-க்கு ஹலோ சொல்லுங்கள்!';
  }

  @override
  String get chatMessageHint => 'செய்தி...';

  @override
  String get notificationsTitle => 'அறிவிப்புகள்';

  @override
  String get notificationsTabAll => 'எல்லாம்';

  @override
  String get notificationsTabCourses => 'பாடத்திட்டங்கள்';

  @override
  String get notificationsTabSocial => 'சமூகம்';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'அமைப்பு';

  @override
  String get notificationsEmpty => 'அறிவிப்புகள் இல்லை';

  @override
  String get notificationsDeleted => 'அறிவிப்பு நீக்கப்பட்டது';

  @override
  String get notificationTitleFallback => 'அறிவிப்பு';

  @override
  String get notificationTypeCourse => 'பாடத்திட்டம்';

  @override
  String get notificationTypeSocial => 'சமூகம்';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'அமைப்பு';

  @override
  String get notificationsFriendAccepted => 'நட்பு கோரிக்கை ஏற்கப்பட்டது';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'நட்பு கோரிக்கையை ஏற்க முடியவில்லை: $error';
  }

  @override
  String get notificationsFriendDeclined => 'நட்பு கோரிக்கை நிராகரிக்கப்பட்டது';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'நட்பு கோரிக்கையை நிராகரிக்க முடியவில்லை: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle-ல் சேர முடியவில்லை: $error';
  }

  @override
  String get notificationsOpening => 'திறக்கிறது';

  @override
  String get notificationsOpened => 'திறக்கப்பட்டது';

  @override
  String notificationsActionMessage(Object action) {
    return '$action அறிவிப்பு';
  }

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get settingsSectionAccount => 'கணக்கு';

  @override
  String get settingsEditProfile => 'சுயவிவரத்தைத் தொகு';

  @override
  String get settingsPrivacy => 'தனியுரிமை';

  @override
  String get settingsSecurity => 'பாதுகாப்பு';

  @override
  String get settingsSectionGameplay => 'விளையாட்டு முறை';

  @override
  String get settingsShowTranslationLine => 'மொழிபெயர்ப்பு வரியைக் காட்டு';

  @override
  String get settingsShowReadingLine => 'வாசிப்பைக் காட்டு (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'கேள்விக்கான இயல்புநிலை டைமர்';

  @override
  String get settingsMatchDifficulty => 'போட்டி கடினத்தன்மை';

  @override
  String get settingsMatchDifficultyAdaptive => 'தகவமைக்கும்';

  @override
  String get settingsSectionSoundFeel => 'ஒலி & உணர்வு';

  @override
  String get settingsMusic => 'இசை';

  @override
  String get settingsSoundEffects => 'ஒலி விளைவுகள்';

  @override
  String get settingsHaptics => 'அதிர்வுகள்';

  @override
  String get settingsSectionNotifications => 'அறிவிப்புகள்';

  @override
  String get settingsPushNotifications => 'புஷ் அறிவிப்புகள்';

  @override
  String get settingsDailyReminder => 'தினசரி நினைவூட்டல்';

  @override
  String get settingsSectionAppearance => 'தோற்றம்';

  @override
  String get settingsTheme => 'தீம்';

  @override
  String get settingsUiLanguage => 'UI மொழி';

  @override
  String get settingsSectionAbout => 'பற்றி';

  @override
  String get settingsVersion => 'பதிப்பு';

  @override
  String get settingsTermsPrivacy => 'விதிமுறைகள் & தனியுரிமை';

  @override
  String get settingsSupport => 'ஆதரவு';

  @override
  String get settingsLogout => 'வெளியேறு';

  @override
  String get themeSystem => 'அமைப்பு';

  @override
  String get themeDark => 'டார்க்';

  @override
  String get themeLight => 'லைட்';

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
  String get languageTamil => 'தமிழ்';

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
  String get editProfileUpdated => 'சுயவிவரம் புதுப்பிக்கப்பட்டது';

  @override
  String get editProfileTitle => 'சுயவிவரத்தைத் தொகு';

  @override
  String get editProfilePhotoLabel => 'சுயவிவரப் படம்';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage வழியாக அவதார் தேர்வு விரைவில்';

  @override
  String get editProfileChangePhoto => 'மாற்று';

  @override
  String get editProfileAvatarUploadSoon => 'அவதார் பதிவேற்றம் விரைவில் வரும்';

  @override
  String get editProfileDisplayNameLabel => 'காட்சிப் பெயர்';

  @override
  String get editProfileDisplayNameHint => 'உங்கள் பெயர்';

  @override
  String get editProfileDisplayNameRequired => 'உங்கள் பெயரை உள்ளிடவும்';

  @override
  String get editProfileDisplayNameTooShort => 'மிகவும் சிறியது';

  @override
  String get editProfileUsernameLabel => 'பயனர்பெயர்';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'பயனர்பெயரை உள்ளிடவும்';

  @override
  String get editProfileUsernameTooShort => 'குறைந்தது 3 எழுத்துக்கள்';

  @override
  String get editProfileUsernameInvalid => 'எழுத்துக்கள், எண்கள், _ மட்டும்';

  @override
  String get editProfileBioLabel => 'வாழ்க்கைக்குறிப்பு';

  @override
  String get editProfileBioHint => 'ஒரு சிறிய குறிப்பு...';

  @override
  String get editProfileBioTooLong => 'அதிகபட்சம் 120 எழுத்துக்கள்';

  @override
  String get editProfileLocationLabel => 'இடம்';

  @override
  String get editProfileLocationHint => 'நகரம் / நாடு';

  @override
  String get editProfileDailyGoalTitle => 'தினசரி இலக்கு';

  @override
  String get editProfileDailyGoalSubtitle =>
      'தினமும் எத்தனை நிமிடங்கள் படிக்க விரும்புகிறீர்கள் என்பதைத் தேர்வுசெய்க';

  @override
  String get securityTitle => 'பாதுகாப்பு';

  @override
  String get securitySectionPassword => 'கடவுச்சொல்';

  @override
  String get securityChangePasswordTitle => 'கடவுச்சொல்லை மாற்று';

  @override
  String get securityChangePasswordSubtitle =>
      'உங்கள் கடவுச்சொல்லை ஒழுங்காகப் புதுப்பிக்கவும்';

  @override
  String get securitySectionTwoFactor => 'இரண்டு காரணி அங்கீகாரம்';

  @override
  String get securityEnable2faTitle => '2FA-ஐ இயக்கு';

  @override
  String get securityEnable2faSubtitle => 'உள்நுழையும்போது கூடுதல் பாதுகாப்பு';

  @override
  String get securitySectionAppLock => 'செயலி பூட்டு';

  @override
  String get securityBiometricTitle => 'பயோமெட்ரிக் திறப்பு';

  @override
  String get securityBiometricSubtitle =>
      'SOMA-ஐத் திறக்க FaceID/TouchID பயன்படுத்தவும்';

  @override
  String get securityAppLockTitle => 'செயலி பூட்டு';

  @override
  String get securityAppLockSubtitle =>
      'நீங்கள் வெளியேறும்போது SOMA-ஐப் பூட்டவும்';

  @override
  String get securitySectionSessions => 'செயலில் உள்ள அமர்வுகள்';

  @override
  String get securityNoSessions => 'செயலில் உள்ள அமர்வுகள் இல்லை';

  @override
  String get securityThisDevice => 'இந்தச் சாதனம்';

  @override
  String get securityDevice => 'சாதனம்';

  @override
  String get securityActiveLabel => 'செயலில்';

  @override
  String get securitySignInToEnable2fa => '2FA-ஐ இயக்க உள்நுழையவும்';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA-ஐ இயக்க முடியவில்லை: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA-ஐ முடக்க முடியவில்லை: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA அமைப்பு';

  @override
  String get securitySecretKeyLabel => 'ரகசிய விசை';

  @override
  String get securityCodeHint => '6-இலக்க குறியீடு';

  @override
  String get security2faEnabled => '2FA இயக்கப்பட்டது';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'குறியீட்டைச் சரிபார்க்க முடியவில்லை: $error';
  }

  @override
  String get securityVerifying => 'சரிபார்க்கிறது...';

  @override
  String get securityVerify => 'சரிபார்';

  @override
  String get securityCurrentPasswordHint => 'தற்போதைய கடவுச்சொல்';

  @override
  String get securityNewPasswordHint =>
      'புதிய கடவுச்சொல் (குறைந்தது 8 எழுத்துக்கள்)';

  @override
  String get securityConfirmPasswordHint =>
      'புதிய கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get securitySignInToChangePassword =>
      'கடவுச்சொல்லை மாற்ற உள்நுழையவும்';

  @override
  String get securityEnterCurrentPassword =>
      'உங்கள் தற்போதைய கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get securityPasswordMinLength =>
      'புதிய கடவுச்சொல் குறைந்தது 8 எழுத்துக்கள் இருக்க வேண்டும்';

  @override
  String get securityPasswordsDoNotMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை';

  @override
  String get securityPasswordUpdated => 'கடவுச்சொல் புதுப்பிக்கப்பட்டது';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'கடவுச்சொல்லைப் புதுப்பிக்க முடியவில்லை: $error';
  }

  @override
  String get securityAutoLockAfter => 'தானியங்கி பூட்டு நேரம்';

  @override
  String get privacyTitle => 'தனியுரிமை';

  @override
  String get privacySectionVisibility => 'தோற்றம்';

  @override
  String get privacyProfileVisibilityTitle => 'சுயவிவரத் தோற்றம்';

  @override
  String get privacyVisibilityPublic => 'பொது';

  @override
  String get privacyVisibilityFriends => 'நண்பர்கள்';

  @override
  String get privacyVisibilityPrivate => 'தனிப்பட்ட';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'யார் வேண்டுமானாலும் உங்கள் சுயவிவரத்தைப் பார்க்கலாம்';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'நண்பர்கள் மட்டுமே உங்கள் சுயவிவரத்தைப் பார்க்க முடியும்';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'நீங்கள் மட்டுமே உங்கள் சுயவிவரத்தைப் பார்க்க முடியும்';

  @override
  String get privacySectionActivity => 'செயல்பாடு';

  @override
  String get privacyShowOnlineTitle => 'ஆன்லைன் நிலையைத் காட்டு';

  @override
  String get privacyShowOnlineSubtitle =>
      'நீங்கள் ஆன்லைனில் இருப்பதை வீரர்கள் பார்க்க அனுமதி';

  @override
  String get privacyShowActivityTitle => 'கற்றல் செயல்பாட்டைக் காட்டு';

  @override
  String get privacyShowActivitySubtitle =>
      'தொடர், XP மற்றும் சமீபத்திய முன்னேற்றத்தைக் காட்டு';

  @override
  String get privacySectionSocial => 'சமூகம்';

  @override
  String get privacyAllowRequestsTitle => 'நட்பு கோரிக்கைகளை அனுமதி';

  @override
  String get privacyAllowRequestsSubtitle =>
      'மக்கள் உங்களுக்கு நட்பு கோரிக்கைகளை அனுப்ப அனுமதி';

  @override
  String get privacyWhoCanDmTitle => 'யார் DM அனுப்பலாம்';

  @override
  String get privacyDmEveryone => 'எல்லோரும்';

  @override
  String get privacyDmFriends => 'நண்பர்கள்';

  @override
  String get privacyDmNoOne => 'யாரும் இல்லை';

  @override
  String get privacyDmEveryoneSubtitle =>
      'யார் வேண்டுமானாலும் உங்களுக்கு செய்தி அனுப்பலாம்';

  @override
  String get privacyDmFriendsSubtitle =>
      'நண்பர்கள் மட்டுமே உங்களுக்கு செய்தி அனுப்ப முடியும்';

  @override
  String get privacyDmNoOneSubtitle =>
      'யாரும் உங்களுக்கு செய்தி அனுப்ப முடியாது';

  @override
  String get privacySectionBlockedUsers => 'தடுக்கப்பட்ட பயனர்கள்';

  @override
  String get privacyBlockedUsersComingSoon =>
      'தடுக்கப்பட்ட பயனர்கள் மேலாண்மை விரைவில்';

  @override
  String get privacySectionDataControls => 'தரவு கட்டுப்பாடுகள்';

  @override
  String get privacyExportDataTitle => 'எனது தரவை ஏற்றுமதி செய்';

  @override
  String get privacyExportDataSubtitle =>
      'உங்கள் செயல்பாடு மற்றும் பாடத்திட்டங்களைப் பதிவிறக்குங்கள்';

  @override
  String get privacyExportInfoTitle => 'தரவு ஏற்றுமதி';

  @override
  String get privacyExportInfoBody =>
      'அடுத்த கட்டம்: JSON/CSV ஏற்றுமதியை உருவாக்கி மின்னஞ்சல் அல்லது உள்ளூர் பதிவிறக்கம்';

  @override
  String get privacyDeleteAccountTitle => 'கணக்கை நீக்கு';

  @override
  String get privacyDeleteAccountSubtitle =>
      'இது உங்கள் கணக்கையும் தரவையும் நிரந்தரமாக நீக்கும்';

  @override
  String get privacyDeleteConfirmTitle => 'கணக்கை நீக்கவா?';

  @override
  String get privacyDeleteConfirmBody =>
      'இதை மாற்ற முடியாது. உங்கள் சுயவிவரம், பாடத்திட்டங்கள், நண்பர்கள் மற்றும் செய்திகள் நீக்கப்படும்';

  @override
  String get privacyDeleteComingSoon =>
      'நீக்குதல் பின்னர் Supabase உடன் இணைக்கப்படும்';

  @override
  String get soloLabel => 'தனி';

  @override
  String get soloResultsCompletedTitle => 'தனி அமர்வு முடிந்தது';

  @override
  String get soloResultsFeedbackElite =>
      'சிறப்பு செயல்திறன் - தொடரைத் தக்கவைக்கவும்';

  @override
  String get soloResultsFeedbackStrong => 'வலுவான வேலை - வேகமாக மேம்படுகிறது';

  @override
  String get soloResultsFeedbackProgress =>
      'நல்ல முன்னேற்றம் - பிழைகளை மதிப்பாய்வு செய்து மீண்டும் முயற்சிக்கவும்';

  @override
  String get soloResultsFeedbackTryAgain =>
      'அழுத்தம் இல்லை - குறைவான கேள்விகளுடன் மீண்டும் முயற்சிக்கவும் மற்றும் கவனம் செலுத்தவும்';

  @override
  String get soloResultsPerfectScore =>
      'முழு மதிப்பெண்! மதிப்பாய்வு செய்ய பிழைகள் இல்லை';

  @override
  String get soloResultsReviewPrompt =>
      'வேகமாகக் கற்க பிழைகளை மதிப்பாய்வு செய்யவும். உங்கள் தவறான பதில்கள் கீழே';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'பிழைகளை மதிப்பாய்வு செய் ($count)';
  }

  @override
  String get authNotSignedIn => 'உள்நுழையவில்லை';

  @override
  String get genericUser => 'பயனர்';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get edit => 'தொகு';

  @override
  String get send => 'அனுப்பு';

  @override
  String get join => 'சேர்';

  @override
  String get leave => 'விலகு';

  @override
  String get ready => 'தயார்';

  @override
  String get levelBeginner => 'தொடக்கநிலை';

  @override
  String get levelIntermediate => 'இடைநிலை';

  @override
  String get levelAdvanced => 'மேம்பட்ட';

  @override
  String questionsShort(Object count) {
    return '$count கேள்விகள்';
  }

  @override
  String secondsShort(Object count) {
    return '$count வினாடிகள்';
  }

  @override
  String get circlesAllCourses => 'எல்லா பாடத்திட்டங்களும்';

  @override
  String get circlesAllModes => 'எல்லா முறைகளும்';

  @override
  String get circlesAllLevels => 'எல்லா நிலைகளும்';

  @override
  String get circlesAddNewCourse => 'புதிய பாடத்திட்டத்தைச் சேர்';

  @override
  String get circlesCoursesTitle => 'பாடத்திட்டங்கள்';

  @override
  String get circlesModeTitle => 'முறை';

  @override
  String get circlesLevelTitle => 'நிலை';

  @override
  String get circlesNoActiveForFilters =>
      'இந்த வடிப்பான்களுக்கு செயலில் உள்ள Circle இல்லை';

  @override
  String get circlesUnknownRoom => 'தெரியாத அறை';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle உருவாக்கு';

  @override
  String get circlesCircleName => 'Circle பெயர்';

  @override
  String get circlesEnterName => 'பெயரை உள்ளிடுக';

  @override
  String get circlesLanguages => 'மொழிகள்';

  @override
  String get circlesRoomSetup => 'அறை அமைப்பு';

  @override
  String get circlesPlayers => 'வீரர்கள்';

  @override
  String get circlesEmptySlot => 'காலியிடம்';

  @override
  String get circlesPlayersRange => '1-5 வீரர்கள்';

  @override
  String get circlesQuestions => 'கேள்விகள்';

  @override
  String get circlesQuestionsSubtitle => 'கேள்விகள் எண்ணிக்கை';

  @override
  String get circlesTimePerQuestion => 'கேள்விக்கான நேரம்';

  @override
  String get circlesSecondsPerQuestion => 'வினாடி/கேள்வி';

  @override
  String get circlesAdvanced => 'மேம்பட்ட';

  @override
  String get circlesAllowSpectators => 'பார்வையாளர்களை அனுமதி';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Let others watch without playing.';

  @override
  String get circlesLiveVoiceChat => 'நேரலை குரல் அரட்டை';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'போட்டிகளின் போது குரல் தொடர்புகளை இயக்கு';

  @override
  String get circlesLiveTextChat => 'நேரலை உரை அரட்டை';

  @override
  String get circlesLiveTextChatSubtitle => 'போட்டிகளின் போது அரட்டையை இயக்கு';

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
  String get circlesCreatedSuccess => 'Circle உருவாக்கப்பட்டது';

  @override
  String circlesCreateError(Object error) {
    return 'Circle உருவாக்கத்தை தோல்வி: $error';
  }

  @override
  String get circlesHostTip =>
      'குறிப்பு: உருவாக்கிய பிறகு நண்பர்களை அழைக்கலாம்';

  @override
  String circlesJoinError(Object error) {
    return 'Circle-ல் சேர முடியவில்லை: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle காத்திருப்பு அறை';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'குறியீடு: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'போட்டி அமைப்புகள்';

  @override
  String circlesLevelWithValue(Object level) {
    return 'நிலை $level';
  }

  @override
  String get circlesDifficulty => 'கடினத்தன்மை';

  @override
  String get circlesPerQuestionShort => 'ஒவ்வொரு கேள்விக்கும்';

  @override
  String get circlesInvite => 'அழை';

  @override
  String get circlesCopyId => 'ஐடியை நகலெடு';

  @override
  String get circlesCopiedId => 'ஐடி நகலெடுக்கப்பட்டது';

  @override
  String get circlesMatchInProgress => 'போட்டி நடைபெறுகிறது';

  @override
  String get circlesSpectatorQueuedBody =>
      'போட்டி நடைபெறுகிறது. நீங்கள் பார்வையாளராகச் சேருவீர்கள்';

  @override
  String get circlesHostStartWhenReady =>
      'அனைவரும் தயாரானதும் தொகுppாளர் துவங்குவார்';

  @override
  String get circlesSpectators => 'பார்வையாளர்கள்';

  @override
  String get circlesSpectator => 'பார்வையாளர்';

  @override
  String get circlesSpectatorCanWatch => 'பார்வையாளர்கள் நேரலையில் பார்க்கலாம்';

  @override
  String get circlesJoinRequests => 'சேரும் கோரிக்கைகள்';

  @override
  String get circlesAcceptSpectatorsHint =>
      'போட்டியைத் துவங்கும் முன் பார்வையாளர்களை ஏற்கவும்';

  @override
  String get circlesStartGame => 'விளையாட்டைத் துவங்கு';

  @override
  String get circlesWaitingForPlayers => 'வீரர்களுக்காகக் காத்திருக்கிறது';

  @override
  String get circlesLeaveCircle => 'Circle-லிருந்து விலகு';

  @override
  String get circlesRequestSent => 'கோரிக்கை அனுப்பப்பட்டது';

  @override
  String get circlesRequestToJoin => 'சேரக் கோரிக்கை';

  @override
  String get circlesWatchLive => 'நேரலையில் பார்';

  @override
  String get circlesPlayerTip =>
      'நீங்கள் தயாரானதும் \'தயார்\' அழுத்தவும். தொகுப்பாளர் போட்டியைத் துவங்குவார்';

  @override
  String get circlesSpectatorTip =>
      'நீங்கள் பார்க்கிறீர்கள். தொகுப்பாளர் துவங்கியதும் நேரலையில் பாருங்கள்';

  @override
  String get circlesHostControls => 'தொகுப்பாளர் கட்டுப்பாடுகள்';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'தொகுப்பாளரை மாற்ற முடியவில்லை: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle-ஐ முடிக்க முடியவில்லை: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'பயனர் @$username காணப்படவில்லை';
  }

  @override
  String get circlesInvalidUser => 'செல்லுபடியாகாத பயனர்';

  @override
  String get circlesCantInviteSelf => 'உங்களை நீங்களே அழைக்க முடியாது';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username ஏற்கனவே Circle-ல் உள்ளார்';
  }

  @override
  String get circlesDefaultHost => 'தொகுப்பாளர்';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'பயனர்பெயர் மூலம் அழை';

  @override
  String circlesInviteSent(Object username) {
    return '@$username-க்கு அழைப்பு அனுப்பப்பட்டது';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'அழைப்பு அனுப்புவதில் தோல்வி: $error';
  }

  @override
  String get circlesJoinRequestSent => 'சேரும் கோரிக்கை அனுப்பப்பட்டது';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'கோரிக்கை அனுப்புவதில் தோல்வி: $error';
  }

  @override
  String get circlesFull => 'Circle நிரம்பியுள்ளது';

  @override
  String get circlesSpectatorAdded => 'பார்வையாளர் சேர்க்கப்பட்டார்';

  @override
  String circlesApproveFailed(Object error) {
    return 'ஏற்க முடியவில்லை: $error';
  }

  @override
  String get circlesRequestDeclined => 'கோரிக்கை நிராகரிக்கப்பட்டது';

  @override
  String circlesDeclineFailed(Object error) {
    return 'நிராகரிக்க முடியவில்லை: $error';
  }

  @override
  String get circlesParticipant => 'பங்கேற்பாளர்';

  @override
  String get circlesLeavePromptTitle => 'Circle-லிருந்து விலகவா?';

  @override
  String get circlesLeavePromptTransfer => 'விலகும் முன் தொகுப்பாளரை மாற்றவும்';

  @override
  String get circlesLeavePromptEndOnly => 'Circle-ஐ முடித்து வெளியேறு';

  @override
  String get circlesTransferHost => 'தொகுப்பாளரை மாற்று';

  @override
  String get circlesEndCircle => 'Circle-ஐ முடி';

  @override
  String get circlesTransferHostTitle => 'தொகுப்பாளர் மாற்றம்';

  @override
  String circlesShareId(Object id) {
    return 'Circle ஐடி: $id';
  }
}
