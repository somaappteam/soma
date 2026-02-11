// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

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
  String get profileNoAchievements => 'Ei vielä saavutuksia';

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
  String get notificationsTitle => 'Ilmoitukset';

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
  String get notificationsEmpty => 'Ei vielä ilmoituksia';

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
    return 'Piiriin liittyminen epäonnistui: $error';
  }

  @override
  String get notificationsOpening => 'Avataan';

  @override
  String get notificationsOpened => 'Avattu';

  @override
  String notificationsActionMessage(Object action) {
    return '$action ilmoitus';
  }

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsSectionAccount => 'Tili';

  @override
  String get settingsEditProfile => 'Muokkaa Profiilia';

  @override
  String get settingsPrivacy => 'Yksityisyys';

  @override
  String get settingsSecurity => 'Turvallisuus';

  @override
  String get settingsSectionGameplay => 'Pelattavuus';

  @override
  String get settingsShowTranslationLine => 'Näytä Käännösrivi';

  @override
  String get settingsShowReadingLine => 'Näytä Lukurivi (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Aika per Kysymys';

  @override
  String get settingsMatchDifficulty => 'Matsin Vaikeusaste';

  @override
  String get settingsMatchDifficultyAdaptive => 'Mukautuva';

  @override
  String get settingsSectionSoundFeel => 'Ääni & Tuntuma';

  @override
  String get settingsMusic => 'Musiikki';

  @override
  String get settingsSoundEffects => 'Äänitehosteet';

  @override
  String get settingsHaptics => 'Värinä';

  @override
  String get settingsSectionNotifications => 'Ilmoitukset';

  @override
  String get settingsPushNotifications => 'Push-ilmoitukset';

  @override
  String get settingsDailyReminder => 'Päivittäinen Muistutus';

  @override
  String get settingsSectionAppearance => 'Ulkoasu';

  @override
  String get settingsTheme => 'Teema';

  @override
  String get settingsUiLanguage => 'Käyttöliittymän Kieli';

  @override
  String get settingsSectionAbout => 'Tietoja';

  @override
  String get settingsVersion => 'Versio';

  @override
  String get settingsTermsPrivacy => 'Ehdot & Yksityisyys';

  @override
  String get settingsSupport => 'Tuki';

  @override
  String get settingsLogout => 'Kirjaudu Ulos';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeDark => 'Tumma';

  @override
  String get themeLight => 'Vaalea';

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
  String get editProfileUpdated => 'Profiili Päivitetty';

  @override
  String get editProfileTitle => 'Muokkaa Profiilia';

  @override
  String get editProfilePhotoLabel => 'Profiilikuva';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage Avatar-valitsin tulossa pian';

  @override
  String get editProfileChangePhoto => 'Vaihda';

  @override
  String get editProfileAvatarUploadSoon => 'Avatarin lataus tulossa pian';

  @override
  String get editProfileDisplayNameLabel => 'Näyttönimi';

  @override
  String get editProfileDisplayNameHint => 'Sinun nimesi';

  @override
  String get editProfileDisplayNameRequired => 'Anna nimesi';

  @override
  String get editProfileDisplayNameTooShort => 'Liian lyhyt';

  @override
  String get editProfileUsernameLabel => 'Käyttäjätunnus';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Anna käyttäjätunnus';

  @override
  String get editProfileUsernameTooShort => 'Vähintään 3 merkkiä';

  @override
  String get editProfileUsernameInvalid => 'Vain kirjaimia, numeroita, _';

  @override
  String get editProfileBioLabel => 'Kuvaus';

  @override
  String get editProfileBioHint => 'Lyhyt kuvaus sinusta...';

  @override
  String get editProfileBioTooLong => 'Enintään 120 merkkiä';

  @override
  String get editProfileLocationLabel => 'Sijainti';

  @override
  String get editProfileLocationHint => 'Kaupunki / Maa';

  @override
  String get editProfileDailyGoalTitle => 'Päivittäinen Tavoite';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Valitse kuinka monta minuuttia haluat oppia päivässä';

  @override
  String get securityTitle => 'Turvallisuus';

  @override
  String get securitySectionPassword => 'Salasana';

  @override
  String get securityChangePasswordTitle => 'Vaihda Salasana';

  @override
  String get securityChangePasswordSubtitle =>
      'Päivitä salasanasi säännöllisesti';

  @override
  String get securitySectionTwoFactor => 'Kaksivaiheinen Tunnistautuminen';

  @override
  String get securityEnable2faTitle => 'Ota 2FA Käyttöön';

  @override
  String get securityEnable2faSubtitle => 'Lisäturvaa kirjautumiseen';

  @override
  String get securitySectionAppLock => 'Sovelluksen Lukitus';

  @override
  String get securityBiometricTitle => 'Biometrinen Avaus';

  @override
  String get securityBiometricSubtitle =>
      'Käytä FaceID/TouchID:tä SOMAn avaamiseen';

  @override
  String get securityAppLockTitle => 'Sovelluksen Lukitus';

  @override
  String get securityAppLockSubtitle => 'Lukitse SOMA kun poistut';

  @override
  String get securitySectionSessions => 'Aktiiviset Istunnot';

  @override
  String get securityNoSessions => 'Ei aktiivisia istuntoja';

  @override
  String get securityThisDevice => 'Tämä Laite';

  @override
  String get securityDevice => 'Laite';

  @override
  String get securityActiveLabel => 'Aktiivinen';

  @override
  String get securitySignInToEnable2fa =>
      'Kirjaudu sisään ottaaksesi 2FA:n käyttöön';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA:n käyttöönotto epäonnistui: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA:n poistaminen käytöstä epäonnistui: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA Asennus';

  @override
  String get securitySecretKeyLabel => 'Salainen Avain';

  @override
  String get securityCodeHint => '6-numeroinen koodi';

  @override
  String get security2faEnabled => '2FA Käytössä';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Koodin vahvistaminen epäonnistui: $error';
  }

  @override
  String get securityVerifying => 'Vahvistetaan...';

  @override
  String get securityVerify => 'Vahvista';

  @override
  String get securityCurrentPasswordHint => 'Nykyinen Salasana';

  @override
  String get securityNewPasswordHint => 'Uusi Salasana (min 8 merkkiä)';

  @override
  String get securityConfirmPasswordHint => 'Vahvista uusi salasana';

  @override
  String get securitySignInToChangePassword =>
      'Kirjaudu sisään vaihtaaksesi salasanan';

  @override
  String get securityEnterCurrentPassword => 'Anna nykyinen salasanasi';

  @override
  String get securityPasswordMinLength =>
      'Uuden salasanan on oltava vähintään 8 merkkiä';

  @override
  String get securityPasswordsDoNotMatch => 'Salasanat eivät täsmää';

  @override
  String get securityPasswordUpdated => 'Salasana päivitetty';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Salasanan päivitys epäonnistui: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automaattinen Lukitus Jälkeen';

  @override
  String get privacyTitle => 'Yksityisyys';

  @override
  String get privacySectionVisibility => 'Näkyvyys';

  @override
  String get privacyProfileVisibilityTitle => 'Profiilin Näkyvyys';

  @override
  String get privacyVisibilityPublic => 'Julkinen';

  @override
  String get privacyVisibilityFriends => 'Kaverit';

  @override
  String get privacyVisibilityPrivate => 'Yksityinen';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Kuka tahansa voi nähdä profiilisi';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Vain kaverit voivat nähdä profiilisi';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Vain sinä voit nähdä profiilisi';

  @override
  String get privacySectionActivity => 'Toiminta';

  @override
  String get privacyShowOnlineTitle => 'Näytä Online-tila';

  @override
  String get privacyShowOnlineSubtitle =>
      'Salli pelaajien nähdä kun olet online';

  @override
  String get privacyShowActivityTitle => 'Näytä Oppimistoiminta';

  @override
  String get privacyShowActivitySubtitle =>
      'Näytä putki, XP ja viimeaikainen edistyminen';

  @override
  String get privacySectionSocial => 'Sosiaalinen';

  @override
  String get privacyAllowRequestsTitle => 'Salli Kaveripyynnöt';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Salli ihmisten lähettää sinulle kaveripyyntöjä';

  @override
  String get privacyWhoCanDmTitle => 'Kuka Voi Lähettää Viestejä';

  @override
  String get privacyDmEveryone => 'Kaikki';

  @override
  String get privacyDmFriends => 'Kaverit';

  @override
  String get privacyDmNoOne => 'Ei Kukaan';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Kuka tahansa voi lähettää sinulle viestejä';

  @override
  String get privacyDmFriendsSubtitle =>
      'Vain kaverit voivat lähettää sinulle viestejä';

  @override
  String get privacyDmNoOneSubtitle =>
      'Kukaan ei voi lähettää sinulle viestejä';

  @override
  String get privacySectionBlockedUsers => 'Estetyt Käyttäjät';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Estettyjen käyttäjien hallinta tulossa pian';

  @override
  String get privacySectionDataControls => 'Tietojen Hallinta';

  @override
  String get privacyExportDataTitle => 'Vie Tietoni';

  @override
  String get privacyExportDataSubtitle => 'Lataa toimintasi ja kurssisi';

  @override
  String get privacyExportInfoTitle => 'Tietojen Vienti';

  @override
  String get privacyExportInfoBody =>
      'Muu: Luo JSON/CSV vienti ja lähetä sähköpostitse tai lataa suoraan';

  @override
  String get privacyDeleteAccountTitle => 'Poista Tili';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Tämä poistaa tilisi ja tietosi pysyvästi';

  @override
  String get privacyDeleteConfirmTitle => 'Poista Tili?';

  @override
  String get privacyDeleteConfirmBody =>
      'Tätä ei voi kumota. Profiilisi, kurssisi, kaverisi ja viestisi poistetaan';

  @override
  String get privacyDeleteComingSoon =>
      'Poistaminen integroidaan Supabasen kanssa myöhemmin';

  @override
  String get soloLabel => 'Soolo';

  @override
  String get soloResultsCompletedTitle => 'Soolosessio Valmis';

  @override
  String get soloResultsFeedbackElite => 'Huippusuoritus - pidä putki elossa';

  @override
  String get soloResultsFeedbackStrong => 'Hyvää työtä - kehityt nopeasti';

  @override
  String get soloResultsFeedbackProgress =>
      'Hyvää edistymistä - tarkista virheet ja yritä uudelleen';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Ei paineita - yritä uudelleen vähemmillä kysymyksillä ja keskity';

  @override
  String get soloResultsPerfectScore => 'Täydellinen tulos! Ei tarkistettavaa';

  @override
  String get soloResultsReviewPrompt =>
      'Tarkista virheesi oppiaksesi nopeammin. Väärät vastauksesi ovat alla';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Tarkista Virheet ($count)';
  }

  @override
  String get authNotSignedIn => 'Ei kirjautunut';

  @override
  String get genericUser => 'Käyttäjä';

  @override
  String get loading => 'Ladataan...';

  @override
  String get edit => 'Muokkaa';

  @override
  String get send => 'Lähetä';

  @override
  String get join => 'Liity';

  @override
  String get leave => 'Poistu';

  @override
  String get ready => 'Valmis';

  @override
  String get levelBeginner => 'Aloittelija';

  @override
  String get levelIntermediate => 'Keskitaso';

  @override
  String get levelAdvanced => 'Edistynyt';

  @override
  String questionsShort(Object count) {
    return '$count Kysymystä';
  }

  @override
  String secondsShort(Object count) {
    return '$count Sekuntia';
  }

  @override
  String get circlesAllCourses => 'Kaikki Kurssit';

  @override
  String get circlesAllModes => 'Kaikki Tilat';

  @override
  String get circlesAllLevels => 'Kaikki Tasot';

  @override
  String get circlesAddNewCourse => 'Lisää Uusi Kurssi';

  @override
  String get circlesCoursesTitle => 'Kurssit';

  @override
  String get circlesModeTitle => 'Tila';

  @override
  String get circlesLevelTitle => 'Taso';

  @override
  String get circlesNoActiveForFilters =>
      'Ei aktiivista piiriä näillä suodattimilla';

  @override
  String get circlesUnknownRoom => 'Tuntematon Huone';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Luo Piiri';

  @override
  String get circlesCircleName => 'Piirin Nimi';

  @override
  String get circlesEnterName => 'Anna nimi';

  @override
  String get circlesLanguages => 'Kielet';

  @override
  String get circlesRoomSetup => 'Huoneen Asetukset';

  @override
  String get circlesPlayers => 'Pelaajat';

  @override
  String get circlesEmptySlot => 'Tyhjä Paikka';

  @override
  String get circlesPlayersRange => '1-5 Pelaajaa';

  @override
  String get circlesQuestions => 'Kysymykset';

  @override
  String get circlesQuestionsSubtitle => 'Kysymysten määrä';

  @override
  String get circlesTimePerQuestion => 'Aika per Kysymys';

  @override
  String get circlesSecondsPerQuestion => 'Sek/Kys';

  @override
  String get circlesAdvanced => 'Edistynyt';

  @override
  String get circlesAllowSpectators => 'Salli Katsojat';

  @override
  String get circlesAllowSpectatorsSubtitle => 'Salli muiden katsoa pelaamatta';

  @override
  String get circlesLiveVoiceChat => 'Live Äänichat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Salli ääni-interaktio matsin aikana';

  @override
  String get circlesLiveTextChat => 'Live Tekstichat';

  @override
  String get circlesLiveTextChatSubtitle => 'Salli viestit matsin aikana';

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
  String get circlesCreatedSuccess => 'Piiri luotu';

  @override
  String circlesCreateError(Object error) {
    return 'Piirin luominen epäonnistui: $error';
  }

  @override
  String get circlesHostTip => 'Vinkki: Voit kutsua kavereita luomisen jälkeen';

  @override
  String circlesJoinError(Object error) {
    return 'Piiriin liittyminen epäonnistui: $error';
  }

  @override
  String get circlesLobbyTitle => 'Piirin Aula';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Koodi: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Matsin Asetukset';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Taso $level';
  }

  @override
  String get circlesDifficulty => 'Vaikeusaste';

  @override
  String get circlesPerQuestionShort => 'Per Kysymys';

  @override
  String get circlesInvite => 'Kutsu';

  @override
  String get circlesCopyId => 'Kopioi ID';

  @override
  String get circlesCopiedId => 'ID kopioitu';

  @override
  String get circlesMatchInProgress => 'Matsi käynnissä';

  @override
  String get circlesSpectatorQueuedBody => 'Matsi käynnissä. Liityt katsojana';

  @override
  String get circlesHostStartWhenReady =>
      'Isäntä aloittaa kun kaikki ovat valmiina';

  @override
  String get circlesSpectators => 'Katsojat';

  @override
  String get circlesSpectator => 'Katsoja';

  @override
  String get circlesSpectatorCanWatch => 'Katsojat voivat katsoa livenä';

  @override
  String get circlesJoinRequests => 'Liittymispyynnöt';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Hyväksy katsojat ennen matsin alkua';

  @override
  String get circlesStartGame => 'Aloita Peli';

  @override
  String get circlesWaitingForPlayers => 'Odotetaan pelaajia';

  @override
  String get circlesLeaveCircle => 'Poistu Piiristä';

  @override
  String get circlesRequestSent => 'Pyyntö lähetetty';

  @override
  String get circlesRequestToJoin => 'Pyydä Liittyä';

  @override
  String get circlesWatchLive => 'Katso Livenä';

  @override
  String get circlesPlayerTip =>
      'Napauta \'Valmis\' kun olet valmis. Isäntä aloittaa matsin';

  @override
  String get circlesSpectatorTip =>
      'Olet katsoja. Katso toimintaa livenä kun isäntä aloittaa';

  @override
  String get circlesHostControls => 'Isännän Hallinta';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Isännän siirto epäonnistui: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Piirin lopettaminen epäonnistui: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Käyttäjää @$username ei löytynyt';
  }

  @override
  String get circlesInvalidUser => 'Virheellinen käyttäjä';

  @override
  String get circlesCantInviteSelf => 'Et voi kutsua itseäsi';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username on jo piirissä';
  }

  @override
  String get circlesDefaultHost => 'Isäntä';

  @override
  String get circlesDefaultTitle => 'Piiri';

  @override
  String get circlesInviteByUsername => 'Käyttäjätunnuksella';

  @override
  String circlesInviteSent(Object username) {
    return 'Kutsu lähetetty käyttäjälle @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Kutsun lähetys epäonnistui: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Liittymispyyntö lähetetty';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Pyyntö epäonnistui: $error';
  }

  @override
  String get circlesFull => 'Piiri on täynnä';

  @override
  String get circlesSpectatorAdded => 'Katsoja lisätty';

  @override
  String circlesApproveFailed(Object error) {
    return 'Hyväksyminen epäonnistui: $error';
  }

  @override
  String get circlesRequestDeclined => 'Pyyntö hylätty';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Hylkääminen epäonnistui: $error';
  }

  @override
  String get circlesParticipant => 'Osallistuja';

  @override
  String get circlesLeavePromptTitle => 'Poistu Piiristä?';

  @override
  String get circlesLeavePromptTransfer => 'Siirrä isännyys ennen poistumista';

  @override
  String get circlesLeavePromptEndOnly => 'Lopeta Piiri ja poistu';

  @override
  String get circlesTransferHost => 'Siirrä Isännyys';

  @override
  String get circlesEndCircle => 'Lopeta Piiri';

  @override
  String get circlesTransferHostTitle => 'Siirrä Isännyys';

  @override
  String circlesShareId(Object id) {
    return 'Piirin ID: $id';
  }
}
