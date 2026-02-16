// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

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
  String get profileNoAchievements => 'Încă nu sunt realizări';

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
  String get notificationsTitle => 'Notificări';

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
  String get notificationsEmpty => 'Nu există notificări încă';

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
    return 'Nu s-a putut alătura Cercului: $error';
  }

  @override
  String get notificationsOpening => 'Se deschide';

  @override
  String get notificationsOpened => 'Deschis';

  @override
  String notificationsActionMessage(Object action) {
    return 'Notificare $action';
  }

  @override
  String get settingsTitle => 'Setări';

  @override
  String get settingsSectionAccount => 'Cont';

  @override
  String get settingsEditProfile => 'Editează Profil';

  @override
  String get settingsPrivacy => 'Confidențialitate';

  @override
  String get settingsSecurity => 'Securitate';

  @override
  String get settingsSectionGameplay => 'Joc';

  @override
  String get settingsShowTranslationLine => 'Arată Pasajul Tradus';

  @override
  String get settingsShowReadingLine =>
      'Arată Pasajul de Citire (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Timp per Întrebare';

  @override
  String get settingsMatchDifficulty => 'Dificultate Meci';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptiv';

  @override
  String get settingsSectionSoundFeel => 'Sunet & Simț';

  @override
  String get settingsMusic => 'Muzică';

  @override
  String get settingsSoundEffects => 'Efecte Sonore';

  @override
  String get settingsHaptics => 'Vibrații';

  @override
  String get settingsSectionNotifications => 'Notificări';

  @override
  String get settingsPushNotifications => 'Notificări Push';

  @override
  String get settingsDailyReminder => 'Memento Zilnic';

  @override
  String get settingsSectionAppearance => 'Aspect';

  @override
  String get settingsTheme => 'Temă';

  @override
  String get settingsUiLanguage => 'Limbă interfață';

  @override
  String get settingsSectionAbout => 'Despre';

  @override
  String get settingsVersion => 'Versiune';

  @override
  String get settingsTermsPrivacy => 'Termeni & Confidențialitate';

  @override
  String get settingsSupport => 'Suport';

  @override
  String get settingsLogout => 'Deconectare';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Întunecat';

  @override
  String get themeLight => 'Luminos';

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
  String get editProfileUpdated => 'Profil Actualizat';

  @override
  String get editProfileTitle => 'Editează Profil';

  @override
  String get editProfilePhotoLabel => 'Poză de Profil';

  @override
  String get editProfilePhotoSubtitle =>
      'Selector Avatar Supabase Storage disponibil în curând';

  @override
  String get editProfileChangePhoto => 'Schimbă';

  @override
  String get editProfileAvatarUploadSoon => 'Încărcare Avatar în curând';

  @override
  String get editProfileDisplayNameLabel => 'Nume Afișat';

  @override
  String get editProfileDisplayNameHint => 'Numele tău';

  @override
  String get editProfileDisplayNameRequired => 'Te rog introdu numele tău';

  @override
  String get editProfileDisplayNameTooShort => 'Prea scurt';

  @override
  String get editProfileUsernameLabel => 'Nume Utilizator';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired =>
      'Te rog introdu un nume de utilizator';

  @override
  String get editProfileUsernameTooShort => 'Minim 3 caractere';

  @override
  String get editProfileUsernameInvalid => 'Doar litere, cifre, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'O scurtă descriere despre tine...';

  @override
  String get editProfileBioTooLong => 'Maxim 120 caractere';

  @override
  String get editProfileLocationLabel => 'Locație';

  @override
  String get editProfileLocationHint => 'Oraș / Țară';

  @override
  String get editProfileDailyGoalTitle => 'Obiectiv Zilnic';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Alege câte minute vrei să înveți pe zi';

  @override
  String get securityTitle => 'Securitate';

  @override
  String get securitySectionPassword => 'Parolă';

  @override
  String get securityChangePasswordTitle => 'Schimbă Parola';

  @override
  String get securityChangePasswordSubtitle =>
      'Actualizează-ți parola periodic';

  @override
  String get securitySectionTwoFactor => 'Autentificare în Doi Pași';

  @override
  String get securityEnable2faTitle => 'Activează 2FA';

  @override
  String get securityEnable2faSubtitle =>
      'Securitate suplimentară la autentificare';

  @override
  String get securitySectionAppLock => 'Blocare Aplicație';

  @override
  String get securityBiometricTitle => 'Deblocare Biometrică';

  @override
  String get securityBiometricSubtitle =>
      'Folosește FaceID/TouchID pentru a debloca SOMA';

  @override
  String get securityAppLockTitle => 'Blocare Aplicație';

  @override
  String get securityAppLockSubtitle => 'Blochează SOMA când pleci';

  @override
  String get securitySectionSessions => 'Sesiuni Active';

  @override
  String get securityNoSessions => 'Nu există sesiuni active';

  @override
  String get securityThisDevice => 'Acest Dispozitiv';

  @override
  String get securityDevice => 'Dispozitiv';

  @override
  String get securityActiveLabel => 'Activ';

  @override
  String get securitySignInToEnable2fa => 'Conectează-te pentru a activa 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Activare 2FA eșuată: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Dezactivare 2FA eșuată: $error';
  }

  @override
  String get securitySetup2faTitle => 'Configurare 2FA';

  @override
  String get securitySecretKeyLabel => 'Cheie Secretă';

  @override
  String get securityCodeHint => 'Cod din 6 cifre';

  @override
  String get security2faEnabled => '2FA Activat';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Verificare cod eșuată: $error';
  }

  @override
  String get securityVerifying => 'Se verifică...';

  @override
  String get securityVerify => 'Verifică';

  @override
  String get securityCurrentPasswordHint => 'Parola Curentă';

  @override
  String get securityNewPasswordHint => 'Parola Nouă (min 8 caractere)';

  @override
  String get securityConfirmPasswordHint => 'Confirmă parola nouă';

  @override
  String get securitySignInToChangePassword =>
      'Conectează-te pentru a schimba parola';

  @override
  String get securityEnterCurrentPassword => 'Introdu parola curentă';

  @override
  String get securityPasswordMinLength =>
      'Parola nouă trebuie să aibă minim 8 caractere';

  @override
  String get securityPasswordsDoNotMatch => 'Parolele nu se potrivesc';

  @override
  String get securityPasswordUpdated => 'Parolă actualizată';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Actualizare parolă eșuată: $error';
  }

  @override
  String get securityAutoLockAfter => 'Blocare Automată După';

  @override
  String get privacyTitle => 'Confidențialitate';

  @override
  String get privacySectionVisibility => 'Vizibilitate';

  @override
  String get privacyProfileVisibilityTitle => 'Vizibilitate Profil';

  @override
  String get privacyVisibilityPublic => 'Public';

  @override
  String get privacyVisibilityFriends => 'Prieteni';

  @override
  String get privacyVisibilityPrivate => 'Privat';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Oricine îți poate vedea profilul';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Doar prietenii îți pot vedea profilul';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Doar tu îți poți vedea profilul';

  @override
  String get privacySectionActivity => 'Activitate';

  @override
  String get privacyShowOnlineTitle => 'Arată Statut Online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Permite jucătorilor să vadă când ești online';

  @override
  String get privacyShowActivityTitle => 'Arată Activitate Învățare';

  @override
  String get privacyShowActivitySubtitle =>
      'Arată seria, XP și progresul recent';

  @override
  String get privacySectionSocial => 'Social';

  @override
  String get privacyAllowRequestsTitle => 'Permite Cereri de Prietenie';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Permite oamenilor să trimită cereri de prietenie';

  @override
  String get privacyWhoCanDmTitle => 'Cine poate trimite Mesaje';

  @override
  String get privacyDmEveryone => 'Oricine';

  @override
  String get privacyDmFriends => 'Prieteni';

  @override
  String get privacyDmNoOne => 'Nimeni';

  @override
  String get privacyDmEveryoneSubtitle => 'Oricine îți poate trimite mesaje';

  @override
  String get privacyDmFriendsSubtitle =>
      'Doar prietenii îți pot trimite mesaje';

  @override
  String get privacyDmNoOneSubtitle => 'Nimeni nu îți poate trimite mesaje';

  @override
  String get privacySectionBlockedUsers => 'Utilizatori Blocați';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Gestionarea utilizatorilor blocați în curând';

  @override
  String get privacySectionDataControls => 'Control Date';

  @override
  String get privacyExportDataTitle => 'Exportă Datele Mele';

  @override
  String get privacyExportDataSubtitle =>
      'Descarcă activitatea și cursurile tale';

  @override
  String get privacyExportInfoTitle => 'Export Date';

  @override
  String get privacyExportInfoBody =>
      'Altele: Generează un export JSON/CSV și trimite pe email sau descarcă direct';

  @override
  String get privacyDeleteAccountTitle => 'Șterge Cont';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Aceasta va șterge permanent contul și datele tale';

  @override
  String get privacyDeleteConfirmTitle => 'Ștergi Contul?';

  @override
  String get privacyDeleteConfirmBody =>
      'Aceasta nu poate fi anulată. Profilul, cursurile, prietenii și mesajele vor fi șterse';

  @override
  String get privacyDeleteComingSoon =>
      'Ștergerea va fi integrată cu Supabase mai târziu';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sesiune Solo Completă';

  @override
  String get soloResultsFeedbackElite =>
      'Performanță de elită - menține seria vie';

  @override
  String get soloResultsFeedbackStrong => 'Treabă bună - îmbunătățire rapidă';

  @override
  String get soloResultsFeedbackProgress =>
      'Progres bun - revizuiește greșelile și încearcă din nou';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Fără presiune - încearcă din nou cu mai puține întrebări și concentrează-te';

  @override
  String get soloResultsPerfectScore =>
      'Scor perfect! Fără greșeli de revizuit';

  @override
  String get soloResultsReviewPrompt =>
      'Revizuiește greșelile pentru a învăța mai repede. Răspunsurile tale sunt mai jos';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Revizuiește Greșeli ($count)';
  }

  @override
  String get authNotSignedIn => 'Neautentificat';

  @override
  String get genericUser => 'Utilizator';

  @override
  String get loading => 'Se încarcă...';

  @override
  String get edit => 'Editează';

  @override
  String get send => 'Trimite';

  @override
  String get join => 'Alătură-te';

  @override
  String get leave => 'Părăsește';

  @override
  String get ready => 'Gata';

  @override
  String get levelBeginner => 'Începător';

  @override
  String get levelIntermediate => 'Intermediar';

  @override
  String get levelAdvanced => 'Avansat';

  @override
  String questionsShort(Object count) {
    return '$count Întrebări';
  }

  @override
  String secondsShort(Object count) {
    return '$count Secunde';
  }

  @override
  String get circlesAllCourses => 'Toate Cursurile';

  @override
  String get circlesAllModes => 'Toate Modurile';

  @override
  String get circlesAllLevels => 'Toate Nivelurile';

  @override
  String get circlesAddNewCourse => 'Adaugă Curs Nou';

  @override
  String get circlesCoursesTitle => 'Cursuri';

  @override
  String get circlesModeTitle => 'Mod';

  @override
  String get circlesLevelTitle => 'Nivel';

  @override
  String get circlesNoActiveForFilters => 'Niciun Cerc activ cu aceste filtre';

  @override
  String get circlesUnknownRoom => 'Cameră Necunoscută';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Creează Cerc';

  @override
  String get circlesCircleName => 'Nume Cerc';

  @override
  String get circlesEnterName => 'Introdu nume';

  @override
  String get circlesLanguages => 'Limbi';

  @override
  String get circlesRoomSetup => 'Configurare Cameră';

  @override
  String get circlesPlayers => 'Jucători';

  @override
  String get circlesEmptySlot => 'Loc Gol';

  @override
  String get circlesPlayersRange => '1-5 Jucători';

  @override
  String get circlesQuestions => 'Întrebări';

  @override
  String get circlesQuestionsSubtitle => 'Cantitate întrebări';

  @override
  String get circlesTimePerQuestion => 'Timp per Întrebare';

  @override
  String get circlesSecondsPerQuestion => 'Sec/Întrebare';

  @override
  String get circlesAdvanced => 'Avansat';

  @override
  String get circlesAllowSpectators => 'Permite Spectatori';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Permite altora să privească fără să joace';

  @override
  String get circlesLiveVoiceChat => 'Chat Vocal Live';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Activează interacțiunea vocală în timpul meciului';

  @override
  String get circlesLiveTextChat => 'Chat Text Live';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Activează mesageria în timpul meciului';

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
  String get circlesCreatedSuccess => 'Cerc creat';

  @override
  String circlesCreateError(Object error) {
    return 'Creare Cerc eșuată: $error';
  }

  @override
  String get circlesHostTip => 'Sfat: Poți invita prieteni după creare';

  @override
  String circlesJoinError(Object error) {
    return 'Nu s-a putut intra în Cerc: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby Cerc';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Cod: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Setări Meci';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Nivel $level';
  }

  @override
  String get circlesDifficulty => 'Dificultate';

  @override
  String get circlesPerQuestionShort => 'Per întrebare';

  @override
  String get circlesInvite => 'Invită';

  @override
  String get circlesCopyId => 'Copiază ID';

  @override
  String get circlesCopiedId => 'ID copiat';

  @override
  String get circlesMatchInProgress => 'Meci în desfășurare';

  @override
  String get circlesSpectatorQueuedBody =>
      'Meci în desfășurare. Vei intra ca spectator';

  @override
  String get circlesHostStartWhenReady =>
      'Gazda va începe când toată lumea e gata';

  @override
  String get circlesSpectators => 'Spectatori';

  @override
  String get circlesSpectator => 'Spectator';

  @override
  String get circlesSpectatorCanWatch => 'Spectatorii pot privi live';

  @override
  String get circlesJoinRequests => 'Cereri de Alăturare';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Acceptă spectatori înainte de a începe meciul';

  @override
  String get circlesStartGame => 'Începe Joc';

  @override
  String get circlesWaitingForPlayers => 'Se așteaptă jucători';

  @override
  String get circlesLeaveCircle => 'Părăsește Cerc';

  @override
  String get circlesRequestSent => 'Cerere trimisă';

  @override
  String get circlesRequestToJoin => 'Cere să te alături';

  @override
  String get circlesWatchLive => 'Privește Live';

  @override
  String get circlesPlayerTip =>
      'Apasă \'Gata\' când ești pregătit. Gazda va începe meciul';

  @override
  String get circlesSpectatorTip =>
      'Ești spectator. Vezi acțiunea în timp real când gazda începe';

  @override
  String get circlesHostControls => 'Control Gazdă';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Transfer gazdă eșuat: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Închidere Cerc eșuată: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Utilizatorul @$username nu a fost găsit';
  }

  @override
  String get circlesInvalidUser => 'Utilizator invalid';

  @override
  String get circlesCantInviteSelf => 'Nu te poți invita singur';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username este deja în Cerc';
  }

  @override
  String get circlesDefaultHost => 'Gazdă';

  @override
  String get circlesDefaultTitle => 'Cerc';

  @override
  String get circlesInviteByUsername => 'După Nume Utilizator';

  @override
  String circlesInviteSent(Object username) {
    return 'Invitație trimisă către @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Trimitere invitație eșuată: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Cerere de alăturare trimisă';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Cerere eșuată: $error';
  }

  @override
  String get circlesFull => 'Cerc plin';

  @override
  String get circlesSpectatorAdded => 'Spectator adăugat';

  @override
  String circlesApproveFailed(Object error) {
    return 'Aprobare eșuată: $error';
  }

  @override
  String get circlesRequestDeclined => 'Cerere refuzată';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Refuz eșuat: $error';
  }

  @override
  String get circlesParticipant => 'Participant';

  @override
  String get circlesLeavePromptTitle => 'Părăsești Cercul?';

  @override
  String get circlesLeavePromptTransfer => 'Transferă gazda înainte de a pleca';

  @override
  String get circlesLeavePromptEndOnly => 'Închide Cercul și pleacă';

  @override
  String get circlesTransferHost => 'Transferă Gazdă';

  @override
  String get circlesEndCircle => 'Închide Cerc';

  @override
  String get circlesTransferHostTitle => 'Transfer Gazdă';

  @override
  String circlesShareId(Object id) {
    return 'ID Cerc: $id';
  }
}
