// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

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
  String get profileNoAchievements => 'אין הישגים עדיין';

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
  String get notificationsTitle => 'התראות';

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
  String get notificationsEmpty => 'אין עדיין התראות';

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
    return 'ההצטרפות למעגל נכשלה: $error';
  }

  @override
  String get notificationsOpening => 'פותח';

  @override
  String get notificationsOpened => 'נפתח';

  @override
  String notificationsActionMessage(Object action) {
    return 'התראת $action';
  }

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get settingsSectionAccount => 'חשבון';

  @override
  String get settingsEditProfile => 'ערוך פרופיל';

  @override
  String get settingsPrivacy => 'פרטיות';

  @override
  String get settingsSecurity => 'אבטחה';

  @override
  String get settingsSectionGameplay => 'משחקיות';

  @override
  String get settingsShowTranslationLine => 'הצג שורת תרגום';

  @override
  String get settingsShowReadingLine => 'הצג שורת קריאה (פיניין/רומאג\'י)';

  @override
  String get settingsDefaultTimerPerQuestion => 'זמן לכל שאלה';

  @override
  String get settingsMatchDifficulty => 'קושי המשחק';

  @override
  String get settingsMatchDifficultyAdaptive => 'מותאם אישית';

  @override
  String get settingsSectionSoundFeel => 'צליל ותחושה';

  @override
  String get settingsMusic => 'מוזיקה';

  @override
  String get settingsSoundEffects => 'אפקטים קוליים';

  @override
  String get settingsHaptics => 'רטט';

  @override
  String get settingsSectionNotifications => 'התראות';

  @override
  String get settingsPushNotifications => 'התראות דחיפה';

  @override
  String get settingsDailyReminder => 'תזכורת יומית';

  @override
  String get settingsSectionAppearance => 'מראה';

  @override
  String get settingsTheme => 'ערכת נושא';

  @override
  String get settingsUiLanguage => 'שפת ממשק';

  @override
  String get settingsSectionAbout => 'אודות';

  @override
  String get settingsVersion => 'גרסה';

  @override
  String get settingsTermsPrivacy => 'תנאים ופרטיות';

  @override
  String get settingsSupport => 'תמיכה';

  @override
  String get settingsLogout => 'התנתק';

  @override
  String get themeSystem => 'מערכת';

  @override
  String get themeDark => 'כהה';

  @override
  String get themeLight => 'בהיר';

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
  String get editProfileUpdated => 'הפרופיל עודכן';

  @override
  String get editProfileTitle => 'ערוך פרופיל';

  @override
  String get editProfilePhotoLabel => 'תמונת פרופיל';

  @override
  String get editProfilePhotoSubtitle =>
      'בוחר הדמויות של Supabase Storage בקרוב';

  @override
  String get editProfileChangePhoto => 'שנה';

  @override
  String get editProfileAvatarUploadSoon => 'העלאת אווטאר בקרוב';

  @override
  String get editProfileDisplayNameLabel => 'שם תצוגה';

  @override
  String get editProfileDisplayNameHint => 'השם שלך';

  @override
  String get editProfileDisplayNameRequired => 'אנא הכנס את שמך';

  @override
  String get editProfileDisplayNameTooShort => 'קצר מדי';

  @override
  String get editProfileUsernameLabel => 'שם משתמש';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'אנא הכנס שם משתמש';

  @override
  String get editProfileUsernameTooShort => 'לפחות 3 תווים';

  @override
  String get editProfileUsernameInvalid => 'רק אותיות, מספרים, _';

  @override
  String get editProfileBioLabel => 'ביוגרפיה';

  @override
  String get editProfileBioHint => 'תיאור קצר עליך...';

  @override
  String get editProfileBioTooLong => 'מקסימום 120 תווים';

  @override
  String get editProfileLocationLabel => 'מיקום';

  @override
  String get editProfileLocationHint => 'עיר / מדינה';

  @override
  String get editProfileDailyGoalTitle => 'יעד יומי';

  @override
  String get editProfileDailyGoalSubtitle => 'בחר כמה דקות תרצה ללמוד ביום';

  @override
  String get securityTitle => 'אבטחה';

  @override
  String get securitySectionPassword => 'סיסמה';

  @override
  String get securityChangePasswordTitle => 'שנה סיסמה';

  @override
  String get securityChangePasswordSubtitle => 'עדכן את הסיסמה שלך באופן קבוע';

  @override
  String get securitySectionTwoFactor => 'אימות דו-שלבי';

  @override
  String get securityEnable2faTitle => 'הפעל אימות דו-שלבי';

  @override
  String get securityEnable2faSubtitle => 'אבטחה נוספת בכניסה';

  @override
  String get securitySectionAppLock => 'נעילת אפליקציה';

  @override
  String get securityBiometricTitle => 'פתיחה ביומטרית';

  @override
  String get securityBiometricSubtitle =>
      'השתמש ב-FaceID/TouchID כדי לפתוח את SOMA';

  @override
  String get securityAppLockTitle => 'נעילת אפליקציה';

  @override
  String get securityAppLockSubtitle => 'נעל את SOMA כשאתה עוזב';

  @override
  String get securitySectionSessions => 'הפעלות פעילות';

  @override
  String get securityNoSessions => 'אין הפעלות פעילות';

  @override
  String get securityThisDevice => 'מכשיר זה';

  @override
  String get securityDevice => 'מכשיר';

  @override
  String get securityActiveLabel => 'פעיל';

  @override
  String get securitySignInToEnable2fa => 'התחבר כדי להפעיל אימות דו-שלבי';

  @override
  String securityEnable2faFailed(Object error) {
    return 'נכשל בהפעלת אימות דו-שלבי: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'נכשל בהשבתת אימות דו-שלבי: $error';
  }

  @override
  String get securitySetup2faTitle => 'הגדרת אימות דו-שלבי';

  @override
  String get securitySecretKeyLabel => 'מפתח סודי';

  @override
  String get securityCodeHint => 'קוד 6 ספרות';

  @override
  String get security2faEnabled => 'אימות דו-שלבי מופעל';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'אימות הקוד נכשל: $error';
  }

  @override
  String get securityVerifying => 'מאמת...';

  @override
  String get securityVerify => 'אמת';

  @override
  String get securityCurrentPasswordHint => 'סיסמה נוכחית';

  @override
  String get securityNewPasswordHint => 'סיסמה חדשה (מינימום 8 תווים)';

  @override
  String get securityConfirmPasswordHint => 'אשר סיסמה חדשה';

  @override
  String get securitySignInToChangePassword => 'התחבר כדי לשנות סיסמה';

  @override
  String get securityEnterCurrentPassword => 'הכנס את הסיסמה הנוכחית שלך';

  @override
  String get securityPasswordMinLength =>
      'הסיסמה החדשה חייבת להכיל לפחות 8 תווים';

  @override
  String get securityPasswordsDoNotMatch => 'הסיסמאות אינן תואמות';

  @override
  String get securityPasswordUpdated => 'הסיסמה עודכנה';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'עדכון הסיסמה נכשל: $error';
  }

  @override
  String get securityAutoLockAfter => 'נעילה אוטומטית לאחר';

  @override
  String get privacyTitle => 'פרטיות';

  @override
  String get privacySectionVisibility => 'נראות';

  @override
  String get privacyProfileVisibilityTitle => 'נראות הפרופיל';

  @override
  String get privacyVisibilityPublic => 'ציבורי';

  @override
  String get privacyVisibilityFriends => 'חברים';

  @override
  String get privacyVisibilityPrivate => 'פרטי';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'כולם יכולים לראות את הפרופיל שלך';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'רק חברים יכולים לראות את הפרופיל שלך';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'רק אתה יכול לראות את הפרופיל שלך';

  @override
  String get privacySectionActivity => 'פעילות';

  @override
  String get privacyShowOnlineTitle => 'הצג סטטוס מקוון';

  @override
  String get privacyShowOnlineSubtitle => 'אפשר לשחקנים לראות מתי אתה מקוון';

  @override
  String get privacyShowActivityTitle => 'הצג פעילות למידה';

  @override
  String get privacyShowActivitySubtitle =>
      'הצג רצף, נקודות ניסיון והתקדמות אחרונה';

  @override
  String get privacySectionSocial => 'חברתי';

  @override
  String get privacyAllowRequestsTitle => 'אפשר בקשות חברות';

  @override
  String get privacyAllowRequestsSubtitle => 'אפשר לאנשים לשלוח לך בקשות חברות';

  @override
  String get privacyWhoCanDmTitle => 'מי יכול לשלוח הודעות פרטיות';

  @override
  String get privacyDmEveryone => 'כולם';

  @override
  String get privacyDmFriends => 'חברים';

  @override
  String get privacyDmNoOne => 'אף אחד';

  @override
  String get privacyDmEveryoneSubtitle => 'כולם יכולים לשלוח לך הודעות';

  @override
  String get privacyDmFriendsSubtitle => 'רק חברים יכולים לשלוח לך הודעות';

  @override
  String get privacyDmNoOneSubtitle => 'אף אחד לא יכול לשלוח לך הודעות';

  @override
  String get privacySectionBlockedUsers => 'משתמשים חסומים';

  @override
  String get privacyBlockedUsersComingSoon => 'ניהול משתמשים חסומים בקרוב';

  @override
  String get privacySectionDataControls => 'בקרת נתונים';

  @override
  String get privacyExportDataTitle => 'ייצא את הנתונים שלי';

  @override
  String get privacyExportDataSubtitle => 'הורד את הפעילות והקורסים שלך';

  @override
  String get privacyExportInfoTitle => 'ייצוא נתונים';

  @override
  String get privacyExportInfoBody =>
      'אחר: צור ייצוא JSON/CSV ושלח במייל או הורד ישירות';

  @override
  String get privacyDeleteAccountTitle => 'מחק חשבון';

  @override
  String get privacyDeleteAccountSubtitle =>
      'פעולה זו מוחקת לצמיתות את החשבון והנתונים שלך';

  @override
  String get privacyDeleteConfirmTitle => 'למחוק את החשבון?';

  @override
  String get privacyDeleteConfirmBody =>
      'פעולה זו אינה הפיכה. הפרופיל, הקורסים, החברים וההודעות שלך יימחקו';

  @override
  String get privacyDeleteComingSoon => 'המחיקה תשתלב עם Supabase בהמשך';

  @override
  String get soloLabel => 'סולו';

  @override
  String get soloResultsCompletedTitle => 'הפעלת סולו הסתיימה';

  @override
  String get soloResultsFeedbackElite => 'ביצועי עלית - שמור על הרצף';

  @override
  String get soloResultsFeedbackStrong => 'הישג יפה - אתה משתפר במהירות';

  @override
  String get soloResultsFeedbackProgress =>
      'התקדמות טובה - בדוק טעויות ונסה שוב';

  @override
  String get soloResultsFeedbackTryAgain =>
      'אין לחץ - נסה שוב עם פחות שאלות והתמקד';

  @override
  String get soloResultsPerfectScore => 'ציון מושלם! אין מה לבדוק';

  @override
  String get soloResultsReviewPrompt =>
      'בדוק את הטעויות שלך ללמידה מהירה יותר. התשובות השגויות שלך למטה';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'בדוק טעויות ($count)';
  }

  @override
  String get authNotSignedIn => 'לא מחובר';

  @override
  String get genericUser => 'משתמש';

  @override
  String get loading => 'טוען...';

  @override
  String get edit => 'ערוך';

  @override
  String get send => 'שלח';

  @override
  String get join => 'הצטרף';

  @override
  String get leave => 'עזוב';

  @override
  String get ready => 'מוכן';

  @override
  String get levelBeginner => 'מתחיל';

  @override
  String get levelIntermediate => 'בינוני';

  @override
  String get levelAdvanced => 'מומחה';

  @override
  String questionsShort(Object count) {
    return '$count שאלות';
  }

  @override
  String secondsShort(Object count) {
    return '$count שניות';
  }

  @override
  String get circlesAllCourses => 'כל הקורסים';

  @override
  String get circlesAllModes => 'כל המצבים';

  @override
  String get circlesAllLevels => 'כל הרמות';

  @override
  String get circlesAddNewCourse => 'הוסף קורס חדש';

  @override
  String get circlesCoursesTitle => 'קורסים';

  @override
  String get circlesModeTitle => 'מצב';

  @override
  String get circlesLevelTitle => 'רמה';

  @override
  String get circlesNoActiveForFilters => 'אין מעגל פעיל עבור מסננים אלו';

  @override
  String get circlesUnknownRoom => 'חדר לא ידוע';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'צור מעגל';

  @override
  String get circlesCircleName => 'שם המעגל';

  @override
  String get circlesEnterName => 'הכנס שם';

  @override
  String get circlesLanguages => 'שפות';

  @override
  String get circlesRoomSetup => 'הגדרת חדר';

  @override
  String get circlesPlayers => 'שחקנים';

  @override
  String get circlesEmptySlot => 'מקום פנוי';

  @override
  String get circlesPlayersRange => '1-5 שחקנים';

  @override
  String get circlesQuestions => 'שאלות';

  @override
  String get circlesQuestionsSubtitle => 'כמות השאלות';

  @override
  String get circlesTimePerQuestion => 'זמן לכל שאלה';

  @override
  String get circlesSecondsPerQuestion => 'שניות/שאלה';

  @override
  String get circlesAdvanced => 'מומחה';

  @override
  String get circlesAllowSpectators => 'אפשר צופים';

  @override
  String get circlesAllowSpectatorsSubtitle => 'אפשר לאחרים לצפות ללא משחק';

  @override
  String get circlesLiveVoiceChat => 'צ\'אט קולי חי';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'אפשר אינטראקציה קולית במהלך המשחק';

  @override
  String get circlesLiveTextChat => 'צ\'אט טקסט חי';

  @override
  String get circlesLiveTextChatSubtitle => 'אפשר שליחת הודעות במהלך המשחק';

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
  String get circlesCreatedSuccess => 'המעגל נוצר';

  @override
  String circlesCreateError(Object error) {
    return 'יצירת המעגל נכשלה: $error';
  }

  @override
  String get circlesHostTip => 'טיפ: אתה יכול להזמין חברים לאחר היצירה';

  @override
  String circlesJoinError(Object error) {
    return 'ההצטרפות למעגל נכשלה: $error';
  }

  @override
  String get circlesLobbyTitle => 'לובי המעגל';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'קוד: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'הגדרות משחק';

  @override
  String circlesLevelWithValue(Object level) {
    return 'רמה $level';
  }

  @override
  String get circlesDifficulty => 'רמת קושי';

  @override
  String get circlesPerQuestionShort => 'לשאלה';

  @override
  String get circlesInvite => 'הזמן';

  @override
  String get circlesCopyId => 'העתק מזהה';

  @override
  String get circlesCopiedId => 'המזהה הועתק';

  @override
  String get circlesMatchInProgress => 'משחק בתהליך';

  @override
  String get circlesSpectatorQueuedBody => 'משחק בתהליך. תצטרף כצופה';

  @override
  String get circlesHostStartWhenReady => 'המארח יתחיל כשכולם מוכנים';

  @override
  String get circlesSpectators => 'צופים';

  @override
  String get circlesSpectator => 'צופה';

  @override
  String get circlesSpectatorCanWatch => 'צופים יכולים לצפות בשידור חי';

  @override
  String get circlesJoinRequests => 'בקשות הצטרפות';

  @override
  String get circlesAcceptSpectatorsHint => 'קבל צופים לפני תחילת המשחק';

  @override
  String get circlesStartGame => 'התחל משחק';

  @override
  String get circlesStartingGame => 'Starting game...';

  @override
  String get circlesWaitingForPlayers => 'מחכה לשחקנים';

  @override
  String get circlesLeaveCircle => 'עזוב מעגל';

  @override
  String get circlesRequestSent => 'הבקשה נשלחה';

  @override
  String get circlesRequestToJoin => 'בקש להצטרף';

  @override
  String get circlesWatchLive => 'צפה בשידור חי';

  @override
  String get circlesPlayerTip =>
      'הקש על \'מוכן\' כשאתה מוכן. המארח יתחיל את המשחק';

  @override
  String get circlesSpectatorTip =>
      'אתה צופה. צפה בפעולה בשידור חי כשהמארח מתחיל';

  @override
  String get circlesHostControls => 'בקרות מארח';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'העברת האירוח נכשלה: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'סגירת המעגל נכשלה: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'משתמש @$username לא נמצא';
  }

  @override
  String get circlesInvalidUser => 'משתמש לא חוקי';

  @override
  String get circlesCantInviteSelf => 'אתה לא יכול להזמין את עצמך';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username כבר במעגל';
  }

  @override
  String get circlesDefaultHost => 'מארח';

  @override
  String get circlesDefaultTitle => 'מעגל';

  @override
  String get circlesInviteByUsername => 'לפי שם משתמש';

  @override
  String circlesInviteSent(Object username) {
    return 'הזמנה נשלחה ל-@$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'שליחת ההזמנה נכשלה: $error';
  }

  @override
  String get circlesJoinRequestSent => 'בקשת הצטרפות נשלחה';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'הבקשה נכשלה: $error';
  }

  @override
  String get circlesFull => 'המעגל מלא';

  @override
  String get circlesSpectatorAdded => 'צופה נוסף';

  @override
  String circlesApproveFailed(Object error) {
    return 'האישור נכשל: $error';
  }

  @override
  String get circlesRequestDeclined => 'הבקשה נדחתה';

  @override
  String circlesDeclineFailed(Object error) {
    return 'הדחייה נכשלה: $error';
  }

  @override
  String get circlesParticipant => 'משתתף';

  @override
  String get circlesLeavePromptTitle => 'לעזוב את המעגל?';

  @override
  String get circlesLeavePromptTransfer => 'העבר את האירוח לפני העזיבה';

  @override
  String get circlesLeavePromptEndOnly => 'סיים את המעגל ועזוב';

  @override
  String get circlesTransferHost => 'העבר אירוח';

  @override
  String get circlesEndCircle => 'סיים מעגל';

  @override
  String get circlesTransferHostTitle => 'העברת אירוח';

  @override
  String circlesShareId(Object id) {
    return 'מזהה מעגל: $id';
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
