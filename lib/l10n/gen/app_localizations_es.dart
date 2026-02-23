// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Aprende. Compite. Domina.';

  @override
  String welcome(Object name) {
    return '¡Bienvenido, $name!';
  }

  @override
  String get signUp => 'Registrate';

  @override
  String get signIn => 'Iniciar sesion';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get authFillAllFields => 'Por favor completa todos los campos';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authForgotPasswordBody =>
      'Ingresa el correo vinculado a tu cuenta. Te enviaremos un enlace de recuperación.';

  @override
  String get authSendResetLink => 'Enviar enlace de recuperación';

  @override
  String get authResetSentTitle => 'Revisa tu correo';

  @override
  String get authResetSentBody =>
      'Enviamos un enlace para restablecer tu contraseña. Sigue las instrucciones para establecer una nueva.';

  @override
  String get authResetFailedTitle => 'Error al restablecer';

  @override
  String get authSignUpConfirmTitle => 'Confirma tu correo';

  @override
  String authSignUpConfirmBody(Object email) {
    return 'Enviamos un correo de confirmación de SOMA a $email. Por favor confírmalo antes de continuar.';
  }

  @override
  String get authEmailResent => 'Correo de confirmación enviado de nuevo.';

  @override
  String authEmailResendFailed(Object error) {
    return 'No se pudo reenviar el correo: $error';
  }

  @override
  String get resend => 'Reenviar';

  @override
  String authError(Object error) {
    return 'Error: $error';
  }

  @override
  String get authEmail => 'Correo';

  @override
  String get authPassword => 'Contrasena';

  @override
  String get authUsername => 'Usuario';

  @override
  String get authContinue => 'Continuar';

  @override
  String get authSigningIn => 'Iniciando sesion...';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authCreating => 'Creando...';

  @override
  String get authNeedAccount => 'No tienes una cuenta? ';

  @override
  String get authHaveAccount => 'Ya tienes una cuenta? ';

  @override
  String get dialogAuthRequiredTitle => 'Inicia sesion para acceder a Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles son salas multijugador. Crea una cuenta para unirte a partidas en vivo, invitar amigos y guardar progreso.';

  @override
  String get notNow => 'Ahora no';

  @override
  String get navHome => 'Inicio';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Perfil';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'Eliminar curso?';

  @override
  String removeCourseBody(Object course) {
    return '$course se eliminara de tu lista de inicio.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String welcomeBack(Object name) {
    return 'Bienvenido de nuevo, $name!';
  }

  @override
  String get editCourses => 'Editar cursos';

  @override
  String get done => 'Listo';

  @override
  String get noCoursesToEdit => 'No hay cursos para editar.';

  @override
  String get addCourse => 'Agregar curso';

  @override
  String get unknown => 'Desconocido';

  @override
  String get iSpeak => 'Hablo';

  @override
  String get iWantToLearn => 'Quiero aprender';

  @override
  String get chooseYourLanguage => 'Elige tu idioma';

  @override
  String get chooseLearningLanguage => 'Elige idioma a aprender';

  @override
  String get chooseTwoDifferentLanguages => 'Elige dos idiomas diferentes.';

  @override
  String get createCourse => 'Crear curso';

  @override
  String get soloCourseTitle => 'Curso en solitario';

  @override
  String get searchLanguage => 'Buscar idioma';

  @override
  String get noMatches => 'Sin resultados';

  @override
  String get chooseCourseType => 'Elige un tipo de curso';

  @override
  String get soloStudyDescription =>
      'Estudia solo con el mismo estilo de cuestionario que Circles - pero sin salas, chat, espectadores ni opciones de anfitrion.';

  @override
  String get soloModeVocabulary => 'Vocabulario';

  @override
  String get soloModeSentences => 'Oraciones';

  @override
  String get soloModeReview => 'Revision';

  @override
  String get soloModeVocabularySubtitle =>
      'Significados de opcion multiple, sinonimos, uso';

  @override
  String get soloModeSentencesSubtitle =>
      'Completa el espacio + traduccion + lectura';

  @override
  String get soloModeReviewDescription =>
      'Practica lo aprendido: palabras debiles, errores recientes y repeticion espaciada.';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'Iniciar revision';

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
    return 'Configuracion de $mode';
  }

  @override
  String get difficulty => 'Dificultad';

  @override
  String get numberOfQuestions => 'Numero de preguntas';

  @override
  String get timerPerQuestion => 'Temporizador por pregunta';

  @override
  String get noTimer => 'Sin temporizador';

  @override
  String get start => 'Iniciar';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileSignInToMessage => 'Inicia sesion para enviar mensajes';

  @override
  String get profileThatsYourProfile => 'Ese es tu perfil';

  @override
  String get profileSignInToAddFriends => 'Inicia sesion para agregar amigos';

  @override
  String get profileCantAddYourself => 'No puedes agregarte';

  @override
  String profileRequestSent(Object username) {
    return 'Solicitud enviada a @$username';
  }

  @override
  String get profileRequestFailed => 'No se pudo enviar la solicitud';

  @override
  String get profileDefaultDisplayName => 'Nuevo usuario';

  @override
  String get profileDefaultBio => 'Listo para aprender!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Invitado';

  @override
  String get guestUsername => 'invitado';

  @override
  String get guestSessionLabel => 'Sesion de invitado';

  @override
  String get unlockFullProfile => 'Desbloquea tu perfil completo';

  @override
  String get guestBenefitSync => 'Sincroniza progreso entre dispositivos';

  @override
  String get guestBenefitCircles => 'Unete a Circles y juega en vivo';

  @override
  String get guestBenefitNotifications =>
      'Recibe notificaciones y solicitudes de amistad';

  @override
  String get progressStaysOnDevice =>
      'El progreso queda en este dispositivo hasta que inicies sesion.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Meta: ${minutes}m';
  }

  @override
  String get profileXpProgress => 'Progreso de XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Victorias';

  @override
  String get profileStreak => 'Racha';

  @override
  String get profileFriendsTitle => 'Mis amigos';

  @override
  String get profileViewAll => 'Ver todo';

  @override
  String get profileAchievementsTitle => 'Logros';

  @override
  String get profileNoAchievements => 'Aun no hay logros.';

  @override
  String get profileRequested => 'Solicitado';

  @override
  String get profileSending => 'Enviando...';

  @override
  String get profileAddFriend => 'Agregar amigo';

  @override
  String get profileConnectTitle => 'Conectar';

  @override
  String get profileMessage => 'Mensaje';

  @override
  String get profileSnapshot => 'Resumen del perfil';

  @override
  String get profileLocationHidden => 'Ubicacion oculta';

  @override
  String get profileBioHidden => 'Bio oculta';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Meta diaria ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Invitacion a Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID del Circle: $id';
  }

  @override
  String get signInToJoin => 'Inicia sesion para unirte';

  @override
  String get joiningCircle => 'Uniendose...';

  @override
  String get joinCircle => 'Unirse al Circle';

  @override
  String get circleJoinedAsPlayer => 'Unido como jugador';

  @override
  String get circleJoinedAsSpectator => 'Unido como espectador';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get open => 'Abrir';

  @override
  String get circleCountdownTitle => 'Preparado';

  @override
  String get circleCountdownSubtitle => 'El Circle esta por empezar...';

  @override
  String get userFallbackName => 'Usuario';

  @override
  String get micOff => 'Microfono apagado';

  @override
  String get micOn => 'Microfono encendido';

  @override
  String get roleHost => 'Anfitrion';

  @override
  String get roleSpectator => 'Espectador';

  @override
  String get tagHost => 'ANFITRION';

  @override
  String get tagYou => 'TU';

  @override
  String get statusCorrect => 'Correcto';

  @override
  String get statusWrong => 'Incorrecto';

  @override
  String get statusWaiting => 'Esperando';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pts';

  @override
  String get pointsLabel => 'Puntos';

  @override
  String get statCorrect => 'Correctas';

  @override
  String get statAnswers => 'respuestas';

  @override
  String get statTotal => 'Total';

  @override
  String get statQuestions => 'preguntas';

  @override
  String get statAccuracy => 'Precision';

  @override
  String get statRate => 'tasa';

  @override
  String get statRank => 'Rango';

  @override
  String get statPosition => 'posicion';

  @override
  String get statMode => 'Modo';

  @override
  String get statType => 'tipo';

  @override
  String get next => 'Siguiente';

  @override
  String get submit => 'Enviar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get save => 'Guardar';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get backToCourse => 'Volver al curso';

  @override
  String get resultsTitle => 'Resultados';

  @override
  String get shareLater => 'Compartir luego';

  @override
  String get delete => 'Eliminar';

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
  String get timeJustNow => 'justo ahora';

  @override
  String timeMinutesAgo(Object count) {
    return 'hace ${count}m';
  }

  @override
  String timeHoursAgo(Object count) {
    return 'hace ${count}h';
  }

  @override
  String timeDaysAgo(Object count) {
    return 'hace ${count}d';
  }

  @override
  String get liveQuizWaitingForHost => 'Esperando al anfitrion...';

  @override
  String get liveQuizJoinRequestSent => 'Solicitud de ingreso enviada';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'No se pudo solicitar ingreso: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Controles del anfitrion';

  @override
  String get liveQuizSpectatorModeTitle => 'Modo espectador';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Las rondas avanzan automaticamente cuando todos responden o se acaba el tiempo.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Mira las preguntas y el ranking en vivo. No puedes responder.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Pregunta $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Solicitud enviada';

  @override
  String get liveQuizRequestToJoin => 'Solicitar ingreso';

  @override
  String get liveQuizSpectatorFooter =>
      'Estas viendo en vivo. Disfruta las preguntas y el ranking.';

  @override
  String get circleNotFound => 'No se encontro el Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'No se pudo iniciar la revancha: $error';
  }

  @override
  String get resultsMatchTitle => 'Resultados del match';

  @override
  String resultsNiceWork(Object name) {
    return 'Buen trabajo, $name';
  }

  @override
  String get resultsPlaceFirst => '1er lugar';

  @override
  String get resultsPlaceSecond => '2do lugar';

  @override
  String get resultsPlaceThird => '3er lugar';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Lugar $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'De $players jugadores';
  }

  @override
  String get resultsHighlightChampion => 'Campeon! Dominaste este Circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Gran precision. Estas cerca de la cima!';

  @override
  String get resultsHighlightKeepGoing =>
      'Sigue asi - la constancia vence a la velocidad.';

  @override
  String get resultsLeaderboardTitle => 'Ranking';

  @override
  String resultsPlayersCount(Object count) {
    return '$count jugadores';
  }

  @override
  String get resultsBackToCircles => 'Volver a Circles';

  @override
  String get resultsRematch => 'Revancha';

  @override
  String get resultsPlayAgain => 'Jugar de nuevo';

  @override
  String get leaderboardGlobalTitle => 'Ranking global';

  @override
  String get leaderboardEmpty => 'Aun no hay rankings.';

  @override
  String get aboutTitle => 'Info';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'SOMA es una plataforma de aprendizaje de idiomas gamificada, diseniada para hacer el dominio de nuevos idiomas atractivo y social. Compite en Circles, practica solo y sigue tu progreso.';

  @override
  String get aboutTerms => 'Terminos de servicio';

  @override
  String get aboutPrivacy => 'Politica de privacidad';

  @override
  String get aboutOpenSource => 'Licencias de codigo abierto';

  @override
  String get addFriendTitle => 'Agregar amigo';

  @override
  String get addFriendFindByUsername => 'Buscar por usuario';

  @override
  String get addFriendUsernameHint => 'Escribe usuario...';

  @override
  String get addFriendTip => 'Tip: luego podremos soportar QR + ID de amigo.';

  @override
  String get addFriendSending => 'Enviando...';

  @override
  String get addFriendSendRequest => 'Enviar solicitud';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Usuario @$username no encontrado';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'La accion fallo o ya fue enviada: $error';
  }

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get searchFriendsHint => 'Buscar amigos...';

  @override
  String get somaLearnerSubtitle => 'Aprendiz de Soma';

  @override
  String get friendRequestLabel => 'Solicitud';

  @override
  String get friendRequestSentLabel => 'Solicitud enviada';

  @override
  String get friendIncomingRequestLabel => 'Solicitud entrante';

  @override
  String get friendRequestsSection => 'Solicitudes';

  @override
  String get friendPendingSection => 'Pendientes';

  @override
  String get friendAllSection => 'Todos los amigos';

  @override
  String get friendsEmptyState =>
      'Aun no tienes amigos. Agrega tu primer amigo!';

  @override
  String get friendsEmptyShort => 'Aun no hay amigos.';

  @override
  String noMatchForQuery(Object query) {
    return 'Sin coincidencias para \"$query\"';
  }

  @override
  String get inboxTitle => 'Bandeja';

  @override
  String get searchChatsHint => 'Buscar chats...';

  @override
  String get inboxEmptyState =>
      'Aun no hay conversaciones. Empieza a chatear con un amigo!';

  @override
  String get newMessageTitle => 'Nuevo mensaje';

  @override
  String get chatCallLater =>
      'Llamada de voz despues (Circle voice es lo siguiente)';

  @override
  String errorWithDetails(Object error) {
    return 'Error: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Di hola a $name!';
  }

  @override
  String get chatMessageHint => 'Mensaje...';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsTabAll => 'Todo';

  @override
  String get notificationsTabCourses => 'Cursos';

  @override
  String get notificationsTabSocial => 'Social';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Sistema';

  @override
  String get notificationsEmpty => 'No hay notificaciones aqui.';

  @override
  String get notificationsDeleted => 'Notificacion eliminada';

  @override
  String get notificationTitleFallback => 'Notificacion';

  @override
  String get notificationTypeCourse => 'Curso';

  @override
  String get notificationTypeSocial => 'Social';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Sistema';

  @override
  String get notificationsFriendAccepted => 'Solicitud aceptada';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'No se pudo aceptar la solicitud: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Solicitud rechazada';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'No se pudo rechazar la solicitud: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'No se pudo unir al Circle: $error';
  }

  @override
  String get notificationsOpening => 'Abriendo';

  @override
  String get notificationsOpened => 'Abierto';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notificacion';
  }

  @override
  String get settingsTitle => 'Configuracion';

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsPrivacy => 'Privacidad';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsSectionGameplay => 'Jugabilidad';

  @override
  String get settingsShowTranslationLine => 'Mostrar linea de traduccion';

  @override
  String get settingsShowReadingLine => 'Mostrar lectura (pinyin/romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Temporizador por pregunta';

  @override
  String get settingsMatchDifficulty => 'Dificultad del match';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptativo';

  @override
  String get settingsSectionSoundFeel => 'Sonido y sensacion';

  @override
  String get settingsMusic => 'Musica';

  @override
  String get settingsSoundEffects => 'Efectos de sonido';

  @override
  String get settingsHaptics => 'Hapticos';

  @override
  String get settingsSectionNotifications => 'Notificaciones';

  @override
  String get settingsPushNotifications => 'Notificaciones push';

  @override
  String get settingsDailyReminder => 'Recordatorio diario';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Idioma de la app';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsTermsPrivacy => 'Terminos y privacidad';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsLogout => 'Cerrar sesion';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

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
  String get editProfileUpdated => 'Perfil actualizado';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfilePhotoLabel => 'Foto de perfil';

  @override
  String get editProfilePhotoSubtitle =>
      'Seleccion de avatar en Supabase Storage pronto.';

  @override
  String get editProfileChangePhoto => 'Cambiar';

  @override
  String get editProfileAvatarUploadSoon => 'Carga de avatar pronto';

  @override
  String get editProfileDisplayNameLabel => 'Nombre visible';

  @override
  String get editProfileDisplayNameHint => 'Tu nombre';

  @override
  String get editProfileDisplayNameRequired => 'Ingresa tu nombre';

  @override
  String get editProfileDisplayNameTooShort => 'Muy corto';

  @override
  String get editProfileUsernameLabel => 'Usuario';

  @override
  String get editProfileUsernameHint => 'alex_learner';

  @override
  String get editProfileUsernameRequired => 'Ingresa usuario';

  @override
  String get editProfileUsernameTooShort => 'Min 3 caracteres';

  @override
  String get editProfileUsernameInvalid => 'Solo letras, numeros, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Bio corta...';

  @override
  String get editProfileBioTooLong => 'Max 120 caracteres';

  @override
  String get editProfileLocationLabel => 'Ubicacion';

  @override
  String get editProfileLocationHint => 'Ciudad / Pais';

  @override
  String get editProfileDailyGoalTitle => 'Meta diaria';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Elige cuantos minutos quieres estudiar al dia.';

  @override
  String get securityTitle => 'Seguridad';

  @override
  String get securitySectionPassword => 'Contrasena';

  @override
  String get securityChangePasswordTitle => 'Cambiar contrasena';

  @override
  String get securityChangePasswordSubtitle =>
      'Actualiza tu contrasena regularmente.';

  @override
  String get securitySectionTwoFactor => 'Autenticacion de dos factores';

  @override
  String get securityEnable2faTitle => 'Activar 2FA';

  @override
  String get securityEnable2faSubtitle => 'Proteccion extra al iniciar sesion.';

  @override
  String get securitySectionAppLock => 'Bloqueo de app';

  @override
  String get securityBiometricTitle => 'Desbloqueo biometrico';

  @override
  String get securityBiometricSubtitle =>
      'Usa FaceID/TouchID para desbloquear SOMA.';

  @override
  String get securityAppLockTitle => 'Bloqueo de app';

  @override
  String get securityAppLockSubtitle => 'Bloquea SOMA cuando sales de la app.';

  @override
  String get securitySectionSessions => 'Sesiones activas';

  @override
  String get securityNoSessions => 'No se encontraron sesiones activas.';

  @override
  String get securityThisDevice => 'Este dispositivo';

  @override
  String get securityDevice => 'Dispositivo';

  @override
  String get securityActiveLabel => 'Activo';

  @override
  String get securitySignInToEnable2fa => 'Inicia sesion para activar 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'No se pudo activar 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'No se pudo desactivar 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Configurar 2FA';

  @override
  String get securitySecretKeyLabel => 'Clave secreta';

  @override
  String get securityCodeHint => 'Codigo de 6 digitos';

  @override
  String get security2faEnabled => '2FA activado';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'No se pudo verificar el codigo: $error';
  }

  @override
  String get securityVerifying => 'Verificando...';

  @override
  String get securityVerify => 'Verificar';

  @override
  String get securityCurrentPasswordHint => 'Contrasena actual';

  @override
  String get securityNewPasswordHint => 'Nueva contrasena (min 8 caracteres)';

  @override
  String get securityConfirmPasswordHint => 'Confirmar nueva contrasena';

  @override
  String get securitySignInToChangePassword =>
      'Inicia sesion para cambiar tu contrasena';

  @override
  String get securityEnterCurrentPassword => 'Ingresa tu contrasena actual';

  @override
  String get securityPasswordMinLength =>
      'La contrasena debe tener al menos 8 caracteres';

  @override
  String get securityPasswordsDoNotMatch => 'Las contrasenas no coinciden';

  @override
  String get securityPasswordUpdated => 'Contrasena actualizada';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'No se pudo actualizar la contrasena: $error';
  }

  @override
  String get securityAutoLockAfter => 'Bloquear despues de';

  @override
  String get privacyTitle => 'Privacidad';

  @override
  String get privacySectionVisibility => 'Visibilidad';

  @override
  String get privacyProfileVisibilityTitle => 'Visibilidad del perfil';

  @override
  String get privacyVisibilityPublic => 'Publico';

  @override
  String get privacyVisibilityFriends => 'Amigos';

  @override
  String get privacyVisibilityPrivate => 'Privado';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Cualquiera puede ver tu perfil.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Solo amigos pueden ver tu perfil.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Solo tu puedes ver tu perfil.';

  @override
  String get privacySectionActivity => 'Actividad';

  @override
  String get privacyShowOnlineTitle => 'Mostrar estado en linea';

  @override
  String get privacyShowOnlineSubtitle =>
      'Permite que otros vean cuando estas en linea.';

  @override
  String get privacyShowActivityTitle => 'Mostrar actividad de aprendizaje';

  @override
  String get privacyShowActivitySubtitle =>
      'Muestra racha, XP y progreso reciente.';

  @override
  String get privacySectionSocial => 'Social';

  @override
  String get privacyAllowRequestsTitle => 'Permitir solicitudes de amistad';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Permite que otros te envien solicitudes de amistad.';

  @override
  String get privacyWhoCanDmTitle => 'Quien puede enviarte DM';

  @override
  String get privacyDmEveryone => 'Todos';

  @override
  String get privacyDmFriends => 'Amigos';

  @override
  String get privacyDmNoOne => 'Nadie';

  @override
  String get privacyDmEveryoneSubtitle => 'Cualquiera puede enviarte mensajes.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Solo amigos pueden enviarte mensajes.';

  @override
  String get privacyDmNoOneSubtitle => 'Nadie puede enviarte mensajes.';

  @override
  String get privacySectionBlockedUsers => 'Usuarios bloqueados';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Gestion de usuarios bloqueados pronto.';

  @override
  String get privacySectionDataControls => 'Controles de datos';

  @override
  String get privacyExportDataTitle => 'Exportar mis datos';

  @override
  String get privacyExportDataSubtitle => 'Descarga tu actividad y cursos.';

  @override
  String get privacyExportInfoTitle => 'Exportar datos';

  @override
  String get privacyExportInfoBody =>
      'Siguiente paso: generar un export JSON/CSV y enviarlo por correo o descargarlo localmente.';

  @override
  String get privacyDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Esto elimina permanentemente tu cuenta y datos.';

  @override
  String get privacyDeleteConfirmTitle => 'Eliminar cuenta?';

  @override
  String get privacyDeleteConfirmBody =>
      'Esta accion es permanente. Tu perfil, cursos, amigos y mensajes seran eliminados.';

  @override
  String get privacyDeleteComingSoon =>
      'Eliminar se conectara a Supabase mas adelante';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sesion en solitario completada';

  @override
  String get soloResultsFeedbackElite => 'Rendimiento elite. Manten la racha';

  @override
  String get soloResultsFeedbackStrong =>
      'Buen trabajo. Estas mejorando rapido.';

  @override
  String get soloResultsFeedbackProgress =>
      'Buen progreso. Revisa errores y repite.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Sin estres. Intenta de nuevo con menos preguntas y enfoque.';

  @override
  String get soloResultsPerfectScore =>
      'Puntaje perfecto! No hay errores para revisar.';

  @override
  String get soloResultsReviewPrompt =>
      'Revisa errores para aprender mas rapido. Mostraremos respuestas incorrectas aqui luego.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Revisar errores ($count)';
  }

  @override
  String get authNotSignedIn => 'No has iniciado sesion';

  @override
  String get genericUser => 'Usuario';

  @override
  String get loading => 'Cargando...';

  @override
  String get edit => 'Editar';

  @override
  String get send => 'Enviar';

  @override
  String get join => 'Unirse';

  @override
  String get leave => 'Salir';

  @override
  String get ready => 'Listo';

  @override
  String get levelBeginner => 'Principiante';

  @override
  String get levelIntermediate => 'Intermedio';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String questionsShort(Object count) {
    return '$count P';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'Todos los cursos';

  @override
  String get circlesAllModes => 'Todos los modos';

  @override
  String get circlesAllLevels => 'Todos los niveles';

  @override
  String get circlesAddNewCourse => 'Agregar curso';

  @override
  String get circlesCoursesTitle => 'Cursos';

  @override
  String get circlesModeTitle => 'Modo';

  @override
  String get circlesLevelTitle => 'Nivel';

  @override
  String get circlesNoActiveForFilters =>
      'No hay Circles activos para estos filtros.';

  @override
  String get circlesUnknownRoom => 'Sala desconocida';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Crear Circle';

  @override
  String get circlesCircleName => 'Nombre del Circle';

  @override
  String get circlesEnterName => 'Ingresa un nombre';

  @override
  String get circlesLanguages => 'Idiomas';

  @override
  String get circlesRoomSetup => 'Configuracion de sala';

  @override
  String get circlesPlayers => 'Jugadores';

  @override
  String get circlesEmptySlot => 'Espacio vacio';

  @override
  String get circlesPlayersRange => '1-5 jugadores';

  @override
  String get circlesQuestions => 'Preguntas';

  @override
  String get circlesQuestionsSubtitle => 'Cantidad de preguntas';

  @override
  String get circlesTimePerQuestion => 'Tiempo por pregunta';

  @override
  String get circlesSecondsPerQuestion => 'segundos por pregunta';

  @override
  String get circlesAdvanced => 'Avanzado';

  @override
  String get circlesAllowSpectators => 'Permitir espectadores';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Deja que otros miren sin jugar.';

  @override
  String get circlesLiveVoiceChat => 'Chat de voz en vivo';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Habilita voz en vivo durante el match.';

  @override
  String get circlesLiveTextChat => 'Chat de texto en vivo';

  @override
  String get circlesLiveTextChatSubtitle => 'Habilita chat durante el match.';

  @override
  String get circlesRoomLocked => 'Sala bloqueada';

  @override
  String get circlesRoomUnlocked => 'Sala desbloqueada';

  @override
  String get circlesSettingsSaved => 'Ajustes de sala guardados';

  @override
  String circlesUpdateFailed(Object error) {
    return 'No se pudo actualizar la sala: $error';
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
  String get circlesCreatedSuccess => 'Circle creado';

  @override
  String circlesCreateError(Object error) {
    return 'No se pudo crear el Circle: $error';
  }

  @override
  String get circlesHostTip => 'Tip: puedes invitar amigos despues de crear.';

  @override
  String circlesJoinError(Object error) {
    return 'No se pudo unir al Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby del Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Codigo: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Ajustes del match';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Nivel $level';
  }

  @override
  String get circlesDifficulty => 'Dificultad';

  @override
  String get circlesPerQuestionShort => 'por pregunta';

  @override
  String get circlesInvite => 'Invitar';

  @override
  String get circlesCopyId => 'Copiar ID';

  @override
  String get circlesCopiedId => 'ID copiado';

  @override
  String get circlesMatchInProgress => 'Match en progreso';

  @override
  String get circlesSpectatorQueuedBody =>
      'El match esta en progreso. Entraras como espectador.';

  @override
  String get circlesHostStartWhenReady =>
      'El anfitrion inicia cuando todos estan listos.';

  @override
  String get circlesSpectators => 'Espectadores';

  @override
  String get circlesSpectator => 'Espectador';

  @override
  String get circlesSpectatorCanWatch =>
      'Los espectadores pueden mirar en vivo.';

  @override
  String get circlesJoinRequests => 'Solicitudes';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Acepta espectadores antes de que empiece el match.';

  @override
  String get circlesStartGame => 'Iniciar juego';

  @override
  String get circlesStartingGame => 'Starting game...';

  @override
  String get circlesWaitingForPlayers => 'Esperando jugadores';

  @override
  String get circlesLeaveCircle => 'Salir del Circle';

  @override
  String get circlesRequestSent => 'Solicitud enviada';

  @override
  String get circlesRequestToJoin => 'Solicitar ingreso';

  @override
  String get circlesWatchLive => 'Ver en vivo';

  @override
  String get circlesPlayerTip =>
      'Toca Listo cuando estes listo. El anfitrion iniciara el match.';

  @override
  String get circlesSpectatorTip =>
      'Estas espectando. Mira en vivo cuando el anfitrion empiece.';

  @override
  String get circlesHostControls => 'Controles del anfitrion';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'No se pudo transferir anfitrion: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'No se pudo terminar el Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Usuario @$username no encontrado';
  }

  @override
  String get circlesInvalidUser => 'Usuario invalido';

  @override
  String get circlesCantInviteSelf => 'No puedes invitarte';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'Usuario @$username ya esta en el Circle';
  }

  @override
  String get circlesDefaultHost => 'Anfitrion';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Invitar por usuario';

  @override
  String circlesInviteSent(Object username) {
    return 'Invitacion enviada a @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'No se pudo enviar invitacion: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Solicitud enviada';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'No se pudo solicitar ingreso: $error';
  }

  @override
  String get circlesFull => 'Circle lleno';

  @override
  String get circlesSpectatorAdded => 'Espectador agregado';

  @override
  String circlesApproveFailed(Object error) {
    return 'No se pudo aprobar: $error';
  }

  @override
  String get circlesRequestDeclined => 'Solicitud rechazada';

  @override
  String circlesDeclineFailed(Object error) {
    return 'No se pudo rechazar: $error';
  }

  @override
  String get circlesParticipant => 'Participante';

  @override
  String get circlesLeavePromptTitle => 'Salir del Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Transfiere el anfitrion antes de salir.';

  @override
  String get circlesLeavePromptEndOnly => 'Termina el Circle y sal.';

  @override
  String get circlesTransferHost => 'Transferir anfitrion';

  @override
  String get circlesEndCircle => 'Terminar Circle';

  @override
  String get circlesTransferHostTitle => 'Transferir anfitrion';

  @override
  String circlesShareId(Object id) {
    return 'ID del Circle: $id';
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
