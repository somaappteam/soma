// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Belajar. Bersaing. Menguasai.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Daftar';

  @override
  String get signIn => 'Masuk';

  @override
  String get skipForNow => 'Lewati Sekarang';

  @override
  String get authFillAllFields => 'Harap isi semua kolom';

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
    return 'Kesalahan: $error';
  }

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Kata Sandi';

  @override
  String get authUsername => 'Nama Pengguna';

  @override
  String get authContinue => 'Lanjutkan';

  @override
  String get authSigningIn => 'Masuk...';

  @override
  String get authCreateAccount => 'Buat Akun';

  @override
  String get authCreating => 'Membuat...';

  @override
  String get authNeedAccount => 'Belum punya akun? ';

  @override
  String get authHaveAccount => 'Sudah punya akun? ';

  @override
  String get dialogAuthRequiredTitle => 'Masuk untuk mengakses Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles adalah ruang multipemain. Buat akun untuk bergabung di pertandingan langsung, mengundang teman, dan menyimpan kemajuan Anda.';

  @override
  String get notNow => 'Nanti Saja';

  @override
  String get navHome => 'Beranda';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Profil';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'Hapus Kursus?';

  @override
  String removeCourseBody(Object course) {
    return 'Menghapus $course dari daftar beranda Anda.';
  }

  @override
  String get cancel => 'Batal';

  @override
  String get remove => 'Hapus';

  @override
  String welcomeBack(Object name) {
    return 'Selamat datang kembali, $name!';
  }

  @override
  String get editCourses => 'Edit Kursus';

  @override
  String get done => 'Selesai';

  @override
  String get noCoursesToEdit => 'Tidak ada kursus untuk diedit.';

  @override
  String get addCourse => 'Tambah Kursus';

  @override
  String get unknown => 'Tidak Diketahui';

  @override
  String get iSpeak => 'Saya Berbicara';

  @override
  String get iWantToLearn => 'Saya Ingin Belajar';

  @override
  String get chooseYourLanguage => 'Pilih Bahasa Anda';

  @override
  String get chooseLearningLanguage => 'Pilih bahasa yang ingin Anda pelajari';

  @override
  String get chooseTwoDifferentLanguages =>
      'Harap pilih dua bahasa yang berbeda.';

  @override
  String get createCourse => 'Buat Kursus';

  @override
  String get soloCourseTitle => 'Kursus Solo';

  @override
  String get searchLanguage => 'Cari Bahasa';

  @override
  String get noMatches => 'Tidak Ada Kecocokan';

  @override
  String get chooseCourseType => 'Pilih Jenis Kursus';

  @override
  String get soloStudyDescription =>
      'Belajar sendiri dengan kuis gaya Circles - tanpa ruang, obrolan, penonton, atau opsi tuan rumah.';

  @override
  String get soloModeVocabulary => 'Kosa Kata';

  @override
  String get soloModeSentences => 'Kalimat';

  @override
  String get soloModeReview => 'Tinjauan';

  @override
  String get soloModeVocabularySubtitle =>
      'Pilihan ganda arti, sinonim, penggunaan';

  @override
  String get soloModeSentencesSubtitle => 'Isi kosong + terjemahan + bacaan';

  @override
  String get soloModeReviewDescription =>
      'Praktikkan apa yang telah dipelajari: kata-kata lemah, kesalahan terbaru, pengulangan berjarak.';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'Mulai Tinjauan';

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
    return 'Pengaturan $mode';
  }

  @override
  String get difficulty => 'Kesulitan';

  @override
  String get numberOfQuestions => 'Jumlah Pertanyaan';

  @override
  String get timerPerQuestion => 'Waktu per Pertanyaan';

  @override
  String get noTimer => 'Tanpa Waktu';

  @override
  String get start => 'Mulai';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileSignInToMessage => 'Masuk untuk mengirim pesan';

  @override
  String get profileThatsYourProfile => 'Ini profil Anda';

  @override
  String get profileSignInToAddFriends => 'Masuk untuk menambahkan teman';

  @override
  String get profileCantAddYourself => 'Tidak bisa menambahkan diri sendiri';

  @override
  String profileRequestSent(Object username) {
    return 'Permintaan terkirim ke @$username';
  }

  @override
  String get profileRequestFailed => 'Gagal mengirim permintaan';

  @override
  String get profileDefaultDisplayName => 'Pengguna Baru';

  @override
  String get profileDefaultBio => 'Siap belajar!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Tamu';

  @override
  String get guestUsername => 'tamu';

  @override
  String get guestSessionLabel => 'Sesi Tamu';

  @override
  String get unlockFullProfile => 'Buka Profil Lengkap';

  @override
  String get guestBenefitSync => 'Sinkronkan kemajuan di semua perangkat';

  @override
  String get guestBenefitCircles =>
      'Bergabung di Circles untuk bermain langsung';

  @override
  String get guestBenefitNotifications =>
      'Terima notifikasi dan permintaan teman';

  @override
  String get progressStaysOnDevice =>
      'Sampai Anda masuk, kemajuan Anda tetap di perangkat ini.';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Target: $minutes mnt';
  }

  @override
  String get profileXpProgress => 'Kemajuan XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Menang';

  @override
  String get profileStreak => 'Rentetan';

  @override
  String get profileFriendsTitle => 'Teman';

  @override
  String get profileViewAll => 'Lihat Semua';

  @override
  String get profileAchievementsTitle => 'Pencapaian';

  @override
  String get profileNoAchievements => 'Belum ada pencapaian.';

  @override
  String get profileRequested => 'Diminta';

  @override
  String get profileSending => 'Mengirim...';

  @override
  String get profileAddFriend => 'Tambah Teman';

  @override
  String get profileConnectTitle => 'Terhubung';

  @override
  String get profileMessage => 'Pesan';

  @override
  String get profileSnapshot => 'Cuplikan Profil';

  @override
  String get profileLocationHidden => 'Lokasi Disembunyikan';

  @override
  String get profileBioHidden => 'Bio Disembunyikan';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Target Harian $minutes mnt';
  }

  @override
  String get circleInviteTitle => 'Undangan Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Masuk untuk bergabung';

  @override
  String get joiningCircle => 'Bergabung...';

  @override
  String get joinCircle => 'Gabung Circle';

  @override
  String get circleJoinedAsPlayer => 'Bergabung sebagai pemain';

  @override
  String get circleJoinedAsSpectator => 'Bergabung sebagai penonton';

  @override
  String get accept => 'Terima';

  @override
  String get decline => 'Tolak';

  @override
  String get open => 'Buka';

  @override
  String get circleCountdownTitle => 'Bersiap-siaplah';

  @override
  String get circleCountdownSubtitle => 'Circle dimulai...';

  @override
  String get userFallbackName => 'Pengguna';

  @override
  String get micOff => 'Mikrofon Mati';

  @override
  String get micOn => 'Mikrofon Hidup';

  @override
  String get roleHost => 'Tuan Rumah';

  @override
  String get roleSpectator => 'Penonton';

  @override
  String get tagHost => 'Tuan Rumah';

  @override
  String get tagYou => 'Anda';

  @override
  String get statusCorrect => 'Benar';

  @override
  String get statusWrong => 'Salah';

  @override
  String get statusWaiting => 'Menunggu';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'poin';

  @override
  String get pointsLabel => 'Poin';

  @override
  String get statCorrect => 'Benar';

  @override
  String get statAnswers => 'Jawaban';

  @override
  String get statTotal => 'Total';

  @override
  String get statQuestions => 'Pertanyaan';

  @override
  String get statAccuracy => 'Akurasi';

  @override
  String get statRate => 'Tingkat';

  @override
  String get statRank => 'Peringkat';

  @override
  String get statPosition => 'Posisi';

  @override
  String get statMode => 'Mode';

  @override
  String get statType => 'Jenis';

  @override
  String get next => 'Berikutnya';

  @override
  String get submit => 'Kirim';

  @override
  String get continueLabel => 'Lanjutkan';

  @override
  String get save => 'Simpan';

  @override
  String get playAgain => 'Main Lagi';

  @override
  String get backToCourse => 'Kembali ke Kursus';

  @override
  String get resultsTitle => 'Hasil';

  @override
  String get shareLater => 'Bagikan Nanti';

  @override
  String get delete => 'Hapus';

  @override
  String get ok => 'OK';

  @override
  String minutesShort(Object minutes) {
    return '$minutes mnt';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count mnt';
  }

  @override
  String timeShortHours(Object count) {
    return '$count jam';
  }

  @override
  String timeShortDays(Object count) {
    return '$count hari';
  }

  @override
  String get timeJustNow => 'Baru saja';

  @override
  String timeMinutesAgo(Object count) {
    return '$count menit lalu';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count jam lalu';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count hari lalu';
  }

  @override
  String get liveQuizWaitingForHost => 'Menunggu tuan rumah...';

  @override
  String get liveQuizJoinRequestSent => 'Permintaan bergabung terkirim';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Permintaan gagal: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Kontrol Tuan Rumah';

  @override
  String get liveQuizSpectatorModeTitle => 'Mode Penonton';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Putaran berlangsung otomatis ketika semua orang menjawab atau waktu habis.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Saksikan pertanyaan dan papan peringkat secara langsung. Anda tidak dapat menjawab.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Pertanyaan $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Permintaan terkirim';

  @override
  String get liveQuizRequestToJoin => 'Minta Bergabung';

  @override
  String get liveQuizSpectatorFooter =>
      'Anda menyaksikan secara langsung. Nikmati pertanyaan dan papan peringkat.';

  @override
  String get circleNotFound => 'Circle tidak ditemukan';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Gagal memulai pertandingan ulang: $error';
  }

  @override
  String get resultsMatchTitle => 'Hasil Pertandingan';

  @override
  String resultsNiceWork(Object name) {
    return 'Kerja bagus, $name';
  }

  @override
  String get resultsPlaceFirst => 'Ke-1';

  @override
  String get resultsPlaceSecond => 'Ke-2';

  @override
  String get resultsPlaceThird => 'Ke-3';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Ke-$rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'dari $players pemain';
  }

  @override
  String get resultsHighlightChampion => 'Juara! Anda menaklukkan Circle ini.';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Akurasi hebat. Anda hampir di puncak!';

  @override
  String get resultsHighlightKeepGoing =>
      'Terus lanjutkan - konsistensi mengalahkan kecepatan.';

  @override
  String get resultsLeaderboardTitle => 'Papan Peringkat';

  @override
  String resultsPlayersCount(Object count) {
    return '$count pemain';
  }

  @override
  String get resultsBackToCircles => 'Kembali ke Circles';

  @override
  String get resultsRematch => 'Pertandingan Ulang';

  @override
  String get resultsPlayAgain => 'Main Lagi';

  @override
  String get leaderboardGlobalTitle => 'Papan Peringkat Global';

  @override
  String get leaderboardEmpty => 'Belum ada papan peringkat.';

  @override
  String get aboutTitle => 'Tentang';

  @override
  String aboutVersion(Object version) {
    return 'Versi $version';
  }

  @override
  String get aboutDescription =>
      'SOMA adalah platform pembelajaran bahasa yang digamifikasi yang membuat belajar bahasa baru menjadi menyenangkan dan sosial. Bergabunglah di Circles, berlatih sendiri, dan lacak kemajuan Anda.';

  @override
  String get aboutTerms => 'Syarat Layanan';

  @override
  String get aboutPrivacy => 'Kebijakan Privasi';

  @override
  String get aboutOpenSource => 'Lisensi Sumber Terbuka';

  @override
  String get addFriendTitle => 'Tambah Teman';

  @override
  String get addFriendFindByUsername => 'Cari berdasarkan nama pengguna';

  @override
  String get addFriendUsernameHint => 'Masukkan nama pengguna...';

  @override
  String get addFriendTip =>
      'Tips: Dukungan kode QR + ID teman dapat ditambahkan nanti.';

  @override
  String get addFriendSending => 'Mengirim...';

  @override
  String get addFriendSendRequest => 'Kirim Permintaan';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username tidak ditemukan';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Tindakan gagal atau sudah terkirim: $error';
  }

  @override
  String get friendsTitle => 'Teman';

  @override
  String get searchFriendsHint => 'Cari teman...';

  @override
  String get somaLearnerSubtitle => 'Pelajar Soma';

  @override
  String get friendRequestLabel => 'Permintaan';

  @override
  String get friendRequestSentLabel => 'Permintaan Terkirim';

  @override
  String get friendIncomingRequestLabel => 'Permintaan Masuk';

  @override
  String get friendRequestsSection => 'Permintaan';

  @override
  String get friendPendingSection => 'Tertunda';

  @override
  String get friendAllSection => 'Semua Teman';

  @override
  String get friendsEmptyState =>
      'Belum ada teman. Tambahkan teman pertama Anda!';

  @override
  String get friendsEmptyShort => 'Belum ada teman.';

  @override
  String noMatchForQuery(Object query) {
    return 'Tidak ada yang cocok dengan \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'Kotak Masuk';

  @override
  String get searchChatsHint => 'Cari obrolan...';

  @override
  String get inboxEmptyState =>
      'Belum ada obrolan. Mulai obrolan dengan teman!';

  @override
  String get newMessageTitle => 'Pesan Baru';

  @override
  String get chatCallLater =>
      'Panggilan suara nanti (bahasa Circle segera hadir)';

  @override
  String errorWithDetails(Object error) {
    return 'Kesalahan: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Sapa $name!';
  }

  @override
  String get chatMessageHint => 'Pesan...';

  @override
  String get notificationsTitle => 'Notifikasi';

  @override
  String get notificationsTabAll => 'Semua';

  @override
  String get notificationsTabCourses => 'Kursus';

  @override
  String get notificationsTabSocial => 'Sosial';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Sistem';

  @override
  String get notificationsEmpty => 'Tidak ada notifikasi di sini.';

  @override
  String get notificationsDeleted => 'Notifikasi dihapus';

  @override
  String get notificationTitleFallback => 'Notifikasi';

  @override
  String get notificationTypeCourse => 'Kursus';

  @override
  String get notificationTypeSocial => 'Sosial';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Sistem';

  @override
  String get notificationsFriendAccepted => 'Permintaan teman diterima';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Gagal menerima permintaan teman: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Permintaan teman ditolak';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Gagal menolak permintaan teman: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Gagal bergabung di Circle: $error';
  }

  @override
  String get notificationsOpening => 'Membuka';

  @override
  String get notificationsOpened => 'Dibuka';

  @override
  String notificationsActionMessage(Object action) {
    return '$action notifikasi';
  }

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSectionAccount => 'Akun';

  @override
  String get settingsEditProfile => 'Edit Profil';

  @override
  String get settingsPrivacy => 'Privasi';

  @override
  String get settingsSecurity => 'Keamanan';

  @override
  String get settingsSectionGameplay => 'Gameplay';

  @override
  String get settingsShowTranslationLine => 'Tampilkan baris terjemahan';

  @override
  String get settingsShowReadingLine => 'Tampilkan bacaan (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Waktu default per pertanyaan';

  @override
  String get settingsMatchDifficulty => 'Kesulitan Pertandingan';

  @override
  String get settingsMatchDifficultyAdaptive => 'Adaptif';

  @override
  String get settingsSectionSoundFeel => 'Suara & Nuansa';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSoundEffects => 'Efek Suara';

  @override
  String get settingsHaptics => 'Umpan Balik Haptik';

  @override
  String get settingsSectionNotifications => 'Notifikasi';

  @override
  String get settingsPushNotifications => 'Notifikasi Push';

  @override
  String get settingsDailyReminder => 'Pengingat Harian';

  @override
  String get settingsSectionAppearance => 'Tampilan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsUiLanguage => 'Bahasa UI';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsTermsPrivacy => 'Syarat & Privasi';

  @override
  String get settingsSupport => 'Dukungan';

  @override
  String get settingsLogout => 'Keluar';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeLight => 'Terang';

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
  String get editProfileUpdated => 'Profil diperbarui';

  @override
  String get editProfileTitle => 'Edit Profil';

  @override
  String get editProfilePhotoLabel => 'Foto Profil';

  @override
  String get editProfilePhotoSubtitle =>
      'Pemilihan avatar melalui Supabase Storage segera hadir.';

  @override
  String get editProfileChangePhoto => 'Ubah';

  @override
  String get editProfileAvatarUploadSoon => 'Unggah avatar segera hadir';

  @override
  String get editProfileDisplayNameLabel => 'Nama Tampilan';

  @override
  String get editProfileDisplayNameHint => 'Nama Anda';

  @override
  String get editProfileDisplayNameRequired => 'Harap masukkan nama';

  @override
  String get editProfileDisplayNameTooShort => 'Terlalu pendek';

  @override
  String get editProfileUsernameLabel => 'Nama Pengguna';

  @override
  String get editProfileUsernameHint => 'budi_pelajar';

  @override
  String get editProfileUsernameRequired => 'Harap masukkan nama pengguna';

  @override
  String get editProfileUsernameTooShort => 'Minimal 3 karakter';

  @override
  String get editProfileUsernameInvalid => 'Hanya huruf, angka, _';

  @override
  String get editProfileBioLabel => 'Bio';

  @override
  String get editProfileBioHint => 'Bio singkat...';

  @override
  String get editProfileBioTooLong => 'Maksimal 120 karakter';

  @override
  String get editProfileLocationLabel => 'Lokasi';

  @override
  String get editProfileLocationHint => 'Kota / Negara';

  @override
  String get editProfileDailyGoalTitle => 'Target Harian';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Pilih berapa menit Anda ingin belajar setiap hari.';

  @override
  String get securityTitle => 'Keamanan';

  @override
  String get securitySectionPassword => 'Kata Sandi';

  @override
  String get securityChangePasswordTitle => 'Ubah Kata Sandi';

  @override
  String get securityChangePasswordSubtitle =>
      'Perbarui kata sandi Anda secara berkala.';

  @override
  String get securitySectionTwoFactor => 'Autentikasi Dua Faktor';

  @override
  String get securityEnable2faTitle => 'Aktifkan 2FA';

  @override
  String get securityEnable2faSubtitle => 'Keamanan ekstra saat masuk.';

  @override
  String get securitySectionAppLock => 'Kunci Aplikasi';

  @override
  String get securityBiometricTitle => 'Buka Kunci Biometrik';

  @override
  String get securityBiometricSubtitle =>
      'Gunakan FaceID/TouchID untuk membuka SOMA.';

  @override
  String get securityAppLockTitle => 'Kunci Aplikasi';

  @override
  String get securityAppLockSubtitle => 'Kunci SOMA saat keluar.';

  @override
  String get securitySectionSessions => 'Sesi Aktif';

  @override
  String get securityNoSessions => 'Tidak ada sesi aktif ditemukan.';

  @override
  String get securityThisDevice => 'Perangkat Ini';

  @override
  String get securityDevice => 'Perangkat';

  @override
  String get securityActiveLabel => 'Aktif';

  @override
  String get securitySignInToEnable2fa => 'Masuk untuk mengaktifkan 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Gagal mengaktifkan 2FA: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Gagal menonaktifkan 2FA: $error';
  }

  @override
  String get securitySetup2faTitle => 'Pengaturan 2FA';

  @override
  String get securitySecretKeyLabel => 'Kunci Rahasia';

  @override
  String get securityCodeHint => 'Kode 6 digit';

  @override
  String get security2faEnabled => '2FA diaktifkan';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Gagal memverifikasi kode: $error';
  }

  @override
  String get securityVerifying => 'Memverifikasi...';

  @override
  String get securityVerify => 'Verifikasi';

  @override
  String get securityCurrentPasswordHint => 'Kata sandi saat ini';

  @override
  String get securityNewPasswordHint => 'Kata sandi baru (min. 8 karakter)';

  @override
  String get securityConfirmPasswordHint => 'Konfirmasi kata sandi baru';

  @override
  String get securitySignInToChangePassword =>
      'Masuk untuk mengubah kata sandi';

  @override
  String get securityEnterCurrentPassword =>
      'Harap masukkan kata sandi saat ini';

  @override
  String get securityPasswordMinLength =>
      'Kata sandi baru harus minimal 8 karakter';

  @override
  String get securityPasswordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get securityPasswordUpdated => 'Kata sandi diperbarui';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Gagal memperbarui kata sandi: $error';
  }

  @override
  String get securityAutoLockAfter => 'Kunci otomatis setelah';

  @override
  String get privacyTitle => 'Privasi';

  @override
  String get privacySectionVisibility => 'Visibilitas';

  @override
  String get privacyProfileVisibilityTitle => 'Visibilitas Profil';

  @override
  String get privacyVisibilityPublic => 'Publik';

  @override
  String get privacyVisibilityFriends => 'Teman';

  @override
  String get privacyVisibilityPrivate => 'Pribadi';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Siapa pun dapat melihat profil Anda.';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Hanya teman yang dapat melihat profil Anda.';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Hanya Anda yang dapat melihat profil.';

  @override
  String get privacySectionActivity => 'Aktivitas';

  @override
  String get privacyShowOnlineTitle => 'Tampilkan Status Online';

  @override
  String get privacyShowOnlineSubtitle =>
      'Biarkan orang lain melihat Anda online.';

  @override
  String get privacyShowActivityTitle => 'Tampilkan Aktivitas Belajar';

  @override
  String get privacyShowActivitySubtitle =>
      'Tampilkan rentetan, XP, dan kemajuan saat ini.';

  @override
  String get privacySectionSocial => 'Sosial';

  @override
  String get privacyAllowRequestsTitle => 'Izinkan Permintaan Teman';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Izinkan orang lain mengirim permintaan teman.';

  @override
  String get privacyWhoCanDmTitle => 'Siapa yang Bisa DM';

  @override
  String get privacyDmEveryone => 'Semua Orang';

  @override
  String get privacyDmFriends => 'Teman';

  @override
  String get privacyDmNoOne => 'Tidak Ada';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Siapa pun dapat mengirim DM kepada Anda.';

  @override
  String get privacyDmFriendsSubtitle =>
      'Hanya teman yang dapat mengirim DM kepada Anda.';

  @override
  String get privacyDmNoOneSubtitle =>
      'Tidak ada yang dapat mengirim DM kepada Anda.';

  @override
  String get privacySectionBlockedUsers => 'Pengguna yang Diblokir';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Kelola pengguna yang diblokir segera hadir.';

  @override
  String get privacySectionDataControls => 'Kontrol Data';

  @override
  String get privacyExportDataTitle => 'Ekspor Data';

  @override
  String get privacyExportDataSubtitle => 'Unduh aktivitas dan kursus Anda.';

  @override
  String get privacyExportInfoTitle => 'Ekspor Data';

  @override
  String get privacyExportInfoBody =>
      'Langkah selanjutnya: Buat ekspor JSON/CSV dan kirim melalui email atau unduh secara lokal.';

  @override
  String get privacyDeleteAccountTitle => 'Hapus Akun';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Ini akan menghapus akun dan data Anda secara permanen.';

  @override
  String get privacyDeleteConfirmTitle => 'Hapus Akun?';

  @override
  String get privacyDeleteConfirmBody =>
      'Tindakan ini permanen. Profil, kursus, teman, dan pesan Anda akan dihapus.';

  @override
  String get privacyDeleteComingSoon =>
      'Penghapusan akan terhubung ke Supabase nanti';

  @override
  String get soloLabel => 'Solo';

  @override
  String get soloResultsCompletedTitle => 'Sesi Solo Selesai';

  @override
  String get soloResultsFeedbackElite =>
      'Performa elite. Pertahankan rentetan.';

  @override
  String get soloResultsFeedbackStrong => 'Kuat. Anda berkembang pesat.';

  @override
  String get soloResultsFeedbackProgress =>
      'Kemajuan bagus. Tinjau kesalahan dan ulangi.';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Tanpa stres. Coba lagi dengan lebih sedikit pertanyaan dan fokus.';

  @override
  String get soloResultsPerfectScore =>
      'Skor sempurna! Tidak ada kesalahan untuk ditinjau.';

  @override
  String get soloResultsReviewPrompt =>
      'Tinjau kesalahan untuk belajar lebih cepat. Jawaban salah Anda ada di bawah.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Tinjau Kesalahan ($count)';
  }

  @override
  String get authNotSignedIn => 'Belum masuk';

  @override
  String get genericUser => 'Pengguna';

  @override
  String get loading => 'Memuat...';

  @override
  String get edit => 'Edit';

  @override
  String get send => 'Kirim';

  @override
  String get join => 'Gabung';

  @override
  String get leave => 'Tinggalkan';

  @override
  String get ready => 'Siap';

  @override
  String get levelBeginner => 'Pemula';

  @override
  String get levelIntermediate => 'Menengah';

  @override
  String get levelAdvanced => 'Lanjutan';

  @override
  String questionsShort(Object count) {
    return '$count pert.';
  }

  @override
  String secondsShort(Object count) {
    return '$count dtk';
  }

  @override
  String get circlesAllCourses => 'Semua Kursus';

  @override
  String get circlesAllModes => 'Semua Mode';

  @override
  String get circlesAllLevels => 'Semua Level';

  @override
  String get circlesAddNewCourse => 'Tambah Kursus Baru';

  @override
  String get circlesCoursesTitle => 'Kursus';

  @override
  String get circlesModeTitle => 'Mode';

  @override
  String get circlesLevelTitle => 'Level';

  @override
  String get circlesNoActiveForFilters =>
      'Tidak ada Circle aktif untuk filter ini.';

  @override
  String get circlesUnknownRoom => 'Ruang Tidak Dikenal';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Buat Circle';

  @override
  String get circlesCircleName => 'Nama Circle';

  @override
  String get circlesEnterName => 'Masukkan nama';

  @override
  String get circlesLanguages => 'Bahasa';

  @override
  String get circlesRoomSetup => 'Pengaturan Ruang';

  @override
  String get circlesPlayers => 'Pemain';

  @override
  String get circlesEmptySlot => 'Slot Kosong';

  @override
  String get circlesPlayersRange => '1-5 pemain';

  @override
  String get circlesQuestions => 'Pertanyaan';

  @override
  String get circlesQuestionsSubtitle => 'Jumlah pertanyaan';

  @override
  String get circlesTimePerQuestion => 'Waktu per Pertanyaan';

  @override
  String get circlesSecondsPerQuestion => 'Detik per pertanyaan';

  @override
  String get circlesAdvanced => 'Lanjutan';

  @override
  String get circlesAllowSpectators => 'Izinkan Penonton';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Izinkan orang lain menonton tanpa bermain.';

  @override
  String get circlesLiveVoiceChat => 'Obrolan Suara Langsung';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Aktifkan suara langsung selama pertandingan.';

  @override
  String get circlesLiveTextChat => 'Obrolan Teks Langsung';

  @override
  String get circlesLiveTextChatSubtitle =>
      'Aktifkan obrolan selama pertandingan.';

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
  String get circlesCreatedSuccess => 'Circle dibuat';

  @override
  String circlesCreateError(Object error) {
    return 'Gagal membuat Circle: $error';
  }

  @override
  String get circlesHostTip =>
      'Tips: Anda dapat mengundang teman setelah membuat.';

  @override
  String circlesJoinError(Object error) {
    return 'Gagal bergabung di Circle: $error';
  }

  @override
  String get circlesLobbyTitle => 'Lobi Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Kode: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Pengaturan Pertandingan';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Level $level';
  }

  @override
  String get circlesDifficulty => 'Kesulitan';

  @override
  String get circlesPerQuestionShort => 'per pert.';

  @override
  String get circlesInvite => 'Undang';

  @override
  String get circlesCopyId => 'Salin ID';

  @override
  String get circlesCopiedId => 'ID disalin';

  @override
  String get circlesMatchInProgress => 'Pertandingan Berlangsung';

  @override
  String get circlesSpectatorQueuedBody =>
      'Pertandingan berlangsung. Bergabung sebagai penonton.';

  @override
  String get circlesHostStartWhenReady =>
      'Tuan rumah memulai ketika semua orang siap.';

  @override
  String get circlesSpectators => 'Penonton';

  @override
  String get circlesSpectator => 'Penonton';

  @override
  String get circlesSpectatorCanWatch =>
      'Penonton dapat menyaksikan secara langsung.';

  @override
  String get circlesJoinRequests => 'Permintaan Bergabung';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Setujui penonton sebelum memulai pertandingan.';

  @override
  String get circlesStartGame => 'Mulai Permainan';

  @override
  String get circlesWaitingForPlayers => 'Menunggu Pemain';

  @override
  String get circlesLeaveCircle => 'Tinggalkan Circle';

  @override
  String get circlesRequestSent => 'Permintaan terkirim';

  @override
  String get circlesRequestToJoin => 'Minta Bergabung';

  @override
  String get circlesWatchLive => 'Saksikan Langsung';

  @override
  String get circlesPlayerTip =>
      'Ketuk siap saat Anda siap. Tuan rumah akan memulai pertandingan.';

  @override
  String get circlesSpectatorTip =>
      'Anda sedang menyaksikan. Saksikan secara langsung ketika tuan rumah memulai.';

  @override
  String get circlesHostControls => 'Kontrol Tuan Rumah';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Gagal memindahkan tuan rumah: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Gagal mengakhiri Circle: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username tidak ditemukan';
  }

  @override
  String get circlesInvalidUser => 'Pengguna tidak valid';

  @override
  String get circlesCantInviteSelf => 'Tidak bisa mengundang diri sendiri';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username sudah ada di Circle';
  }

  @override
  String get circlesDefaultHost => 'Tuan Rumah';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Undang dengan nama pengguna';

  @override
  String circlesInviteSent(Object username) {
    return 'Undangan terkirim ke @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Gagal mengirim undangan: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Permintaan bergabung terkirim';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Permintaan gagal: $error';
  }

  @override
  String get circlesFull => 'Circle penuh';

  @override
  String get circlesSpectatorAdded => 'Penonton ditambahkan';

  @override
  String circlesApproveFailed(Object error) {
    return 'Gagal menyetujui permintaan: $error';
  }

  @override
  String get circlesRequestDeclined => 'Permintaan ditolak';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Gagal menolak permintaan: $error';
  }

  @override
  String get circlesParticipant => 'Peserta';

  @override
  String get circlesLeavePromptTitle => 'Tinggalkan Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Harap pindahkan tuan rumah sebelum meninggalkan.';

  @override
  String get circlesLeavePromptEndOnly => 'Akhiri Circle dan tinggalkan.';

  @override
  String get circlesTransferHost => 'Pindahkan Tuan Rumah';

  @override
  String get circlesEndCircle => 'Akhiri Circle';

  @override
  String get circlesTransferHostTitle => 'Pindahkan Tuan Rumah';

  @override
  String circlesShareId(Object id) {
    return 'ID Circle: $id';
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
