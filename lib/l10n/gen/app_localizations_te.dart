// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'నేర్చుకోండి. పోటీపడండి. నైపుణ్యం సాధించండి.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'సైన్ అప్';

  @override
  String get signIn => 'సైన్ ఇన్';

  @override
  String get skipForNow => 'ప్రస్తుతానికి వదిలేయండి';

  @override
  String get authFillAllFields => 'దయచేసి అన్ని వివరాలను పూరించండి';

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
    return 'లోపం: $error';
  }

  @override
  String get authEmail => 'ఇమెయిల్';

  @override
  String get authPassword => 'పాస్‌వర్డ్';

  @override
  String get authUsername => 'యూజర్ పేరు';

  @override
  String get authContinue => 'కొనసాగించండి';

  @override
  String get authSigningIn => 'సైన్ ఇన్ అవుతోంది...';

  @override
  String get authCreateAccount => 'ఖాతాను సృష్టించండి';

  @override
  String get authCreating => 'సృష్టిస్తోంది...';

  @override
  String get authNeedAccount => 'ఖాతా లేదా? ';

  @override
  String get authHaveAccount => 'ఇప్పటికే ఖాతా ఉందా? ';

  @override
  String get dialogAuthRequiredTitle => 'Circlesలో చేరడానికి సైన్ ఇన్ చేయండి';

  @override
  String get dialogAuthRequiredBody =>
      'Circles మల్టీప్లేయర్ గదులు. లైవ్ మ్యాచ్‌లలో చేరడానికి, స్నేహితులను ఆహ్వానించడానికి మరియు ప్రగతిని సేవ్ చేయడానికి ఖాతాను సృష్టించండి.';

  @override
  String get notNow => 'ఇప్పుడు కాదు';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navCircles => 'సర్కిల్స్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'కోర్సును తొలగించాలా?';

  @override
  String removeCourseBody(Object course) {
    return '$course మీ జాబితా నుండి తొలగించబడుతుంది';
  }

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get remove => 'తొలగించు';

  @override
  String welcomeBack(Object name) {
    return 'స్వాగతం, $name!';
  }

  @override
  String get editCourses => 'కోర్సులను సవరించండి';

  @override
  String get done => 'పూర్తయింది';

  @override
  String get noCoursesToEdit => 'సవరించడానికి కోర్సులు లేవు';

  @override
  String get addCourse => 'కోర్సును జోడించండి';

  @override
  String get unknown => 'తెలియదు';

  @override
  String get iSpeak => 'నేను మాట్లాడేది';

  @override
  String get iWantToLearn => 'నేను నేర్చుకోవాలనుకుంటున్నది';

  @override
  String get chooseYourLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get chooseLearningLanguage => 'నేర్చుకునే భాషను ఎంచుకోండి';

  @override
  String get chooseTwoDifferentLanguages =>
      'దయచేసి రెండు వేర్వేరు భాషలను ఎంచుకోండి';

  @override
  String get createCourse => 'కోర్సును సృష్టించండి';

  @override
  String get soloCourseTitle => 'సోలో కోర్సు';

  @override
  String get searchLanguage => 'భాషను శోధించండి';

  @override
  String get noMatches => 'ఫలితాలు లేవు';

  @override
  String get chooseCourseType => 'కోర్సు రకాన్ని ఎంచుకోండి';

  @override
  String get soloStudyDescription =>
      'సర్కిల్స్ క్విజ్‌ల లాగ, ఒంటరిగా ప్రాక్టీస్ చేయండి - కానీ గదులు, చాట్ లేదా హోస్ట్ లేకుండా';

  @override
  String get soloModeVocabulary => 'పదజాలం';

  @override
  String get soloModeSentences => 'వాక్యాలు';

  @override
  String get soloModeReview => 'సమీక్ష';

  @override
  String get soloModeVocabularySubtitle =>
      'మల్టిపుల్ ఛాయిస్, అర్థాలు, పర్యాయపదాలు, ఉపయోగం';

  @override
  String get soloModeSentencesSubtitle => 'ఖాళీలను పూరించండి + అనువాదం + పఠనం';

  @override
  String get soloModeReviewDescription =>
      'నేర్చుకున్నవాటిని ప్రాక్టీస్ చేయండి: బలహీనమైన పదాలు, ఇటీవల చేసిన తప్పులు';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'సమీక్షను ప్రారంభించండి';

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
    return '$mode సెటప్';
  }

  @override
  String get difficulty => 'కఠినత';

  @override
  String get numberOfQuestions => 'ప్రశ్నల సంఖ్య';

  @override
  String get timerPerQuestion => 'ప్రశ్నకు సమయం';

  @override
  String get noTimer => 'సమయం లేదు';

  @override
  String get start => 'ప్రారంభించు';

  @override
  String get profileTitle => 'ప్రొఫైల్';

  @override
  String get profileSignInToMessage => 'సందేశం పంపడానికి సైన్ ఇన్ చేయండి';

  @override
  String get profileThatsYourProfile => 'ఇది మీ ప్రొఫైల్';

  @override
  String get profileSignInToAddFriends =>
      'స్నేహితులను జోడించడానికి సైన్ ఇన్ చేయండి';

  @override
  String get profileCantAddYourself => 'మిమ్మల్ని మీరు జోడించుకోలేరు';

  @override
  String profileRequestSent(Object username) {
    return '@$usernameకి అభ్యర్థన పంపబడింది';
  }

  @override
  String get profileRequestFailed => 'అభ్యర్థన పంపడంలో విఫలమైంది';

  @override
  String get profileDefaultDisplayName => 'కొత్త యూజర్';

  @override
  String get profileDefaultBio => 'నేర్చుకోవడానికి సిద్ధం!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'అతిథి';

  @override
  String get guestUsername => 'అతిథి';

  @override
  String get guestSessionLabel => 'అతిథి సెషన్';

  @override
  String get unlockFullProfile => 'పూర్తి ప్రొఫైల్‌ను అన్‌లాక్ చేయండి';

  @override
  String get guestBenefitSync => 'అన్ని పరికరాల్లో ప్రగతిని సేవ్ చేయండి';

  @override
  String get guestBenefitCircles => 'సర్కిల్స్‌లో చేరండి మరియు లైవ్‌లో ఆడండి';

  @override
  String get guestBenefitNotifications =>
      'నోటిఫికేషన్లు మరియు స్నేహ అభ్యర్థనలను పొందండి';

  @override
  String get progressStaysOnDevice =>
      'మీరు సైన్ ఇన్ చేసే వరకు ప్రగతి ఈ పరికరంలోనే ఉంటుంది';

  @override
  String profileGoalLabel(Object minutes) {
    return 'లక్ష్యం: $minutes నిమి';
  }

  @override
  String get profileXpProgress => 'XP ప్రగతి';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'విజయాలు';

  @override
  String get profileStreak => 'స్ట్రీక్';

  @override
  String get profileFriendsTitle => 'స్నేహితులు';

  @override
  String get profileViewAll => 'అన్నీ చూడండి';

  @override
  String get profileAchievementsTitle => 'విజయాలు';

  @override
  String get profileNoAchievements => 'ఇంకా విజయాలు లేవు';

  @override
  String get profileRequested => 'అభ్యర్థించబడింది';

  @override
  String get profileSending => 'పంపుతోంది...';

  @override
  String get profileAddFriend => 'స్నేహితుడిని జోడించండి';

  @override
  String get profileConnectTitle => 'కనెక్ట్';

  @override
  String get profileMessage => 'సందేశం';

  @override
  String get profileSnapshot => 'ప్రొఫైల్ చిత్రం';

  @override
  String get profileLocationHidden => 'స్థానం దాచబడింది';

  @override
  String get profileBioHidden => 'బయో దాచబడింది';

  @override
  String profileDailyGoal(Object minutes) {
    return 'రోజువారీ లక్ష్యం $minutes నిమి';
  }

  @override
  String get circleInviteTitle => 'సర్కిల్ ఆహ్వానం';

  @override
  String circleIdLabel(Object id) {
    return 'సర్కిల్ ID: $id';
  }

  @override
  String get signInToJoin => 'చేరడానికి సైన్ ఇన్ చేయండి';

  @override
  String get joiningCircle => 'చేరుతోంది...';

  @override
  String get joinCircle => 'సర్కిల్స్‌లో చేరండి';

  @override
  String get circleJoinedAsPlayer => 'ప్లేయర్‌గా చేరారు';

  @override
  String get circleJoinedAsSpectator => 'వీక్షకుడిగా చేరారు';

  @override
  String get accept => 'అంగీకరించు';

  @override
  String get decline => 'తిరస్కరించు';

  @override
  String get open => 'తెరువు';

  @override
  String get circleCountdownTitle => 'సిద్ధంగా ఉండండి';

  @override
  String get circleCountdownSubtitle => 'సర్కిల్ ప్రారంభమవుతోంది...';

  @override
  String get userFallbackName => 'యూజర్';

  @override
  String get micOff => 'మైక్ ఆఫ్';

  @override
  String get micOn => 'మైక్ ఆన్';

  @override
  String get roleHost => 'హోస్ట్';

  @override
  String get roleSpectator => 'వీక్షకుడు';

  @override
  String get tagHost => 'హోస్ట్';

  @override
  String get tagYou => 'మీరు';

  @override
  String get statusCorrect => 'సరైనది';

  @override
  String get statusWrong => 'తప్పు';

  @override
  String get statusWaiting => 'వేచి ఉంది';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'పాయింట్లు';

  @override
  String get pointsLabel => 'పాయింట్లు';

  @override
  String get statCorrect => 'సరైనవి';

  @override
  String get statAnswers => 'సమాధానాలు';

  @override
  String get statTotal => 'మొత్తం';

  @override
  String get statQuestions => 'ప్రశ్నలు';

  @override
  String get statAccuracy => 'ఖచ్చితత్వం';

  @override
  String get statRate => 'రేటు';

  @override
  String get statRank => 'ర్యాంక్';

  @override
  String get statPosition => 'స్థానం';

  @override
  String get statMode => 'మోడ్';

  @override
  String get statType => 'రకం';

  @override
  String get next => 'తరువాత';

  @override
  String get submit => 'సమర్పించు';

  @override
  String get continueLabel => 'కొనసాగించు';

  @override
  String get save => 'సేవ్ చేయి';

  @override
  String get playAgain => 'మళ్ళీ ఆడు';

  @override
  String get backToCourse => 'కోర్సుకి తిరిగి వెళ్లు';

  @override
  String get resultsTitle => 'ఫలితాలు';

  @override
  String get shareLater => 'తర్వాత షేర్ చేయండి';

  @override
  String get delete => 'తొలగించు';

  @override
  String get ok => 'సరే';

  @override
  String minutesShort(Object minutes) {
    return '$minutes నిమి';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count నిమి';
  }

  @override
  String timeShortHours(Object count) {
    return '$count గం';
  }

  @override
  String timeShortDays(Object count) {
    return '$count రోజులు';
  }

  @override
  String get timeJustNow => 'ఇప్పుడే';

  @override
  String timeMinutesAgo(Object count) {
    return '$count నిమి క్రితం';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count గం క్రితం';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count రోజుల క్రితం';
  }

  @override
  String get liveQuizWaitingForHost => 'హోస్ట్ కోసం వేచి ఉంది...';

  @override
  String get liveQuizJoinRequestSent => 'చేరడానికి అభ్యర్థన పంపబడింది';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'అభ్యర్థన విఫలమైంది: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'హోస్ట్ నియంత్రణలు';

  @override
  String get liveQuizSpectatorModeTitle => 'వీక్షక మోడ్';

  @override
  String get liveQuizHostControlsSubtitle =>
      'అందరూ సమాధానం ఇచ్చినప్పుడు లేదా సమయం ముగిసినప్పుడు రౌండ్‌లు ఆటోమేటిక్‌గా ముందుకు వెళ్తాయి';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'ప్రశ్నలు మరియు లీడర్‌బోర్డ్‌లను లైవ్‌లో చూడండి. మీరు సమాధానం ఇవ్వలేరు';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'ప్రశ్న $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'అభ్యర్థన పంపబడింది';

  @override
  String get liveQuizRequestToJoin => 'చేరడానికి అభ్యర్థన';

  @override
  String get liveQuizSpectatorFooter =>
      'మీరు లైవ్ చూస్తున్నారు. ప్రశ్నలు మరియు లీడర్‌బోర్డ్‌లను ఆస్వాదించండి';

  @override
  String get circleNotFound => 'సర్కిల్ కనుగొనబడలేదు';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'రీమాచ్ ప్రారంభించడం విఫలమైంది: $error';
  }

  @override
  String get resultsMatchTitle => 'మ్యాచ్ ఫలితాలు';

  @override
  String resultsNiceWork(Object name) {
    return 'చాలా బాగుంది, $name';
  }

  @override
  String get resultsPlaceFirst => '1వ స్థానం';

  @override
  String get resultsPlaceSecond => '2వ స్థానం';

  @override
  String get resultsPlaceThird => '3వ స్థానం';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankవ స్థానం';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players ప్లేయర్లలో';
  }

  @override
  String get resultsHighlightChampion =>
      'ఛాంపియన్! ఈ రౌండ్‌లో మీరు అద్భుతంగా ఆడారు';

  @override
  String get resultsHighlightGreatAccuracy =>
      'గొప్ప ఖచ్చితత్వం - చాలా వరకు సరిగ్గా!';

  @override
  String get resultsHighlightKeepGoing =>
      'కొనసాగించండి - నిలకడ వేగాన్ని జయిస్తుంది';

  @override
  String get resultsLeaderboardTitle => 'లీడర్‌బోర్డ్';

  @override
  String resultsPlayersCount(Object count) {
    return '$count ప్లేయర్లు';
  }

  @override
  String get resultsBackToCircles => 'సర్కిల్స్‌కి తిరిగి వెళ్లు';

  @override
  String get resultsRematch => 'రీమాచ్';

  @override
  String get resultsPlayAgain => 'మళ్ళీ ఆడు';

  @override
  String get leaderboardGlobalTitle => 'గ్లోబల్ లీడర్‌బోర్డ్';

  @override
  String get leaderboardEmpty => 'ఇంకా ర్యాంకింగ్‌లు లేవు';

  @override
  String get aboutTitle => 'గురించి';

  @override
  String aboutVersion(Object version) {
    return 'వెర్షన్ $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ఒక గేమ్ ఆధారిత భాషా అభ్యాస వేదిక, కొత్త భాషల్లో నైపుణ్యం సాధించడాన్ని సరదాగా మరియు సామాజికంగా మారుస్తుంది. సర్కిల్స్‌లో పోటీపడండి, ఒంటరిగా ప్రాక్టీస్ చేయండి మరియు మీ ప్రగతిని ట్రాక్ చేయండి.';

  @override
  String get aboutTerms => 'సేవా నిబంధనలు';

  @override
  String get aboutPrivacy => 'గోప్యతా విధానం';

  @override
  String get aboutOpenSource => 'ఓపెన్ సోర్స్ లైసెన్సులు';

  @override
  String get addFriendTitle => 'స్నేహితుడిని జోడించండి';

  @override
  String get addFriendFindByUsername => 'యూజర్ పేరు ద్వారా కనుగొనండి';

  @override
  String get addFriendUsernameHint => 'యూజర్ పేరు టైప్ చేయండి...';

  @override
  String get addFriendTip =>
      'చిట్కా: QR కోడ్ + ఫ్రెండ్ ID మద్దతు త్వరలో రాబోతోంది';

  @override
  String get addFriendSending => 'పంపుతోంది...';

  @override
  String get addFriendSendRequest => 'అభ్యర్థన పంపండి';

  @override
  String addFriendUserNotFound(Object username) {
    return 'యూజర్ @$username కనుగొనబడలేదు';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'చర్య విఫలమైంది లేదా ఇప్పటికే పంపబడింది: $error';
  }

  @override
  String get friendsTitle => 'స్నేహితులు';

  @override
  String get searchFriendsHint => 'స్నేహితులను శోధించండి...';

  @override
  String get somaLearnerSubtitle => 'Soma విద్యార్థి';

  @override
  String get friendRequestLabel => 'అభ్యర్థన';

  @override
  String get friendRequestSentLabel => 'అభ్యర్థన పంపబడింది';

  @override
  String get friendIncomingRequestLabel => 'వస్తున్న అభ్యర్థన';

  @override
  String get friendRequestsSection => 'అభ్యర్థనలు';

  @override
  String get friendPendingSection => 'పెండింగ్‌లో ఉంది';

  @override
  String get friendAllSection => 'అందరూ స్నేహితులు';

  @override
  String get friendsEmptyState =>
      'ఇంకా స్నేహితులు లేరు. మీ మొదటి స్నేహితుడిని జోడించండి!';

  @override
  String get friendsEmptyShort => 'ఇంకా స్నేహితులు లేరు';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\"కి ఫలితాలు లేవు';
  }

  @override
  String get inboxTitle => 'ఇన్‌ బాక్స్';

  @override
  String get searchChatsHint => 'చాట్‌లను శోధించండి...';

  @override
  String get inboxEmptyState =>
      'ఇంకా చాట్‌లు లేవు. స్నేహితుడితో సంభాషణను ప్రారంభించండి!';

  @override
  String get newMessageTitle => 'కొత్త సందేశం';

  @override
  String get chatCallLater => 'వాయిస్ కాల్ త్వరలో (తదుపరి సర్కిల్ వాయిస్)';

  @override
  String errorWithDetails(Object error) {
    return 'లోపం: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$nameకి హలో చెప్పండి!';
  }

  @override
  String get chatMessageHint => 'సందేశం...';

  @override
  String get notificationsTitle => 'నోటిఫికేషన్లు';

  @override
  String get notificationsTabAll => 'అన్నీ';

  @override
  String get notificationsTabCourses => 'కోర్సులు';

  @override
  String get notificationsTabSocial => 'సోషల్';

  @override
  String get notificationsTabCircles => 'సర్కిల్స్';

  @override
  String get notificationsTabSystem => 'సిస్టమ్';

  @override
  String get notificationsEmpty => 'నోటిఫికేషన్లు లేవు';

  @override
  String get notificationsDeleted => 'నోటిఫికేషన్ తొలగించబడింది';

  @override
  String get notificationTitleFallback => 'నోటిఫికేషన్';

  @override
  String get notificationTypeCourse => 'కోర్సు';

  @override
  String get notificationTypeSocial => 'సోషల్';

  @override
  String get notificationTypeCircle => 'సర్కిల్';

  @override
  String get notificationTypeSystem => 'సిస్టమ్';

  @override
  String get notificationsFriendAccepted => 'స్నేహ అభ్యర్థన అంగీకరించబడింది';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'స్నేహ అభ్యర్థనను అంగీకరించడం విఫలమైంది: $error';
  }

  @override
  String get notificationsFriendDeclined => 'స్నేహ అభ్యర్థన తిరస్కరించబడింది';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'స్నేహ అభ్యర్థనను తిరస్కరించడం విఫలమైంది: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'సర్కిల్‌లో చేరడం విఫలమైంది: $error';
  }

  @override
  String get notificationsOpening => 'తెరుస్తోంది';

  @override
  String get notificationsOpened => 'తెరవబడింది';

  @override
  String notificationsActionMessage(Object action) {
    return '$action నోటిఫికేషన్';
  }

  @override
  String get settingsTitle => 'సెట్టింగ్స్';

  @override
  String get settingsSectionAccount => 'ఖాతా';

  @override
  String get settingsEditProfile => 'ప్రొఫైల్ సవరించండి';

  @override
  String get settingsPrivacy => 'గోప్యత';

  @override
  String get settingsSecurity => 'భద్రత';

  @override
  String get settingsSectionGameplay => 'గేమ్‌ప్లే';

  @override
  String get settingsShowTranslationLine => 'అనువాద లైన్ చూపించు';

  @override
  String get settingsShowReadingLine => 'పఠనం చూపించు (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'ప్రశ్నకు డిఫాల్ట్ టైమర్';

  @override
  String get settingsMatchDifficulty => 'మ్యాచ్ కఠినత';

  @override
  String get settingsMatchDifficultyAdaptive => 'అడాప్టివ్';

  @override
  String get settingsSectionSoundFeel => 'సౌండ్ & ఫీల్';

  @override
  String get settingsMusic => 'మ్యూజిక్';

  @override
  String get settingsSoundEffects => 'సౌండ్ ఎఫెక్ట్స్';

  @override
  String get settingsHaptics => 'హాప్టిక్స్';

  @override
  String get settingsSectionNotifications => 'నోటిఫికేషన్లు';

  @override
  String get settingsPushNotifications => 'పుష్ నోటిఫికేషన్లు';

  @override
  String get settingsDailyReminder => 'రోజువారీ రిమైండర్';

  @override
  String get settingsSectionAppearance => 'కనిపించే విధానం';

  @override
  String get settingsTheme => 'థీమ్';

  @override
  String get settingsUiLanguage => 'UI భాష';

  @override
  String get settingsSectionAbout => 'గురించి';

  @override
  String get settingsVersion => 'వెర్షన్';

  @override
  String get settingsTermsPrivacy => 'నిబంధనలు & గోప్యత';

  @override
  String get settingsSupport => 'సపోర్ట్';

  @override
  String get settingsLogout => 'లాగ్ అవుట్';

  @override
  String get themeSystem => 'సిస్టమ్';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get themeLight => 'లైట్';

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
  String get editProfileUpdated => 'ప్రొఫైల్ సేవ్ చేయబడింది';

  @override
  String get editProfileTitle => 'ప్రొఫైల్ సవరించండి';

  @override
  String get editProfilePhotoLabel => 'ప్రొఫైల్ ఫోటో';

  @override
  String get editProfilePhotoSubtitle => 'Supabase Storage అవతార్ ఎంపిక త్వరలో';

  @override
  String get editProfileChangePhoto => 'మార్చు';

  @override
  String get editProfileAvatarUploadSoon => 'అవతార్ అప్‌లోడ్ త్వరలో';

  @override
  String get editProfileDisplayNameLabel => 'డిస్‌ప్లే పేరు';

  @override
  String get editProfileDisplayNameHint => 'మీ పేరు';

  @override
  String get editProfileDisplayNameRequired => 'దయచేసి మీ పేరును నమోదు చేయండి';

  @override
  String get editProfileDisplayNameTooShort => 'మరీ చిన్నగా ఉంది';

  @override
  String get editProfileUsernameLabel => 'యూజర్ పేరు';

  @override
  String get editProfileUsernameHint => 'learner_ali';

  @override
  String get editProfileUsernameRequired => 'దయచేసి యూజర్ పేరును నమోదు చేయండి';

  @override
  String get editProfileUsernameTooShort => 'కనీసం 3 అక్షరాలు';

  @override
  String get editProfileUsernameInvalid => 'అక్షరాలు, సంఖ్యలు, _ మాత్రమే';

  @override
  String get editProfileBioLabel => 'బయో';

  @override
  String get editProfileBioHint => 'మీ గురించి చిన్న పరిచయం...';

  @override
  String get editProfileBioTooLong => 'గరిష్టంగా 120 అక్షరాలు';

  @override
  String get editProfileLocationLabel => 'స్థానం';

  @override
  String get editProfileLocationHint => 'నగరం / దేశం';

  @override
  String get editProfileDailyGoalTitle => 'రోజువారీ లక్ష్యం';

  @override
  String get editProfileDailyGoalSubtitle =>
      'రోజుకు ఎన్ని నిమిషాలు నేర్చుకోవాలనుకుంటున్నారో ఎంచుకోండి';

  @override
  String get securityTitle => 'భద్రత';

  @override
  String get securitySectionPassword => 'పాస్‌వర్డ్';

  @override
  String get securityChangePasswordTitle => 'పాస్‌వర్డ్ మార్చండి';

  @override
  String get securityChangePasswordSubtitle =>
      'మీ పాస్‌వర్డ్‌ను క్రమం తప్పకుండా అప్‌డేట్ చేయండి';

  @override
  String get securitySectionTwoFactor => 'టూ-ఫ్యాక్టర్ అథెంటికేషన్';

  @override
  String get securityEnable2faTitle => '2FAని ఎనేబుల్ చేయండి';

  @override
  String get securityEnable2faSubtitle => 'సైన్ ఇన్ కోసం అదనపు భద్రత';

  @override
  String get securitySectionAppLock => 'యాప్ లాక్';

  @override
  String get securityBiometricTitle => 'బయోమెట్రిక్ అన్‌లాక్';

  @override
  String get securityBiometricSubtitle =>
      'SOMAని తెరవడానికి FaceID/TouchIDని వాడండి';

  @override
  String get securityAppLockTitle => 'యాప్ లాక్';

  @override
  String get securityAppLockSubtitle =>
      'మీరు బయటకు వెళ్ళినప్పుడు SOMAని లాక్ చేయండి';

  @override
  String get securitySectionSessions => 'యాక్టివ్ సెషన్‌లు';

  @override
  String get securityNoSessions => 'యాక్టివ్ సెషన్‌లు లేవు';

  @override
  String get securityThisDevice => 'ఈ పరికరం';

  @override
  String get securityDevice => 'పరికరం';

  @override
  String get securityActiveLabel => 'యాక్టివ్';

  @override
  String get securitySignInToEnable2fa =>
      '2FAని ఎనేబుల్ చేయడానికి సైన్ ఇన్ చేయండి';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FAని ఎనేబుల్ చేయడం విఫలమైంది: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FAని డిజేబుల్ చేయడం విఫలమైంది: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA సెటప్';

  @override
  String get securitySecretKeyLabel => 'సీక్రెట్ కీ';

  @override
  String get securityCodeHint => '6-అంకెల కోడ్';

  @override
  String get security2faEnabled => '2FA ఎనేబుల్ చేయబడింది';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'కోడ్‌ని వెరిఫై చేయడం విఫలమైంది: $error';
  }

  @override
  String get securityVerifying => 'వెరిఫై చేస్తోంది...';

  @override
  String get securityVerify => 'వెరిఫై';

  @override
  String get securityCurrentPasswordHint => 'ప్రస్తుత పాస్‌వర్డ్';

  @override
  String get securityNewPasswordHint => 'కొత్త పాస్‌వర్డ్ (కనీసం 8 అక్షరాలు)';

  @override
  String get securityConfirmPasswordHint => 'కొత్త పాస్‌వర్డ్‌ని నిర్ధారించండి';

  @override
  String get securitySignInToChangePassword =>
      'పాస్‌వర్డ్ మార్చడానికి సైన్ ఇన్ చేయండి';

  @override
  String get securityEnterCurrentPassword =>
      'మీ ప్రస్తుత పాస్‌వర్డ్‌ను నమోదు చేయండి';

  @override
  String get securityPasswordMinLength =>
      'కొత్త పాస్‌వర్డ్ కనీసం 8 అక్షరాలు ఉండాలి';

  @override
  String get securityPasswordsDoNotMatch => 'పాస్‌వర్డ్‌లు సరిపోలలేదు';

  @override
  String get securityPasswordUpdated => 'పాస్‌వర్డ్ అప్‌డేట్ చేయబడింది';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'పాస్‌వర్డ్ అప్‌డేట్ చేయడం విఫలమైంది: $error';
  }

  @override
  String get securityAutoLockAfter => 'ఆటో-లాక్ సమయం';

  @override
  String get privacyTitle => 'గోప్యత';

  @override
  String get privacySectionVisibility => 'విజిబిలిటీ';

  @override
  String get privacyProfileVisibilityTitle => 'ప్రొఫైల్ విజిబిలిటీ';

  @override
  String get privacyVisibilityPublic => 'పబ్లిక్';

  @override
  String get privacyVisibilityFriends => 'స్నేహితులు';

  @override
  String get privacyVisibilityPrivate => 'ప్రైవేట్';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'ఎవరైనా మీ ప్రొఫైల్‌ను చూడవచ్చు';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'కేవలం స్నేహితులు మాత్రమే మీ ప్రొఫైల్‌ను చూడగలరు';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'మీరు మాత్రమే మీ ప్రొఫైల్‌ను చూడగలరు';

  @override
  String get privacySectionActivity => 'యాక్టివిటీ';

  @override
  String get privacyShowOnlineTitle => 'ఆన్‌లైన్ స్టేటస్ చూపించు';

  @override
  String get privacyShowOnlineSubtitle =>
      'మీరు ఆన్‌లైన్‌లో ఉన్నారని ప్లేయర్లకు తెలియజేయండి';

  @override
  String get privacyShowActivityTitle => 'లెర్నింగ్ యాక్టివిటీ చూపించు';

  @override
  String get privacyShowActivitySubtitle =>
      'స్ట్రీక్, XP మరియు ఇటీవలి ప్రగతిని చూపించు';

  @override
  String get privacySectionSocial => 'సోషల్';

  @override
  String get privacyAllowRequestsTitle => 'స్నేహ అభ్యర్థనలను అనుమతించు';

  @override
  String get privacyAllowRequestsSubtitle =>
      'ప్రజలు మీకు స్నేహ అభ్యర్థనలు పంపడాన్ని అనుమతించండి';

  @override
  String get privacyWhoCanDmTitle => 'ఎవరు DM పంపగలరు';

  @override
  String get privacyDmEveryone => 'ఎవరైనా';

  @override
  String get privacyDmFriends => 'స్నేహితులు';

  @override
  String get privacyDmNoOne => 'ఎవరూ కాదు';

  @override
  String get privacyDmEveryoneSubtitle => 'ఎవరైనా మీకు మెసేజ్ చేయవచ్చు';

  @override
  String get privacyDmFriendsSubtitle =>
      'స్నేహితులు మాత్రమే మీకు మెసేజ్ చేయగలరు';

  @override
  String get privacyDmNoOneSubtitle => 'ఎవరూ మీకు మెసేజ్ చేయలేరు';

  @override
  String get privacySectionBlockedUsers => 'బ్లాక్ చేయబడిన యూజర్లు';

  @override
  String get privacyBlockedUsersComingSoon =>
      'బ్లాక్ చేయబడిన యూజర్ల నిర్వహణ త్వరలో';

  @override
  String get privacySectionDataControls => 'డేటా నియంత్రణలు';

  @override
  String get privacyExportDataTitle => 'నా డేటాను ఎగుమతి చేయి';

  @override
  String get privacyExportDataSubtitle =>
      'మీ యాక్టివిటీ మరియు కోర్సులను డౌన్‌లోడ్ చేయండి';

  @override
  String get privacyExportInfoTitle => 'డేటా ఎగుమతి';

  @override
  String get privacyExportInfoBody =>
      'తదుపరి దశ: JSON/CSV ఎగుమతిని రూపొందించడం మరియు ఇమెయిల్ లేదా లోకల్ డౌన్‌లోడ్';

  @override
  String get privacyDeleteAccountTitle => 'ఖాతాను తొలగించు';

  @override
  String get privacyDeleteAccountSubtitle =>
      'ఇది మీ ఖాతా మరియు డేటాను శాశ్వతంగా తొలగిస్తుంది';

  @override
  String get privacyDeleteConfirmTitle => 'ఖాతాను తొలగించాలా?';

  @override
  String get privacyDeleteConfirmBody =>
      'దీన్ని వెనక్కి తీసుకోలేము. మీ ప్రొఫైల్, కోర్సులు, స్నేహితులు మరియు మెసేజ్‌లు తొలగించబడతాయి';

  @override
  String get privacyDeleteComingSoon =>
      'తొలగింపు తర్వాత Supabaseతో లింక్ చేయబడుతుంది';

  @override
  String get soloLabel => 'సోలో';

  @override
  String get soloResultsCompletedTitle => 'సోలో సెషన్ పూర్తయింది';

  @override
  String get soloResultsFeedbackElite =>
      'అద్భుతమైన పనితీరు - స్ట్రీక్‌ను కొనసాగించండి';

  @override
  String get soloResultsFeedbackStrong => 'మంచి పని - వేగంగా మెరుగుపడుతోంది';

  @override
  String get soloResultsFeedbackProgress =>
      'మంచి ప్రగతి - తప్పులను సమీక్షించి మళ్లీ ప్రయత్నించండి';

  @override
  String get soloResultsFeedbackTryAgain =>
      'ఒత్తిడి లేదు - తక్కువ ప్రశ్నలతో మళ్లీ ప్రయత్నించండి';

  @override
  String get soloResultsPerfectScore =>
      'పూర్తి స్కోర్! సమీక్షించడానికి తప్పులు లేవు';

  @override
  String get soloResultsReviewPrompt =>
      'వేగంగా నేర్చుకోవడానికి తప్పులను సమీక్షించండి. మీ తప్పు సమాధానాలు క్రింద ఉన్నాయి';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'తప్పులను సమీక్షించండి ($count)';
  }

  @override
  String get authNotSignedIn => 'సైన్ ఇన్ చేయలేదు';

  @override
  String get genericUser => 'యూజర్';

  @override
  String get loading => 'లోడ్ అవుతోంది...';

  @override
  String get edit => 'ఎడిట్';

  @override
  String get send => 'పంపు';

  @override
  String get join => 'చేరండి';

  @override
  String get leave => 'వదిలేయండి';

  @override
  String get ready => 'సిద్ధం';

  @override
  String get levelBeginner => 'బిగినర్';

  @override
  String get levelIntermediate => 'ఇంటర్మీడియట్';

  @override
  String get levelAdvanced => 'అడ్వాన్స్‌డ్';

  @override
  String questionsShort(Object count) {
    return '$count ప్రశ్నలు';
  }

  @override
  String secondsShort(Object count) {
    return '$count సెకన్లు';
  }

  @override
  String get circlesAllCourses => 'అన్ని కోర్సులు';

  @override
  String get circlesAllModes => 'అన్ని మోడ్‌లు';

  @override
  String get circlesAllLevels => 'అన్ని స్థాయిలు';

  @override
  String get circlesAddNewCourse => 'కొత్త కోర్సును జోడించండి';

  @override
  String get circlesCoursesTitle => 'కోర్సులు';

  @override
  String get circlesModeTitle => 'మోడ్';

  @override
  String get circlesLevelTitle => 'స్థాయి';

  @override
  String get circlesNoActiveForFilters => 'ఈ ఫిల్టర్‌లకు యాక్టివ్ సర్కిల్ లేదు';

  @override
  String get circlesUnknownRoom => 'తెలియని గది';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'సర్కిల్‌ని సృష్టించండి';

  @override
  String get circlesCircleName => 'సర్కిల్ పేరు';

  @override
  String get circlesEnterName => 'పేరును నమోదు చేయండి';

  @override
  String get circlesLanguages => 'భాషలు';

  @override
  String get circlesRoomSetup => 'గది సెటప్';

  @override
  String get circlesPlayers => 'ప్లేయర్లు';

  @override
  String get circlesEmptySlot => 'ఖాళీ';

  @override
  String get circlesPlayersRange => '1-5 ప్లేయర్లు';

  @override
  String get circlesQuestions => 'ప్రశ్నలు';

  @override
  String get circlesQuestionsSubtitle => 'ప్రశ్నల పరిమాణం';

  @override
  String get circlesTimePerQuestion => 'ప్రశ్నకు సమయం';

  @override
  String get circlesSecondsPerQuestion => 'సెకను/ప్రశ్న';

  @override
  String get circlesAdvanced => 'అడ్వాన్స్‌డ్';

  @override
  String get circlesAllowSpectators => 'వీక్షకులను అనుమతించు';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'ఆడకుండా ఇతరులను చూడటానికి అనుమతించండి';

  @override
  String get circlesLiveVoiceChat => 'లైవ్ వాయిస్ చాట్';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'మ్యాచ్‌ల సమయంలో వాయిస్ ఇంటరాక్షన్ ఎనేబుల్ చేయండి';

  @override
  String get circlesLiveTextChat => 'లైవ్ టెక్స్ట్ చాట్';

  @override
  String get circlesLiveTextChatSubtitle =>
      'మ్యాచ్‌ల సమయంలో మెసేజింగ్ ఎనేబుల్ చేయండి';

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
  String get circlesCreatedSuccess => 'సర్కిల్ సృష్టించబడింది';

  @override
  String circlesCreateError(Object error) {
    return 'సర్కిల్‌ని సృష్టించడం విఫలమైంది: $error';
  }

  @override
  String get circlesHostTip =>
      'చిట్కా: సృష్టించిన తర్వాత మీరు స్నేహితులను ఆహ్వానించవచ్చు';

  @override
  String circlesJoinError(Object error) {
    return 'సర్కిల్‌లో చేరడం విఫలమైంది: $error';
  }

  @override
  String get circlesLobbyTitle => 'సర్కిల్ లాబీ';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'కోడ్: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'మ్యాచ్ సెట్టింగ్‌లు';

  @override
  String circlesLevelWithValue(Object level) {
    return 'స్థాయి $level';
  }

  @override
  String get circlesDifficulty => 'కఠినత';

  @override
  String get circlesPerQuestionShort => 'ప్రతి ప్రశ్నకు';

  @override
  String get circlesInvite => 'ఆహ్వానించండి';

  @override
  String get circlesCopyId => 'IDని కాపీ చేయండి';

  @override
  String get circlesCopiedId => 'ID కాపీ చేయబడింది';

  @override
  String get circlesMatchInProgress => 'మ్యాచ్ జరుగుతోంది';

  @override
  String get circlesSpectatorQueuedBody =>
      'మ్యాచ్ జరుగుతోంది. మీరు వీక్షకుడిగా చేరతారు';

  @override
  String get circlesHostStartWhenReady =>
      'అందరూ సిద్ధంగా ఉన్నప్పుడు హోస్ట్ ప్రారంభిస్తారు';

  @override
  String get circlesSpectators => 'వీక్షకులు';

  @override
  String get circlesSpectator => 'వీక్షకుడు';

  @override
  String get circlesSpectatorCanWatch => 'వీక్షకులు లైవ్ చూడవచ్చు';

  @override
  String get circlesJoinRequests => 'చేరడానికి అభ్యర్థనలు';

  @override
  String get circlesAcceptSpectatorsHint =>
      'మ్యాచ్ ప్రారంభించే ముందు వీక్షకులను అంగీకరించండి';

  @override
  String get circlesStartGame => 'గేమ్ ప్రారంభించండి';

  @override
  String get circlesStartingGame => 'Starting game...';

  @override
  String get circlesWaitingForPlayers => 'ప్లేయర్ల కోసం వేచి ఉంది';

  @override
  String get circlesLeaveCircle => 'సర్కిల్‌ని వదిలేయండి';

  @override
  String get circlesRequestSent => 'అభ్యర్థన పంపబడింది';

  @override
  String get circlesRequestToJoin => 'చేరడానికి అభ్యర్థన';

  @override
  String get circlesWatchLive => 'లైవ్ చూడండి';

  @override
  String get circlesPlayerTip =>
      'మీరు సిద్ధమైనప్పుడు \'రెడీ\' నొక్కండి. హోస్ట్ మ్యాచ్‌ను ప్రారంభిస్తారు';

  @override
  String get circlesSpectatorTip =>
      'మీరు చూస్తున్నారు. హోస్ట్ ప్రారంభించినప్పుడు లైవ్ యాక్షన్‌ను చూడండి';

  @override
  String get circlesHostControls => 'హోస్ట్ నియంత్రణలు';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'హోస్ట్‌ను మార్చడం విఫలమైంది: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'సర్కిల్‌ని ముగించడం విఫలమైంది: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'యూజర్ @$username కనుగొనబడలేదు';
  }

  @override
  String get circlesInvalidUser => 'చెల్లని యూజర్';

  @override
  String get circlesCantInviteSelf => 'మిమ్మల్ని మీరు ఆహ్వానించుకోలేరు';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username ఇప్పటికే సర్కిల్‌లో ఉన్నారు';
  }

  @override
  String get circlesDefaultHost => 'హోస్ట్';

  @override
  String get circlesDefaultTitle => 'సర్కిల్';

  @override
  String get circlesInviteByUsername => 'యూజర్ పేరు ద్వారా';

  @override
  String circlesInviteSent(Object username) {
    return '@$usernameకి ఆహ్వానం పంపబడింది';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'ఆహ్వానం పంపడం విఫలమైంది: $error';
  }

  @override
  String get circlesJoinRequestSent => 'చేరడానికి అభ్యర్థన పంపబడింది';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'అభ్యర్థన విఫలమైంది: $error';
  }

  @override
  String get circlesFull => 'సర్కిల్ నిండిపోయింది';

  @override
  String get circlesSpectatorAdded => 'వీక్షకుడు జోడించబడ్డారు';

  @override
  String circlesApproveFailed(Object error) {
    return 'ఆమోదించడం విఫలమైంది: $error';
  }

  @override
  String get circlesRequestDeclined => 'అభ్యర్థన తిరస్కరించబడింది';

  @override
  String circlesDeclineFailed(Object error) {
    return 'తిరస్కరించడం విఫలమైంది: $error';
  }

  @override
  String get circlesParticipant => 'పాల్గొనేవారు';

  @override
  String get circlesLeavePromptTitle => 'సర్కిల్‌ని వదిలేయాలా?';

  @override
  String get circlesLeavePromptTransfer =>
      'వదిలేసే ముందు హోస్ట్‌ను బదిలీ చేయండి';

  @override
  String get circlesLeavePromptEndOnly => 'సర్కిల్‌ని ముగించి నిష్క్రమించు';

  @override
  String get circlesTransferHost => 'హోస్ట్‌ను మార్చండి';

  @override
  String get circlesEndCircle => 'సర్కిల్‌ని ముగించు';

  @override
  String get circlesTransferHostTitle => 'హోస్ట్ బదిలీ';

  @override
  String circlesShareId(Object id) {
    return 'సర్కిల్ ID: $id';
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
