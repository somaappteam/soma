// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'सीखें। प्रतिस्पर्धा करें। महारत हासिल करें।';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get authFillAllFields => 'कृपया सभी फ़ील्ड भरें';

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
    return 'त्रुटि: $error';
  }

  @override
  String get authEmail => 'ईमेल';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authUsername => 'उपयोगकर्ता नाम';

  @override
  String get authContinue => 'जारी रखें';

  @override
  String get authSigningIn => 'साइन इन हो रहा है...';

  @override
  String get authCreateAccount => 'खाता बनाएं';

  @override
  String get authCreating => 'बना रहे हैं...';

  @override
  String get authNeedAccount => 'खाता नहीं है? ';

  @override
  String get authHaveAccount => 'पहले से खाता है? ';

  @override
  String get dialogAuthRequiredTitle =>
      'Circles तक पहुंचने के लिए साइन इन करें';

  @override
  String get dialogAuthRequiredBody =>
      'Circles मल्टीप्लेयर रूम हैं। लाइव मैच में शामिल होने, दोस्तों को आमंत्रित करने और प्रगति सहेजने के लिए एक खाता बनाएं।';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get navHome => 'होम';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'कोर्स हटाएं?';

  @override
  String removeCourseBody(Object course) {
    return '$course होम सूची से हटाया जाएगा।';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get remove => 'हटाएं';

  @override
  String welcomeBack(Object name) {
    return 'वापस स्वागत है, $name!';
  }

  @override
  String get editCourses => 'कोर्स संपादित करें';

  @override
  String get done => 'हो गया';

  @override
  String get noCoursesToEdit => 'संपादित करने के लिए कोई कोर्स नहीं।';

  @override
  String get addCourse => 'कोर्स जोड़ें';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get iSpeak => 'मैं बोलता/बोलती हूं';

  @override
  String get iWantToLearn => 'मैं सीखना चाहता/चाहती हूं';

  @override
  String get chooseYourLanguage => 'अपनी भाषा चुनें';

  @override
  String get chooseLearningLanguage => 'वह भाषा चुनें जो आप सीखना चाहते हैं';

  @override
  String get chooseTwoDifferentLanguages => 'दो अलग-अलग भाषाएं चुनें।';

  @override
  String get createCourse => 'कोर्स बनाएं';

  @override
  String get soloCourseTitle => 'एकल कोर्स';

  @override
  String get searchLanguage => 'भाषा खोजें';

  @override
  String get noMatches => 'कोई मिलान नहीं';

  @override
  String get chooseCourseType => 'कोर्स प्रकार चुनें';

  @override
  String get soloStudyDescription =>
      'Circles-शैली क्विज़ के साथ अकेले अध्ययन करें - लेकिन कमरे या चैट या दर्शकों या होस्ट विकल्पों के बिना।';

  @override
  String get soloModeVocabulary => 'शब्दावली';

  @override
  String get soloModeSentences => 'वाक्य';

  @override
  String get soloModeReview => 'समीक्षा';

  @override
  String get soloModeVocabularySubtitle =>
      'अर्थ, समानार्थी शब्द और उपयोग के लिए बहुविकल्पी';

  @override
  String get soloModeSentencesSubtitle => 'रिक्त स्थान भरें + अनुवाद + पढ़ना';

  @override
  String get soloModeReviewDescription =>
      'जो आपने सीखा है उसका अभ्यास करें: कमजोर शब्द, हाल की गलतियां और स्पेस्ड रिपीटिशन।';

  @override
  String get startReview => 'समीक्षा शुरू करें';

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
    return '$mode सेटअप';
  }

  @override
  String get difficulty => 'कठिनाई';

  @override
  String get numberOfQuestions => 'प्रश्नों की संख्या';

  @override
  String get timerPerQuestion => 'प्रति प्रश्न टाइमर';

  @override
  String get noTimer => 'टाइमर नहीं';

  @override
  String get start => 'शुरू करें';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileSignInToMessage => 'संदेश भेजने के लिए साइन इन करें';

  @override
  String get profileThatsYourProfile => 'यह आपकी प्रोफ़ाइल है';

  @override
  String get profileSignInToAddFriends => 'दोस्त जोड़ने के लिए साइन इन करें';

  @override
  String get profileCantAddYourself => 'आप खुद को नहीं जोड़ सकते';

  @override
  String profileRequestSent(Object username) {
    return '@$username को अनुरोध भेजा गया';
  }

  @override
  String get profileRequestFailed => 'अनुरोध भेजने में विफल';

  @override
  String get profileDefaultDisplayName => 'नया उपयोगकर्ता';

  @override
  String get profileDefaultBio => 'सीखने के लिए तैयार!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'अतिथि';

  @override
  String get guestUsername => 'अतिथि';

  @override
  String get guestSessionLabel => 'अतिथि सत्र';

  @override
  String get unlockFullProfile => 'अपनी पूर्ण प्रोफ़ाइल अनलॉक करें';

  @override
  String get guestBenefitSync => 'सभी डिवाइसों पर प्रगति सिंक करें';

  @override
  String get guestBenefitCircles => 'Circles में शामिल हों और लाइव खेलें';

  @override
  String get guestBenefitNotifications =>
      'सूचनाएं और मित्र अनुरोध प्राप्त करें';

  @override
  String get progressStaysOnDevice =>
      'जब तक आप साइन इन नहीं करते, प्रगति इस डिवाइस पर रहती है।';

  @override
  String profileGoalLabel(Object minutes) {
    return 'लक्ष्य: $minutesमि';
  }

  @override
  String get profileXpProgress => 'XP प्रगति';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'जीत';

  @override
  String get profileStreak => 'लकीर';

  @override
  String get profileFriendsTitle => 'मेरे दोस्त';

  @override
  String get profileViewAll => 'सभी देखें';

  @override
  String get profileAchievementsTitle => 'उपलब्धियाँ';

  @override
  String get profileNoAchievements => 'अभी तक कोई उपलब्धि नहीं।';

  @override
  String get profileRequested => 'अनुरोध किया गया';

  @override
  String get profileSending => 'भेज रहे हैं...';

  @override
  String get profileAddFriend => 'दोस्त जोड़ें';

  @override
  String get profileConnectTitle => 'कनेक्ट करें';

  @override
  String get profileMessage => 'संदेश';

  @override
  String get profileSnapshot => 'प्रोफ़ाइल स्नैपशॉट';

  @override
  String get profileLocationHidden => 'स्थान छिपा हुआ';

  @override
  String get profileBioHidden => 'जीवनी छिपी हुई';

  @override
  String profileDailyGoal(Object minutes) {
    return 'दैनिक लक्ष्य $minutesमि';
  }

  @override
  String get circleInviteTitle => 'Circle आमंत्रण';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'शामिल होने के लिए साइन इन करें';

  @override
  String get joiningCircle => 'शामिल हो रहे हैं...';

  @override
  String get joinCircle => 'Circle में शामिल हों';

  @override
  String get circleJoinedAsPlayer => 'खिलाड़ी के रूप में शामिल हुए';

  @override
  String get circleJoinedAsSpectator => 'दर्शक के रूप में शामिल हुए';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get open => 'खोलें';

  @override
  String get circleCountdownTitle => 'तैयार हो जाएं';

  @override
  String get circleCountdownSubtitle => 'Circle शुरू हो रहा है...';

  @override
  String get userFallbackName => 'उपयोगकर्ता';

  @override
  String get micOff => 'माइक बंद';

  @override
  String get micOn => 'माइक चालू';

  @override
  String get roleHost => 'होस्ट';

  @override
  String get roleSpectator => 'दर्शक';

  @override
  String get tagHost => 'होस्ट';

  @override
  String get tagYou => 'आप';

  @override
  String get statusCorrect => 'सही';

  @override
  String get statusWrong => 'गलत';

  @override
  String get statusWaiting => 'प्रतीक्षा कर रहे हैं';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'अंक';

  @override
  String get pointsLabel => 'अंक';

  @override
  String get statCorrect => 'सही';

  @override
  String get statAnswers => 'उत्तर';

  @override
  String get statTotal => 'कुल';

  @override
  String get statQuestions => 'प्रश्न';

  @override
  String get statAccuracy => 'सटीकता';

  @override
  String get statRate => 'दर';

  @override
  String get statRank => 'रैंक';

  @override
  String get statPosition => 'स्थिति';

  @override
  String get statMode => 'मोड';

  @override
  String get statType => 'प्रकार';

  @override
  String get next => 'अगला';

  @override
  String get submit => 'जमा करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get save => 'सहेजें';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get backToCourse => 'कोर्स पर वापस जाएं';

  @override
  String get resultsTitle => 'परिणाम';

  @override
  String get shareLater => 'बाद में साझा करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get ok => 'ठीक है';

  @override
  String minutesShort(Object minutes) {
    return '$minutesमि';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$countमि';
  }

  @override
  String timeShortHours(Object count) {
    return '$countघं';
  }

  @override
  String timeShortDays(Object count) {
    return '$countदि';
  }

  @override
  String get timeJustNow => 'अभी';

  @override
  String timeMinutesAgo(Object count) {
    return '$countमि पहले';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$countघं पहले';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$countदि पहले';
  }

  @override
  String get liveQuizWaitingForHost => 'होस्ट की प्रतीक्षा कर रहे हैं...';

  @override
  String get liveQuizJoinRequestSent => 'शामिल होने का अनुरोध भेजा गया';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'अनुरोध विफल: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'होस्ट नियंत्रण';

  @override
  String get liveQuizSpectatorModeTitle => 'दर्शक मोड';

  @override
  String get liveQuizHostControlsSubtitle =>
      'जब सभी उत्तर देते हैं या समय समाप्त होता है तो राउंड स्वचालित रूप से आगे बढ़ता है।';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'प्रश्न और लीडरबोर्ड लाइव देखें। आप उत्तर नहीं दे सकते।';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'प्रश्न $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'अनुरोध भेजा गया';

  @override
  String get liveQuizRequestToJoin => 'शामिल होने का अनुरोध';

  @override
  String get liveQuizSpectatorFooter =>
      'आप लाइव देख रहे हैं। प्रश्न और लीडरबोर्ड का आनंद लें।';

  @override
  String get circleNotFound => 'Circle नहीं मिला';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'रीमैच शुरू करने में विफल: $error';
  }

  @override
  String get resultsMatchTitle => 'मैच परिणाम';

  @override
  String resultsNiceWork(Object name) {
    return 'बढ़िया काम, $name';
  }

  @override
  String get resultsPlaceFirst => 'पहला स्थान';

  @override
  String get resultsPlaceSecond => 'दूसरा स्थान';

  @override
  String get resultsPlaceThird => 'तीसरा स्थान';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankवां स्थान';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players खिलाड़ियों में से';
  }

  @override
  String get resultsHighlightChampion => 'चैंपियन! आपने इस Circle पर हावी रहे।';

  @override
  String get resultsHighlightGreatAccuracy =>
      'शानदार सटीकता। आप शीर्ष के करीब हैं!';

  @override
  String get resultsHighlightKeepGoing =>
      'जारी रखें - स्थिरता गति को हराती है।';

  @override
  String get resultsLeaderboardTitle => 'लीडरबोर्ड';

  @override
  String resultsPlayersCount(Object count) {
    return '$count खिलाड़ी';
  }

  @override
  String get resultsBackToCircles => 'Circles पर वापस जाएं';

  @override
  String get resultsRematch => 'रीमैच';

  @override
  String get resultsPlayAgain => 'फिर से खेलें';

  @override
  String get leaderboardGlobalTitle => 'वैश्विक लीडरबोर्ड';

  @override
  String get leaderboardEmpty => 'अभी तक कोई लीडरबोर्ड नहीं।';

  @override
  String get aboutTitle => 'के बारे में';

  @override
  String aboutVersion(Object version) {
    return 'संस्करण $version';
  }

  @override
  String get aboutDescription =>
      'SOMA एक गेमिफाइड भाषा सीखने का मंच है जो नई भाषाओं में महारत हासिल करना मजेदार और सामाजिक बनाता है। Circles में शामिल हों, अकेले अभ्यास करें और अपनी प्रगति को ट्रैक करें।';

  @override
  String get aboutTerms => 'सेवा की शर्तें';

  @override
  String get aboutPrivacy => 'गोपनीयता नीति';

  @override
  String get aboutOpenSource => 'ओपन सोर्स लाइसेंस';

  @override
  String get addFriendTitle => 'दोस्त जोड़ें';

  @override
  String get addFriendFindByUsername => 'उपयोगकर्ता नाम से खोजें';

  @override
  String get addFriendUsernameHint => 'उपयोगकर्ता नाम दर्ज करें...';

  @override
  String get addFriendTip =>
      'टिप: बाद में हम QR कोड + मित्र ID का समर्थन कर सकते हैं।';

  @override
  String get addFriendSending => 'भेज रहे हैं...';

  @override
  String get addFriendSendRequest => 'अनुरोध भेजें';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username नहीं मिला';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'कार्य विफल या पहले से भेजा गया: $error';
  }

  @override
  String get friendsTitle => 'दोस्त';

  @override
  String get searchFriendsHint => 'दोस्तों को खोजें...';

  @override
  String get somaLearnerSubtitle => 'Soma शिक्षार्थी';

  @override
  String get friendRequestLabel => 'अनुरोध';

  @override
  String get friendRequestSentLabel => 'अनुरोध भेजा गया';

  @override
  String get friendIncomingRequestLabel => 'आने वाला अनुरोध';

  @override
  String get friendRequestsSection => 'अनुरोध';

  @override
  String get friendPendingSection => 'लंबित';

  @override
  String get friendAllSection => 'सभी दोस्त';

  @override
  String get friendsEmptyState =>
      'अभी तक कोई दोस्त नहीं। अपना पहला दोस्त जोड़ें!';

  @override
  String get friendsEmptyShort => 'अभी तक कोई दोस्त नहीं।';

  @override
  String noMatchForQuery(Object query) {
    return '\"$query\" के लिए कोई मिलान नहीं';
  }

  @override
  String get inboxTitle => 'इनबॉक्स';

  @override
  String get searchChatsHint => 'चैट खोजें...';

  @override
  String get inboxEmptyState =>
      'अभी तक कोई चैट नहीं। किसी दोस्त के साथ चैट शुरू करें!';

  @override
  String get newMessageTitle => 'नया संदेश';

  @override
  String get chatCallLater => 'बाद में वॉयस कॉल (Circle भाषा जल्द आ रही है)';

  @override
  String errorWithDetails(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name को हाय कहें!';
  }

  @override
  String get chatMessageHint => 'संदेश...';

  @override
  String get notificationsTitle => 'सूचनाएं';

  @override
  String get notificationsTabAll => 'सभी';

  @override
  String get notificationsTabCourses => 'कोर्स';

  @override
  String get notificationsTabSocial => 'सामाजिक';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'सिस्टम';

  @override
  String get notificationsEmpty => 'यहां कोई सूचना नहीं।';

  @override
  String get notificationsDeleted => 'सूचना हटाई गई';

  @override
  String get notificationTitleFallback => 'सूचना';

  @override
  String get notificationTypeCourse => 'कोर्स';

  @override
  String get notificationTypeSocial => 'सामाजिक';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'सिस्टम';

  @override
  String get notificationsFriendAccepted => 'मित्र अनुरोध स्वीकार किया गया';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'मित्र अनुरोध स्वीकार करने में विफल: $error';
  }

  @override
  String get notificationsFriendDeclined => 'मित्र अनुरोध अस्वीकार किया गया';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'मित्र अनुरोध अस्वीकार करने में विफल: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle में शामिल होने में विफल: $error';
  }

  @override
  String get notificationsOpening => 'खोल रहे हैं';

  @override
  String get notificationsOpened => 'खोला गया';

  @override
  String notificationsActionMessage(Object action) {
    return '$action सूचना';
  }

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSectionAccount => 'खाता';

  @override
  String get settingsEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get settingsPrivacy => 'गोपनीयता';

  @override
  String get settingsSecurity => 'सुरक्षा';

  @override
  String get settingsSectionGameplay => 'गेमप्ले';

  @override
  String get settingsShowTranslationLine => 'अनुवाद पंक्ति दिखाएं';

  @override
  String get settingsShowReadingLine => 'पढ़ना दिखाएं (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'प्रति प्रश्न डिफ़ॉल्ट टाइमर';

  @override
  String get settingsMatchDifficulty => 'मैच कठिनाई';

  @override
  String get settingsMatchDifficultyAdaptive => 'अनुकूली';

  @override
  String get settingsSectionSoundFeel => 'ध्वनि और अनुभव';

  @override
  String get settingsMusic => 'संगीत';

  @override
  String get settingsSoundEffects => 'ध्वनि प्रभाव';

  @override
  String get settingsHaptics => 'हैप्टिक्स';

  @override
  String get settingsSectionNotifications => 'सूचनाएं';

  @override
  String get settingsPushNotifications => 'पुश सूचनाएं';

  @override
  String get settingsDailyReminder => 'दैनिक अनुस्मारक';

  @override
  String get settingsSectionAppearance => 'दिखावट';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsUiLanguage => 'UI भाषा';

  @override
  String get settingsSectionAbout => 'के बारे में';

  @override
  String get settingsVersion => 'संस्करण';

  @override
  String get settingsTermsPrivacy => 'शर्तें और गोपनीयता';

  @override
  String get settingsSupport => 'सहायता';

  @override
  String get settingsLogout => 'लॉग आउट';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeDark => 'गहरा';

  @override
  String get themeLight => 'हल्का';

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
  String get editProfileUpdated => 'प्रोफ़ाइल अपडेट की गई';

  @override
  String get editProfileTitle => 'प्रोफ़ाइल संपादित करें';

  @override
  String get editProfilePhotoLabel => 'प्रोफ़ाइल फ़ोटो';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase स्टोरेज के माध्यम से अवतार चयन जल्द आ रहा है।';

  @override
  String get editProfileChangePhoto => 'बदलें';

  @override
  String get editProfileAvatarUploadSoon => 'अवतार अपलोड जल्द आ रहा है';

  @override
  String get editProfileDisplayNameLabel => 'प्रदर्शन नाम';

  @override
  String get editProfileDisplayNameHint => 'आपका नाम';

  @override
  String get editProfileDisplayNameRequired => 'अपना नाम दर्ज करें';

  @override
  String get editProfileDisplayNameTooShort => 'बहुत छोटा';

  @override
  String get editProfileUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get editProfileUsernameHint => 'राज_सीखने_वाला';

  @override
  String get editProfileUsernameRequired => 'उपयोगकर्ता नाम दर्ज करें';

  @override
  String get editProfileUsernameTooShort => 'कम से कम 3 वर्ण';

  @override
  String get editProfileUsernameInvalid => 'केवल अक्षर, संख्याएं और _';

  @override
  String get editProfileBioLabel => 'जीवनी';

  @override
  String get editProfileBioHint => 'एक छोटी जीवनी...';

  @override
  String get editProfileBioTooLong => 'अधिकतम 120 वर्ण';

  @override
  String get editProfileLocationLabel => 'स्थान';

  @override
  String get editProfileLocationHint => 'शहर / देश';

  @override
  String get editProfileDailyGoalTitle => 'दैनिक लक्ष्य';

  @override
  String get editProfileDailyGoalSubtitle =>
      'चुनें कि आप प्रतिदिन कितने मिनट अध्ययन करना चाहते हैं।';

  @override
  String get securityTitle => 'सुरक्षा';

  @override
  String get securitySectionPassword => 'पासवर्ड';

  @override
  String get securityChangePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get securityChangePasswordSubtitle =>
      'नियमित रूप से पासवर्ड अपडेट करें।';

  @override
  String get securitySectionTwoFactor => 'टू-फैक्टर प्रमाणीकरण';

  @override
  String get securityEnable2faTitle => '2FA सक्षम करें';

  @override
  String get securityEnable2faSubtitle => 'साइन इन करते समय अतिरिक्त सुरक्षा।';

  @override
  String get securitySectionAppLock => 'ऐप लॉक';

  @override
  String get securityBiometricTitle => 'बायोमेट्रिक अनलॉक';

  @override
  String get securityBiometricSubtitle =>
      'SOMA को अनलॉक करने के लिए FaceID/TouchID का उपयोग करें।';

  @override
  String get securityAppLockTitle => 'ऐप लॉक';

  @override
  String get securityAppLockSubtitle =>
      'ऐप से बाहर निकलने पर SOMA को लॉक करें।';

  @override
  String get securitySectionSessions => 'सक्रिय सत्र';

  @override
  String get securityNoSessions => 'कोई सक्रिय सत्र नहीं मिला।';

  @override
  String get securityThisDevice => 'यह डिवाइस';

  @override
  String get securityDevice => 'डिवाइस';

  @override
  String get securityActiveLabel => 'सक्रिय';

  @override
  String get securitySignInToEnable2fa => '2FA सक्षम करने के लिए साइन इन करें';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA सक्षम करने में विफल: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA अक्षम करने में विफल: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA सेटअप';

  @override
  String get securitySecretKeyLabel => 'गुप्त कुंजी';

  @override
  String get securityCodeHint => '6-अंक कोड';

  @override
  String get security2faEnabled => '2FA सक्षम किया गया';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'कोड सत्यापित करने में विफल: $error';
  }

  @override
  String get securityVerifying => 'सत्यापित कर रहे हैं...';

  @override
  String get securityVerify => 'सत्यापित करें';

  @override
  String get securityCurrentPasswordHint => 'मौजूदा पासवर्ड';

  @override
  String get securityNewPasswordHint => 'नया पासवर्ड (कम से कम 8 वर्ण)';

  @override
  String get securityConfirmPasswordHint => 'नया पासवर्ड की पुष्टि करें';

  @override
  String get securitySignInToChangePassword =>
      'पासवर्ड बदलने के लिए साइन इन करें';

  @override
  String get securityEnterCurrentPassword => 'मौजूदा पासवर्ड दर्ज करें';

  @override
  String get securityPasswordMinLength =>
      'नया पासवर्ड कम से कम 8 वर्ण का होना चाहिए';

  @override
  String get securityPasswordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get securityPasswordUpdated => 'पासवर्ड अपडेट किया गया';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'पासवर्ड अपडेट करने में विफल: $error';
  }

  @override
  String get securityAutoLockAfter => 'इसके बाद स्वतः लॉक करें';

  @override
  String get privacyTitle => 'गोपनीयता';

  @override
  String get privacySectionVisibility => 'दृश्यता';

  @override
  String get privacyProfileVisibilityTitle => 'प्रोफ़ाइल दृश्यता';

  @override
  String get privacyVisibilityPublic => 'सार्वजनिक';

  @override
  String get privacyVisibilityFriends => 'दोस्त';

  @override
  String get privacyVisibilityPrivate => 'निजी';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'कोई भी आपकी प्रोफ़ाइल देख सकता है।';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'केवल दोस्त आपकी प्रोफ़ाइल देख सकते हैं।';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'केवल आप अपनी प्रोफ़ाइल देख सकते हैं।';

  @override
  String get privacySectionActivity => 'गतिविधि';

  @override
  String get privacyShowOnlineTitle => 'ऑनलाइन स्थिति दिखाएं';

  @override
  String get privacyShowOnlineSubtitle =>
      'दूसरों को देखने दें कि आप कब ऑनलाइन हैं।';

  @override
  String get privacyShowActivityTitle => 'सीखने की गतिविधि दिखाएं';

  @override
  String get privacyShowActivitySubtitle =>
      'लकीर, XP और वर्तमान प्रगति प्रदर्शित करें।';

  @override
  String get privacySectionSocial => 'सामाजिक';

  @override
  String get privacyAllowRequestsTitle => 'मित्र अनुरोधों की अनुमति दें';

  @override
  String get privacyAllowRequestsSubtitle => 'लोगों को मित्र अनुरोध भेजने दें।';

  @override
  String get privacyWhoCanDmTitle => 'कौन DM कर सकता है';

  @override
  String get privacyDmEveryone => 'सभी';

  @override
  String get privacyDmFriends => 'दोस्त';

  @override
  String get privacyDmNoOne => 'कोई नहीं';

  @override
  String get privacyDmEveryoneSubtitle => 'कोई भी आपको DM कर सकता है।';

  @override
  String get privacyDmFriendsSubtitle => 'केवल दोस्त आपको DM कर सकते हैं।';

  @override
  String get privacyDmNoOneSubtitle => 'कोई भी आपको DM नहीं कर सकता।';

  @override
  String get privacySectionBlockedUsers => 'ब्लॉक किए गए उपयोगकर्ता';

  @override
  String get privacyBlockedUsersComingSoon =>
      'ब्लॉक किए गए उपयोगकर्ताओं का प्रबंधन जल्द आ रहा है।';

  @override
  String get privacySectionDataControls => 'डेटा नियंत्रण';

  @override
  String get privacyExportDataTitle => 'मेरा डेटा निर्यात करें';

  @override
  String get privacyExportDataSubtitle => 'अपनी गतिविधि और कोर्स डाउनलोड करें।';

  @override
  String get privacyExportInfoTitle => 'डेटा निर्यात';

  @override
  String get privacyExportInfoBody =>
      'अगला कदम: JSON/CSV निर्यात बनाएं और ईमेल के माध्यम से भेजें या स्थानीय रूप से डाउनलोड करें।';

  @override
  String get privacyDeleteAccountTitle => 'खाता हटाएं';

  @override
  String get privacyDeleteAccountSubtitle =>
      'यह आपके खाते और डेटा को स्थायी रूप से हटा देगा।';

  @override
  String get privacyDeleteConfirmTitle => 'खाता हटाएं?';

  @override
  String get privacyDeleteConfirmBody =>
      'यह क्रिया स्थायी है। आपकी प्रोफ़ाइल, कोर्स, दोस्त और संदेश हटा दिए जाएंगे।';

  @override
  String get privacyDeleteComingSoon =>
      'बाद में Supabase से हटाने को वायर किया जाएगा';

  @override
  String get soloLabel => 'एकल';

  @override
  String get soloResultsCompletedTitle => 'एकल सत्र पूर्ण';

  @override
  String get soloResultsFeedbackElite => 'एलीट प्रदर्शन। लकीर बनाए रखें।';

  @override
  String get soloResultsFeedbackStrong =>
      'मजबूत काम। आप तेजी से सुधार कर रहे हैं।';

  @override
  String get soloResultsFeedbackProgress =>
      'अच्छी प्रगति। गलतियों की समीक्षा करें और दोहराएं।';

  @override
  String get soloResultsFeedbackTryAgain =>
      'कोई तनाव नहीं। कम प्रश्नों और फोकस के साथ फिर से प्रयास करें।';

  @override
  String get soloResultsPerfectScore =>
      'परफेक्ट स्कोर! समीक्षा करने के लिए कोई गलती नहीं।';

  @override
  String get soloResultsReviewPrompt =>
      'तेजी से सीखने के लिए गलतियों की समीक्षा करें। हम नीचे गलत उत्तर दिखाएंगे।';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'गलतियों की समीक्षा ($count)';
  }

  @override
  String get authNotSignedIn => 'साइन इन नहीं किया गया';

  @override
  String get genericUser => 'उपयोगकर्ता';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get edit => 'संपादित करें';

  @override
  String get send => 'भेजें';

  @override
  String get join => 'शामिल हों';

  @override
  String get leave => 'छोड़ें';

  @override
  String get ready => 'तैयार';

  @override
  String get levelBeginner => 'शुरुआती';

  @override
  String get levelIntermediate => 'मध्यवर्ती';

  @override
  String get levelAdvanced => 'उन्नत';

  @override
  String questionsShort(Object count) {
    return '$count प्र';
  }

  @override
  String secondsShort(Object count) {
    return '$countसे';
  }

  @override
  String get circlesAllCourses => 'सभी कोर्स';

  @override
  String get circlesAllModes => 'सभी मोड';

  @override
  String get circlesAllLevels => 'सभी स्तर';

  @override
  String get circlesAddNewCourse => 'नया कोर्स जोड़ें';

  @override
  String get circlesCoursesTitle => 'कोर्स';

  @override
  String get circlesModeTitle => 'मोड';

  @override
  String get circlesLevelTitle => 'स्तर';

  @override
  String get circlesNoActiveForFilters =>
      'इन फ़िल्टर के लिए कोई सक्रिय Circles नहीं।';

  @override
  String get circlesUnknownRoom => 'अज्ञात रूम';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle बनाएं';

  @override
  String get circlesCircleName => 'Circle नाम';

  @override
  String get circlesEnterName => 'नाम दर्ज करें';

  @override
  String get circlesLanguages => 'भाषाएं';

  @override
  String get circlesRoomSetup => 'रूम सेटअप';

  @override
  String get circlesPlayers => 'खिलाड़ी';

  @override
  String get circlesEmptySlot => 'खाली स्लॉट';

  @override
  String get circlesPlayersRange => '1-5 खिलाड़ी';

  @override
  String get circlesQuestions => 'प्रश्न';

  @override
  String get circlesQuestionsSubtitle => 'प्रश्नों की संख्या';

  @override
  String get circlesTimePerQuestion => 'प्रति प्रश्न समय';

  @override
  String get circlesSecondsPerQuestion => 'प्रति प्रश्न सेकंड';

  @override
  String get circlesAdvanced => 'उन्नत';

  @override
  String get circlesAllowSpectators => 'दर्शकों की अनुमति दें';

  @override
  String get circlesAllowSpectatorsSubtitle => 'दूसरों को बिना खेले देखने दें।';

  @override
  String get circlesLiveVoiceChat => 'लाइव वॉयस चैट';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'मैच के दौरान लाइव ऑडियो सक्षम करें।';

  @override
  String get circlesLiveTextChat => 'लाइव टेक्स्ट चैट';

  @override
  String get circlesLiveTextChatSubtitle => 'मैच के दौरान चैट सक्षम करें।';

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
  String get circlesCreatedSuccess => 'Circle बनाया गया';

  @override
  String circlesCreateError(Object error) {
    return 'Circle बनाने में विफल: $error';
  }

  @override
  String get circlesHostTip =>
      'टिप: बनाने के बाद आप दोस्तों को आमंत्रित कर सकते हैं।';

  @override
  String circlesJoinError(Object error) {
    return 'Circle में शामिल होने में विफल: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle लॉबी';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'कोड: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'मैच सेटिंग्स';

  @override
  String circlesLevelWithValue(Object level) {
    return 'स्तर $level';
  }

  @override
  String get circlesDifficulty => 'कठिनाई';

  @override
  String get circlesPerQuestionShort => 'प्रति प्रश्न';

  @override
  String get circlesInvite => 'आमंत्रित करें';

  @override
  String get circlesCopyId => 'ID कॉपी करें';

  @override
  String get circlesCopiedId => 'ID कॉपी की गई';

  @override
  String get circlesMatchInProgress => 'मैच चल रहा है';

  @override
  String get circlesSpectatorQueuedBody =>
      'मैच चल रहा है। आप दर्शक के रूप में शामिल होंगे।';

  @override
  String get circlesHostStartWhenReady => 'सभी तैयार होने पर होस्ट शुरू करेगा।';

  @override
  String get circlesSpectators => 'दर्शक';

  @override
  String get circlesSpectator => 'दर्शक';

  @override
  String get circlesSpectatorCanWatch => 'दर्शक लाइव देख सकते हैं।';

  @override
  String get circlesJoinRequests => 'शामिल होने के अनुरोध';

  @override
  String get circlesAcceptSpectatorsHint =>
      'मैच शुरू करने से पहले दर्शकों को स्वीकार करें।';

  @override
  String get circlesStartGame => 'गेम शुरू करें';

  @override
  String get circlesWaitingForPlayers => 'खिलाड़ियों की प्रतीक्षा कर रहे हैं';

  @override
  String get circlesLeaveCircle => 'Circle छोड़ें';

  @override
  String get circlesRequestSent => 'अनुरोध भेजा गया';

  @override
  String get circlesRequestToJoin => 'शामिल होने का अनुरोध';

  @override
  String get circlesWatchLive => 'लाइव देखें';

  @override
  String get circlesPlayerTip =>
      'जब आप तैयार हों तो तैयार टैप करें। होस्ट मैच शुरू करेगा।';

  @override
  String get circlesSpectatorTip =>
      'आप देख रहे हैं। होस्ट शुरू करते ही लाइव देखें।';

  @override
  String get circlesHostControls => 'होस्ट नियंत्रण';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'होस्ट स्थानांतरित करने में विफल: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle समाप्त करने में विफल: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username नहीं मिला';
  }

  @override
  String get circlesInvalidUser => 'अमान्य उपयोगकर्ता';

  @override
  String get circlesCantInviteSelf => 'आप खुद को आमंत्रित नहीं कर सकते';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username पहले से ही Circle में है';
  }

  @override
  String get circlesDefaultHost => 'होस्ट';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'उपयोगकर्ता नाम से आमंत्रित करें';

  @override
  String circlesInviteSent(Object username) {
    return '@$username को आमंत्रण भेजा गया';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'आमंत्रण भेजने में विफल: $error';
  }

  @override
  String get circlesJoinRequestSent => 'शामिल होने का अनुरोध भेजा गया';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'अनुरोध विफल: $error';
  }

  @override
  String get circlesFull => 'Circle भरा हुआ है';

  @override
  String get circlesSpectatorAdded => 'दर्शक जोड़ा गया';

  @override
  String circlesApproveFailed(Object error) {
    return 'अनुरोध स्वीकृत करने में विफल: $error';
  }

  @override
  String get circlesRequestDeclined => 'अनुरोध अस्वीकार किया गया';

  @override
  String circlesDeclineFailed(Object error) {
    return 'अनुरोध अस्वीकार करने में विफल: $error';
  }

  @override
  String get circlesParticipant => 'प्रतिभागी';

  @override
  String get circlesLeavePromptTitle => 'Circle छोड़ें?';

  @override
  String get circlesLeavePromptTransfer =>
      'छोड़ने से पहले होस्ट स्थानांतरित करें।';

  @override
  String get circlesLeavePromptEndOnly => 'Circle समाप्त करें और छोड़ें।';

  @override
  String get circlesTransferHost => 'होस्ट स्थानांतरित करें';

  @override
  String get circlesEndCircle => 'Circle समाप्त करें';

  @override
  String get circlesTransferHostTitle => 'होस्ट स्थानांतरित करें';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
