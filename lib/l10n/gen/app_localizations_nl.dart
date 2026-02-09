// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Leren. Concurreren. Beheersen.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Aanmelden';

  @override
  String get signIn => 'Inloggen';

  @override
  String get skipForNow => 'Nu Overslaan';

  @override
  String get authFillAllFields => 'Vul alle velden in';

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
    return 'Fout: $error';
  }

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Wachtwoord';

  @override
  String get authUsername => 'Gebruikersnaam';

  @override
  String get authContinue => 'Doorgaan';

  @override
  String get authSigningIn => 'Inloggen...';

  @override
  String get authCreateAccount => 'Account Aanmaken';

  @override
  String get authCreating => 'Aanmaken...';

  @override
  String get authNeedAccount => 'Nog geen account? ';

  @override
  String get authHaveAccount => 'Al een account? ';

  @override
  String get dialogAuthRequiredTitle => 'Log in om Circles te openen';

  @override
  String get dialogAuthRequiredBody =>
      'Circles zijn multiplayer ruimtes. Maak een account aan om live wedstrijden te spelen, vrienden uit te nodigen en je voortgang op te slaan.';

  @override
  String get notNow => 'Niet Nu';

  @override
  String get navHome => 'Home';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profiel';

  @override
  String get removeCourseTitle => 'Cursus Verwijderen?';

  @override
  String removeCourseBody(Object course) {
    return '$course verwijderen van je startlijst.';
  }

  @override
  String get cancel => 'Annuleren';

  @override
  String get remove => 'Verwijderen';

  @override
  String welcomeBack(Object name) {
    return 'Welkom terug, $name!';
  }

  @override
  String get editCourses => 'Cursussen Bewerken';

  @override
  String get done => 'Klaar';

  @override
  String get noCoursesToEdit => 'Geen cursussen om te bewerken.';

  @override
  String get addCourse => 'Cursus Toevoegen';

  @override
  String get unknown => 'Onbekend';

  @override
  String get iSpeak => 'Ik Spreek';

  @override
  String get iWantToLearn => 'Ik Wil Leren';

  @override
  String get chooseYourLanguage => 'Kies Je Taal';

  @override
  String get chooseLearningLanguage => 'Kies de taal die je wilt leren';

  @override
  String get chooseTwoDifferentLanguages => 'Kies twee verschillende talen.';

  @override
  String get createCourse => 'Cursus Maken';

  @override
  String get soloCourseTitle => 'Solo Cursus';

  @override
  String get searchLanguage => 'Zoek Taal';

  @override
  String get noMatches => 'Geen Resultaten';

  @override
  String get chooseCourseType => 'Kies Cursustype';

  @override
  String get soloStudyDescription =>
      'Studeer alleen met Circles-stijl quizzen - geen ruimtes, chat, toeschouwers of hostopties.';

  @override
  String get soloModeVocabulary => 'Woordenschat';

  @override
  String get soloModeSentences => 'Zinnen';

  @override
  String get soloModeReview => 'Herhaling';

  @override
  String get soloModeVocabularySubtitle =>
      'Meerkeuzevragen over betekenis, synoniemen, gebruik';

  @override
  String get soloModeSentencesSubtitle =>
      'Invuloefeningen + vertalingen + uitspraak';

  @override
  String get soloModeReviewDescription =>
      'Oefen wat je hebt geleerd: zwakke woorden, recente fouten, gespreide herhaling.';

  @override
  String get startReview => 'Start Herhaling';

  @override
  String soloSetupTitle(Object mode) {
    return '$mode Instellingen';
  }

  @override
  String get difficulty => 'Moeilijkheidsgraad';

  @override
  String get numberOfQuestions => 'Aantal Vragen';

  @override
  String get timerPerQuestion => 'Timer per Vraag';

  @override
  String get noTimer => 'Geen Timer';

  @override
  String get start => 'Start';

  @override
  String get profileTitle => 'Profiel';

  @override
  String get profileSignInToMessage => 'Log in om te chatten';

  @override
  String get profileThatsYourProfile => 'Dit is jouw profiel';

  @override
  String get profileSignInToAddFriends => 'Log in om vrienden toe te voegen';

  @override
  String get profileCantAddYourself => 'Je kunt jezelf niet toevoegen';

  @override
  String profileRequestSent(Object username) {
    return 'Verzoek verzonden naar @$username';
  }

  @override
  String get profileRequestFailed => 'Verzoek verzenden mislukt';

  @override
  String get profileDefaultDisplayName => 'Nieuwe Gebruiker';

  @override
  String get profileDefaultBio => 'Klaar om te leren!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Gast';

  @override
  String get guestUsername => 'gast';

  @override
  String get guestSessionLabel => 'Gastsessie';

  @override
  String get unlockFullProfile => 'Ontgrendel Volledig Profiel';

  @override
  String get guestBenefitSync => 'Synchroniseer voortgang op alle apparaten';

  @override
  String get guestBenefitCircles => 'Doe mee aan Circles voor live spelen';

  @override
  String get guestBenefitNotifications =>
      'Ontvang meldingen en vriendverzoeken';

  @override
  String get progressStaysOnDevice =>
      'Totdat je inlogt, blijft je voortgang op dit apparaat.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Doel: $minutes min';
  }

  @override
  String get profileXpProgress => 'XP Voortgang';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Overwinningen';

  @override
  String get profileStreak => 'Reeks';

  @override
  String get profileFriendsTitle => 'Vrienden';

  @override
  String get profileViewAll => 'Bekijk Alles';

  @override
  String get profileAchievementsTitle => 'Prestaties';

  @override
  String get profileNoAchievements => 'Nog geen prestaties.';

  @override
  String get profileRequested => 'Verzocht';

  @override
  String get profileSending => 'Verzenden...';

  @override
  String get profileAddFriend => 'Vriend Toevoegen';

  @override
  String get profileConnectTitle => 'Verbinden';

  @override
  String get profileMessage => 'Bericht';

  @override
  String get profileSnapshot => 'Profiel Snapshot';

  @override
  String get profileLocationHidden => 'Locatie Verborgen';

  @override
  String get profileBioHidden => 'Bio Verborgen';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Dagelijks Doel $minutes min';
  }

  @override
  String get circleInviteTitle => 'Circle Uitnodiging';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'Log in om deel te nemen';

  @override
  String get joiningCircle => 'Deelnemen...';

  @override
  String get joinCircle => 'Deelnemen aan Circle';

  @override
  String get circleJoinedAsPlayer => 'Deelgenomen als speler';

  @override
  String get circleJoinedAsSpectator => 'Deelgenomen als toeschouwer';

  @override
  String get accept => 'Accepteren';

  @override
  String get decline => 'Weigeren';

  @override
  String get open => 'Openen';

  @override
  String get circleCountdownTitle => 'Maak je klaar';

  @override
  String get circleCountdownSubtitle => 'Circle begint...';

  @override
  String get userFallbackName => 'Gebruiker';

  @override
  String get micOff => 'Microfoon Uit';

  @override
  String get micOn => 'Microfoon Aan';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'Toeschouwer';

  @override
  String get tagHost => 'Host';

  @override
  String get tagYou => 'Jij';

  @override
  String get statusCorrect => 'Correct';

  @override
  String get statusWrong => 'Fout';

  @override
  String get statusWaiting => 'Wachten';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'ptn';

  @override
  String get pointsLabel => 'Punten';

  @override
  String get statCorrect => 'Correct';

  @override
  String get statAnswers => 'Antwoorden';

  @override
  String get statTotal => 'Totaal';

  @override
  String get statQuestions => 'Vragen';

  @override
  String get statAccuracy => 'Nauwkeurigheid';

  @override
  String get statRate => 'Percentage';

  @override
  String get statRank => 'Rang';

  @override
  String get statPosition => 'Positie';

  @override
  String get statMode => 'Modus';

  @override
  String get statType => 'Type';

  @override
  String get next => 'Volgende';

  @override
  String get submit => 'Verzenden';

  @override
  String get continueLabel => 'Doorgaan';

  @override
  String get save => 'Opslaan';

  @override
  String get playAgain => 'Opnieuw Spelen';

  @override
  String get backToCourse => 'Terug naar Cursus';

  @override
  String get resultsTitle => 'Resultaten';

  @override
  String get shareLater => 'Later Delen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get ok => 'OK';

  @override
  String minutesShort(Object minutes) {
    return '$minutes min';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count min';
  }

  @override
  String timeShortHours(Object count) {
    return '$count uur';
  }

  @override
  String timeShortDays(Object count) {
    return '$count d';
  }

  @override
  String get timeJustNow => 'Zojuist';

  @override
  String timeMinutesAgo(Object count) {
    return '$count minuten geleden';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count uur geleden';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count dagen geleden';
  }

  @override
  String get liveQuizWaitingForHost => 'Wachten op host...';

  @override
  String get liveQuizJoinRequestSent => 'Deelnameaanvraag verzonden';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Aanvraag mislukt: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Host Besturing';

  @override
  String get liveQuizSpectatorModeTitle => 'Toeschouwermodus';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Rondes verlopen automatisch wanneer iedereen heeft geantwoord of de tijd verloopt.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Bekijk vragen en scorebord live. Je kunt niet antwoorden.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Vraag $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Aanvraag verzonden';

  @override
  String get liveQuizRequestToJoin => 'Verzoek om Deel te Nemen';

  @override
  String get liveQuizSpectatorFooter =>
      'Je kijkt live. Geniet van vragen en scorebord.';

  @override
  String get circleNotFound => 'Circle niet gevonden';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Herkansing starten mislukt: $error';
  }

  @override
  String get resultsMatchTitle => 'Wedstrijdresultaten';

  @override
  String resultsNiceWork(Object name) {
    return 'Goed gedaan, $name';
  }

  @override
  String get resultsPlaceFirst => '1e';

  @override
  String get resultsPlaceSecond => '2e';

  @override
  String get resultsPlaceThird => '3e';

  @override
  String resultsPlaceNth(Object rank) {
    return '${rank}e';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'van $players spelers';
  }

  @override
  String get resultsHighlightChampion =>
      'Kampioen! Je hebt deze Circle veroverd.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Geweldige nauwkeurigheid. Je was bijna op top!';

  @override
  String get resultsHighlightKeepGoing =>
      'Blijf doorgaan - consistentie verslaat snelheid.';

  @override
  String get resultsLeaderboardTitle => 'Scorebord';

  @override
  String resultsPlayersCount(Object count) {
    return '$count spelers';
  }

  @override
  String get resultsBackToCircles => 'Terug naar Circles';

  @override
  String get resultsRematch => 'Herkansing';

  @override
  String get resultsPlayAgain => 'Opnieuw Spelen';

  @override
  String get leaderboardGlobalTitle => 'Wereldwijd Scorebord';

  @override
  String get leaderboardEmpty => 'Nog geen scorebord.';

  @override
  String get aboutTitle => 'Over';

  @override
  String aboutVersion(Object version) {
    return 'Versie $version';
  }

  @override
  String get aboutDescription =>
      'SOMA is een gamified taalplatform dat het leren van nieuwe talen leuk en sociaal maakt. Doe mee aan Circles, oefen solo en volg je voortgang.';

  @override
  String get aboutTerms => 'Servicevoorwaarden';

  @override
  String get aboutPrivacy => 'Privacybeleid';

  @override
  String get aboutOpenSource => 'Open Source Licenties';

  @override
  String get addFriendTitle => 'Vriend Toevoegen';

  @override
  String get addFriendFindByUsername => 'Zoeken op gebruikersnaam';

  @override
  String get addFriendUsernameHint => 'Voer gebruikersnaam in...';

  @override
  String get addFriendTip =>
      'Tip: QR-code + vriend-ID ondersteuning kan later worden toegevoegd.';

  @override
  String get addFriendSending => 'Verzenden...';

  @override
  String get addFriendSendRequest => 'Verzoek Verzenden';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username niet gevonden';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Actie mislukt of al verzonden: $error';
  }

  @override
  String get friendsTitle => 'Vrienden';

  @override
  String get searchFriendsHint => 'Zoek vrienden...';

  @override
  String get somaLearnerSubtitle => 'Soma Leerling';

  @override
  String get friendRequestLabel => 'Verzoek';

  @override
  String get friendRequestSentLabel => 'Verzoek Verzonden';

  @override
  String get friendIncomingRequestLabel => 'Inkomend Verzoek';

  @override
  String get friendRequestsSection => 'Verzoeken';

  @override
  String get friendPendingSection => 'In Afwachting';

  @override
  String get friendAllSection => 'Alle Vrienden';

  @override
  String get friendsEmptyState =>
      'Nog geen vrienden. Voeg je eerste vriend toe!';

  @override
  String get friendsEmptyShort => 'Nog geen vrienden.';

  @override
  String noMatchForQuery(Object query) {
    return 'Geen resultaten voor \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'Inbox';

  @override
  String get searchChatsHint => 'Zoek chats...';

  @override
  String get inboxEmptyState =>
      'Nog geen chats. Begin een chat met een vriend!';

  @override
  String get newMessageTitle => 'Nieuw Bericht';

  @override
  String get chatCallLater =>
      'Spraakoproepen later (Circle talen binnenkort beschikbaar)';

  @override
  String errorWithDetails(Object error) {
    return 'Fout: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Zeg hallo tegen $name!';
  }

  @override
  String get chatMessageHint => 'Bericht...';

  @override
  String get notificationsTitle => 'Meldingen';

  @override
  String get notificationsTabAll => 'Alles';

  @override
  String get notificationsTabCourses => 'Cursussen';

  @override
  String get notificationsTabSocial => 'Sociaal';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Systeem';

  @override
  String get notificationsEmpty => 'Geen meldingen hier.';

  @override
  String get notificationsDeleted => 'Melding verwijderd';

  @override
  String get notificationTitleFallback => 'Melding';

  @override
  String get notificationTypeCourse => 'Cursus';

  @override
  String get notificationTypeSocial => 'Sociaal';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Systeem';

  @override
  String get notificationsFriendAccepted => 'Vriendverzoek geaccepteerd';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Vriendverzoek accepteren mislukt: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Vriendverzoek geweigerd';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Vriendverzoek weigeren mislukt: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Deelnemen aan Circle mislukt: $error';
  }

  @override
  String get notificationsOpening => 'Openen';

  @override
  String get notificationsOpened => 'Geopend';

  @override
  String notificationsActionMessage(Object action) {
    return '$action melding';
  }

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsEditProfile => 'Profiel Bewerken';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSecurity => 'Beveiliging';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Toon vertaalregel';

  @override
  String get settingsShowReadingLine => 'Toon leesregel (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Standaard timer per vraag';

  @override
  String get settingsMatchDifficulty => 'Wedstrijd Moeilijkheid';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptief';

  @override
  String get settingsSectionSoundFeel => 'Geluid & Gevoel';

  @override
  String get settingsMusic => 'Muziek';

  @override
  String get settingsSoundEffects => 'Geluidseffecten';

  @override
  String get settingsHaptics => 'Haptische Feedback';

  @override
  String get settingsSectionNotifications => 'Meldingen';

  @override
  String get settingsPushNotifications => 'Pushmeldingen';

  @override
  String get settingsDailyReminder => 'Dagelijkse Herinnering';

  @override
  String get settingsSectionAppearance => 'Uiterlijk';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsUiLanguage => 'UI Taal';

  @override
  String get settingsSectionAbout => 'Over';

  @override
  String get settingsVersion => 'Versie';

  @override
  String get settingsTermsPrivacy => 'Voorwaarden & Privacy';

  @override
  String get settingsSupport => 'Ondersteuning';

  @override
  String get settingsLogout => 'Uitloggen';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeLight => 'Licht';

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
  String get editProfileUpdated => 'Profiel bijgewerkt';

  @override
  String get editProfileTitle => 'Profiel Bewerken';

  @override
  String get editProfilePhotoLabel => 'Profielfoto';

  @override
  String get editProfilePhotoSubtitle =>
      'Avatarselectie via Supabase Storage binnenkort beschikbaar.';

  @override
  String get editProfileChangePhoto => 'Wijzigen';

  @override
  String get editProfileAvatarUploadSoon =>
      'Avatar uploaden binnenkort beschikbaar';

  @override
  String get editProfileDisplayNameLabel => 'Weergavenaam';

  @override
  String get editProfileDisplayNameHint => 'Jouw Naam';

  @override
  String get editProfileDisplayNameRequired => 'Voer een naam in';

  @override
  String get editProfileDisplayNameTooShort => 'Te kort';

  @override
  String get editProfileUsernameLabel => 'Gebruikersnaam';

  @override
  String get editProfileUsernameHint => 'jan_leerling';

  @override
  String get editProfileUsernameRequired => 'Voer een gebruikersnaam in';

  @override
  String get editProfileUsernameTooShort => 'Minimaal 3 tekens';

  @override
  String get editProfileUsernameInvalid => 'Alleen letters, cijfers, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Korte bio...';

  @override
  String get editProfileBioTooLong => 'Maximaal 120 tekens';

  @override
  String get editProfileLocationLabel => 'Locatie';

  @override
  String get editProfileLocationHint => 'Stad / Land';

  @override
  String get editProfileDailyGoalTitle => 'Dagelijks Doel';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Kies hoeveel minuten je elke dag wilt studeren.';

  @override
  String get securityTitle => 'Beveiliging';

  @override
  String get securitySectionPassword => 'Wachtwoord';

  @override
  String get securityChangePasswordTitle => 'Wachtwoord Wijzigen';

  @override
  String get securityChangePasswordSubtitle =>
      'Werk je wachtwoord regelmatig bij.';

  @override
  String get securitySectionTwoFactor => 'Tweefactorauthenticatie';

  @override
  String get securityEnable2faTitle => '2FA Inschakelen';

  @override
  String get securityEnable2faSubtitle => 'Extra beveiliging bij inloggen.';

  @override
  String get securitySectionAppLock => 'App Vergrendeling';

  @override
  String get securityBiometricTitle => 'Biometrisch Ontgrendelen';

  @override
  String get securityBiometricSubtitle =>
      'Gebruik FaceID/TouchID om SOMA te ontgrendelen.';

  @override
  String get securityAppLockTitle => 'App Vergrendeling';

  @override
  String get securityAppLockSubtitle => 'Vergrendel SOMA bij uitloggen.';

  @override
  String get securitySectionSessions => 'Actieve Sessies';

  @override
  String get securityNoSessions => 'Geen actieve sessies gevonden.';

  @override
  String get securityThisDevice => 'Dit Apparaat';

  @override
  String get securityDevice => 'Apparaat';

  @override
  String get securityActiveLabel => 'Actief';

  @override
  String get securitySignInToEnable2fa => 'Log in om 2FA in te schakelen';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA inschakelen mislukt: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA uitschakelen mislukt: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA Instellingen';

  @override
  String get securitySecretKeyLabel => 'Geheime Sleutel';

  @override
  String get securityCodeHint => '6-cijferige code';

  @override
  String get security2faEnabled => '2FA ingeschakeld';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Code verifiëren mislukt: $error';
  }

  @override
  String get securityVerifying => 'Verifiëren...';

  @override
  String get securityVerify => 'Verifiëren';

  @override
  String get securityCurrentPasswordHint => 'Huidig wachtwoord';

  @override
  String get securityNewPasswordHint => 'Nieuw wachtwoord (min. 8 tekens)';

  @override
  String get securityConfirmPasswordHint => 'Bevestig nieuw wachtwoord';

  @override
  String get securitySignInToChangePassword =>
      'Log in om wachtwoord te wijzigen';

  @override
  String get securityEnterCurrentPassword => 'Voer huidig wachtwoord in';

  @override
  String get securityPasswordMinLength =>
      'Nieuw wachtwoord moet minimaal 8 tekens zijn';

  @override
  String get securityPasswordsDoNotMatch => 'Wachtwoorden komen niet overeen';

  @override
  String get securityPasswordUpdated => 'Wachtwoord bijgewerkt';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Wachtwoord bijwerken mislukt: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatisch vergrendelen na';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacySectionVisibility => 'Zichtbaarheid';

  @override
  String get privacyProfileVisibilityTitle => 'Profielzichtbaarheid';

  @override
  String get privacyVisibilityPublic => 'Openbaar';

  @override
  String get privacyVisibilityFriends => 'Vrienden';

  @override
  String get privacyVisibilityPrivate => 'Privé';

  @override
  String get privacyVisibilityPublicSubtitle => 'Iedereen kan je profiel zien.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Alleen vrienden kunnen je profiel zien.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Alleen jij kunt je profiel zien.';

  @override
  String get privacySectionActivity => 'Activiteit';

  @override
  String get privacyShowOnlineTitle => 'Online Status Tonen';

  @override
  String get privacyShowOnlineSubtitle =>
      'Laat anderen zien dat je online bent.';

  @override
  String get privacyShowActivityTitle => 'Leeractiviteit Tonen';

  @override
  String get privacyShowActivitySubtitle =>
      'Toon reeks, XP en huidige voortgang.';

  @override
  String get privacySectionSocial => 'Sociaal';

  @override
  String get privacyAllowRequestsTitle => 'Vriendverzoeken Toestaan';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Sta anderen toe om vriendverzoeken te sturen.';

  @override
  String get privacyWhoCanDmTitle => 'Wie Kan DM Sturen';

  @override
  String get privacyDmEveryone => 'Iedereen';

  @override
  String get privacyDmFriends => 'Vrienden';

  @override
  String get privacyDmNoOne => 'Niemand';

  @override
  String get privacyDmEveryoneSubtitle => 'Iedereen kan je DM sturen.';

  @override
  String get privacyDmFriendsSubtitle => 'Alleen vrienden kunnen je DM sturen.';

  @override
  String get privacyDmNoOneSubtitle => 'Niemand kan je DM sturen.';

  @override
  String get privacySectionBlockedUsers => 'Geblokkeerde Gebruikers';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Beheer geblokkeerde gebruikers binnenkort beschikbaar.';

  @override
  String get privacySectionDataControls => 'Gegevenscontrole';

  @override
  String get privacyExportDataTitle => 'Gegevens Exporteren';

  @override
  String get privacyExportDataSubtitle =>
      'Download je activiteit en cursussen.';

  @override
  String get privacyExportInfoTitle => 'Gegevens Exporteren';

  @override
  String get privacyExportInfoBody =>
      'Volgende stappen: JSON/CSV export maken en via e-mail verzenden of lokaal downloaden.';

  @override
  String get privacyDeleteAccountTitle => 'Account Verwijderen';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Dit verwijdert je account en gegevens permanent.';

  @override
  String get privacyDeleteConfirmTitle => 'Account Verwijderen?';

  @override
  String get privacyDeleteConfirmBody =>
      'Deze actie is permanent. Je profiel, cursussen, vrienden en berichten worden verwijderd.';

  @override
  String get privacyDeleteComingSoon =>
      'Verwijdering wordt later verbonden met Supabase';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo Sessie Voltooid';

  @override
  String get soloResultsFeedbackElite => 'Elite prestatie. Behoud je reeks.';

  @override
  String get soloResultsFeedbackStrong => 'Sterk. Je groeit snel.';

  @override
  String get soloResultsFeedbackProgress =>
      'Goede vooruitgang. Bekijk fouten en herhaal.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Geen stress. Probeer opnieuw met minder vragen en focus.';

  @override
  String get soloResultsPerfectScore =>
      'Perfecte score! Geen fouten om te bekijken.';

  @override
  String get soloResultsReviewPrompt =>
      'Bekijk fouten om sneller te leren. Je foute antwoorden staan hieronder.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Fouten Bekijken ($count)';
  }

  @override
  String get authNotSignedIn => 'Niet ingelogd';

  @override
  String get genericUser => 'Gebruiker';

  @override
  String get loading => 'Laden...';

  @override
  String get edit => 'Bewerken';

  @override
  String get send => 'Verzenden';

  @override
  String get join => 'Deelnemen';

  @override
  String get leave => 'Verlaten';

  @override
  String get ready => 'Klaar';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Gemiddeld';

  @override
  String get levelAdvanced => 'Gevorderd';

  @override
  String questionsShort(Object count) {
    return '$count vr.';
  }

  @override
  String secondsShort(Object count) {
    return '$count sec';
  }

  @override
  String get circlesAllCourses => 'Alle Cursussen';

  @override
  String get circlesAllModes => 'Alle Modi';

  @override
  String get circlesAllLevels => 'Alle Niveaus';

  @override
  String get circlesAddNewCourse => 'Nieuwe Cursus Toevoegen';

  @override
  String get circlesCoursesTitle => 'Cursussen';

  @override
  String get circlesModeTitle => 'Modus';

  @override
  String get circlesLevelTitle => 'Niveau';

  @override
  String get circlesNoActiveForFilters =>
      'Geen actieve Circles voor deze filters.';

  @override
  String get circlesUnknownRoom => 'Onbekende Ruimte';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle Maken';

  @override
  String get circlesCircleName => 'Circle Naam';

  @override
  String get circlesEnterName => 'Voer naam in';

  @override
  String get circlesLanguages => 'Talen';

  @override
  String get circlesRoomSetup => 'Ruimte Instelling';

  @override
  String get circlesPlayers => 'Spelers';

  @override
  String get circlesEmptySlot => 'Lege Plek';

  @override
  String get circlesPlayersRange => '1-5 spelers';

  @override
  String get circlesQuestions => 'Vragen';

  @override
  String get circlesQuestionsSubtitle => 'Aantal vragen';

  @override
  String get circlesTimePerQuestion => 'Tijd per Vraag';

  @override
  String get circlesSecondsPerQuestion => 'Seconden per vraag';

  @override
  String get circlesAdvanced => 'Geavanceerd';

  @override
  String get circlesAllowSpectators => 'Toeschouwers Toestaan';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Sta anderen toe om te kijken zonder te spelen.';

  @override
  String get circlesLiveVoiceChat => 'Live Spraakchat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Schakel live spraak in tijdens wedstrijden.';

  @override
  String get circlesLiveTextChat => 'Live Tekstchat';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Schakel chat in tijdens wedstrijden.';

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
  String get circlesCreatedSuccess => 'Circle gemaakt';

  @override
  String circlesCreateError(Object error) {
    return 'Circle maken mislukt: $error';
  }

  @override
  String get circlesHostTip =>
      'Tip: Je kunt vrienden uitnodigen na het aanmaken.';

  @override
  String circlesJoinError(Object error) {
    return 'Deelnemen aan Circle mislukt: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle Lobby';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Code: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Wedstrijd Instellingen';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Niveau $level';
  }

  @override
  String get circlesDifficulty => 'Moeilijkheid';

  @override
  String get circlesPerQuestionShort => 'per vr.';

  @override
  String get circlesInvite => 'Uitnodigen';

  @override
  String get circlesCopyId => 'ID Kopiëren';

  @override
  String get circlesCopiedId => 'ID gekopieerd';

  @override
  String get circlesMatchInProgress => 'Wedstrijd Bezig';

  @override
  String get circlesSpectatorQueuedBody =>
      'Wedstrijd bezig. Deelnemen als toeschouwer.';

  @override
  String get circlesHostStartWhenReady =>
      'Host start wanneer iedereen klaar is.';

  @override
  String get circlesSpectators => 'Toeschouwers';

  @override
  String get circlesSpectator => 'Toeschouwer';

  @override
  String get circlesSpectatorCanWatch => 'Toeschouwers kunnen live kijken.';

  @override
  String get circlesJoinRequests => 'Deelnameverzoeken';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Keur toeschouwers goed voordat je de wedstrijd start.';

  @override
  String get circlesStartGame => 'Spel Starten';

  @override
  String get circlesWaitingForPlayers => 'Wachten op Spelers';

  @override
  String get circlesLeaveCircle => 'Circle Verlaten';

  @override
  String get circlesRequestSent => 'Verzoek verzonden';

  @override
  String get circlesRequestToJoin => 'Verzoek om Deel te Nemen';

  @override
  String get circlesWatchLive => 'Live Kijken';

  @override
  String get circlesPlayerTip =>
      'Tik op klaar wanneer je klaar bent. De host start de wedstrijd.';

  @override
  String get circlesSpectatorTip =>
      'Je bent aan het kijken. Kijk live wanneer de host begint.';

  @override
  String get circlesHostControls => 'Host Besturing';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Host overdragen mislukt: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle beëindigen mislukt: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username niet gevonden';
  }

  @override
  String get circlesInvalidUser => 'Ongeldige gebruiker';

  @override
  String get circlesCantInviteSelf => 'Je kunt jezelf niet uitnodigen';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username is al in de Circle';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Uitnodigen via gebruikersnaam';

  @override
  String circlesInviteSent(Object username) {
    return 'Uitnodiging verzonden naar @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Uitnodiging verzenden mislukt: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Deelnameverzoek verzonden';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Verzoek mislukt: $error';
  }

  @override
  String get circlesFull => 'Circle vol';

  @override
  String get circlesSpectatorAdded => 'Toeschouwer toegevoegd';

  @override
  String circlesApproveFailed(Object error) {
    return 'Verzoek goedkeuren mislukt: $error';
  }

  @override
  String get circlesRequestDeclined => 'Verzoek geweigerd';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Verzoek weigeren mislukt: $error';
  }

  @override
  String get circlesParticipant => 'Deelnemer';

  @override
  String get circlesLeavePromptTitle => 'Circle Verlaten?';

  @override
  String get circlesLeavePromptTransfer =>
      'Draag de host over voordat je vertrekt.';

  @override
  String get circlesLeavePromptEndOnly => 'Beëindig de Circle en vertrek.';

  @override
  String get circlesTransferHost => 'Host Overdragen';

  @override
  String get circlesEndCircle => 'Circle Beëindigen';

  @override
  String get circlesTransferHostTitle => 'Host Overdragen';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
