// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get profileNoAchievements => 'No achievements yet.';

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
  String get notificationsTitle => 'Notifications';

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
  String get notificationsEmpty => 'No notifications here.';

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
    return 'Couldn\'t join circle: $error';
  }

  @override
  String get notificationsOpening => 'Opening';

  @override
  String get notificationsOpened => 'Opened';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notification';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Show translation line';

  @override
  String get settingsShowReadingLine => 'Show reading (pinyin/romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Default timer per question';

  @override
  String get settingsMatchDifficulty => 'Match difficulty';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptive';

  @override
  String get settingsSectionSoundFeel => 'Sound & Feel';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsSoundEffects => 'Sound effects';

  @override
  String get settingsHaptics => 'Haptics';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Push notifications';

  @override
  String get settingsDailyReminder => 'Daily reminder';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsUiLanguage => 'UI language';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsTermsPrivacy => 'Terms & Privacy';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

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
  String get editProfileUpdated => 'Profile updated';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfilePhotoLabel => 'Profile photo';

  @override
  String get editProfilePhotoSubtitle =>
      'Avatar selection via Supabase Storage upcoming.';

  @override
  String get editProfileChangePhoto => 'Change';

  @override
  String get editProfileAvatarUploadSoon => 'Avatar upload coming soon';

  @override
  String get editProfileDisplayNameLabel => 'Display name';

  @override
  String get editProfileDisplayNameHint => 'Your name';

  @override
  String get editProfileDisplayNameRequired => 'Enter your name';

  @override
  String get editProfileDisplayNameTooShort => 'Too short';

  @override
  String get editProfileUsernameLabel => 'Username';

  @override
  String get editProfileUsernameHint => 'alex_learner';

  @override
  String get editProfileUsernameRequired => 'Enter username';

  @override
  String get editProfileUsernameTooShort => 'Min 3 characters';

  @override
  String get editProfileUsernameInvalid => 'Only letters, numbers, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Short bio...';

  @override
  String get editProfileBioTooLong => 'Max 120 chars';

  @override
  String get editProfileLocationLabel => 'Location';

  @override
  String get editProfileLocationHint => 'City / Country';

  @override
  String get editProfileDailyGoalTitle => 'Daily goal';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Choose how many minutes you want to study daily.';

  @override
  String get securityTitle => 'Security';

  @override
  String get securitySectionPassword => 'Password';

  @override
  String get securityChangePasswordTitle => 'Change password';

  @override
  String get securityChangePasswordSubtitle =>
      'Update your password regularly.';

  @override
  String get securitySectionTwoFactor => 'Two-Factor Authentication';

  @override
  String get securityEnable2faTitle => 'Enable 2FA';

  @override
  String get securityEnable2faSubtitle => 'Extra protection when signing in.';

  @override
  String get securitySectionAppLock => 'App Lock';

  @override
  String get securityBiometricTitle => 'Biometric unlock';

  @override
  String get securityBiometricSubtitle => 'Use FaceID/TouchID to unlock SOMA.';

  @override
  String get securityAppLockTitle => 'App lock';

  @override
  String get securityAppLockSubtitle => 'Lock SOMA when you leave the app.';

  @override
  String get securitySectionSessions => 'Active Sessions';

  @override
  String get securityNoSessions => 'No active sessions found.';

  @override
  String get securityThisDevice => 'This device';

  @override
  String get securityDevice => 'Device';

  @override
  String get securityActiveLabel => 'Active';

  @override
  String get securitySignInToEnable2fa => 'Sign in to enable 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Couldn\'t enable 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Couldn\'t disable 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Set up 2FA';

  @override
  String get securitySecretKeyLabel => 'Secret key';

  @override
  String get securityCodeHint => '6-digit code';

  @override
  String get security2faEnabled => '2FA enabled';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Couldn\'t verify code: $error';
  }

  @override
  String get securityVerifying => 'Verifying...';

  @override
  String get securityVerify => 'Verify';

  @override
  String get securityCurrentPasswordHint => 'Current password';

  @override
  String get securityNewPasswordHint => 'New password (min 8 chars)';

  @override
  String get securityConfirmPasswordHint => 'Confirm new password';

  @override
  String get securitySignInToChangePassword =>
      'Sign in to change your password';

  @override
  String get securityEnterCurrentPassword => 'Enter your current password';

  @override
  String get securityPasswordMinLength =>
      'New password must be at least 8 characters';

  @override
  String get securityPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get securityPasswordUpdated => 'Password updated';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Couldn\'t update password: $error';
  }

  @override
  String get securityAutoLockAfter => 'Auto lock after';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacySectionVisibility => 'Visibility';

  @override
  String get privacyProfileVisibilityTitle => 'Profile visibility';

  @override
  String get privacyVisibilityPublic => 'Public';

  @override
  String get privacyVisibilityFriends => 'Friends';

  @override
  String get privacyVisibilityPrivate => 'Private';

  @override
  String get privacyVisibilityPublicSubtitle => 'Anyone can view your profile.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Only friends can view your profile.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Only you can view your profile.';

  @override
  String get privacySectionActivity => 'Activity';

  @override
  String get privacyShowOnlineTitle => 'Show online status';

  @override
  String get privacyShowOnlineSubtitle => 'Let others see when you\'re online.';

  @override
  String get privacyShowActivityTitle => 'Show learning activity';

  @override
  String get privacyShowActivitySubtitle =>
      'Show streak, XP, and recent progress.';

  @override
  String get privacySectionSocial => 'Social';

  @override
  String get privacyAllowRequestsTitle => 'Allow friend requests';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Let people send you friend requests.';

  @override
  String get privacyWhoCanDmTitle => 'Who can DM you';

  @override
  String get privacyDmEveryone => 'Everyone';

  @override
  String get privacyDmFriends => 'Friends';

  @override
  String get privacyDmNoOne => 'No one';

  @override
  String get privacyDmEveryoneSubtitle => 'Anyone can message you.';

  @override
  String get privacyDmFriendsSubtitle => 'Only friends can message you.';

  @override
  String get privacyDmNoOneSubtitle => 'Nobody can message you.';

  @override
  String get privacySectionBlockedUsers => 'Blocked users';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Blocked users management coming soon.';

  @override
  String get privacySectionDataControls => 'Data controls';

  @override
  String get privacyExportDataTitle => 'Export my data';

  @override
  String get privacyExportDataSubtitle => 'Download your activity and courses.';

  @override
  String get privacyExportInfoTitle => 'Export data';

  @override
  String get privacyExportInfoBody =>
      'Next step: generate a JSON/CSV export and email it or download locally.';

  @override
  String get privacyDeleteAccountTitle => 'Delete account';

  @override
  String get privacyDeleteAccountSubtitle =>
      'This permanently removes your account and data.';

  @override
  String get privacyDeleteConfirmTitle => 'Delete account?';

  @override
  String get privacyDeleteConfirmBody =>
      'This action is permanent. Your profile, courses, friends, and messages will be removed.';

  @override
  String get privacyDeleteComingSoon =>
      'Delete will be wired to Supabase later';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo Session Completed';

  @override
  String get soloResultsFeedbackElite => 'Elite performance. Keep the streak';

  @override
  String get soloResultsFeedbackStrong =>
      'Strong work. You\'re improving fast.';

  @override
  String get soloResultsFeedbackProgress =>
      'Good progress. Review mistakes and repeat.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'No stress. Try again with fewer questions and focus.';

  @override
  String get soloResultsPerfectScore => 'Perfect score! No mistakes to review.';

  @override
  String get soloResultsReviewPrompt =>
      'Review mistakes to learn faster. We\'ll show wrong answers here next.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Review Mistakes ($count)';
  }

  @override
  String get authNotSignedIn => 'You are not signed in';

  @override
  String get genericUser => 'User';

  @override
  String get loading => 'Loading...';

  @override
  String get edit => 'Edit';

  @override
  String get send => 'Send';

  @override
  String get join => 'Join';

  @override
  String get leave => 'Leave';

  @override
  String get ready => 'Ready';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String questionsShort(Object count) {
    return '$count Q';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'All courses';

  @override
  String get circlesAllModes => 'All modes';

  @override
  String get circlesAllLevels => 'All levels';

  @override
  String get circlesAddNewCourse => 'Add new course';

  @override
  String get circlesCoursesTitle => 'Courses';

  @override
  String get circlesModeTitle => 'Mode';

  @override
  String get circlesLevelTitle => 'Level';

  @override
  String get circlesNoActiveForFilters =>
      'No active circles for these filters.';

  @override
  String get circlesUnknownRoom => 'Unknown room';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Create Circle';

  @override
  String get circlesCircleName => 'Circle name';

  @override
  String get circlesEnterName => 'Enter a name';

  @override
  String get circlesLanguages => 'Languages';

  @override
  String get circlesRoomSetup => 'Room setup';

  @override
  String get circlesPlayers => 'Players';

  @override
  String get circlesEmptySlot => 'Empty slot';

  @override
  String get circlesPlayersRange => '1-5 players';

  @override
  String get circlesQuestions => 'Questions';

  @override
  String get circlesQuestionsSubtitle => 'How many questions';

  @override
  String get circlesTimePerQuestion => 'Time per question';

  @override
  String get circlesSecondsPerQuestion => 'seconds per question';

  @override
  String get circlesAdvanced => 'Advanced';

  @override
  String get circlesAllowSpectators => 'Allow spectators';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Let others watch without playing.';

  @override
  String get circlesLiveVoiceChat => 'Live voice chat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Enable live voice during matches.';

  @override
  String get circlesLiveTextChat => 'Live text chat';

  @override
  String get circlesLiveTextChatSubtitle => 'Enable chat during matches.';

  @override
  String get circlesCreatedSuccess => 'Circle created';

  @override
  String circlesCreateError(Object error) {
    return 'Failed to create circle: $error';
  }

  @override
  String get circlesHostTip => 'Tip: you can invite friends after creating.';

  @override
  String circlesJoinError(Object error) {
    return 'Failed to join circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle lobby';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Code: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Match settings';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Level $level';
  }

  @override
  String get circlesDifficulty => 'Difficulty';

  @override
  String get circlesPerQuestionShort => 'per question';

  @override
  String get circlesInvite => 'Invite';

  @override
  String get circlesCopyId => 'Copy ID';

  @override
  String get circlesCopiedId => 'ID copied';

  @override
  String get circlesMatchInProgress => 'Match in progress';

  @override
  String get circlesSpectatorQueuedBody =>
      'Match is in progress. You\'ll join as spectator.';

  @override
  String get circlesHostStartWhenReady => 'Host starts when everyone is ready.';

  @override
  String get circlesSpectators => 'Spectators';

  @override
  String get circlesSpectator => 'Spectator';

  @override
  String get circlesSpectatorCanWatch => 'Spectators can watch live.';

  @override
  String get circlesJoinRequests => 'Join requests';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Accept spectators before the match starts.';

  @override
  String get circlesStartGame => 'Start game';

  @override
  String get circlesWaitingForPlayers => 'Waiting for players';

  @override
  String get circlesLeaveCircle => 'Leave circle';

  @override
  String get circlesRequestSent => 'Request Sent';

  @override
  String get circlesRequestToJoin => 'Request to Join';

  @override
  String get circlesWatchLive => 'Watch live';

  @override
  String get circlesPlayerTip =>
      'Tap Ready when you\'re set. Host will start the match.';

  @override
  String get circlesSpectatorTip =>
      'You\'re spectating. Watch live once the host starts.';

  @override
  String get circlesHostControls => 'Host controls';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Failed to transfer host: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Failed to end circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'User @$username not found';
  }

  @override
  String get circlesInvalidUser => 'Invalid user';

  @override
  String get circlesCantInviteSelf => 'You can\'t invite yourself';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'User @$username is already in the circle';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Invite by username';

  @override
  String circlesInviteSent(Object username) {
    return 'Invite sent to @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Failed to send invite: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Join request sent';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Failed to request join: $error';
  }

  @override
  String get circlesFull => 'Circle is full';

  @override
  String get circlesSpectatorAdded => 'Spectator added';

  @override
  String circlesApproveFailed(Object error) {
    return 'Failed to approve request: $error';
  }

  @override
  String get circlesRequestDeclined => 'Request declined';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Failed to decline request: $error';
  }

  @override
  String get circlesParticipant => 'Participant';

  @override
  String get circlesLeavePromptTitle => 'Leave circle?';

  @override
  String get circlesLeavePromptTransfer => 'Transfer host before leaving.';

  @override
  String get circlesLeavePromptEndOnly => 'End the circle and leave.';

  @override
  String get circlesTransferHost => 'Transfer host';

  @override
  String get circlesEndCircle => 'End circle';

  @override
  String get circlesTransferHostTitle => 'Transfer host';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
