// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

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
  String get profileNoAchievements => 'Κανένα επίτευγμα ακόμα';

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
  String get notificationsTitle => 'Ειδοποιήσεις';

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
  String get notificationsEmpty => 'Δεν υπάρχουν ειδοποιήσεις ακόμα';

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
    return 'Αποτυχία συμμετοχής στον Κύκλο: $error';
  }

  @override
  String get notificationsOpening => 'Άνοιγμα';

  @override
  String get notificationsOpened => 'Άνοιξε';

  @override
  String notificationsActionMessage(Object action) {
    return 'Ειδοποίηση $action';
  }

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsSectionAccount => 'Λογαριασμός';

  @override
  String get settingsEditProfile => 'Επεξεργασία Προφίλ';

  @override
  String get settingsPrivacy => 'Απόρρητο';

  @override
  String get settingsSecurity => 'Ασφάλεια';

  @override
  String get settingsSectionGameplay => 'Παιχνίδι';

  @override
  String get settingsShowTranslationLine => 'Εμφάνιση Γραμμής Μετάφρασης';

  @override
  String get settingsShowReadingLine =>
      'Εμφάνιση Γραμμής Ανάγνωσης (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Χρόνος Ανά Ερώτηση';

  @override
  String get settingsMatchDifficulty => 'Δυσκολία Αγώνα';

  @override
  String get settingsMatchDifficultyAdaptive => 'Προσαρμοστική';

  @override
  String get settingsSectionSoundFeel => 'Ήχος & Αίσθηση';

  @override
  String get settingsMusic => 'Μουσική';

  @override
  String get settingsSoundEffects => 'Εφέ Ήχου';

  @override
  String get settingsHaptics => 'Δόνηση';

  @override
  String get settingsSectionNotifications => 'Ειδοποιήσεις';

  @override
  String get settingsPushNotifications => 'Ειδοποιήσεις Push';

  @override
  String get settingsDailyReminder => 'Καθημερινή Υπενθύμιση';

  @override
  String get settingsSectionAppearance => 'Εμφάνιση';

  @override
  String get settingsTheme => 'Θέμα';

  @override
  String get settingsUiLanguage => 'Γλώσσα UI';

  @override
  String get settingsSectionAbout => 'Σχετικά';

  @override
  String get settingsVersion => 'Έκδοση';

  @override
  String get settingsTermsPrivacy => 'Όροι & Απόρρητο';

  @override
  String get settingsSupport => 'Υποστήριξη';

  @override
  String get settingsLogout => 'Αποσύνδεση';

  @override
  String get themeSystem => 'Σύστημα';

  @override
  String get themeDark => 'Σκούρο';

  @override
  String get themeLight => 'Φωτεινό';

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
  String get editProfileUpdated => 'Το Προφίλ Ενημερώθηκε';

  @override
  String get editProfileTitle => 'Επεξεργασία Προφίλ';

  @override
  String get editProfilePhotoLabel => 'Φωτογραφία Προφίλ';

  @override
  String get editProfilePhotoSubtitle =>
      'Ο επιλογέας Avatar του Supabase Storage έρχεται σύντομα';

  @override
  String get editProfileChangePhoto => 'Αλλαγή';

  @override
  String get editProfileAvatarUploadSoon => 'Μεταφόρτωση Avatar σύντομα';

  @override
  String get editProfileDisplayNameLabel => 'Όνομα Εμφάνισης';

  @override
  String get editProfileDisplayNameHint => 'Το όνομά σας';

  @override
  String get editProfileDisplayNameRequired => 'Παρακαλώ εισάγετε το όνομά σας';

  @override
  String get editProfileDisplayNameTooShort => 'Πολύ σύντομο';

  @override
  String get editProfileUsernameLabel => 'Όνομα Χρήστη';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Παρακαλώ εισάγετε όνομα χρήστη';

  @override
  String get editProfileUsernameTooShort => 'Τουλάχιστον 3 χαρακτήρες';

  @override
  String get editProfileUsernameInvalid => 'Μόνο γράμματα, αριθμοί, _';

  @override
  String get editProfileBioLabel => 'Βιογραφικό';

  @override
  String get editProfileBioHint => 'Μια σύντομη περιγραφή για εσάς...';

  @override
  String get editProfileBioTooLong => 'Μέγιστο 120 χαρακτήρες';

  @override
  String get editProfileLocationLabel => 'Τοποθεσία';

  @override
  String get editProfileLocationHint => 'Πόλη / Χώρα';

  @override
  String get editProfileDailyGoalTitle => 'Ημερήσιος Στόχος';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Επιλέξτε πόσα λεπτά θέλετε να μαθαίνετε την ημέρα';

  @override
  String get securityTitle => 'Ασφάλεια';

  @override
  String get securitySectionPassword => 'Κωδικός Πρόσβασης';

  @override
  String get securityChangePasswordTitle => 'Αλλαγή Κωδικού';

  @override
  String get securityChangePasswordSubtitle =>
      'Ενημερώστε τον κωδικό σας περιοδικά';

  @override
  String get securitySectionTwoFactor => 'Έλεγχος Ταυτότητας Δύο Παραγόντων';

  @override
  String get securityEnable2faTitle => 'Ενεργοποίηση 2FA';

  @override
  String get securityEnable2faSubtitle => 'Πρόσθετη ασφάλεια στη σύνδεση';

  @override
  String get securitySectionAppLock => 'Κλείδωμα Εφαρμογής';

  @override
  String get securityBiometricTitle => 'Βιομετρικό Ξεκλείδωμα';

  @override
  String get securityBiometricSubtitle =>
      'Χρήση FaceID/TouchID για ξεκλείδωμα του SOMA';

  @override
  String get securityAppLockTitle => 'Κλείδωμα Εφαρμογής';

  @override
  String get securityAppLockSubtitle => 'Κλείδωμα SOMA όταν φεύγετε';

  @override
  String get securitySectionSessions => 'Ενεργές Συνεδρίες';

  @override
  String get securityNoSessions => 'Καμία ενεργή συνεδρία';

  @override
  String get securityThisDevice => 'Αυτή η Συσκευή';

  @override
  String get securityDevice => 'Συσκευή';

  @override
  String get securityActiveLabel => 'Ενεργό';

  @override
  String get securitySignInToEnable2fa =>
      'Συνδεθείτε για να ενεργοποιήσετε το 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Αποτυχία ενεργοποίησης 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Αποτυχία απενεργοποίησης 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Ρύθμιση 2FA';

  @override
  String get securitySecretKeyLabel => 'Μυστικό Κλειδί';

  @override
  String get securityCodeHint => '6-ψήφιος κωδικός';

  @override
  String get security2faEnabled => '2FA Ενεργοποιημένο';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Αποτυχία επαλήθευσης κωδικού: $error';
  }

  @override
  String get securityVerifying => 'Επαλήθευση...';

  @override
  String get securityVerify => 'Επαλήθευση';

  @override
  String get securityCurrentPasswordHint => 'Τρέχων Κωδικός';

  @override
  String get securityNewPasswordHint =>
      'Νέος Κωδικός (τουλάχιστον 8 χαρακτήρες)';

  @override
  String get securityConfirmPasswordHint => 'Επιβεβαίωση νέου κωδικού';

  @override
  String get securitySignInToChangePassword => 'Συνδεθείτε για αλλαγή κωδικού';

  @override
  String get securityEnterCurrentPassword => 'Εισάγετε τον τρέχοντα κωδικό';

  @override
  String get securityPasswordMinLength =>
      'Ο νέος κωδικός πρέπει να έχει τουλάχιστον 8 χαρακτήρες';

  @override
  String get securityPasswordsDoNotMatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get securityPasswordUpdated => 'Ο κωδικός ενημερώθηκε';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Αποτυχία ενημέρωσης κωδικού: $error';
  }

  @override
  String get securityAutoLockAfter => 'Αυτόματο Κλείδωμα Μετά';

  @override
  String get privacyTitle => 'Απόρρητο';

  @override
  String get privacySectionVisibility => 'Ορατότητα';

  @override
  String get privacyProfileVisibilityTitle => 'Ορατότητα Προφίλ';

  @override
  String get privacyVisibilityPublic => 'Δημόσιο';

  @override
  String get privacyVisibilityFriends => 'Φίλοι';

  @override
  String get privacyVisibilityPrivate => 'Ιδιωτικό';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Οποιοσδήποτε μπορεί να δει το προφίλ σας';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Μόνο φίλοι μπορούν να δουν το προφίλ σας';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Μόνο εσείς μπορείτε να δείτε το προφίλ σας';

  @override
  String get privacySectionActivity => 'Δραστηριότητα';

  @override
  String get privacyShowOnlineTitle => 'Εμφάνιση Κατάστασης Online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Επιτρέψτε στους παίκτες να βλέπουν πότε είστε online';

  @override
  String get privacyShowActivityTitle => 'Εμφάνιση Δραστηριότητας Μάθησης';

  @override
  String get privacyShowActivitySubtitle =>
      'Εμφάνιση σερί, XP και πρόσφατης προόδου';

  @override
  String get privacySectionSocial => 'Κοινωνικά';

  @override
  String get privacyAllowRequestsTitle => 'Αποδοχή Αιτημάτων Φιλίας';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Επιτρέψτε σε άτομα να σας στέλνουν αιτήματα φιλίας';

  @override
  String get privacyWhoCanDmTitle => 'Ποιος μπορεί να στείλει DM';

  @override
  String get privacyDmEveryone => 'Όλοι';

  @override
  String get privacyDmFriends => 'Φίλοι';

  @override
  String get privacyDmNoOne => 'Κανείς';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Οποιοσδήποτε μπορεί να σας στείλει μήνυμα';

  @override
  String get privacyDmFriendsSubtitle =>
      'Μόνο φίλοι μπορούν να σας στείλουν μήνυμα';

  @override
  String get privacyDmNoOneSubtitle =>
      'Κανείς δεν μπορεί να σας στείλει μήνυμα';

  @override
  String get privacySectionBlockedUsers => 'Αποκλεισμένοι Χρήστες';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Η διαχείριση αποκλεισμένων χρηστών έρχεται σύντομα';

  @override
  String get privacySectionDataControls => 'Έλεγχος Δεδομένων';

  @override
  String get privacyExportDataTitle => 'Εξαγωγή Δεδομένων Μου';

  @override
  String get privacyExportDataSubtitle =>
      'Κατεβάστε τη δραστηριότητα και τα μαθήματά σας';

  @override
  String get privacyExportInfoTitle => 'Εξαγωγή Δεδομένων';

  @override
  String get privacyExportInfoBody =>
      'Άλλο: Δημιουργία εξαγωγής JSON/CSV και αποστολή με email ή απευθείας λήψη';

  @override
  String get privacyDeleteAccountTitle => 'Διαγραφή Λογαριασμού';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Αυτό θα διαγράψει οριστικά τον λογαριασμό και τα δεδομένα σας';

  @override
  String get privacyDeleteConfirmTitle => 'Διαγραφή Λογαριασμού;';

  @override
  String get privacyDeleteConfirmBody =>
      'Αυτό δεν μπορεί να αναιρεθεί. Το προφίλ, τα μαθήματα, οι φίλοι και τα μηνύματά σας θα διαγραφούν';

  @override
  String get privacyDeleteComingSoon =>
      'Η διαγραφή θα ενσωματωθεί με το Supabase αργότερα';

  @override
  String get soloLabel => 'Σόλο';

  @override
  String get soloResultsCompletedTitle => 'Σόλο Συνεδρία Ολοκληρώθηκε';

  @override
  String get soloResultsFeedbackElite =>
      'Κορυφαία απόδοση - κρατήστε το σερί ζωντανό';

  @override
  String get soloResultsFeedbackStrong =>
      'Εξαιρετική δουλειά - βελτιώνεστε γρήγορα';

  @override
  String get soloResultsFeedbackProgress =>
      'Καλή πρόοδος - ελέγξτε τα λάθη και προσπαθήστε ξανά';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Χωρίς πίεση - προσπαθήστε ξανά με λιγότερες ερωτήσεις και συγκεντρωθείτε';

  @override
  String get soloResultsPerfectScore => 'Τέλειο σκορ! Κανένα λάθος για έλεγχο';

  @override
  String get soloResultsReviewPrompt =>
      'Ελέγξτε τα λάθη για να μάθετε γρηγορότερα. Οι λάθος απαντήσεις σας είναι παρακάτω';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Έλεγχος Λαθών ($count)';
  }

  @override
  String get authNotSignedIn => 'Μη Συνδεδεμένος';

  @override
  String get genericUser => 'Χρήστης';

  @override
  String get loading => 'Φόρτωση...';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get send => 'Αποστολή';

  @override
  String get join => 'Συμμετοχή';

  @override
  String get leave => 'Αποχώρηση';

  @override
  String get ready => 'Έτοιμος';

  @override
  String get levelBeginner => 'Αρχάριος';

  @override
  String get levelIntermediate => 'Μεσαίο';

  @override
  String get levelAdvanced => 'Προχωρημένο';

  @override
  String questionsShort(Object count) {
    return '$count Ερωτήσεις';
  }

  @override
  String secondsShort(Object count) {
    return '$count Δευτερόλεπτα';
  }

  @override
  String get circlesAllCourses => 'Όλα τα Μαθήματα';

  @override
  String get circlesAllModes => 'Όλες οι Λειτουργίες';

  @override
  String get circlesAllLevels => 'Όλα τα Επίπεδα';

  @override
  String get circlesAddNewCourse => 'Προσθήκη Νέου Μαθήματος';

  @override
  String get circlesCoursesTitle => 'Μαθήματα';

  @override
  String get circlesModeTitle => 'Λειτουργία';

  @override
  String get circlesLevelTitle => 'Επίπεδο';

  @override
  String get circlesNoActiveForFilters =>
      'Κανένας ενεργός Κύκλος για αυτά τα φίλτρα';

  @override
  String get circlesUnknownRoom => 'Άγνωστο Δωμάτιο';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Δημιουργία Κύκλου';

  @override
  String get circlesCircleName => 'Όνομα Κύκλου';

  @override
  String get circlesEnterName => 'Εισάγετε όνομα';

  @override
  String get circlesLanguages => 'Γλώσσες';

  @override
  String get circlesRoomSetup => 'Ρύθμιση Δωματίου';

  @override
  String get circlesPlayers => 'Παίκτες';

  @override
  String get circlesEmptySlot => 'Κενή Θέση';

  @override
  String get circlesPlayersRange => '1-5 Παίκτες';

  @override
  String get circlesQuestions => 'Ερωτήσεις';

  @override
  String get circlesQuestionsSubtitle => 'Ποσότητα ερωτήσεων';

  @override
  String get circlesTimePerQuestion => 'Χρόνος ανά Ερώτηση';

  @override
  String get circlesSecondsPerQuestion => 'Δευτ/Ερώτηση';

  @override
  String get circlesAdvanced => 'Προχωρημένο';

  @override
  String get circlesAllowSpectators => 'Να επιτρέπονται θεατές';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Να επιτρέπεται σε άλλους να παρακολουθούν χωρίς να παίζουν';

  @override
  String get circlesLiveVoiceChat => 'Ζωντανή Φωνητική Συνομιλία';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Ενεργοποίηση φωνητικής αλληλεπίδρασης κατά τη διάρκεια του αγώνα';

  @override
  String get circlesLiveTextChat => 'Ζωντανή Συνομιλία Κειμένου';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Ενεργοποίηση μηνυμάτων κατά τη διάρκεια του αγώνα';

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
  String get circlesCreatedSuccess => 'Ο Κύκλος δημιουργήθηκε';

  @override
  String circlesCreateError(Object error) {
    return 'Αποτυχία δημιουργίας Κύκλου: $error';
  }

  @override
  String get circlesHostTip =>
      'Συμβουλή: Μπορείτε να προσκαλέσετε φίλους μετά τη δημιουργία';

  @override
  String circlesJoinError(Object error) {
    return 'Αποτυχία συμμετοχής στον Κύκλο: $error';
  }

  @override
  String get circlesLobbyTitle => 'Λόμπι Κύκλου';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Κωδικός: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Ρυθμίσεις Αγώνα';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Επίπεδο $level';
  }

  @override
  String get circlesDifficulty => 'Δυσκολία';

  @override
  String get circlesPerQuestionShort => 'Ανά ερώτηση';

  @override
  String get circlesInvite => 'Πρόσκληση';

  @override
  String get circlesCopyId => 'Αντιγραφή ID';

  @override
  String get circlesCopiedId => 'Το ID αντιγράφηκε';

  @override
  String get circlesMatchInProgress => 'Αγώνας σε εξέλιξη';

  @override
  String get circlesSpectatorQueuedBody =>
      'Αγώνας σε εξέλιξη. Θα συμμετάσχετε ως θεατής';

  @override
  String get circlesHostStartWhenReady =>
      'Ο οικοδεσπότης θα ξεκινήσει όταν όλοι είναι έτοιμοι';

  @override
  String get circlesSpectators => 'Θεατές';

  @override
  String get circlesSpectator => 'Θεατής';

  @override
  String get circlesSpectatorCanWatch =>
      'Οι θεατές μπορούν να παρακολουθήσουν ζωντανά';

  @override
  String get circlesJoinRequests => 'Αιτήματα Συμμετοχής';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Αποδεχτείτε θεατές πριν ξεκινήσετε τον αγώνα';

  @override
  String get circlesStartGame => 'Έναρξη Παιχνιδιού';

  @override
  String get circlesStartingGame => 'Starting game...';

  @override
  String get circlesWaitingForPlayers => 'Αναμονή για παίκτες';

  @override
  String get circlesLeaveCircle => 'Αποχώρηση από Κύκλο';

  @override
  String get circlesRequestSent => 'Αίτημα εστάλη';

  @override
  String get circlesRequestToJoin => 'Αίτημα Συμμετοχής';

  @override
  String get circlesWatchLive => 'Παρακολούθηση Ζωντανά';

  @override
  String get circlesPlayerTip =>
      'Πατήστε \'Έτοιμος\' όταν είστε έτοιμοι. Ο οικοδεσπότης θα ξεκινήσει τον αγώνα';

  @override
  String get circlesSpectatorTip =>
      'Παρακολουθείτε. Δείτε τη δράση ζωντανά όταν ξεκινήσει ο οικοδεσπότης';

  @override
  String get circlesHostControls => 'Έλεγχοι Οικοδεσπότη';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Αποτυχία μεταφοράς οικοδεσπότη: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Αποτυχία τερματισμού Κύκλου: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Ο χρήστης @$username δεν βρέθηκε';
  }

  @override
  String get circlesInvalidUser => 'Μη έγκυρος χρήστης';

  @override
  String get circlesCantInviteSelf =>
      'Δεν μπορείτε να προσκαλέσετε τον εαυτό σας';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'Ο/Η @$username είναι ήδη στον Κύκλο';
  }

  @override
  String get circlesDefaultHost => 'Οικοδεσπότης';

  @override
  String get circlesDefaultTitle => 'Κύκλος';

  @override
  String get circlesInviteByUsername => 'Μέσω Ονόματος Χρήστη';

  @override
  String circlesInviteSent(Object username) {
    return 'Πρόσκληση εστάλη στον/στην @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Αποτυχία αποστολής πρόσκλησης: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Το αίτημα συμμετοχής εστάλη';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Το αίτημα απέτυχε: $error';
  }

  @override
  String get circlesFull => 'Ο Κύκλος είναι πλήρης';

  @override
  String get circlesSpectatorAdded => 'Προστέθηκε θεατής';

  @override
  String circlesApproveFailed(Object error) {
    return 'Αποτυχία έγκρισης: $error';
  }

  @override
  String get circlesRequestDeclined => 'Το αίτημα απορρίφθηκε';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Αποτυχία απόρριψης: $error';
  }

  @override
  String get circlesParticipant => 'Συμμετέχων';

  @override
  String get circlesLeavePromptTitle => 'Αποχώρηση από τον Κύκλο;';

  @override
  String get circlesLeavePromptTransfer =>
      'Μεταφέρετε τον οικοδεσπότη πριν φύγετε';

  @override
  String get circlesLeavePromptEndOnly => 'Τερματισμός Κύκλου και αποχώρηση';

  @override
  String get circlesTransferHost => 'Μεταφορά Οικοδεσπότη';

  @override
  String get circlesEndCircle => 'Τερματισμός Κύκλου';

  @override
  String get circlesTransferHostTitle => 'Μεταφορά Οικοδεσπότη';

  @override
  String circlesShareId(Object id) {
    return 'ID Κύκλου: $id';
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
