// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Apprendre. Concourir. Maîtriser.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get authFillAllFields => 'Veuillez remplir tous les champs';

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
    return 'Erreur : $error';
  }

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authUsername => 'Nom d\'utilisateur';

  @override
  String get authContinue => 'Continuer';

  @override
  String get authSigningIn => 'Connexion en cours...';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authCreating => 'Création en cours...';

  @override
  String get authNeedAccount => 'Vous n\'avez pas de compte ? ';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get dialogAuthRequiredTitle =>
      'Connectez-vous pour accéder aux Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Les Circles sont des salles multijoueurs. Créez un compte pour rejoindre des matchs en direct, inviter des amis et sauvegarder votre progression.';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profil';

  @override
  String get removeCourseTitle => 'Retirer le cours ?';

  @override
  String removeCourseBody(Object course) {
    return '$course sera retiré de votre liste d\'accueil.';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Retirer';

  @override
  String welcomeBack(Object name) {
    return 'Bon retour, $name !';
  }

  @override
  String get editCourses => 'Modifier les cours';

  @override
  String get done => 'Terminé';

  @override
  String get noCoursesToEdit => 'Aucun cours à modifier.';

  @override
  String get addCourse => 'Ajouter un cours';

  @override
  String get unknown => 'Inconnu';

  @override
  String get iSpeak => 'Je parle';

  @override
  String get iWantToLearn => 'Je veux apprendre';

  @override
  String get chooseYourLanguage => 'Choisissez votre langue';

  @override
  String get chooseLearningLanguage => 'Choisissez la langue d\'apprentissage';

  @override
  String get chooseTwoDifferentLanguages =>
      'Choisissez deux langues différentes.';

  @override
  String get createCourse => 'Créer un cours';

  @override
  String get soloCourseTitle => 'Cours solo';

  @override
  String get searchLanguage => 'Rechercher une langue';

  @override
  String get noMatches => 'Aucun résultat';

  @override
  String get chooseCourseType => 'Choisissez un type de cours';

  @override
  String get soloStudyDescription =>
      'Étudiez seul avec le même style de quiz que les circles - mais sans salles, chat, spectateurs ou options d\'hôte.';

  @override
  String get soloModeVocabulary => 'Vocabulaire';

  @override
  String get soloModeSentences => 'Phrases';

  @override
  String get soloModeReview => 'Révision';

  @override
  String get soloModeVocabularySubtitle =>
      'Choix multiples de significations, synonymes, usage';

  @override
  String get soloModeSentencesSubtitle =>
      'Remplir le blanc + traduction + lecture';

  @override
  String get soloModeReviewDescription =>
      'Pratiquez ce que vous avez appris : mots faibles, erreurs récentes et répétition espacée.';

  @override
  String get startReview => 'Démarrer la révision';

  @override
  String soloSetupTitle(Object mode) {
    return 'Configuration $mode';
  }

  @override
  String get difficulty => 'Difficulté';

  @override
  String get numberOfQuestions => 'Nombre de questions';

  @override
  String get timerPerQuestion => 'Chronomètre par question';

  @override
  String get noTimer => 'Pas de chronomètre';

  @override
  String get start => 'Démarrer';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSignInToMessage => 'Connectez-vous pour envoyer un message';

  @override
  String get profileThatsYourProfile => 'C\'est votre profil';

  @override
  String get profileSignInToAddFriends =>
      'Connectez-vous pour ajouter des amis';

  @override
  String get profileCantAddYourself =>
      'Vous ne pouvez pas vous ajouter vous-même';

  @override
  String profileRequestSent(Object username) {
    return 'Demande envoyée à @$username';
  }

  @override
  String get profileRequestFailed => 'Impossible d\'envoyer la demande';

  @override
  String get profileDefaultDisplayName => 'Nouvel utilisateur';

  @override
  String get profileDefaultBio => 'Prêt à apprendre !';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Invité';

  @override
  String get guestUsername => 'invité';

  @override
  String get guestSessionLabel => 'Session invité';

  @override
  String get unlockFullProfile => 'Débloquez votre profil complet';

  @override
  String get guestBenefitSync => 'Synchronisez la progression entre appareils';

  @override
  String get guestBenefitCircles => 'Rejoignez les Circles et jouez en direct';

  @override
  String get guestBenefitNotifications =>
      'Recevez des notifications et demandes d\'amis';

  @override
  String get progressStaysOnDevice =>
      'La progression reste sur cet appareil jusqu\'à ce que vous vous connectiez.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Objectif : ${minutes}m';
  }

  @override
  String get profileXpProgress => 'Progression XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Victoires';

  @override
  String get profileStreak => 'Série';

  @override
  String get profileFriendsTitle => 'Mes amis';

  @override
  String get profileViewAll => 'Tout voir';

  @override
  String get profileAchievementsTitle => 'Réalisations';

  @override
  String get profileNoAchievements => 'Aucune réalisation pour l\'instant.';

  @override
  String get profileRequested => 'Demandé';

  @override
  String get profileSending => 'Envoi en cours...';

  @override
  String get profileAddFriend => 'Ajouter un ami';

  @override
  String get profileConnectTitle => 'Connecter';

  @override
  String get profileMessage => 'Message';

  @override
  String get profileSnapshot => 'Aperçu du profil';

  @override
  String get profileLocationHidden => 'Localisation masquée';

  @override
  String get profileBioHidden => 'Bio masquée';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Objectif quotidien ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Invitation Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle : $id';
  }

  @override
  String get signInToJoin => 'Se connecter pour rejoindre';

  @override
  String get joiningCircle => 'Rejoindre...';

  @override
  String get joinCircle => 'Rejoindre le Circle';

  @override
  String get circleJoinedAsPlayer => 'Rejoint en tantque joueur';

  @override
  String get circleJoinedAsSpectator => 'Rejoint en tant que spectateur';

  @override
  String get accept => 'Accepter';

  @override
  String get decline => 'Refuser';

  @override
  String get open => 'Ouvrir';

  @override
  String get circleCountdownTitle => 'Préparez-vous';

  @override
  String get circleCountdownSubtitle => 'Le Circle démarre...';

  @override
  String get userFallbackName => 'Utilisateur';

  @override
  String get micOff => 'Micro désactivé';

  @override
  String get micOn => 'Micro activé';

  @override
  String get roleHost => 'Hôte';

  @override
  String get roleSpectator => 'Spectateur';

  @override
  String get tagHost => 'HÔTE';

  @override
  String get tagYou => 'VOUS';

  @override
  String get statusCorrect => 'Correct';

  @override
  String get statusWrong => 'Faux';

  @override
  String get statusWaiting => 'En attente';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pts';

  @override
  String get pointsLabel => 'Points';

  @override
  String get statCorrect => 'Correct';

  @override
  String get statAnswers => 'réponses';

  @override
  String get statTotal => 'Total';

  @override
  String get statQuestions => 'questions';

  @override
  String get statAccuracy => 'Précision';

  @override
  String get statRate => 'taux';

  @override
  String get statRank => 'Rang';

  @override
  String get statPosition => 'position';

  @override
  String get statMode => 'Mode';

  @override
  String get statType => 'type';

  @override
  String get next => 'Suivant';

  @override
  String get submit => 'Soumettre';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get save => 'Enregistrer';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get backToCourse => 'Retour au cours';

  @override
  String get resultsTitle => 'Résultats';

  @override
  String get shareLater => 'Partager plus tard';

  @override
  String get delete => 'Supprimer';

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
    return '${count}j';
  }

  @override
  String get timeJustNow => 'à l\'instant';

  @override
  String timeMinutesAgo(Object count) {
    return 'il y a ${count}m';
  }

  @override
  String timeHoursAgo(Object count) {
    return 'il y a ${count}h';
  }

  @override
  String timeDaysAgo(Object count) {
    return 'il y a ${count}j';
  }

  @override
  String get liveQuizWaitingForHost => 'En attente de l\'hôte...';

  @override
  String get liveQuizJoinRequestSent => 'Demande de rejoindre envoyée';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Échec de la demande : $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Contrôles de l\'hôte';

  @override
  String get liveQuizSpectatorModeTitle => 'Mode spectateur';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Les tours avancent automatiquement lorsque tout le monde répond ou que le temps s\'écoule.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Regardez les questions et le classement en direct. Vous ne pouvez pas répondre.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Question $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Demande envoyée';

  @override
  String get liveQuizRequestToJoin => 'Demander à rejoindre';

  @override
  String get liveQuizSpectatorFooter =>
      'Vous regardez en direct. Profitez des questions et du classement.';

  @override
  String get circleNotFound => 'Circle introuvable';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Échec du démarrage de la revanche : $error';
  }

  @override
  String get resultsMatchTitle => 'Résultats du match';

  @override
  String resultsNiceWork(Object name) {
    return 'Bon travail, $name';
  }

  @override
  String get resultsPlaceFirst => '1ère place';

  @override
  String get resultsPlaceSecond => '2ème place';

  @override
  String get resultsPlaceThird => '3ème place';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Place $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Sur $players joueurs';
  }

  @override
  String get resultsHighlightChampion =>
      'Champion ! Vous avez dominé ce circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Excellente précision. Vous êtes proche du sommet !';

  @override
  String get resultsHighlightKeepGoing =>
      'Continuez - la constance bat la vitesse.';

  @override
  String get resultsLeaderboardTitle => 'Classement';

  @override
  String resultsPlayersCount(Object count) {
    return '$count joueurs';
  }

  @override
  String get resultsBackToCircles => 'Retour aux Circles';

  @override
  String get resultsRematch => 'Revanche';

  @override
  String get resultsPlayAgain => 'Rejouer';

  @override
  String get leaderboardGlobalTitle => 'Classement mondial';

  @override
  String get leaderboardEmpty => 'Aucun classement pour l\'instant.';

  @override
  String get aboutTitle => 'Info';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'SOMA est une plateforme d\'apprentissage des langues gamifiée conçue pour rendre la maîtrise de nouvelles langues engageante et sociale. Participez à des circles, pratiquez en solo et suivez votre progression.';

  @override
  String get aboutTerms => 'Conditions d\'utilisation';

  @override
  String get aboutPrivacy => 'Politique de confidentialité';

  @override
  String get aboutOpenSource => 'Licences open source';

  @override
  String get addFriendTitle => 'Ajouter un ami';

  @override
  String get addFriendFindByUsername => 'Trouver par nom d\'utilisateur';

  @override
  String get addFriendUsernameHint => 'Tapez le nom d\'utilisateur...';

  @override
  String get addFriendTip =>
      'Astuce : plus tard, nous pourrons prendre en charge le QR code + ID ami.';

  @override
  String get addFriendSending => 'Envoi en cours...';

  @override
  String get addFriendSendRequest => 'Envoyer la demande';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Utilisateur @$username introuvable';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Action échouée ou déjà envoyée : $error';
  }

  @override
  String get friendsTitle => 'Amis';

  @override
  String get searchFriendsHint => 'Rechercher des amis...';

  @override
  String get somaLearnerSubtitle => 'Apprenant Soma';

  @override
  String get friendRequestLabel => 'Demande';

  @override
  String get friendRequestSentLabel => 'Demande envoyée';

  @override
  String get friendIncomingRequestLabel => 'Demande entrante';

  @override
  String get friendRequestsSection => 'Demandes';

  @override
  String get friendPendingSection => 'En attente';

  @override
  String get friendAllSection => 'Tous les amis';

  @override
  String get friendsEmptyState =>
      'Pas encore d\'amis. Ajoutez votre premier ami !';

  @override
  String get friendsEmptyShort => 'Pas encore d\'amis.';

  @override
  String noMatchForQuery(Object query) {
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String get inboxTitle => 'Boîte de réception';

  @override
  String get searchChatsHint => 'Rechercher des discussions...';

  @override
  String get inboxEmptyState =>
      'Pas encore de conversations. Commencez à discuter avec un ami !';

  @override
  String get newMessageTitle => 'Nouveau message';

  @override
  String get chatCallLater =>
      'Appel vocal plus tard (la voix Circle est suivante)';

  @override
  String errorWithDetails(Object error) {
    return 'Erreur : $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Dites bonjour à $name !';
  }

  @override
  String get chatMessageHint => 'Message...';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsTabAll => 'Toutes';

  @override
  String get notificationsTabCourses => 'Cours';

  @override
  String get notificationsTabSocial => 'Social';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Système';

  @override
  String get notificationsEmpty => 'Aucune notification ici.';

  @override
  String get notificationsDeleted => 'Notification supprimée';

  @override
  String get notificationTitleFallback => 'Notification';

  @override
  String get notificationTypeCourse => 'Cours';

  @override
  String get notificationTypeSocial => 'Social';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Système';

  @override
  String get notificationsFriendAccepted => 'Demande d\'ami acceptée';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Impossible d\'accepter la demande d\'ami : $error';
  }

  @override
  String get notificationsFriendDeclined => 'Demande d\'ami refusée';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Impossible de refuser la demande d\'ami : $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Impossible de rejoindre le circle : $error';
  }

  @override
  String get notificationsOpening => 'Ouverture';

  @override
  String get notificationsOpened => 'Ouvert';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notification';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsEditProfile => 'Modifier le profil';

  @override
  String get settingsPrivacy => 'Confidentialité';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Afficher la ligne de traduction';

  @override
  String get settingsShowReadingLine => 'Afficher la lecture (pinyin/romaji)';

  @override
  String get settingsDefaultTimerPerQuestion =>
      'Chronomètre par défaut par question';

  @override
  String get settingsMatchDifficulty => 'Difficulté de match';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptatif';

  @override
  String get settingsSectionSoundFeel => 'Son et ressenti';

  @override
  String get settingsMusic => 'Musique';

  @override
  String get settingsSoundEffects => 'Effets sonores';

  @override
  String get settingsHaptics => 'Haptiques';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsDailyReminder => 'Rappel quotidien';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsUiLanguage => 'Langue de l\'interface';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsTermsPrivacy => 'Conditions et confidentialité';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsLogout => 'Se déconnecter';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

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
  String get editProfileUpdated => 'Profil mis à jour';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get editProfilePhotoLabel => 'Photo de profil';

  @override
  String get editProfilePhotoSubtitle =>
      'Sélection d\'avatar via Supabase Storage à venir.';

  @override
  String get editProfileChangePhoto => 'Changer';

  @override
  String get editProfileAvatarUploadSoon =>
      'Téléchargement d\'avatar bientôt disponible';

  @override
  String get editProfileDisplayNameLabel => 'Nom d\'affichage';

  @override
  String get editProfileDisplayNameHint => 'Votre nom';

  @override
  String get editProfileDisplayNameRequired => 'Entrez votre nom';

  @override
  String get editProfileDisplayNameTooShort => 'Trop court';

  @override
  String get editProfileUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get editProfileUsernameHint => 'alex_apprenant';

  @override
  String get editProfileUsernameRequired => 'Entrez le nom d\'utilisateur';

  @override
  String get editProfileUsernameTooShort => 'Min 3 caractères';

  @override
  String get editProfileUsernameInvalid => 'Seulement lettres, chiffres, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Courte bio...';

  @override
  String get editProfileBioTooLong => 'Max 120 caractères';

  @override
  String get editProfileLocationLabel => 'Localisation';

  @override
  String get editProfileLocationHint => 'Ville / Pays';

  @override
  String get editProfileDailyGoalTitle => 'Objectif quotidien';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Choisissez combien de minutes vous souhaitez étudier quotidiennement.';

  @override
  String get securityTitle => 'Sécurité';

  @override
  String get securitySectionPassword => 'Mot de passe';

  @override
  String get securityChangePasswordTitle => 'Changer le mot de passe';

  @override
  String get securityChangePasswordSubtitle =>
      'Mettez à jour votre mot de passe régulièrement.';

  @override
  String get securitySectionTwoFactor => 'Authentification à deux facteurs';

  @override
  String get securityEnable2faTitle => 'Activer l\'A2F';

  @override
  String get securityEnable2faSubtitle =>
      'Protection supplémentaire lors de la connexion.';

  @override
  String get securitySectionAppLock => 'Verrouillage de l\'application';

  @override
  String get securityBiometricTitle => 'Déverrouillage biométrique';

  @override
  String get securityBiometricSubtitle =>
      'Utilisez FaceID/TouchID pour déverrouiller SOMA.';

  @override
  String get securityAppLockTitle => 'Verrouillage de l\'application';

  @override
  String get securityAppLockSubtitle =>
      'Verrouillez SOMA lorsque vous quittez l\'application.';

  @override
  String get securitySectionSessions => 'Sessions actives';

  @override
  String get securityNoSessions => 'Aucune session active trouvée.';

  @override
  String get securityThisDevice => 'Cet appareil';

  @override
  String get securityDevice => 'Appareil';

  @override
  String get securityActiveLabel => 'Actif';

  @override
  String get securitySignInToEnable2fa => 'Connectez-vous pour activer l\'A2F';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Impossible d\'activer l\'A2F : $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Impossible de désactiver l\'A2F : $error';
  }

  @override
  String get securitySetup2faTitle => 'Configurer l\'A2F';

  @override
  String get securitySecretKeyLabel => 'Clé secrète';

  @override
  String get securityCodeHint => 'Code à 6 chiffres';

  @override
  String get security2faEnabled => 'A2F activée';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Impossible de vérifier le code : $error';
  }

  @override
  String get securityVerifying => 'Vérification en cours...';

  @override
  String get securityVerify => 'Vérifier';

  @override
  String get securityCurrentPasswordHint => 'Mot de passe actuel';

  @override
  String get securityNewPasswordHint =>
      'Nouveau mot de passe (min 8 caractères)';

  @override
  String get securityConfirmPasswordHint => 'Confirmez le nouveau mot de passe';

  @override
  String get securitySignInToChangePassword =>
      'Connectez-vous pour changer votre mot de passe';

  @override
  String get securityEnterCurrentPassword => 'Entrez votre mot de passe actuel';

  @override
  String get securityPasswordMinLength =>
      'Le nouveau mot de passe doit comporter au moins 8 caractères';

  @override
  String get securityPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get securityPasswordUpdated => 'Mot de passe mis à jour';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Impossible de mettre à jour le mot de passe : $error';
  }

  @override
  String get securityAutoLockAfter => 'Verrouillage automatique après';

  @override
  String get privacyTitle => 'Confidentialité';

  @override
  String get privacySectionVisibility => 'Visibilité';

  @override
  String get privacyProfileVisibilityTitle => 'Visibilité du profil';

  @override
  String get privacyVisibilityPublic => 'Public';

  @override
  String get privacyVisibilityFriends => 'Amis';

  @override
  String get privacyVisibilityPrivate => 'Privé';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Tout le monde peut voir votre profil.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Seuls les amis peuvent voir votre profil.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Vous seul pouvez voir votre profil.';

  @override
  String get privacySectionActivity => 'Activité';

  @override
  String get privacyShowOnlineTitle => 'Afficher le statut en ligne';

  @override
  String get privacyShowOnlineSubtitle =>
      'Permettre aux autres de voir quand vous êtes en ligne.';

  @override
  String get privacyShowActivityTitle =>
      'Afficher l\'activité d\'apprentissage';

  @override
  String get privacyShowActivitySubtitle =>
      'Afficher la série, les XP et la progression récente.';

  @override
  String get privacySectionSocial => 'Social';

  @override
  String get privacyAllowRequestsTitle => 'Autoriser les demandes d\'amis';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Permettre aux gens de vous envoyer des demandes d\'amis.';

  @override
  String get privacyWhoCanDmTitle => 'Qui peut vous envoyer des DM';

  @override
  String get privacyDmEveryone => 'Tout le monde';

  @override
  String get privacyDmFriends => 'Amis';

  @override
  String get privacyDmNoOne => 'Personne';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Tout le monde peut vous envoyer un message.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Seuls les amis peuvent vous envoyer un message.';

  @override
  String get privacyDmNoOneSubtitle =>
      'Personne ne peut vous envoyer un message.';

  @override
  String get privacySectionBlockedUsers => 'Utilisateurs bloqués';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Gestion des utilisateurs bloqués bientôt disponible.';

  @override
  String get privacySectionDataControls => 'Contrôles des données';

  @override
  String get privacyExportDataTitle => 'Exporter mes données';

  @override
  String get privacyExportDataSubtitle =>
      'Téléchargez votre activité et vos cours.';

  @override
  String get privacyExportInfoTitle => 'Exporter les données';

  @override
  String get privacyExportInfoBody =>
      'Prochaine étape : générer une exportation JSON/CSV et l\'envoyer par e-mail ou la télécharger localement.';

  @override
  String get privacyDeleteAccountTitle => 'Supprimer le compte';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Cela supprime définitivement votre compte et vos données.';

  @override
  String get privacyDeleteConfirmTitle => 'Supprimer le compte ?';

  @override
  String get privacyDeleteConfirmBody =>
      'Cette action est permanente. Votre profil, vos cours, vos amis et vos messages seront supprimés.';

  @override
  String get privacyDeleteComingSoon =>
      'La suppression sera connectée à Supabase plus tard';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Session solo terminée';

  @override
  String get soloResultsFeedbackElite =>
      'Performance d\'élite. Continuez la série';

  @override
  String get soloResultsFeedbackStrong =>
      'Bon travail. Vous progressez rapidement.';

  @override
  String get soloResultsFeedbackProgress =>
      'Bonne progression. Révisez les erreurs et répétez.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Pas de stress. Réessayez avec moins de questions et concentrez-vous.';

  @override
  String get soloResultsPerfectScore =>
      'Score parfait ! Aucune erreur à réviser.';

  @override
  String get soloResultsReviewPrompt =>
      'Révisez les erreurs pour apprendre plus vite. Nous vous montrerons les mauvaises réponses ici ensuite.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Réviser les erreurs ($count)';
  }

  @override
  String get authNotSignedIn => 'Vous n\'êtes pas connecté';

  @override
  String get genericUser => 'Utilisateur';

  @override
  String get loading => 'Chargement...';

  @override
  String get edit => 'Modifier';

  @override
  String get send => 'Envoyer';

  @override
  String get join => 'Rejoindre';

  @override
  String get leave => 'Quitter';

  @override
  String get ready => 'Prêt';

  @override
  String get levelBeginner => 'Débutant';

  @override
  String get levelIntermediate => 'Intermédiaire';

  @override
  String get levelAdvanced => 'Avancé';

  @override
  String questionsShort(Object count) {
    return '$count Q';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'Tous les cours';

  @override
  String get circlesAllModes => 'Tous les modes';

  @override
  String get circlesAllLevels => 'Tous les niveaux';

  @override
  String get circlesAddNewCourse => 'Ajouter un nouveau cours';

  @override
  String get circlesCoursesTitle => 'Cours';

  @override
  String get circlesModeTitle => 'Mode';

  @override
  String get circlesLevelTitle => 'Niveau';

  @override
  String get circlesNoActiveForFilters =>
      'Aucun circle actif pour ces filtres.';

  @override
  String get circlesUnknownRoom => 'Salle inconnue';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Créer un Circle';

  @override
  String get circlesCircleName => 'Nom du Circle';

  @override
  String get circlesEnterName => 'Entrez un nom';

  @override
  String get circlesLanguages => 'Langues';

  @override
  String get circlesRoomSetup => 'Configuration de la salle';

  @override
  String get circlesPlayers => 'Joueurs';

  @override
  String get circlesEmptySlot => 'Emplacement vide';

  @override
  String get circlesPlayersRange => '1-5 joueurs';

  @override
  String get circlesQuestions => 'Questions';

  @override
  String get circlesQuestionsSubtitle => 'Nombre de questions';

  @override
  String get circlesTimePerQuestion => 'Temps par question';

  @override
  String get circlesSecondsPerQuestion => 'secondes par question';

  @override
  String get circlesAdvanced => 'Avancé';

  @override
  String get circlesAllowSpectators => 'Autoriser les spectateurs';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Permettre aux autres de regarder sans jouer.';

  @override
  String get circlesLiveVoiceChat => 'Chat vocal en direct';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Activer la voix en direct pendant les matchs.';

  @override
  String get circlesLiveTextChat => 'Chat texte en direct';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Activer le chat pendant les matchs.';

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
  String get circlesCreatedSuccess => 'Circle créé';

  @override
  String circlesCreateError(Object error) {
    return 'Échec de la création du circle : $error';
  }

  @override
  String get circlesHostTip =>
      'Astuce : vous pouvez inviter des amis après la création.';

  @override
  String circlesJoinError(Object error) {
    return 'Échec de rejoindre le circle : $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby du Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Code : $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Paramètres du match';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Niveau $level';
  }

  @override
  String get circlesDifficulty => 'Difficulté';

  @override
  String get circlesPerQuestionShort => 'par question';

  @override
  String get circlesInvite => 'Inviter';

  @override
  String get circlesCopyId => 'Copier l\'ID';

  @override
  String get circlesCopiedId => 'ID copié';

  @override
  String get circlesMatchInProgress => 'Match en cours';

  @override
  String get circlesSpectatorQueuedBody =>
      'Le match est en cours. Vous rejoindrez en tant que spectateur.';

  @override
  String get circlesHostStartWhenReady =>
      'L\'hôte démarre quand tout le monde est prêt.';

  @override
  String get circlesSpectators => 'Spectateurs';

  @override
  String get circlesSpectator => 'Spectateur';

  @override
  String get circlesSpectatorCanWatch =>
      'Les spectateurs peuvent regarder en direct.';

  @override
  String get circlesJoinRequests => 'Demandes de rejoindre';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Acceptez les spectateurs avant le début du match.';

  @override
  String get circlesStartGame => 'Démarrer le jeu';

  @override
  String get circlesWaitingForPlayers => 'En attente de joueurs';

  @override
  String get circlesLeaveCircle => 'Quitter le circle';

  @override
  String get circlesRequestSent => 'Demande envoyée';

  @override
  String get circlesRequestToJoin => 'Demander à rejoindre';

  @override
  String get circlesWatchLive => 'Regarder en direct';

  @override
  String get circlesPlayerTip =>
      'Appuyez sur Prêt quand vous êtes prêt. L\'hôte démarrera le match.';

  @override
  String get circlesSpectatorTip =>
      'Vous êtes spectateur. Regardez en direct une fois que l\'hôte démarre.';

  @override
  String get circlesHostControls => 'Contrôles de l\'hôte';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Échec du transfert de l\'hôte : $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Échec de la fin du circle : $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Utilisateur @$username introuvable';
  }

  @override
  String get circlesInvalidUser => 'Utilisateur invalide';

  @override
  String get circlesCantInviteSelf =>
      'Vous ne pouvez pas vous inviter vous-même';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'L\'utilisateur @$username est déjà dans le circle';
  }

  @override
  String get circlesDefaultHost => 'Hôte';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Inviter par nom d\'utilisateur';

  @override
  String circlesInviteSent(Object username) {
    return 'Invitation envoyée à @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Échec de l\'envoi de l\'invitation : $error';
  }

  @override
  String get circlesJoinRequestSent => 'Demande de rejoindre envoyée';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Échec de la demande : $error';
  }

  @override
  String get circlesFull => 'Le circle est plein';

  @override
  String get circlesSpectatorAdded => 'Spectateur ajouté';

  @override
  String circlesApproveFailed(Object error) {
    return 'Échec de l\'approbation de la demande : $error';
  }

  @override
  String get circlesRequestDeclined => 'Demande refusée';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Échec du refus de la demande : $error';
  }

  @override
  String get circlesParticipant => 'Participant';

  @override
  String get circlesLeavePromptTitle => 'Quitter le circle ?';

  @override
  String get circlesLeavePromptTransfer =>
      'Transférez l\'hôte avant de partir.';

  @override
  String get circlesLeavePromptEndOnly => 'Terminez le circle et partez.';

  @override
  String get circlesTransferHost => 'Transférer l\'hôte';

  @override
  String get circlesEndCircle => 'Terminer le circle';

  @override
  String get circlesTransferHostTitle => 'Transférer l\'hôte';

  @override
  String circlesShareId(Object id) {
    return 'ID du Circle : $id';
  }
}
