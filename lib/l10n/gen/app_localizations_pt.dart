// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Aprenda. Compita. Domine.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Cadastrar';

  @override
  String get signIn => 'Entrar';

  @override
  String get skipForNow => 'Pular por enquanto';

  @override
  String get authFillAllFields => 'Preencha todos os campos';

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
    return 'Erro: $error';
  }

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Senha';

  @override
  String get authUsername => 'Nome de usuário';

  @override
  String get authContinue => 'Continuar';

  @override
  String get authSigningIn => 'Entrando...';

  @override
  String get authCreateAccount => 'Criar conta';

  @override
  String get authCreating => 'Criando...';

  @override
  String get authNeedAccount => 'Não tem uma conta? ';

  @override
  String get authHaveAccount => 'Já tem uma conta? ';

  @override
  String get dialogAuthRequiredTitle => 'Entre para acessar Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles são salas multiplayer. Crie uma conta para participar de partidas ao vivo, convidar amigos e salvar progresso.';

  @override
  String get notNow => 'Agora não';

  @override
  String get navHome => 'Início';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Perfil';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'Remover curso?';

  @override
  String removeCourseBody(Object course) {
    return '$course será removido da sua lista Início.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Remover';

  @override
  String welcomeBack(Object name) {
    return 'Bem-vindo de volta, $name!';
  }

  @override
  String get editCourses => 'Editar cursos';

  @override
  String get done => 'Concluído';

  @override
  String get noCoursesToEdit => 'Nenhum curso para editar.';

  @override
  String get addCourse => 'Adicionar curso';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get iSpeak => 'Eu falo';

  @override
  String get iWantToLearn => 'Quero aprender';

  @override
  String get chooseYourLanguage => 'Escolha seu idioma';

  @override
  String get chooseLearningLanguage => 'Escolha o idioma para aprender';

  @override
  String get chooseTwoDifferentLanguages => 'Escolha dois idiomas diferentes.';

  @override
  String get createCourse => 'Criar curso';

  @override
  String get soloCourseTitle => 'Curso Solo';

  @override
  String get searchLanguage => 'Buscar idioma';

  @override
  String get noMatches => 'Nenhuma correspondência';

  @override
  String get chooseCourseType => 'Escolha um tipo de curso';

  @override
  String get soloStudyDescription =>
      'Estude sozinho com o mesmo estilo de quiz dos Circles - mas sem salas, chat, espectadores ou opções de host.';

  @override
  String get soloModeVocabulary => 'Vocabulário';

  @override
  String get soloModeSentences => 'Frases';

  @override
  String get soloModeReview => 'Revisão';

  @override
  String get soloModeVocabularySubtitle =>
      'Múltipla escolha significados, sinônimos, uso';

  @override
  String get soloModeSentencesSubtitle =>
      'Preencher lacunas + tradução + leitura';

  @override
  String get soloModeReviewDescription =>
      'Pratique o que aprendeu: palavras fracas, erros recentes e repetição espaçada.';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'Iniciar revisão';

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
    return 'Configuração $mode';
  }

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get numberOfQuestions => 'Número de perguntas';

  @override
  String get timerPerQuestion => 'Tempo por pergunta';

  @override
  String get noTimer => 'Sem tempo';

  @override
  String get start => 'Iniciar';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileSignInToMessage => 'Entre para enviar mensagem';

  @override
  String get profileThatsYourProfile => 'Este é o seu perfil';

  @override
  String get profileSignInToAddFriends => 'Entre para adicionar amigos';

  @override
  String get profileCantAddYourself => 'Você não pode adicionar a si mesmo';

  @override
  String profileRequestSent(Object username) {
    return 'Solicitação enviada para @$username';
  }

  @override
  String get profileRequestFailed => 'Falha ao enviar solicitação';

  @override
  String get profileDefaultDisplayName => 'Novo usuário';

  @override
  String get profileDefaultBio => 'Pronto para aprender!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Convidado';

  @override
  String get guestUsername => 'convidado';

  @override
  String get guestSessionLabel => 'Sessão de convidado';

  @override
  String get unlockFullProfile => 'Desbloqueie seu perfil completo';

  @override
  String get guestBenefitSync =>
      'Sincronize progresso em todos os dispositivos';

  @override
  String get guestBenefitCircles => 'Participe de Circles e jogue ao vivo';

  @override
  String get guestBenefitNotifications =>
      'Receba notificações e solicitações de amizade';

  @override
  String get progressStaysOnDevice =>
      'O progresso fica neste dispositivo até você entrar.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Meta: ${minutes}m';
  }

  @override
  String get profileXpProgress => 'Progresso XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Vitórias';

  @override
  String get profileStreak => 'Sequência';

  @override
  String get profileFriendsTitle => 'Meus amigos';

  @override
  String get profileViewAll => 'Ver todos';

  @override
  String get profileAchievementsTitle => 'Conquistas';

  @override
  String get profileNoAchievements => 'Nenhuma conquista ainda.';

  @override
  String get profileRequested => 'Solicitado';

  @override
  String get profileSending => 'Enviando...';

  @override
  String get profileAddFriend => 'Adicionar amigo';

  @override
  String get profileConnectTitle => 'Conectar';

  @override
  String get profileMessage => 'Mensagem';

  @override
  String get profileSnapshot => 'Foto do perfil';

  @override
  String get profileLocationHidden => 'Localização oculta';

  @override
  String get profileBioHidden => 'Bio oculta';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Meta diária ${minutes}m';
  }

  @override
  String get circleInviteTitle => 'Convite Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Entre para participar';

  @override
  String get joiningCircle => 'Entrando...';

  @override
  String get joinCircle => 'Entrar no Circle';

  @override
  String get circleJoinedAsPlayer => 'Entrou como jogador';

  @override
  String get circleJoinedAsSpectator => 'Entrou como espectador';

  @override
  String get accept => 'Aceitar';

  @override
  String get decline => 'Recusar';

  @override
  String get open => 'Abrir';

  @override
  String get circleCountdownTitle => 'Prepare-se';

  @override
  String get circleCountdownSubtitle => 'Circle começando...';

  @override
  String get userFallbackName => 'Usuário';

  @override
  String get micOff => 'Microfone desligado';

  @override
  String get micOn => 'Microfone ligado';

  @override
  String get roleHost => 'Anfitrião';

  @override
  String get roleSpectator => 'Espectador';

  @override
  String get tagHost => 'ANFITRIÃO';

  @override
  String get tagYou => 'VOCÊ';

  @override
  String get statusCorrect => 'Correto';

  @override
  String get statusWrong => 'Errado';

  @override
  String get statusWaiting => 'Aguardando';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'Pts';

  @override
  String get pointsLabel => 'Pontos';

  @override
  String get statCorrect => 'Correto';

  @override
  String get statAnswers => 'Respostas';

  @override
  String get statTotal => 'Total';

  @override
  String get statQuestions => 'Perguntas';

  @override
  String get statAccuracy => 'Precisão';

  @override
  String get statRate => 'Taxa';

  @override
  String get statRank => 'Classificação';

  @override
  String get statPosition => 'Posição';

  @override
  String get statMode => 'Modo';

  @override
  String get statType => 'Tipo';

  @override
  String get next => 'Próximo';

  @override
  String get submit => 'Enviar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get save => 'Salvar';

  @override
  String get playAgain => 'Jogar novamente';

  @override
  String get backToCourse => 'Voltar ao curso';

  @override
  String get resultsTitle => 'Resultados';

  @override
  String get shareLater => 'Compartilhar depois';

  @override
  String get delete => 'Excluir';

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
  String get timeJustNow => 'agora mesmo';

  @override
  String timeMinutesAgo(Object count) {
    return '${count}m atrás';
  }

  @override
  String timeHoursAgo(Object count) {
    return '${count}h atrás';
  }

  @override
  String timeDaysAgo(Object count) {
    return '${count}d atrás';
  }

  @override
  String get liveQuizWaitingForHost => 'Aguardando anfitrião...';

  @override
  String get liveQuizJoinRequestSent => 'Solicitação de entrada enviada';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Solicitação falhou: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Controles do anfitrião';

  @override
  String get liveQuizSpectatorModeTitle => 'Modo espectador';

  @override
  String get liveQuizHostControlsSubtitle =>
      'As rodadas avançam automaticamente quando todos responderam ou o tempo acabou.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Veja as perguntas e o placar ao vivo. Você não pode responder.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Pergunta $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Solicitação enviada';

  @override
  String get liveQuizRequestToJoin => 'Solicitação de entrada';

  @override
  String get liveQuizSpectatorFooter =>
      'Você está assistindo ao vivo. Aproveite as perguntas e o placar.';

  @override
  String get circleNotFound => 'Circle não encontrado';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Falha ao iniciar revanche: $error';
  }

  @override
  String get resultsMatchTitle => 'Resultados da partida';

  @override
  String resultsNiceWork(Object name) {
    return 'Bom trabalho, $name';
  }

  @override
  String get resultsPlaceFirst => '1º lugar';

  @override
  String get resultsPlaceSecond => '2º lugar';

  @override
  String get resultsPlaceThird => '3º lugar';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rankº lugar';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'De $players jogadores';
  }

  @override
  String get resultsHighlightChampion => 'Campeão! Você dominou este Circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Ótima precisão. Você está perto do topo!';

  @override
  String get resultsHighlightKeepGoing =>
      'Continue assim - consistência supera velocidade.';

  @override
  String get resultsLeaderboardTitle => 'Placar';

  @override
  String resultsPlayersCount(Object count) {
    return '$count jogadores';
  }

  @override
  String get resultsBackToCircles => 'Voltar aos Circles';

  @override
  String get resultsRematch => 'Revanche';

  @override
  String get resultsPlayAgain => 'Jogar novamente';

  @override
  String get leaderboardGlobalTitle => 'Placar global';

  @override
  String get leaderboardEmpty => 'Nenhum placar ainda.';

  @override
  String get aboutTitle => 'Sobre';

  @override
  String aboutVersion(Object version) {
    return 'Versão $version';
  }

  @override
  String get aboutDescription =>
      'SOMA é uma plataforma gamificada de aprendizado de idiomas que torna o domínio de novos idiomas envolvente e social. Participe de Circles, pratique sozinho e acompanhe seu progresso.';

  @override
  String get aboutTerms => 'Termos de serviço';

  @override
  String get aboutPrivacy => 'Política de privacidade';

  @override
  String get aboutOpenSource => 'Licenças de código aberto';

  @override
  String get addFriendTitle => 'Adicionar amigo';

  @override
  String get addFriendFindByUsername => 'Encontrar por nome de usuário';

  @override
  String get addFriendUsernameHint => 'Digite o nome de usuário...';

  @override
  String get addFriendTip =>
      'Dica: Mais tarde podemos oferecer suporte a código QR + ID de amigos.';

  @override
  String get addFriendSending => 'Enviando...';

  @override
  String get addFriendSendRequest => 'Enviar solicitação';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Usuário @$username não encontrado';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Ação falhou ou já foi enviada: $error';
  }

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get searchFriendsHint => 'Buscar amigos...';

  @override
  String get somaLearnerSubtitle => 'Estudante Soma';

  @override
  String get friendRequestLabel => 'Solicitação';

  @override
  String get friendRequestSentLabel => 'Solicitação enviada';

  @override
  String get friendIncomingRequestLabel => 'Solicitação recebida';

  @override
  String get friendRequestsSection => 'Solicitações';

  @override
  String get friendPendingSection => 'Pendentes';

  @override
  String get friendAllSection => 'Todos os amigos';

  @override
  String get friendsEmptyState =>
      'Nenhum amigo ainda. Adicione seu primeiro amigo!';

  @override
  String get friendsEmptyShort => 'Nenhum amigo ainda.';

  @override
  String noMatchForQuery(Object query) {
    return 'Nenhuma correspondência para \"$query\"';
  }

  @override
  String get inboxTitle => 'Caixa de entrada';

  @override
  String get searchChatsHint => 'Buscar conversas...';

  @override
  String get inboxEmptyState =>
      'Nenhuma conversa ainda. Comece a conversar com um amigo!';

  @override
  String get newMessageTitle => 'Nova mensagem';

  @override
  String get chatCallLater =>
      'Chamada de voz mais tarde (linguagem Circle vem a seguir)';

  @override
  String errorWithDetails(Object error) {
    return 'Erro: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Diga oi para $name!';
  }

  @override
  String get chatMessageHint => 'Mensagem...';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsTabAll => 'Todas';

  @override
  String get notificationsTabCourses => 'Cursos';

  @override
  String get notificationsTabSocial => 'Social';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Sistema';

  @override
  String get notificationsEmpty => 'Nenhuma notificação aqui.';

  @override
  String get notificationsDeleted => 'Notificação excluída';

  @override
  String get notificationTitleFallback => 'Notificação';

  @override
  String get notificationTypeCourse => 'Curso';

  @override
  String get notificationTypeSocial => 'Social';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Sistema';

  @override
  String get notificationsFriendAccepted => 'Solicitação de amizade aceita';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Falha ao aceitar solicitação de amizade: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Solicitação de amizade recusada';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Falha ao recusar solicitação de amizade: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Falha ao entrar no Circle: $error';
  }

  @override
  String get notificationsOpening => 'Abrindo';

  @override
  String get notificationsOpened => 'Aberto';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notificação';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsPrivacy => 'Privacidade';

  @override
  String get settingsSecurity => 'Segurança';

  @override
  String get settingsSectionGameplay => 'Jogo';

  @override
  String get settingsShowTranslationLine => 'Mostrar linha de tradução';

  @override
  String get settingsShowReadingLine => 'Mostrar leitura (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Tempo padrão por pergunta';

  @override
  String get settingsMatchDifficulty => 'Dificuldade da partida';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptativa';

  @override
  String get settingsSectionSoundFeel => 'Som e sensação';

  @override
  String get settingsMusic => 'Música';

  @override
  String get settingsSoundEffects => 'Efeitos sonoros';

  @override
  String get settingsHaptics => 'Feedback tátil';

  @override
  String get settingsSectionNotifications => 'Notificações';

  @override
  String get settingsPushNotifications => 'Notificações push';

  @override
  String get settingsDailyReminder => 'Lembrete diário';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Idioma da interface';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsTermsPrivacy => 'Termos e privacidade';

  @override
  String get settingsSupport => 'Suporte';

  @override
  String get settingsLogout => 'Sair';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeDark => 'Escuro';

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
  String get editProfileUpdated => 'Perfil atualizado';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfilePhotoLabel => 'Foto do perfil';

  @override
  String get editProfilePhotoSubtitle =>
      'Seleção de avatar via Supabase Storage em breve.';

  @override
  String get editProfileChangePhoto => 'Alterar';

  @override
  String get editProfileAvatarUploadSoon =>
      'Upload de avatar disponível em breve';

  @override
  String get editProfileDisplayNameLabel => 'Nome de exibição';

  @override
  String get editProfileDisplayNameHint => 'Seu nome';

  @override
  String get editProfileDisplayNameRequired => 'Digite seu nome';

  @override
  String get editProfileDisplayNameTooShort => 'Muito curto';

  @override
  String get editProfileUsernameLabel => 'Nome de usuário';

  @override
  String get editProfileUsernameHint => 'alex_estudante';

  @override
  String get editProfileUsernameRequired => 'Digite o nome de usuário';

  @override
  String get editProfileUsernameTooShort => 'Mín. 3 caracteres';

  @override
  String get editProfileUsernameInvalid => 'Apenas letras, números, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Bio curta...';

  @override
  String get editProfileBioTooLong => 'Máx. 120 caracteres';

  @override
  String get editProfileLocationLabel => 'Localização';

  @override
  String get editProfileLocationHint => 'Cidade / País';

  @override
  String get editProfileDailyGoalTitle => 'Meta diária';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Escolha quantos minutos você quer estudar por dia.';

  @override
  String get securityTitle => 'Segurança';

  @override
  String get securitySectionPassword => 'Senha';

  @override
  String get securityChangePasswordTitle => 'Alterar senha';

  @override
  String get securityChangePasswordSubtitle =>
      'Atualize sua senha regularmente.';

  @override
  String get securitySectionTwoFactor => 'Autenticação de dois fatores';

  @override
  String get securityEnable2faTitle => 'Ativar 2FA';

  @override
  String get securityEnable2faSubtitle => 'Proteção extra ao fazer login.';

  @override
  String get securitySectionAppLock => 'Bloqueio do aplicativo';

  @override
  String get securityBiometricTitle => 'Desbloqueio biométrico';

  @override
  String get securityBiometricSubtitle =>
      'Use FaceID/TouchID para desbloquear o SOMA.';

  @override
  String get securityAppLockTitle => 'Bloqueio do aplicativo';

  @override
  String get securityAppLockSubtitle =>
      'Bloqueie o SOMA ao sair do aplicativo.';

  @override
  String get securitySectionSessions => 'Sessões ativas';

  @override
  String get securityNoSessions => 'Nenhuma sessão ativa encontrada.';

  @override
  String get securityThisDevice => 'Este dispositivo';

  @override
  String get securityDevice => 'Dispositivo';

  @override
  String get securityActiveLabel => 'Ativo';

  @override
  String get securitySignInToEnable2fa => 'Entre para ativar 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Falha ao ativar 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Falha ao desativar 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Configurar 2FA';

  @override
  String get securitySecretKeyLabel => 'Chave secreta';

  @override
  String get securityCodeHint => 'Código de 6 dígitos';

  @override
  String get security2faEnabled => '2FA ativado';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Falha ao verificar código: $error';
  }

  @override
  String get securityVerifying => 'Verificando...';

  @override
  String get securityVerify => 'Verificar';

  @override
  String get securityCurrentPasswordHint => 'Senha atual';

  @override
  String get securityNewPasswordHint => 'Nova senha (mín. 8 caracteres)';

  @override
  String get securityConfirmPasswordHint => 'Confirmar nova senha';

  @override
  String get securitySignInToChangePassword => 'Entre para alterar sua senha';

  @override
  String get securityEnterCurrentPassword => 'Digite sua senha atual';

  @override
  String get securityPasswordMinLength =>
      'A nova senha deve ter pelo menos 8 caracteres';

  @override
  String get securityPasswordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get securityPasswordUpdated => 'Senha atualizada';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Falha ao atualizar senha: $error';
  }

  @override
  String get securityAutoLockAfter => 'Bloquear automaticamente após';

  @override
  String get privacyTitle => 'Privacidade';

  @override
  String get privacySectionVisibility => 'Visibilidade';

  @override
  String get privacyProfileVisibilityTitle => 'Visibilidade do perfil';

  @override
  String get privacyVisibilityPublic => 'Público';

  @override
  String get privacyVisibilityFriends => 'Amigos';

  @override
  String get privacyVisibilityPrivate => 'Privado';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Qualquer um pode ver seu perfil.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Apenas amigos podem ver seu perfil.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Apenas você pode ver seu perfil.';

  @override
  String get privacySectionActivity => 'Atividade';

  @override
  String get privacyShowOnlineTitle => 'Mostrar status online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Permita que outros vejam quando você está online.';

  @override
  String get privacyShowActivityTitle => 'Mostrar atividade de aprendizado';

  @override
  String get privacyShowActivitySubtitle =>
      'Exibir sequência, XP e progresso atual.';

  @override
  String get privacySectionSocial => 'Social';

  @override
  String get privacyAllowRequestsTitle => 'Permitir solicitações de amizade';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Permita que as pessoas enviem solicitações de amizade.';

  @override
  String get privacyWhoCanDmTitle => 'Quem pode enviar DMs';

  @override
  String get privacyDmEveryone => 'Todos';

  @override
  String get privacyDmFriends => 'Amigos';

  @override
  String get privacyDmNoOne => 'Ninguém';

  @override
  String get privacyDmEveryoneSubtitle => 'Qualquer um pode enviar mensagens.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Apenas amigos podem enviar mensagens.';

  @override
  String get privacyDmNoOneSubtitle => 'Ninguém pode enviar mensagens.';

  @override
  String get privacySectionBlockedUsers => 'Usuários bloqueados';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Gerenciamento de usuários bloqueados disponível em breve.';

  @override
  String get privacySectionDataControls => 'Controles de dados';

  @override
  String get privacyExportDataTitle => 'Exportar meus dados';

  @override
  String get privacyExportDataSubtitle => 'Baixe sua atividade e cursos.';

  @override
  String get privacyExportInfoTitle => 'Exportar dados';

  @override
  String get privacyExportInfoBody =>
      'Próximo passo: gere uma exportação JSON/CSV e envie por e-mail ou baixe localmente.';

  @override
  String get privacyDeleteAccountTitle => 'Excluir conta';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Isso removerá permanentemente sua conta e dados.';

  @override
  String get privacyDeleteConfirmTitle => 'Excluir conta?';

  @override
  String get privacyDeleteConfirmBody =>
      'Esta ação é permanente. Seu perfil, cursos, amigos e mensagens serão removidos.';

  @override
  String get privacyDeleteComingSoon =>
      'Exclusão será conectada ao Supabase mais tarde';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sessão solo concluída';

  @override
  String get soloResultsFeedbackElite =>
      'Desempenho de elite. Mantenha a sequência';

  @override
  String get soloResultsFeedbackStrong =>
      'Ótimo trabalho. Você está melhorando rapidamente.';

  @override
  String get soloResultsFeedbackProgress =>
      'Bom progresso. Revise os erros e repita.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Sem estresse. Tente novamente com menos perguntas e foco.';

  @override
  String get soloResultsPerfectScore =>
      'Pontuação perfeita! Nenhum erro para revisar.';

  @override
  String get soloResultsReviewPrompt =>
      'Revise os erros para aprender mais rápido. Mostraremos as respostas erradas abaixo.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Revisar erros ($count)';
  }

  @override
  String get authNotSignedIn => 'Você não está conectado';

  @override
  String get genericUser => 'Usuário';

  @override
  String get loading => 'Carregando...';

  @override
  String get edit => 'Editar';

  @override
  String get send => 'Enviar';

  @override
  String get join => 'Entrar';

  @override
  String get leave => 'Sair';

  @override
  String get ready => 'Pronto';

  @override
  String get levelBeginner => 'Iniciante';

  @override
  String get levelIntermediate => 'Intermediário';

  @override
  String get levelAdvanced => 'Avançado';

  @override
  String questionsShort(Object count) {
    return '$count P';
  }

  @override
  String secondsShort(Object count) {
    return '${count}s';
  }

  @override
  String get circlesAllCourses => 'Todos os cursos';

  @override
  String get circlesAllModes => 'Todos os modos';

  @override
  String get circlesAllLevels => 'Todos os níveis';

  @override
  String get circlesAddNewCourse => 'Adicionar novo curso';

  @override
  String get circlesCoursesTitle => 'Cursos';

  @override
  String get circlesModeTitle => 'Modo';

  @override
  String get circlesLevelTitle => 'Nível';

  @override
  String get circlesNoActiveForFilters =>
      'Nenhum Circle ativo para estes filtros.';

  @override
  String get circlesUnknownRoom => 'Sala desconhecida';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Criar Circle';

  @override
  String get circlesCircleName => 'Nome do Circle';

  @override
  String get circlesEnterName => 'Digite o nome';

  @override
  String get circlesLanguages => 'Idiomas';

  @override
  String get circlesRoomSetup => 'Configuração da sala';

  @override
  String get circlesPlayers => 'Jogadores';

  @override
  String get circlesEmptySlot => 'Vaga vazia';

  @override
  String get circlesPlayersRange => '1-5 jogadores';

  @override
  String get circlesQuestions => 'Perguntas';

  @override
  String get circlesQuestionsSubtitle => 'Número de perguntas';

  @override
  String get circlesTimePerQuestion => 'Tempo por pergunta';

  @override
  String get circlesSecondsPerQuestion => 'Segundos por pergunta';

  @override
  String get circlesAdvanced => 'Avançado';

  @override
  String get circlesAllowSpectators => 'Permitir espectadores';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Permita que outros assistam sem jogar.';

  @override
  String get circlesLiveVoiceChat => 'Chat de voz ao vivo';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Ative voz ao vivo durante partidas.';

  @override
  String get circlesLiveTextChat => 'Chat de texto ao vivo';

  @override
  String get circlesLiveTextChatSubtitle => 'Ative chat durante partidas.';

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
  String get circlesCreatedSuccess => 'Circle criado';

  @override
  String circlesCreateError(Object error) {
    return 'Falha ao criar Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Dica: Você pode convidar amigos após a criação.';

  @override
  String circlesJoinError(Object error) {
    return 'Falha ao entrar no Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobby do Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Código: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Configurações da partida';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Nível $level';
  }

  @override
  String get circlesDifficulty => 'Dificuldade';

  @override
  String get circlesPerQuestionShort => 'por pergunta';

  @override
  String get circlesInvite => 'Convidar';

  @override
  String get circlesCopyId => 'Copiar ID';

  @override
  String get circlesCopiedId => 'ID copiado';

  @override
  String get circlesMatchInProgress => 'Partida em andamento';

  @override
  String get circlesSpectatorQueuedBody =>
      'Partida em andamento. Você entrará como espectador.';

  @override
  String get circlesHostStartWhenReady =>
      'O anfitrião inicia quando todos estiverem prontos.';

  @override
  String get circlesSpectators => 'Espectadores';

  @override
  String get circlesSpectator => 'Espectador';

  @override
  String get circlesSpectatorCanWatch => 'Espectadores podem assistir ao vivo.';

  @override
  String get circlesJoinRequests => 'Solicitações de entrada';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Aceite espectadores antes do início da partida.';

  @override
  String get circlesStartGame => 'Iniciar jogo';

  @override
  String get circlesWaitingForPlayers => 'Aguardando jogadores';

  @override
  String get circlesLeaveCircle => 'Sair do Circle';

  @override
  String get circlesRequestSent => 'Solicitação enviada';

  @override
  String get circlesRequestToJoin => 'Solicitação de entrada';

  @override
  String get circlesWatchLive => 'Assistir ao vivo';

  @override
  String get circlesPlayerTip =>
      'Toque em Pronto quando estiver pronto. O anfitrião iniciará a partida.';

  @override
  String get circlesSpectatorTip =>
      'Você está assistindo. Assista ao vivo quando o anfitrião iniciar.';

  @override
  String get circlesHostControls => 'Controles do anfitrião';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Falha ao transferir anfitrião: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Falha ao encerrar Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Usuário @$username não encontrado';
  }

  @override
  String get circlesInvalidUser => 'Usuário inválido';

  @override
  String get circlesCantInviteSelf => 'Você não pode convidar a si mesmo';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'Usuário @$username já está no Circle';
  }

  @override
  String get circlesDefaultHost => 'Anfitrião';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Convidar por nome de usuário';

  @override
  String circlesInviteSent(Object username) {
    return 'Convite enviado para @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Falha ao enviar convite: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Solicitação de entrada enviada';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Solicitação falhou: $error';
  }

  @override
  String get circlesFull => 'Circle cheio';

  @override
  String get circlesSpectatorAdded => 'Espectador adicionado';

  @override
  String circlesApproveFailed(Object error) {
    return 'Falha ao aprovar solicitação: $error';
  }

  @override
  String get circlesRequestDeclined => 'Solicitação recusada';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Falha ao recusar solicitação: $error';
  }

  @override
  String get circlesParticipant => 'Participante';

  @override
  String get circlesLeavePromptTitle => 'Sair do Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Transfira o anfitrião antes de sair.';

  @override
  String get circlesLeavePromptEndOnly => 'Encerre o Circle e saia.';

  @override
  String get circlesTransferHost => 'Transferir anfitrião';

  @override
  String get circlesEndCircle => 'Encerrar Circle';

  @override
  String get circlesTransferHostTitle => 'Transferir anfitrião';

  @override
  String circlesShareId(Object id) {
    return 'ID do Circle: $id';
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
