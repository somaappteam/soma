import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nl'),
    Locale('no'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('sw'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SOMA'**
  String get appTitle;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn. Compete. Master.'**
  String get welcomeTagline;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcome(Object name);

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for Now'**
  String get skipForNow;

  /// No description provided for @authFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get authFillAllFields;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email linked to your account. We\'ll send a secure reset link.'**
  String get authForgotPasswordBody;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authSendResetLink;

  /// No description provided for @authResetSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authResetSentTitle;

  /// No description provided for @authResetSentBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link. Follow the instructions to set a new password.'**
  String get authResetSentBody;

  /// No description provided for @authResetFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset failed'**
  String get authResetFailedTitle;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String authError(Object error);

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsername;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get authSigningIn;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get authCreating;

  /// No description provided for @authNeedAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNeedAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// No description provided for @dialogAuthRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access Circles'**
  String get dialogAuthRequiredTitle;

  /// No description provided for @dialogAuthRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Circles are multiplayer rooms. Create an account to join live matches, invite friends, and save progress.'**
  String get dialogAuthRequiredBody;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCircles.
  ///
  /// In en, this message translates to:
  /// **'Circles'**
  String get navCircles;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @removeCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove course?'**
  String get removeCourseTitle;

  /// No description provided for @removeCourseBody.
  ///
  /// In en, this message translates to:
  /// **'{course} will be removed from your home list.'**
  String removeCourseBody(Object course);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(Object name);

  /// No description provided for @editCourses.
  ///
  /// In en, this message translates to:
  /// **'Edit courses'**
  String get editCourses;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @noCoursesToEdit.
  ///
  /// In en, this message translates to:
  /// **'No courses to edit.'**
  String get noCoursesToEdit;

  /// No description provided for @addCourse.
  ///
  /// In en, this message translates to:
  /// **'Add Course'**
  String get addCourse;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @iSpeak.
  ///
  /// In en, this message translates to:
  /// **'I speak'**
  String get iSpeak;

  /// No description provided for @iWantToLearn.
  ///
  /// In en, this message translates to:
  /// **'I want to learn'**
  String get iWantToLearn;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseYourLanguage;

  /// No description provided for @chooseLearningLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose learning language'**
  String get chooseLearningLanguage;

  /// No description provided for @chooseTwoDifferentLanguages.
  ///
  /// In en, this message translates to:
  /// **'Choose two different languages.'**
  String get chooseTwoDifferentLanguages;

  /// No description provided for @createCourse.
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get createCourse;

  /// No description provided for @soloCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Solo Course'**
  String get soloCourseTitle;

  /// No description provided for @searchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Search language'**
  String get searchLanguage;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @chooseCourseType.
  ///
  /// In en, this message translates to:
  /// **'Choose a course type'**
  String get chooseCourseType;

  /// No description provided for @soloStudyDescription.
  ///
  /// In en, this message translates to:
  /// **'Study alone with the same quiz style as circles - but without rooms, chat, spectators, or host options.'**
  String get soloStudyDescription;

  /// No description provided for @soloModeVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get soloModeVocabulary;

  /// No description provided for @soloModeSentences.
  ///
  /// In en, this message translates to:
  /// **'Sentences'**
  String get soloModeSentences;

  /// No description provided for @soloModeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get soloModeReview;

  /// No description provided for @soloModeVocabularySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice meanings, synonyms, usage'**
  String get soloModeVocabularySubtitle;

  /// No description provided for @soloModeSentencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the blank + translation + reading'**
  String get soloModeSentencesSubtitle;

  /// No description provided for @soloModeReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice what you learned: weak words, recent mistakes, and spaced repetition.'**
  String get soloModeReviewDescription;

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Start Review'**
  String get startReview;

  /// No description provided for @soloReviewModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Review mode'**
  String get soloReviewModeTitle;

  /// No description provided for @soloReviewOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Review options'**
  String get soloReviewOptionsTitle;

  /// No description provided for @soloReviewScopeAllLearned.
  ///
  /// In en, this message translates to:
  /// **'All learned'**
  String get soloReviewScopeAllLearned;

  /// No description provided for @soloReviewScopeStruggling.
  ///
  /// In en, this message translates to:
  /// **'Struggling items'**
  String get soloReviewScopeStruggling;

  /// No description provided for @soloReviewScopeStrugglingDescription.
  ///
  /// In en, this message translates to:
  /// **'Prioritize items you recently got wrong.'**
  String get soloReviewScopeStrugglingDescription;

  /// No description provided for @soloReviewScopeAllLearnedDescription.
  ///
  /// In en, this message translates to:
  /// **'Review all learned content for this course.'**
  String get soloReviewScopeAllLearnedDescription;

  /// No description provided for @soloSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'{mode} Setup'**
  String soloSetupTitle(Object mode);

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @numberOfQuestions.
  ///
  /// In en, this message translates to:
  /// **'Number of questions'**
  String get numberOfQuestions;

  /// No description provided for @timerPerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Timer per question'**
  String get timerPerQuestion;

  /// No description provided for @noTimer.
  ///
  /// In en, this message translates to:
  /// **'No timer'**
  String get noTimer;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSignInToMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to message'**
  String get profileSignInToMessage;

  /// No description provided for @profileThatsYourProfile.
  ///
  /// In en, this message translates to:
  /// **'That\'s your profile'**
  String get profileThatsYourProfile;

  /// No description provided for @profileSignInToAddFriends.
  ///
  /// In en, this message translates to:
  /// **'Sign in to add friends'**
  String get profileSignInToAddFriends;

  /// No description provided for @profileCantAddYourself.
  ///
  /// In en, this message translates to:
  /// **'You can\'t add yourself'**
  String get profileCantAddYourself;

  /// No description provided for @profileRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent to @{username}'**
  String profileRequestSent(Object username);

  /// No description provided for @profileRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send request'**
  String get profileRequestFailed;

  /// No description provided for @profileDefaultDisplayName.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get profileDefaultDisplayName;

  /// No description provided for @profileDefaultBio.
  ///
  /// In en, this message translates to:
  /// **'Ready to learn!'**
  String get profileDefaultBio;

  /// No description provided for @profileDefaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Soma'**
  String get profileDefaultLocation;

  /// No description provided for @guestDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestDisplayName;

  /// No description provided for @guestUsername.
  ///
  /// In en, this message translates to:
  /// **'guest'**
  String get guestUsername;

  /// No description provided for @guestSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Guest session'**
  String get guestSessionLabel;

  /// No description provided for @unlockFullProfile.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full profile'**
  String get unlockFullProfile;

  /// No description provided for @guestBenefitSync.
  ///
  /// In en, this message translates to:
  /// **'Sync progress across devices'**
  String get guestBenefitSync;

  /// No description provided for @guestBenefitCircles.
  ///
  /// In en, this message translates to:
  /// **'Join Circles and play live'**
  String get guestBenefitCircles;

  /// No description provided for @guestBenefitNotifications.
  ///
  /// In en, this message translates to:
  /// **'Get notifications and friend requests'**
  String get guestBenefitNotifications;

  /// No description provided for @progressStaysOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Progress stays on this device until you sign in.'**
  String get progressStaysOnDevice;

  /// No description provided for @profileGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal: {minutes}m'**
  String profileGoalLabel(Object minutes);

  /// No description provided for @profileXpProgress.
  ///
  /// In en, this message translates to:
  /// **'XP Progress'**
  String get profileXpProgress;

  /// No description provided for @profileXpValue.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String profileXpValue(Object xp);

  /// No description provided for @profileWins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get profileWins;

  /// No description provided for @profileStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get profileStreak;

  /// No description provided for @profileFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Friends'**
  String get profileFriendsTitle;

  /// No description provided for @profileViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get profileViewAll;

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profileAchievementsTitle;

  /// No description provided for @profileNoAchievements.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet.'**
  String get profileNoAchievements;

  /// No description provided for @profileRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get profileRequested;

  /// No description provided for @profileSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get profileSending;

  /// No description provided for @profileAddFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get profileAddFriend;

  /// No description provided for @profileConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get profileConnectTitle;

  /// No description provided for @profileMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get profileMessage;

  /// No description provided for @profileSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Profile Snapshot'**
  String get profileSnapshot;

  /// No description provided for @profileLocationHidden.
  ///
  /// In en, this message translates to:
  /// **'Location hidden'**
  String get profileLocationHidden;

  /// No description provided for @profileBioHidden.
  ///
  /// In en, this message translates to:
  /// **'Bio hidden'**
  String get profileBioHidden;

  /// No description provided for @profileDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal {minutes}m'**
  String profileDailyGoal(Object minutes);

  /// No description provided for @circleInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Circle invite'**
  String get circleInviteTitle;

  /// No description provided for @circleIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Circle ID: {id}'**
  String circleIdLabel(Object id);

  /// No description provided for @signInToJoin.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Join'**
  String get signInToJoin;

  /// No description provided for @joiningCircle.
  ///
  /// In en, this message translates to:
  /// **'Joining...'**
  String get joiningCircle;

  /// No description provided for @joinCircle.
  ///
  /// In en, this message translates to:
  /// **'Join Circle'**
  String get joinCircle;

  /// No description provided for @circleJoinedAsPlayer.
  ///
  /// In en, this message translates to:
  /// **'Joined as player'**
  String get circleJoinedAsPlayer;

  /// No description provided for @circleJoinedAsSpectator.
  ///
  /// In en, this message translates to:
  /// **'Joined as spectator'**
  String get circleJoinedAsSpectator;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @circleCountdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Ready'**
  String get circleCountdownTitle;

  /// No description provided for @circleCountdownSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Circle is starting...'**
  String get circleCountdownSubtitle;

  /// No description provided for @userFallbackName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallbackName;

  /// No description provided for @micOff.
  ///
  /// In en, this message translates to:
  /// **'Mic Off'**
  String get micOff;

  /// No description provided for @micOn.
  ///
  /// In en, this message translates to:
  /// **'Mic On'**
  String get micOn;

  /// No description provided for @roleHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get roleHost;

  /// No description provided for @roleSpectator.
  ///
  /// In en, this message translates to:
  /// **'Spectator'**
  String get roleSpectator;

  /// No description provided for @tagHost.
  ///
  /// In en, this message translates to:
  /// **'HOST'**
  String get tagHost;

  /// No description provided for @tagYou.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get tagYou;

  /// No description provided for @statusCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get statusCorrect;

  /// No description provided for @statusWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get statusWrong;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusNone.
  ///
  /// In en, this message translates to:
  /// **'-'**
  String get statusNone;

  /// No description provided for @pointsAbbrev.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get pointsAbbrev;

  /// No description provided for @pointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsLabel;

  /// No description provided for @statCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get statCorrect;

  /// No description provided for @statAnswers.
  ///
  /// In en, this message translates to:
  /// **'answers'**
  String get statAnswers;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @statQuestions.
  ///
  /// In en, this message translates to:
  /// **'questions'**
  String get statQuestions;

  /// No description provided for @statAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get statAccuracy;

  /// No description provided for @statRate.
  ///
  /// In en, this message translates to:
  /// **'rate'**
  String get statRate;

  /// No description provided for @statRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get statRank;

  /// No description provided for @statPosition.
  ///
  /// In en, this message translates to:
  /// **'position'**
  String get statPosition;

  /// No description provided for @statMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get statMode;

  /// No description provided for @statType.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get statType;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToCourse.
  ///
  /// In en, this message translates to:
  /// **'Back to Course'**
  String get backToCourse;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsTitle;

  /// No description provided for @shareLater.
  ///
  /// In en, this message translates to:
  /// **'Share later'**
  String get shareLater;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String minutesShort(Object minutes);

  /// No description provided for @timeShortMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String timeShortMinutes(Object count);

  /// No description provided for @timeShortHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String timeShortHours(Object count);

  /// No description provided for @timeShortDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String timeShortDays(Object count);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String timeMinutesAgo(Object count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String timeHoursAgo(Object count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String timeDaysAgo(Object count);

  /// No description provided for @liveQuizWaitingForHost.
  ///
  /// In en, this message translates to:
  /// **'Waiting for host...'**
  String get liveQuizWaitingForHost;

  /// No description provided for @liveQuizJoinRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Join request sent'**
  String get liveQuizJoinRequestSent;

  /// No description provided for @liveQuizJoinRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to request join: {error}'**
  String liveQuizJoinRequestFailed(Object error);

  /// No description provided for @liveQuizHostControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Host controls'**
  String get liveQuizHostControlsTitle;

  /// No description provided for @liveQuizSpectatorModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Spectator mode'**
  String get liveQuizSpectatorModeTitle;

  /// No description provided for @liveQuizHostControlsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rounds auto-advance when everyone answers or time runs out.'**
  String get liveQuizHostControlsSubtitle;

  /// No description provided for @liveQuizSpectatorModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch questions and the live leaderboard. You can\'t answer.'**
  String get liveQuizSpectatorModeSubtitle;

  /// No description provided for @liveQuizQuestionCounter.
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String liveQuizQuestionCounter(Object current, Object total);

  /// No description provided for @liveQuizRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get liveQuizRequestSent;

  /// No description provided for @liveQuizRequestToJoin.
  ///
  /// In en, this message translates to:
  /// **'Request to Join'**
  String get liveQuizRequestToJoin;

  /// No description provided for @liveQuizSpectatorFooter.
  ///
  /// In en, this message translates to:
  /// **'You\'re watching live. Enjoy the questions and leaderboard.'**
  String get liveQuizSpectatorFooter;

  /// No description provided for @circleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Circle not found'**
  String get circleNotFound;

  /// No description provided for @resultsRematchStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start rematch: {error}'**
  String resultsRematchStartFailed(Object error);

  /// No description provided for @resultsMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Match Results'**
  String get resultsMatchTitle;

  /// No description provided for @resultsNiceWork.
  ///
  /// In en, this message translates to:
  /// **'Nice work, {name}'**
  String resultsNiceWork(Object name);

  /// No description provided for @resultsPlaceFirst.
  ///
  /// In en, this message translates to:
  /// **'1st Place'**
  String get resultsPlaceFirst;

  /// No description provided for @resultsPlaceSecond.
  ///
  /// In en, this message translates to:
  /// **'2nd Place'**
  String get resultsPlaceSecond;

  /// No description provided for @resultsPlaceThird.
  ///
  /// In en, this message translates to:
  /// **'3rd Place'**
  String get resultsPlaceThird;

  /// No description provided for @resultsPlaceNth.
  ///
  /// In en, this message translates to:
  /// **'Place {rank}'**
  String resultsPlaceNth(Object rank);

  /// No description provided for @resultsOutOfPlayers.
  ///
  /// In en, this message translates to:
  /// **'Out of {players} players'**
  String resultsOutOfPlayers(Object players);

  /// No description provided for @resultsHighlightChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion! You dominated this circle.'**
  String get resultsHighlightChampion;

  /// No description provided for @resultsHighlightGreatAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Great accuracy. You\'re close to the top!'**
  String get resultsHighlightGreatAccuracy;

  /// No description provided for @resultsHighlightKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going - consistency beats speed.'**
  String get resultsHighlightKeepGoing;

  /// No description provided for @resultsLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get resultsLeaderboardTitle;

  /// No description provided for @resultsPlayersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} players'**
  String resultsPlayersCount(Object count);

  /// No description provided for @resultsBackToCircles.
  ///
  /// In en, this message translates to:
  /// **'Back to Circles'**
  String get resultsBackToCircles;

  /// No description provided for @resultsRematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get resultsRematch;

  /// No description provided for @resultsPlayAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get resultsPlayAgain;

  /// No description provided for @leaderboardGlobalTitle.
  ///
  /// In en, this message translates to:
  /// **'Global Ranking'**
  String get leaderboardGlobalTitle;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rankings yet.'**
  String get leaderboardEmpty;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(Object version);

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'SOMA is a gamified language learning platform designed to make mastering new languages engaging and social. Compete in circles, practice solo, and track your progress.'**
  String get aboutDescription;

  /// No description provided for @aboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTerms;

  /// No description provided for @aboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacy;

  /// No description provided for @aboutOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutOpenSource;

  /// No description provided for @addFriendTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriendTitle;

  /// No description provided for @addFriendFindByUsername.
  ///
  /// In en, this message translates to:
  /// **'Find by username'**
  String get addFriendFindByUsername;

  /// No description provided for @addFriendUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Type username...'**
  String get addFriendUsernameHint;

  /// No description provided for @addFriendTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: later we can support QR code + friend ID.'**
  String get addFriendTip;

  /// No description provided for @addFriendSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get addFriendSending;

  /// No description provided for @addFriendSendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get addFriendSendRequest;

  /// No description provided for @addFriendUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User @{username} not found'**
  String addFriendUserNotFound(Object username);

  /// No description provided for @addFriendRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed or already sent: {error}'**
  String addFriendRequestFailed(Object error);

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @searchFriendsHint.
  ///
  /// In en, this message translates to:
  /// **'Search friends...'**
  String get searchFriendsHint;

  /// No description provided for @somaLearnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soma Learner'**
  String get somaLearnerSubtitle;

  /// No description provided for @friendRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get friendRequestLabel;

  /// No description provided for @friendRequestSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get friendRequestSentLabel;

  /// No description provided for @friendIncomingRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Incoming Request'**
  String get friendIncomingRequestLabel;

  /// No description provided for @friendRequestsSection.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get friendRequestsSection;

  /// No description provided for @friendPendingSection.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get friendPendingSection;

  /// No description provided for @friendAllSection.
  ///
  /// In en, this message translates to:
  /// **'All Friends'**
  String get friendAllSection;

  /// No description provided for @friendsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No friends yet. Add your first friend!'**
  String get friendsEmptyState;

  /// No description provided for @friendsEmptyShort.
  ///
  /// In en, this message translates to:
  /// **'No friends yet.'**
  String get friendsEmptyShort;

  /// No description provided for @noMatchForQuery.
  ///
  /// In en, this message translates to:
  /// **'No match for \"{query}\"'**
  String noMatchForQuery(Object query);

  /// No description provided for @inboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inboxTitle;

  /// No description provided for @searchChatsHint.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChatsHint;

  /// No description provided for @inboxEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet. Start chatting with a friend!'**
  String get inboxEmptyState;

  /// No description provided for @newMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessageTitle;

  /// No description provided for @chatCallLater.
  ///
  /// In en, this message translates to:
  /// **'Voice call later (Circle voice is next)'**
  String get chatCallLater;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(Object error);

  /// No description provided for @chatSayHi.
  ///
  /// In en, this message translates to:
  /// **'Say hi to {name}!'**
  String chatSayHi(Object name);

  /// No description provided for @chatMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get chatMessageHint;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsTabAll;

  /// No description provided for @notificationsTabCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get notificationsTabCourses;

  /// No description provided for @notificationsTabSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get notificationsTabSocial;

  /// No description provided for @notificationsTabCircles.
  ///
  /// In en, this message translates to:
  /// **'Circles'**
  String get notificationsTabCircles;

  /// No description provided for @notificationsTabSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationsTabSystem;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications here.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationsDeleted;

  /// No description provided for @notificationTitleFallback.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationTitleFallback;

  /// No description provided for @notificationTypeCourse.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get notificationTypeCourse;

  /// No description provided for @notificationTypeSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get notificationTypeSocial;

  /// No description provided for @notificationTypeCircle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get notificationTypeCircle;

  /// No description provided for @notificationTypeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notificationTypeSystem;

  /// No description provided for @notificationsFriendAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get notificationsFriendAccepted;

  /// No description provided for @notificationsFriendAcceptFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t accept friend request: {error}'**
  String notificationsFriendAcceptFailed(Object error);

  /// No description provided for @notificationsFriendDeclined.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined'**
  String get notificationsFriendDeclined;

  /// No description provided for @notificationsFriendDeclineFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t decline friend request: {error}'**
  String notificationsFriendDeclineFailed(Object error);

  /// No description provided for @notificationsJoinCircleFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join circle: {error}'**
  String notificationsJoinCircleFailed(Object error);

  /// No description provided for @notificationsOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get notificationsOpening;

  /// No description provided for @notificationsOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get notificationsOpened;

  /// No description provided for @notificationsActionMessage.
  ///
  /// In en, this message translates to:
  /// **'{action} notification'**
  String notificationsActionMessage(Object action);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsSectionGameplay.
  ///
  /// In en, this message translates to:
  /// **'Gameplay'**
  String get settingsSectionGameplay;

  /// No description provided for @settingsShowTranslationLine.
  ///
  /// In en, this message translates to:
  /// **'Show translation line'**
  String get settingsShowTranslationLine;

  /// No description provided for @settingsShowReadingLine.
  ///
  /// In en, this message translates to:
  /// **'Show reading (pinyin/transliteration/romanisation)'**
  String get settingsShowReadingLine;

  /// No description provided for @settingsDefaultTimerPerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Default timer per question'**
  String get settingsDefaultTimerPerQuestion;

  /// No description provided for @settingsMatchDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Match difficulty'**
  String get settingsMatchDifficulty;

  /// No description provided for @settingsMatchDifficultyAdaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get settingsMatchDifficultyAdaptive;

  /// No description provided for @settingsSectionSoundFeel.
  ///
  /// In en, this message translates to:
  /// **'Sound & Feel'**
  String get settingsSectionSoundFeel;

  /// No description provided for @settingsMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get settingsMusic;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get settingsSoundEffects;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get settingsHaptics;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settingsPushNotifications;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get settingsDailyReminder;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsUiLanguage.
  ///
  /// In en, this message translates to:
  /// **'UI language'**
  String get settingsUiLanguage;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsTermsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get settingsTermsPrivacy;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settingsLogout;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBengali;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageUrdu;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get languageThai;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get languageUkrainian;

  /// No description provided for @languageDutch.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageDutch;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get languagePersian;

  /// No description provided for @languagePunjabi.
  ///
  /// In en, this message translates to:
  /// **'Punjabi'**
  String get languagePunjabi;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamil;

  /// No description provided for @languageTelugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get languageTelugu;

  /// No description provided for @languageSwahili.
  ///
  /// In en, this message translates to:
  /// **'Swahili'**
  String get languageSwahili;

  /// No description provided for @languageMalay.
  ///
  /// In en, this message translates to:
  /// **'Malay'**
  String get languageMalay;

  /// No description provided for @languageRomanian.
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get languageRomanian;

  /// No description provided for @languageGreek.
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get languageGreek;

  /// No description provided for @languageHungarian.
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get languageHungarian;

  /// No description provided for @languageCzech.
  ///
  /// In en, this message translates to:
  /// **'Czech'**
  String get languageCzech;

  /// No description provided for @languageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get languageSwedish;

  /// No description provided for @languageHebrew.
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get languageHebrew;

  /// No description provided for @languageNorwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get languageNorwegian;

  /// No description provided for @languageDanish.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get languageDanish;

  /// No description provided for @languageFinnish.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get languageFinnish;

  /// No description provided for @editProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get editProfileUpdated;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfilePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get editProfilePhotoLabel;

  /// No description provided for @editProfilePhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Avatar selection via Supabase Storage upcoming.'**
  String get editProfilePhotoSubtitle;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileAvatarUploadSoon.
  ///
  /// In en, this message translates to:
  /// **'Avatar upload coming soon'**
  String get editProfileAvatarUploadSoon;

  /// No description provided for @editProfileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get editProfileDisplayNameLabel;

  /// No description provided for @editProfileDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get editProfileDisplayNameHint;

  /// No description provided for @editProfileDisplayNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get editProfileDisplayNameRequired;

  /// No description provided for @editProfileDisplayNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Too short'**
  String get editProfileDisplayNameTooShort;

  /// No description provided for @editProfileUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editProfileUsernameLabel;

  /// No description provided for @editProfileUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'alex_learner'**
  String get editProfileUsernameHint;

  /// No description provided for @editProfileUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get editProfileUsernameRequired;

  /// No description provided for @editProfileUsernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Min 3 characters'**
  String get editProfileUsernameTooShort;

  /// No description provided for @editProfileUsernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers, _'**
  String get editProfileUsernameInvalid;

  /// No description provided for @editProfileBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editProfileBioLabel;

  /// No description provided for @editProfileBioHint.
  ///
  /// In en, this message translates to:
  /// **'Short bio...'**
  String get editProfileBioHint;

  /// No description provided for @editProfileBioTooLong.
  ///
  /// In en, this message translates to:
  /// **'Max 120 chars'**
  String get editProfileBioTooLong;

  /// No description provided for @editProfileLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editProfileLocationLabel;

  /// No description provided for @editProfileLocationHint.
  ///
  /// In en, this message translates to:
  /// **'City / Country'**
  String get editProfileLocationHint;

  /// No description provided for @editProfileDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get editProfileDailyGoalTitle;

  /// No description provided for @editProfileDailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how many minutes you want to study daily.'**
  String get editProfileDailyGoalSubtitle;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @securitySectionPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get securitySectionPassword;

  /// No description provided for @securityChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get securityChangePasswordTitle;

  /// No description provided for @securityChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password regularly.'**
  String get securityChangePasswordSubtitle;

  /// No description provided for @securitySectionTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get securitySectionTwoFactor;

  /// No description provided for @securityEnable2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA'**
  String get securityEnable2faTitle;

  /// No description provided for @securityEnable2faSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Extra protection when signing in.'**
  String get securityEnable2faSubtitle;

  /// No description provided for @securitySectionAppLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get securitySectionAppLock;

  /// No description provided for @securityBiometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock'**
  String get securityBiometricTitle;

  /// No description provided for @securityBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use FaceID/TouchID to unlock SOMA.'**
  String get securityBiometricSubtitle;

  /// No description provided for @securityAppLockTitle.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get securityAppLockTitle;

  /// No description provided for @securityAppLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lock SOMA when you leave the app.'**
  String get securityAppLockSubtitle;

  /// No description provided for @securitySectionSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get securitySectionSessions;

  /// No description provided for @securityNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions found.'**
  String get securityNoSessions;

  /// No description provided for @securityThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get securityThisDevice;

  /// No description provided for @securityDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get securityDevice;

  /// No description provided for @securityActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get securityActiveLabel;

  /// No description provided for @securitySignInToEnable2fa.
  ///
  /// In en, this message translates to:
  /// **'Sign in to enable 2FA'**
  String get securitySignInToEnable2fa;

  /// No description provided for @securityEnable2faFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t enable 2FA: {error}'**
  String securityEnable2faFailed(Object error);

  /// No description provided for @securityDisable2faFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t disable 2FA: {error}'**
  String securityDisable2faFailed(Object error);

  /// No description provided for @securitySetup2faTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up 2FA'**
  String get securitySetup2faTitle;

  /// No description provided for @securitySecretKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Secret key'**
  String get securitySecretKeyLabel;

  /// No description provided for @securityCodeHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get securityCodeHint;

  /// No description provided for @security2faEnabled.
  ///
  /// In en, this message translates to:
  /// **'2FA enabled'**
  String get security2faEnabled;

  /// No description provided for @securityVerifyCodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify code: {error}'**
  String securityVerifyCodeFailed(Object error);

  /// No description provided for @securityVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get securityVerifying;

  /// No description provided for @securityVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get securityVerify;

  /// No description provided for @securityCurrentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get securityCurrentPasswordHint;

  /// No description provided for @securityNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New password (min 8 chars)'**
  String get securityNewPasswordHint;

  /// No description provided for @securityConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get securityConfirmPasswordHint;

  /// No description provided for @securitySignInToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Sign in to change your password'**
  String get securitySignInToChangePassword;

  /// No description provided for @securityEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get securityEnterCurrentPassword;

  /// No description provided for @securityPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 8 characters'**
  String get securityPasswordMinLength;

  /// No description provided for @securityPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get securityPasswordsDoNotMatch;

  /// No description provided for @securityPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get securityPasswordUpdated;

  /// No description provided for @securityPasswordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update password: {error}'**
  String securityPasswordUpdateFailed(Object error);

  /// No description provided for @securityAutoLockAfter.
  ///
  /// In en, this message translates to:
  /// **'Auto lock after'**
  String get securityAutoLockAfter;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacySectionVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get privacySectionVisibility;

  /// No description provided for @privacyProfileVisibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility'**
  String get privacyProfileVisibilityTitle;

  /// No description provided for @privacyVisibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get privacyVisibilityPublic;

  /// No description provided for @privacyVisibilityFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get privacyVisibilityFriends;

  /// No description provided for @privacyVisibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privacyVisibilityPrivate;

  /// No description provided for @privacyVisibilityPublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anyone can view your profile.'**
  String get privacyVisibilityPublicSubtitle;

  /// No description provided for @privacyVisibilityFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only friends can view your profile.'**
  String get privacyVisibilityFriendsSubtitle;

  /// No description provided for @privacyVisibilityPrivateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only you can view your profile.'**
  String get privacyVisibilityPrivateSubtitle;

  /// No description provided for @privacySectionActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get privacySectionActivity;

  /// No description provided for @privacyShowOnlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Show online status'**
  String get privacyShowOnlineTitle;

  /// No description provided for @privacyShowOnlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let others see when you\'re online.'**
  String get privacyShowOnlineSubtitle;

  /// No description provided for @privacyShowActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Show learning activity'**
  String get privacyShowActivityTitle;

  /// No description provided for @privacyShowActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show streak, XP, and recent progress.'**
  String get privacyShowActivitySubtitle;

  /// No description provided for @privacySectionSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get privacySectionSocial;

  /// No description provided for @privacyAllowRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow friend requests'**
  String get privacyAllowRequestsTitle;

  /// No description provided for @privacyAllowRequestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let people send you friend requests.'**
  String get privacyAllowRequestsSubtitle;

  /// No description provided for @privacyWhoCanDmTitle.
  ///
  /// In en, this message translates to:
  /// **'Who can DM you'**
  String get privacyWhoCanDmTitle;

  /// No description provided for @privacyDmEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get privacyDmEveryone;

  /// No description provided for @privacyDmFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get privacyDmFriends;

  /// No description provided for @privacyDmNoOne.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get privacyDmNoOne;

  /// No description provided for @privacyDmEveryoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anyone can message you.'**
  String get privacyDmEveryoneSubtitle;

  /// No description provided for @privacyDmFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only friends can message you.'**
  String get privacyDmFriendsSubtitle;

  /// No description provided for @privacyDmNoOneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nobody can message you.'**
  String get privacyDmNoOneSubtitle;

  /// No description provided for @privacySectionBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get privacySectionBlockedUsers;

  /// No description provided for @privacyBlockedUsersComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Blocked users management coming soon.'**
  String get privacyBlockedUsersComingSoon;

  /// No description provided for @privacySectionDataControls.
  ///
  /// In en, this message translates to:
  /// **'Data controls'**
  String get privacySectionDataControls;

  /// No description provided for @privacyExportDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Export my data'**
  String get privacyExportDataTitle;

  /// No description provided for @privacyExportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download your activity and courses.'**
  String get privacyExportDataSubtitle;

  /// No description provided for @privacyExportInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get privacyExportInfoTitle;

  /// No description provided for @privacyExportInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Next step: generate a JSON/CSV export and email it or download locally.'**
  String get privacyExportInfoBody;

  /// No description provided for @privacyDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get privacyDeleteAccountTitle;

  /// No description provided for @privacyDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your account and data.'**
  String get privacyDeleteAccountSubtitle;

  /// No description provided for @privacyDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get privacyDeleteConfirmTitle;

  /// No description provided for @privacyDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Your profile, courses, friends, and messages will be removed.'**
  String get privacyDeleteConfirmBody;

  /// No description provided for @privacyDeleteComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Delete will be wired to Supabase later'**
  String get privacyDeleteComingSoon;

  /// No description provided for @soloLabel.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get soloLabel;

  /// No description provided for @soloResultsCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Solo Session Completed'**
  String get soloResultsCompletedTitle;

  /// No description provided for @soloResultsFeedbackElite.
  ///
  /// In en, this message translates to:
  /// **'Elite performance. Keep the streak'**
  String get soloResultsFeedbackElite;

  /// No description provided for @soloResultsFeedbackStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong work. You\'re improving fast.'**
  String get soloResultsFeedbackStrong;

  /// No description provided for @soloResultsFeedbackProgress.
  ///
  /// In en, this message translates to:
  /// **'Good progress. Review mistakes and repeat.'**
  String get soloResultsFeedbackProgress;

  /// No description provided for @soloResultsFeedbackTryAgain.
  ///
  /// In en, this message translates to:
  /// **'No stress. Try again with fewer questions and focus.'**
  String get soloResultsFeedbackTryAgain;

  /// No description provided for @soloResultsPerfectScore.
  ///
  /// In en, this message translates to:
  /// **'Perfect score! No mistakes to review.'**
  String get soloResultsPerfectScore;

  /// No description provided for @soloResultsReviewPrompt.
  ///
  /// In en, this message translates to:
  /// **'Review mistakes to learn faster. We\'ll show wrong answers here next.'**
  String get soloResultsReviewPrompt;

  /// No description provided for @soloResultsReviewMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review Mistakes ({count})'**
  String soloResultsReviewMistakes(Object count);

  /// No description provided for @authNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in'**
  String get authNotSignedIn;

  /// No description provided for @genericUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get genericUser;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @questionsShort.
  ///
  /// In en, this message translates to:
  /// **'{count} Q'**
  String questionsShort(Object count);

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String secondsShort(Object count);

  /// No description provided for @circlesAllCourses.
  ///
  /// In en, this message translates to:
  /// **'All courses'**
  String get circlesAllCourses;

  /// No description provided for @circlesAllModes.
  ///
  /// In en, this message translates to:
  /// **'All modes'**
  String get circlesAllModes;

  /// No description provided for @circlesAllLevels.
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get circlesAllLevels;

  /// No description provided for @circlesAddNewCourse.
  ///
  /// In en, this message translates to:
  /// **'Add new course'**
  String get circlesAddNewCourse;

  /// No description provided for @circlesCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get circlesCoursesTitle;

  /// No description provided for @circlesModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get circlesModeTitle;

  /// No description provided for @circlesLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get circlesLevelTitle;

  /// No description provided for @circlesNoActiveForFilters.
  ///
  /// In en, this message translates to:
  /// **'No active circles for these filters.'**
  String get circlesNoActiveForFilters;

  /// No description provided for @circlesUnknownRoom.
  ///
  /// In en, this message translates to:
  /// **'Unknown room'**
  String get circlesUnknownRoom;

  /// No description provided for @circlesRoomLine.
  ///
  /// In en, this message translates to:
  /// **'{from} -> {to} - {mode} - {level}'**
  String circlesRoomLine(Object from, Object to, Object mode, Object level);

  /// No description provided for @circlesCreateCircle.
  ///
  /// In en, this message translates to:
  /// **'Create Circle'**
  String get circlesCreateCircle;

  /// No description provided for @circlesCircleName.
  ///
  /// In en, this message translates to:
  /// **'Circle name'**
  String get circlesCircleName;

  /// No description provided for @circlesEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get circlesEnterName;

  /// No description provided for @circlesLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get circlesLanguages;

  /// No description provided for @circlesRoomSetup.
  ///
  /// In en, this message translates to:
  /// **'Room setup'**
  String get circlesRoomSetup;

  /// No description provided for @circlesPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get circlesPlayers;

  /// No description provided for @circlesEmptySlot.
  ///
  /// In en, this message translates to:
  /// **'Empty slot'**
  String get circlesEmptySlot;

  /// No description provided for @circlesPlayersRange.
  ///
  /// In en, this message translates to:
  /// **'1-5 players'**
  String get circlesPlayersRange;

  /// No description provided for @circlesQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get circlesQuestions;

  /// No description provided for @circlesQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How many questions'**
  String get circlesQuestionsSubtitle;

  /// No description provided for @circlesTimePerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Time per question'**
  String get circlesTimePerQuestion;

  /// No description provided for @circlesSecondsPerQuestion.
  ///
  /// In en, this message translates to:
  /// **'seconds per question'**
  String get circlesSecondsPerQuestion;

  /// No description provided for @circlesAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get circlesAdvanced;

  /// No description provided for @circlesAllowSpectators.
  ///
  /// In en, this message translates to:
  /// **'Allow spectators'**
  String get circlesAllowSpectators;

  /// No description provided for @circlesAllowSpectatorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let others watch without playing.'**
  String get circlesAllowSpectatorsSubtitle;

  /// No description provided for @circlesLiveVoiceChat.
  ///
  /// In en, this message translates to:
  /// **'Live voice chat'**
  String get circlesLiveVoiceChat;

  /// No description provided for @circlesLiveVoiceChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable live voice during matches.'**
  String get circlesLiveVoiceChatSubtitle;

  /// No description provided for @circlesLiveTextChat.
  ///
  /// In en, this message translates to:
  /// **'Live text chat'**
  String get circlesLiveTextChat;

  /// No description provided for @circlesLiveTextChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable chat during matches.'**
  String get circlesLiveTextChatSubtitle;

  /// No description provided for @circlesRoomLocked.
  ///
  /// In en, this message translates to:
  /// **'Room locked'**
  String get circlesRoomLocked;

  /// No description provided for @circlesRoomUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Room unlocked'**
  String get circlesRoomUnlocked;

  /// No description provided for @circlesSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Room settings saved'**
  String get circlesSettingsSaved;

  /// No description provided for @circlesUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update room: {error}'**
  String circlesUpdateFailed(Object error);

  /// No description provided for @circlesLiveChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Live chat'**
  String get circlesLiveChatTitle;

  /// No description provided for @circlesLiveChatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get circlesLiveChatPlaceholder;

  /// No description provided for @circlesLiveChatEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Start the chat!'**
  String get circlesLiveChatEmpty;

  /// No description provided for @circlesLiveChatUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Live chat is available inside active circles.'**
  String get circlesLiveChatUnavailable;

  /// No description provided for @circlesCreateHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a circle'**
  String get circlesCreateHelpTitle;

  /// No description provided for @circlesCreateHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Choose your languages, mode, and difficulty, then set room limits. Spectators can watch, and live chat lets everyone talk during the match.'**
  String get circlesCreateHelpBody;

  /// No description provided for @circlesCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Circle created'**
  String get circlesCreatedSuccess;

  /// No description provided for @circlesCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create circle: {error}'**
  String circlesCreateError(Object error);

  /// No description provided for @circlesHostTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: you can invite friends after creating.'**
  String get circlesHostTip;

  /// No description provided for @circlesJoinError.
  ///
  /// In en, this message translates to:
  /// **'Failed to join circle: {error}'**
  String circlesJoinError(Object error);

  /// No description provided for @circlesLobbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Circle lobby'**
  String get circlesLobbyTitle;

  /// No description provided for @circlesCodeLine.
  ///
  /// In en, this message translates to:
  /// **'Code: {code} - {current}/{max}'**
  String circlesCodeLine(Object code, Object current, Object max);

  /// No description provided for @circlesMatchSettings.
  ///
  /// In en, this message translates to:
  /// **'Match settings'**
  String get circlesMatchSettings;

  /// No description provided for @circlesLevelWithValue.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String circlesLevelWithValue(Object level);

  /// No description provided for @circlesDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get circlesDifficulty;

  /// No description provided for @circlesPerQuestionShort.
  ///
  /// In en, this message translates to:
  /// **'per question'**
  String get circlesPerQuestionShort;

  /// No description provided for @circlesInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get circlesInvite;

  /// No description provided for @circlesCopyId.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get circlesCopyId;

  /// No description provided for @circlesCopiedId.
  ///
  /// In en, this message translates to:
  /// **'ID copied'**
  String get circlesCopiedId;

  /// No description provided for @circlesMatchInProgress.
  ///
  /// In en, this message translates to:
  /// **'Match in progress'**
  String get circlesMatchInProgress;

  /// No description provided for @circlesSpectatorQueuedBody.
  ///
  /// In en, this message translates to:
  /// **'Match is in progress. You\'ll join as spectator.'**
  String get circlesSpectatorQueuedBody;

  /// No description provided for @circlesHostStartWhenReady.
  ///
  /// In en, this message translates to:
  /// **'Host starts when everyone is ready.'**
  String get circlesHostStartWhenReady;

  /// No description provided for @circlesSpectators.
  ///
  /// In en, this message translates to:
  /// **'Spectators'**
  String get circlesSpectators;

  /// No description provided for @circlesSpectator.
  ///
  /// In en, this message translates to:
  /// **'Spectator'**
  String get circlesSpectator;

  /// No description provided for @circlesSpectatorCanWatch.
  ///
  /// In en, this message translates to:
  /// **'Spectators can watch live.'**
  String get circlesSpectatorCanWatch;

  /// No description provided for @circlesJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'Join requests'**
  String get circlesJoinRequests;

  /// No description provided for @circlesAcceptSpectatorsHint.
  ///
  /// In en, this message translates to:
  /// **'Accept spectators before the match starts.'**
  String get circlesAcceptSpectatorsHint;

  /// No description provided for @circlesStartGame.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get circlesStartGame;

  /// No description provided for @circlesWaitingForPlayers.
  ///
  /// In en, this message translates to:
  /// **'Waiting for players'**
  String get circlesWaitingForPlayers;

  /// No description provided for @circlesLeaveCircle.
  ///
  /// In en, this message translates to:
  /// **'Leave circle'**
  String get circlesLeaveCircle;

  /// No description provided for @circlesRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get circlesRequestSent;

  /// No description provided for @circlesRequestToJoin.
  ///
  /// In en, this message translates to:
  /// **'Request to Join'**
  String get circlesRequestToJoin;

  /// No description provided for @circlesWatchLive.
  ///
  /// In en, this message translates to:
  /// **'Watch live'**
  String get circlesWatchLive;

  /// No description provided for @circlesPlayerTip.
  ///
  /// In en, this message translates to:
  /// **'Tap Ready when you\'re set. Host will start the match.'**
  String get circlesPlayerTip;

  /// No description provided for @circlesSpectatorTip.
  ///
  /// In en, this message translates to:
  /// **'You\'re spectating. Watch live once the host starts.'**
  String get circlesSpectatorTip;

  /// No description provided for @circlesHostControls.
  ///
  /// In en, this message translates to:
  /// **'Host controls'**
  String get circlesHostControls;

  /// No description provided for @circlesTransferHostFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to transfer host: {error}'**
  String circlesTransferHostFailed(Object error);

  /// No description provided for @circlesEndCircleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to end circle: {error}'**
  String circlesEndCircleFailed(Object error);

  /// No description provided for @circlesUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User @{username} not found'**
  String circlesUserNotFound(Object username);

  /// No description provided for @circlesInvalidUser.
  ///
  /// In en, this message translates to:
  /// **'Invalid user'**
  String get circlesInvalidUser;

  /// No description provided for @circlesCantInviteSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t invite yourself'**
  String get circlesCantInviteSelf;

  /// No description provided for @circlesUserAlreadyInCircle.
  ///
  /// In en, this message translates to:
  /// **'User @{username} is already in the circle'**
  String circlesUserAlreadyInCircle(Object username);

  /// No description provided for @circlesDefaultHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get circlesDefaultHost;

  /// No description provided for @circlesDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get circlesDefaultTitle;

  /// No description provided for @circlesInviteByUsername.
  ///
  /// In en, this message translates to:
  /// **'Invite by username'**
  String get circlesInviteByUsername;

  /// No description provided for @circlesInviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent to @{username}'**
  String circlesInviteSent(Object username);

  /// No description provided for @circlesInviteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send invite: {error}'**
  String circlesInviteFailed(Object error);

  /// No description provided for @circlesJoinRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Join request sent'**
  String get circlesJoinRequestSent;

  /// No description provided for @circlesJoinRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to request join: {error}'**
  String circlesJoinRequestFailed(Object error);

  /// No description provided for @circlesFull.
  ///
  /// In en, this message translates to:
  /// **'Circle is full'**
  String get circlesFull;

  /// No description provided for @circlesSpectatorAdded.
  ///
  /// In en, this message translates to:
  /// **'Spectator added'**
  String get circlesSpectatorAdded;

  /// No description provided for @circlesApproveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve request: {error}'**
  String circlesApproveFailed(Object error);

  /// No description provided for @circlesRequestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get circlesRequestDeclined;

  /// No description provided for @circlesDeclineFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to decline request: {error}'**
  String circlesDeclineFailed(Object error);

  /// No description provided for @circlesParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get circlesParticipant;

  /// No description provided for @circlesLeavePromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave circle?'**
  String get circlesLeavePromptTitle;

  /// No description provided for @circlesLeavePromptTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer host before leaving.'**
  String get circlesLeavePromptTransfer;

  /// No description provided for @circlesLeavePromptEndOnly.
  ///
  /// In en, this message translates to:
  /// **'End the circle and leave.'**
  String get circlesLeavePromptEndOnly;

  /// No description provided for @circlesTransferHost.
  ///
  /// In en, this message translates to:
  /// **'Transfer host'**
  String get circlesTransferHost;

  /// No description provided for @circlesEndCircle.
  ///
  /// In en, this message translates to:
  /// **'End circle'**
  String get circlesEndCircle;

  /// No description provided for @circlesTransferHostTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer host'**
  String get circlesTransferHostTitle;

  /// No description provided for @circlesShareId.
  ///
  /// In en, this message translates to:
  /// **'Circle ID: {id}'**
  String circlesShareId(Object id);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'cs',
        'da',
        'de',
        'el',
        'en',
        'es',
        'fa',
        'fi',
        'fr',
        'he',
        'hi',
        'hu',
        'id',
        'it',
        'ja',
        'ko',
        'ms',
        'nl',
        'no',
        'pa',
        'pl',
        'pt',
        'ro',
        'ru',
        'sv',
        'sw',
        'ta',
        'te',
        'th',
        'tr',
        'uk',
        'ur',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
