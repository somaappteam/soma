// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Ucz się. Rywalizuj. Opanuj.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get skipForNow => 'Pomiń Teraz';

  @override
  String get authFillAllFields => 'Wypełnij wszystkie pola';

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
    return 'Błąd: $error';
  }

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Hasło';

  @override
  String get authUsername => 'Nazwa użytkownika';

  @override
  String get authContinue => 'Kontynuuj';

  @override
  String get authSigningIn => 'Logowanie...';

  @override
  String get authCreateAccount => 'Utwórz Konto';

  @override
  String get authCreating => 'Tworzenie...';

  @override
  String get authNeedAccount => 'Nie masz konta? ';

  @override
  String get authHaveAccount => 'Masz już konto? ';

  @override
  String get dialogAuthRequiredTitle =>
      'Zaloguj się, aby uzyskać dostęp do Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles to przestrzenie wieloosobowe. Utwórz konto, aby dołączyć do meczów na żywo, zapraszać znajomych i zapisywać postępy.';

  @override
  String get notNow => 'Nie Teraz';

  @override
  String get navHome => 'Strona Główna';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profil';

  @override
  String get removeCourseTitle => 'Usunąć Kurs?';

  @override
  String removeCourseBody(Object course) {
    return 'Usuwanie $course z listy startowej.';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String get remove => 'Usuń';

  @override
  String welcomeBack(Object name) {
    return 'Witaj ponownie, $name!';
  }

  @override
  String get editCourses => 'Edytuj Kursy';

  @override
  String get done => 'Gotowe';

  @override
  String get noCoursesToEdit => 'Brak kursów do edycji.';

  @override
  String get addCourse => 'Dodaj Kurs';

  @override
  String get unknown => 'Nieznany';

  @override
  String get iSpeak => 'Mówię';

  @override
  String get iWantToLearn => 'Chcę Się Uczyć';

  @override
  String get chooseYourLanguage => 'Wybierz Swój Język';

  @override
  String get chooseLearningLanguage =>
      'Wybierz język, którego chcesz się uczyć';

  @override
  String get chooseTwoDifferentLanguages => 'Wybierz dwa różne języki.';

  @override
  String get createCourse => 'Utwórz Kurs';

  @override
  String get soloCourseTitle => 'Kurs Solo';

  @override
  String get searchLanguage => 'Szukaj Języka';

  @override
  String get noMatches => 'Brak Wyników';

  @override
  String get chooseCourseType => 'Wybierz Typ Kursu';

  @override
  String get soloStudyDescription =>
      'Ucz się sam z quizami w stylu Circles - bez pokoi, czatu, widzów czy opcji hosta.';

  @override
  String get soloModeVocabulary => 'Słownictwo';

  @override
  String get soloModeSentences => 'Zdania';

  @override
  String get soloModeReview => 'Powtórka';

  @override
  String get soloModeVocabularySubtitle =>
      'Wybór wielokrotny znaczenia, synonimy, użycie';

  @override
  String get soloModeSentencesSubtitle =>
      'Uzupełnianie luk + tłumaczenia + czytanie';

  @override
  String get soloModeReviewDescription =>
      'Ćwicz to, czego się nauczyłeś: słabe słowa, ostatnie błędy, powtarzanie z przerwami.';

  @override
  String get startReview => 'Rozpocznij Powtórkę';

  @override
  String soloSetupTitle(Object mode) {
    return 'Ustawienia $mode';
  }

  @override
  String get difficulty => 'Trudność';

  @override
  String get numberOfQuestions => 'Liczba Pytań';

  @override
  String get timerPerQuestion => 'Licznik Czasu na Pytanie';

  @override
  String get noTimer => 'Bez Licznika';

  @override
  String get start => 'Start';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSignInToMessage => 'Zaloguj się, aby wysłać wiadomość';

  @override
  String get profileThatsYourProfile => 'To Twój profil';

  @override
  String get profileSignInToAddFriends => 'Zaloguj się, aby dodać znajomych';

  @override
  String get profileCantAddYourself => 'Nie możesz dodać siebie';

  @override
  String profileRequestSent(Object username) {
    return 'Wysłano prośbę do @$username';
  }

  @override
  String get profileRequestFailed => 'Nie udało się wysłać prośby';

  @override
  String get profileDefaultDisplayName => 'Nowy Użytkownik';

  @override
  String get profileDefaultBio => 'Gotowy do nauki!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Gość';

  @override
  String get guestUsername => 'gość';

  @override
  String get guestSessionLabel => 'Sesja Gościa';

  @override
  String get unlockFullProfile => 'Odblokuj Pełny Profil';

  @override
  String get guestBenefitSync =>
      'Synchronizuj postępy na wszystkich urządzeniach';

  @override
  String get guestBenefitCircles => 'Dołącz do Circles, aby grać na żywo';

  @override
  String get guestBenefitNotifications =>
      'Otrzymuj powiadomienia i prośby o dodanie do znajomych';

  @override
  String get progressStaysOnDevice =>
      'Dopóki się nie zalogujesz, Twoje postępy pozostają na tym urządzeniu.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Cel: $minutes min';
  }

  @override
  String get profileXpProgress => 'Postęp XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Wygrane';

  @override
  String get profileStreak => 'Seria';

  @override
  String get profileFriendsTitle => 'Znajomi';

  @override
  String get profileViewAll => 'Zobacz Wszystko';

  @override
  String get profileAchievementsTitle => 'Osiągnięcia';

  @override
  String get profileNoAchievements => 'Brak osiągnięć.';

  @override
  String get profileRequested => 'Wysłano Prośbę';

  @override
  String get profileSending => 'Wysyłanie...';

  @override
  String get profileAddFriend => 'Dodaj Znajomego';

  @override
  String get profileConnectTitle => 'Połącz';

  @override
  String get profileMessage => 'Wiadomość';

  @override
  String get profileSnapshot => 'Migawka Profilu';

  @override
  String get profileLocationHidden => 'Lokalizacja Ukryta';

  @override
  String get profileBioHidden => 'Bio Ukryte';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Dzienny Cel $minutes min';
  }

  @override
  String get circleInviteTitle => 'Zaproszenie do Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Zaloguj się, aby dołączyć';

  @override
  String get joiningCircle => 'Dołączanie...';

  @override
  String get joinCircle => 'Dołącz do Circle';

  @override
  String get circleJoinedAsPlayer => 'Dołączono jako gracz';

  @override
  String get circleJoinedAsSpectator => 'Dołączono jako widz';

  @override
  String get accept => 'Zaakceptuj';

  @override
  String get decline => 'Odrzuć';

  @override
  String get open => 'Otwórz';

  @override
  String get circleCountdownTitle => 'Przygotuj się';

  @override
  String get circleCountdownSubtitle => 'Circle się zaczyna...';

  @override
  String get userFallbackName => 'Użytkownik';

  @override
  String get micOff => 'Mikrofon Wyłączony';

  @override
  String get micOn => 'Mikrofon Włączony';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'Widz';

  @override
  String get tagHost => 'Host';

  @override
  String get tagYou => 'Ty';

  @override
  String get statusCorrect => 'Poprawnie';

  @override
  String get statusWrong => 'Błędnie';

  @override
  String get statusWaiting => 'Czekanie';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pkt';

  @override
  String get pointsLabel => 'Punkty';

  @override
  String get statCorrect => 'Poprawne';

  @override
  String get statAnswers => 'Odpowiedzi';

  @override
  String get statTotal => 'Suma';

  @override
  String get statQuestions => 'Pytania';

  @override
  String get statAccuracy => 'Dokładność';

  @override
  String get statRate => 'Wskaźnik';

  @override
  String get statRank => 'Ranga';

  @override
  String get statPosition => 'Pozycja';

  @override
  String get statMode => 'Tryb';

  @override
  String get statType => 'Typ';

  @override
  String get next => 'Dalej';

  @override
  String get submit => 'Wyślij';

  @override
  String get continueLabel => 'Kontynuuj';

  @override
  String get save => 'Zapisz';

  @override
  String get playAgain => 'Zagraj Ponownie';

  @override
  String get backToCourse => 'Powrót do Kursu';

  @override
  String get resultsTitle => 'Wyniki';

  @override
  String get shareLater => 'Udostępnij Później';

  @override
  String get delete => 'Usuń';

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
    return '$count godz.';
  }

  @override
  String timeShortDays(Object count) {
    return '$count dni';
  }

  @override
  String get timeJustNow => 'Przed chwilą';

  @override
  String timeMinutesAgo(Object count) {
    return '$count minut temu';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count godzin temu';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count dni temu';
  }

  @override
  String get liveQuizWaitingForHost => 'Czekanie na hosta...';

  @override
  String get liveQuizJoinRequestSent => 'Wysłano prośbę o dołączenie';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Prośba nie powiodła się: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Kontrola Hosta';

  @override
  String get liveQuizSpectatorModeTitle => 'Tryb Widza';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Rundy postępują automatycznie, gdy wszyscy odpowiedzą lub czas się skończy.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Oglądaj pytania i tablicę wyników na żywo. Nie możesz odpowiadać.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Pytanie $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Wysłano prośbę';

  @override
  String get liveQuizRequestToJoin => 'Poproś o Dołączenie';

  @override
  String get liveQuizSpectatorFooter =>
      'Oglądasz na żywo. Ciesz się pytaniami i tablicą wyników.';

  @override
  String get circleNotFound => 'Nie znaleziono Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Nie udało się rozpocząć rewanżu: $error';
  }

  @override
  String get resultsMatchTitle => 'Wyniki Meczu';

  @override
  String resultsNiceWork(Object name) {
    return 'Dobra robota, $name';
  }

  @override
  String get resultsPlaceFirst => '1.';

  @override
  String get resultsPlaceSecond => '2.';

  @override
  String get resultsPlaceThird => '3.';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank.';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'z $players graczy';
  }

  @override
  String get resultsHighlightChampion => 'Mistrz! Podbiłeś ten Circle.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Świetna dokładność. Byłeś prawie na szczycie!';

  @override
  String get resultsHighlightKeepGoing =>
      'Kontynuuj - konsekwencja pokonuje prędkość.';

  @override
  String get resultsLeaderboardTitle => 'Tablica Wyników';

  @override
  String resultsPlayersCount(Object count) {
    return '$count graczy';
  }

  @override
  String get resultsBackToCircles => 'Powrót do Circles';

  @override
  String get resultsRematch => 'Rewanż';

  @override
  String get resultsPlayAgain => 'Zagraj Ponownie';

  @override
  String get leaderboardGlobalTitle => 'Globalna Tablica Wyników';

  @override
  String get leaderboardEmpty => 'Brak tablicy wyników.';

  @override
  String get aboutTitle => 'O Aplikacji';

  @override
  String aboutVersion(Object version) {
    return 'Wersja $version';
  }

  @override
  String get aboutDescription =>
      'SOMA to gamifikowana platforma do nauki języków, która sprawia, że nauka nowych języków jest zabawna i społeczna. Dołącz do Circles, ćwicz solo i śledź swoje postępy.';

  @override
  String get aboutTerms => 'Warunki Usługi';

  @override
  String get aboutPrivacy => 'Polityka Prywatności';

  @override
  String get aboutOpenSource => 'Licencje Open Source';

  @override
  String get addFriendTitle => 'Dodaj Znajomego';

  @override
  String get addFriendFindByUsername => 'Znajdź po nazwie użytkownika';

  @override
  String get addFriendUsernameHint => 'Wprowadź nazwę użytkownika...';

  @override
  String get addFriendTip =>
      'Wskazówka: Obsługa kodu QR + ID znajomego może zostać dodana później.';

  @override
  String get addFriendSending => 'Wysyłanie...';

  @override
  String get addFriendSendRequest => 'Wyślij Prośbę';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Nie znaleziono @$username';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Akcja nie powiodła się lub już wysłano: $error';
  }

  @override
  String get friendsTitle => 'Znajomi';

  @override
  String get searchFriendsHint => 'Szukaj znajomych...';

  @override
  String get somaLearnerSubtitle => 'Uczeń Soma';

  @override
  String get friendRequestLabel => 'Prośba';

  @override
  String get friendRequestSentLabel => 'Wysłano Prośbę';

  @override
  String get friendIncomingRequestLabel => 'Prośba Przychodząca';

  @override
  String get friendRequestsSection => 'Prośby';

  @override
  String get friendPendingSection => 'Oczekujące';

  @override
  String get friendAllSection => 'Wszyscy Znajomi';

  @override
  String get friendsEmptyState =>
      'Brak znajomych. Dodaj swojego pierwszego znajomego!';

  @override
  String get friendsEmptyShort => 'Brak znajomych.';

  @override
  String noMatchForQuery(Object query) {
    return 'Brak wyników dla \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'Skrzynka Odbiorcza';

  @override
  String get searchChatsHint => 'Szukaj czatów...';

  @override
  String get inboxEmptyState => 'Brak czatów. Rozpocznij czat ze znajomym!';

  @override
  String get newMessageTitle => 'Nowa Wiadomość';

  @override
  String get chatCallLater =>
      'Rozmowy głosowe później (języki Circle już wkrótce)';

  @override
  String errorWithDetails(Object error) {
    return 'Błąd: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Przywitaj się z $name!';
  }

  @override
  String get chatMessageHint => 'Wiadomość...';

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsTabAll => 'Wszystkie';

  @override
  String get notificationsTabCourses => 'Kursy';

  @override
  String get notificationsTabSocial => 'Społeczność';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'System';

  @override
  String get notificationsEmpty => 'Brak powiadomień.';

  @override
  String get notificationsDeleted => 'Usunięto powiadomienie';

  @override
  String get notificationTitleFallback => 'Powiadomienie';

  @override
  String get notificationTypeCourse => 'Kurs';

  @override
  String get notificationTypeSocial => 'Społeczność';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'System';

  @override
  String get notificationsFriendAccepted =>
      'Zaakceptowano prośbę o dodanie do znajomych';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Nie udało się zaakceptować prośby: $error';
  }

  @override
  String get notificationsFriendDeclined =>
      'Odrzucono prośbę o dodanie do znajomych';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Nie udało się odrzucić prośby: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Nie udało się dołączyć do Circle: $error';
  }

  @override
  String get notificationsOpening => 'Otwieranie';

  @override
  String get notificationsOpened => 'Otwarto';

  @override
  String notificationsActionMessage(Object action) {
    return '$action powiadomienie';
  }

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsEditProfile => 'Edytuj Profil';

  @override
  String get settingsPrivacy => 'Prywatność';

  @override
  String get settingsSecurity => 'Bezpieczeństwo';

  @override
  String get settingsSectionGameplay => 'Rozgrywka';

  @override
  String get settingsShowTranslationLine => 'Pokaż linię tłumaczenia';

  @override
  String get settingsShowReadingLine => 'Pokaż czytanie (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion =>
      'Domyślny licznik czasu na pytanie';

  @override
  String get settingsMatchDifficulty => 'Trudność Meczu';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptacyjna';

  @override
  String get settingsSectionSoundFeel => 'Dźwięk i Odczucia';

  @override
  String get settingsMusic => 'Muzyka';

  @override
  String get settingsSoundEffects => 'Efekty Dźwiękowe';

  @override
  String get settingsHaptics => 'Wibracje Dotykowe';

  @override
  String get settingsSectionNotifications => 'Powiadomienia';

  @override
  String get settingsPushNotifications => 'Powiadomienia Push';

  @override
  String get settingsDailyReminder => 'Codzienne Przypomnienie';

  @override
  String get settingsSectionAppearance => 'Wygląd';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsUiLanguage => 'Język Interfejsu';

  @override
  String get settingsSectionAbout => 'O Aplikacji';

  @override
  String get settingsVersion => 'Wersja';

  @override
  String get settingsTermsPrivacy => 'Warunki i Prywatność';

  @override
  String get settingsSupport => 'Pomoc';

  @override
  String get settingsLogout => 'Wyloguj';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

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
  String get editProfileUpdated => 'Zaktualizowano profil';

  @override
  String get editProfileTitle => 'Edytuj Profil';

  @override
  String get editProfilePhotoLabel => 'Zdjęcie Profilowe';

  @override
  String get editProfilePhotoSubtitle =>
      'Wybór awatara przez Supabase Storage wkrótce dostępny.';

  @override
  String get editProfileChangePhoto => 'Zmień';

  @override
  String get editProfileAvatarUploadSoon =>
      'Przesyłanie awatara wkrótce dostępne';

  @override
  String get editProfileDisplayNameLabel => 'Nazwa Wyświetlana';

  @override
  String get editProfileDisplayNameHint => 'Twoje Imię';

  @override
  String get editProfileDisplayNameRequired => 'Wprowadź nazwę';

  @override
  String get editProfileDisplayNameTooShort => 'Za krótkie';

  @override
  String get editProfileUsernameLabel => 'Nazwa Użytkownika';

  @override
  String get editProfileUsernameHint => 'jan_uczen';

  @override
  String get editProfileUsernameRequired => 'Wprowadź nazwę użytkownika';

  @override
  String get editProfileUsernameTooShort => 'Minimum 3 znaki';

  @override
  String get editProfileUsernameInvalid => 'Tylko litery, cyfry, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Krótkie bio...';

  @override
  String get editProfileBioTooLong => 'Maksymalnie 120 znaków';

  @override
  String get editProfileLocationLabel => 'Lokalizacja';

  @override
  String get editProfileLocationHint => 'Miasto / Kraj';

  @override
  String get editProfileDailyGoalTitle => 'Dzienny Cel';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Wybierz, ile minut chcesz uczyć się każdego dnia.';

  @override
  String get securityTitle => 'Bezpieczeństwo';

  @override
  String get securitySectionPassword => 'Hasło';

  @override
  String get securityChangePasswordTitle => 'Zmień Hasło';

  @override
  String get securityChangePasswordSubtitle =>
      'Regularnie aktualizuj swoje hasło.';

  @override
  String get securitySectionTwoFactor => 'Uwierzytelnianie Dwuskładnikowe';

  @override
  String get securityEnable2faTitle => 'Włącz 2FA';

  @override
  String get securityEnable2faSubtitle =>
      'Dodatkowe bezpieczeństwo przy logowaniu.';

  @override
  String get securitySectionAppLock => 'Blokada Aplikacji';

  @override
  String get securityBiometricTitle => 'Odblokowanie Biometryczne';

  @override
  String get securityBiometricSubtitle =>
      'Użyj FaceID/TouchID, aby odblokować SOMA.';

  @override
  String get securityAppLockTitle => 'Blokada Aplikacji';

  @override
  String get securityAppLockSubtitle => 'Zablokuj SOMA przy wyjściu.';

  @override
  String get securitySectionSessions => 'Aktywne Sesje';

  @override
  String get securityNoSessions => 'Nie znaleziono aktywnych sesji.';

  @override
  String get securityThisDevice => 'To Urządzenie';

  @override
  String get securityDevice => 'Urządzenie';

  @override
  String get securityActiveLabel => 'Aktywne';

  @override
  String get securitySignInToEnable2fa => 'Zaloguj się, aby włączyć 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Nie udało się włączyć 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Nie udało się wyłączyć 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Ustawienia 2FA';

  @override
  String get securitySecretKeyLabel => 'Tajny Klucz';

  @override
  String get securityCodeHint => 'Kod 6-cyfrowy';

  @override
  String get security2faEnabled => 'Włączono 2FA';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Nie udało się zweryfikować kodu: $error';
  }

  @override
  String get securityVerifying => 'Weryfikacja...';

  @override
  String get securityVerify => 'Weryfikuj';

  @override
  String get securityCurrentPasswordHint => 'Aktualne hasło';

  @override
  String get securityNewPasswordHint => 'Nowe hasło (min. 8 znaków)';

  @override
  String get securityConfirmPasswordHint => 'Potwierdź nowe hasło';

  @override
  String get securitySignInToChangePassword => 'Zaloguj się, aby zmienić hasło';

  @override
  String get securityEnterCurrentPassword => 'Wprowadź aktualne hasło';

  @override
  String get securityPasswordMinLength =>
      'Nowe hasło musi mieć co najmniej 8 znaków';

  @override
  String get securityPasswordsDoNotMatch => 'Hasła nie pasują';

  @override
  String get securityPasswordUpdated => 'Zaktualizowano hasło';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Nie udało się zaktualizować hasła: $error';
  }

  @override
  String get securityAutoLockAfter => 'Automatyczna blokada po';

  @override
  String get privacyTitle => 'Prywatność';

  @override
  String get privacySectionVisibility => 'Widoczność';

  @override
  String get privacyProfileVisibilityTitle => 'Widoczność Profilu';

  @override
  String get privacyVisibilityPublic => 'Publiczny';

  @override
  String get privacyVisibilityFriends => 'Znajomi';

  @override
  String get privacyVisibilityPrivate => 'Prywatny';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Każdy może zobaczyć Twój profil.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Tylko znajomi mogą zobaczyć Twój profil.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Tylko Ty możesz zobaczyć Twój profil.';

  @override
  String get privacySectionActivity => 'Aktywność';

  @override
  String get privacyShowOnlineTitle => 'Pokaż Status Online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Pozwól innym wiedzieć, że jesteś online.';

  @override
  String get privacyShowActivityTitle => 'Pokaż Aktywność Nauki';

  @override
  String get privacyShowActivitySubtitle =>
      'Pokaż serię, XP i bieżące postępy.';

  @override
  String get privacySectionSocial => 'Społeczność';

  @override
  String get privacyAllowRequestsTitle =>
      'Zezwól na Prośby o Dodanie do Znajomych';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Pozwól innym wysyłać prośby o dodanie do znajomych.';

  @override
  String get privacyWhoCanDmTitle => 'Kto Może Wysyłać DM';

  @override
  String get privacyDmEveryone => 'Wszyscy';

  @override
  String get privacyDmFriends => 'Znajomi';

  @override
  String get privacyDmNoOne => 'Nikt';

  @override
  String get privacyDmEveryoneSubtitle => 'Każdy może wysłać Ci DM.';

  @override
  String get privacyDmFriendsSubtitle => 'Tylko znajomi mogą wysłać Ci DM.';

  @override
  String get privacyDmNoOneSubtitle => 'Nikt nie może wysłać Ci DM.';

  @override
  String get privacySectionBlockedUsers => 'Zablokowani Użytkownicy';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Zarządzanie zablokowanymi użytkownikami wkrótce dostępne.';

  @override
  String get privacySectionDataControls => 'Kontrola Danych';

  @override
  String get privacyExportDataTitle => 'Eksportuj Dane';

  @override
  String get privacyExportDataSubtitle => 'Pobierz swoją aktywność i kursy.';

  @override
  String get privacyExportInfoTitle => 'Eksportuj Dane';

  @override
  String get privacyExportInfoBody =>
      'Następne kroki: Utwórz eksport JSON/CSV i wyślij e-mailem lub pobierz lokalnie.';

  @override
  String get privacyDeleteAccountTitle => 'Usuń Konto';

  @override
  String get privacyDeleteAccountSubtitle =>
      'To trwale usunie Twoje konto i dane.';

  @override
  String get privacyDeleteConfirmTitle => 'Usunąć Konto?';

  @override
  String get privacyDeleteConfirmBody =>
      'Ta akcja jest trwała. Twój profil, kursy, znajomi i wiadomości zostaną usunięte.';

  @override
  String get privacyDeleteComingSoon =>
      'Usuwanie zostanie połączone z Supabase później';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Ukończono Sesję Solo';

  @override
  String get soloResultsFeedbackElite =>
      'Elitarne osiągnięcie. Utrzymuj serię.';

  @override
  String get soloResultsFeedbackStrong => 'Mocne. Szybko się rozwijasz.';

  @override
  String get soloResultsFeedbackProgress =>
      'Dobry postęp. Przejrzyj błędy i powtórz.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Bez stresu. Spróbuj ponownie z mniejszą liczbą pytań i skup się.';

  @override
  String get soloResultsPerfectScore =>
      'Idealny wynik! Brak błędów do przejrzenia.';

  @override
  String get soloResultsReviewPrompt =>
      'Przejrzyj błędy, aby uczyć się szybciej. Twoje błędne odpowiedzi są poniżej.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Przejrzyj Błędy ($count)';
  }

  @override
  String get authNotSignedIn => 'Nie zalogowany';

  @override
  String get genericUser => 'Użytkownik';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get edit => 'Edytuj';

  @override
  String get send => 'Wyślij';

  @override
  String get join => 'Dołącz';

  @override
  String get leave => 'Opuść';

  @override
  String get ready => 'Gotowy';

  @override
  String get levelBeginner => 'Początkujący';

  @override
  String get levelIntermediate => 'Średnio zaawansowany';

  @override
  String get levelAdvanced => 'Zaawansowany';

  @override
  String questionsShort(Object count) {
    return '$count pyt.';
  }

  @override
  String secondsShort(Object count) {
    return '$count sek';
  }

  @override
  String get circlesAllCourses => 'Wszystkie Kursy';

  @override
  String get circlesAllModes => 'Wszystkie Tryby';

  @override
  String get circlesAllLevels => 'Wszystkie Poziomy';

  @override
  String get circlesAddNewCourse => 'Dodaj Nowy Kurs';

  @override
  String get circlesCoursesTitle => 'Kursy';

  @override
  String get circlesModeTitle => 'Tryb';

  @override
  String get circlesLevelTitle => 'Poziom';

  @override
  String get circlesNoActiveForFilters =>
      'Brak aktywnych Circles dla tych filtrów.';

  @override
  String get circlesUnknownRoom => 'Nieznany Pokój';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Utwórz Circle';

  @override
  String get circlesCircleName => 'Nazwa Circle';

  @override
  String get circlesEnterName => 'Wprowadź nazwę';

  @override
  String get circlesLanguages => 'Języki';

  @override
  String get circlesRoomSetup => 'Ustawienia Pokoju';

  @override
  String get circlesPlayers => 'Gracze';

  @override
  String get circlesEmptySlot => 'Wolne Miejsce';

  @override
  String get circlesPlayersRange => '1-5 graczy';

  @override
  String get circlesQuestions => 'Pytania';

  @override
  String get circlesQuestionsSubtitle => 'Liczba pytań';

  @override
  String get circlesTimePerQuestion => 'Czas na Pytanie';

  @override
  String get circlesSecondsPerQuestion => 'Sekund na pytanie';

  @override
  String get circlesAdvanced => 'Zaawansowane';

  @override
  String get circlesAllowSpectators => 'Zezwól na Widzów';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Pozwól innym oglądać bez grania.';

  @override
  String get circlesLiveVoiceChat => 'Czat Głosowy na Żywo';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Włącz głos na żywo podczas meczy.';

  @override
  String get circlesLiveTextChat => 'Czat Tekstowy na Żywo';

  @override
  String get circlesLiveTextChatSubtitle => 'Włącz czat podczas meczy.';

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
  String get circlesCreatedSuccess => 'Utworzono Circle';

  @override
  String circlesCreateError(Object error) {
    return 'Nie udało się utworzyć Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Wskazówka: Możesz zaprosić znajomych po utworzeniu.';

  @override
  String circlesJoinError(Object error) {
    return 'Nie udało się dołączyć do Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Poczekalnia Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kod: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Ustawienia Meczu';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Poziom $level';
  }

  @override
  String get circlesDifficulty => 'Trudność';

  @override
  String get circlesPerQuestionShort => 'na pyt.';

  @override
  String get circlesInvite => 'Zaproś';

  @override
  String get circlesCopyId => 'Kopiuj ID';

  @override
  String get circlesCopiedId => 'Skopiowano ID';

  @override
  String get circlesMatchInProgress => 'Mecz w Toku';

  @override
  String get circlesSpectatorQueuedBody => 'Mecz w toku. Dołączanie jako widz.';

  @override
  String get circlesHostStartWhenReady =>
      'Host zaczyna, gdy wszyscy są gotowi.';

  @override
  String get circlesSpectators => 'Widzowie';

  @override
  String get circlesSpectator => 'Widz';

  @override
  String get circlesSpectatorCanWatch => 'Widzowie mogą oglądać na żywo.';

  @override
  String get circlesJoinRequests => 'Prośby o Dołączenie';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Zaakceptuj widzów przed rozpoczęciem meczu.';

  @override
  String get circlesStartGame => 'Rozpocznij Grę';

  @override
  String get circlesWaitingForPlayers => 'Czekanie na Graczy';

  @override
  String get circlesLeaveCircle => 'Opuść Circle';

  @override
  String get circlesRequestSent => 'Wysłano prośbę';

  @override
  String get circlesRequestToJoin => 'Poproś o Dołączenie';

  @override
  String get circlesWatchLive => 'Oglądaj na Żywo';

  @override
  String get circlesPlayerTip =>
      'Dotknij gotowy, gdy jesteś gotowy. Host rozpocznie mecz.';

  @override
  String get circlesSpectatorTip =>
      'Oglądasz. Oglądaj na żywo, gdy host zacznie.';

  @override
  String get circlesHostControls => 'Kontrola Hosta';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Nie udało się przenieść hosta: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Nie udało się zakończyć Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Nie znaleziono @$username';
  }

  @override
  String get circlesInvalidUser => 'Nieprawidłowy użytkownik';

  @override
  String get circlesCantInviteSelf => 'Nie możesz zaprosić siebie';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username jest już w Circle';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Zaproś po nazwie użytkownika';

  @override
  String circlesInviteSent(Object username) {
    return 'Wysłano zaproszenie do @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Nie udało się wysłać zaproszenia: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Wysłano prośbę o dołączenie';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Prośba nie powiodła się: $error';
  }

  @override
  String get circlesFull => 'Circle pełny';

  @override
  String get circlesSpectatorAdded => 'Dodano widza';

  @override
  String circlesApproveFailed(Object error) {
    return 'Nie udało się zaakceptować: $error';
  }

  @override
  String get circlesRequestDeclined => 'Odrzucono prośbę';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Nie udało się odrzucić prośby: $error';
  }

  @override
  String get circlesParticipant => 'Uczestnik';

  @override
  String get circlesLeavePromptTitle => 'Opuścić Circle?';

  @override
  String get circlesLeavePromptTransfer => 'Przenieś hosta przed opuszczeniem.';

  @override
  String get circlesLeavePromptEndOnly => 'Zakończ Circle i opuść.';

  @override
  String get circlesTransferHost => 'Przenieś Hosta';

  @override
  String get circlesEndCircle => 'Zakończ Circle';

  @override
  String get circlesTransferHostTitle => 'Przenieś Hosta';

  @override
  String circlesShareId(Object id) {
    return 'ID Circle: $id';
  }
}
