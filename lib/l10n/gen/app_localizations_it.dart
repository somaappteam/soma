// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Impara. Competi. Padroneggia.';

  @override
  String get signUp => 'Registrati';

  @override
  String get signIn => 'Accedi';

  @override
  String get skipForNow => 'Salta per ora';

  @override
  String get authFillAllFields => 'Compila tutti i campi';

  @override
  String authError(Object error) {
    return 'Errore: $error';
  }

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authUsername => 'Nome utente';

  @override
  String get authContinue => 'Continua';

  @override
  String get authSigningIn => 'Accesso in corso...';

  @override
  String get authCreateAccount => 'Crea account';

  @override
  String get authCreating => 'Creazione...';

  @override
  String get authNeedAccount => 'Non hai un account? ';

  @override
  String get authHaveAccount => 'Hai già un account? ';

  @override
  String get dialogAuthRequiredTitle => 'Accedi per accedere ai Circle';

  @override
  String get dialogAuthRequiredBody =>
      'I Circle sono stanze multiplayer. Crea un account per partecipare a partite dal vivo, invitare amici e salvare i progressi.';

  @override
  String get notNow => 'Non ora';

  @override
  String get navHome => 'Home';

  @override
  String get navCircles => 'Circle';

  @override
  String get navProfile => 'Profilo';

  @override
  String get removeCourseTitle => 'Rimuovere corso?';

  @override
  String removeCourseBody(Object course) {
    return '$course sarà rimosso dalla tua lista Home.';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get remove => 'Rimuovi';

  @override
  String welcomeBack(Object name) {
    return 'Bentornato, $name!';
  }

  @override
  String get editCourses => 'Modifica corsi';

  @override
  String get done => 'Fatto';

  @override
  String get noCoursesToEdit => 'Nessun corso da modificare.';

  @override
  String get addCourse => 'Aggiungi corso';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get iSpeak => 'Parlo';

  @override
  String get iWantToLearn => 'Voglio imparare';

  @override
  String get chooseYourLanguage => 'Scegli la tua lingua';

  @override
  String get chooseLearningLanguage => 'Scegli la lingua da imparare';

  @override
  String get chooseTwoDifferentLanguages => 'Scegli due lingue diverse.';

  @override
  String get createCourse => 'Crea corso';

  @override
  String get soloCourseTitle => 'Corso Solo';

  @override
  String get searchLanguage => 'Cerca lingua';

  @override
  String get noMatches => 'Nessuna corrispondenza';

  @override
  String get chooseCourseType => 'Scegli un tipo di corso';

  @override
  String get soloStudyDescription =>
      'Studia da solo con lo stesso stile di quiz dei Circle - ma senza stanze, chat, spettatori o opzioni host.';

  @override
  String get soloModeVocabulary => 'Vocabolario';

  @override
  String get soloModeSentences => 'Frasi';

  @override
  String get soloModeReview => 'Ripasso';

  @override
  String get soloModeVocabularySubtitle =>
      'Scelta multipla significati, sinonimi, uso';

  @override
  String get soloModeSentencesSubtitle =>
      'Riempimento spazi + traduzione + lettura';

  @override
  String get soloModeReviewDescription =>
      'Esercitati su ciò che hai appreso: parole deboli, errori recenti e ripetizione spaziata.';

  @override
  String get startReview => 'Inizia ripasso';

  @override
  String soloSetupTitle(Object mode) {
    return 'Impostazione $mode';
  }

  @override
  String get difficulty => 'Difficoltà';

  @override
  String get numberOfQuestions => 'Numero di domande';

  @override
  String get timerPerQuestion => 'Timer per domanda';

  @override
  String get noTimer => 'Nessun timer';

  @override
  String get start => 'Inizia';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get profileSignInToMessage => 'Accedi per inviare messaggi';

  @override
  String get profileThatsYourProfile => 'Questo è il tuo profilo';

  @override
  String get profileSignInToAddFriends => 'Accedi per aggiungere amici';

  @override
  String get profileCantAddYourself => 'Non puoi aggiungere te stesso';

  @override
  String profileRequestSent(Object username) {
    return 'Richiesta inviata a @$username';
  }

  @override
  String get profileRequestFailed => 'Invio richiesta fallito';

  @override
  String get profileDefaultDisplayName => 'Nuovo utente';

  @override
  String get profileDefaultBio => 'Pronto a imparare!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Ospite';

  @override
  String get guestUsername => 'ospite';

  @override
  String get guestSessionLabel => 'Sessione ospite';

  @override
  String get unlockFullProfile => 'Sblocca il tuo profilo completo';

  @override
  String get guestBenefitSync =>
      'Sincronizza i progressi su tutti i dispositivi';

  @override
  String get guestBenefitCircles => 'Unisciti ai Circle e gioca dal vivo';

  @override
  String get guestBenefitNotifications =>
      'Ricevi notifiche e richieste di amicizia';

  @override
  String get progressStaysOnDevice =>
      'I progressi rimangono su questo dispositivo finché non accedi.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Obiettivo: ${minutes}m';
  }

  @override
  String get profileXpProgress => 'Progressi XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Vittorie';

  @override
  String get profileStreak => 'Serie';

  @override
  String get profileFriendsTitle => 'I miei amici';

  @override
  String get profileViewAll => 'Vedi tutti';

  @override
  String get profileAchievementsTitle => 'Traguardi';

  @override
  String get profileNoAchievements => 'Nessun traguardo ancora.';

  @override
  String get profileRequested => 'Richiesto';

  @override
  String get profileSending => 'Invio...';

  @override
  String get profileAddFriend => 'Aggiungi amico';

  @override
  String get profileConnectTitle => 'Connetti';

  @override
  String get profileMessage => 'Messaggio';

  @override
  String get profileSnapshot => 'Snapshot profilo';

  @override
  String get profileLocationHidden => 'Posizione nascosta';

  @override
  String get profileBioHidden => 'Bio nascosta';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Obiettivo giornaliero ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Invito Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Accedi per unirti';

  @override
  String get joiningCircle => 'Accesso...';

  @override
  String get joinCircle => 'Unisciti al Circle';

  @override
  String get circleJoinedAsPlayer => 'Ti sei unito come giocatore';

  @override
  String get circleJoinedAsSpectator => 'Ti sei unito come spettatore';

  @override
  String get accept => 'Accetta';

  @override
  String get decline => 'Rifiuta';

  @override
  String get open => 'Apri';

  @override
  String get circleCountdownTitle => 'Preparati';

  @override
  String get circleCountdownSubtitle => 'Il Circle sta per iniziare...';

  @override
  String get userFallbackName => 'Utente';

  @override
  String get micOff => 'Microfono spento';

  @override
  String get micOn => 'Microfono acceso';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'Spettatore';

  @override
  String get tagHost => 'HOST';

  @override
  String get tagYou => 'TU';

  @override
  String get statusCorrect => 'Corretto';

  @override
  String get statusWrong => 'Sbagliato';

  @override
  String get statusWaiting => 'In attesa';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'Pt';

  @override
  String get pointsLabel => 'Punti';

  @override
  String get statCorrect => 'Corretto';

  @override
  String get statAnswers => 'Risposte';

  @override
  String get statTotal => 'Totale';

  @override
  String get statQuestions => 'Domande';

  @override
  String get statAccuracy => 'Precisione';

  @override
  String get statRate => 'Velocità';

  @override
  String get statRank => 'Classifica';

  @override
  String get statPosition => 'Posizione';

  @override
  String get statMode => 'Modalità';

  @override
  String get statType => 'Tipo';

  @override
  String get next => 'Avanti';

  @override
  String get submit => 'Invia';

  @override
  String get continueLabel => 'Continua';

  @override
  String get save => 'Salva';

  @override
  String get playAgain => 'Gioca ancora';

  @override
  String get backToCourse => 'Torna al corso';

  @override
  String get resultsTitle => 'Risultati';

  @override
  String get shareLater => 'Condividi dopo';

  @override
  String get delete => 'Elimina';

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
    return '${count}g';
  }

  @override
  String get timeJustNow => 'proprio ora';

  @override
  String timeMinutesAgo(Object count) {
    return '${count}m fa';
  }

  @override
  String timeHoursAgo(Object count) {
    return '${count}h fa';
  }

  @override
  String timeDaysAgo(Object count) {
    return '${count}g fa';
  }

  @override
  String get liveQuizWaitingForHost => 'In attesa dell\'host...';

  @override
  String get liveQuizJoinRequestSent => 'Richiesta di accesso inviata';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Richiesta fallita: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Controlli host';

  @override
  String get liveQuizSpectatorModeTitle => 'Modalità spettatore';

  @override
  String get liveQuizHostControlsSubtitle =>
      'I round avanzano automaticamente quando tutti hanno risposto o il tempo è scaduto.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Guarda le domande e la classifica dal vivo. Non puoi rispondere.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Domanda $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Richiesta inviata';

  @override
  String get liveQuizRequestToJoin => 'Richiesta di accesso';

  @override
  String get liveQuizSpectatorFooter =>
      'Stai guardando dal vivo. Goditi le domande e la classifica.';

  @override
  String get circleNotFound => 'Circle non trovato';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Avvio rivincita fallito: $error';
  }

  @override
  String get resultsMatchTitle => 'Risultati partita';

  @override
  String resultsNiceWork(Object name) {
    return 'Ottimo lavoro, $name';
  }

  @override
  String get resultsPlaceFirst => '1° posto';

  @override
  String get resultsPlaceSecond => '2° posto';

  @override
  String get resultsPlaceThird => '3° posto';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank° posto';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Su $players giocatori';
  }

  @override
  String get resultsHighlightChampion =>
      'Campione! Hai dominato questo Circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Grande precisione. Sei vicino alla vetta!';

  @override
  String get resultsHighlightKeepGoing =>
      'Continua così - la costanza batte la velocità.';

  @override
  String get resultsLeaderboardTitle => 'Classifica';

  @override
  String resultsPlayersCount(Object count) {
    return '$count giocatori';
  }

  @override
  String get resultsBackToCircles => 'Torna ai Circle';

  @override
  String get resultsRematch => 'Rivincita';

  @override
  String get resultsPlayAgain => 'Gioca ancora';

  @override
  String get leaderboardGlobalTitle => 'Classifica globale';

  @override
  String get leaderboardEmpty => 'Nessuna classifica ancora.';

  @override
  String get aboutTitle => 'Info';

  @override
  String aboutVersion(Object version) {
    return 'Versione $version';
  }

  @override
  String get aboutDescription =>
      'SOMA è una piattaforma di apprendimento linguistico gamificata che rende coinvolgente e sociale la padronanza di nuove lingue. Unisciti ai Circle, esercitati da solo e monitora i tuoi progressi.';

  @override
  String get aboutTerms => 'Termini di servizio';

  @override
  String get aboutPrivacy => 'Informativa sulla privacy';

  @override
  String get aboutOpenSource => 'Licenze open source';

  @override
  String get addFriendTitle => 'Aggiungi amico';

  @override
  String get addFriendFindByUsername => 'Trova per nome utente';

  @override
  String get addFriendUsernameHint => 'Inserisci nome utente...';

  @override
  String get addFriendTip =>
      'Suggerimento: In seguito possiamo supportare QR code + ID amici.';

  @override
  String get addFriendSending => 'Invio...';

  @override
  String get addFriendSendRequest => 'Invia richiesta';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Utente @$username non trovato';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Azione fallita o già inviata: $error';
  }

  @override
  String get friendsTitle => 'Amici';

  @override
  String get searchFriendsHint => 'Cerca amici...';

  @override
  String get somaLearnerSubtitle => 'Studente Soma';

  @override
  String get friendRequestLabel => 'Richiesta';

  @override
  String get friendRequestSentLabel => 'Richiesta inviata';

  @override
  String get friendIncomingRequestLabel => 'Richiesta in arrivo';

  @override
  String get friendRequestsSection => 'Richieste';

  @override
  String get friendPendingSection => 'In sospeso';

  @override
  String get friendAllSection => 'Tutti gli amici';

  @override
  String get friendsEmptyState =>
      'Nessun amico ancora. Aggiungi il tuo primo amico!';

  @override
  String get friendsEmptyShort => 'Nessun amico ancora.';

  @override
  String noMatchForQuery(Object query) {
    return 'Nessuna corrispondenza per \"$query\"';
  }

  @override
  String get inboxTitle => 'Posta in arrivo';

  @override
  String get searchChatsHint => 'Cerca chat...';

  @override
  String get inboxEmptyState =>
      'Nessuna conversazione ancora. Inizia a chattare con un amico!';

  @override
  String get newMessageTitle => 'Nuovo messaggio';

  @override
  String get chatCallLater =>
      'Chiamata vocale più tardi (il linguaggio Circle arriva dopo)';

  @override
  String errorWithDetails(Object error) {
    return 'Errore: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Saluta $name!';
  }

  @override
  String get chatMessageHint => 'Messaggio...';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsTabAll => 'Tutte';

  @override
  String get notificationsTabCourses => 'Corsi';

  @override
  String get notificationsTabSocial => 'Sociale';

  @override
  String get notificationsTabCircles => 'Circle';

  @override
  String get notificationsTabSystem => 'Sistema';

  @override
  String get notificationsEmpty => 'Nessuna notifica qui.';

  @override
  String get notificationsDeleted => 'Notifica eliminata';

  @override
  String get notificationTitleFallback => 'Notifica';

  @override
  String get notificationTypeCourse => 'Corso';

  @override
  String get notificationTypeSocial => 'Sociale';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Sistema';

  @override
  String get notificationsFriendAccepted => 'Richiesta di amicizia accettata';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Impossibile accettare richiesta di amicizia: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Richiesta di amicizia rifiutata';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Impossibile rifiutare richiesta di amicizia: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Impossibile unirsi al Circle: $error';
  }

  @override
  String get notificationsOpening => 'Apertura';

  @override
  String get notificationsOpened => 'Aperto';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notifica';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsEditProfile => 'Modifica profilo';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsSecurity => 'Sicurezza';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Mostra riga traduzione';

  @override
  String get settingsShowReadingLine => 'Mostra lettura (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Timer predefinito per domanda';

  @override
  String get settingsMatchDifficulty => 'Difficoltà partita';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adattiva';

  @override
  String get settingsSectionSoundFeel => 'Suono e sensazione';

  @override
  String get settingsMusic => 'Musica';

  @override
  String get settingsSoundEffects => 'Effetti sonori';

  @override
  String get settingsHaptics => 'Feedback tattile';

  @override
  String get settingsSectionNotifications => 'Notifiche';

  @override
  String get settingsPushNotifications => 'Notifiche push';

  @override
  String get settingsDailyReminder => 'Promemoria giornaliero';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Lingua interfaccia';

  @override
  String get settingsSectionAbout => 'Info';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsTermsPrivacy => 'Termini e privacy';

  @override
  String get settingsSupport => 'Supporto';

  @override
  String get settingsLogout => 'Disconnetti';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

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
  String get editProfileUpdated => 'Profilo aggiornato';

  @override
  String get editProfileTitle => 'Modifica profilo';

  @override
  String get editProfilePhotoLabel => 'Foto profilo';

  @override
  String get editProfilePhotoSubtitle =>
      'Selezione avatar tramite Supabase Storage in arrivo.';

  @override
  String get editProfileChangePhoto => 'Cambia';

  @override
  String get editProfileAvatarUploadSoon =>
      'Caricamento avatar disponibile presto';

  @override
  String get editProfileDisplayNameLabel => 'Nome visualizzato';

  @override
  String get editProfileDisplayNameHint => 'Il tuo nome';

  @override
  String get editProfileDisplayNameRequired => 'Inserisci il tuo nome';

  @override
  String get editProfileDisplayNameTooShort => 'Troppo corto';

  @override
  String get editProfileUsernameLabel => 'Nome utente';

  @override
  String get editProfileUsernameHint => 'alex_studente';

  @override
  String get editProfileUsernameRequired => 'Inserisci nome utente';

  @override
  String get editProfileUsernameTooShort => 'Min. 3 caratteri';

  @override
  String get editProfileUsernameInvalid => 'Solo lettere, numeri, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Breve bio...';

  @override
  String get editProfileBioTooLong => 'Max 120 caratteri';

  @override
  String get editProfileLocationLabel => 'Posizione';

  @override
  String get editProfileLocationHint => 'Città / Paese';

  @override
  String get editProfileDailyGoalTitle => 'Obiettivo giornaliero';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Scegli quanti minuti vuoi studiare ogni giorno.';

  @override
  String get securityTitle => 'Sicurezza';

  @override
  String get securitySectionPassword => 'Password';

  @override
  String get securityChangePasswordTitle => 'Cambia password';

  @override
  String get securityChangePasswordSubtitle =>
      'Aggiorna regolarmente la tua password.';

  @override
  String get securitySectionTwoFactor => 'Autenticazione a due fattori';

  @override
  String get securityEnable2faTitle => 'Abilita 2FA';

  @override
  String get securityEnable2faSubtitle =>
      'Protezione extra durante l\'accesso.';

  @override
  String get securitySectionAppLock => 'Blocco app';

  @override
  String get securityBiometricTitle => 'Sblocco biometrico';

  @override
  String get securityBiometricSubtitle =>
      'Usa FaceID/TouchID per sbloccare SOMA.';

  @override
  String get securityAppLockTitle => 'Blocco app';

  @override
  String get securityAppLockSubtitle => 'Blocca SOMA quando esci dall\'app.';

  @override
  String get securitySectionSessions => 'Sessioni attive';

  @override
  String get securityNoSessions => 'Nessuna sessione attiva trovata.';

  @override
  String get securityThisDevice => 'Questo dispositivo';

  @override
  String get securityDevice => 'Dispositivo';

  @override
  String get securityActiveLabel => 'Attivo';

  @override
  String get securitySignInToEnable2fa => 'Accedi per abilitare 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Impossibile abilitare 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Impossibile disabilitare 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Configura 2FA';

  @override
  String get securitySecretKeyLabel => 'Chiave segreta';

  @override
  String get securityCodeHint => 'Codice a 6 cifre';

  @override
  String get security2faEnabled => '2FA abilitato';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Impossibile verificare il codice: $error';
  }

  @override
  String get securityVerifying => 'Verifica...';

  @override
  String get securityVerify => 'Verifica';

  @override
  String get securityCurrentPasswordHint => 'Password attuale';

  @override
  String get securityNewPasswordHint => 'Nuova password (min. 8 caratteri)';

  @override
  String get securityConfirmPasswordHint => 'Conferma nuova password';

  @override
  String get securitySignInToChangePassword =>
      'Accedi per cambiare la tua password';

  @override
  String get securityEnterCurrentPassword =>
      'Inserisci la tua password attuale';

  @override
  String get securityPasswordMinLength =>
      'La nuova password deve essere lunga almeno 8 caratteri';

  @override
  String get securityPasswordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get securityPasswordUpdated => 'Password aggiornata';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Impossibile aggiornare la password: $error';
  }

  @override
  String get securityAutoLockAfter => 'Blocco automatico dopo';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacySectionVisibility => 'Visibilità';

  @override
  String get privacyProfileVisibilityTitle => 'Visibilità profilo';

  @override
  String get privacyVisibilityPublic => 'Pubblico';

  @override
  String get privacyVisibilityFriends => 'Amici';

  @override
  String get privacyVisibilityPrivate => 'Privato';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Chiunque può vedere il tuo profilo.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Solo gli amici possono vedere il tuo profilo.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Solo tu puoi vedere il tuo profilo.';

  @override
  String get privacySectionActivity => 'Attività';

  @override
  String get privacyShowOnlineTitle => 'Mostra stato online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Permetti agli altri di vedere quando sei online.';

  @override
  String get privacyShowActivityTitle => 'Mostra attività di apprendimento';

  @override
  String get privacyShowActivitySubtitle =>
      'Visualizza serie, XP e progressi attuali.';

  @override
  String get privacySectionSocial => 'Sociale';

  @override
  String get privacyAllowRequestsTitle => 'Consenti richieste di amicizia';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Permetti alle persone di inviarti richieste di amicizia.';

  @override
  String get privacyWhoCanDmTitle => 'Chi può inviarti DM';

  @override
  String get privacyDmEveryone => 'Tutti';

  @override
  String get privacyDmFriends => 'Amici';

  @override
  String get privacyDmNoOne => 'Nessuno';

  @override
  String get privacyDmEveryoneSubtitle => 'Chiunque può inviarti messaggi.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Solo gli amici possono inviarti messaggi.';

  @override
  String get privacyDmNoOneSubtitle => 'Nessuno può inviarti messaggi.';

  @override
  String get privacySectionBlockedUsers => 'Utenti bloccati';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Gestione utenti bloccati disponibile presto.';

  @override
  String get privacySectionDataControls => 'Controlli dati';

  @override
  String get privacyExportDataTitle => 'Esporta i miei dati';

  @override
  String get privacyExportDataSubtitle =>
      'Scarica la tua attività e i tuoi corsi.';

  @override
  String get privacyExportInfoTitle => 'Esporta dati';

  @override
  String get privacyExportInfoBody =>
      'Prossimo passo: genera un\'esportazione JSON/CSV e inviatela via email o scaricala localmente.';

  @override
  String get privacyDeleteAccountTitle => 'Elimina account';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Questo rimuoverà permanentemente il tuo account e i tuoi dati.';

  @override
  String get privacyDeleteConfirmTitle => 'Eliminare account?';

  @override
  String get privacyDeleteConfirmBody =>
      'Questa azione è permanente. Il tuo profilo, corsi, amici e messaggi saranno rimossi.';

  @override
  String get privacyDeleteComingSoon =>
      'L\'eliminazione sarà collegata a Supabase più tardi';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sessione solo completata';

  @override
  String get soloResultsFeedbackElite =>
      'Prestazione d\'élite. Mantieni la serie';

  @override
  String get soloResultsFeedbackStrong =>
      'Ottimo lavoro. Stai migliorando velocemente.';

  @override
  String get soloResultsFeedbackProgress =>
      'Buon progresso. Rivedi gli errori e ripeti.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Niente stress. Riprova con meno domande e concentrazione.';

  @override
  String get soloResultsPerfectScore =>
      'Punteggio perfetto! Nessun errore da rivedere.';

  @override
  String get soloResultsReviewPrompt =>
      'Rivedi gli errori per imparare più velocemente. Ti mostreremo le risposte sbagliate qui di seguito.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Rivedi errori ($count)';
  }

  @override
  String get authNotSignedIn => 'Non hai effettuato l\'accesso';

  @override
  String get genericUser => 'Utente';

  @override
  String get loading => 'Caricamento...';

  @override
  String get edit => 'Modifica';

  @override
  String get send => 'Invia';

  @override
  String get join => 'Unisciti';

  @override
  String get leave => 'Esci';

  @override
  String get ready => 'Pronto';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelAdvanced => 'Avanzato';

  @override
  String questionsShort(Object count) {
    return '$count D';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'Tutti i corsi';

  @override
  String get circlesAllModes => 'Tutte le modalità';

  @override
  String get circlesAllLevels => 'Tutti i livelli';

  @override
  String get circlesAddNewCourse => 'Aggiungi nuovo corso';

  @override
  String get circlesCoursesTitle => 'Corsi';

  @override
  String get circlesModeTitle => 'Modalità';

  @override
  String get circlesLevelTitle => 'Livello';

  @override
  String get circlesNoActiveForFilters =>
      'Nessun Circle attivo per questi filtri.';

  @override
  String get circlesUnknownRoom => 'Stanza sconosciuta';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Crea Circle';

  @override
  String get circlesCircleName => 'Nome Circle';

  @override
  String get circlesEnterName => 'Inserisci nome';

  @override
  String get circlesLanguages => 'Lingue';

  @override
  String get circlesRoomSetup => 'Configurazione stanza';

  @override
  String get circlesPlayers => 'Giocatori';

  @override
  String get circlesEmptySlot => 'Slot vuoto';

  @override
  String get circlesPlayersRange => '1-5 giocatori';

  @override
  String get circlesQuestions => 'Domande';

  @override
  String get circlesQuestionsSubtitle => 'Numero di domande';

  @override
  String get circlesTimePerQuestion => 'Tempo per domanda';

  @override
  String get circlesSecondsPerQuestion => 'Secondi per domanda';

  @override
  String get circlesAdvanced => 'Avanzate';

  @override
  String get circlesAllowSpectators => 'Consenti spettatori';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Permetti ad altri di guardare senza giocare.';

  @override
  String get circlesLiveVoiceChat => 'Chat vocale dal vivo';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Abilita voce dal vivo durante le partite.';

  @override
  String get circlesLiveTextChat => 'Chat testuale dal vivo';

  @override
  String get circlesLiveTextChatSubtitle => 'Abilita chat durante le partite.';

  @override
  String get circlesCreatedSuccess => 'Circle creato';

  @override
  String circlesCreateError(Object error) {
    return 'Creazione Circle fallita: $error';
  }

  @override
  String get circlesHostTip =>
      'Suggerimento: puoi invitare amici dopo la creazione.';

  @override
  String circlesJoinError(Object error) {
    return 'Accesso al Circle fallito: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Codice: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Impostazioni partita';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Livello $level';
  }

  @override
  String get circlesDifficulty => 'Difficoltà';

  @override
  String get circlesPerQuestionShort => 'per domanda';

  @override
  String get circlesInvite => 'Invita';

  @override
  String get circlesCopyId => 'Copia ID';

  @override
  String get circlesCopiedId => 'ID copiato';

  @override
  String get circlesMatchInProgress => 'Partita in corso';

  @override
  String get circlesSpectatorQueuedBody =>
      'Partita in corso. Ti unirai come spettatore.';

  @override
  String get circlesHostStartWhenReady =>
      'L\'host inizia quando tutti sono pronti.';

  @override
  String get circlesSpectators => 'Spettatori';

  @override
  String get circlesSpectator => 'Spettatore';

  @override
  String get circlesSpectatorCanWatch =>
      'Gli spettatori possono guardare dal vivo.';

  @override
  String get circlesJoinRequests => 'Richieste di accesso';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Accetta spettatori prima dell\'inizio della partita.';

  @override
  String get circlesStartGame => 'Inizia gioco';

  @override
  String get circlesWaitingForPlayers => 'In attesa di giocatori';

  @override
  String get circlesLeaveCircle => 'Esci dal Circle';

  @override
  String get circlesRequestSent => 'Richiesta inviata';

  @override
  String get circlesRequestToJoin => 'Richiesta di accesso';

  @override
  String get circlesWatchLive => 'Guarda dal vivo';

  @override
  String get circlesPlayerTip =>
      'Tocca Pronto quando sei pronto. L\'host inizierà la partita.';

  @override
  String get circlesSpectatorTip =>
      'Stai guardando. Guarda dal vivo una volta che l\'host inizia.';

  @override
  String get circlesHostControls => 'Controlli host';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Trasferimento host fallito: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Chiusura Circle fallita: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Utente @$username non trovato';
  }

  @override
  String get circlesInvalidUser => 'Utente non valido';

  @override
  String get circlesCantInviteSelf => 'Non puoi invitare te stesso';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'L\'utente @$username è già nel Circle';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Invita per nome utente';

  @override
  String circlesInviteSent(Object username) {
    return 'Invito inviato a @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Invio invito fallito: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Richiesta di accesso inviata';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Richiesta fallita: $error';
  }

  @override
  String get circlesFull => 'Circle pieno';

  @override
  String get circlesSpectatorAdded => 'Spettatore aggiunto';

  @override
  String circlesApproveFailed(Object error) {
    return 'Approvazione richiesta fallita: $error';
  }

  @override
  String get circlesRequestDeclined => 'Richiesta rifiutata';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Rifiuto richiesta fallito: $error';
  }

  @override
  String get circlesParticipant => 'Partecipante';

  @override
  String get circlesLeavePromptTitle => 'Uscire dal Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Trasferisci l\'host prima di uscire.';

  @override
  String get circlesLeavePromptEndOnly => 'Termina il Circle ed esci.';

  @override
  String get circlesTransferHost => 'Trasferisci host';

  @override
  String get circlesEndCircle => 'Termina Circle';

  @override
  String get circlesTransferHostTitle => 'Trasferisci host';

  @override
  String circlesShareId(Object id) {
    return 'ID Circle: $id';
  }
}
