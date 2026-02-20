// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

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
  String get myCourses => 'My Courses';

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
  String get soloReverse => 'Reverse mode';

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
  String get profileNoAchievements => 'Inga prestationer än';

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
  String get notificationsTitle => 'Aviseringar';

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
  String get notificationsEmpty => 'Inga aviseringar än';

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
    return 'Kunde inte gå med i Cirkel: $error';
  }

  @override
  String get notificationsOpening => 'Öppnar';

  @override
  String get notificationsOpened => 'Öppnad';

  @override
  String notificationsActionMessage(Object action) {
    return '$action avisering';
  }

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsEditProfile => 'Redigera Profil';

  @override
  String get settingsPrivacy => 'Sekretess';

  @override
  String get settingsSecurity => 'Säkerhet';

  @override
  String get settingsSectionGameplay => 'Spelupplevelse';

  @override
  String get settingsShowTranslationLine => 'Visa Översättningsrad';

  @override
  String get settingsShowReadingLine => 'Visa Läsrad (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Tid per Fråga';

  @override
  String get settingsMatchDifficulty => 'Matchsvårighet';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptiv';

  @override
  String get settingsSectionSoundFeel => 'Ljud & Känsla';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSoundEffects => 'Ljudeffekter';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsSectionNotifications => 'Aviseringar';

  @override
  String get settingsPushNotifications => 'Push-aviseringar';

  @override
  String get settingsDailyReminder => 'Daglig Påminnelse';

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Gränssnittsspråk';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsTermsPrivacy => 'Villkor & Sekretess';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLogout => 'Logga ut';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Mörkt';

  @override
  String get themeLight => 'Ljust';

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
  String get editProfileUpdated => 'Profil Uppdaterad';

  @override
  String get editProfileTitle => 'Redigera Profil';

  @override
  String get editProfilePhotoLabel => 'Profilbild';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage Avatarväljare kommer snart';

  @override
  String get editProfileChangePhoto => 'Ändra';

  @override
  String get editProfileAvatarUploadSoon => 'Avataruppladdning kommer snart';

  @override
  String get editProfileDisplayNameLabel => 'Visningsnamn';

  @override
  String get editProfileDisplayNameHint => 'Ditt namn';

  @override
  String get editProfileDisplayNameRequired => 'Vänligen ange ditt namn';

  @override
  String get editProfileDisplayNameTooShort => 'För kort';

  @override
  String get editProfileUsernameLabel => 'Användarnamn';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Vänligen ange ett användarnamn';

  @override
  String get editProfileUsernameTooShort => 'Minst 3 tecken';

  @override
  String get editProfileUsernameInvalid => 'Endast bokstäver, siffror, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'En kort beskrivning om dig...';

  @override
  String get editProfileBioTooLong => 'Max 120 tecken';

  @override
  String get editProfileLocationLabel => 'Plats';

  @override
  String get editProfileLocationHint => 'Stad / Land';

  @override
  String get editProfileDailyGoalTitle => 'Dagligt Mål';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Välj hur många minuter du vill lära dig per dag';

  @override
  String get securityTitle => 'Säkerhet';

  @override
  String get securitySectionPassword => 'Lösenord';

  @override
  String get securityChangePasswordTitle => 'Byt Lösenord';

  @override
  String get securityChangePasswordSubtitle =>
      'Uppdatera ditt lösenord regelbundet';

  @override
  String get securitySectionTwoFactor => 'Tvåfaktorsautentisering';

  @override
  String get securityEnable2faTitle => 'Aktivera 2FA';

  @override
  String get securityEnable2faSubtitle => 'Extra säkerhet vid inloggning';

  @override
  String get securitySectionAppLock => 'Applås';

  @override
  String get securityBiometricTitle => 'Biometrisk Upplåsning';

  @override
  String get securityBiometricSubtitle =>
      'Använd FaceID/TouchID för att låsa upp SOMA';

  @override
  String get securityAppLockTitle => 'Applås';

  @override
  String get securityAppLockSubtitle => 'Lås SOMA när du lämnar';

  @override
  String get securitySectionSessions => 'Aktiva Sessioner';

  @override
  String get securityNoSessions => 'Inga aktiva sessioner';

  @override
  String get securityThisDevice => 'Denna Enhet';

  @override
  String get securityDevice => 'Enhet';

  @override
  String get securityActiveLabel => 'Aktiv';

  @override
  String get securitySignInToEnable2fa => 'Logga in för att aktivera 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Kunde inte aktivera 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Kunde inte inaktivera 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Inställning av 2FA';

  @override
  String get securitySecretKeyLabel => 'Hemlig Nyckel';

  @override
  String get securityCodeHint => '6-siffrig kod';

  @override
  String get security2faEnabled => '2FA Aktiverat';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Kunde inte verifiera kod: $error';
  }

  @override
  String get securityVerifying => 'Verifierar...';

  @override
  String get securityVerify => 'Verifiera';

  @override
  String get securityCurrentPasswordHint => 'Nuvarande Lösenord';

  @override
  String get securityNewPasswordHint => 'Nytt Lösenord (min 8 tecken)';

  @override
  String get securityConfirmPasswordHint => 'Bekräfta nytt lösenord';

  @override
  String get securitySignInToChangePassword => 'Logga in för att byta lösenord';

  @override
  String get securityEnterCurrentPassword => 'Ange ditt nuvarande lösenord';

  @override
  String get securityPasswordMinLength =>
      'Nytt lösenord måste vara minst 8 tecken';

  @override
  String get securityPasswordsDoNotMatch => 'Lösenorden matchar inte';

  @override
  String get securityPasswordUpdated => 'Lösenord uppdaterat';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Kunde inte uppdatera lösenord: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatisk Låsning Efter';

  @override
  String get privacyTitle => 'Sekretess';

  @override
  String get privacySectionVisibility => 'Synlighet';

  @override
  String get privacyProfileVisibilityTitle => 'Profilsynlighet';

  @override
  String get privacyVisibilityPublic => 'Offentlig';

  @override
  String get privacyVisibilityFriends => 'Vänner';

  @override
  String get privacyVisibilityPrivate => 'Privat';

  @override
  String get privacyVisibilityPublicSubtitle => 'Alla kan se din profil';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Endast vänner kan se din profil';

  @override
  String get privacyVisibilityPrivateSubtitle => 'Endast du kan se din profil';

  @override
  String get privacySectionActivity => 'Aktivitet';

  @override
  String get privacyShowOnlineTitle => 'Visa Onlinestatus';

  @override
  String get privacyShowOnlineSubtitle =>
      'Tillåt spelare att se när du är online';

  @override
  String get privacyShowActivityTitle => 'Visa Inlärningsaktivitet';

  @override
  String get privacyShowActivitySubtitle =>
      'Visa svit, XP och senaste framsteg';

  @override
  String get privacySectionSocial => 'Socialt';

  @override
  String get privacyAllowRequestsTitle => 'Tillåt Vänförfrågningar';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Tillåt personer att skicka vänförfrågningar';

  @override
  String get privacyWhoCanDmTitle => 'Vem Kan Skicka DM';

  @override
  String get privacyDmEveryone => 'Alla';

  @override
  String get privacyDmFriends => 'Vänner';

  @override
  String get privacyDmNoOne => 'Ingen';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Alla kan skicka meddelanden till dig';

  @override
  String get privacyDmFriendsSubtitle =>
      'Endast vänner kan skicka meddelanden till dig';

  @override
  String get privacyDmNoOneSubtitle => 'Ingen kan skicka meddelanden till dig';

  @override
  String get privacySectionBlockedUsers => 'Blockerade Användare';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Hantering av blockerade användare kommer snart';

  @override
  String get privacySectionDataControls => 'Datakontroller';

  @override
  String get privacyExportDataTitle => 'Exportera Min Data';

  @override
  String get privacyExportDataSubtitle => 'Ladda ner din aktivitet och kurser';

  @override
  String get privacyExportInfoTitle => 'Dataexport';

  @override
  String get privacyExportInfoBody =>
      'Annat: Generera JSON/CSV export och skicka via e-post eller ladda ner direkt';

  @override
  String get privacyDeleteAccountTitle => 'Ta Bort Konto';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Detta tar permanent bort ditt konto och dina data';

  @override
  String get privacyDeleteConfirmTitle => 'Ta Bort Konto?';

  @override
  String get privacyDeleteConfirmBody =>
      'Detta kan inte ångras. Din profil, kurser, vänner och meddelanden kommer att tas bort';

  @override
  String get privacyDeleteComingSoon =>
      'Borttagning kommer att integreras med Supabase senare';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo-session Klar';

  @override
  String get soloResultsFeedbackElite => 'Elitprestation - håll sviten vid liv';

  @override
  String get soloResultsFeedbackStrong => 'Bra jobbat - du blir snabbt bättre';

  @override
  String get soloResultsFeedbackProgress =>
      'Bra framsteg - granska fel och försök igen';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Ingen stress - försök igen med färre frågor och fokusera';

  @override
  String get soloResultsPerfectScore => 'Perfekt poäng! Inget att granska';

  @override
  String get soloResultsReviewPrompt =>
      'Granska dina misstag för snabbare inlärning. Dina felaktiga svar finns nedan';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Granska Misstag ($count)';
  }

  @override
  String get authNotSignedIn => 'Ej inloggad';

  @override
  String get genericUser => 'Användare';

  @override
  String get loading => 'Laddar...';

  @override
  String get edit => 'Redigera';

  @override
  String get send => 'Skicka';

  @override
  String get join => 'Gå med';

  @override
  String get leave => 'Lämna';

  @override
  String get ready => 'Klar';

  @override
  String get levelBeginner => 'Nybörjare';

  @override
  String get levelIntermediate => 'Medel';

  @override
  String get levelAdvanced => 'Expert';

  @override
  String questionsShort(Object count) {
    return '$count Frågor';
  }

  @override
  String secondsShort(Object count) {
    return '$count Sekunder';
  }

  @override
  String get circlesAllCourses => 'Alla Kurser';

  @override
  String get circlesAllModes => 'Alla Lägen';

  @override
  String get circlesAllLevels => 'Alla Nivåer';

  @override
  String get circlesAddNewCourse => 'Lägg till Ny Kurs';

  @override
  String get circlesCoursesTitle => 'Kurser';

  @override
  String get circlesModeTitle => 'Läge';

  @override
  String get circlesLevelTitle => 'Nivå';

  @override
  String get circlesNoActiveForFilters => 'Ingen aktiv Cirkel för dessa filter';

  @override
  String get circlesUnknownRoom => 'Okänt Rum';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Skapa Cirkel';

  @override
  String get circlesCircleName => 'Cirkelnamn';

  @override
  String get circlesEnterName => 'Ange ett namn';

  @override
  String get circlesLanguages => 'Språk';

  @override
  String get circlesRoomSetup => 'Rumsinställningar';

  @override
  String get circlesPlayers => 'Spelare';

  @override
  String get circlesEmptySlot => 'Tom Plats';

  @override
  String get circlesPlayersRange => '1-5 Spelare';

  @override
  String get circlesQuestions => 'Frågor';

  @override
  String get circlesQuestionsSubtitle => 'Antal frågor';

  @override
  String get circlesTimePerQuestion => 'Tid per Fråga';

  @override
  String get circlesSecondsPerQuestion => 'Sek/Fråga';

  @override
  String get circlesAdvanced => 'Expert';

  @override
  String get circlesAllowSpectators => 'Tillåt Åskådare';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Tillåt andra att titta utan att spela';

  @override
  String get circlesLiveVoiceChat => 'Live Röstchatt';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Tillåt röstinteraktion under match';

  @override
  String get circlesLiveTextChat => 'Live Textchatt';

  @override
  String get circlesLiveTextChatSubtitle => 'Tillåt meddelanden under match';

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
  String get circlesCreatedSuccess => 'Cirkel skapad';

  @override
  String circlesCreateError(Object error) {
    return 'Kunde inte skapa Cirkel: $error';
  }

  @override
  String get circlesHostTip => 'Tips: Du kan bjuda in vänner efter skapandet';

  @override
  String circlesJoinError(Object error) {
    return 'Kunde inte gå med i Cirkel: $error';
  }

  @override
  String get circlesLobbyTitle => 'Cirkel Lobby';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kod: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Matchinställningar';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Nivå $level';
  }

  @override
  String get circlesDifficulty => 'Svårighetsgrad';

  @override
  String get circlesPerQuestionShort => 'Per Fråga';

  @override
  String get circlesInvite => 'Bjud in';

  @override
  String get circlesCopyId => 'Kopiera ID';

  @override
  String get circlesCopiedId => 'ID kopierat';

  @override
  String get circlesMatchInProgress => 'Match pågår';

  @override
  String get circlesSpectatorQueuedBody =>
      'Match pågår. Du kommer att gå med som åskådare';

  @override
  String get circlesHostStartWhenReady => 'Värden startar när alla är redo';

  @override
  String get circlesSpectators => 'Åskådare';

  @override
  String get circlesSpectator => 'Åskådare';

  @override
  String get circlesSpectatorCanWatch => 'Åskådare kan titta live';

  @override
  String get circlesJoinRequests => 'Förfrågningar att gå med';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Acceptera åskådare innan matchen startar';

  @override
  String get circlesStartGame => 'Starta Spel';

  @override
  String get circlesWaitingForPlayers => 'Väntar på spelare';

  @override
  String get circlesLeaveCircle => 'Lämna Cirkel';

  @override
  String get circlesRequestSent => 'Förfrågan skickad';

  @override
  String get circlesRequestToJoin => 'Begär att få gå med';

  @override
  String get circlesWatchLive => 'Titta Live';

  @override
  String get circlesPlayerTip =>
      'Tryck \'Klar\' när du är redo. Värden startar matchen';

  @override
  String get circlesSpectatorTip =>
      'Du tittar på. Se handlingen live när värden startar';

  @override
  String get circlesHostControls => 'Värdkontroller';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Kunde inte överföra värdskap: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Kunde inte avsluta Cirkel: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Användare @$username hittades inte';
  }

  @override
  String get circlesInvalidUser => 'Ogiltig användare';

  @override
  String get circlesCantInviteSelf => 'Du kan inte bjuda in dig själv';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username är redan i Cirkeln';
  }

  @override
  String get circlesDefaultHost => 'Värd';

  @override
  String get circlesDefaultTitle => 'Cirkel';

  @override
  String get circlesInviteByUsername => 'Genom Användarnamn';

  @override
  String circlesInviteSent(Object username) {
    return 'Inbjudan skickad till @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Kunde inte skicka inbjudan: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Förfrågan om att gå med skickad';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Förfrågan misslyckades: $error';
  }

  @override
  String get circlesFull => 'Cirkeln är full';

  @override
  String get circlesSpectatorAdded => 'Åskådare tillagd';

  @override
  String circlesApproveFailed(Object error) {
    return 'Kunde inte godkänna: $error';
  }

  @override
  String get circlesRequestDeclined => 'Förfrågan avböjd';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Kunde inte avböja: $error';
  }

  @override
  String get circlesParticipant => 'Deltagare';

  @override
  String get circlesLeavePromptTitle => 'Lämna Cirkel?';

  @override
  String get circlesLeavePromptTransfer => 'Överför värdskap innan du lämnar';

  @override
  String get circlesLeavePromptEndOnly => 'Avsluta Cirkel och lämna';

  @override
  String get circlesTransferHost => 'Överför Värdskap';

  @override
  String get circlesEndCircle => 'Avsluta Cirkel';

  @override
  String get circlesTransferHostTitle => 'Överför Värdskap';

  @override
  String circlesShareId(Object id) {
    return 'Cirkel ID: $id';
  }
}
