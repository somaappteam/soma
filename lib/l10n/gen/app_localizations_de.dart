// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Lernen. Konkurrieren. Meistern.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Registrieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get authFillAllFields => 'Bitte füllen Sie alle Felder aus';

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
    return 'Fehler: $error';
  }

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authUsername => 'Benutzername';

  @override
  String get authContinue => 'Weiter';

  @override
  String get authSigningIn => 'Anmelden...';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authCreating => 'Erstellen...';

  @override
  String get authNeedAccount => 'Sie haben noch kein Konto? ';

  @override
  String get authHaveAccount => 'Sie haben bereits ein Konto? ';

  @override
  String get dialogAuthRequiredTitle =>
      'Melden Sie sich an, um auf Circles zuzugreifen';

  @override
  String get dialogAuthRequiredBody =>
      'Circles sind Mehrspieler-Räume. Erstellen Sie ein Konto, um an Live-Matches teilzunehmen, Freunde einzuladen und Fortschritte zu speichern.';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get navHome => 'Start';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profil';

  @override
  String get removeCourseTitle => 'Kurs entfernen?';

  @override
  String removeCourseBody(Object course) {
    return '$course wird aus Ihrer Startliste entfernt.';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get remove => 'Entfernen';

  @override
  String welcomeBack(Object name) {
    return 'Willkommen zurück, $name!';
  }

  @override
  String get editCourses => 'Kurse bearbeiten';

  @override
  String get done => 'Fertig';

  @override
  String get noCoursesToEdit => 'Keine Kurse zum Bearbeiten.';

  @override
  String get addCourse => 'Kurs hinzufügen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get iSpeak => 'Ich spreche';

  @override
  String get iWantToLearn => 'Ich möchte lernen';

  @override
  String get chooseYourLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get chooseLearningLanguage => 'Wählen Sie die Lernsprache';

  @override
  String get chooseTwoDifferentLanguages =>
      'Wählen Sie zwei verschiedene Sprachen.';

  @override
  String get createCourse => 'Kurs erstellen';

  @override
  String get soloCourseTitle => 'Solo-Kurs';

  @override
  String get searchLanguage => 'Sprache suchen';

  @override
  String get noMatches => 'Keine Treffer';

  @override
  String get chooseCourseType => 'Wählen Sie einen Kurstyp';

  @override
  String get soloStudyDescription =>
      'Lernen Sie allein mit dem gleichen Quiz-Stil wie Circles - aber ohne Räume, Chat, Zuschauer oder Host-Optionen.';

  @override
  String get soloModeVocabulary => 'Vokabular';

  @override
  String get soloModeSentences => 'Sätze';

  @override
  String get soloModeReview => 'Wiederholung';

  @override
  String get soloModeVocabularySubtitle =>
      'Multiple Choice Bedeutungen, Synonyme, Verwendung';

  @override
  String get soloModeSentencesSubtitle => 'Lückentext + Übersetzung + Lesung';

  @override
  String get soloModeReviewDescription =>
      'Üben Sie, was Sie gelernt haben: schwache Wörter, aktuelle Fehler und verteilte Wiederholung.';

  @override
  String get startReview => 'Wiederholung starten';

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
    return '$mode Einrichtung';
  }

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get numberOfQuestions => 'Anzahl der Fragen';

  @override
  String get timerPerQuestion => 'Timer pro Frage';

  @override
  String get noTimer => 'Kein Timer';

  @override
  String get start => 'Starten';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSignInToMessage => 'Anmelden, um Nachricht zu senden';

  @override
  String get profileThatsYourProfile => 'Das ist Ihr Profil';

  @override
  String get profileSignInToAddFriends => 'Anmelden, um Freunde hinzuzufügen';

  @override
  String get profileCantAddYourself =>
      'Sie können sich nicht selbst hinzufügen';

  @override
  String profileRequestSent(Object username) {
    return 'Anfrage an @$username gesendet';
  }

  @override
  String get profileRequestFailed => 'Anfrage konnte nicht gesendet werden';

  @override
  String get profileDefaultDisplayName => 'Neuer Benutzer';

  @override
  String get profileDefaultBio => 'Bereit zu lernen!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Gast';

  @override
  String get guestUsername => 'gast';

  @override
  String get guestSessionLabel => 'Gastsitzung';

  @override
  String get unlockFullProfile => 'Schalten Sie Ihr vollständiges Profil frei';

  @override
  String get guestBenefitSync =>
      'Synchronisieren Sie Fortschritte auf allen Geräten';

  @override
  String get guestBenefitCircles =>
      'Treten Sie Circles bei und spielen Sie live';

  @override
  String get guestBenefitNotifications =>
      'Erhalten Sie Benachrichtigungen und Freundesanfragen';

  @override
  String get progressStaysOnDevice =>
      'Der Fortschritt bleibt auf diesem Gerät, bis Sie sich anmelden.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Ziel: ${minutes}m';
  }

  @override
  String get profileXpProgress => 'XP-Fortschritt';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Siege';

  @override
  String get profileStreak => 'Serie';

  @override
  String get profileFriendsTitle => 'Meine Freunde';

  @override
  String get profileViewAll => 'Alle anzeigen';

  @override
  String get profileAchievementsTitle => 'Erfolge';

  @override
  String get profileNoAchievements => 'Noch keine Erfolge.';

  @override
  String get profileRequested => 'Angefragt';

  @override
  String get profileSending => 'Senden...';

  @override
  String get profileAddFriend => 'Freund hinzufügen';

  @override
  String get profileConnectTitle => 'Verbinden';

  @override
  String get profileMessage => 'Nachricht';

  @override
  String get profileSnapshot => 'Profil-Schnappschuss';

  @override
  String get profileLocationHidden => 'Standort verborgen';

  @override
  String get profileBioHidden => 'Bio verborgen';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Tagesziel ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Circle-Einladung';

  @override
  String circleIdLabel(Object id) {
    return 'Circle-ID: $id';
  }

  @override
  String get signInToJoin => 'Anmelden zum Beitreten';

  @override
  String get joiningCircle => 'Beitreten...';

  @override
  String get joinCircle => 'Circle beitreten';

  @override
  String get circleJoinedAsPlayer => 'Als Spieler beigetreten';

  @override
  String get circleJoinedAsSpectator => 'Als Zuschauer beigetreten';

  @override
  String get accept => 'Akzeptieren';

  @override
  String get decline => 'Ablehnen';

  @override
  String get open => 'Öffnen';

  @override
  String get circleCountdownTitle => 'Mach dich bereit';

  @override
  String get circleCountdownSubtitle => 'Circle startet...';

  @override
  String get userFallbackName => 'Benutzer';

  @override
  String get micOff => 'Mikrofon aus';

  @override
  String get micOn => 'Mikrofon an';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'Zuschauer';

  @override
  String get tagHost => 'HOST';

  @override
  String get tagYou => 'SIE';

  @override
  String get statusCorrect => 'Richtig';

  @override
  String get statusWrong => 'Falsch';

  @override
  String get statusWaiting => 'Warten';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'Pkt';

  @override
  String get pointsLabel => 'Punkte';

  @override
  String get statCorrect => 'Richtig';

  @override
  String get statAnswers => 'Antworten';

  @override
  String get statTotal => 'Gesamt';

  @override
  String get statQuestions => 'Fragen';

  @override
  String get statAccuracy => 'Genauigkeit';

  @override
  String get statRate => 'Rate';

  @override
  String get statRank => 'Rang';

  @override
  String get statPosition => 'Position';

  @override
  String get statMode => 'Modus';

  @override
  String get statType => 'Typ';

  @override
  String get next => 'Weiter';

  @override
  String get submit => 'Absenden';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get save => 'Speichern';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get backToCourse => 'Zurück zum Kurs';

  @override
  String get resultsTitle => 'Ergebnisse';

  @override
  String get shareLater => 'Später teilen';

  @override
  String get delete => 'Löschen';

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
    return '${count}T';
  }

  @override
  String get timeJustNow => 'gerade eben';

  @override
  String timeMinutesAgo(Object count) {
    return 'vor ${count}m';
  }

  @override
  String timeHoursAgo(Object count) {
    return 'vor ${count}h';
  }

  @override
  String timeDaysAgo(Object count) {
    return 'vor ${count}T';
  }

  @override
  String get liveQuizWaitingForHost => 'Warten auf Host...';

  @override
  String get liveQuizJoinRequestSent => 'Beitrittsanfrage gesendet';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Anfrage fehlgeschlagen: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Host-Steuerung';

  @override
  String get liveQuizSpectatorModeTitle => 'Zuschauermodus';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Runden werden automatisch fortgesetzt, wenn alle geantwortet haben oder die Zeit abgelaufen ist.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Sehen Sie sich die Fragen und die Live-Bestenliste an. Sie können nicht antworten.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Frage $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Anfrage gesendet';

  @override
  String get liveQuizRequestToJoin => 'Anfrage zum Beitreten';

  @override
  String get liveQuizSpectatorFooter =>
      'Sie schauen live zu. Genießen Sie die Fragen und die Bestenliste.';

  @override
  String get circleNotFound => 'Circle nicht gefunden';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Revanche starten fehlgeschlagen: $error';
  }

  @override
  String get resultsMatchTitle => 'Match-Ergebnisse';

  @override
  String resultsNiceWork(Object name) {
    return 'Gute Arbeit, $name';
  }

  @override
  String get resultsPlaceFirst => '1. Platz';

  @override
  String get resultsPlaceSecond => '2. Platz';

  @override
  String get resultsPlaceThird => '3. Platz';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Platz $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Von $players Spielern';
  }

  @override
  String get resultsHighlightChampion =>
      'Champion! Sie haben diesen Circle dominiert.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Großartige Genauigkeit. Sie sind nah an der Spitze!';

  @override
  String get resultsHighlightKeepGoing =>
      'Weiter so - Beständigkeit schlägt Geschwindigkeit.';

  @override
  String get resultsLeaderboardTitle => 'Bestenliste';

  @override
  String resultsPlayersCount(Object count) {
    return '$count Spieler';
  }

  @override
  String get resultsBackToCircles => 'Zurück zu Circles';

  @override
  String get resultsRematch => 'Revanche';

  @override
  String get resultsPlayAgain => 'Nochmal spielen';

  @override
  String get leaderboardGlobalTitle => 'Globale Rangliste';

  @override
  String get leaderboardEmpty => 'Noch keine Rangliste.';

  @override
  String get aboutTitle => 'Info';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'SOMA ist eine gamifizierte Sprachlernplattform, die das Beherrschen neuer Sprachen ansprechend und sozial gestaltet. Nehmen Sie an Circles teil, üben Sie solo und verfolgen Sie Ihren Fortschritt.';

  @override
  String get aboutTerms => 'Nutzungsbedingungen';

  @override
  String get aboutPrivacy => 'Datenschutzrichtlinie';

  @override
  String get aboutOpenSource => 'Open-Source-Lizenzen';

  @override
  String get addFriendTitle => 'Freund hinzufügen';

  @override
  String get addFriendFindByUsername => 'Nach Benutzername suchen';

  @override
  String get addFriendUsernameHint => 'Benutzername eingeben...';

  @override
  String get addFriendTip =>
      'Tipp: Später können wir QR-Code + Freunde-ID unterstützen.';

  @override
  String get addFriendSending => 'Senden...';

  @override
  String get addFriendSendRequest => 'Anfrage senden';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Benutzer @$username nicht gefunden';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Aktion fehlgeschlagen oder bereits gesendet: $error';
  }

  @override
  String get friendsTitle => 'Freunde';

  @override
  String get searchFriendsHint => 'Freunde suchen...';

  @override
  String get somaLearnerSubtitle => 'Soma-Lernender';

  @override
  String get friendRequestLabel => 'Anfrage';

  @override
  String get friendRequestSentLabel => 'Anfrage gesendet';

  @override
  String get friendIncomingRequestLabel => 'Eingehende Anfrage';

  @override
  String get friendRequestsSection => 'Anfragen';

  @override
  String get friendPendingSection => 'Ausstehend';

  @override
  String get friendAllSection => 'Alle Freunde';

  @override
  String get friendsEmptyState =>
      'Noch keine Freunde. Fügen Sie Ihren ersten Freund hinzu!';

  @override
  String get friendsEmptyShort => 'Noch keine Freunde.';

  @override
  String noMatchForQuery(Object query) {
    return 'Keine Übereinstimmung für \"$query\"';
  }

  @override
  String get inboxTitle => 'Posteingang';

  @override
  String get searchChatsHint => 'Chats durchsuchen...';

  @override
  String get inboxEmptyState =>
      'Noch keine Unterhaltungen. Beginnen Sie mit einem Freund zu chatten!';

  @override
  String get newMessageTitle => 'Neue Nachricht';

  @override
  String get chatCallLater =>
      'Sprachanruf später (Circle-Sprache kommt als nächstes)';

  @override
  String errorWithDetails(Object error) {
    return 'Fehler: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Sagen Sie Hallo zu $name!';
  }

  @override
  String get chatMessageHint => 'Nachricht...';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsTabAll => 'Alle';

  @override
  String get notificationsTabCourses => 'Kurse';

  @override
  String get notificationsTabSocial => 'Soziales';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'System';

  @override
  String get notificationsEmpty => 'Keine Benachrichtigungen hier.';

  @override
  String get notificationsDeleted => 'Benachrichtigung gelöscht';

  @override
  String get notificationTitleFallback => 'Benachrichtigung';

  @override
  String get notificationTypeCourse => 'Kurs';

  @override
  String get notificationTypeSocial => 'Soziales';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'System';

  @override
  String get notificationsFriendAccepted => 'Freundschaftsanfrage akzeptiert';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Freundschaftsanfrage konnte nicht akzeptiert werden: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Freundschaftsanfrage abgelehnt';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Freundschaftsanfrage konnte nicht abgelehnt werden: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle konnte nicht beigetreten werden: $error';
  }

  @override
  String get notificationsOpening => 'Öffnen';

  @override
  String get notificationsOpened => 'Geöffnet';

  @override
  String notificationsActionMessage(Object action) {
    return '$action Benachrichtigung';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsEditProfile => 'Profil bearbeiten';

  @override
  String get settingsPrivacy => 'Privatsphäre';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Übersetzungszeile anzeigen';

  @override
  String get settingsShowReadingLine => 'Lesung anzeigen (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Standard-Timer pro Frage';

  @override
  String get settingsMatchDifficulty => 'Match-Schwierigkeit';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptiv';

  @override
  String get settingsSectionSoundFeel => 'Ton & Haptik';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSoundEffects => 'Soundeffekte';

  @override
  String get settingsHaptics => 'Haptik';

  @override
  String get settingsSectionNotifications => 'Benachrichtigungen';

  @override
  String get settingsPushNotifications => 'Push-Benachrichtigungen';

  @override
  String get settingsDailyReminder => 'Tägliche Erinnerung';

  @override
  String get settingsSectionAppearance => 'Erscheinungsbild';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsUiLanguage => 'UI-Sprache';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsTermsPrivacy => 'Bedingungen & Datenschutz';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLogout => 'Abmelden';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

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
  String get editProfileUpdated => 'Profil aktualisiert';

  @override
  String get editProfileTitle => 'Profil bearbeiten';

  @override
  String get editProfilePhotoLabel => 'Profilbild';

  @override
  String get editProfilePhotoSubtitle =>
      'Avatar-Auswahl über Supabase Storage demnächst.';

  @override
  String get editProfileChangePhoto => 'Ändern';

  @override
  String get editProfileAvatarUploadSoon => 'Avatar-Upload demnächst verfügbar';

  @override
  String get editProfileDisplayNameLabel => 'Anzeigename';

  @override
  String get editProfileDisplayNameHint => 'Ihr Name';

  @override
  String get editProfileDisplayNameRequired => 'Geben Sie Ihren Namen ein';

  @override
  String get editProfileDisplayNameTooShort => 'Zu kurz';

  @override
  String get editProfileUsernameLabel => 'Benutzername';

  @override
  String get editProfileUsernameHint => 'alex_lerner';

  @override
  String get editProfileUsernameRequired => 'Benutzername eingeben';

  @override
  String get editProfileUsernameTooShort => 'Min. 3 Zeichen';

  @override
  String get editProfileUsernameInvalid => 'Nur Buchstaben, Zahlen, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Kurze Bio...';

  @override
  String get editProfileBioTooLong => 'Max. 120 Zeichen';

  @override
  String get editProfileLocationLabel => 'Standort';

  @override
  String get editProfileLocationHint => 'Stadt / Land';

  @override
  String get editProfileDailyGoalTitle => 'Tagesziel';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Wählen Sie, wie viele Minuten Sie täglich lernen möchten.';

  @override
  String get securityTitle => 'Sicherheit';

  @override
  String get securitySectionPassword => 'Passwort';

  @override
  String get securityChangePasswordTitle => 'Passwort ändern';

  @override
  String get securityChangePasswordSubtitle =>
      'Aktualisieren Sie Ihr Passwort regelmäßig.';

  @override
  String get securitySectionTwoFactor => 'Zwei-Faktor-Authentifizierung';

  @override
  String get securityEnable2faTitle => '2FA aktivieren';

  @override
  String get securityEnable2faSubtitle => 'Zusätzlicher Schutz beim Anmelden.';

  @override
  String get securitySectionAppLock => 'App-Sperre';

  @override
  String get securityBiometricTitle => 'Biometrisches Entsperren';

  @override
  String get securityBiometricSubtitle =>
      'Verwenden Sie FaceID/TouchID zum Entsperren von SOMA.';

  @override
  String get securityAppLockTitle => 'App-Sperre';

  @override
  String get securityAppLockSubtitle =>
      'Sperren Sie SOMA, wenn Sie die App verlassen.';

  @override
  String get securitySectionSessions => 'Aktive Sitzungen';

  @override
  String get securityNoSessions => 'Keine aktiven Sitzungen gefunden.';

  @override
  String get securityThisDevice => 'Dieses Gerät';

  @override
  String get securityDevice => 'Gerät';

  @override
  String get securityActiveLabel => 'Aktiv';

  @override
  String get securitySignInToEnable2fa =>
      'Melden Sie sich an, um 2FA zu aktivieren';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA konnte nicht aktiviert werden: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA konnte nicht deaktiviert werden: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA einrichten';

  @override
  String get securitySecretKeyLabel => 'Geheimer Schlüssel';

  @override
  String get securityCodeHint => '6-stelliger Code';

  @override
  String get security2faEnabled => '2FA aktiviert';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Code konnte nicht verifiziert werden: $error';
  }

  @override
  String get securityVerifying => 'Verifizieren...';

  @override
  String get securityVerify => 'Verifizieren';

  @override
  String get securityCurrentPasswordHint => 'Aktuelles Passwort';

  @override
  String get securityNewPasswordHint => 'Neues Passwort (min. 8 Zeichen)';

  @override
  String get securityConfirmPasswordHint => 'Neues Passwort bestätigen';

  @override
  String get securitySignInToChangePassword =>
      'Melden Sie sich an, um Ihr Passwort zu ändern';

  @override
  String get securityEnterCurrentPassword =>
      'Geben Sie Ihr aktuelles Passwort ein';

  @override
  String get securityPasswordMinLength =>
      'Das neue Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get securityPasswordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get securityPasswordUpdated => 'Passwort aktualisiert';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Passwort konnte nicht aktualisiert werden: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatisch sperren nach';

  @override
  String get privacyTitle => 'Privatsphäre';

  @override
  String get privacySectionVisibility => 'Sichtbarkeit';

  @override
  String get privacyProfileVisibilityTitle => 'Profil-Sichtbarkeit';

  @override
  String get privacyVisibilityPublic => 'Öffentlich';

  @override
  String get privacyVisibilityFriends => 'Freunde';

  @override
  String get privacyVisibilityPrivate => 'Privat';

  @override
  String get privacyVisibilityPublicSubtitle => 'Jeder kann Ihr Profil sehen.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Nur Freunde können Ihr Profil sehen.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Nur Sie können Ihr Profil sehen.';

  @override
  String get privacySectionActivity => 'Aktivität';

  @override
  String get privacyShowOnlineTitle => 'Online-Status anzeigen';

  @override
  String get privacyShowOnlineSubtitle =>
      'Lassen Sie andere sehen, wenn Sie online sind.';

  @override
  String get privacyShowActivityTitle => 'Lernaktivität anzeigen';

  @override
  String get privacyShowActivitySubtitle =>
      'Serie, XP und aktuellen Fortschritt anzeigen.';

  @override
  String get privacySectionSocial => 'Soziales';

  @override
  String get privacyAllowRequestsTitle => 'Freundschaftsanfragen zulassen';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Lassen Sie Leute Ihnen Freundschaftsanfragen senden.';

  @override
  String get privacyWhoCanDmTitle => 'Wer kann Ihnen DMs senden';

  @override
  String get privacyDmEveryone => 'Jeder';

  @override
  String get privacyDmFriends => 'Freunde';

  @override
  String get privacyDmNoOne => 'Niemand';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Jeder kann Ihnen Nachrichten senden.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Nur Freunde können Ihnen Nachrichten senden.';

  @override
  String get privacyDmNoOneSubtitle => 'Niemand kann Ihnen Nachrichten senden.';

  @override
  String get privacySectionBlockedUsers => 'Blockierte Benutzer';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Verwaltung blockierter Benutzer demnächst verfügbar.';

  @override
  String get privacySectionDataControls => 'Datenkontrollen';

  @override
  String get privacyExportDataTitle => 'Meine Daten exportieren';

  @override
  String get privacyExportDataSubtitle =>
      'Laden Sie Ihre Aktivität und Kurse herunter.';

  @override
  String get privacyExportInfoTitle => 'Daten exportieren';

  @override
  String get privacyExportInfoBody =>
      'Nächster Schritt: Generieren Sie einen JSON/CSV-Export und senden Sie ihn per E-Mail oder laden Sie ihn lokal herunter.';

  @override
  String get privacyDeleteAccountTitle => 'Konto löschen';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Dies entfernt dauerhaft Ihr Konto und Ihre Daten.';

  @override
  String get privacyDeleteConfirmTitle => 'Konto löschen?';

  @override
  String get privacyDeleteConfirmBody =>
      'Diese Aktion ist dauerhaft. Ihr Profil, Ihre Kurse, Freunde und Nachrichten werden entfernt.';

  @override
  String get privacyDeleteComingSoon =>
      'Löschen wird später mit Supabase verbunden';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo-Sitzung abgeschlossen';

  @override
  String get soloResultsFeedbackElite =>
      'Elite-Leistung. Behalten Sie die Serie bei';

  @override
  String get soloResultsFeedbackStrong =>
      'Starke Arbeit. Sie verbessern sich schnell.';

  @override
  String get soloResultsFeedbackProgress =>
      'Guter Fortschritt. Überprüfen Sie Fehler und wiederholen Sie.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Kein Stress. Versuchen Sie es erneut mit weniger Fragen und Konzentration.';

  @override
  String get soloResultsPerfectScore =>
      'Perfekte Punktzahl! Keine Fehler zu überprüfen.';

  @override
  String get soloResultsReviewPrompt =>
      'Überprüfen Sie Fehler, um schneller zu lernen. Wir zeigen Ihnen als nächstes falsche Antworten hier.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Fehler überprüfen ($count)';
  }

  @override
  String get authNotSignedIn => 'Sie sind nicht angemeldet';

  @override
  String get genericUser => 'Benutzer';

  @override
  String get loading => 'Laden...';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get send => 'Senden';

  @override
  String get join => 'Beitreten';

  @override
  String get leave => 'Verlassen';

  @override
  String get ready => 'Bereit';

  @override
  String get levelBeginner => 'Anfänger';

  @override
  String get levelIntermediate => 'Fortgeschritten';

  @override
  String get levelAdvanced => 'Profi';

  @override
  String questionsShort(Object count) {
    return '$count F';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'Alle Kurse';

  @override
  String get circlesAllModes => 'Alle Modi';

  @override
  String get circlesAllLevels => 'Alle Stufen';

  @override
  String get circlesAddNewCourse => 'Neuen Kurs hinzufügen';

  @override
  String get circlesCoursesTitle => 'Kurse';

  @override
  String get circlesModeTitle => 'Modus';

  @override
  String get circlesLevelTitle => 'Stufe';

  @override
  String get circlesNoActiveForFilters =>
      'Keine aktiven Circles für diese Filter.';

  @override
  String get circlesUnknownRoom => 'Unbekannter Raum';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle erstellen';

  @override
  String get circlesCircleName => 'Circle-Name';

  @override
  String get circlesEnterName => 'Namen eingeben';

  @override
  String get circlesLanguages => 'Sprachen';

  @override
  String get circlesRoomSetup => 'Raum-Einrichtung';

  @override
  String get circlesPlayers => 'Spieler';

  @override
  String get circlesEmptySlot => 'Leerer Platz';

  @override
  String get circlesPlayersRange => '1-5 Spieler';

  @override
  String get circlesQuestions => 'Fragen';

  @override
  String get circlesQuestionsSubtitle => 'Anzahl der Fragen';

  @override
  String get circlesTimePerQuestion => 'Zeit pro Frage';

  @override
  String get circlesSecondsPerQuestion => 'Sekunden pro Frage';

  @override
  String get circlesAdvanced => 'Erweitert';

  @override
  String get circlesAllowSpectators => 'Zuschauer zulassen';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Lassen Sie andere zusehen, ohne zu spielen.';

  @override
  String get circlesLiveVoiceChat => 'Live-Sprachchat';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Aktivieren Sie Live-Sprache während Matches.';

  @override
  String get circlesLiveTextChat => 'Live-Textchat';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Aktivieren Sie Chat während Matches.';

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
  String get circlesCreatedSuccess => 'Circle erstellt';

  @override
  String circlesCreateError(Object error) {
    return 'Circle erstellen fehlgeschlagen: $error';
  }

  @override
  String get circlesHostTip =>
      'Tipp: Sie können Freunde nach der Erstellung einladen.';

  @override
  String circlesJoinError(Object error) {
    return 'Circle beitreten fehlgeschlagen: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle-Lobby';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Code: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Match-Einstellungen';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Stufe $level';
  }

  @override
  String get circlesDifficulty => 'Schwierigkeit';

  @override
  String get circlesPerQuestionShort => 'pro Frage';

  @override
  String get circlesInvite => 'Einladen';

  @override
  String get circlesCopyId => 'ID kopieren';

  @override
  String get circlesCopiedId => 'ID kopiert';

  @override
  String get circlesMatchInProgress => 'Match läuft';

  @override
  String get circlesSpectatorQueuedBody =>
      'Match läuft. Sie treten als Zuschauer bei.';

  @override
  String get circlesHostStartWhenReady =>
      'Host startet, wenn alle bereit sind.';

  @override
  String get circlesSpectators => 'Zuschauer';

  @override
  String get circlesSpectator => 'Zuschauer';

  @override
  String get circlesSpectatorCanWatch => 'Zuschauer können live zusehen.';

  @override
  String get circlesJoinRequests => 'Beitrittsanfragen';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Akzeptieren Sie Zuschauer vor Matchbeginn.';

  @override
  String get circlesStartGame => 'Spiel starten';

  @override
  String get circlesWaitingForPlayers => 'Warten auf Spieler';

  @override
  String get circlesLeaveCircle => 'Circle verlassen';

  @override
  String get circlesRequestSent => 'Anfrage gesendet';

  @override
  String get circlesRequestToJoin => 'Anfrage zum Beitreten';

  @override
  String get circlesWatchLive => 'Live zusehen';

  @override
  String get circlesPlayerTip =>
      'Tippen Sie auf Bereit, wenn Sie fertig sind. Der Host startet das Match.';

  @override
  String get circlesSpectatorTip =>
      'Sie schauen zu. Sehen Sie live zu, sobald der Host startet.';

  @override
  String get circlesHostControls => 'Host-Steuerung';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Host übertragen fehlgeschlagen: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle beenden fehlgeschlagen: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Benutzer @$username nicht gefunden';
  }

  @override
  String get circlesInvalidUser => 'Ungültiger Benutzer';

  @override
  String get circlesCantInviteSelf => 'Sie können sich nicht selbst einladen';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'Benutzer @$username ist bereits im Circle';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Per Benutzername einladen';

  @override
  String circlesInviteSent(Object username) {
    return 'Einladung an @$username gesendet';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Einladung senden fehlgeschlagen: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Beitrittsanfrage gesendet';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Anfrage fehlgeschlagen: $error';
  }

  @override
  String get circlesFull => 'Circle ist voll';

  @override
  String get circlesSpectatorAdded => 'Zuschauer hinzugefügt';

  @override
  String circlesApproveFailed(Object error) {
    return 'Anfrage genehmigen fehlgeschlagen: $error';
  }

  @override
  String get circlesRequestDeclined => 'Anfrage abgelehnt';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Anfrage ablehnen fehlgeschlagen: $error';
  }

  @override
  String get circlesParticipant => 'Teilnehmer';

  @override
  String get circlesLeavePromptTitle => 'Circle verlassen?';

  @override
  String get circlesLeavePromptTransfer =>
      'Übertragen Sie den Host, bevor Sie gehen.';

  @override
  String get circlesLeavePromptEndOnly =>
      'Beenden Sie den Circle und gehen Sie.';

  @override
  String get circlesTransferHost => 'Host übertragen';

  @override
  String get circlesEndCircle => 'Circle beenden';

  @override
  String get circlesTransferHostTitle => 'Host übertragen';

  @override
  String circlesShareId(Object id) {
    return 'Circle-ID: $id';
  }
}
