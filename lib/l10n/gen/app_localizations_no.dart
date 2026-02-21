// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Learn. Compete. Master.';

  @override
  String welcome(Object name) {
    return 'Velkommen, $name!';
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
  String get authForgotPassword => 'Glemt passord?';

  @override
  String get authForgotPasswordTitle => 'Tilbakestill passord';

  @override
  String get authForgotPasswordBody =>
      'Skriv inn e-posten knyttet til kontoen din. Vi sender deg en sikker lenke.';

  @override
  String get authSendResetLink => 'Send tilbakestillingslenke';

  @override
  String get authResetSentTitle => 'Sjekk e-posten din';

  @override
  String get authResetSentBody =>
      'Vi har sendt en lenke for å tilbakestille passordet. Følg instruksjonene for å velge et nytt passord.';

  @override
  String get authResetFailedTitle => 'Tilbakestilling mislyktes';

  @override
  String get authSignUpConfirmTitle => 'Bekreft e-posten din';

  @override
  String authSignUpConfirmBody(Object email) {
    return 'Vi har sendt en bekreftelses-e-post til $email. Vennligst bekreft e-posten før du fortsetter.';
  }

  @override
  String get authEmailResent => 'Bekreftelses-e-post sendt på nytt.';

  @override
  String authEmailResendFailed(Object error) {
    return 'Kunne ikke sende bekreftelses-e-post på nytt: $error';
  }

  @override
  String get resend => 'Send på nytt';

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
  String get profileNoAchievements => 'Ingen prestasjoner ennå';

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
  String get notificationsTitle => 'Varsler';

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
  String get notificationsEmpty => 'Ingen varsler ennå';

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
    return 'Kunne ikke bli med i Sirkel: $error';
  }

  @override
  String get notificationsOpening => 'Åpner';

  @override
  String get notificationsOpened => 'Åpnet';

  @override
  String notificationsActionMessage(Object action) {
    return '$action varsel';
  }

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsEditProfile => 'Rediger Profil';

  @override
  String get settingsPrivacy => 'Personvern';

  @override
  String get settingsSecurity => 'Sikkerhet';

  @override
  String get settingsSectionGameplay => 'Spillopplevelse';

  @override
  String get settingsShowTranslationLine => 'Vis Oversettelseslinje';

  @override
  String get settingsShowReadingLine => 'Vis Leselinje (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Tid per Spørsmål';

  @override
  String get settingsMatchDifficulty => 'Kampvanskelighet';

  @override
  String get settingsMatchDifficultyAdaptive => 'Tilpasset';

  @override
  String get settingsSectionSoundFeel => 'Lyd og Følelse';

  @override
  String get settingsMusic => 'Musikk';

  @override
  String get settingsSoundEffects => 'Lydeffekter';

  @override
  String get settingsHaptics => 'Haptikk';

  @override
  String get settingsSectionNotifications => 'Varsler';

  @override
  String get settingsPushNotifications => 'Push-varsler';

  @override
  String get settingsDailyReminder => 'Daglig Påminnelse';

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Grensesnittspråk';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsVersion => 'Versjon';

  @override
  String get settingsTermsPrivacy => 'Vilkår og Personvern';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLogout => 'Logg ut';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Mørk';

  @override
  String get themeLight => 'Lys';

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
  String get editProfileUpdated => 'Profil Oppdatert';

  @override
  String get editProfileTitle => 'Rediger Profil';

  @override
  String get editProfilePhotoLabel => 'Profilbilde';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage Avatarvelger kommer snart';

  @override
  String get editProfileChangePhoto => 'Endre';

  @override
  String get editProfileAvatarUploadSoon => 'Avataropplasting kommer snart';

  @override
  String get editProfileDisplayNameLabel => 'Visningsnavn';

  @override
  String get editProfileDisplayNameHint => 'Ditt navn';

  @override
  String get editProfileDisplayNameRequired =>
      'Vennligst skriv inn navnet ditt';

  @override
  String get editProfileDisplayNameTooShort => 'For kort';

  @override
  String get editProfileUsernameLabel => 'Brukernavn';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Vennligst skriv inn et brukernavn';

  @override
  String get editProfileUsernameTooShort => 'Minst 3 tegn';

  @override
  String get editProfileUsernameInvalid => 'Kun bokstaver, tall, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'En kort beskrivelse om deg...';

  @override
  String get editProfileBioTooLong => 'Maks 120 tegn';

  @override
  String get editProfileLocationLabel => 'Sted';

  @override
  String get editProfileLocationHint => 'By / Land';

  @override
  String get editProfileDailyGoalTitle => 'Daglig Mål';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Velg hvor mange minutter du vil lære hver dag';

  @override
  String get securityTitle => 'Sikkerhet';

  @override
  String get securitySectionPassword => 'Passord';

  @override
  String get securityChangePasswordTitle => 'Endre Passord';

  @override
  String get securityChangePasswordSubtitle =>
      'Oppdater passordet ditt regelmessig';

  @override
  String get securitySectionTwoFactor => 'To-faktor Autentisering';

  @override
  String get securityEnable2faTitle => 'Aktiver 2FA';

  @override
  String get securityEnable2faSubtitle => 'Ekstra sikkerhet ved innlogging';

  @override
  String get securitySectionAppLock => 'Applås';

  @override
  String get securityBiometricTitle => 'Biometrisk Opplåsing';

  @override
  String get securityBiometricSubtitle =>
      'Bruk FaceID/TouchID for å låse opp SOMA';

  @override
  String get securityAppLockTitle => 'Applås';

  @override
  String get securityAppLockSubtitle => 'Lås SOMA når du forlater';

  @override
  String get securitySectionSessions => 'Aktive Økter';

  @override
  String get securityNoSessions => 'Ingen aktive økter';

  @override
  String get securityThisDevice => 'Denne Enheten';

  @override
  String get securityDevice => 'Enhet';

  @override
  String get securityActiveLabel => 'Aktiv';

  @override
  String get securitySignInToEnable2fa => 'Logg inn for å aktivere 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Kunne ikke aktivere 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Kunne ikke deaktivere 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Oppsett av 2FA';

  @override
  String get securitySecretKeyLabel => 'Hemmelig Nøkkel';

  @override
  String get securityCodeHint => '6-sifret kode';

  @override
  String get security2faEnabled => '2FA Aktivert';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Kodeverifisering mislyktes: $error';
  }

  @override
  String get securityVerifying => 'Verifiserer...';

  @override
  String get securityVerify => 'Verifiser';

  @override
  String get securityCurrentPasswordHint => 'Nåværende Passord';

  @override
  String get securityNewPasswordHint => 'Nytt Passord (min 8 tegn)';

  @override
  String get securityConfirmPasswordHint => 'Bekreft nytt passord';

  @override
  String get securitySignInToChangePassword => 'Logg inn for å endre passord';

  @override
  String get securityEnterCurrentPassword => 'Skriv inn ditt nåværende passord';

  @override
  String get securityPasswordMinLength => 'Nytt passord må være minst 8 tegn';

  @override
  String get securityPasswordsDoNotMatch => 'Passordene samsvarer ikke';

  @override
  String get securityPasswordUpdated => 'Passord oppdatert';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Kunne ikke oppdatere passord: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatisk Lås Etter';

  @override
  String get privacyTitle => 'Personvern';

  @override
  String get privacySectionVisibility => 'Synlighet';

  @override
  String get privacyProfileVisibilityTitle => 'Profilsynlighet';

  @override
  String get privacyVisibilityPublic => 'Helt Offentlig';

  @override
  String get privacyVisibilityFriends => 'Venner';

  @override
  String get privacyVisibilityPrivate => 'Privat';

  @override
  String get privacyVisibilityPublicSubtitle => 'Alle kan se profilen din';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Kun venner kan se profilen din';

  @override
  String get privacyVisibilityPrivateSubtitle => 'Kun du kan se profilen din';

  @override
  String get privacySectionActivity => 'Aktivitet';

  @override
  String get privacyShowOnlineTitle => 'Vis Online Status';

  @override
  String get privacyShowOnlineSubtitle => 'La spillere se når du er online';

  @override
  String get privacyShowActivityTitle => 'Vis Læringsaktivitet';

  @override
  String get privacyShowActivitySubtitle => 'Vis serie, XP og nylig fremgang';

  @override
  String get privacySectionSocial => 'Sosialt';

  @override
  String get privacyAllowRequestsTitle => 'Tillat Venneforespørsler';

  @override
  String get privacyAllowRequestsSubtitle =>
      'La folk sende deg venneforespørsler';

  @override
  String get privacyWhoCanDmTitle => 'Hvem Kan Sende DM';

  @override
  String get privacyDmEveryone => 'Alle';

  @override
  String get privacyDmFriends => 'Venner';

  @override
  String get privacyDmNoOne => 'Ingen';

  @override
  String get privacyDmEveryoneSubtitle => 'Alle kan sende deg meldinger';

  @override
  String get privacyDmFriendsSubtitle => 'Kun venner kan sende deg meldinger';

  @override
  String get privacyDmNoOneSubtitle => 'Ingen kan sende deg meldinger';

  @override
  String get privacySectionBlockedUsers => 'Blokkerte Brukere';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Håndtering av blokkerte brukere kommer snart';

  @override
  String get privacySectionDataControls => 'Datakontroll';

  @override
  String get privacyExportDataTitle => 'Eksporter Mine Data';

  @override
  String get privacyExportDataSubtitle => 'Last ned din aktivitet og kurs';

  @override
  String get privacyExportInfoTitle => 'Dataeksport';

  @override
  String get privacyExportInfoBody =>
      'Annet: Generer JSON/CSV eksport og send på e-post eller last ned direkte';

  @override
  String get privacyDeleteAccountTitle => 'Slett Konto';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Dette sletter kontoen og dataene dine permanent';

  @override
  String get privacyDeleteConfirmTitle => 'Slett Konto?';

  @override
  String get privacyDeleteConfirmBody =>
      'Dette kan ikke angres. Din profil, kurs, venner og meldinger vil bli slettet';

  @override
  String get privacyDeleteComingSoon =>
      'Sletting vil bli integrert med Supabase senere';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo Økt Fullført';

  @override
  String get soloResultsFeedbackElite => 'Eliteprestasjon - hold serien i gang';

  @override
  String get soloResultsFeedbackStrong => 'Bra jobbet - du forbedrer deg raskt';

  @override
  String get soloResultsFeedbackProgress =>
      'God fremgang - gå gjennom feil og prøv igjen';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Ikke noe stress - prøv igjen med færre spørsmål og fokuser';

  @override
  String get soloResultsPerfectScore => 'Perfekt score! Ingenting å gjennomgå';

  @override
  String get soloResultsReviewPrompt =>
      'Gjennomgå feilene dine for raskere læring. Dine feil svar er nedenfor';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Gjennomgå Feil ($count)';
  }

  @override
  String get authNotSignedIn => 'Ikke logget inn';

  @override
  String get genericUser => 'Bruker';

  @override
  String get loading => 'Laster...';

  @override
  String get edit => 'Rediger';

  @override
  String get send => 'Send';

  @override
  String get join => 'Bli med';

  @override
  String get leave => 'Forlat';

  @override
  String get ready => 'Klar';

  @override
  String get levelBeginner => 'Nybegynner';

  @override
  String get levelIntermediate => 'Viderekommen';

  @override
  String get levelAdvanced => 'Ekspert';

  @override
  String questionsShort(Object count) {
    return '$count Spørsmål';
  }

  @override
  String secondsShort(Object count) {
    return '$count Sekunder';
  }

  @override
  String get circlesAllCourses => 'Alle Kurs';

  @override
  String get circlesAllModes => 'Alle Moduser';

  @override
  String get circlesAllLevels => 'Alle Nivåer';

  @override
  String get circlesAddNewCourse => 'Legg til Nytt Kurs';

  @override
  String get circlesCoursesTitle => 'Kurs';

  @override
  String get circlesModeTitle => 'Modus';

  @override
  String get circlesLevelTitle => 'Nivå';

  @override
  String get circlesNoActiveForFilters =>
      'Ingen aktiv Sirkel for disse filtrene';

  @override
  String get circlesUnknownRoom => 'Ukjent Rom';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Opprett Sirkel';

  @override
  String get circlesCircleName => 'Sirkelnavn';

  @override
  String get circlesEnterName => 'Skriv inn et navn';

  @override
  String get circlesLanguages => 'Språk';

  @override
  String get circlesRoomSetup => 'romoppsett';

  @override
  String get circlesPlayers => 'Spillere';

  @override
  String get circlesEmptySlot => 'Ledig Plass';

  @override
  String get circlesPlayersRange => '1-5 Spillere';

  @override
  String get circlesQuestions => 'Spørsmål';

  @override
  String get circlesQuestionsSubtitle => 'Antall spørsmål';

  @override
  String get circlesTimePerQuestion => 'Tid per Spørsmål';

  @override
  String get circlesSecondsPerQuestion => 'Sek/Spm';

  @override
  String get circlesAdvanced => 'Ekspert';

  @override
  String get circlesAllowSpectators => 'Tillat Tilskuere';

  @override
  String get circlesAllowSpectatorsSubtitle => 'La andre se på uten å spille';

  @override
  String get circlesLiveVoiceChat => 'Live Talechat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Tillat taleinteraksjon under kamp';

  @override
  String get circlesLiveTextChat => 'Live Tekstchat';

  @override
  String get circlesLiveTextChatSubtitle => 'Tillat meldinger under kamp';

  @override
  String get circlesRoomLocked => 'Rommet er låst';

  @override
  String get circlesRoomUnlocked => 'Rommet er låst opp';

  @override
  String get circlesSettingsSaved => 'Romsinnstillinger lagret';

  @override
  String circlesUpdateFailed(Object error) {
    return 'Kunne ikke oppdatere rommet: $error';
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
  String get circlesCreatedSuccess => 'Sirkel opprettet';

  @override
  String circlesCreateError(Object error) {
    return 'Kunne ikke opprette Sirkel: $error';
  }

  @override
  String get circlesHostTip => 'Tips: Du kan invitere venner etter opprettelse';

  @override
  String circlesJoinError(Object error) {
    return 'Kunne ikke bli med i Sirkel: $error';
  }

  @override
  String get circlesLobbyTitle => 'Sirkel Lobby';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kode: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Kampinnstillinger';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Nivå $level';
  }

  @override
  String get circlesDifficulty => 'Vanskelighetsgrad';

  @override
  String get circlesPerQuestionShort => 'Per Spørsmål';

  @override
  String get circlesInvite => 'Inviter';

  @override
  String get circlesCopyId => 'Kopier ID';

  @override
  String get circlesCopiedId => 'ID kopiert';

  @override
  String get circlesMatchInProgress => 'Kamp pågår';

  @override
  String get circlesSpectatorQueuedBody =>
      'Kamp pågår. Du vil bli med som tilskuer';

  @override
  String get circlesHostStartWhenReady => 'Verten starter når alle er klare';

  @override
  String get circlesSpectators => 'Tilskuere';

  @override
  String get circlesSpectator => 'Tilskuer';

  @override
  String get circlesSpectatorCanWatch => 'Tilskuere kan se live';

  @override
  String get circlesJoinRequests => 'Forespørsler om å bli med';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Godta tilskuere før kampen starter';

  @override
  String get circlesStartGame => 'Start Spill';

  @override
  String get circlesWaitingForPlayers => 'Venter på spillere';

  @override
  String get circlesLeaveCircle => 'Forlat Sirkel';

  @override
  String get circlesRequestSent => 'Forespørsel sendt';

  @override
  String get circlesRequestToJoin => 'Be om å bli med';

  @override
  String get circlesWatchLive => 'Se Live';

  @override
  String get circlesPlayerTip =>
      'Trykk \'Klar\' når du er ferdig. Verten starter kampen';

  @override
  String get circlesSpectatorTip =>
      'Du ser på. Se handlingen live når verten starter';

  @override
  String get circlesHostControls => 'Vertskontroller';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Feil ved overføring av vert: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Feil ved avslutning av Sirkel: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Bruker @$username ikke funnet';
  }

  @override
  String get circlesInvalidUser => 'Ugyldig bruker';

  @override
  String get circlesCantInviteSelf => 'Du kan ikke invitere deg selv';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username er allerede i Sirkelen';
  }

  @override
  String get circlesDefaultHost => 'Vert';

  @override
  String get circlesDefaultTitle => 'Sirkel';

  @override
  String get circlesInviteByUsername => 'Via Brukernavn';

  @override
  String circlesInviteSent(Object username) {
    return 'Invitasjon sendt til @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Kunne ikke sende invitasjon: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Forespørsel om å bli med sendt';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Forespørsel feilet: $error';
  }

  @override
  String get circlesFull => 'Sirkelen er full';

  @override
  String get circlesSpectatorAdded => 'Tilskuer lagt til';

  @override
  String circlesApproveFailed(Object error) {
    return 'Godkjenning feilet: $error';
  }

  @override
  String get circlesRequestDeclined => 'Forespørsel avslått';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Avslag feilet: $error';
  }

  @override
  String get circlesParticipant => 'Deltaker';

  @override
  String get circlesLeavePromptTitle => 'Forlate Sirkelen?';

  @override
  String get circlesLeavePromptTransfer => 'Overfør vert før du forlater';

  @override
  String get circlesLeavePromptEndOnly => 'Avslutt Sirkel og forlat';

  @override
  String get circlesTransferHost => 'Overfør Vert';

  @override
  String get circlesEndCircle => 'Avslutt Sirkel';

  @override
  String get circlesTransferHostTitle => 'Overfør Vert';

  @override
  String circlesShareId(Object id) {
    return 'Sirkel ID: $id';
  }

  @override
  String incomingCallFrom(Object name) {
    return 'Incoming call from $name';
  }

  @override
  String get declineCall => 'Decline';

  @override
  String get acceptCall => 'Accept';

  @override
  String get voiceCall => 'Voice call';

  @override
  String inCallWith(Object name) {
    return 'In call • $name';
  }

  @override
  String get authBenefitLiveCircles => 'Live circles with real learners';

  @override
  String get authBenefitVoiceRooms => 'Voice rooms with instant practice';

  @override
  String get authBenefitFriendChallenges =>
      'Friend challenges and saved progress';
}
