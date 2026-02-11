// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Учись. Соревнуйся. Мастери.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Регистрация';

  @override
  String get signIn => 'Войти';

  @override
  String get skipForNow => 'Пропустить';

  @override
  String get authFillAllFields => 'Заполните все поля';

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
    return 'Ошибка: $error';
  }

  @override
  String get authEmail => 'Эл. почта';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authUsername => 'Имя пользователя';

  @override
  String get authContinue => 'Продолжить';

  @override
  String get authSigningIn => 'Вход...';

  @override
  String get authCreateAccount => 'Создать аккаунт';

  @override
  String get authCreating => 'Создание...';

  @override
  String get authNeedAccount => 'Нет аккаунта? ';

  @override
  String get authHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get dialogAuthRequiredTitle => 'Войдите для доступа к Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles — это многопользовательские комнаты. Создайте аккаунт, чтобы участвовать в матчах, приглашать друзей и сохранять прогресс.';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get navHome => 'Главная';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Профиль';

  @override
  String get removeCourseTitle => 'Удалить курс?';

  @override
  String removeCourseBody(Object course) {
    return '$course будет удален из списка.';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get remove => 'Удалить';

  @override
  String welcomeBack(Object name) {
    return 'С возвращением, $name!';
  }

  @override
  String get editCourses => 'Редактировать курсы';

  @override
  String get done => 'Готово';

  @override
  String get noCoursesToEdit => 'Нет курсов для редактирования.';

  @override
  String get addCourse => 'Добавить курс';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get iSpeak => 'Я говорю';

  @override
  String get iWantToLearn => 'Хочу изучать';

  @override
  String get chooseYourLanguage => 'Выберите ваш язык';

  @override
  String get chooseLearningLanguage => 'Выберите изучаемый язык';

  @override
  String get chooseTwoDifferentLanguages => 'Выберите два разных языка.';

  @override
  String get createCourse => 'Создать курс';

  @override
  String get soloCourseTitle => 'Соло курс';

  @override
  String get searchLanguage => 'Поиск языка';

  @override
  String get noMatches => 'Нет совпадений';

  @override
  String get chooseCourseType => 'Выберите тип курса';

  @override
  String get soloStudyDescription =>
      'Изучайте самостоятельно в формате викторины Circles — но без комнат, чата, зрителей и опций хоста.';

  @override
  String get soloModeVocabulary => 'Словарь';

  @override
  String get soloModeSentences => 'Предложения';

  @override
  String get soloModeReview => 'Повторение';

  @override
  String get soloModeVocabularySubtitle =>
      'Выбор значений, синонимов, использование';

  @override
  String get soloModeSentencesSubtitle =>
      'Заполнение пропусков + перевод + чтение';

  @override
  String get soloModeReviewDescription =>
      'Практикуйте изученное: слабые слова, недавние ошибки и интервальное повторение.';

  @override
  String get startReview => 'Начать повторение';

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
    return 'Настройка $mode';
  }

  @override
  String get difficulty => 'Сложность';

  @override
  String get numberOfQuestions => 'Количество вопросов';

  @override
  String get timerPerQuestion => 'Таймер на вопрос';

  @override
  String get noTimer => 'Без таймера';

  @override
  String get start => 'Начать';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileSignInToMessage => 'Войдите для отправки сообщений';

  @override
  String get profileThatsYourProfile => 'Это ваш профиль';

  @override
  String get profileSignInToAddFriends => 'Войдите для добавления друзей';

  @override
  String get profileCantAddYourself => 'Вы не можете добавить себя';

  @override
  String profileRequestSent(Object username) {
    return 'Запрос отправлен @$username';
  }

  @override
  String get profileRequestFailed => 'Не удалось отправить запрос';

  @override
  String get profileDefaultDisplayName => 'Новый пользователь';

  @override
  String get profileDefaultBio => 'Готов учиться!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Гость';

  @override
  String get guestUsername => 'гость';

  @override
  String get guestSessionLabel => 'Гостевая сессия';

  @override
  String get unlockFullProfile => 'Разблокируйте полный профиль';

  @override
  String get guestBenefitSync => 'Синхронизация прогресса на всех устройствах';

  @override
  String get guestBenefitCircles =>
      'Присоединяйтесь к Circles и играйте вживую';

  @override
  String get guestBenefitNotifications =>
      'Получайте уведомления и запросы в друзья';

  @override
  String get progressStaysOnDevice =>
      'Прогресс остается на устройстве, пока вы не войдете.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Цель: $minutesм';
  }

  @override
  String get profileXpProgress => 'Прогресс XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Победы';

  @override
  String get profileStreak => 'Серия';

  @override
  String get profileFriendsTitle => 'Мои друзья';

  @override
  String get profileViewAll => 'Все';

  @override
  String get profileAchievementsTitle => 'Достижения';

  @override
  String get profileNoAchievements => 'Пока нет достижений.';

  @override
  String get profileRequested => 'Запрошено';

  @override
  String get profileSending => 'Отправка...';

  @override
  String get profileAddFriend => 'Добавить друга';

  @override
  String get profileConnectTitle => 'Подключиться';

  @override
  String get profileMessage => 'Сообщение';

  @override
  String get profileSnapshot => 'Снимок профиля';

  @override
  String get profileLocationHidden => 'Местоположение скрыто';

  @override
  String get profileBioHidden => 'Биография скрыта';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Ежедневная цель $minutesм';
  }

  @override
  String get circleInviteTitle => 'Приглашение в Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Войдите для участия';

  @override
  String get joiningCircle => 'Присоединение...';

  @override
  String get joinCircle => 'Присоединиться';

  @override
  String get circleJoinedAsPlayer => 'Вы присоединились как игрок';

  @override
  String get circleJoinedAsSpectator => 'Вы присоединились как зритель';

  @override
  String get accept => 'Принять';

  @override
  String get decline => 'Отклонить';

  @override
  String get open => 'Открыть';

  @override
  String get circleCountdownTitle => 'Приготовьтесь';

  @override
  String get circleCountdownSubtitle => 'Circle начинается...';

  @override
  String get userFallbackName => 'Пользователь';

  @override
  String get micOff => 'Микрофон выкл';

  @override
  String get micOn => 'Микрофон вкл';

  @override
  String get roleHost => 'Хост';

  @override
  String get roleSpectator => 'Зритель';

  @override
  String get tagHost => 'ХОСТ';

  @override
  String get tagYou => 'ВЫ';

  @override
  String get statusCorrect => 'Верно';

  @override
  String get statusWrong => 'Неверно';

  @override
  String get statusWaiting => 'Ожидание';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'Очк';

  @override
  String get pointsLabel => 'Очки';

  @override
  String get statCorrect => 'Верно';

  @override
  String get statAnswers => 'Ответы';

  @override
  String get statTotal => 'Всего';

  @override
  String get statQuestions => 'Вопросы';

  @override
  String get statAccuracy => 'Точность';

  @override
  String get statRate => 'Скорость';

  @override
  String get statRank => 'Рейтинг';

  @override
  String get statPosition => 'Позиция';

  @override
  String get statMode => 'Режим';

  @override
  String get statType => 'Тип';

  @override
  String get next => 'Далее';

  @override
  String get submit => 'Отправить';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get save => 'Сохранить';

  @override
  String get playAgain => 'Играть снова';

  @override
  String get backToCourse => 'Вернуться к курсу';

  @override
  String get resultsTitle => 'Результаты';

  @override
  String get shareLater => 'Поделиться позже';

  @override
  String get delete => 'Удалить';

  @override
  String get ok => 'ОК';

  @override
  String minutesShort(Object minutes) {
    return '$minutesм';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$countм';
  }

  @override
  String timeShortHours(Object count) {
    return '$countч';
  }

  @override
  String timeShortDays(Object count) {
    return '$countд';
  }

  @override
  String get timeJustNow => 'только что';

  @override
  String timeMinutesAgo(Object count) {
    return '$countм назад';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$countч назад';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$countд назад';
  }

  @override
  String get liveQuizWaitingForHost => 'Ожидание хоста...';

  @override
  String get liveQuizJoinRequestSent => 'Запрос на вход отправлен';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Запрос не удался: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Управление хоста';

  @override
  String get liveQuizSpectatorModeTitle => 'Режим зрителя';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Раунды продолжаются автоматически, когда все ответили или время истекло.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Смотрите вопросы и таблицу лидеров. Вы не можете отвечать.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Вопрос $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Запрос отправлен';

  @override
  String get liveQuizRequestToJoin => 'Запрос на вход';

  @override
  String get liveQuizSpectatorFooter =>
      'Вы наблюдаете вживую. Наслаждайтесь вопросами и таблицей лидеров.';

  @override
  String get circleNotFound => 'Circle не найден';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Не удалось начать реванш: $error';
  }

  @override
  String get resultsMatchTitle => 'Результаты матча';

  @override
  String resultsNiceWork(Object name) {
    return 'Отличная работа, $name';
  }

  @override
  String get resultsPlaceFirst => '1-е место';

  @override
  String get resultsPlaceSecond => '2-е место';

  @override
  String get resultsPlaceThird => '3-е место';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank-е место';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Из $players игроков';
  }

  @override
  String get resultsHighlightChampion =>
      'Чемпион! Вы доминировали в этом Circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Отличная точность. Вы близки к вершине!';

  @override
  String get resultsHighlightKeepGoing =>
      'Продолжайте — постоянство важнее скорости.';

  @override
  String get resultsLeaderboardTitle => 'Таблица лидеров';

  @override
  String resultsPlayersCount(Object count) {
    return '$count игроков';
  }

  @override
  String get resultsBackToCircles => 'Вернуться к Circles';

  @override
  String get resultsRematch => 'Реванш';

  @override
  String get resultsPlayAgain => 'Играть снова';

  @override
  String get leaderboardGlobalTitle => 'Глобальная таблица лидеров';

  @override
  String get leaderboardEmpty => 'Таблица лидеров пока пуста.';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String aboutVersion(Object version) {
    return 'Версия $version';
  }

  @override
  String get aboutDescription =>
      'SOMA — это игровая платформа для изучения языков, которая делает освоение новых языков увлекательным и социальным. Присоединяйтесь к Circles, практикуйтесь самостоятельно и отслеживайте свой прогресс.';

  @override
  String get aboutTerms => 'Условия использования';

  @override
  String get aboutPrivacy => 'Политика конфиденциальности';

  @override
  String get aboutOpenSource => 'Лицензии с открытым исходным кодом';

  @override
  String get addFriendTitle => 'Добавить друга';

  @override
  String get addFriendFindByUsername => 'Найти по имени пользователя';

  @override
  String get addFriendUsernameHint => 'Введите имя пользователя...';

  @override
  String get addFriendTip =>
      'Подсказка: Позже мы сможем поддерживать QR-код + ID друзей.';

  @override
  String get addFriendSending => 'Отправка...';

  @override
  String get addFriendSendRequest => 'Отправить запрос';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Пользователь @$username не найден';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Действие не удалось или уже отправлено: $error';
  }

  @override
  String get friendsTitle => 'Друзья';

  @override
  String get searchFriendsHint => 'Поиск друзей...';

  @override
  String get somaLearnerSubtitle => 'Учащийся Soma';

  @override
  String get friendRequestLabel => 'Запрос';

  @override
  String get friendRequestSentLabel => 'Запрос отправлен';

  @override
  String get friendIncomingRequestLabel => 'Входящий запрос';

  @override
  String get friendRequestsSection => 'Запросы';

  @override
  String get friendPendingSection => 'Ожидающие';

  @override
  String get friendAllSection => 'Все друзья';

  @override
  String get friendsEmptyState => 'Пока нет друзей. Добавьте первого друга!';

  @override
  String get friendsEmptyShort => 'Пока нет друзей.';

  @override
  String noMatchForQuery(Object query) {
    return 'Нет результатов для \"$query\"';
  }

  @override
  String get inboxTitle => 'Входящие';

  @override
  String get searchChatsHint => 'Поиск чатов...';

  @override
  String get inboxEmptyState => 'Пока нет бесед. Начните чат с другом!';

  @override
  String get newMessageTitle => 'Новое сообщение';

  @override
  String get chatCallLater => 'Голосовой звонок позже (язык Circle скоро)';

  @override
  String errorWithDetails(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Поздоровайтесь с $name!';
  }

  @override
  String get chatMessageHint => 'Сообщение...';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsTabAll => 'Все';

  @override
  String get notificationsTabCourses => 'Курсы';

  @override
  String get notificationsTabSocial => 'Социальные';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Система';

  @override
  String get notificationsEmpty => 'Здесь нет уведомлений.';

  @override
  String get notificationsDeleted => 'Уведомление удалено';

  @override
  String get notificationTitleFallback => 'Уведомление';

  @override
  String get notificationTypeCourse => 'Курс';

  @override
  String get notificationTypeSocial => 'Социальное';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Система';

  @override
  String get notificationsFriendAccepted => 'Запрос в друзья принят';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Не удалось принять запрос в друзья: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Запрос в друзья отклонен';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Не удалось отклонить запрос в друзья: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Не удалось присоединиться к Circle: $error';
  }

  @override
  String get notificationsOpening => 'Открытие';

  @override
  String get notificationsOpened => 'Открыто';

  @override
  String notificationsActionMessage(Object action) {
    return '$action уведомление';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionAccount => 'Аккаунт';

  @override
  String get settingsEditProfile => 'Редактировать профиль';

  @override
  String get settingsPrivacy => 'Конфиденциальность';

  @override
  String get settingsSecurity => 'Безопасность';

  @override
  String get settingsSectionGameplay => 'Игра';

  @override
  String get settingsShowTranslationLine => 'Показать строку перевода';

  @override
  String get settingsShowReadingLine => 'Показать чтение (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Таймер по умолчанию на вопрос';

  @override
  String get settingsMatchDifficulty => 'Сложность матча';

  @override
  String get settingsMatchDifficultyAdaptive => 'Адаптивная';

  @override
  String get settingsSectionSoundFeel => 'Звук и вибрация';

  @override
  String get settingsMusic => 'Музыка';

  @override
  String get settingsSoundEffects => 'Звуковые эффекты';

  @override
  String get settingsHaptics => 'Вибрация';

  @override
  String get settingsSectionNotifications => 'Уведомления';

  @override
  String get settingsPushNotifications => 'Push-уведомления';

  @override
  String get settingsDailyReminder => 'Ежедневное напоминание';

  @override
  String get settingsSectionAppearance => 'Внешний вид';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsUiLanguage => 'Язык интерфейса';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsVersion => 'Версия';

  @override
  String get settingsTermsPrivacy => 'Условия и конфиденциальность';

  @override
  String get settingsSupport => 'Поддержка';

  @override
  String get settingsLogout => 'Выйти';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeDark => 'Темная';

  @override
  String get themeLight => 'Светлая';

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
  String get editProfileUpdated => 'Профиль обновлен';

  @override
  String get editProfileTitle => 'Редактировать профиль';

  @override
  String get editProfilePhotoLabel => 'Фото профиля';

  @override
  String get editProfilePhotoSubtitle =>
      'Выбор аватара через Supabase Storage скоро.';

  @override
  String get editProfileChangePhoto => 'Изменить';

  @override
  String get editProfileAvatarUploadSoon => 'Загрузка аватара скоро доступна';

  @override
  String get editProfileDisplayNameLabel => 'Отображаемое имя';

  @override
  String get editProfileDisplayNameHint => 'Ваше имя';

  @override
  String get editProfileDisplayNameRequired => 'Введите ваше имя';

  @override
  String get editProfileDisplayNameTooShort => 'Слишком короткое';

  @override
  String get editProfileUsernameLabel => 'Имя пользователя';

  @override
  String get editProfileUsernameHint => 'alex_uchenik';

  @override
  String get editProfileUsernameRequired => 'Введите имя пользователя';

  @override
  String get editProfileUsernameTooShort => 'Мин. 3 символа';

  @override
  String get editProfileUsernameInvalid => 'Только буквы, цифры, _';

  @override
  String get editProfileBioLabel => 'О себе';

  @override
  String get editProfileBioHint => 'Короткая биография...';

  @override
  String get editProfileBioTooLong => 'Макс. 120 символов';

  @override
  String get editProfileLocationLabel => 'Местоположение';

  @override
  String get editProfileLocationHint => 'Город / Страна';

  @override
  String get editProfileDailyGoalTitle => 'Ежедневная цель';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Выберите, сколько минут вы хотите заниматься каждый день.';

  @override
  String get securityTitle => 'Безопасность';

  @override
  String get securitySectionPassword => 'Пароль';

  @override
  String get securityChangePasswordTitle => 'Изменить пароль';

  @override
  String get securityChangePasswordSubtitle => 'Регулярно обновляйте пароль.';

  @override
  String get securitySectionTwoFactor => 'Двухфакторная аутентификация';

  @override
  String get securityEnable2faTitle => 'Включить 2FA';

  @override
  String get securityEnable2faSubtitle => 'Дополнительная защита при входе.';

  @override
  String get securitySectionAppLock => 'Блокировка приложения';

  @override
  String get securityBiometricTitle => 'Биометрическая разблокировка';

  @override
  String get securityBiometricSubtitle =>
      'Используйте FaceID/TouchID для разблокировки SOMA.';

  @override
  String get securityAppLockTitle => 'Блокировка приложения';

  @override
  String get securityAppLockSubtitle =>
      'Блокируйте SOMA при выходе из приложения.';

  @override
  String get securitySectionSessions => 'Активные сессии';

  @override
  String get securityNoSessions => 'Активных сессий не найдено.';

  @override
  String get securityThisDevice => 'Это устройство';

  @override
  String get securityDevice => 'Устройство';

  @override
  String get securityActiveLabel => 'Активно';

  @override
  String get securitySignInToEnable2fa => 'Войдите для включения 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Не удалось включить 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Не удалось отключить 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Настроить 2FA';

  @override
  String get securitySecretKeyLabel => 'Секретный ключ';

  @override
  String get securityCodeHint => '6-значный код';

  @override
  String get security2faEnabled => '2FA включена';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Не удалось проверить код: $error';
  }

  @override
  String get securityVerifying => 'Проверка...';

  @override
  String get securityVerify => 'Проверить';

  @override
  String get securityCurrentPasswordHint => 'Текущий пароль';

  @override
  String get securityNewPasswordHint => 'Новый пароль (мин. 8 символов)';

  @override
  String get securityConfirmPasswordHint => 'Подтвердите новый пароль';

  @override
  String get securitySignInToChangePassword => 'Войдите для изменения пароля';

  @override
  String get securityEnterCurrentPassword => 'Введите текущий пароль';

  @override
  String get securityPasswordMinLength =>
      'Новый пароль должен содержать минимум 8 символов';

  @override
  String get securityPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get securityPasswordUpdated => 'Пароль обновлен';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Не удалось обновить пароль: $error';
  }

  @override
  String get securityAutoLockAfter => 'Автоблокировка после';

  @override
  String get privacyTitle => 'Конфиденциальность';

  @override
  String get privacySectionVisibility => 'Видимость';

  @override
  String get privacyProfileVisibilityTitle => 'Видимость профиля';

  @override
  String get privacyVisibilityPublic => 'Публичный';

  @override
  String get privacyVisibilityFriends => 'Друзья';

  @override
  String get privacyVisibilityPrivate => 'Приватный';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Любой может просматривать ваш профиль.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Только друзья могут просматривать ваш профиль.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Только вы можете просматривать ваш профиль.';

  @override
  String get privacySectionActivity => 'Активность';

  @override
  String get privacyShowOnlineTitle => 'Показывать статус онлайн';

  @override
  String get privacyShowOnlineSubtitle =>
      'Позволить другим видеть, когда вы онлайн.';

  @override
  String get privacyShowActivityTitle => 'Показывать учебную активность';

  @override
  String get privacyShowActivitySubtitle =>
      'Отображать серию, XP и текущий прогресс.';

  @override
  String get privacySectionSocial => 'Социальное';

  @override
  String get privacyAllowRequestsTitle => 'Разрешить запросы в друзья';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Позволить людям отправлять запросы в друзья.';

  @override
  String get privacyWhoCanDmTitle => 'Кто может отправлять сообщения';

  @override
  String get privacyDmEveryone => 'Все';

  @override
  String get privacyDmFriends => 'Друзья';

  @override
  String get privacyDmNoOne => 'Никто';

  @override
  String get privacyDmEveryoneSubtitle => 'Любой может отправлять сообщения.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Только друзья могут отправлять сообщения.';

  @override
  String get privacyDmNoOneSubtitle => 'Никто не может отправлять сообщения.';

  @override
  String get privacySectionBlockedUsers => 'Заблокированные пользователи';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Управление заблокированными пользователями скоро доступно.';

  @override
  String get privacySectionDataControls => 'Управление данными';

  @override
  String get privacyExportDataTitle => 'Экспортировать мои данные';

  @override
  String get privacyExportDataSubtitle => 'Скачайте вашу активность и курсы.';

  @override
  String get privacyExportInfoTitle => 'Экспорт данных';

  @override
  String get privacyExportInfoBody =>
      'Следующий шаг: создайте экспорт JSON/CSV и отправьте по электронной почте или скачайте локально.';

  @override
  String get privacyDeleteAccountTitle => 'Удалить аккаунт';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Это навсегда удалит ваш аккаунт и данные.';

  @override
  String get privacyDeleteConfirmTitle => 'Удалить аккаунт?';

  @override
  String get privacyDeleteConfirmBody =>
      'Это действие необратимо. Ваш профиль, курсы, друзья и сообщения будут удалены.';

  @override
  String get privacyDeleteComingSoon =>
      'Удаление будет подключено к Supabase позже';

  @override
  String get soloLabel => 'Соло';

  @override
  String get soloResultsCompletedTitle => 'Соло-сессия завершена';

  @override
  String get soloResultsFeedbackElite =>
      'Элитное выступление. Сохраняйте серию';

  @override
  String get soloResultsFeedbackStrong =>
      'Отличная работа. Вы быстро улучшаетесь.';

  @override
  String get soloResultsFeedbackProgress =>
      'Хороший прогресс. Повторите ошибки и попробуйте снова.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Без стресса. Попробуйте снова с меньшим количеством вопросов и концентрацией.';

  @override
  String get soloResultsPerfectScore =>
      'Идеальный результат! Нет ошибок для повторения.';

  @override
  String get soloResultsReviewPrompt =>
      'Повторите ошибки, чтобы учиться быстрее. Мы покажем неправильные ответы ниже.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Повторить ошибки ($count)';
  }

  @override
  String get authNotSignedIn => 'Вы не вошли в систему';

  @override
  String get genericUser => 'Пользователь';

  @override
  String get loading => 'Загрузка...';

  @override
  String get edit => 'Редактировать';

  @override
  String get send => 'Отправить';

  @override
  String get join => 'Присоединиться';

  @override
  String get leave => 'Выйти';

  @override
  String get ready => 'Готов';

  @override
  String get levelBeginner => 'Начинающий';

  @override
  String get levelIntermediate => 'Средний';

  @override
  String get levelAdvanced => 'Продвинутый';

  @override
  String questionsShort(Object count) {
    return '$count В';
  }

  @override
  String secondsShort(Object count) {
    return '$countс';
  }

  @override
  String get circlesAllCourses => 'Все курсы';

  @override
  String get circlesAllModes => 'Все режимы';

  @override
  String get circlesAllLevels => 'Все уровни';

  @override
  String get circlesAddNewCourse => 'Добавить новый курс';

  @override
  String get circlesCoursesTitle => 'Курсы';

  @override
  String get circlesModeTitle => 'Режим';

  @override
  String get circlesLevelTitle => 'Уровень';

  @override
  String get circlesNoActiveForFilters =>
      'Нет активных Circles для этих фильтров.';

  @override
  String get circlesUnknownRoom => 'Неизвестная комната';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Создать Circle';

  @override
  String get circlesCircleName => 'Название Circle';

  @override
  String get circlesEnterName => 'Введите название';

  @override
  String get circlesLanguages => 'Языки';

  @override
  String get circlesRoomSetup => 'Настройка комнаты';

  @override
  String get circlesPlayers => 'Игроки';

  @override
  String get circlesEmptySlot => 'Пустое место';

  @override
  String get circlesPlayersRange => '1-5 игроков';

  @override
  String get circlesQuestions => 'Вопросы';

  @override
  String get circlesQuestionsSubtitle => 'Количество вопросов';

  @override
  String get circlesTimePerQuestion => 'Время на вопрос';

  @override
  String get circlesSecondsPerQuestion => 'Секунд на вопрос';

  @override
  String get circlesAdvanced => 'Расширенные';

  @override
  String get circlesAllowSpectators => 'Разрешить зрителей';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Позволить другим наблюдать без игры.';

  @override
  String get circlesLiveVoiceChat => 'Голосовой чат вживую';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Включить голосовой чат во время матчей.';

  @override
  String get circlesLiveTextChat => 'Текстовый чат вживую';

  @override
  String get circlesLiveTextChatSubtitle => 'Включить чат во время матчей.';

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
  String get circlesCreatedSuccess => 'Circle создан';

  @override
  String circlesCreateError(Object error) {
    return 'Не удалось создать Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Подсказка: Вы можете пригласить друзей после создания.';

  @override
  String circlesJoinError(Object error) {
    return 'Не удалось присоединиться к Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Лобби Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Код: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Настройки матча';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Уровень $level';
  }

  @override
  String get circlesDifficulty => 'Сложность';

  @override
  String get circlesPerQuestionShort => 'на вопрос';

  @override
  String get circlesInvite => 'Пригласить';

  @override
  String get circlesCopyId => 'Копировать ID';

  @override
  String get circlesCopiedId => 'ID скопирован';

  @override
  String get circlesMatchInProgress => 'Матч идет';

  @override
  String get circlesSpectatorQueuedBody =>
      'Матч идет. Вы присоединитесь как зритель.';

  @override
  String get circlesHostStartWhenReady =>
      'Хост запустит, когда все будут готовы.';

  @override
  String get circlesSpectators => 'Зрители';

  @override
  String get circlesSpectator => 'Зритель';

  @override
  String get circlesSpectatorCanWatch => 'Зрители могут смотреть вживую.';

  @override
  String get circlesJoinRequests => 'Запросы на вход';

  @override
  String get circlesAcceptSpectatorsHint => 'Примите зрителей до начала матча.';

  @override
  String get circlesStartGame => 'Начать игру';

  @override
  String get circlesWaitingForPlayers => 'Ожидание игроков';

  @override
  String get circlesLeaveCircle => 'Покинуть Circle';

  @override
  String get circlesRequestSent => 'Запрос отправлен';

  @override
  String get circlesRequestToJoin => 'Запрос на вход';

  @override
  String get circlesWatchLive => 'Смотреть вживую';

  @override
  String get circlesPlayerTip =>
      'Нажмите Готов, когда будете готовы. Хост запустит матч.';

  @override
  String get circlesSpectatorTip =>
      'Вы наблюдаете. Смотрите вживую, как только хост запустит.';

  @override
  String get circlesHostControls => 'Управление хоста';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Не удалось передать хоста: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Не удалось завершить Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Пользователь @$username не найден';
  }

  @override
  String get circlesInvalidUser => 'Неверный пользователь';

  @override
  String get circlesCantInviteSelf => 'Вы не можете пригласить себя';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return 'Пользователь @$username уже в Circle';
  }

  @override
  String get circlesDefaultHost => 'Хост';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Пригласить по имени пользователя';

  @override
  String circlesInviteSent(Object username) {
    return 'Приглашение отправлено @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Не удалось отправить приглашение: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Запрос на вход отправлен';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Запрос не удался: $error';
  }

  @override
  String get circlesFull => 'Circle заполнен';

  @override
  String get circlesSpectatorAdded => 'Зритель добавлен';

  @override
  String circlesApproveFailed(Object error) {
    return 'Не удалось одобрить запрос: $error';
  }

  @override
  String get circlesRequestDeclined => 'Запрос отклонен';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Не удалось отклонить запрос: $error';
  }

  @override
  String get circlesParticipant => 'Участник';

  @override
  String get circlesLeavePromptTitle => 'Покинуть Circle?';

  @override
  String get circlesLeavePromptTransfer => 'Передайте хоста перед уходом.';

  @override
  String get circlesLeavePromptEndOnly => 'Завершите Circle и уйдите.';

  @override
  String get circlesTransferHost => 'Передать хоста';

  @override
  String get circlesEndCircle => 'Завершить Circle';

  @override
  String get circlesTransferHostTitle => 'Передать хоста';

  @override
  String circlesShareId(Object id) {
    return 'ID Circle: $id';
  }
}
