// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

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
  String get profileNoAchievements => 'Tiada pencapaian lagi';

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
  String get notificationsTitle => 'Pemberitahuan';

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
  String get notificationsEmpty => 'Tiada pemberitahuan lagi';

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
    return 'Gagal menyertai Bulatan: $error';
  }

  @override
  String get notificationsOpening => 'Membuka';

  @override
  String get notificationsOpened => 'Dibuka';

  @override
  String notificationsActionMessage(Object action) {
    return 'Pemberitahuan $action';
  }

  @override
  String get settingsTitle => 'Tetapan';

  @override
  String get settingsSectionAccount => 'Akaun';

  @override
  String get settingsEditProfile => 'Edit Profil';

  @override
  String get settingsPrivacy => 'Privasi';

  @override
  String get settingsSecurity => 'Keselamatan';

  @override
  String get settingsSectionGameplay => 'Permainan';

  @override
  String get settingsShowTranslationLine => 'Tunjukkan Baris Terjemahan';

  @override
  String get settingsShowReadingLine =>
      'Tunjukkan Baris Bacaan (Pinyin/Romanji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Masa Per Soalan';

  @override
  String get settingsMatchDifficulty => 'Kesukaran Perlawanan';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptif';

  @override
  String get settingsSectionSoundFeel => 'Bunyi & Rasa';

  @override
  String get settingsMusic => 'Muzik';

  @override
  String get settingsSoundEffects => 'Kesan Bunyi';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsSectionNotifications => 'Pemberitahuan';

  @override
  String get settingsPushNotifications => 'Pemberitahuan Tolak';

  @override
  String get settingsDailyReminder => 'Peringatan Harian';

  @override
  String get settingsSectionAppearance => 'Penampilan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Bahasa UI';

  @override
  String get settingsSectionAbout => 'Mengenai';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsTermsPrivacy => 'Terma & Privasi';

  @override
  String get settingsSupport => 'Sokongan';

  @override
  String get settingsLogout => 'Log Keluar';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Cerah';

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
  String get editProfileUpdated => 'Profil Dikemas Kini';

  @override
  String get editProfileTitle => 'Edit Profil';

  @override
  String get editProfilePhotoLabel => 'Gambar Profil';

  @override
  String get editProfilePhotoSubtitle =>
      'Pemilih Avatar Supabase Storage akan datang tidak lama lagi';

  @override
  String get editProfileChangePhoto => 'Tukar';

  @override
  String get editProfileAvatarUploadSoon => 'Muat Naik Avatar Akan Datang';

  @override
  String get editProfileDisplayNameLabel => 'Nama Paparan';

  @override
  String get editProfileDisplayNameHint => 'Nama anda';

  @override
  String get editProfileDisplayNameRequired => 'Sila masukkan nama anda';

  @override
  String get editProfileDisplayNameTooShort => 'Terlalu pendek';

  @override
  String get editProfileUsernameLabel => 'Nama Pengguna';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'Sila masukkan nama pengguna';

  @override
  String get editProfileUsernameTooShort => 'Sekurang-kurangnya 3 perkataan';

  @override
  String get editProfileUsernameInvalid => 'Huruf, angka, _ sahaja';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Penerangan ringkas tentang anda...';

  @override
  String get editProfileBioTooLong => 'Maksimum 120 aksara';

  @override
  String get editProfileLocationLabel => 'Lokasi';

  @override
  String get editProfileLocationHint => 'Bandar / Negara';

  @override
  String get editProfileDailyGoalTitle => 'Matlamat Harian';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Pilih berapa minit anda ingin belajar setiap hari';

  @override
  String get securityTitle => 'Keselamatan';

  @override
  String get securitySectionPassword => 'Kata Laluan';

  @override
  String get securityChangePasswordTitle => 'Tukar Kata Laluan';

  @override
  String get securityChangePasswordSubtitle =>
      'Kemas kini kata laluan anda secara berkala';

  @override
  String get securitySectionTwoFactor => 'Pengesahan Dua Faktor';

  @override
  String get securityEnable2faTitle => 'Dayakan 2FA';

  @override
  String get securityEnable2faSubtitle =>
      'Keselamatan tambahan untuk log masuk';

  @override
  String get securitySectionAppLock => 'Kunci Apl';

  @override
  String get securityBiometricTitle => 'Buka Kunci Biometrik';

  @override
  String get securityBiometricSubtitle =>
      'Gunakan FaceID/TouchID untuk membuka SOMA';

  @override
  String get securityAppLockTitle => 'Kunci Apl';

  @override
  String get securityAppLockSubtitle => 'Kunci SOMA apabila anda pergi';

  @override
  String get securitySectionSessions => 'Sesi Aktif';

  @override
  String get securityNoSessions => 'Tiada sesi aktif';

  @override
  String get securityThisDevice => 'Peranti Ini';

  @override
  String get securityDevice => 'Peranti';

  @override
  String get securityActiveLabel => 'Aktif';

  @override
  String get securitySignInToEnable2fa => 'Log masuk untuk mendayakan 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Gagal mendayakan 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Gagal melumpuhkan 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Persiapan 2FA';

  @override
  String get securitySecretKeyLabel => 'Kunci Rahsia';

  @override
  String get securityCodeHint => 'Kod 6 digit';

  @override
  String get security2faEnabled => '2FA Didayakan';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Gagal mengesahkan kod: $error';
  }

  @override
  String get securityVerifying => 'Mengesahkan...';

  @override
  String get securityVerify => 'Sahkan';

  @override
  String get securityCurrentPasswordHint => 'Kata Laluan Semasa';

  @override
  String get securityNewPasswordHint => 'Kata Laluan Baru (min 8 aksara)';

  @override
  String get securityConfirmPasswordHint => 'Sahkan kata laluan baru';

  @override
  String get securitySignInToChangePassword =>
      'Log masuk untuk menukar kata laluan';

  @override
  String get securityEnterCurrentPassword => 'Masukkan kata laluan semasa anda';

  @override
  String get securityPasswordMinLength =>
      'Kata laluan baru mesti sekurang-kurangnya 8 aksara';

  @override
  String get securityPasswordsDoNotMatch => 'Kata laluan tidak sepadan';

  @override
  String get securityPasswordUpdated => 'Kata laluan dikemas kini';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Gagal mengemas kini kata laluan: $error';
  }

  @override
  String get securityAutoLockAfter => 'Auto-kunci Selepas';

  @override
  String get privacyTitle => 'Privasi';

  @override
  String get privacySectionVisibility => 'Keterlihatan';

  @override
  String get privacyProfileVisibilityTitle => 'Keterlihatan Profil';

  @override
  String get privacyVisibilityPublic => 'Awam';

  @override
  String get privacyVisibilityFriends => 'Rakan';

  @override
  String get privacyVisibilityPrivate => 'Peribadi';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Sesiapa sahaja boleh melihat profil anda';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Hanya rakan boleh melihat profil anda';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Hanya anda boleh melihat profil anda';

  @override
  String get privacySectionActivity => 'Aktiviti';

  @override
  String get privacyShowOnlineTitle => 'Tunjukkan Status Dalam Talian';

  @override
  String get privacyShowOnlineSubtitle =>
      'Benarkan pemain melihat apabila anda dalam talian';

  @override
  String get privacyShowActivityTitle => 'Tunjukkan Aktiviti Pembelajaran';

  @override
  String get privacyShowActivitySubtitle =>
      'Tunjukkan rentetan, XP, dan kemajuan terkini';

  @override
  String get privacySectionSocial => 'Sosial';

  @override
  String get privacyAllowRequestsTitle => 'Benarkan Permintaan Rakan';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Benarkan orang menghantar permintaan rakan';

  @override
  String get privacyWhoCanDmTitle => 'Siapa Boleh DM';

  @override
  String get privacyDmEveryone => 'Sesiapa Sahaja';

  @override
  String get privacyDmFriends => 'Rakan';

  @override
  String get privacyDmNoOne => 'Tiada Siapa';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Sesiapa sahaja boleh menghantar mesej kepada anda';

  @override
  String get privacyDmFriendsSubtitle =>
      'Hanya rakan boleh menghantar mesej kepada anda';

  @override
  String get privacyDmNoOneSubtitle =>
      'Tiada siapa boleh menghantar mesej kepada anda';

  @override
  String get privacySectionBlockedUsers => 'Pengguna Disekat';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Pengurusan pengguna disekat akan datang tidak lama lagi';

  @override
  String get privacySectionDataControls => 'Kawalan Data';

  @override
  String get privacyExportDataTitle => 'Eksport Data Saya';

  @override
  String get privacyExportDataSubtitle => 'Muat turun aktiviti dan kursus anda';

  @override
  String get privacyExportInfoTitle => 'Eksport Data';

  @override
  String get privacyExportInfoBody =>
      'Lain-lain: Hasilkan eksport JSON/CSV dan e-mel atau muat turun terus';

  @override
  String get privacyDeleteAccountTitle => 'Padam Akaun';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Ini akan memadam akaun dan data anda secara kekal';

  @override
  String get privacyDeleteConfirmTitle => 'Padam Akaun?';

  @override
  String get privacyDeleteConfirmBody =>
      'Ini tidak boleh dibatalkan. Profil, kursus, rakan, dan mesej anda akan dipadamkan';

  @override
  String get privacyDeleteComingSoon =>
      'Pemadaman akan disepadukan dengan Supabase kemudian';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sesi Solo Selesai';

  @override
  String get soloResultsFeedbackElite =>
      'Prestasi cemerlang - kekalkan rentetan hidup';

  @override
  String get soloResultsFeedbackStrong =>
      'Kerja hebat - meningkat dengan pantas';

  @override
  String get soloResultsFeedbackProgress =>
      'Kemajuan yang baik - semak kesilapan dan cuba lagi';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Tiada tekanan - cuba lagi dengan soalan yang lebih sedikit dan fokus';

  @override
  String get soloResultsPerfectScore =>
      'Skor sempurna! Tiada kesilapan untuk disemak';

  @override
  String get soloResultsReviewPrompt =>
      'Semak kesilapan anda untuk belajar lebih cepat. Jawapan salah anda ada di bawah';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Semak Kesilapan ($count)';
  }

  @override
  String get authNotSignedIn => 'Belum Log Masuk';

  @override
  String get genericUser => 'Pengguna';

  @override
  String get loading => 'Memuatkan...';

  @override
  String get edit => 'Edit';

  @override
  String get send => 'Hantar';

  @override
  String get join => 'Sertai';

  @override
  String get leave => 'Tinggalkan';

  @override
  String get ready => 'Sedia';

  @override
  String get levelBeginner => 'Pemula';

  @override
  String get levelIntermediate => 'Pertengahan';

  @override
  String get levelAdvanced => 'Lanjutan';

  @override
  String questionsShort(Object count) {
    return '$count Soalan';
  }

  @override
  String secondsShort(Object count) {
    return '$count Saat';
  }

  @override
  String get circlesAllCourses => 'Semua Kursus';

  @override
  String get circlesAllModes => 'Semua Mod';

  @override
  String get circlesAllLevels => 'Semua Tahap';

  @override
  String get circlesAddNewCourse => 'Tambah Kursus Baru';

  @override
  String get circlesCoursesTitle => 'Kursus';

  @override
  String get circlesModeTitle => 'Mod';

  @override
  String get circlesLevelTitle => 'Tahap';

  @override
  String get circlesNoActiveForFilters =>
      'Tiada Bulatan aktif untuk penapis ini';

  @override
  String get circlesUnknownRoom => 'Bilik Tidak Diketahui';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Cipta Bulatan';

  @override
  String get circlesCircleName => 'Nama Bulatan';

  @override
  String get circlesEnterName => 'Masukkan nama';

  @override
  String get circlesLanguages => 'Bahasa';

  @override
  String get circlesRoomSetup => 'Persiapan Bilik';

  @override
  String get circlesPlayers => 'Pemain';

  @override
  String get circlesEmptySlot => 'Slot Kosong';

  @override
  String get circlesPlayersRange => '1-5 Pemain';

  @override
  String get circlesQuestions => 'Soalan';

  @override
  String get circlesQuestionsSubtitle => 'Jumlah soalan';

  @override
  String get circlesTimePerQuestion => 'Masa setiap Soalan';

  @override
  String get circlesSecondsPerQuestion => 'Saat/Soalan';

  @override
  String get circlesAdvanced => 'Lanjutan';

  @override
  String get circlesAllowSpectators => 'Benarkan Penonton';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Benarkan orang lain menonton tanpa bermain';

  @override
  String get circlesLiveVoiceChat => 'Sembang Suara Langsung';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Dayakan interaksi suara semasa perlawanan';

  @override
  String get circlesLiveTextChat => 'Sembang Teks Langsung';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Dayakan penghantaran mesej semasa perlawanan';

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
  String get circlesCreatedSuccess => 'Bulatan dicipta';

  @override
  String circlesCreateError(Object error) {
    return 'Gagal mencipta Bulatan: $error';
  }

  @override
  String get circlesHostTip =>
      'Tip: Anda boleh menjemput rakan selepas mencipta';

  @override
  String circlesJoinError(Object error) {
    return 'Gagal menyertai Bulatan: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobi Bulatan';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kod: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Tetapan Perlawanan';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Tahap $level';
  }

  @override
  String get circlesDifficulty => 'Kesukaran';

  @override
  String get circlesPerQuestionShort => 'Setiap soalan';

  @override
  String get circlesInvite => 'Jemput';

  @override
  String get circlesCopyId => 'Salin ID';

  @override
  String get circlesCopiedId => 'ID disalin';

  @override
  String get circlesMatchInProgress => 'Perlawanan sedang berlangsung';

  @override
  String get circlesSpectatorQueuedBody =>
      'Perlawanan sedang berlangsung. Anda akan menyertai sebagai penonton';

  @override
  String get circlesHostStartWhenReady =>
      'Tuan rumah akan bermula apabila semua orang bersedia';

  @override
  String get circlesSpectators => 'Penonton';

  @override
  String get circlesSpectator => 'Penonton';

  @override
  String get circlesSpectatorCanWatch =>
      'Penonton boleh menonton secara langsung';

  @override
  String get circlesJoinRequests => 'Permintaan Menyertai';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Terima penonton sebelum memulakan perlawanan';

  @override
  String get circlesStartGame => 'Mula Permainan';

  @override
  String get circlesWaitingForPlayers => 'Menunggu pemain';

  @override
  String get circlesLeaveCircle => 'Tinggalkan Bulatan';

  @override
  String get circlesRequestSent => 'Permintaan dihantar';

  @override
  String get circlesRequestToJoin => 'Minta untuk Menyertai';

  @override
  String get circlesWatchLive => 'Tonton Langsung';

  @override
  String get circlesPlayerTip =>
      'Ketik \'Sedia\' apabila anda bersedia. Tuan rumah akan memulakan perlawanan';

  @override
  String get circlesSpectatorTip =>
      'Anda sedang menonton. Lihat aksi di waktu nyata apabila tuan rumah bermula';

  @override
  String get circlesHostControls => 'Kawalan Tuan Rumah';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Gagal memindahkan tuan rumah: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Gagal menamatkan Bulatan: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Pengguna @$username tidak ditemui';
  }

  @override
  String get circlesInvalidUser => 'Pengguna tidak sah';

  @override
  String get circlesCantInviteSelf => 'Anda tidak boleh menjemput diri sendiri';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username sudah berada dalam Bulatan';
  }

  @override
  String get circlesDefaultHost => 'Tuan Rumah';

  @override
  String get circlesDefaultTitle => 'Bulatan';

  @override
  String get circlesInviteByUsername => 'Melalui Nama Pengguna';

  @override
  String circlesInviteSent(Object username) {
    return 'Jemputan dihantar ke @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Gagal menghantar jemputan: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Permintaan menyertai dihantar';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Permintaan gagal: $error';
  }

  @override
  String get circlesFull => 'Bulatan penuh';

  @override
  String get circlesSpectatorAdded => 'Penonton ditambah';

  @override
  String circlesApproveFailed(Object error) {
    return 'Gagal meluluskan: $error';
  }

  @override
  String get circlesRequestDeclined => 'Permintaan ditolak';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Gagal menolak: $error';
  }

  @override
  String get circlesParticipant => 'Peserta';

  @override
  String get circlesLeavePromptTitle => 'Tinggalkan Bulatan?';

  @override
  String get circlesLeavePromptTransfer => 'Pindahkan tuan rumah sebelum pergi';

  @override
  String get circlesLeavePromptEndOnly => 'Tamatkan Bulatan dan pergi';

  @override
  String get circlesTransferHost => 'Pindahkan Tuan Rumah';

  @override
  String get circlesEndCircle => 'Tamatkan Bulatan';

  @override
  String get circlesTransferHostTitle => 'Pemindahan Tuan Rumah';

  @override
  String circlesShareId(Object id) {
    return 'ID Bulatan: $id';
  }
}
