// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Вчись. Змагайся. Панuj';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get signIn => 'Увійти';

  @override
  String get skipForNow => 'Пропустити зараз';

  @override
  String get authFillAllFields => 'Будь ласка, заповніть усі поля';

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
    return 'Помилка: $error';
  }

  @override
  String get authEmail => 'Електронна пошта';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authUsername => 'Ім\'я користувача';

  @override
  String get authContinue => 'Продовжити';

  @override
  String get authSigningIn => 'Вхід...';

  @override
  String get authCreateAccount => 'Створити обліковий запис';

  @override
  String get authCreating => 'Створення...';

  @override
  String get authNeedAccount => 'Немає облікового запису? ';

  @override
  String get authHaveAccount => 'Вже є обліковий запис? ';

  @override
  String get dialogAuthRequiredTitle => 'Увійдіть для доступу до Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles — це багатокористувацькі кімнати. Створіть обліковий запис, щоб приєднатися до живих матчів, запросити друзів і зберегти прогрес.';

  @override
  String get notNow => 'Не зараз';

  @override
  String get navHome => 'Головна';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Профіль';

  @override
  String get removeCourseTitle => 'Видалити курс?';

  @override
  String removeCourseBody(Object course) {
    return '$course буде видалено з вашого списку';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get remove => 'Видалити';

  @override
  String welcomeBack(Object name) {
    return 'З поверненням, $name!';
  }

  @override
  String get editCourses => 'Редагувати курси';

  @override
  String get done => 'Готово';

  @override
  String get noCoursesToEdit => 'Немає курсів для редагування';

  @override
  String get addCourse => 'Додати курс';

  @override
  String get unknown => 'Невідомо';

  @override
  String get iSpeak => 'Я розмовляю';

  @override
  String get iWantToLearn => 'Я хочу вивчити';

  @override
  String get chooseYourLanguage => 'Оберіть свою мову';

  @override
  String get chooseLearningLanguage => 'Оберіть мову для вивчення';

  @override
  String get chooseTwoDifferentLanguages =>
      'Будь ласка, оберіть дві різні мови';

  @override
  String get createCourse => 'Створити курс';

  @override
  String get soloCourseTitle => 'Соло курс';

  @override
  String get searchLanguage => 'Пошук мови';

  @override
  String get noMatches => 'Немає збігів';

  @override
  String get chooseCourseType => 'Оберіть тип курсу';

  @override
  String get soloStudyDescription =>
      'Навчайтеся самостійно з такими ж тестами, як у Circles - але без кімнат, чату, глядачів або опцій хоста';

  @override
  String get soloModeVocabulary => 'Лексика';

  @override
  String get soloModeSentences => 'Речення';

  @override
  String get soloModeReview => 'Повторення';

  @override
  String get soloModeVocabularySubtitle =>
      'Множинний вибір, значення, синоніми, використання';

  @override
  String get soloModeSentencesSubtitle =>
      'Заповнення пропусків + переклад + читання';

  @override
  String get soloModeReviewDescription =>
      'Практикуйте вивчене: слабкі слова, нещодавні помилки та інтервальне повторення';

  @override
  String get startReview => 'Почати повторення';

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
    return 'Налаштування $mode';
  }

  @override
  String get difficulty => 'Складність';

  @override
  String get numberOfQuestions => 'Кількість питань';

  @override
  String get timerPerQuestion => 'Таймер на питання';

  @override
  String get noTimer => 'Без таймера';

  @override
  String get start => 'Почати';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get profileSignInToMessage => 'Увійдіть, щоб надіслати повідомлення';

  @override
  String get profileThatsYourProfile => 'Це ваш профіль';

  @override
  String get profileSignInToAddFriends => 'Увійдіть, щоб додати друзів';

  @override
  String get profileCantAddYourself => 'Ви не можете додати себе';

  @override
  String profileRequestSent(Object username) {
    return 'Запит надіслано @$username';
  }

  @override
  String get profileRequestFailed => 'Не вдалося надіслати запит';

  @override
  String get profileDefaultDisplayName => 'Новий користувач';

  @override
  String get profileDefaultBio => 'Готовий вчитися!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Гість';

  @override
  String get guestUsername => 'гість';

  @override
  String get guestSessionLabel => 'Гостьовий сеанс';

  @override
  String get unlockFullProfile => 'Розблокуйте повний профіль';

  @override
  String get guestBenefitSync => 'Синхронізуйте прогрес на всіх пристроях';

  @override
  String get guestBenefitCircles => 'Приєднуйтесь до Circles і грайте наживо';

  @override
  String get guestBenefitNotifications =>
      'Отримуйте сповіщення та запити дружби';

  @override
  String get progressStaysOnDevice =>
      'Прогрес залишається на цьому пристрої, поки ви не ввійдете';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Ціль: $minutes хв';
  }

  @override
  String get profileXpProgress => 'Прогрес XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Перемоги';

  @override
  String get profileStreak => 'Серія';

  @override
  String get profileFriendsTitle => 'Друзі';

  @override
  String get profileViewAll => 'Переглянути все';

  @override
  String get profileAchievementsTitle => 'Досягнення';

  @override
  String get profileNoAchievements => 'Поки немає досягнень';

  @override
  String get profileRequested => 'Запит надіслано';

  @override
  String get profileSending => 'Надсилання...';

  @override
  String get profileAddFriend => 'Додати друга';

  @override
  String get profileConnectTitle => 'Підключитися';

  @override
  String get profileMessage => 'Повідомлення';

  @override
  String get profileSnapshot => 'Знімок профілю';

  @override
  String get profileLocationHidden => 'Місцезнаходження приховано';

  @override
  String get profileBioHidden => 'Біографія прихована';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Щоденна ціль $minutes хв';
  }

  @override
  String get circleInviteTitle => 'Запрошення в Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Увійдіть, щоб приєднатися';

  @override
  String get joiningCircle => 'Приєднання...';

  @override
  String get joinCircle => 'Приєднатися до Circle';

  @override
  String get circleJoinedAsPlayer => 'Приєдналися як гравець';

  @override
  String get circleJoinedAsSpectator => 'Приєдналися як глядач';

  @override
  String get accept => 'Прийняти';

  @override
  String get decline => 'Відхилити';

  @override
  String get open => 'Відкрити';

  @override
  String get circleCountdownTitle => 'Приготуйтесь';

  @override
  String get circleCountdownSubtitle => 'Circle починається...';

  @override
  String get userFallbackName => 'Користувач';

  @override
  String get micOff => 'Мікрофон вимкнено';

  @override
  String get micOn => 'Мікрофон увімкнено';

  @override
  String get roleHost => 'Хост';

  @override
  String get roleSpectator => 'Глядач';

  @override
  String get tagHost => 'ХОСТ';

  @override
  String get tagYou => 'ВИ';

  @override
  String get statusCorrect => 'Правильно';

  @override
  String get statusWrong => 'Неправильно';

  @override
  String get statusWaiting => 'Очікування';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'бали';

  @override
  String get pointsLabel => 'Бали';

  @override
  String get statCorrect => 'Правильно';

  @override
  String get statAnswers => 'відповідей';

  @override
  String get statTotal => 'Всього';

  @override
  String get statQuestions => 'питань';

  @override
  String get statAccuracy => 'Точність';

  @override
  String get statRate => 'рівень';

  @override
  String get statRank => 'Ранг';

  @override
  String get statPosition => 'позиція';

  @override
  String get statMode => 'Режим';

  @override
  String get statType => 'тип';

  @override
  String get next => 'Далі';

  @override
  String get submit => 'Надіслати';

  @override
  String get continueLabel => 'Продовжити';

  @override
  String get save => 'Зберегти';

  @override
  String get playAgain => 'Грати знову';

  @override
  String get backToCourse => 'Назад до курсу';

  @override
  String get resultsTitle => 'Результати';

  @override
  String get shareLater => 'Поділитися пізніше';

  @override
  String get delete => 'Видалити';

  @override
  String get ok => 'Гаразд';

  @override
  String minutesShort(Object minutes) {
    return '$minutes хв';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count хв';
  }

  @override
  String timeShortHours(Object count) {
    return '$count год';
  }

  @override
  String timeShortDays(Object count) {
    return '$count дн';
  }

  @override
  String get timeJustNow => 'щойно';

  @override
  String timeMinutesAgo(Object count) {
    return '$count хв тому';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count год тому';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count дн тому';
  }

  @override
  String get liveQuizWaitingForHost => 'Очікування хоста...';

  @override
  String get liveQuizJoinRequestSent => 'Запит на приєднання надіслано';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Не вдалося надіслати запит: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Керування хоста';

  @override
  String get liveQuizSpectatorModeTitle => 'Режим глядача';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Раунди автоматично переходять, коли всі відповідають або закінчується час';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Дивіться питання та таблицю лідерів наживо. Ви не можете відповідати';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Питання $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Запит надіслано';

  @override
  String get liveQuizRequestToJoin => 'Запит на приєднання';

  @override
  String get liveQuizSpectatorFooter =>
      'Ви дивитесь наживо. Насолоджуйтесь питаннями та таблицею лідерів';

  @override
  String get circleNotFound => 'Circle не знайдено';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Не вдалося розпочати реванш: $error';
  }

  @override
  String get resultsMatchTitle => 'Результати матчу';

  @override
  String resultsNiceWork(Object name) {
    return 'Гарна робота, $name';
  }

  @override
  String get resultsPlaceFirst => '1-е місце';

  @override
  String get resultsPlaceSecond => '2-е місце';

  @override
  String get resultsPlaceThird => '3-є місце';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Місце $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'З $players гравців';
  }

  @override
  String get resultsHighlightChampion => 'Чемпіон! Ви домінували в цьому колі';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Чудова точність - ви близькі до вершини!';

  @override
  String get resultsHighlightKeepGoing =>
      'Продовжуйте - постійність перемагає швидкість';

  @override
  String get resultsLeaderboardTitle => 'Таблиця лідерів';

  @override
  String resultsPlayersCount(Object count) {
    return '$count гравців';
  }

  @override
  String get resultsBackToCircles => 'Назад до Circles';

  @override
  String get resultsRematch => 'Реванш';

  @override
  String get resultsPlayAgain => 'Грати знову';

  @override
  String get leaderboardGlobalTitle => 'Глобальний рейтинг';

  @override
  String get leaderboardEmpty => 'Поки немає рейтингу';

  @override
  String get aboutTitle => 'Про додаток';

  @override
  String aboutVersion(Object version) {
    return 'Версія $version';
  }

  @override
  String get aboutDescription =>
      'SOMA — це ігрова платформа для вивчення мов, яка робить опанування нових мов захоплюючим і соціальним. Змагайтеся в Circles, практикуйтесь наодинці та відстежуйте свій прогрес.';

  @override
  String get aboutTerms => 'Умови використання';

  @override
  String get aboutPrivacy => 'Політика конфіденційності';

  @override
  String get aboutOpenSource => 'Ліцензії відкритого коду';

  @override
  String get addFriendTitle => 'Додати друга';

  @override
  String get addFriendFindByUsername => 'Знайти за іменем користувача';

  @override
  String get addFriendUsernameHint => 'Введіть ім\'я користувача...';

  @override
  String get addFriendTip =>
      'Порада: підтримка QR-коду + ID друга буде додана пізніше';

  @override
  String get addFriendSending => 'Надсилання...';

  @override
  String get addFriendSendRequest => 'Надіслати запит';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Користувача @$username не знайдено';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Дія не вдалася або вже надіслано: $error';
  }

  @override
  String get friendsTitle => 'Друзі';

  @override
  String get searchFriendsHint => 'Пошук друзів...';

  @override
  String get somaLearnerSubtitle => 'Учень Soma';

  @override
  String get friendRequestLabel => 'Запит';

  @override
  String get friendRequestSentLabel => 'Запит надіслано';

  @override
  String get friendIncomingRequestLabel => 'Вхідний запит';

  @override
  String get friendRequestsSection => 'Запити';

  @override
  String get friendPendingSection => 'Очікування';

  @override
  String get friendAllSection => 'Усі друзі';

  @override
  String get friendsEmptyState =>
      'Поки немає друзів. Додайте свого першого друга!';

  @override
  String get friendsEmptyShort => 'Поки немає друзів';

  @override
  String noMatchForQuery(Object query) {
    return 'Немає збігів для \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'Вхідні';

  @override
  String get searchChatsHint => 'Пошук чатів...';

  @override
  String get inboxEmptyState => 'Поки немає розмов. Почніть чат з другом!';

  @override
  String get newMessageTitle => 'Нове повідомлення';

  @override
  String get chatCallLater =>
      'Голосовий дзвінок пізніше (Circle voice наступний)';

  @override
  String errorWithDetails(Object error) {
    return 'Помилка: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Привітайтеся з $name!';
  }

  @override
  String get chatMessageHint => 'Повідомлення...';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsTabAll => 'Усі';

  @override
  String get notificationsTabCourses => 'Курси';

  @override
  String get notificationsTabSocial => 'Соціальні';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Система';

  @override
  String get notificationsEmpty => 'Немає сповіщень';

  @override
  String get notificationsDeleted => 'Сповіщення видалено';

  @override
  String get notificationTitleFallback => 'Сповіщення';

  @override
  String get notificationTypeCourse => 'Курс';

  @override
  String get notificationTypeSocial => 'Соціальне';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Система';

  @override
  String get notificationsFriendAccepted => 'Запит дружби прийнято';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Не вдалося прийняти запит дружби: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Запит дружби відхилено';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Не вдалося відхилити запит дружби: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Не вдалося приєднатися до Circle: $error';
  }

  @override
  String get notificationsOpening => 'Відкривається';

  @override
  String get notificationsOpened => 'Відкрито';

  @override
  String notificationsActionMessage(Object action) {
    return '$action сповіщення';
  }

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSectionAccount => 'Обліковий запис';

  @override
  String get settingsEditProfile => 'Редагувати профіль';

  @override
  String get settingsPrivacy => 'Конфіденційність';

  @override
  String get settingsSecurity => 'Безпека';

  @override
  String get settingsSectionGameplay => 'Геймплей';

  @override
  String get settingsShowTranslationLine => 'Показати рядок перекладу';

  @override
  String get settingsShowReadingLine => 'Показати читання (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Стандартний таймер на питання';

  @override
  String get settingsMatchDifficulty => 'Складність матчу';

  @override
  String get settingsMatchDifficultyAdaptive => 'Адаптивна';

  @override
  String get settingsSectionSoundFeel => 'Звук і відчуття';

  @override
  String get settingsMusic => 'Музика';

  @override
  String get settingsSoundEffects => 'Звукові ефекти';

  @override
  String get settingsHaptics => 'Вібрація';

  @override
  String get settingsSectionNotifications => 'Сповіщення';

  @override
  String get settingsPushNotifications => 'Push-сповіщення';

  @override
  String get settingsDailyReminder => 'Щоденне нагадування';

  @override
  String get settingsSectionAppearance => 'Зовнішній вигляд';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsUiLanguage => 'Мова інтерфейсу';

  @override
  String get settingsSectionAbout => 'Про додаток';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsTermsPrivacy => 'Умови та конфіденційність';

  @override
  String get settingsSupport => 'Підтримка';

  @override
  String get settingsLogout => 'Вийти';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

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
  String get editProfileUpdated => 'Профіль оновлено';

  @override
  String get editProfileTitle => 'Редагувати профіль';

  @override
  String get editProfilePhotoLabel => 'Фото профілю';

  @override
  String get editProfilePhotoSubtitle =>
      'Вибір аватара через Supabase Storage незабаром';

  @override
  String get editProfileChangePhoto => 'Змінити';

  @override
  String get editProfileAvatarUploadSoon => 'Завантаження аватара незабаром';

  @override
  String get editProfileDisplayNameLabel => 'Ім\'я для відображення';

  @override
  String get editProfileDisplayNameHint => 'Ваше ім\'я';

  @override
  String get editProfileDisplayNameRequired => 'Введіть своє ім\'я';

  @override
  String get editProfileDisplayNameTooShort => 'Занадто коротке';

  @override
  String get editProfileUsernameLabel => 'Ім\'я користувача';

  @override
  String get editProfileUsernameHint => 'іван_учень';

  @override
  String get editProfileUsernameRequired => 'Введіть ім\'я користувача';

  @override
  String get editProfileUsernameTooShort => 'Мінімум 3 символи';

  @override
  String get editProfileUsernameInvalid => 'Тільки літери, цифри, _';

  @override
  String get editProfileBioLabel => 'Біографія';

  @override
  String get editProfileBioHint => 'Коротка біографія...';

  @override
  String get editProfileBioTooLong => 'Максимум 120 символів';

  @override
  String get editProfileLocationLabel => 'Місцезнаходження';

  @override
  String get editProfileLocationHint => 'Місто / Країна';

  @override
  String get editProfileDailyGoalTitle => 'Щоденна ціль';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Оберіть, скільки хвилин ви хочете навчатися щодня';

  @override
  String get securityTitle => 'Безпека';

  @override
  String get securitySectionPassword => 'Пароль';

  @override
  String get securityChangePasswordTitle => 'Змінити пароль';

  @override
  String get securityChangePasswordSubtitle =>
      'Регулярно оновлюйте свій пароль';

  @override
  String get securitySectionTwoFactor => 'Двофакторна автентифікація';

  @override
  String get securityEnable2faTitle => 'Увімкнути 2FA';

  @override
  String get securityEnable2faSubtitle => 'Додатковий захист при вході';

  @override
  String get securitySectionAppLock => 'Блокування додатка';

  @override
  String get securityBiometricTitle => 'Біометричне розблокування';

  @override
  String get securityBiometricSubtitle =>
      'Використовуйте FaceID/TouchID для розблокування SOMA';

  @override
  String get securityAppLockTitle => 'Блокування додатка';

  @override
  String get securityAppLockSubtitle => 'Блокувати SOMA при виході з додатка';

  @override
  String get securitySectionSessions => 'Активні сеанси';

  @override
  String get securityNoSessions => 'Активних сеансів не знайдено';

  @override
  String get securityThisDevice => 'Цей пристрій';

  @override
  String get securityDevice => 'Пристрій';

  @override
  String get securityActiveLabel => 'Активний';

  @override
  String get securitySignInToEnable2fa => 'Увійдіть, щоб увімкнути 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Не вдалося увімкнути 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Не вдалося вимкнути 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Налаштування 2FA';

  @override
  String get securitySecretKeyLabel => 'Секретний ключ';

  @override
  String get securityCodeHint => '6-значний код';

  @override
  String get security2faEnabled => '2FA увімкнено';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Не вдалося перевірити код: $error';
  }

  @override
  String get securityVerifying => 'Перевірка...';

  @override
  String get securityVerify => 'Перевірити';

  @override
  String get securityCurrentPasswordHint => 'Поточний пароль';

  @override
  String get securityNewPasswordHint => 'Новий пароль (мінімум 8 символів)';

  @override
  String get securityConfirmPasswordHint => 'Підтвердіть новий пароль';

  @override
  String get securitySignInToChangePassword => 'Увійдіть, щоб змінити пароль';

  @override
  String get securityEnterCurrentPassword => 'Введіть свій поточний пароль';

  @override
  String get securityPasswordMinLength =>
      'Новий пароль має містити принаймні 8 символів';

  @override
  String get securityPasswordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get securityPasswordUpdated => 'Пароль оновлено';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Не вдалося оновити пароль: $error';
  }

  @override
  String get securityAutoLockAfter => 'Автоблокування через';

  @override
  String get privacyTitle => 'Конфіденційність';

  @override
  String get privacySectionVisibility => 'Видимість';

  @override
  String get privacyProfileVisibilityTitle => 'Видимість профілю';

  @override
  String get privacyVisibilityPublic => 'Публічний';

  @override
  String get privacyVisibilityFriends => 'Друзі';

  @override
  String get privacyVisibilityPrivate => 'Приватний';

  @override
  String get privacyVisibilityPublicSubtitle => 'Усі можуть бачити ваш профіль';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Тільки друзі можуть бачити ваш профіль';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Тільки ви можете бачити свій профіль';

  @override
  String get privacySectionActivity => 'Активність';

  @override
  String get privacyShowOnlineTitle => 'Показувати онлайн-статус';

  @override
  String get privacyShowOnlineSubtitle =>
      'Дозволити іншим бачити, коли ви в мережі';

  @override
  String get privacyShowActivityTitle => 'Показувати навчальну активність';

  @override
  String get privacyShowActivitySubtitle =>
      'Показувати серію, XP та останній прогрес';

  @override
  String get privacySectionSocial => 'Соціальні мережі';

  @override
  String get privacyAllowRequestsTitle => 'Дозволити запити дружби';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Дозволити людям надсилати вам запити дружби';

  @override
  String get privacyWhoCanDmTitle => 'Хто може надсилати особисті повідомлення';

  @override
  String get privacyDmEveryone => 'Усі';

  @override
  String get privacyDmFriends => 'Друзі';

  @override
  String get privacyDmNoOne => 'Ніхто';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Будь-хто може надсилати вам повідомлення';

  @override
  String get privacyDmFriendsSubtitle =>
      'Тільки друзі можуть надсилати вам повідомлення';

  @override
  String get privacyDmNoOneSubtitle =>
      'Ніхто не може надсилати вам повідомлення';

  @override
  String get privacySectionBlockedUsers => 'Заблоковані користувачі';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Керування заблокованими користувачами незабаром';

  @override
  String get privacySectionDataControls => 'Керування даними';

  @override
  String get privacyExportDataTitle => 'Експортувати мої дані';

  @override
  String get privacyExportDataSubtitle => 'Завантажте свою активність та курси';

  @override
  String get privacyExportInfoTitle => 'Експорт даних';

  @override
  String get privacyExportInfoBody =>
      'Наступний крок: створити експорт JSON/CSV і надіслати електронною поштою або завантажити локально';

  @override
  String get privacyDeleteAccountTitle => 'Видалити обліковий запис';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Це назавжди видалить ваш обліковий запис і дані';

  @override
  String get privacyDeleteConfirmTitle => 'Видалити обліковий запис?';

  @override
  String get privacyDeleteConfirmBody =>
      'Ця дія незворотна. Ваш профіль, курси, друзі та повідомлення будуть видалені';

  @override
  String get privacyDeleteComingSoon =>
      'Видалення буде підключено до Supabase пізніше';

  @override
  String get soloLabel => 'Соло';

  @override
  String get soloResultsCompletedTitle => 'Соло-сеанс завершено';

  @override
  String get soloResultsFeedbackElite => 'Елітне виконання - зберігайте серію';

  @override
  String get soloResultsFeedbackStrong =>
      'Сильна робота - ви швидко вдосконалюєтесь';

  @override
  String get soloResultsFeedbackProgress =>
      'Гарний прогрес - перегляньте помилки і повторіть';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Без напруження - спробуйте ще раз з меншою кількістю питань і зосередьтесь';

  @override
  String get soloResultsPerfectScore =>
      'Ідеальний результат! Немає помилок для перегляду';

  @override
  String get soloResultsReviewPrompt =>
      'Переглядайте помилки, щоб вчитися швидше. Ваші неправильні відповіді нижче';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Переглянути помилки ($count)';
  }

  @override
  String get authNotSignedIn => 'Ви не ввійшли в систему';

  @override
  String get genericUser => 'Користувач';

  @override
  String get loading => 'Завантаження...';

  @override
  String get edit => 'Редагувати';

  @override
  String get send => 'Надіслати';

  @override
  String get join => 'Приєднатися';

  @override
  String get leave => 'Вийти';

  @override
  String get ready => 'Готовий';

  @override
  String get levelBeginner => 'Початківець';

  @override
  String get levelIntermediate => 'Середній';

  @override
  String get levelAdvanced => 'Просунутий';

  @override
  String questionsShort(Object count) {
    return '$count питань';
  }

  @override
  String secondsShort(Object count) {
    return '$count с';
  }

  @override
  String get circlesAllCourses => 'Усі курси';

  @override
  String get circlesAllModes => 'Усі режими';

  @override
  String get circlesAllLevels => 'Усі рівні';

  @override
  String get circlesAddNewCourse => 'Додати новий курс';

  @override
  String get circlesCoursesTitle => 'Курси';

  @override
  String get circlesModeTitle => 'Режим';

  @override
  String get circlesLevelTitle => 'Рівень';

  @override
  String get circlesNoActiveForFilters =>
      'Немає активних Circles для цих фільтрів';

  @override
  String get circlesUnknownRoom => 'Невідома кімната';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Створити Circle';

  @override
  String get circlesCircleName => 'Назва Circle';

  @override
  String get circlesEnterName => 'Введіть назву';

  @override
  String get circlesLanguages => 'Мови';

  @override
  String get circlesRoomSetup => 'Налаштування кімнати';

  @override
  String get circlesPlayers => 'Гравці';

  @override
  String get circlesEmptySlot => 'Порожнє місце';

  @override
  String get circlesPlayersRange => '1-5 гравців';

  @override
  String get circlesQuestions => 'Питання';

  @override
  String get circlesQuestionsSubtitle => 'Кількість питань';

  @override
  String get circlesTimePerQuestion => 'Час на питання';

  @override
  String get circlesSecondsPerQuestion => 'секунд на питання';

  @override
  String get circlesAdvanced => 'Розширені';

  @override
  String get circlesAllowSpectators => 'Дозволити глядачів';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Дозволити іншим дивитися без гри';

  @override
  String get circlesLiveVoiceChat => 'Голосовий чат наживо';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Увімкнути голосовий зв\'язок під час матчів';

  @override
  String get circlesLiveTextChat => 'Текстовий чат наживо';

  @override
  String get circlesLiveTextChatSubtitle => 'Увімкнути чат під час матчів';

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
  String get circlesCreatedSuccess => 'Circle створено';

  @override
  String circlesCreateError(Object error) {
    return 'Не вдалося створити Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Порада: ви можете запросити друзів після створення';

  @override
  String circlesJoinError(Object error) {
    return 'Не вдалося приєднатися до Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Лобі Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Код: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Налаштування матчу';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Рівень $level';
  }

  @override
  String get circlesDifficulty => 'Складність';

  @override
  String get circlesPerQuestionShort => 'на питання';

  @override
  String get circlesInvite => 'Запросити';

  @override
  String get circlesCopyId => 'Копіювати ID';

  @override
  String get circlesCopiedId => 'ID скопійовано';

  @override
  String get circlesMatchInProgress => 'Матч триває';

  @override
  String get circlesSpectatorQueuedBody =>
      'Матч триває. Ви приєднаєтеся як глядач';

  @override
  String get circlesHostStartWhenReady => 'Хост почне, коли всі будуть готові';

  @override
  String get circlesSpectators => 'Глядачі';

  @override
  String get circlesSpectator => 'Глядач';

  @override
  String get circlesSpectatorCanWatch => 'Глядачі можуть дивитися наживо';

  @override
  String get circlesJoinRequests => 'Запити на приєднання';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Прийміть глядачів перед початком матчу';

  @override
  String get circlesStartGame => 'Почати гру';

  @override
  String get circlesWaitingForPlayers => 'Очікування гравців';

  @override
  String get circlesLeaveCircle => 'Вийти з Circle';

  @override
  String get circlesRequestSent => 'Запит надіслано';

  @override
  String get circlesRequestToJoin => 'Запит на приєднання';

  @override
  String get circlesWatchLive => 'Дивитись наживо';

  @override
  String get circlesPlayerTip =>
      'Натисніть Готовий, коли будете готові. Хост почне матч';

  @override
  String get circlesSpectatorTip =>
      'Ви спостерігаєте. Дивіться наживо, коли хост почне';

  @override
  String get circlesHostControls => 'Керування хоста';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Не вдалося передати хоста: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Не вдалося завершити Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Користувача @$username не знайдено';
  }

  @override
  String get circlesInvalidUser => 'Недійсний користувач';

  @override
  String get circlesCantInviteSelf => 'Ви не можете запросити себе';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username вже в Circle';
  }

  @override
  String get circlesDefaultHost => 'Хост';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Запросити за іменем користувача';

  @override
  String circlesInviteSent(Object username) {
    return 'Запрошення надіслано @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Не вдалося надіслати запрошення: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Запит на приєднання надіслано';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Не вдалося надіслати запит: $error';
  }

  @override
  String get circlesFull => 'Circle заповнено';

  @override
  String get circlesSpectatorAdded => 'Глядача додано';

  @override
  String circlesApproveFailed(Object error) {
    return 'Не вдалося схвалити запит: $error';
  }

  @override
  String get circlesRequestDeclined => 'Запит відхилено';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Не вдалося відхилити запит: $error';
  }

  @override
  String get circlesParticipant => 'Учасник';

  @override
  String get circlesLeavePromptTitle => 'Вийти з Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Будь ласка, передайте хоста перед виходом';

  @override
  String get circlesLeavePromptEndOnly => 'Завершити Circle і вийти';

  @override
  String get circlesTransferHost => 'Передати хоста';

  @override
  String get circlesEndCircle => 'Завершити Circle';

  @override
  String get circlesTransferHostTitle => 'Передати хоста';

  @override
  String circlesShareId(Object id) {
    return 'ID Circle: $id';
  }
}
