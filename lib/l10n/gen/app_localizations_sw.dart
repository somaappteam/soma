// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Jifunze. Shindana. Umuhimu.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Jisajili';

  @override
  String get signIn => 'Ingia';

  @override
  String get skipForNow => 'Ruka kwa sasa';

  @override
  String get authFillAllFields => 'Tafadhali jaza sehemu zote';

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
    return 'Hitilafu: $error';
  }

  @override
  String get authEmail => 'Baruapepe';

  @override
  String get authPassword => 'Nenosiri';

  @override
  String get authUsername => 'Jina la mtumiaji';

  @override
  String get authContinue => 'Endelea';

  @override
  String get authSigningIn => 'inaingia...';

  @override
  String get authCreateAccount => 'Fungua Akaunti';

  @override
  String get authCreating => 'inatengeneza...';

  @override
  String get authNeedAccount => 'Huna akaunti? ';

  @override
  String get authHaveAccount => 'Una akaunti tayari? ';

  @override
  String get dialogAuthRequiredTitle => 'Ingia ili kujiunga na Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles ni vyumba vya wachezaji wengi. Fungua akaunti ili kujiunga na mechi za moja kwa moja, kualika marafiki, na kuhifadhi maendeleo.';

  @override
  String get notNow => 'Sio sasa';

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Wasifu';

  @override
  String get removeCourseTitle => 'Ondoa kozi?';

  @override
  String removeCourseBody(Object course) {
    return '$course itaondolewa kwenye orodha yako';
  }

  @override
  String get cancel => 'Ghairi';

  @override
  String get remove => 'Ondoa';

  @override
  String welcomeBack(Object name) {
    return 'Karibu tena, $name!';
  }

  @override
  String get editCourses => 'Hariri Kozi';

  @override
  String get done => 'Tayari';

  @override
  String get noCoursesToEdit => 'Hakuna kozi za kuhariri';

  @override
  String get addCourse => 'Ongeza Kozi';

  @override
  String get unknown => 'Haijulikani';

  @override
  String get iSpeak => 'Ninazungumza';

  @override
  String get iWantToLearn => 'Ninataka kujifunza';

  @override
  String get chooseYourLanguage => 'Chagua lugha yako';

  @override
  String get chooseLearningLanguage => 'Chagua lugha ya kujifunza';

  @override
  String get chooseTwoDifferentLanguages =>
      'Tafadhali chagua lugha mbili tofauti';

  @override
  String get createCourse => 'Unda Kozi';

  @override
  String get soloCourseTitle => 'Kozi ya Solo';

  @override
  String get searchLanguage => 'Tafuta lugha';

  @override
  String get noMatches => 'Hakuna matokeo';

  @override
  String get chooseCourseType => 'Chagua aina ya kozi';

  @override
  String get soloStudyDescription =>
      'Fanya mazoezi peke yako na maswali kama ya Circles - lakini bila vyumba, mazungumzo, au mwenyeji';

  @override
  String get soloModeVocabulary => 'Msamiati';

  @override
  String get soloModeSentences => 'Sentensi';

  @override
  String get soloModeReview => 'Mapitio';

  @override
  String get soloModeVocabularySubtitle =>
      'Chaguo nyingi, maana, visawe, matumizi';

  @override
  String get soloModeSentencesSubtitle => 'Jaza nafasi + tafsiri + kusoma';

  @override
  String get soloModeReviewDescription =>
      'Fanya mazoezi uliyojifunza: maneno magumu, makosa ya hivi karibuni';

  @override
  String get startReview => 'Anza Mapitio';

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
    return 'Mipangilio ya $mode';
  }

  @override
  String get difficulty => 'Ugumu';

  @override
  String get numberOfQuestions => 'Idadi ya maswali';

  @override
  String get timerPerQuestion => 'Muda kwa swali';

  @override
  String get noTimer => 'Hakuna muda';

  @override
  String get start => 'Anza';

  @override
  String get profileTitle => 'Wasifu';

  @override
  String get profileSignInToMessage => 'Ingia kutuma ujumbe';

  @override
  String get profileThatsYourProfile => 'Hiyo ni wasifu wako';

  @override
  String get profileSignInToAddFriends => 'Ingia kuongeza marafiki';

  @override
  String get profileCantAddYourself => 'Huwezi kujiongeza mwenyewe';

  @override
  String profileRequestSent(Object username) {
    return 'Ombi limetumwa kwa @$username';
  }

  @override
  String get profileRequestFailed => 'Imeshindwa kutuma ombi';

  @override
  String get profileDefaultDisplayName => 'Mtumiaji Mpya';

  @override
  String get profileDefaultBio => 'Tayari kujifunza!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Mgeni';

  @override
  String get guestUsername => 'Mgeni';

  @override
  String get guestSessionLabel => 'Kikao cha Mgeni';

  @override
  String get unlockFullProfile => 'Fungua Wasifu Kamili';

  @override
  String get guestBenefitSync => 'Hifadhi maendeleo kwenye vifaa vyote';

  @override
  String get guestBenefitCircles => 'Jiunge na Circles na ucheze moja kwa moja';

  @override
  String get guestBenefitNotifications => 'Pata arifa na maombi ya urafiki';

  @override
  String get progressStaysOnDevice =>
      'Maendeleo yanabaki kwenye kifaa hiki hadi uingie';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Lengo: dkk $minutes';
  }

  @override
  String get profileXpProgress => 'Maendeleo ya XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Ushindi';

  @override
  String get profileStreak => 'Mfululizo';

  @override
  String get profileFriendsTitle => 'Marafiki';

  @override
  String get profileViewAll => 'Ona zote';

  @override
  String get profileAchievementsTitle => 'Mafanikio';

  @override
  String get profileNoAchievements => 'Bado hakuna mafanikio';

  @override
  String get profileRequested => 'Imeombwa';

  @override
  String get profileSending => 'Inatuma...';

  @override
  String get profileAddFriend => 'Ongeza Rafiki';

  @override
  String get profileConnectTitle => 'Ungana';

  @override
  String get profileMessage => 'Ujumbe';

  @override
  String get profileSnapshot => 'Picha ya Wasifu';

  @override
  String get profileLocationHidden => 'Mahali pamefichwa';

  @override
  String get profileBioHidden => 'Wasifu umefichwa';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Lengo la kila siku dkk $minutes';
  }

  @override
  String get circleInviteTitle => 'Mwaliko wa Circle';

  @override
  String circleIdLabel(Object id) {
    return 'Kitambulisho cha Circle: $id';
  }

  @override
  String get signInToJoin => 'Ingia ili kujiunga';

  @override
  String get joiningCircle => 'Inajiunga...';

  @override
  String get joinCircle => 'Jiunge na Circles';

  @override
  String get circleJoinedAsPlayer => 'Amejiunga kama mchezaji';

  @override
  String get circleJoinedAsSpectator => 'Amejiunga kama mtazamaji';

  @override
  String get accept => 'Kubali';

  @override
  String get decline => 'Kataa';

  @override
  String get open => 'Fungua';

  @override
  String get circleCountdownTitle => 'Jitayarishe';

  @override
  String get circleCountdownSubtitle => 'Circle inaanza...';

  @override
  String get userFallbackName => 'Mtumiaji';

  @override
  String get micOff => 'Maikrofoni Imezimwa';

  @override
  String get micOn => 'Maikrofoni Imewashwa';

  @override
  String get roleHost => 'Mwenyeji';

  @override
  String get roleSpectator => 'Mtazamaji';

  @override
  String get tagHost => 'MWENYEJI';

  @override
  String get tagYou => 'WEWE';

  @override
  String get statusCorrect => 'SAHIHI';

  @override
  String get statusWrong => 'KOSA';

  @override
  String get statusWaiting => 'INASUBIRI';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pts';

  @override
  String get pointsLabel => 'Alama';

  @override
  String get statCorrect => 'Sahihi';

  @override
  String get statAnswers => 'Majibu';

  @override
  String get statTotal => 'Jumla';

  @override
  String get statQuestions => 'Maswali';

  @override
  String get statAccuracy => 'Usahihi';

  @override
  String get statRate => 'Kiwango';

  @override
  String get statRank => 'Nafasi';

  @override
  String get statPosition => 'Nafasi';

  @override
  String get statMode => 'Modi';

  @override
  String get statType => 'Aina';

  @override
  String get next => 'Inayofuata';

  @override
  String get submit => 'Wasilisha';

  @override
  String get continueLabel => 'Endelea';

  @override
  String get save => 'Hifadhi';

  @override
  String get playAgain => 'Cheza Tena';

  @override
  String get backToCourse => 'Rudi kwenye Kozi';

  @override
  String get resultsTitle => 'Matokeo';

  @override
  String get shareLater => 'Shiriki baadaye';

  @override
  String get delete => 'Futa';

  @override
  String get ok => 'Sawa';

  @override
  String minutesShort(Object minutes) {
    return 'dkk $minutes';
  }

  @override
  String timeShortMinutes(Object count) {
    return 'dkk $count';
  }

  @override
  String timeShortHours(Object count) {
    return 'saa $count';
  }

  @override
  String timeShortDays(Object count) {
    return 'siku $count';
  }

  @override
  String get timeJustNow => 'sasa hivi';

  @override
  String timeMinutesAgo(Object count) {
    return 'dkk $count zilizopita';
  }

  @override
  String timeHoursAgo(Object count) {
    return 'saa $count zilizopita';
  }

  @override
  String timeDaysAgo(Object count) {
    return 'siku $count zilizopita';
  }

  @override
  String get liveQuizWaitingForHost => 'Inamsubiri mwenyeji...';

  @override
  String get liveQuizJoinRequestSent => 'Ombi la kujiunga limetumwa';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Ombi limeshindwa: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Udhibiti wa Mwenyeji';

  @override
  String get liveQuizSpectatorModeTitle => 'Modi ya Mtazamaji';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Raundi zitasonga mbele kiotomatiki wakati kila mtu amejibu au muda unapoisha';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Angalia maswali na bao la kuongoza moja kwa moja. Huwezi kujibu';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Swali $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Ombi limetumwa';

  @override
  String get liveQuizRequestToJoin => 'Omba kujiunga';

  @override
  String get liveQuizSpectatorFooter =>
      'Unatazama moja kwa moja. Furahia maswali na ubao wa kuongoza';

  @override
  String get circleNotFound => 'Circle haikupatikana';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Imeshindwa kuanza mechi mpya: $error';
  }

  @override
  String get resultsMatchTitle => 'Matokeo ya Mechi';

  @override
  String resultsNiceWork(Object name) {
    return 'Kazi nzuri, $name';
  }

  @override
  String get resultsPlaceFirst => 'Nafasi ya 1';

  @override
  String get resultsPlaceSecond => 'Nafasi ya 2';

  @override
  String get resultsPlaceThird => 'Nafasi ya 3';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Nafasi ya $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'kati ya wachezaji $players';
  }

  @override
  String get resultsHighlightChampion => 'Bingwa! Ulitawala raundi hii';

  @override
  String get resultsHighlightGreatAccuracy => 'Usahihi mkubwa - karibu kabisa!';

  @override
  String get resultsHighlightKeepGoing => 'Endelea - uthabiti unashinda kasi';

  @override
  String get resultsLeaderboardTitle => 'Ubao wa kuongoza';

  @override
  String resultsPlayersCount(Object count) {
    return 'Wachezaji $count';
  }

  @override
  String get resultsBackToCircles => 'Rudi kwenye Circles';

  @override
  String get resultsRematch => 'Mechi Mpya';

  @override
  String get resultsPlayAgain => 'Cheza Tena';

  @override
  String get leaderboardGlobalTitle => 'Ubao wa Kimataifa';

  @override
  String get leaderboardEmpty => 'Bado hakuna nafasi';

  @override
  String get aboutTitle => 'Kuhusu';

  @override
  String aboutVersion(Object version) {
    return 'Toleo $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ni jukwaa la kujifunza lugha kwa njia ya mchezo ambalo hufanya umilisi wa lugha mpya kuwa wa kufurahisha na wa kijamii. Shindana katika Circles, fanya mazoezi peke yako, na fuatilia maendeleo yako.';

  @override
  String get aboutTerms => 'Masharti ya Huduma';

  @override
  String get aboutPrivacy => 'Sera ya Faragha';

  @override
  String get aboutOpenSource => 'Leseni za Chanzo Huria';

  @override
  String get addFriendTitle => 'Ongeza Rafiki';

  @override
  String get addFriendFindByUsername => 'Tafuta kwa Jina la Mtumiaji';

  @override
  String get addFriendUsernameHint => 'Andika jina la mtumiaji...';

  @override
  String get addFriendTip =>
      'Kidokezo: Usaidizi wa msimbo wa QR + Kitambulisho cha Rafiki unakuja hivi karibuni';

  @override
  String get addFriendSending => 'Inatuma...';

  @override
  String get addFriendSendRequest => 'Tuma Ombi';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Mtumiaji @$username hakupatikana';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Kitendo kimeshindwa au tayari kimetumwa: $error';
  }

  @override
  String get friendsTitle => 'Marafiki';

  @override
  String get searchFriendsHint => 'Tafuta marafiki...';

  @override
  String get somaLearnerSubtitle => 'Mwanafunzi wa Soma';

  @override
  String get friendRequestLabel => 'Ombi';

  @override
  String get friendRequestSentLabel => 'Ombi limetumwa';

  @override
  String get friendIncomingRequestLabel => 'Ombi linalokuja';

  @override
  String get friendRequestsSection => 'Maombi';

  @override
  String get friendPendingSection => 'Inasubiri';

  @override
  String get friendAllSection => 'Marafiki Wote';

  @override
  String get friendsEmptyState =>
      'Bado hakuna marafiki. Ongeza rafiki yako wa kwanza!';

  @override
  String get friendsEmptyShort => 'Bado hakuna marafiki';

  @override
  String noMatchForQuery(Object query) {
    return 'Hakuna matokeo kwa \"$query\"';
  }

  @override
  String get inboxTitle => 'Kikasha';

  @override
  String get searchChatsHint => 'Tafuta mazungumzo...';

  @override
  String get inboxEmptyState =>
      'Bado hakuna mazungumzo. Anzisha mazungumzo na rafiki!';

  @override
  String get newMessageTitle => 'Ujumbe Mpya';

  @override
  String get chatCallLater =>
      'Simu ya sauti hivi karibuni (sauti ya Circle inayofuata)';

  @override
  String errorWithDetails(Object error) {
    return 'Hitilafu: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Sema Jambo kwa $name!';
  }

  @override
  String get chatMessageHint => 'Ujumbe...';

  @override
  String get notificationsTitle => 'Arifa';

  @override
  String get notificationsTabAll => 'Zote';

  @override
  String get notificationsTabCourses => 'Kozi';

  @override
  String get notificationsTabSocial => 'Kijamii';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Mfumo';

  @override
  String get notificationsEmpty => 'Hakuna arifa';

  @override
  String get notificationsDeleted => 'Arifa imefutwa';

  @override
  String get notificationTitleFallback => 'Arifa';

  @override
  String get notificationTypeCourse => 'Kozi';

  @override
  String get notificationTypeSocial => 'Kijamii';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Mfumo';

  @override
  String get notificationsFriendAccepted => 'Ombi la urafiki limekubaliwa';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Imeshindwa kukubali ombi la urafiki: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Ombi la urafiki limekataliwa';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Imeshindwa kukataa ombi la urafiki: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Imeshindwa kujiunga na Circle: $error';
  }

  @override
  String get notificationsOpening => 'Inafungua';

  @override
  String get notificationsOpened => 'Imefunguliwa';

  @override
  String notificationsActionMessage(Object action) {
    return 'Arifa ya $action';
  }

  @override
  String get settingsTitle => 'Mipangilio';

  @override
  String get settingsSectionAccount => 'Akaunti';

  @override
  String get settingsEditProfile => 'Hariri Wasifu';

  @override
  String get settingsPrivacy => 'Faragha';

  @override
  String get settingsSecurity => 'Usalama';

  @override
  String get settingsSectionGameplay => 'Uchezaji';

  @override
  String get settingsShowTranslationLine => 'Onyesha Mstari wa Tafsiri';

  @override
  String get settingsShowReadingLine =>
      'Onyesha Mstari wa Kusoma (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Muda wa Kila Swali';

  @override
  String get settingsMatchDifficulty => 'Ugumu wa Mechi';

  @override
  String get settingsMatchDifficultyAdaptive => 'Inayobadilika';

  @override
  String get settingsSectionSoundFeel => 'Sauti na Mguso';

  @override
  String get settingsMusic => 'Muziki';

  @override
  String get settingsSoundEffects => 'Athari za Sauti';

  @override
  String get settingsHaptics => 'Mtetemo';

  @override
  String get settingsSectionNotifications => 'Arifa';

  @override
  String get settingsPushNotifications => 'Arifa za Push';

  @override
  String get settingsDailyReminder => 'Kikumbusho cha Kila Siku';

  @override
  String get settingsSectionAppearance => 'Muonekano';

  @override
  String get settingsTheme => 'Mandhari';

  @override
  String get settingsUiLanguage => 'Lugha ya UI';

  @override
  String get settingsSectionAbout => 'Kuhusu';

  @override
  String get settingsVersion => 'Toleo';

  @override
  String get settingsTermsPrivacy => 'Masharti na Faragha';

  @override
  String get settingsSupport => 'Msaada';

  @override
  String get settingsLogout => 'Ondoka';

  @override
  String get themeSystem => 'Mfumo';

  @override
  String get themeDark => 'Giza';

  @override
  String get themeLight => 'Mwanga';

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
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageSwahili => 'Kiswahili';

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
  String get editProfileUpdated => 'Wasifu Umesasishwa';

  @override
  String get editProfileTitle => 'Hariri Wasifu';

  @override
  String get editProfilePhotoLabel => 'Picha ya Wasifu';

  @override
  String get editProfilePhotoSubtitle =>
      'Uchaguzi wa Avatar wa Supabase Storage unakuja hivi karibuni';

  @override
  String get editProfileChangePhoto => 'Badilisha';

  @override
  String get editProfileAvatarUploadSoon => 'Upakiaji wa Avatar hivi karibuni';

  @override
  String get editProfileDisplayNameLabel => 'Jina la Kuonyesha';

  @override
  String get editProfileDisplayNameHint => 'Jina lako';

  @override
  String get editProfileDisplayNameRequired => 'Tafadhali ingiza jina lako';

  @override
  String get editProfileDisplayNameTooShort => 'Fupi mno';

  @override
  String get editProfileUsernameLabel => 'Jina la Mtumiaji';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Tafadhali ingiza jina la mtumiaji';

  @override
  String get editProfileUsernameTooShort => 'Angalau herufi 3';

  @override
  String get editProfileUsernameInvalid => 'Herufi, nambari, _ pekee';

  @override
  String get editProfileBioLabel => 'Wasifu';

  @override
  String get editProfileBioHint => 'Maelezo mafupi kukuhusu...';

  @override
  String get editProfileBioTooLong => 'Upeo wa herufi 120';

  @override
  String get editProfileLocationLabel => 'Mahali';

  @override
  String get editProfileLocationHint => 'Mji / Nchi';

  @override
  String get editProfileDailyGoalTitle => 'Lengo la Kila Siku';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Chagua dakika ngapi unataka kujifunza kwa siku';

  @override
  String get securityTitle => 'Usalama';

  @override
  String get securitySectionPassword => 'Nenosiri';

  @override
  String get securityChangePasswordTitle => 'Badilisha Nenosiri';

  @override
  String get securityChangePasswordSubtitle =>
      'Sasisha nenosiri lako mara kwa mara';

  @override
  String get securitySectionTwoFactor => 'Uthibitishaji wa Hatua Mbili';

  @override
  String get securityEnable2faTitle => 'Wezesha 2FA';

  @override
  String get securityEnable2faSubtitle => 'Usalama wa ziada kwa kuingia';

  @override
  String get securitySectionAppLock => 'Kufunga Programu';

  @override
  String get securityBiometricTitle => 'Kufungua kwa Biometriska';

  @override
  String get securityBiometricSubtitle => 'Tumia FaceID/TouchID kufungua SOMA';

  @override
  String get securityAppLockTitle => 'Kufunga Programu';

  @override
  String get securityAppLockSubtitle => 'Funga SOMA unapoondoka';

  @override
  String get securitySectionSessions => 'Vipindi Vinavyoendelea';

  @override
  String get securityNoSessions => 'Hakuna vipindi vinavyoendelea';

  @override
  String get securityThisDevice => 'Kifaa Hiki';

  @override
  String get securityDevice => 'Kifaa';

  @override
  String get securityActiveLabel => 'Amilifu';

  @override
  String get securitySignInToEnable2fa => 'Ingia ili kuwezesha 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Imeshindwa kuwezesha 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Imeshindwa kulemaza 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Usanidi wa 2FA';

  @override
  String get securitySecretKeyLabel => 'Ufunguo wa Siri';

  @override
  String get securityCodeHint => 'Msimbo wa tarakimu 6';

  @override
  String get security2faEnabled => '2FA Imewezeshwa';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Imeshindwa kuthibitisha msimbo: $error';
  }

  @override
  String get securityVerifying => 'Inathibitisha...';

  @override
  String get securityVerify => 'Thibitisha';

  @override
  String get securityCurrentPasswordHint => 'Nenosiri la Sasa';

  @override
  String get securityNewPasswordHint => 'Nenosiri Mpya (angalau herufi 8)';

  @override
  String get securityConfirmPasswordHint => 'Thibitisha nenosiri mpya';

  @override
  String get securitySignInToChangePassword => 'Ingia ili kubadilisha nenosiri';

  @override
  String get securityEnterCurrentPassword => 'Ingiza nenosiri lako la sasa';

  @override
  String get securityPasswordMinLength =>
      'Nenosiri mpya lazima liwe na angalau herufi 8';

  @override
  String get securityPasswordsDoNotMatch => 'Nywila hazilingani';

  @override
  String get securityPasswordUpdated => 'Nenosiri limesasishwa';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Imeshindwa kusasisha nenosiri: $error';
  }

  @override
  String get securityAutoLockAfter => 'Saa ya Kufunga Kiotomatiki';

  @override
  String get privacyTitle => 'Faragha';

  @override
  String get privacySectionVisibility => 'Mwonekano';

  @override
  String get privacyProfileVisibilityTitle => 'Mwonekano wa Wasifu';

  @override
  String get privacyVisibilityPublic => 'Umma';

  @override
  String get privacyVisibilityFriends => 'Marafiki';

  @override
  String get privacyVisibilityPrivate => 'Binafsi';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Mtu yeyote anaweza kuona wasifu wako';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Marafiki pekee ndio wanaoweza kuona wasifu wako';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Wewe pekee ndiye unayeweza kuona wasifu wako';

  @override
  String get privacySectionActivity => 'Shughuli';

  @override
  String get privacyShowOnlineTitle => 'Onyesha Hali ya Mtandaoni';

  @override
  String get privacyShowOnlineSubtitle =>
      'Waruhusu wachezaji waone unapokuwa mtandaoni';

  @override
  String get privacyShowActivityTitle => 'Onyesha Shughuli ya Kujifunza';

  @override
  String get privacyShowActivitySubtitle =>
      'Onyesha mfululizo, XP, na maendeleo ya hivi majuzi';

  @override
  String get privacySectionSocial => 'Kijamii';

  @override
  String get privacyAllowRequestsTitle => 'Ruhusu Maombi ya Urafiki';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Ruhusu watu wakutumie maombi ya urafiki';

  @override
  String get privacyWhoCanDmTitle => 'Nani Anaweza DM';

  @override
  String get privacyDmEveryone => 'Kila mtu';

  @override
  String get privacyDmFriends => 'Marafiki';

  @override
  String get privacyDmNoOne => 'Hakuna mtu';

  @override
  String get privacyDmEveryoneSubtitle => 'Mtu yeyote anaweza kukutumia ujumbe';

  @override
  String get privacyDmFriendsSubtitle =>
      'Marafiki pekee ndio wanaoweza kukutumia ujumbe';

  @override
  String get privacyDmNoOneSubtitle => 'Hakuna mtu anayeweza kukutumia ujumbe';

  @override
  String get privacySectionBlockedUsers => 'Watumiaji Waliozuiwa';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Usimamizi wa watumiaji waliozuiwa unakuja hivi karibuni';

  @override
  String get privacySectionDataControls => 'Udhibiti wa Data';

  @override
  String get privacyExportDataTitle => 'Hamisha Data Yangu';

  @override
  String get privacyExportDataSubtitle => 'Pakua shughuli zako na kozi';

  @override
  String get privacyExportInfoTitle => 'Uhamishaji wa Data';

  @override
  String get privacyExportInfoBody =>
      'Nyingine: Tengeneza usafirishaji wa JSON/CSV na barua pepe au upakuaji wa kawaida';

  @override
  String get privacyDeleteAccountTitle => 'Futa Akaunti';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Hii itafuta akaunti yako na data kabisa';

  @override
  String get privacyDeleteConfirmTitle => 'Futa Akaunti?';

  @override
  String get privacyDeleteConfirmBody =>
      'Hii haiwezi kubatilishwa. Wasifu wako, kozi, marafiki, na ujumbe vitafutwa';

  @override
  String get privacyDeleteComingSoon =>
      'Ufutaji utaunganishwa na Supabase baadaye';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Kikao cha Solo kimekamilika';

  @override
  String get soloResultsFeedbackElite => 'Utendaji bora - weka mfululizo hai';

  @override
  String get soloResultsFeedbackStrong => 'Kazi nzuri - inaboresha haraka';

  @override
  String get soloResultsFeedbackProgress =>
      'Maendeleo mazuri - kagua makosa na jaribu tena';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Hakuna shinikizo - jaribu tena na maswali machache na uzingatie';

  @override
  String get soloResultsPerfectScore =>
      'Alama kamili! Hakuna makosa ya kukagua';

  @override
  String get soloResultsReviewPrompt =>
      'Kagua makosa ili ujifunze haraka zaidi. Majibu yako yasiyo sahihi yako hapa chini';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Kagua Makosa ($count)';
  }

  @override
  String get authNotSignedIn => 'Hujaingia';

  @override
  String get genericUser => 'Mtumiaji';

  @override
  String get loading => 'Inapakia...';

  @override
  String get edit => 'Hariri';

  @override
  String get send => 'Tuma';

  @override
  String get join => 'Jiunge';

  @override
  String get leave => 'Ondoka';

  @override
  String get ready => 'Tayari';

  @override
  String get levelBeginner => 'Mwanzilishi';

  @override
  String get levelIntermediate => 'Wakati';

  @override
  String get levelAdvanced => 'Juu';

  @override
  String questionsShort(Object count) {
    return 'Maswali $count';
  }

  @override
  String secondsShort(Object count) {
    return 'Sekunde $count';
  }

  @override
  String get circlesAllCourses => 'Kozi Zote';

  @override
  String get circlesAllModes => 'Modi Zote';

  @override
  String get circlesAllLevels => 'Ngazi Zote';

  @override
  String get circlesAddNewCourse => 'Ongeza Kozi Mpya';

  @override
  String get circlesCoursesTitle => 'Kozi';

  @override
  String get circlesModeTitle => 'Modi';

  @override
  String get circlesLevelTitle => 'Ngazi';

  @override
  String get circlesNoActiveForFilters =>
      'Hakuna Circle inayotumika kwa vichungi hivi';

  @override
  String get circlesUnknownRoom => 'Chumba Kisichojulikana';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Unda Circle';

  @override
  String get circlesCircleName => 'Jina la Circle';

  @override
  String get circlesEnterName => 'Ingiza jina';

  @override
  String get circlesLanguages => 'Lugha';

  @override
  String get circlesRoomSetup => 'Mpangilio wa Chumba';

  @override
  String get circlesPlayers => 'Wachezaji';

  @override
  String get circlesEmptySlot => 'Nafasi Tupu';

  @override
  String get circlesPlayersRange => 'Wachezaji 1-5';

  @override
  String get circlesQuestions => 'Maswali';

  @override
  String get circlesQuestionsSubtitle => 'Kiasi cha maswali';

  @override
  String get circlesTimePerQuestion => 'Muda kwa Swali';

  @override
  String get circlesSecondsPerQuestion => 'Sek/Swali';

  @override
  String get circlesAdvanced => 'Juu';

  @override
  String get circlesAllowSpectators => 'Ruhusu Watazamaji';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Ruhusu wengine kutazama bila kucheza';

  @override
  String get circlesLiveVoiceChat => 'Mazungumzo ya Sauti ya Moja kwa Moja';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Wezesha mwingiliano wa sauti wakati wa mechi';

  @override
  String get circlesLiveTextChat => 'Mazungumzo ya Maandishi ya Moja kwa Moja';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Wezesha kutuma ujumbe wakati wa mechi';

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
  String get circlesCreatedSuccess => 'Circle imeundwa';

  @override
  String circlesCreateError(Object error) {
    return 'Imeshindwa kuunda Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Kidokezo: Unaweza kualika marafiki baada ya kuunda';

  @override
  String circlesJoinError(Object error) {
    return 'Imeshindwa kujiunga na Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby ya Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Msimbo: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Mipangilio ya Mechi';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Ngazi $level';
  }

  @override
  String get circlesDifficulty => 'Ugumu';

  @override
  String get circlesPerQuestionShort => 'Kwa kila swali';

  @override
  String get circlesInvite => 'Alika';

  @override
  String get circlesCopyId => 'Nakili ID';

  @override
  String get circlesCopiedId => 'ID imenakiliwa';

  @override
  String get circlesMatchInProgress => 'Mechi inaendelea';

  @override
  String get circlesSpectatorQueuedBody =>
      'Mechi inaendelea. Utajiunga kama mtazamaji';

  @override
  String get circlesHostStartWhenReady =>
      'Mwenyeji ataanza wakati kila mtu yuko tayari';

  @override
  String get circlesSpectators => 'Watazamaji';

  @override
  String get circlesSpectator => 'Mtazamaji';

  @override
  String get circlesSpectatorCanWatch =>
      'Watazamaji wanaweza kutazama moja kwa moja';

  @override
  String get circlesJoinRequests => 'Maombi ya Kujiunga';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Kubali watazamaji kabla ya kuanza mechi';

  @override
  String get circlesStartGame => 'Anza Mchezo';

  @override
  String get circlesWaitingForPlayers => 'Inasubiri wachezaji';

  @override
  String get circlesLeaveCircle => 'Ondoka kwenye Circle';

  @override
  String get circlesRequestSent => 'Ombi limetumwa';

  @override
  String get circlesRequestToJoin => 'Omba kujiunga';

  @override
  String get circlesWatchLive => 'Tazama Moja kwa Moja';

  @override
  String get circlesPlayerTip =>
      'Gonga \'Tayari\' unapokuwa tayari. Mwenyeji ataanza mechi';

  @override
  String get circlesSpectatorTip =>
      'Unatazama. Tazama hatua moja kwa moja mwenyeji anapoanza';

  @override
  String get circlesHostControls => 'Udhibiti wa Mwenyeji';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Imeshindwa kuhamisha uwenyeji: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Imeshindwa kumaliza Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Mtumiaji @$username hakupatikana';
  }

  @override
  String get circlesInvalidUser => 'Mtumiaji batili';

  @override
  String get circlesCantInviteSelf => 'Huwezi kujialika mwenyewe';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username tayari yuko kwenye Circle';
  }

  @override
  String get circlesDefaultHost => 'Mwenyeji';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Kupitia Jina la Mtumiaji';

  @override
  String circlesInviteSent(Object username) {
    return 'Mwaliko umetumwa kwa @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Imeshindwa kutuma mwaliko: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Ombi la kujiunga limetumwa';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Ombi limeshindwa: $error';
  }

  @override
  String get circlesFull => 'Circle imejaa';

  @override
  String get circlesSpectatorAdded => 'Mtazamaji ameongezwa';

  @override
  String circlesApproveFailed(Object error) {
    return 'Imeshindwa kuidhinisha: $error';
  }

  @override
  String get circlesRequestDeclined => 'Ombi limekataliwa';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Imeshindwa kukataa: $error';
  }

  @override
  String get circlesParticipant => 'Mshiriki';

  @override
  String get circlesLeavePromptTitle => 'Ondoka kwenye Circle?';

  @override
  String get circlesLeavePromptTransfer => 'Hamisha uwenyeji kabla ya kuondoka';

  @override
  String get circlesLeavePromptEndOnly => 'Maliza Circle na uondoke';

  @override
  String get circlesTransferHost => 'Hamisha Mwenyeji';

  @override
  String get circlesEndCircle => 'Maliza Circle';

  @override
  String get circlesTransferHostTitle => 'Uhamisho wa Mwenyeji';

  @override
  String circlesShareId(Object id) {
    return 'Kitambulisho cha Circle: $id';
  }
}
