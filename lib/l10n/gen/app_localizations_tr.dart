// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Öğren, Yarış, Fethet';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Kaydol';

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get skipForNow => 'Şimdilik Geç';

  @override
  String get authFillAllFields => 'Lütfen tüm alanları doldurun';

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
    return 'Hata: $error';
  }

  @override
  String get authEmail => 'E-posta';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authUsername => 'Kullanıcı Adı';

  @override
  String get authContinue => 'Devam Et';

  @override
  String get authSigningIn => 'Giriş yapılıyor...';

  @override
  String get authCreateAccount => 'Hesap Oluştur';

  @override
  String get authCreating => 'Oluşturuluyor...';

  @override
  String get authNeedAccount => 'Hesabınız yok mu? ';

  @override
  String get authHaveAccount => 'Zaten hesabınız var mı? ';

  @override
  String get dialogAuthRequiredTitle => 'Circles\'a Erişmek İçin Giriş Yapın';

  @override
  String get dialogAuthRequiredBody =>
      'Circles çok oyunculu bir alandır. Canlı yarışmalara katılmak, arkadaş davet etmek ve ilerlemenizi kaydetmek için bir hesap oluşturun.';

  @override
  String get notNow => 'Şimdi Değil';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profil';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'Kurs Kaldırılsın mı?';

  @override
  String removeCourseBody(Object course) {
    return '$course ana sayfa listenizden kaldırılıyor';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get remove => 'Kaldır';

  @override
  String welcomeBack(Object name) {
    return 'Tekrar hoş geldin $name!';
  }

  @override
  String get editCourses => 'Kursları Düzenle';

  @override
  String get done => 'Tamam';

  @override
  String get noCoursesToEdit => 'Düzenlenecek kurs yok';

  @override
  String get addCourse => 'Kurs Ekle';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get iSpeak => 'Ben konuşuyorum';

  @override
  String get iWantToLearn => 'Öğrenmek istiyorum';

  @override
  String get chooseYourLanguage => 'Dilinizi seçin';

  @override
  String get chooseLearningLanguage => 'Öğrenmek istediğiniz dili seçin';

  @override
  String get chooseTwoDifferentLanguages => 'Lütfen iki farklı dil seçin';

  @override
  String get createCourse => 'Kurs Oluştur';

  @override
  String get soloCourseTitle => 'Solo Kurs';

  @override
  String get searchLanguage => 'Dil ara';

  @override
  String get noMatches => 'Eşleşme bulunamadı';

  @override
  String get chooseCourseType => 'Kurs Türünü Seçin';

  @override
  String get soloStudyDescription =>
      'Circles tarzı testlerle kendi başınıza çalışın - oda, sohbet, izleyici veya host seçeneği yok';

  @override
  String get soloModeVocabulary => 'Kelime Bilgisi';

  @override
  String get soloModeSentences => 'Cümleler';

  @override
  String get soloModeReview => 'Gözden Geçir';

  @override
  String get soloModeVocabularySubtitle =>
      'Çoktan seçmeli, anlamlar, eş anlamlılar, kullanım';

  @override
  String get soloModeSentencesSubtitle => 'Boşluk doldurma + çeviri + okuma';

  @override
  String get soloModeReviewDescription =>
      'Öğrendiklerinizi pratik edin: unutulan kelimeler, son hatalar, aralıklı tekrar';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'Gözden Geçirmeyi Başlat';

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
    return '$mode Kurulumu';
  }

  @override
  String get difficulty => 'Zorluk';

  @override
  String get numberOfQuestions => 'Soru Sayısı';

  @override
  String get timerPerQuestion => 'Soru Başına Zamanlayıcı';

  @override
  String get noTimer => 'Zamanlayıcı Yok';

  @override
  String get start => 'Başla';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSignInToMessage => 'Mesaj göndermek için giriş yapın';

  @override
  String get profileThatsYourProfile => 'Bu senin profilin';

  @override
  String get profileSignInToAddFriends => 'Arkadaş eklemek için giriş yapın';

  @override
  String get profileCantAddYourself => 'Kendinizi ekleyemezsiniz';

  @override
  String profileRequestSent(Object username) {
    return '@$username kullanıcısına istek gönderildi';
  }

  @override
  String get profileRequestFailed => 'İstek gönderilemedi';

  @override
  String get profileDefaultDisplayName => 'Yeni Kullanıcı';

  @override
  String get profileDefaultBio => 'Öğrenmeye hazır!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Misafir';

  @override
  String get guestUsername => 'misafir';

  @override
  String get guestSessionLabel => 'Misafir Oturumu';

  @override
  String get unlockFullProfile => 'Tam Profili Aç';

  @override
  String get guestBenefitSync => 'İlerlemenizi tüm cihazlarda senkronize edin';

  @override
  String get guestBenefitCircles => 'Canlı oynamak için Circles\'a katılın';

  @override
  String get guestBenefitNotifications =>
      'Bildirimler ve arkadaşlık istekleri alın';

  @override
  String get progressStaysOnDevice =>
      'Giriş yapana kadar ilerlemeniz bu cihazda kalır';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Hedef: $minutes dakika';
  }

  @override
  String get profileXpProgress => 'XP İlerlemesi';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Galibiyet';

  @override
  String get profileStreak => 'Seri';

  @override
  String get profileFriendsTitle => 'Arkadaşlar';

  @override
  String get profileViewAll => 'Tümünü Gör';

  @override
  String get profileAchievementsTitle => 'Başarılar';

  @override
  String get profileNoAchievements => 'Henüz başarı yok';

  @override
  String get profileRequested => 'İstek Gönderildi';

  @override
  String get profileSending => 'Gönderiliyor...';

  @override
  String get profileAddFriend => 'Arkadaş Ekle';

  @override
  String get profileConnectTitle => 'Bağlan';

  @override
  String get profileMessage => 'Mesaj';

  @override
  String get profileSnapshot => 'Profil Görüntüsü';

  @override
  String get profileLocationHidden => 'Konum gizli';

  @override
  String get profileBioHidden => 'Biyografi gizli';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Günlük $minutes dakika hedef';
  }

  @override
  String get circleInviteTitle => 'Circle Daveti';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => 'Katılmak için giriş yapın';

  @override
  String get joiningCircle => 'Katılınıyor...';

  @override
  String get joinCircle => 'Circle\'a Katıl';

  @override
  String get circleJoinedAsPlayer => 'Oyuncu olarak katıldınız';

  @override
  String get circleJoinedAsSpectator => 'İzleyici olarak katıldınız';

  @override
  String get accept => 'Kabul Et';

  @override
  String get decline => 'Reddet';

  @override
  String get open => 'Aç';

  @override
  String get circleCountdownTitle => 'Hazırlanın';

  @override
  String get circleCountdownSubtitle => 'Circle başlıyor...';

  @override
  String get userFallbackName => 'Kullanıcı';

  @override
  String get micOff => 'Mikrofon Kapalı';

  @override
  String get micOn => 'Mikrofon Açık';

  @override
  String get roleHost => 'Host';

  @override
  String get roleSpectator => 'İzleyici';

  @override
  String get tagHost => 'Host';

  @override
  String get tagYou => 'Sen';

  @override
  String get statusCorrect => 'Doğru';

  @override
  String get statusWrong => 'Yanlış';

  @override
  String get statusWaiting => 'Bekliyor';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'puan';

  @override
  String get pointsLabel => 'Puan';

  @override
  String get statCorrect => 'Doğru';

  @override
  String get statAnswers => 'Cevaplar';

  @override
  String get statTotal => 'Toplam';

  @override
  String get statQuestions => 'Sorular';

  @override
  String get statAccuracy => 'Doğruluk';

  @override
  String get statRate => 'Oran';

  @override
  String get statRank => 'Sıra';

  @override
  String get statPosition => 'Konum';

  @override
  String get statMode => 'Mod';

  @override
  String get statType => 'Tür';

  @override
  String get next => 'İleri';

  @override
  String get submit => 'Gönder';

  @override
  String get continueLabel => 'Devam Et';

  @override
  String get save => 'Kaydet';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get backToCourse => 'Kursa Dön';

  @override
  String get resultsTitle => 'Sonuçlar';

  @override
  String get shareLater => 'Sonra Paylaş';

  @override
  String get delete => 'Sil';

  @override
  String get ok => 'Tamam';

  @override
  String minutesShort(Object minutes) {
    return '$minutes dk';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count dk';
  }

  @override
  String timeShortHours(Object count) {
    return '$count sa';
  }

  @override
  String timeShortDays(Object count) {
    return '$count gün';
  }

  @override
  String get timeJustNow => 'Az önce';

  @override
  String timeMinutesAgo(Object count) {
    return '$count dakika önce';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count saat önce';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count gün önce';
  }

  @override
  String get liveQuizWaitingForHost => 'Host bekleniyor...';

  @override
  String get liveQuizJoinRequestSent => 'Katılma isteği gönderildi';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'İstek başarısız: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Host Kontrolleri';

  @override
  String get liveQuizSpectatorModeTitle => 'İzleyici Modu';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Turlar herkes cevap verdiğinde veya süre dolduğunda otomatik ilerler';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Soruları ve puan tablosunu canlı izleyin. Cevap veremezsiniz';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Soru $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'İstek gönderildi';

  @override
  String get liveQuizRequestToJoin => 'Katılmak İçin İstek';

  @override
  String get liveQuizSpectatorFooter =>
      'Canlı izliyorsunuz. Soruların ve puan tablosunun keyfini çıkarın';

  @override
  String get circleNotFound => 'Circle bulunamadı';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Rövanş başlatılamadı: $error';
  }

  @override
  String get resultsMatchTitle => 'Maç Sonuçları';

  @override
  String resultsNiceWork(Object name) {
    return 'İyi iş $name';
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
    return '$players oyuncudan';
  }

  @override
  String get resultsHighlightChampion => 'Şampiyon! Bu Circle\'ı fethettiniz';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Harika doğruluk - zirveye çok yakınsınız!';

  @override
  String get resultsHighlightKeepGoing => 'Devam edin - tutarlılık hızı yener';

  @override
  String get resultsLeaderboardTitle => 'Lider Tablosu';

  @override
  String resultsPlayersCount(Object count) {
    return '$count oyuncu';
  }

  @override
  String get resultsBackToCircles => 'Circles\'a Dön';

  @override
  String get resultsRematch => 'Rövanş';

  @override
  String get resultsPlayAgain => 'Tekrar Oyna';

  @override
  String get leaderboardGlobalTitle => 'Küresel Lider Tablosu';

  @override
  String get leaderboardEmpty => 'Henüz lider tablosu yok';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String aboutVersion(Object version) {
    return 'Sürüm $version';
  }

  @override
  String get aboutDescription =>
      'SOMA, yeni bir dil öğrenmeyi eğlenceli ve sosyal hale getiren oyunlaştırılmış bir dil öğrenme platformudur. Circles\'a katılın, solo pratik yapın ve ilerlemenizi takip edin.';

  @override
  String get aboutTerms => 'Hizmet Şartları';

  @override
  String get aboutPrivacy => 'Gizlilik Politikası';

  @override
  String get aboutOpenSource => 'Açık Kaynak Lisansları';

  @override
  String get addFriendTitle => 'Arkadaş Ekle';

  @override
  String get addFriendFindByUsername => 'Kullanıcı adına göre bul';

  @override
  String get addFriendUsernameHint => 'Kullanıcı adı girin...';

  @override
  String get addFriendTip =>
      'İpucu: QR kodu + arkadaş kodu desteği yakında eklenecek';

  @override
  String get addFriendSending => 'Gönderiliyor...';

  @override
  String get addFriendSendRequest => 'İstek Gönder';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username bulunamadı';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'İşlem başarısız veya zaten gönderildi: $error';
  }

  @override
  String get friendsTitle => 'Arkadaşlar';

  @override
  String get searchFriendsHint => 'Arkadaş ara...';

  @override
  String get somaLearnerSubtitle => 'Soma Öğrencisi';

  @override
  String get friendRequestLabel => 'İstek';

  @override
  String get friendRequestSentLabel => 'İstek Gönderildi';

  @override
  String get friendIncomingRequestLabel => 'Gelen İstek';

  @override
  String get friendRequestsSection => 'İstekler';

  @override
  String get friendPendingSection => 'Bekleyen';

  @override
  String get friendAllSection => 'Tüm Arkadaşlar';

  @override
  String get friendsEmptyState =>
      'Henüz arkadaş yok. İlk arkadaşınızı ekleyin!';

  @override
  String get friendsEmptyShort => 'Henüz arkadaş yok';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\" için sonuç bulunamadı';
  }

  @override
  String get inboxTitle => 'Gelen Kutusu';

  @override
  String get searchChatsHint => 'Sohbetlerde ara...';

  @override
  String get inboxEmptyState =>
      'Henüz sohbet yok. Arkadaşlarınızla sohbet başlatın!';

  @override
  String get newMessageTitle => 'Yeni Mesaj';

  @override
  String get chatCallLater => 'Daha sonra sesli arama (Circle dili yakında)';

  @override
  String errorWithDetails(Object error) {
    return 'Hata: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name ile merhaba de!';
  }

  @override
  String get chatMessageHint => 'Mesaj...';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notificationsTabAll => 'Tümü';

  @override
  String get notificationsTabCourses => 'Kurslar';

  @override
  String get notificationsTabSocial => 'Sosyal';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Sistem';

  @override
  String get notificationsEmpty => 'Bildirim yok';

  @override
  String get notificationsDeleted => 'Bildirim silindi';

  @override
  String get notificationTitleFallback => 'Bildirim';

  @override
  String get notificationTypeCourse => 'Kurs';

  @override
  String get notificationTypeSocial => 'Sosyal';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Sistem';

  @override
  String get notificationsFriendAccepted => 'Arkadaşlık isteği kabul edildi';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'İstek kabul edilemedi: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Arkadaşlık isteği reddedildi';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'İstek reddedilemedi: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle\'a katılınamadı: $error';
  }

  @override
  String get notificationsOpening => 'Açılıyor';

  @override
  String get notificationsOpened => 'Açıldı';

  @override
  String notificationsActionMessage(Object action) {
    return 'Bildirimi $action';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionAccount => 'Hesap';

  @override
  String get settingsEditProfile => 'Profili Düzenle';

  @override
  String get settingsPrivacy => 'Gizlilik';

  @override
  String get settingsSecurity => 'Güvenlik';

  @override
  String get settingsSectionGameplay => 'Oynanış';

  @override
  String get settingsShowTranslationLine => 'Çeviri Satırını Göster';

  @override
  String get settingsShowReadingLine => 'Okumayı Göster (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion =>
      'Varsayılan Soru Başına Zamanlayıcı';

  @override
  String get settingsMatchDifficulty => 'Maç Zorluğu';

  @override
  String get settingsMatchDifficultyAdaptive => 'Uyarlanabilir';

  @override
  String get settingsSectionSoundFeel => 'Ses ve His';

  @override
  String get settingsMusic => 'Müzik';

  @override
  String get settingsSoundEffects => 'Ses Efektleri';

  @override
  String get settingsHaptics => 'Titreşimler';

  @override
  String get settingsSectionNotifications => 'Bildirimler';

  @override
  String get settingsPushNotifications => 'Anlık Bildirimler';

  @override
  String get settingsDailyReminder => 'Günlük Hatırlatma';

  @override
  String get settingsSectionAppearance => 'Görünüm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Arayüz Dili';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsTermsPrivacy => 'Şartlar ve Gizlilik';

  @override
  String get settingsSupport => 'Destek';

  @override
  String get settingsLogout => 'Çıkış Yap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

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
  String get editProfileUpdated => 'Profil güncellendi';

  @override
  String get editProfileTitle => 'Profili Düzenle';

  @override
  String get editProfilePhotoLabel => 'Profil Fotoğrafı';

  @override
  String get editProfilePhotoSubtitle =>
      'Supabase Storage üzerinden avatar seçimi yakında';

  @override
  String get editProfileChangePhoto => 'Değiştir';

  @override
  String get editProfileAvatarUploadSoon => 'Avatar yükleme yakında';

  @override
  String get editProfileDisplayNameLabel => 'Görünen Ad';

  @override
  String get editProfileDisplayNameHint => 'Adınız';

  @override
  String get editProfileDisplayNameRequired => 'Lütfen bir ad girin';

  @override
  String get editProfileDisplayNameTooShort => 'Çok kısa';

  @override
  String get editProfileUsernameLabel => 'Kullanıcı Adı';

  @override
  String get editProfileUsernameHint => 'ahmet_ogrenci';

  @override
  String get editProfileUsernameRequired => 'Lütfen bir kullanıcı adı girin';

  @override
  String get editProfileUsernameTooShort => 'En az 3 karakter';

  @override
  String get editProfileUsernameInvalid => 'Sadece harf, rakam, _';

  @override
  String get editProfileBioLabel => 'Biyografi';

  @override
  String get editProfileBioHint => 'Kısa bir biyografi...';

  @override
  String get editProfileBioTooLong => 'Maksimum 120 karakter';

  @override
  String get editProfileLocationLabel => 'Konum';

  @override
  String get editProfileLocationHint => 'Şehir / Ülke';

  @override
  String get editProfileDailyGoalTitle => 'Günlük Hedef';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Her gün çalışmak istediğiniz dakika sayısını seçin';

  @override
  String get securityTitle => 'Güvenlik';

  @override
  String get securitySectionPassword => 'Şifre';

  @override
  String get securityChangePasswordTitle => 'Şifre Değiştir';

  @override
  String get securityChangePasswordSubtitle =>
      'Şifrenizi düzenli olarak güncelleyin';

  @override
  String get securitySectionTwoFactor => 'İki Faktörlü Kimlik Doğrulama';

  @override
  String get securityEnable2faTitle => '2FA\'yı Etkinleştir';

  @override
  String get securityEnable2faSubtitle => 'Giriş yaparken ekstra güvenlik';

  @override
  String get securitySectionAppLock => 'Uygulama Kilidi';

  @override
  String get securityBiometricTitle => 'Biyometrik ile Kilidi Aç';

  @override
  String get securityBiometricSubtitle =>
      'SOMA\'nın kilidini açmak için FaceID/TouchID kullanın';

  @override
  String get securityAppLockTitle => 'Uygulamayı Kilitle';

  @override
  String get securityAppLockSubtitle => 'Çıkıldığında SOMA\'yı kilitle';

  @override
  String get securitySectionSessions => 'Aktif Oturumlar';

  @override
  String get securityNoSessions => 'Aktif oturum bulunamadı';

  @override
  String get securityThisDevice => 'Bu Cihaz';

  @override
  String get securityDevice => 'Cihaz';

  @override
  String get securityActiveLabel => 'Aktif';

  @override
  String get securitySignInToEnable2fa =>
      '2FA\'yı etkinleştirmek için giriş yapın';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA etkinleştirilemedi: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA devre dışı bırakılamadı: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA Kurulumu';

  @override
  String get securitySecretKeyLabel => 'Gizli Anahtar';

  @override
  String get securityCodeHint => '6 haneli kod';

  @override
  String get security2faEnabled => '2FA etkinleştirildi';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Kod doğrulanamadı: $error';
  }

  @override
  String get securityVerifying => 'Doğrulanıyor...';

  @override
  String get securityVerify => 'Doğrula';

  @override
  String get securityCurrentPasswordHint => 'Mevcut şifre';

  @override
  String get securityNewPasswordHint => 'Yeni şifre (en az 8 karakter)';

  @override
  String get securityConfirmPasswordHint => 'Yeni şifreyi onayla';

  @override
  String get securitySignInToChangePassword =>
      'Şifre değiştirmek için giriş yapın';

  @override
  String get securityEnterCurrentPassword => 'Lütfen mevcut şifrenizi girin';

  @override
  String get securityPasswordMinLength => 'Yeni şifre en az 8 karakter olmalı';

  @override
  String get securityPasswordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get securityPasswordUpdated => 'Şifre güncellendi';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Şifre güncellenemedi: $error';
  }

  @override
  String get securityAutoLockAfter => 'Şu süre sonra otomatik kilitle';

  @override
  String get privacyTitle => 'Gizlilik';

  @override
  String get privacySectionVisibility => 'Görünürlük';

  @override
  String get privacyProfileVisibilityTitle => 'Profil Görünürlüğü';

  @override
  String get privacyVisibilityPublic => 'Herkese Açık';

  @override
  String get privacyVisibilityFriends => 'Arkadaşlar';

  @override
  String get privacyVisibilityPrivate => 'Özel';

  @override
  String get privacyVisibilityPublicSubtitle => 'Herkes profilinizi görebilir';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Sadece arkadaşlarınız profilinizi görebilir';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Sadece siz profilinizi görebilirsiniz';

  @override
  String get privacySectionActivity => 'Aktivite';

  @override
  String get privacyShowOnlineTitle => 'Çevrimiçi Durumunu Göster';

  @override
  String get privacyShowOnlineSubtitle =>
      'Başkalarının çevrimiçi olduğunuzu görmesine izin ver';

  @override
  String get privacyShowActivityTitle => 'Öğrenme Aktivitesini Göster';

  @override
  String get privacyShowActivitySubtitle =>
      'Seri, XP ve mevcut ilerleme istatistiklerini göster';

  @override
  String get privacySectionSocial => 'Sosyal';

  @override
  String get privacyAllowRequestsTitle => 'Arkadaşlık İsteklerine İzin Ver';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Başkalarının sana arkadaşlık isteği göndermesine izin ver';

  @override
  String get privacyWhoCanDmTitle => 'Kimler DM Gönderebilir';

  @override
  String get privacyDmEveryone => 'Herkes';

  @override
  String get privacyDmFriends => 'Arkadaşlar';

  @override
  String get privacyDmNoOne => 'Kimse';

  @override
  String get privacyDmEveryoneSubtitle => 'Herkes size DM gönderebilir';

  @override
  String get privacyDmFriendsSubtitle =>
      'Sadece arkadaşlarınız size DM gönderebilir';

  @override
  String get privacyDmNoOneSubtitle => 'Kimse size DM gönderemez';

  @override
  String get privacySectionBlockedUsers => 'Engellenen Kullanıcılar';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Engellenen kullanıcı yönetimi yakında';

  @override
  String get privacySectionDataControls => 'Veri Kontrolleri';

  @override
  String get privacyExportDataTitle => 'Verileri Dışa Aktar';

  @override
  String get privacyExportDataSubtitle => 'Aktivite ve kurslarınızı indirin';

  @override
  String get privacyExportInfoTitle => 'Verileri Dışa Aktar';

  @override
  String get privacyExportInfoBody =>
      'Sonraki adım: JSON/CSV dışa aktarma dosyası oluştur ve e-posta ile gönder veya yerel olarak indir';

  @override
  String get privacyDeleteAccountTitle => 'Hesabı Sil';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Bu işlem hesabınızı ve verilerinizi kalıcı olarak siler';

  @override
  String get privacyDeleteConfirmTitle => 'Hesap Silinsin mi?';

  @override
  String get privacyDeleteConfirmBody =>
      'Bu işlem geri alınamaz. Profiliniz, kurslarınız, arkadaşlarınız ve mesajlarınız silinecek';

  @override
  String get privacyDeleteComingSoon =>
      'Silme işlemi daha sonra Supabase\'e bağlanacak';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Solo Oturum Tamamlandı';

  @override
  String get soloResultsFeedbackElite => 'Elit performans - serinizi koruyun';

  @override
  String get soloResultsFeedbackStrong => 'Güçlü - hızla büyüyorsunuz';

  @override
  String get soloResultsFeedbackProgress =>
      'İyi ilerleme - hataları gözden geçirin ve tekrar deneyin';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Stres yapmayın - daha az soruyla tekrar deneyin ve odaklanın';

  @override
  String get soloResultsPerfectScore =>
      'Mükemmel puan! Gözden geçirilecek hata yok';

  @override
  String get soloResultsReviewPrompt =>
      'Daha hızlı öğrenmek için hataları gözden geçirin. Yanlış cevaplarınız aşağıda';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Hataları Gözden Geçir ($count)';
  }

  @override
  String get authNotSignedIn => 'Giriş yapılmadı';

  @override
  String get genericUser => 'Kullanıcı';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get edit => 'Düzenle';

  @override
  String get send => 'Gönder';

  @override
  String get join => 'Katıl';

  @override
  String get leave => 'Ayrıl';

  @override
  String get ready => 'Hazır';

  @override
  String get levelBeginner => 'Başlangıç';

  @override
  String get levelIntermediate => 'Orta';

  @override
  String get levelAdvanced => 'İleri';

  @override
  String questionsShort(Object count) {
    return '$count soru';
  }

  @override
  String secondsShort(Object count) {
    return '$count sn';
  }

  @override
  String get circlesAllCourses => 'Tüm Kurslar';

  @override
  String get circlesAllModes => 'Tüm Modlar';

  @override
  String get circlesAllLevels => 'Tüm Seviyeler';

  @override
  String get circlesAddNewCourse => 'Yeni Kurs Ekle';

  @override
  String get circlesCoursesTitle => 'Kurslar';

  @override
  String get circlesModeTitle => 'Mod';

  @override
  String get circlesLevelTitle => 'Seviye';

  @override
  String get circlesNoActiveForFilters => 'Bu filtreler için aktif Circle yok';

  @override
  String get circlesUnknownRoom => 'Bilinmeyen oda';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle Oluştur';

  @override
  String get circlesCircleName => 'Circle Adı';

  @override
  String get circlesEnterName => 'Ad girin';

  @override
  String get circlesLanguages => 'Diller';

  @override
  String get circlesRoomSetup => 'Oda Kurulumu';

  @override
  String get circlesPlayers => 'Oyuncular';

  @override
  String get circlesEmptySlot => 'Boş slot';

  @override
  String get circlesPlayersRange => '1-5 oyuncu';

  @override
  String get circlesQuestions => 'Sorular';

  @override
  String get circlesQuestionsSubtitle => 'Soru sayısı';

  @override
  String get circlesTimePerQuestion => 'Soru Başına Süre';

  @override
  String get circlesSecondsPerQuestion => 'Soru başına saniye';

  @override
  String get circlesAdvanced => 'Gelişmiş';

  @override
  String get circlesAllowSpectators => 'İzleyicilere İzin Ver';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Başkalarının oynamadan izlemesine izin ver';

  @override
  String get circlesLiveVoiceChat => 'Canlı Sesli Sohbet';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Maç sırasında canlı ses etkinleştir';

  @override
  String get circlesLiveTextChat => 'Canlı Metin Sohbeti';

  @override
  String get circlesLiveTextChatSubtitle => 'Maç sırasında sohbeti etkinleştir';

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
  String get circlesCreatedSuccess => 'Circle oluşturuldu';

  @override
  String circlesCreateError(Object error) {
    return 'Circle oluşturulamadı: $error';
  }

  @override
  String get circlesHostTip =>
      'İpucu: Oluşturduktan sonra arkadaş davet edebilirsiniz';

  @override
  String circlesJoinError(Object error) {
    return 'Circle\'a katılınamadı: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle Lobisi';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kod: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Maç Ayarları';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Seviye $level';
  }

  @override
  String get circlesDifficulty => 'Zorluk';

  @override
  String get circlesPerQuestionShort => 'Soru başına';

  @override
  String get circlesInvite => 'Davet Et';

  @override
  String get circlesCopyId => 'ID Kopyala';

  @override
  String get circlesCopiedId => 'ID kopyalandı';

  @override
  String get circlesMatchInProgress => 'Maç devam ediyor';

  @override
  String get circlesSpectatorQueuedBody =>
      'Maç devam ediyor. İzleyici olarak katılın';

  @override
  String get circlesHostStartWhenReady =>
      'Host herkes hazır olduğunda başlatacak';

  @override
  String get circlesSpectators => 'İzleyiciler';

  @override
  String get circlesSpectator => 'İzleyici';

  @override
  String get circlesSpectatorCanWatch => 'İzleyiciler canlı izleyebilir';

  @override
  String get circlesJoinRequests => 'Katılma İstekleri';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Maçı başlatmadan önce izleyicileri onaylayın';

  @override
  String get circlesStartGame => 'Oyunu Başlat';

  @override
  String get circlesWaitingForPlayers => 'Oyuncular bekleniyor';

  @override
  String get circlesLeaveCircle => 'Circle\'dan Ayrıl';

  @override
  String get circlesRequestSent => 'İstek gönderildi';

  @override
  String get circlesRequestToJoin => 'Katılmak İçin İstek';

  @override
  String get circlesWatchLive => 'Canlı İzle';

  @override
  String get circlesPlayerTip =>
      'Hazır olduğunuzda hazır olarak işaretleyin. Host maçı başlatacak';

  @override
  String get circlesSpectatorTip =>
      'İzliyorsunuz. Host başlattığında canlı izleyin';

  @override
  String get circlesHostControls => 'Host Kontrolleri';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Host aktarılamadı: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle sonlandırılamadı: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username bulunamadı';
  }

  @override
  String get circlesInvalidUser => 'Geçersiz kullanıcı';

  @override
  String get circlesCantInviteSelf => 'Kendinizi davet edemezsiniz';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username zaten Circle\'da';
  }

  @override
  String get circlesDefaultHost => 'Host';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Kullanıcı Adıyla Davet Et';

  @override
  String circlesInviteSent(Object username) {
    return '@$username kullanıcısına davet gönderildi';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Davet gönderilemedi: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Katılma isteği gönderildi';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'İstek başarısız: $error';
  }

  @override
  String get circlesFull => 'Circle dolu';

  @override
  String get circlesSpectatorAdded => 'İzleyici eklendi';

  @override
  String circlesApproveFailed(Object error) {
    return 'İstek onaylanamadı: $error';
  }

  @override
  String get circlesRequestDeclined => 'İstek reddedildi';

  @override
  String circlesDeclineFailed(Object error) {
    return 'İstek reddedilemedi: $error';
  }

  @override
  String get circlesParticipant => 'Katılımcı';

  @override
  String get circlesLeavePromptTitle => 'Circle\'dan Ayrılınsın mı?';

  @override
  String get circlesLeavePromptTransfer =>
      'Lütfen ayrılmadan önce host\'u aktarın';

  @override
  String get circlesLeavePromptEndOnly => 'Circle\'ı sonlandır ve ayrıl';

  @override
  String get circlesTransferHost => 'Host\'u Aktar';

  @override
  String get circlesEndCircle => 'Circle\'ı Sonlandır';

  @override
  String get circlesTransferHostTitle => 'Host\'u Aktar';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
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
