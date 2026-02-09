// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'শিখুন। প্রতিযোগিতা করুন। আয়ত্ত করুন।';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'সাইন আপ';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get skipForNow => 'এখন এড়িয়ে যান';

  @override
  String get authFillAllFields => 'অনুগ্রহ করে সব ক্ষেত্র পূরণ করুন';

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
    return 'ত্রুটি: $error';
  }

  @override
  String get authEmail => 'ইমেল';

  @override
  String get authPassword => 'পাসওয়ার্ড';

  @override
  String get authUsername => 'ব্যবহারকারীর নাম';

  @override
  String get authContinue => 'এগিয়ে যান';

  @override
  String get authSigningIn => 'সাইন ইন করা হচ্ছে...';

  @override
  String get authCreateAccount => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get authCreating => 'তৈরি করা হচ্ছে...';

  @override
  String get authNeedAccount => 'অ্যাকাউন্ট নেই? ';

  @override
  String get authHaveAccount => 'ইতিমধ্যে অ্যাকাউন্ট আছে? ';

  @override
  String get dialogAuthRequiredTitle => 'Circles অ্যাক্সেস করতে সাইন ইন করুন';

  @override
  String get dialogAuthRequiredBody =>
      'Circles হল মাল্টিপ্লেয়ার রুম। লাইভ ম্যাচে যোগ দিতে, বন্ধুদের আমন্ত্রণ জানাতে এবং অগ্রগতি সংরক্ষণ করতে একটি অ্যাকাউন্ট তৈরি করুন।';

  @override
  String get notNow => 'এখন নয়';

  @override
  String get navHome => 'হোম';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get removeCourseTitle => 'কোর্স সরাবেন?';

  @override
  String removeCourseBody(Object course) {
    return '$course হোম তালিকা থেকে সরানো হবে।';
  }

  @override
  String get cancel => 'বাতিল';

  @override
  String get remove => 'সরান';

  @override
  String welcomeBack(Object name) {
    return 'স্বাগতম, $name!';
  }

  @override
  String get editCourses => 'কোর্স সম্পাদনা';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get noCoursesToEdit => 'সম্পাদনা করার জন্য কোন কোর্স নেই।';

  @override
  String get addCourse => 'কোর্স যোগ করুন';

  @override
  String get unknown => 'অজানা';

  @override
  String get iSpeak => 'আমি বলি';

  @override
  String get iWantToLearn => 'আমি শিখতে চাই';

  @override
  String get chooseYourLanguage => 'আপনার ভাষা চয়ন করুন';

  @override
  String get chooseLearningLanguage => 'আপনি যে ভাষা শিখতে চান তা চয়ন করুন';

  @override
  String get chooseTwoDifferentLanguages => 'দুটি ভিন্ন ভাষা চয়ন করুন।';

  @override
  String get createCourse => 'কোর্স তৈরি করুন';

  @override
  String get soloCourseTitle => 'একক কোর্স';

  @override
  String get searchLanguage => 'ভাষা অনুসন্ধান';

  @override
  String get noMatches => 'কোন মিল নেই';

  @override
  String get chooseCourseType => 'কোর্সের ধরন চয়ন করুন';

  @override
  String get soloStudyDescription =>
      'একাই অধ্যয়ন করুন Circles-স্টাইল কুইজ দিয়ে - তবে রুম বা চ্যাট বা দর্শক বা হোস্ট অপশন ছাড়া।';

  @override
  String get soloModeVocabulary => 'শব্দভান্ডার';

  @override
  String get soloModeSentences => 'বাক্য';

  @override
  String get soloModeReview => 'পর্যালোচনা';

  @override
  String get soloModeVocabularySubtitle =>
      'অর্থ, প্রতিশব্দ এবং ব্যবহারের জন্য একাধিক পছন্দ';

  @override
  String get soloModeSentencesSubtitle => 'শূন্যস্থান পূরণ + অনুবাদ + পড়া';

  @override
  String get soloModeReviewDescription =>
      'আপনি যা শিখেছেন তা অনুশীলন করুন: দুর্বল শব্দ, সাম্প্রতিক ভুল এবং স্পেসড পুনরাবৃত্তি।';

  @override
  String get startReview => 'পর্যালোচনা শুরু করুন';

  @override
  String soloSetupTitle(Object mode) {
    return '$mode সেটআপ';
  }

  @override
  String get difficulty => 'অসুবিধা';

  @override
  String get numberOfQuestions => 'প্রশ্নের সংখ্যা';

  @override
  String get timerPerQuestion => 'প্রতি প্রশ্নে টাইমার';

  @override
  String get noTimer => 'টাইমার নেই';

  @override
  String get start => 'শুরু করুন';

  @override
  String get profileTitle => 'প্রোফাইল';

  @override
  String get profileSignInToMessage => 'বার্তা পাঠাতে সাইন ইন করুন';

  @override
  String get profileThatsYourProfile => 'এটি আপনার প্রোফাইল';

  @override
  String get profileSignInToAddFriends => 'বন্ধু যোগ করতে সাইন ইন করুন';

  @override
  String get profileCantAddYourself => 'আপনি নিজেকে যোগ করতে পারবেন না';

  @override
  String profileRequestSent(Object username) {
    return '@$username-এ অনুরোধ পাঠানো হয়েছে';
  }

  @override
  String get profileRequestFailed => 'অনুরোধ পাঠাতে ব্যর্থ';

  @override
  String get profileDefaultDisplayName => 'নতুন ব্যবহারকারী';

  @override
  String get profileDefaultBio => 'শেখার জন্য প্রস্তুত!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'অতিথি';

  @override
  String get guestUsername => 'অতিথি';

  @override
  String get guestSessionLabel => 'অতিথি সেশন';

  @override
  String get unlockFullProfile => 'আপনার সম্পূর্ণ প্রোফাইল আনলক করুন';

  @override
  String get guestBenefitSync => 'সব ডিভাইসে অগ্রগতি সিঙ্ক করুন';

  @override
  String get guestBenefitCircles => 'Circles-এ যোগ দিন এবং লাইভ খেলুন';

  @override
  String get guestBenefitNotifications => 'বিজ্ঞপ্তি এবং বন্ধু অনুরোধ পান';

  @override
  String get progressStaysOnDevice =>
      'আপনি সাইন ইন না করা পর্যন্ত অগ্রগতি এই ডিভাইসে থাকে।';

  @override
  String profileGoalLabel(Object minutes) {
    return 'লক্ষ্য: $minutesমি';
  }

  @override
  String get profileXpProgress => 'XP অগ্রগতি';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'জয়';

  @override
  String get profileStreak => 'ধারা';

  @override
  String get profileFriendsTitle => 'আমার বন্ধুরা';

  @override
  String get profileViewAll => 'সব দেখুন';

  @override
  String get profileAchievementsTitle => 'অর্জন';

  @override
  String get profileNoAchievements => 'এখনও কোন অর্জন নেই।';

  @override
  String get profileRequested => 'অনুরোধ করা হয়েছে';

  @override
  String get profileSending => 'পাঠানো হচ্ছে...';

  @override
  String get profileAddFriend => 'বন্ধু যোগ করুন';

  @override
  String get profileConnectTitle => 'সংযোগ';

  @override
  String get profileMessage => 'বার্তা';

  @override
  String get profileSnapshot => 'প্রোফাইল স্ন্যাপশট';

  @override
  String get profileLocationHidden => 'অবস্থান লুকানো';

  @override
  String get profileBioHidden => 'জীবনী লুকানো';

  @override
  String profileDailyGoal(Object minutes) {
    return 'দৈনিক লক্ষ্য $minutesমি';
  }

  @override
  String get circleInviteTitle => 'Circle আমন্ত্রণ';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'যোগ দিতে সাইন ইন করুন';

  @override
  String get joiningCircle => 'যোগ দেওয়া হচ্ছে...';

  @override
  String get joinCircle => 'Circle-এ যোগ দিন';

  @override
  String get circleJoinedAsPlayer => 'খেলোয়াড় হিসাবে যোগ দিয়েছেন';

  @override
  String get circleJoinedAsSpectator => 'দর্শক হিসাবে যোগ দিয়েছেন';

  @override
  String get accept => 'গ্রহণ';

  @override
  String get decline => 'প্রত্যাখ্যান';

  @override
  String get open => 'খুলুন';

  @override
  String get circleCountdownTitle => 'প্রস্তুত হন';

  @override
  String get circleCountdownSubtitle => 'Circle শুরু হচ্ছে...';

  @override
  String get userFallbackName => 'ব্যবহারকারী';

  @override
  String get micOff => 'মাইক বন্ধ';

  @override
  String get micOn => 'মাইক চালু';

  @override
  String get roleHost => 'হোস্ট';

  @override
  String get roleSpectator => 'দর্শক';

  @override
  String get tagHost => 'হোস্ট';

  @override
  String get tagYou => 'আপনি';

  @override
  String get statusCorrect => 'সঠিক';

  @override
  String get statusWrong => 'ভুল';

  @override
  String get statusWaiting => 'অপেক্ষা করছে';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'পয়েন্ট';

  @override
  String get pointsLabel => 'পয়েন্ট';

  @override
  String get statCorrect => 'সঠিক';

  @override
  String get statAnswers => 'উত্তর';

  @override
  String get statTotal => 'মোট';

  @override
  String get statQuestions => 'প্রশ্ন';

  @override
  String get statAccuracy => 'নির্ভুলতা';

  @override
  String get statRate => 'হার';

  @override
  String get statRank => 'র‌্যাঙ্ক';

  @override
  String get statPosition => 'অবস্থান';

  @override
  String get statMode => 'মোড';

  @override
  String get statType => 'ধরন';

  @override
  String get next => 'পরবর্তী';

  @override
  String get submit => 'জমা দিন';

  @override
  String get continueLabel => 'এগিয়ে যান';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get playAgain => 'আবার খেলুন';

  @override
  String get backToCourse => 'কোর্সে ফিরে যান';

  @override
  String get resultsTitle => 'ফলাফল';

  @override
  String get shareLater => 'পরে শেয়ার করুন';

  @override
  String get delete => 'মুছুন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String minutesShort(Object minutes) {
    return '$minutesমি';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$countমি';
  }

  @override
  String timeShortHours(Object count) {
    return '$countঘ';
  }

  @override
  String timeShortDays(Object count) {
    return '$countদি';
  }

  @override
  String get timeJustNow => 'এখনই';

  @override
  String timeMinutesAgo(Object count) {
    return '$countমি আগে';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$countঘ আগে';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$countদি আগে';
  }

  @override
  String get liveQuizWaitingForHost => 'হোস্টের জন্য অপেক্ষা করছে...';

  @override
  String get liveQuizJoinRequestSent => 'যোগদান অনুরোধ পাঠানো হয়েছে';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'অনুরোধ ব্যর্থ: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'হোস্ট নিয়ন্ত্রণ';

  @override
  String get liveQuizSpectatorModeTitle => 'দর্শক মোড';

  @override
  String get liveQuizHostControlsSubtitle =>
      'সবাই উত্তর দিলে বা সময় শেষ হলে রাউন্ড স্বয়ংক্রিয়ভাবে এগিয়ে যায়।';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'প্রশ্ন এবং লিডারবোর্ড লাইভ দেখুন। আপনি উত্তর দিতে পারবেন না।';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'প্রশ্ন $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get liveQuizRequestToJoin => 'যোগদানের অনুরোধ';

  @override
  String get liveQuizSpectatorFooter =>
      'আপনি লাইভ দেখছেন। প্রশ্ন এবং লিডারবোর্ড উপভোগ করুন।';

  @override
  String get circleNotFound => 'Circle পাওয়া যায়নি';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'রিম্যাচ শুরু করতে ব্যর্থ: $error';
  }

  @override
  String get resultsMatchTitle => 'ম্যাচের ফলাফল';

  @override
  String resultsNiceWork(Object name) {
    return 'চমৎকার কাজ, $name';
  }

  @override
  String get resultsPlaceFirst => '১ম স্থান';

  @override
  String get resultsPlaceSecond => '২য় স্থান';

  @override
  String get resultsPlaceThird => '৩য় স্থান';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankতম স্থান';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players জন খেলোয়াড়ের মধ্যে';
  }

  @override
  String get resultsHighlightChampion =>
      'চ্যাম্পিয়ন! আপনি এই Circle-এ প্রাধান্য বিস্তার করেছেন।';

  @override
  String get resultsHighlightGreatAccuracy =>
      'দুর্দান্ত নির্ভুলতা। আপনি শীর্ষের কাছাকাছি!';

  @override
  String get resultsHighlightKeepGoing =>
      'চালিয়ে যান - সামঞ্জস্য গতিকে পরাজিত করে।';

  @override
  String get resultsLeaderboardTitle => 'লিডারবোর্ড';

  @override
  String resultsPlayersCount(Object count) {
    return '$count জন খেলোয়াড়';
  }

  @override
  String get resultsBackToCircles => 'Circles-এ ফিরে যান';

  @override
  String get resultsRematch => 'রিম্যাচ';

  @override
  String get resultsPlayAgain => 'আবার খেলুন';

  @override
  String get leaderboardGlobalTitle => 'বৈশ্বিক লিডারবোর্ড';

  @override
  String get leaderboardEmpty => 'এখনও কোন লিডারবোর্ড নেই।';

  @override
  String get aboutTitle => 'সম্পর্কে';

  @override
  String aboutVersion(Object version) {
    return 'সংস্করণ $version';
  }

  @override
  String get aboutDescription =>
      'SOMA হল একটি গ্যামিফাইড ভাষা শিক্ষার প্ল্যাটফর্ম যা নতুন ভাষা আয়ত্ত করাকে মজাদার এবং সামাজিক করে তোলে। Circles-এ যোগ দিন, একাই অনুশীলন করুন এবং আপনার অগ্রগতি ট্র্যাক করুন।';

  @override
  String get aboutTerms => 'পরিষেবার শর্তাবলী';

  @override
  String get aboutPrivacy => 'গোপনীয়তা নীতি';

  @override
  String get aboutOpenSource => 'ওপেন সোর্স লাইসেন্স';

  @override
  String get addFriendTitle => 'বন্ধু যোগ করুন';

  @override
  String get addFriendFindByUsername => 'ব্যবহারকারীর নাম দ্বারা খুঁজুন';

  @override
  String get addFriendUsernameHint => 'ব্যবহারকারীর নাম লিখুন...';

  @override
  String get addFriendTip =>
      'টিপ: পরে আমরা QR কোড + বন্ধু আইডি সমর্থন করতে পারি।';

  @override
  String get addFriendSending => 'পাঠানো হচ্ছে...';

  @override
  String get addFriendSendRequest => 'অনুরোধ পাঠান';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username পাওয়া যায়নি';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'কাজ ব্যর্থ বা ইতিমধ্যে পাঠানো হয়েছে: $error';
  }

  @override
  String get friendsTitle => 'বন্ধুরা';

  @override
  String get searchFriendsHint => 'বন্ধুদের অনুসন্ধান করুন...';

  @override
  String get somaLearnerSubtitle => 'Soma শিক্ষার্থী';

  @override
  String get friendRequestLabel => 'অনুরোধ';

  @override
  String get friendRequestSentLabel => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get friendIncomingRequestLabel => 'আগত অনুরোধ';

  @override
  String get friendRequestsSection => 'অনুরোধ';

  @override
  String get friendPendingSection => 'মুলতুবি';

  @override
  String get friendAllSection => 'সব বন্ধু';

  @override
  String get friendsEmptyState =>
      'এখনও কোন বন্ধু নেই। আপনার প্রথম বন্ধু যোগ করুন!';

  @override
  String get friendsEmptyShort => 'এখনও কোন বন্ধু নেই।';

  @override
  String noMatchForQuery(Object query) {
    return '\"$query\" এর জন্য কোন মিল নেই';
  }

  @override
  String get inboxTitle => 'ইনবক্স';

  @override
  String get searchChatsHint => 'চ্যাট অনুসন্ধান করুন...';

  @override
  String get inboxEmptyState =>
      'এখনও কোন চ্যাট নেই। একজন বন্ধুর সাথে চ্যাট শুরু করুন!';

  @override
  String get newMessageTitle => 'নতুন বার্তা';

  @override
  String get chatCallLater => 'পরে ভয়েস কল (Circle ভাষা শীঘ্রই আসছে)';

  @override
  String errorWithDetails(Object error) {
    return 'ত্রুটি: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name-কে হাই বলুন!';
  }

  @override
  String get chatMessageHint => 'বার্তা...';

  @override
  String get notificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get notificationsTabAll => 'সব';

  @override
  String get notificationsTabCourses => 'কোর্স';

  @override
  String get notificationsTabSocial => 'সামাজিক';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'সিস্টেম';

  @override
  String get notificationsEmpty => 'এখানে কোন বিজ্ঞপ্তি নেই।';

  @override
  String get notificationsDeleted => 'বিজ্ঞপ্তি মুছে ফেলা হয়েছে';

  @override
  String get notificationTitleFallback => 'বিজ্ঞপ্তি';

  @override
  String get notificationTypeCourse => 'কোর্স';

  @override
  String get notificationTypeSocial => 'সামাজিক';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'সিস্টেম';

  @override
  String get notificationsFriendAccepted => 'বন্ধু অনুরোধ গৃহীত হয়েছে';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'বন্ধু অনুরোধ গ্রহণ করতে ব্যর্থ: $error';
  }

  @override
  String get notificationsFriendDeclined =>
      'বন্ধু অনুরোধ প্রত্যাখ্যান করা হয়েছে';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'বন্ধু অনুরোধ প্রত্যাখ্যান করতে ব্যর্থ: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle-এ যোগ দিতে ব্যর্থ: $error';
  }

  @override
  String get notificationsOpening => 'খোলা হচ্ছে';

  @override
  String get notificationsOpened => 'খোলা হয়েছে';

  @override
  String notificationsActionMessage(Object action) {
    return '$action বিজ্ঞপ্তি';
  }

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsSectionAccount => 'অ্যাকাউন্ট';

  @override
  String get settingsEditProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get settingsPrivacy => 'গোপনীয়তা';

  @override
  String get settingsSecurity => 'নিরাপত্তা';

  @override
  String get settingsSectionGameplay => 'গেমপ্লে';

  @override
  String get settingsShowTranslationLine => 'অনুবাদ লাইন দেখান';

  @override
  String get settingsShowReadingLine => 'পড়া দেখান (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'প্রতি প্রশ্নে ডিফল্ট টাইমার';

  @override
  String get settingsMatchDifficulty => 'ম্যাচ অসুবিধা';

  @override
  String get settingsMatchDifficultyAdaptive => 'অভিযোজিত';

  @override
  String get settingsSectionSoundFeel => 'শব্দ এবং অনুভূতি';

  @override
  String get settingsMusic => 'সঙ্গীত';

  @override
  String get settingsSoundEffects => 'শব্দ প্রভাব';

  @override
  String get settingsHaptics => 'হ্যাপটিক্স';

  @override
  String get settingsSectionNotifications => 'বিজ্ঞপ্তি';

  @override
  String get settingsPushNotifications => 'পুশ বিজ্ঞপ্তি';

  @override
  String get settingsDailyReminder => 'দৈনিক অনুস্মারক';

  @override
  String get settingsSectionAppearance => 'চেহারা';

  @override
  String get settingsTheme => 'থিম';

  @override
  String get settingsUiLanguage => 'UI ভাষা';

  @override
  String get settingsSectionAbout => 'সম্পর্কে';

  @override
  String get settingsVersion => 'সংস্করণ';

  @override
  String get settingsTermsPrivacy => 'শর্তাবলী এবং গোপনীয়তা';

  @override
  String get settingsSupport => 'সহায়তা';

  @override
  String get settingsLogout => 'লগ আউট';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeDark => 'অন্ধকার';

  @override
  String get themeLight => 'আলো';

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
  String get editProfileUpdated => 'প্রোফাইল আপডেট হয়েছে';

  @override
  String get editProfileTitle => 'প্রোফাইল সম্পাদনা';

  @override
  String get editProfilePhotoLabel => 'প্রোফাইল ছবি';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase স্টোরেজের মাধ্যমে অবতার নির্বাচন শীঘ্রই আসছে।';

  @override
  String get editProfileChangePhoto => 'পরিবর্তন';

  @override
  String get editProfileAvatarUploadSoon => 'অবতার আপলোড শীঘ্রই আসছে';

  @override
  String get editProfileDisplayNameLabel => 'প্রদর্শন নাম';

  @override
  String get editProfileDisplayNameHint => 'আপনার নাম';

  @override
  String get editProfileDisplayNameRequired => 'আপনার নাম লিখুন';

  @override
  String get editProfileDisplayNameTooShort => 'খুব ছোট';

  @override
  String get editProfileUsernameLabel => 'ব্যবহারকারীর নাম';

  @override
  String get editProfileUsernameHint => 'rahman_learner';

  @override
  String get editProfileUsernameRequired => 'ব্যবহারকারীর নাম লিখুন';

  @override
  String get editProfileUsernameTooShort => 'কমপক্ষে ৩টি অক্ষর';

  @override
  String get editProfileUsernameInvalid => 'শুধুমাত্র অক্ষর, সংখ্যা এবং _';

  @override
  String get editProfileBioLabel => 'জীবনী';

  @override
  String get editProfileBioHint => 'একটি সংক্ষিপ্ত জীবনী...';

  @override
  String get editProfileBioTooLong => 'সর্বোচ্চ ১২০ অক্ষর';

  @override
  String get editProfileLocationLabel => 'অবস্থান';

  @override
  String get editProfileLocationHint => 'শহর / দেশ';

  @override
  String get editProfileDailyGoalTitle => 'দৈনিক লক্ষ্য';

  @override
  String get editProfileDailyGoalSubtitle =>
      'আপনি প্রতিদিন কত মিনিট অধ্যয়ন করতে চান তা চয়ন করুন।';

  @override
  String get securityTitle => 'নিরাপত্তা';

  @override
  String get securitySectionPassword => 'পাসওয়ার্ড';

  @override
  String get securityChangePasswordTitle => 'পাসওয়ার্ড পরিবর্তন করুন';

  @override
  String get securityChangePasswordSubtitle => 'নিয়মিত পাসওয়ার্ড আপডেট করুন।';

  @override
  String get securitySectionTwoFactor => 'টু-ফ্যাক্টর প্রমাণীকরণ';

  @override
  String get securityEnable2faTitle => '2FA সক্রিয় করুন';

  @override
  String get securityEnable2faSubtitle => 'সাইন ইন করার সময় অতিরিক্ত সুরক্ষা।';

  @override
  String get securitySectionAppLock => 'অ্যাপ লক';

  @override
  String get securityBiometricTitle => 'বায়োমেট্রিক আনলক';

  @override
  String get securityBiometricSubtitle =>
      'SOMA আনলক করতে FaceID/TouchID ব্যবহার করুন।';

  @override
  String get securityAppLockTitle => 'অ্যাপ লক';

  @override
  String get securityAppLockSubtitle =>
      'অ্যাপ থেকে প্রস্থান করলে SOMA লক করুন।';

  @override
  String get securitySectionSessions => 'সক্রিয় সেশন';

  @override
  String get securityNoSessions => 'কোন সক্রিয় সেশন পাওয়া যায়নি।';

  @override
  String get securityThisDevice => 'এই ডিভাইস';

  @override
  String get securityDevice => 'ডিভাইস';

  @override
  String get securityActiveLabel => 'সক্রিয়';

  @override
  String get securitySignInToEnable2fa => '2FA সক্রিয় করতে সাইন ইন করুন';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA সক্রিয় করতে ব্যর্থ: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA নিষ্ক্রিয় করতে ব্যর্থ: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA সেটআপ';

  @override
  String get securitySecretKeyLabel => 'গোপন কী';

  @override
  String get securityCodeHint => '৬-সংখ্যার কোড';

  @override
  String get security2faEnabled => '2FA সক্রিয় করা হয়েছে';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'কোড যাচাই করতে ব্যর্থ: $error';
  }

  @override
  String get securityVerifying => 'যাচাই করা হচ্ছে...';

  @override
  String get securityVerify => 'যাচাই করুন';

  @override
  String get securityCurrentPasswordHint => 'বর্তমান পাসওয়ার্ড';

  @override
  String get securityNewPasswordHint => 'নতুন পাসওয়ার্ড (কমপক্ষে ৮ অক্ষর)';

  @override
  String get securityConfirmPasswordHint => 'নতুন পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get securitySignInToChangePassword =>
      'পাসওয়ার্ড পরিবর্তন করতে সাইন ইন করুন';

  @override
  String get securityEnterCurrentPassword => 'বর্তমান পাসওয়ার্ড লিখুন';

  @override
  String get securityPasswordMinLength =>
      'নতুন পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';

  @override
  String get securityPasswordsDoNotMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get securityPasswordUpdated => 'পাসওয়ার্ড আপডেট হয়েছে';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'পাসওয়ার্ড আপডেট করতে ব্যর্থ: $error';
  }

  @override
  String get securityAutoLockAfter => 'স্বয়ংক্রিয় লক হওয়ার পরে';

  @override
  String get privacyTitle => 'গোপনীয়তা';

  @override
  String get privacySectionVisibility => 'দৃশ্যমানতা';

  @override
  String get privacyProfileVisibilityTitle => 'প্রোফাইল দৃশ্যমানতা';

  @override
  String get privacyVisibilityPublic => 'সর্বজনীন';

  @override
  String get privacyVisibilityFriends => 'বন্ধুরা';

  @override
  String get privacyVisibilityPrivate => 'ব্যক্তিগত';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'যে কেউ আপনার প্রোফাইল দেখতে পারে।';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'শুধুমাত্র বন্ধুরা আপনার প্রোফাইল দেখতে পারে।';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'শুধুমাত্র আপনি আপনার প্রোফাইল দেখতে পারেন।';

  @override
  String get privacySectionActivity => 'কার্যকলাপ';

  @override
  String get privacyShowOnlineTitle => 'অনলাইন স্ট্যাটাস দেখান';

  @override
  String get privacyShowOnlineSubtitle =>
      'অন্যদের দেখতে দিন কখন আপনি অনলাইন আছেন।';

  @override
  String get privacyShowActivityTitle => 'শেখার কার্যকলাপ দেখান';

  @override
  String get privacyShowActivitySubtitle =>
      'ধারা, XP এবং বর্তমান অগ্রগতি প্রদর্শন করুন।';

  @override
  String get privacySectionSocial => 'সামাজিক';

  @override
  String get privacyAllowRequestsTitle => 'বন্ধু অনুরোধের অনুমতি দিন';

  @override
  String get privacyAllowRequestsSubtitle => 'লোকেদের বন্ধু অনুরোধ পাঠাতে দিন।';

  @override
  String get privacyWhoCanDmTitle => 'কে DM করতে পারে';

  @override
  String get privacyDmEveryone => 'সবাই';

  @override
  String get privacyDmFriends => 'বন্ধুরা';

  @override
  String get privacyDmNoOne => 'কেউ না';

  @override
  String get privacyDmEveryoneSubtitle => 'যে কেউ আপনাকে DM করতে পারে।';

  @override
  String get privacyDmFriendsSubtitle =>
      'শুধুমাত্র বন্ধুরা আপনাকে DM করতে পারে।';

  @override
  String get privacyDmNoOneSubtitle => 'কেউ আপনাকে DM করতে পারে না।';

  @override
  String get privacySectionBlockedUsers => 'ব্লক করা ব্যবহারকারী';

  @override
  String get privacyBlockedUsersComingSoon =>
      'ব্লক করা ব্যবহারকারীদের পরিচালনা শীঘ্রই আসছে।';

  @override
  String get privacySectionDataControls => 'ডেটা নিয়ন্ত্রণ';

  @override
  String get privacyExportDataTitle => 'আমার ডেটা রপ্তানি করুন';

  @override
  String get privacyExportDataSubtitle =>
      'আপনার কার্যকলাপ এবং কোর্স ডাউনলোড করুন।';

  @override
  String get privacyExportInfoTitle => 'ডেটা রপ্তানি';

  @override
  String get privacyExportInfoBody =>
      'পরবর্তী পদক্ষেপ: JSON/CSV রপ্তানি তৈরি করুন এবং ইমেলের মাধ্যমে পাঠান বা স্থানীয়ভাবে ডাউনলোড করুন।';

  @override
  String get privacyDeleteAccountTitle => 'অ্যাকাউন্ট মুছুন';

  @override
  String get privacyDeleteAccountSubtitle =>
      'এটি আপনার অ্যাকাউন্ট এবং ডেটা স্থায়ীভাবে সরিয়ে দেবে।';

  @override
  String get privacyDeleteConfirmTitle => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get privacyDeleteConfirmBody =>
      'এই ক্রিয়া স্থায়ী। আপনার প্রোফাইল, কোর্স, বন্ধু এবং বার্তা সরানো হবে।';

  @override
  String get privacyDeleteComingSoon => 'পরে Supabase-এ মুছে ফেলা তারযুক্ত হবে';

  @override
  String get soloLabel => 'একক';

  @override
  String get soloResultsCompletedTitle => 'একক সেশন সম্পন্ন';

  @override
  String get soloResultsFeedbackElite => 'এলিট পারফরম্যান্স। ধারা চালান।';

  @override
  String get soloResultsFeedbackStrong =>
      'শক্তিশালী কাজ। আপনি দ্রুত উন্নতি করছেন।';

  @override
  String get soloResultsFeedbackProgress =>
      'ভালো অগ্রগতি। ভুল পর্যালোচনা করুন এবং পুনরাবৃত্তি করুন।';

  @override
  String get soloResultsFeedbackTryAgain =>
      'চাপ নেই। কম প্রশ্ন এবং ফোকাস দিয়ে আবার চেষ্টা করুন।';

  @override
  String get soloResultsPerfectScore =>
      'নিখুঁত স্কোর! পর্যালোচনা করার জন্য কোন ভুল নেই।';

  @override
  String get soloResultsReviewPrompt =>
      'দ্রুত শেখার জন্য ভুল পর্যালোচনা করুন। আমরা নীচে ভুল উত্তর দেখাব।';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'ভুল পর্যালোচনা ($count)';
  }

  @override
  String get authNotSignedIn => 'সাইন ইন করেননি';

  @override
  String get genericUser => 'ব্যবহারকারী';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get send => 'পাঠান';

  @override
  String get join => 'যোগ দিন';

  @override
  String get leave => 'ছেড়ে যান';

  @override
  String get ready => 'প্রস্তুত';

  @override
  String get levelBeginner => 'শিক্ষানবিস';

  @override
  String get levelIntermediate => 'মধ্যবর্তী';

  @override
  String get levelAdvanced => 'উন্নত';

  @override
  String questionsShort(Object count) {
    return '$count প্র';
  }

  @override
  String secondsShort(Object count) {
    return '$countসে';
  }

  @override
  String get circlesAllCourses => 'সব কোর্স';

  @override
  String get circlesAllModes => 'সব মোড';

  @override
  String get circlesAllLevels => 'সব স্তর';

  @override
  String get circlesAddNewCourse => 'নতুন কোর্স যোগ করুন';

  @override
  String get circlesCoursesTitle => 'কোর্স';

  @override
  String get circlesModeTitle => 'মোড';

  @override
  String get circlesLevelTitle => 'স্তর';

  @override
  String get circlesNoActiveForFilters =>
      'এই ফিল্টারের জন্য কোন সক্রিয় Circles নেই।';

  @override
  String get circlesUnknownRoom => 'অজানা রুম';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle তৈরি করুন';

  @override
  String get circlesCircleName => 'Circle নাম';

  @override
  String get circlesEnterName => 'নাম লিখুন';

  @override
  String get circlesLanguages => 'ভাষা';

  @override
  String get circlesRoomSetup => 'রুম সেটআপ';

  @override
  String get circlesPlayers => 'খেলোয়াড়';

  @override
  String get circlesEmptySlot => 'খালি স্লট';

  @override
  String get circlesPlayersRange => '১-৫ খেলোয়াড়';

  @override
  String get circlesQuestions => 'প্রশ্ন';

  @override
  String get circlesQuestionsSubtitle => 'প্রশ্নের সংখ্যা';

  @override
  String get circlesTimePerQuestion => 'প্রতি প্রশ্নে সময়';

  @override
  String get circlesSecondsPerQuestion => 'প্রতি প্রশ্নে সেকেন্ড';

  @override
  String get circlesAdvanced => 'উন্নত';

  @override
  String get circlesAllowSpectators => 'দর্শকদের অনুমতি দিন';

  @override
  String get circlesAllowSpectatorsSubtitle => 'অন্যদের খেলা ছাড়াই দেখতে দিন।';

  @override
  String get circlesLiveVoiceChat => 'লাইভ ভয়েস চ্যাট';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'ম্যাচের সময় লাইভ অডিও সক্রিয় করুন।';

  @override
  String get circlesLiveTextChat => 'লাইভ টেক্সট চ্যাট';

  @override
  String get circlesLiveTextChatSubtitle => 'ম্যাচের সময় চ্যাট সক্রিয় করুন।';

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
  String get circlesCreatedSuccess => 'Circle তৈরি হয়েছে';

  @override
  String circlesCreateError(Object error) {
    return 'Circle তৈরি করতে ব্যর্থ: $error';
  }

  @override
  String get circlesHostTip =>
      'টিপ: তৈরি করার পরে আপনি বন্ধুদের আমন্ত্রণ জানাতে পারেন।';

  @override
  String circlesJoinError(Object error) {
    return 'Circle-এ যোগ দিতে ব্যর্থ: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle লবি';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'কোড: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'ম্যাচ সেটিংস';

  @override
  String circlesLevelWithValue(Object level) {
    return 'স্তর $level';
  }

  @override
  String get circlesDifficulty => 'অসুবিধা';

  @override
  String get circlesPerQuestionShort => 'প্রতি প্রশ্ন';

  @override
  String get circlesInvite => 'আমন্ত্রণ';

  @override
  String get circlesCopyId => 'ID কপি করুন';

  @override
  String get circlesCopiedId => 'ID কপি হয়েছে';

  @override
  String get circlesMatchInProgress => 'ম্যাচ চলছে';

  @override
  String get circlesSpectatorQueuedBody =>
      'ম্যাচ চলছে। আপনি দর্শক হিসাবে যোগ দেবেন।';

  @override
  String get circlesHostStartWhenReady => 'সবাই প্রস্তুত হলে হোস্ট শুরু করবে।';

  @override
  String get circlesSpectators => 'দর্শক';

  @override
  String get circlesSpectator => 'দর্শক';

  @override
  String get circlesSpectatorCanWatch => 'দর্শকরা লাইভ দেখতে পারেন।';

  @override
  String get circlesJoinRequests => 'যোগদান অনুরোধ';

  @override
  String get circlesAcceptSpectatorsHint =>
      'ম্যাচ শুরু করার আগে দর্শকদের গ্রহণ করুন।';

  @override
  String get circlesStartGame => 'গেম শুরু করুন';

  @override
  String get circlesWaitingForPlayers => 'খেলোয়াড়দের জন্য অপেক্ষা করছে';

  @override
  String get circlesLeaveCircle => 'Circle ছেড়ে যান';

  @override
  String get circlesRequestSent => 'অনুরোধ পাঠানো হয়েছে';

  @override
  String get circlesRequestToJoin => 'যোগদানের অনুরোধ';

  @override
  String get circlesWatchLive => 'লাইভ দেখুন';

  @override
  String get circlesPlayerTip =>
      'আপনি প্রস্তুত হলে প্রস্তুত আলতো চাপ দিন। হোস্ট ম্যাচ শুরু করবে।';

  @override
  String get circlesSpectatorTip => 'আপনি দেখছেন। হোস্ট শুরু করলে লাইভ দেখুন।';

  @override
  String get circlesHostControls => 'হোস্ট নিয়ন্ত্রণ';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'হোস্ট স্থানান্তর করতে ব্যর্থ: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle শেষ করতে ব্যর্থ: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username পাওয়া যায়নি';
  }

  @override
  String get circlesInvalidUser => 'অবৈধ ব্যবহারকারী';

  @override
  String get circlesCantInviteSelf => 'আপনি নিজেকে আমন্ত্রণ জানাতে পারবেন না';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username ইতিমধ্যে Circle-এ আছেন';
  }

  @override
  String get circlesDefaultHost => 'হোস্ট';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'ব্যবহারকারীর নাম দ্বারা আমন্ত্রণ';

  @override
  String circlesInviteSent(Object username) {
    return '@$username-কে আমন্ত্রণ পাঠানো হয়েছে';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'আমন্ত্রণ পাঠাতে ব্যর্থ: $error';
  }

  @override
  String get circlesJoinRequestSent => 'যোগদান অনুরোধ পাঠানো হয়েছে';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'অনুরোধ ব্যর্থ: $error';
  }

  @override
  String get circlesFull => 'Circle পূর্ণ';

  @override
  String get circlesSpectatorAdded => 'দর্শক যোগ করা হয়েছে';

  @override
  String circlesApproveFailed(Object error) {
    return 'অনুরোধ অনুমোদন করতে ব্যর্থ: $error';
  }

  @override
  String get circlesRequestDeclined => 'অনুরোধ প্রত্যাখ্যান করা হয়েছে';

  @override
  String circlesDeclineFailed(Object error) {
    return 'অনুরোধ প্রত্যাখ্যান করতে ব্যর্থ: $error';
  }

  @override
  String get circlesParticipant => 'অংশগ্রহণকারী';

  @override
  String get circlesLeavePromptTitle => 'Circle ছেড়ে যাবেন?';

  @override
  String get circlesLeavePromptTransfer =>
      'ছেড়ে যাওয়ার আগে হোস্ট স্থানান্তর করুন।';

  @override
  String get circlesLeavePromptEndOnly => 'Circle শেষ করুন এবং ছেড়ে যান।';

  @override
  String get circlesTransferHost => 'হোস্ট স্থানান্তর';

  @override
  String get circlesEndCircle => 'Circle শেষ করুন';

  @override
  String get circlesTransferHostTitle => 'হোস্ট স্থানান্তর';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
