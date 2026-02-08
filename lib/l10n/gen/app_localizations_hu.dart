// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Learn. Compete. Master.';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get authFillAllFields => 'Please fill in all fields';

  @override
  String authError(Object error) {
    return 'Error: $error';
  }

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authUsername => 'Username';

  @override
  String get authContinue => 'Continue';

  @override
  String get authSigningIn => 'Signing In...';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authCreating => 'Creating...';

  @override
  String get authNeedAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get dialogAuthRequiredTitle => 'Sign in to access Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles are multiplayer rooms. Create an account to join live matches, invite friends, and save progress.';

  @override
  String get notNow => 'Not now';

  @override
  String get navHome => 'Home';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profile';

  @override
  String get removeCourseTitle => 'Remove course?';

  @override
  String removeCourseBody(Object course) {
    return '$course will be removed from your home list.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String welcomeBack(Object name) {
    return 'Welcome back, $name!';
  }

  @override
  String get editCourses => 'Edit courses';

  @override
  String get done => 'Done';

  @override
  String get noCoursesToEdit => 'No courses to edit.';

  @override
  String get addCourse => 'Add Course';

  @override
  String get unknown => 'Unknown';

  @override
  String get iSpeak => 'I speak';

  @override
  String get iWantToLearn => 'I want to learn';

  @override
  String get chooseYourLanguage => 'Choose your language';

  @override
  String get chooseLearningLanguage => 'Choose learning language';

  @override
  String get chooseTwoDifferentLanguages => 'Choose two different languages.';

  @override
  String get createCourse => 'Create Course';

  @override
  String get soloCourseTitle => 'Solo Course';

  @override
  String get searchLanguage => 'Search language';

  @override
  String get noMatches => 'No matches';

  @override
  String get chooseCourseType => 'Choose a course type';

  @override
  String get soloStudyDescription =>
      'Study alone with the same quiz style as circles - but without rooms, chat, spectators, or host options.';

  @override
  String get soloModeVocabulary => 'Vocabulary';

  @override
  String get soloModeSentences => 'Sentences';

  @override
  String get soloModeReview => 'Review';

  @override
  String get soloModeVocabularySubtitle =>
      'Multiple choice meanings, synonyms, usage';

  @override
  String get soloModeSentencesSubtitle =>
      'Fill in the blank + translation + reading';

  @override
  String get soloModeReviewDescription =>
      'Practice what you learned: weak words, recent mistakes, and spaced repetition.';

  @override
  String get startReview => 'Start Review';

  @override
  String soloSetupTitle(Object mode) {
    return '$mode Setup';
  }

  @override
  String get difficulty => 'Difficulty';

  @override
  String get numberOfQuestions => 'Number of questions';

  @override
  String get timerPerQuestion => 'Timer per question';

  @override
  String get noTimer => 'No timer';

  @override
  String get start => 'Start';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSignInToMessage => 'Sign in to message';

  @override
  String get profileThatsYourProfile => 'That\'s your profile';

  @override
  String get profileSignInToAddFriends => 'Sign in to add friends';

  @override
  String get profileCantAddYourself => 'You can\'t add yourself';

  @override
  String profileRequestSent(Object username) {
    return 'Request sent to @$username';
  }

  @override
  String get profileRequestFailed => 'Couldn\'t send request';

  @override
  String get profileDefaultDisplayName => 'New User';

  @override
  String get profileDefaultBio => 'Ready to learn!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Guest';

  @override
  String get guestUsername => 'guest';

  @override
  String get guestSessionLabel => 'Guest session';

  @override
  String get unlockFullProfile => 'Unlock your full profile';

  @override
  String get guestBenefitSync => 'Sync progress across devices';

  @override
  String get guestBenefitCircles => 'Join Circles and play live';

  @override
  String get guestBenefitNotifications =>
      'Get notifications and friend requests';

  @override
  String get progressStaysOnDevice =>
      'Progress stays on this device until you sign in.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Goal: ${minutes}m';
  }

  @override
  String get profileXpProgress => 'XP Progress';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Wins';

  @override
  String get profileStreak => 'Streak';

  @override
  String get profileFriendsTitle => 'My Friends';

  @override
  String get profileViewAll => 'View all';

  @override
  String get profileAchievementsTitle => 'Achievements';

  @override
  String get profileNoAchievements => 'Még nincsenek eredmények';

  @override
  String get profileRequested => 'Requested';

  @override
  String get profileSending => 'Sending...';

  @override
  String get profileAddFriend => 'Add Friend';

  @override
  String get profileConnectTitle => 'Connect';

  @override
  String get profileMessage => 'Message';

  @override
  String get profileSnapshot => 'Profile Snapshot';

  @override
  String get profileLocationHidden => 'Location hidden';

  @override
  String get profileBioHidden => 'Bio hidden';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Daily goal ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Circle invite';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'Sign In to Join';

  @override
  String get joiningCircle => 'Joining...';

  @override
  String get joinCircle => 'Join Circle';

  @override
  String get circleJoinedAsPlayer => 'Joined as player';

  @override
  String get circleJoinedAsSpectator => 'Joined as spectator';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get open => 'Open';

  @override
  String get circleCountdownTitle => 'Get Ready';

  @override
  String get circleCountdownSubtitle => 'Circle is starting...';

  @override
  String get userFallbackName => 'User';

  @override
  String get micOff => 'Mic Off';

  @override
  String get micOn => 'Mic On';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'Spectator';

  @override
  String get tagHost => 'HOST';

  @override
  String get tagYou => 'YOU';

  @override
  String get statusCorrect => 'Correct';

  @override
  String get statusWrong => 'Wrong';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pts';

  @override
  String get pointsLabel => 'Points';

  @override
  String get statCorrect => 'Correct';

  @override
  String get statAnswers => 'answers';

  @override
  String get statTotal => 'Total';

  @override
  String get statQuestions => 'questions';

  @override
  String get statAccuracy => 'Accuracy';

  @override
  String get statRate => 'rate';

  @override
  String get statRank => 'Rank';

  @override
  String get statPosition => 'position';

  @override
  String get statMode => 'Mode';

  @override
  String get statType => 'type';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get continueLabel => 'Continue';

  @override
  String get save => 'Save';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToCourse => 'Back to Course';

  @override
  String get resultsTitle => 'Results';

  @override
  String get shareLater => 'Share later';

  @override
  String get delete => 'Delete';

  @override
  String get ok => 'OK';

  @override
  String minutesShort(Object minutes) {
    return '${minutes}m';
  }

  @override
  String timeShortMinutes(Object count) {
    return '${count}m';
  }

  @override
  String timeShortHours(Object count) {
    return '${count}h';
  }

  @override
  String timeShortDays(Object count) {
    return '${count}d';
  }

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String timeHoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String timeDaysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get liveQuizWaitingForHost => 'Waiting for host...';

  @override
  String get liveQuizJoinRequestSent => 'Join request sent';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Failed to request join: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Host controls';

  @override
  String get liveQuizSpectatorModeTitle => 'Spectator mode';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Rounds auto-advance when everyone answers or time runs out.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Watch questions and the live leaderboard. You can\'t answer.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Question $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Request Sent';

  @override
  String get liveQuizRequestToJoin => 'Request to Join';

  @override
  String get liveQuizSpectatorFooter =>
      'You\'re watching live. Enjoy the questions and leaderboard.';

  @override
  String get circleNotFound => 'Circle not found';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Failed to start rematch: $error';
  }

  @override
  String get resultsMatchTitle => 'Match Results';

  @override
  String resultsNiceWork(Object name) {
    return 'Nice work, $name';
  }

  @override
  String get resultsPlaceFirst => '1st Place';

  @override
  String get resultsPlaceSecond => '2nd Place';

  @override
  String get resultsPlaceThird => '3rd Place';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Place $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Out of $players players';
  }

  @override
  String get resultsHighlightChampion => 'Champion! You dominated this circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Great accuracy. You\'re close to the top!';

  @override
  String get resultsHighlightKeepGoing =>
      'Keep going - consistency beats speed.';

  @override
  String get resultsLeaderboardTitle => 'Leaderboard';

  @override
  String resultsPlayersCount(Object count) {
    return '$count players';
  }

  @override
  String get resultsBackToCircles => 'Back to Circles';

  @override
  String get resultsRematch => 'Rematch';

  @override
  String get resultsPlayAgain => 'Play Again';

  @override
  String get leaderboardGlobalTitle => 'Global Ranking';

  @override
  String get leaderboardEmpty => 'No rankings yet.';

  @override
  String get aboutTitle => 'Info';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'SOMA is a gamified language learning platform designed to make mastering new languages engaging and social. Compete in circles, practice solo, and track your progress.';

  @override
  String get aboutTerms => 'Terms of Service';

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutOpenSource => 'Open Source Licenses';

  @override
  String get addFriendTitle => 'Add Friend';

  @override
  String get addFriendFindByUsername => 'Find by username';

  @override
  String get addFriendUsernameHint => 'Type username...';

  @override
  String get addFriendTip => 'Tip: later we can support QR code + friend ID.';

  @override
  String get addFriendSending => 'Sending...';

  @override
  String get addFriendSendRequest => 'Send Request';

  @override
  String addFriendUserNotFound(Object username) {
    return 'User @$username not found';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Action failed or already sent: $error';
  }

  @override
  String get friendsTitle => 'Friends';

  @override
  String get searchFriendsHint => 'Search friends...';

  @override
  String get somaLearnerSubtitle => 'Soma Learner';

  @override
  String get friendRequestLabel => 'Request';

  @override
  String get friendRequestSentLabel => 'Request sent';

  @override
  String get friendIncomingRequestLabel => 'Incoming Request';

  @override
  String get friendRequestsSection => 'Requests';

  @override
  String get friendPendingSection => 'Pending';

  @override
  String get friendAllSection => 'All Friends';

  @override
  String get friendsEmptyState => 'No friends yet. Add your first friend!';

  @override
  String get friendsEmptyShort => 'No friends yet.';

  @override
  String noMatchForQuery(Object query) {
    return 'No match for \"$query\"';
  }

  @override
  String get inboxTitle => 'Inbox';

  @override
  String get searchChatsHint => 'Search chats...';

  @override
  String get inboxEmptyState =>
      'No conversations yet. Start chatting with a friend!';

  @override
  String get newMessageTitle => 'New message';

  @override
  String get chatCallLater => 'Voice call later (Circle voice is next)';

  @override
  String errorWithDetails(Object error) {
    return 'Error: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Say hi to $name!';
  }

  @override
  String get chatMessageHint => 'Message...';

  @override
  String get notificationsTitle => 'Értesítések';

  @override
  String get notificationsTabAll => 'All';

  @override
  String get notificationsTabCourses => 'Courses';

  @override
  String get notificationsTabSocial => 'Social';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'System';

  @override
  String get notificationsEmpty => 'Nincsenek még értesítések';

  @override
  String get notificationsDeleted => 'Notification deleted';

  @override
  String get notificationTitleFallback => 'Notification';

  @override
  String get notificationTypeCourse => 'Course';

  @override
  String get notificationTypeSocial => 'Social';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'System';

  @override
  String get notificationsFriendAccepted => 'Friend request accepted';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Couldn\'t accept friend request: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Friend request declined';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Couldn\'t decline friend request: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Nem sikerült csatlakozni a Körhöz: $error';
  }

  @override
  String get notificationsOpening => 'Megnyitás';

  @override
  String get notificationsOpened => 'Megnyitva';

  @override
  String notificationsActionMessage(Object action) {
    return '$action értesítés';
  }

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsSectionAccount => 'Fiók';

  @override
  String get settingsEditProfile => 'Profil Szerkesztése';

  @override
  String get settingsPrivacy => 'Adatvédelem';

  @override
  String get settingsSecurity => 'Biztonság';

  @override
  String get settingsSectionGameplay => 'Játékmenet';

  @override
  String get settingsShowTranslationLine => 'Fordítás Megjelenítése';

  @override
  String get settingsShowReadingLine => 'Olvasási Segédlet (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Idő per Kérdés';

  @override
  String get settingsMatchDifficulty => 'Meccs Nehézsége';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptív';

  @override
  String get settingsSectionSoundFeel => 'Hang és Érzet';

  @override
  String get settingsMusic => 'Zene';

  @override
  String get settingsSoundEffects => 'Hangeffektek';

  @override
  String get settingsHaptics => 'Rezgés';

  @override
  String get settingsSectionNotifications => 'Értesítések';

  @override
  String get settingsPushNotifications => 'Push Értesítések';

  @override
  String get settingsDailyReminder => 'Napi Emlékeztető';

  @override
  String get settingsSectionAppearance => 'Megjelenés';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsUiLanguage => 'Felület Nyelve';

  @override
  String get settingsSectionAbout => 'Névjegy';

  @override
  String get settingsVersion => 'Verzió';

  @override
  String get settingsTermsPrivacy => 'Feltételek és Adatvédelem';

  @override
  String get settingsSupport => 'Támogatás';

  @override
  String get settingsLogout => 'Kijelentkezés';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeDark => 'Sötét';

  @override
  String get themeLight => 'Világos';

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
  String get editProfileUpdated => 'Profil Frissítve';

  @override
  String get editProfileTitle => 'Profil Szerkesztése';

  @override
  String get editProfilePhotoLabel => 'Profilkép';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage Avatarválasztó hamarosan';

  @override
  String get editProfileChangePhoto => 'Módosít';

  @override
  String get editProfileAvatarUploadSoon => 'Avatar feltöltés hamarosan';

  @override
  String get editProfileDisplayNameLabel => 'Megjelenített Név';

  @override
  String get editProfileDisplayNameHint => 'A neved';

  @override
  String get editProfileDisplayNameRequired => 'Kérlek add meg a neved';

  @override
  String get editProfileDisplayNameTooShort => 'Túl rövid';

  @override
  String get editProfileUsernameLabel => 'Felhasználónév';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Kérlek add meg a felhasználóneved';

  @override
  String get editProfileUsernameTooShort => 'Legalább 3 karakter';

  @override
  String get editProfileUsernameInvalid => 'Csak betűk, számok, _';

  @override
  String get editProfileBioLabel => 'Bemutatkozás';

  @override
  String get editProfileBioHint => 'Rövid leírás rólad...';

  @override
  String get editProfileBioTooLong => 'Maximum 120 karakter';

  @override
  String get editProfileLocationLabel => 'Helyszín';

  @override
  String get editProfileLocationHint => 'Város / Ország';

  @override
  String get editProfileDailyGoalTitle => 'Napi Cél';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Válaszd ki, hány percet szeretnél tanulni naponta';

  @override
  String get securityTitle => 'Biztonság';

  @override
  String get securitySectionPassword => 'Jelszó';

  @override
  String get securityChangePasswordTitle => 'Jelszó Megváltoztatása';

  @override
  String get securityChangePasswordSubtitle =>
      'Frissítsd a jelszavad rendszeresen';

  @override
  String get securitySectionTwoFactor => 'Kétlépcsős Azonosítás';

  @override
  String get securityEnable2faTitle => '2FA Engedélyezése';

  @override
  String get securityEnable2faSubtitle => 'Extra biztonság bejelentkezéskor';

  @override
  String get securitySectionAppLock => 'Alkalmazás Zárolása';

  @override
  String get securityBiometricTitle => 'Biometrikus Feloldás';

  @override
  String get securityBiometricSubtitle =>
      'Használj FaceID/TouchID-t a SOMA feloldásához';

  @override
  String get securityAppLockTitle => 'Alkalmazás Zárolása';

  @override
  String get securityAppLockSubtitle => 'Zárold a SOMA-t, ha távozol';

  @override
  String get securitySectionSessions => 'Aktív Munkamenetek';

  @override
  String get securityNoSessions => 'Nincsenek aktív munkamenetek';

  @override
  String get securityThisDevice => 'Ez az Eszköz';

  @override
  String get securityDevice => 'Eszköz';

  @override
  String get securityActiveLabel => 'Aktív';

  @override
  String get securitySignInToEnable2fa =>
      'Jelentkezz be a 2FA engedélyezéséhez';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Nem sikerült engedélyezni a 2FA-t: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Nem sikerült kikapcsolni a 2FA-t: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA Beállítás';

  @override
  String get securitySecretKeyLabel => 'Titkos Kulcs';

  @override
  String get securityCodeHint => '6 jegyű kód';

  @override
  String get security2faEnabled => '2FA Engedélyezve';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Kód ellenőrzése sikertelen: $error';
  }

  @override
  String get securityVerifying => 'Ellenőrzés...';

  @override
  String get securityVerify => 'Ellenőrzés';

  @override
  String get securityCurrentPasswordHint => 'Jelenlegi Jelszó';

  @override
  String get securityNewPasswordHint => 'Új Jelszó (min 8 karakter)';

  @override
  String get securityConfirmPasswordHint => 'Új jelszó megerősítése';

  @override
  String get securitySignInToChangePassword =>
      'Jelentkezz be a jelszó megváltoztatásához';

  @override
  String get securityEnterCurrentPassword => 'Add meg a jelenlegi jelszavad';

  @override
  String get securityPasswordMinLength =>
      'Az új jelszónak legalább 8 karakternek kell lennie';

  @override
  String get securityPasswordsDoNotMatch => 'A jelszavak nem egyeznek';

  @override
  String get securityPasswordUpdated => 'Jelszó frissítve';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Nem sikerült frissíteni a jelszót: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatikus Zárolás';

  @override
  String get privacyTitle => 'Adatvédelem';

  @override
  String get privacySectionVisibility => 'Láthatóság';

  @override
  String get privacyProfileVisibilityTitle => 'Profil Láthatósága';

  @override
  String get privacyVisibilityPublic => 'Nyilvános';

  @override
  String get privacyVisibilityFriends => 'Barátok';

  @override
  String get privacyVisibilityPrivate => 'Privát';

  @override
  String get privacyVisibilityPublicSubtitle => 'Bárki láthatja a profilodat';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Csak barátok láthatják a profilodat';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Csak te láthatod a profilodat';

  @override
  String get privacySectionActivity => 'Tevékenység';

  @override
  String get privacyShowOnlineTitle => 'Online Állapot Mutatása';

  @override
  String get privacyShowOnlineSubtitle =>
      'Láthatják a játékosok, ha online vagy';

  @override
  String get privacyShowActivityTitle => 'Tanulási Tevékenység Mutatása';

  @override
  String get privacyShowActivitySubtitle =>
      'Sorozat, XP és legutóbbi haladás mutatása';

  @override
  String get privacySectionSocial => 'Közösségi';

  @override
  String get privacyAllowRequestsTitle => 'Barátkérések Engedélyezése';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Engedélyezd, hogy barátkérést küldjenek neked';

  @override
  String get privacyWhoCanDmTitle => 'Ki Küldhet Üzenetet';

  @override
  String get privacyDmEveryone => 'Bárki';

  @override
  String get privacyDmFriends => 'Barátok';

  @override
  String get privacyDmNoOne => 'Senki';

  @override
  String get privacyDmEveryoneSubtitle => 'Bárki küldhet neked üzenetet';

  @override
  String get privacyDmFriendsSubtitle => 'Csak barátok küldhetnek üzenetet';

  @override
  String get privacyDmNoOneSubtitle => 'Senki sem küldhet üzenetet';

  @override
  String get privacySectionBlockedUsers => 'Tiltott Felhasználók';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Tiltott felhasználók kezelése hamarosan';

  @override
  String get privacySectionDataControls => 'Adatkezelés';

  @override
  String get privacyExportDataTitle => 'Adataim Exportálása';

  @override
  String get privacyExportDataSubtitle =>
      'Töltsd le a tevékenységed és kurzusaid';

  @override
  String get privacyExportInfoTitle => 'Adatexportálás';

  @override
  String get privacyExportInfoBody =>
      'Egyéb: JSON/CSV export generálása és küldés emailben vagy letöltés';

  @override
  String get privacyDeleteAccountTitle => 'Fiók Törlése';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Ez véglegesen törli a fiókod és adataid';

  @override
  String get privacyDeleteConfirmTitle => 'Törlöd a Fiókot?';

  @override
  String get privacyDeleteConfirmBody =>
      'Ez nem visszavonható. A profilod, kurzusaid, barátaid és üzeneteid törlésre kerülnek';

  @override
  String get privacyDeleteComingSoon =>
      'A törlés később lesz integrálva a Supabase-szel';

  @override
  String get soloLabel => 'Szóló';

  @override
  String get soloResultsCompletedTitle => 'Szóló Szekció Kész';

  @override
  String get soloResultsFeedbackElite =>
      'Elit teljesítmény - tartsd életben a sorozatot';

  @override
  String get soloResultsFeedbackStrong => 'Szép munka - gyorsan fejlődsz';

  @override
  String get soloResultsFeedbackProgress =>
      'Jó haladás - nézd át a hibákat és próbáld újra';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Semmi gond - próbáld újra kevesebb kérdéssel és koncentrálj';

  @override
  String get soloResultsPerfectScore => 'Tökéletes pontszám! Nincs mit átnézni';

  @override
  String get soloResultsReviewPrompt =>
      'Nézd át a hibákat a gyorsabb tanulásért. A rossz válaszaid lentebb vannak';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Hibák Áttekintése ($count)';
  }

  @override
  String get authNotSignedIn => 'Nincs bejelentkezve';

  @override
  String get genericUser => 'Felhasználó';

  @override
  String get loading => 'Betöltés...';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get send => 'Küldés';

  @override
  String get join => 'Csatlakozás';

  @override
  String get leave => 'Kilépés';

  @override
  String get ready => 'Kész';

  @override
  String get levelBeginner => 'Kezdő';

  @override
  String get levelIntermediate => 'Középhaladó';

  @override
  String get levelAdvanced => 'Haladó';

  @override
  String questionsShort(Object count) {
    return '$count Kérdés';
  }

  @override
  String secondsShort(Object count) {
    return '$count Másodperc';
  }

  @override
  String get circlesAllCourses => 'Összes Kurzus';

  @override
  String get circlesAllModes => 'Összes Mód';

  @override
  String get circlesAllLevels => 'Összes Szint';

  @override
  String get circlesAddNewCourse => 'Új Kurzus Hozzáadása';

  @override
  String get circlesCoursesTitle => 'Kurzusok';

  @override
  String get circlesModeTitle => 'Mód';

  @override
  String get circlesLevelTitle => 'Szint';

  @override
  String get circlesNoActiveForFilters => 'Nincs aktív Kör ezekkel a szűrőkkel';

  @override
  String get circlesUnknownRoom => 'Ismeretlen Szoba';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Kör Létrehozása';

  @override
  String get circlesCircleName => 'Kör Neve';

  @override
  String get circlesEnterName => 'Add meg a nevet';

  @override
  String get circlesLanguages => 'Nyelvek';

  @override
  String get circlesRoomSetup => 'Szoba Beállítás';

  @override
  String get circlesPlayers => 'Játékosok';

  @override
  String get circlesEmptySlot => 'Üres Hely';

  @override
  String get circlesPlayersRange => '1-5 Játékos';

  @override
  String get circlesQuestions => 'Kérdések';

  @override
  String get circlesQuestionsSubtitle => 'Kérdések mennyisége';

  @override
  String get circlesTimePerQuestion => 'Idő per Kérdés';

  @override
  String get circlesSecondsPerQuestion => 'Mp/Kérdés';

  @override
  String get circlesAdvanced => 'Haladó';

  @override
  String get circlesAllowSpectators => 'Nézők Engedélyezése';

  @override
  String get circlesAllowSpectatorsSubtitle => 'Mások nézhetik játék nélkül';

  @override
  String get circlesLiveVoiceChat => 'Élő Hangcsevegés';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Hangos interakció engedélyezése meccs közben';

  @override
  String get circlesLiveTextChat => 'Élő Szöveges Csevegés';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Üzenetküldés engedélyezése meccs közben';

  @override
  String get circlesCreatedSuccess => 'Kör létrehozva';

  @override
  String circlesCreateError(Object error) {
    return 'Nem sikerült létrehozni a Kört: $error';
  }

  @override
  String get circlesHostTip => 'Tipp: Létrehozás után meghívhatsz barátokat';

  @override
  String circlesJoinError(Object error) {
    return 'Nem sikerült csatlakozni a Körhöz: $error';
  }

  @override
  String get circlesLobbyTitle => 'Kör Előszoba';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kód: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Meccs Beállítások';

  @override
  String circlesLevelWithValue(Object level) {
    return '$level Szint';
  }

  @override
  String get circlesDifficulty => 'Nehézség';

  @override
  String get circlesPerQuestionShort => 'Kérdésenként';

  @override
  String get circlesInvite => 'Meghívás';

  @override
  String get circlesCopyId => 'ID Másolása';

  @override
  String get circlesCopiedId => 'ID másolva';

  @override
  String get circlesMatchInProgress => 'Meccs folyamatban';

  @override
  String get circlesSpectatorQueuedBody =>
      'Meccs folyamatban. Nézőként fogsz csatlakozni';

  @override
  String get circlesHostStartWhenReady => 'A házigazda indít, ha mindenki kész';

  @override
  String get circlesSpectators => 'Nézők';

  @override
  String get circlesSpectator => 'Néző';

  @override
  String get circlesSpectatorCanWatch => 'A nézők élőben nézhetik';

  @override
  String get circlesJoinRequests => 'Csatlakozási Kérések';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Fogadd el a nézőket a meccs kezdése előtt';

  @override
  String get circlesStartGame => 'Játék Indítása';

  @override
  String get circlesWaitingForPlayers => 'Várakozás játékosokra';

  @override
  String get circlesLeaveCircle => 'Kör Elhagyása';

  @override
  String get circlesRequestSent => 'Kérés elküldve';

  @override
  String get circlesRequestToJoin => 'Csatlakozás Kérése';

  @override
  String get circlesWatchLive => 'Élőben Nézés';

  @override
  String get circlesPlayerTip =>
      'Nyomj a \'Kész\'-re, ha készen állsz. A házigazda indítja a meccset';

  @override
  String get circlesSpectatorTip =>
      'Néző vagy. Nézd az akciót élőben, amint a házigazda indít';

  @override
  String get circlesHostControls => 'Házigazda Kezelése';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Házigazda átadása sikertelen: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Kör bezárása sikertelen: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username felhasználó nem található';
  }

  @override
  String get circlesInvalidUser => 'Érvénytelen felhasználó';

  @override
  String get circlesCantInviteSelf => 'Nem hívhatod meg magad';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username már a Körben van';
  }

  @override
  String get circlesDefaultHost => 'Házigazda';

  @override
  String get circlesDefaultTitle => 'Kör';

  @override
  String get circlesInviteByUsername => 'Felhasználónév Alapján';

  @override
  String circlesInviteSent(Object username) {
    return 'Meghívó elküldve: @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Nem sikerült elküldeni a meghívót: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Csatlakozási kérés elküldve';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'A kérés sikertelen: $error';
  }

  @override
  String get circlesFull => 'A Kör megtelt';

  @override
  String get circlesSpectatorAdded => 'Néző hozzáadva';

  @override
  String circlesApproveFailed(Object error) {
    return 'Jóváhagyás sikertelen: $error';
  }

  @override
  String get circlesRequestDeclined => 'Kérés elutasítva';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Elutasítás sikertelen: $error';
  }

  @override
  String get circlesParticipant => 'Résztvevő';

  @override
  String get circlesLeavePromptTitle => 'Elhagyod a Kört?';

  @override
  String get circlesLeavePromptTransfer =>
      'Add át a házigazda szerepet távozás előtt';

  @override
  String get circlesLeavePromptEndOnly => 'Kör bezárása és távozás';

  @override
  String get circlesTransferHost => 'Házigazda Átadása';

  @override
  String get circlesEndCircle => 'Kör Bezárása';

  @override
  String get circlesTransferHostTitle => 'Házigazda Átadása';

  @override
  String circlesShareId(Object id) {
    return 'Kör ID: $id';
  }
}
