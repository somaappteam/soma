// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Learn. Compete. Master.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get skipForNow => 'Skip for Now';

  @override
  String get authFillAllFields => 'Please fill in all fields';

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
  String get profileNoAchievements => 'Zatím žádné úspěchy';

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
  String get notificationsTitle => 'Oznámení';

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
  String get notificationsEmpty => 'Zatím žádná oznámení';

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
    return 'Připojení ke Kruhu selhalo: $error';
  }

  @override
  String get notificationsOpening => 'Otevírání';

  @override
  String get notificationsOpened => 'Otevřeno';

  @override
  String notificationsActionMessage(Object action) {
    return 'Oznámení $action';
  }

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsSectionAccount => 'Účet';

  @override
  String get settingsEditProfile => 'Upravit Profil';

  @override
  String get settingsPrivacy => 'Soukromí';

  @override
  String get settingsSecurity => 'Zabezpečení';

  @override
  String get settingsSectionGameplay => 'Hratelnost';

  @override
  String get settingsShowTranslationLine => 'Zobrazit Překladový Řádek';

  @override
  String get settingsShowReadingLine => 'Zobrazit Čtecí Řádek (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Čas na Otázku';

  @override
  String get settingsMatchDifficulty => 'Obtížnost Zápasu';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptivní';

  @override
  String get settingsSectionSoundFeel => 'Zvuk a Pocit';

  @override
  String get settingsMusic => 'Hudba';

  @override
  String get settingsSoundEffects => 'Zvukové Efekty';

  @override
  String get settingsHaptics => 'Haptika';

  @override
  String get settingsSectionNotifications => 'Oznámení';

  @override
  String get settingsPushNotifications => 'Push Oznámení';

  @override
  String get settingsDailyReminder => 'Denní Připomínka';

  @override
  String get settingsSectionAppearance => 'Vzhled';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsUiLanguage => 'Jazyk UI';

  @override
  String get settingsSectionAbout => 'O aplikaci';

  @override
  String get settingsVersion => 'Verze';

  @override
  String get settingsTermsPrivacy => 'Podmínky a Soukromí';

  @override
  String get settingsSupport => 'Podpora';

  @override
  String get settingsLogout => 'Odhlásit se';

  @override
  String get themeSystem => 'Systém';

  @override
  String get themeDark => 'Tmavé';

  @override
  String get themeLight => 'Světlé';

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
  String get editProfileUpdated => 'Profil Aktualizován';

  @override
  String get editProfileTitle => 'Upravit Profil';

  @override
  String get editProfilePhotoLabel => 'Profilová Fotka';

  @override
  String get editProfilePhotoSubtitle =>
      'Výběr Avatara ze Supabase Storage již brzy';

  @override
  String get editProfileChangePhoto => 'Změnit';

  @override
  String get editProfileAvatarUploadSoon => 'Nahrávání Avatara již brzy';

  @override
  String get editProfileDisplayNameLabel => 'Zobrazované Jméno';

  @override
  String get editProfileDisplayNameHint => 'Vaše jméno';

  @override
  String get editProfileDisplayNameRequired => 'Prosím zadejte své jméno';

  @override
  String get editProfileDisplayNameTooShort => 'Příliš krátké';

  @override
  String get editProfileUsernameLabel => 'Uživatelské Jméno';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Prosím zadejte uživatelské jméno';

  @override
  String get editProfileUsernameTooShort => 'Alespoň 3 znaky';

  @override
  String get editProfileUsernameInvalid => 'Pouze písmena, čísla, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Krátký popis o vás...';

  @override
  String get editProfileBioTooLong => 'Maximálně 120 znaků';

  @override
  String get editProfileLocationLabel => 'Místo';

  @override
  String get editProfileLocationHint => 'Město / Země';

  @override
  String get editProfileDailyGoalTitle => 'Denní Cíl';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Vyberte, kolik minut se chcete denně učit';

  @override
  String get securityTitle => 'Zabezpečení';

  @override
  String get securitySectionPassword => 'Heslo';

  @override
  String get securityChangePasswordTitle => 'Změnit Heslo';

  @override
  String get securityChangePasswordSubtitle =>
      'Pravidelně aktualizujte své heslo';

  @override
  String get securitySectionTwoFactor => 'Dvoufaktorové Ověření';

  @override
  String get securityEnable2faTitle => 'Povolit 2FA';

  @override
  String get securityEnable2faSubtitle => 'Extra zabezpečení při přihlašování';

  @override
  String get securitySectionAppLock => 'Zámek Aplikace';

  @override
  String get securityBiometricTitle => 'Biometrické Odemknutí';

  @override
  String get securityBiometricSubtitle =>
      'Použít FaceID/TouchID k odemknutí SOMA';

  @override
  String get securityAppLockTitle => 'Zámek Aplikace';

  @override
  String get securityAppLockSubtitle => 'Zamknout SOMA při odchodu';

  @override
  String get securitySectionSessions => 'Aktivní Relace';

  @override
  String get securityNoSessions => 'Žádné aktivní relace';

  @override
  String get securityThisDevice => 'Toto Zařízení';

  @override
  String get securityDevice => 'Zařízení';

  @override
  String get securityActiveLabel => 'Aktivní';

  @override
  String get securitySignInToEnable2fa => 'Přihlaste se pro povolení 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Nepodařilo se povolit 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Nepodařilo se zakázat 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Nastavení 2FA';

  @override
  String get securitySecretKeyLabel => 'Tajný Klíč';

  @override
  String get securityCodeHint => '6místný kód';

  @override
  String get security2faEnabled => '2FA Povoleno';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Nepodařilo se ověřit kód: $error';
  }

  @override
  String get securityVerifying => 'Ověřování...';

  @override
  String get securityVerify => 'Ověřit';

  @override
  String get securityCurrentPasswordHint => 'Současné Heslo';

  @override
  String get securityNewPasswordHint => 'Nové Heslo (min 8 znaků)';

  @override
  String get securityConfirmPasswordHint => 'Potvrdit nové heslo';

  @override
  String get securitySignInToChangePassword => 'Přihlaste se pro změnu hesla';

  @override
  String get securityEnterCurrentPassword => 'Zadejte své současné heslo';

  @override
  String get securityPasswordMinLength => 'Nové heslo musí mít alespoň 8 znaků';

  @override
  String get securityPasswordsDoNotMatch => 'Hesla se neshodují';

  @override
  String get securityPasswordUpdated => 'Heslo aktualizováno';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Nepodařilo se aktualizovat heslo: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automaticky Zamknout Po';

  @override
  String get privacyTitle => 'Soukromí';

  @override
  String get privacySectionVisibility => 'Viditelnost';

  @override
  String get privacyProfileVisibilityTitle => 'Viditelnost Profilu';

  @override
  String get privacyVisibilityPublic => 'Veřejné';

  @override
  String get privacyVisibilityFriends => 'Přátelé';

  @override
  String get privacyVisibilityPrivate => 'Soukromé';

  @override
  String get privacyVisibilityPublicSubtitle => 'Kdokoli může vidět váš profil';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Pouze přátelé mohou vidět váš profil';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Pouze vy můžete vidět váš profil';

  @override
  String get privacySectionActivity => 'Aktivita';

  @override
  String get privacyShowOnlineTitle => 'Zobrazit Stav Online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Povolit hráčům vidět, kdy jste online';

  @override
  String get privacyShowActivityTitle => 'Zobrazit Aktivitu Učení';

  @override
  String get privacyShowActivitySubtitle =>
      'Zobrazit řadu, XP a nedávný pokrok';

  @override
  String get privacySectionSocial => 'Sociální';

  @override
  String get privacyAllowRequestsTitle => 'Povolit Žádosti o Přátelství';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Povolit lidem posílat vám žádosti o přátelství';

  @override
  String get privacyWhoCanDmTitle => 'Kdo může poslat DM';

  @override
  String get privacyDmEveryone => 'Kdokoli';

  @override
  String get privacyDmFriends => 'Přátelé';

  @override
  String get privacyDmNoOne => 'Nikdo';

  @override
  String get privacyDmEveryoneSubtitle => 'Kdokoli vám může poslat zprávu';

  @override
  String get privacyDmFriendsSubtitle =>
      'Pouze přátelé vám mohou poslat zprávu';

  @override
  String get privacyDmNoOneSubtitle => 'Nikdo vám nemůže poslat zprávu';

  @override
  String get privacySectionBlockedUsers => 'Blokovaní Uživatelé';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Správa blokovaných uživatelů již brzy';

  @override
  String get privacySectionDataControls => 'Ovládání Dat';

  @override
  String get privacyExportDataTitle => 'Exportovat Má Data';

  @override
  String get privacyExportDataSubtitle => 'Stáhnout vaši aktivitu a kurzy';

  @override
  String get privacyExportInfoTitle => 'Export Dat';

  @override
  String get privacyExportInfoBody =>
      'Jiné: Vygenerovat export JSON/CSV a poslat emailem nebo stáhnout přímo';

  @override
  String get privacyDeleteAccountTitle => 'Smazat Účet';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Tím trvale smažete svůj účet a data';

  @override
  String get privacyDeleteConfirmTitle => 'Smazat Účet?';

  @override
  String get privacyDeleteConfirmBody =>
      'Tuto akci nelze vzít zpět. Váš profil, kurzy, přátelé a zprávy budou smazány';

  @override
  String get privacyDeleteComingSoon =>
      'Mazání bude integrováno se Supabase později';

  @override
  String get soloLabel => 'Sólo';

  @override
  String get soloResultsCompletedTitle => 'Sólo Relace Dokončena';

  @override
  String get soloResultsFeedbackElite => 'Elitní výkon - udržte řadu naživu';

  @override
  String get soloResultsFeedbackStrong => 'Skvělá práce - rychle se zlepšujete';

  @override
  String get soloResultsFeedbackProgress =>
      'Dobrý pokrok - zkontrolujte chyby a zkuste to znovu';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Žádný tlak - zkuste to znovu s méně otázkami a soustřeďte se';

  @override
  String get soloResultsPerfectScore =>
      'Perfektní skóre! Žádné chyby k přezkoumání';

  @override
  String get soloResultsReviewPrompt =>
      'Přezkoumejte chyby pro rychlejší učení. Vaše špatné odpovědi jsou níže';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Přezkoumat Chyby ($count)';
  }

  @override
  String get authNotSignedIn => 'Nepřihlášen';

  @override
  String get genericUser => 'Uživatel';

  @override
  String get loading => 'Načítání...';

  @override
  String get edit => 'Upravit';

  @override
  String get send => 'Odeslat';

  @override
  String get join => 'Připojit se';

  @override
  String get leave => 'Odejít';

  @override
  String get ready => 'Připraven';

  @override
  String get levelBeginner => 'Začátečník';

  @override
  String get levelIntermediate => 'Pokročilý';

  @override
  String get levelAdvanced => 'Expert';

  @override
  String questionsShort(Object count) {
    return '$count Otázek';
  }

  @override
  String secondsShort(Object count) {
    return '$count Sekund';
  }

  @override
  String get circlesAllCourses => 'Všechny Kurzy';

  @override
  String get circlesAllModes => 'Všechny Režimy';

  @override
  String get circlesAllLevels => 'Všechny Úrovně';

  @override
  String get circlesAddNewCourse => 'Přidat Nový Kurz';

  @override
  String get circlesCoursesTitle => 'Kurzy';

  @override
  String get circlesModeTitle => 'Režim';

  @override
  String get circlesLevelTitle => 'Úroveň';

  @override
  String get circlesNoActiveForFilters => 'Žádný aktivní Kruh pro tyto filtry';

  @override
  String get circlesUnknownRoom => 'Neznámá Místnost';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Vytvořit Kruh';

  @override
  String get circlesCircleName => 'Název Kruhu';

  @override
  String get circlesEnterName => 'Zadejte název';

  @override
  String get circlesLanguages => 'Jazyky';

  @override
  String get circlesRoomSetup => 'Nastavení Místnosti';

  @override
  String get circlesPlayers => 'Hráči';

  @override
  String get circlesEmptySlot => 'Prázdný Slot';

  @override
  String get circlesPlayersRange => '1-5 Hráčů';

  @override
  String get circlesQuestions => 'Otázky';

  @override
  String get circlesQuestionsSubtitle => 'Množství otázek';

  @override
  String get circlesTimePerQuestion => 'Čas na Otázku';

  @override
  String get circlesSecondsPerQuestion => 'Sek/Otázku';

  @override
  String get circlesAdvanced => 'Expert';

  @override
  String get circlesAllowSpectators => 'Povolit Diváky';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Povolit ostatním sledovat bez hraní';

  @override
  String get circlesLiveVoiceChat => 'Živý Hlasový Chat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Povolit hlasovou interakci během zápasu';

  @override
  String get circlesLiveTextChat => 'Živý Textový Chat';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Povolit posílání zpráv během zápasu';

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
  String get circlesCreatedSuccess => 'Kruh vytvořen';

  @override
  String circlesCreateError(Object error) {
    return 'Nepodařilo se vytvořit Kruh: $error';
  }

  @override
  String get circlesHostTip => 'Tip: Můžete pozvat přátele po vytvoření';

  @override
  String circlesJoinError(Object error) {
    return 'Nepodařilo se připojit ke Kruhu: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby Kruhu';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kód: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Nastavení Zápasu';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Úroveň $level';
  }

  @override
  String get circlesDifficulty => 'Obtížnost';

  @override
  String get circlesPerQuestionShort => 'Na otázku';

  @override
  String get circlesInvite => 'Pozvat';

  @override
  String get circlesCopyId => 'Kopírovat ID';

  @override
  String get circlesCopiedId => 'ID zkopírováno';

  @override
  String get circlesMatchInProgress => 'Zápas probíhá';

  @override
  String get circlesSpectatorQueuedBody =>
      'Zápas probíhá. Připojíte se jako divák';

  @override
  String get circlesHostStartWhenReady =>
      'Hostitel začne, až budou všichni připraveni';

  @override
  String get circlesSpectators => 'Diváci';

  @override
  String get circlesSpectator => 'Divák';

  @override
  String get circlesSpectatorCanWatch => 'Diváci mohou sledovat živě';

  @override
  String get circlesJoinRequests => 'Žádosti o Připojení';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Přijměte diváky před začátkem zápasu';

  @override
  String get circlesStartGame => 'Spustit Hru';

  @override
  String get circlesWaitingForPlayers => 'Čekání na hráče';

  @override
  String get circlesLeaveCircle => 'Opustit Kruh';

  @override
  String get circlesRequestSent => 'Žádost odeslána';

  @override
  String get circlesRequestToJoin => 'Požádat o Připojení';

  @override
  String get circlesWatchLive => 'Sledovat Živě';

  @override
  String get circlesPlayerTip =>
      'Klepněte na \'Připraven\', až budete připraveni. Hostitel spustí zápas';

  @override
  String get circlesSpectatorTip =>
      'Díváte se. Sledujte akci živě, až hostitel začne';

  @override
  String get circlesHostControls => 'Ovládání Hostitele';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Nepodařilo se převést hostitele: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Nepodařilo se ukončit Kruh: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Uživatel @$username nenalezen';
  }

  @override
  String get circlesInvalidUser => 'Neplatný uživatel';

  @override
  String get circlesCantInviteSelf => 'Nemůžete pozvat sami sebe';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username je již v Kruhu';
  }

  @override
  String get circlesDefaultHost => 'Hostitel';

  @override
  String get circlesDefaultTitle => 'Kruh';

  @override
  String get circlesInviteByUsername => 'Podle Uživatelského Jména';

  @override
  String circlesInviteSent(Object username) {
    return 'Pozvánka odeslána uživateli @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Nepodařilo se odeslat pozvánku: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Žádost o připojení odeslána';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Žádost selhala: $error';
  }

  @override
  String get circlesFull => 'Kruh je plný';

  @override
  String get circlesSpectatorAdded => 'Divák přidán';

  @override
  String circlesApproveFailed(Object error) {
    return 'Nepodařilo se schválit: $error';
  }

  @override
  String get circlesRequestDeclined => 'Žádost odmítnuta';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Nepodařilo se odmítnout: $error';
  }

  @override
  String get circlesParticipant => 'Účastník';

  @override
  String get circlesLeavePromptTitle => 'Opustit Kruh?';

  @override
  String get circlesLeavePromptTransfer => 'Převeďte hostitele před odchodem';

  @override
  String get circlesLeavePromptEndOnly => 'Ukončit Kruh a odejít';

  @override
  String get circlesTransferHost => 'Převést Hostitele';

  @override
  String get circlesEndCircle => 'Ukončit Kruh';

  @override
  String get circlesTransferHostTitle => 'Převod Hostitele';

  @override
  String circlesShareId(Object id) {
    return 'ID Kruhu: $id';
  }
}
