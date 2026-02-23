// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'Học. Thi đấu. Thống trị';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'Đăng ký';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get skipForNow => 'Bỏ qua bây giờ';

  @override
  String get authFillAllFields => 'Vui lòng điền đầy đủ các trường';

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
    return 'Lỗi: $error';
  }

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authUsername => 'Tên người dùng';

  @override
  String get authContinue => 'Tiếp tục';

  @override
  String get authSigningIn => 'Đang đăng nhập...';

  @override
  String get authCreateAccount => 'Tạo tài khoản';

  @override
  String get authCreating => 'Đang tạo...';

  @override
  String get authNeedAccount => 'Chưa có tài khoản? ';

  @override
  String get authHaveAccount => 'Đã có tài khoản? ';

  @override
  String get dialogAuthRequiredTitle => 'Đăng nhập để truy cập Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles là phòng nhiều người chơi. Tạo tài khoản để tham gia trận đấu trực tiếp, mời bạn bè và lưu tiến độ.';

  @override
  String get notNow => 'Không phải bây giờ';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'Xóa khóa học?';

  @override
  String removeCourseBody(Object course) {
    return '$course sẽ bị xóa khỏi danh sách của bạn';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get remove => 'Xóa';

  @override
  String welcomeBack(Object name) {
    return 'Chào mừng trở lại, $name!';
  }

  @override
  String get editCourses => 'Chỉnh sửa khóa học';

  @override
  String get done => 'Hoàn thành';

  @override
  String get noCoursesToEdit => 'Không có khóa học để chỉnh sửa';

  @override
  String get addCourse => 'Thêm khóa học';

  @override
  String get unknown => 'Không rõ';

  @override
  String get iSpeak => 'Tôi nói';

  @override
  String get iWantToLearn => 'Tôi muốn học';

  @override
  String get chooseYourLanguage => 'Chọn ngôn ngữ của bạn';

  @override
  String get chooseLearningLanguage => 'Chọn ngôn ngữ học';

  @override
  String get chooseTwoDifferentLanguages =>
      'Vui lòng chọn hai ngôn ngữ khác nhau';

  @override
  String get createCourse => 'Tạo khóa học';

  @override
  String get soloCourseTitle => 'Khóa học đơn';

  @override
  String get searchLanguage => 'Tìm kiếm ngôn ngữ';

  @override
  String get noMatches => 'Không có kết quả';

  @override
  String get chooseCourseType => 'Chọn loại khóa học';

  @override
  String get soloStudyDescription =>
      'Học một mình với các bài kiểm tra giống như Circles - nhưng không có phòng, trò chuyện, người xem hoặc tùy chọn chủ phòng';

  @override
  String get soloModeVocabulary => 'Từ vựng';

  @override
  String get soloModeSentences => 'Câu';

  @override
  String get soloModeReview => 'Ôn tập';

  @override
  String get soloModeVocabularySubtitle =>
      'Trắc nghiệm, nghĩa, từ đồng nghĩa, cách dùng';

  @override
  String get soloModeSentencesSubtitle => 'Điền vào chỗ trống + dịch + đọc';

  @override
  String get soloModeReviewDescription =>
      'Luyện tập những gì đã học: từ yếu, lỗi gần đây và ôn tập ngắt quãng';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'Bắt đầu ôn tập';

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
    return 'Thiết lập $mode';
  }

  @override
  String get difficulty => 'Độ khó';

  @override
  String get numberOfQuestions => 'Số câu hỏi';

  @override
  String get timerPerQuestion => 'Bộ đếm thời gian mỗi câu';

  @override
  String get noTimer => 'Không có bộ đếm';

  @override
  String get start => 'Bắt đầu';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileSignInToMessage => 'Đăng nhập để nhắn tin';

  @override
  String get profileThatsYourProfile => 'Đây là hồ sơ của bạn';

  @override
  String get profileSignInToAddFriends => 'Đăng nhập để thêm bạn bè';

  @override
  String get profileCantAddYourself => 'Bạn không thể thêm chính mình';

  @override
  String profileRequestSent(Object username) {
    return 'Đã gửi yêu cầu đến @$username';
  }

  @override
  String get profileRequestFailed => 'Gửi yêu cầu thất bại';

  @override
  String get profileDefaultDisplayName => 'Người dùng mới';

  @override
  String get profileDefaultBio => 'Sẵn sàng học!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'Khách';

  @override
  String get guestUsername => 'khách';

  @override
  String get guestSessionLabel => 'Phiên khách';

  @override
  String get unlockFullProfile => 'Mở khóa hồ sơ đầy đủ';

  @override
  String get guestBenefitSync => 'Đồng bộ tiến độ trên tất cả thiết bị';

  @override
  String get guestBenefitCircles => 'Tham gia Circles và chơi trực tiếp';

  @override
  String get guestBenefitNotifications => 'Nhận thông báo và yêu cầu kết bạn';

  @override
  String get progressStaysOnDevice =>
      'Tiến độ được lưu trên thiết bị này cho đến khi bạn đăng nhập';

  @override
  String profileGoalLabel(Object minutes) {
    return 'Mục tiêu: $minutes phút';
  }

  @override
  String get profileXpProgress => 'Tiến độ XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'Chiến thắng';

  @override
  String get profileStreak => 'Chuỗi';

  @override
  String get profileFriendsTitle => 'Bạn bè';

  @override
  String get profileViewAll => 'Xem tất cả';

  @override
  String get profileAchievementsTitle => 'Thành tích';

  @override
  String get profileNoAchievements => 'Chưa có thành tích nào';

  @override
  String get profileRequested => 'Đã gửi yêu cầu';

  @override
  String get profileSending => 'Đang gửi...';

  @override
  String get profileAddFriend => 'Thêm bạn';

  @override
  String get profileConnectTitle => 'Kết nối';

  @override
  String get profileMessage => 'Tin nhắn';

  @override
  String get profileSnapshot => 'Ảnh chụp hồ sơ';

  @override
  String get profileLocationHidden => 'Vị trí đã ẩn';

  @override
  String get profileBioHidden => 'Tiểu sử đã ẩn';

  @override
  String profileDailyGoal(Object minutes) {
    return 'Mục tiêu $minutes phút mỗi ngày';
  }

  @override
  String get circleInviteTitle => 'Lời mời Circle';

  @override
  String circleIdLabel(Object id) {
    return 'ID Circle: $id';
  }

  @override
  String get signInToJoin => 'Đăng nhập để tham gia';

  @override
  String get joiningCircle => 'Đang tham gia...';

  @override
  String get joinCircle => 'Tham gia Circle';

  @override
  String get circleJoinedAsPlayer => 'Đã tham gia với tư cách người chơi';

  @override
  String get circleJoinedAsSpectator => 'Đã tham gia với tư cách người xem';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get decline => 'Từ chối';

  @override
  String get open => 'Mở';

  @override
  String get circleCountdownTitle => 'Chuẩn bị';

  @override
  String get circleCountdownSubtitle => 'Circle sắp bắt đầu...';

  @override
  String get userFallbackName => 'Người dùng';

  @override
  String get micOff => 'Tắt mic';

  @override
  String get micOn => 'Bật mic';

  @override
  String get roleHost => 'Chủ phòng';

  @override
  String get roleSpectator => 'Người xem';

  @override
  String get tagHost => 'CHỦ PHÒNG';

  @override
  String get tagYou => 'BẠN';

  @override
  String get statusCorrect => 'Đúng';

  @override
  String get statusWrong => 'Sai';

  @override
  String get statusWaiting => 'Chờ';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'điểm';

  @override
  String get pointsLabel => 'Điểm';

  @override
  String get statCorrect => 'Đúng';

  @override
  String get statAnswers => 'câu trả lời';

  @override
  String get statTotal => 'Tổng';

  @override
  String get statQuestions => 'câu hỏi';

  @override
  String get statAccuracy => 'Độ chính xác';

  @override
  String get statRate => 'tỷ lệ';

  @override
  String get statRank => 'Hạng';

  @override
  String get statPosition => 'vị trí';

  @override
  String get statMode => 'Chế độ';

  @override
  String get statType => 'loại';

  @override
  String get next => 'Tiếp theo';

  @override
  String get submit => 'Gửi';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String get save => 'Lưu';

  @override
  String get playAgain => 'Chơi lại';

  @override
  String get backToCourse => 'Quay lại khóa học';

  @override
  String get resultsTitle => 'Kết quả';

  @override
  String get shareLater => 'Chia sẻ sau';

  @override
  String get delete => 'Xóa';

  @override
  String get ok => 'OK';

  @override
  String minutesShort(Object minutes) {
    return '$minutes phút';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count ph';
  }

  @override
  String timeShortHours(Object count) {
    return '$count giờ';
  }

  @override
  String timeShortDays(Object count) {
    return '$count ngày';
  }

  @override
  String get timeJustNow => 'vừa xong';

  @override
  String timeMinutesAgo(Object count) {
    return '$count phút trước';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count giờ trước';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count ngày trước';
  }

  @override
  String get liveQuizWaitingForHost => 'Đang chờ chủ phòng...';

  @override
  String get liveQuizJoinRequestSent => 'Đã gửi yêu cầu tham gia';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'Gửi yêu cầu thất bại: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'Điều khiển chủ phòng';

  @override
  String get liveQuizSpectatorModeTitle => 'Chế độ người xem';

  @override
  String get liveQuizHostControlsSubtitle =>
      'Vòng tự động tiếp tục khi mọi người trả lời hoặc hết giờ';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'Xem câu hỏi và bảng xếp hạng trực tiếp. Bạn không thể trả lời';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'Câu hỏi $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'Đã gửi yêu cầu';

  @override
  String get liveQuizRequestToJoin => 'Yêu cầu tham gia';

  @override
  String get liveQuizSpectatorFooter =>
      'Bạn đang xem trực tiếp. Thưởng thức câu hỏi và bảng xếp hạng';

  @override
  String get circleNotFound => 'Không tìm thấy Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'Không thể bắt đầu trận tái đấu: $error';
  }

  @override
  String get resultsMatchTitle => 'Kết quả trận đấu';

  @override
  String resultsNiceWork(Object name) {
    return 'Làm tốt lắm, $name';
  }

  @override
  String get resultsPlaceFirst => 'Hạng 1';

  @override
  String get resultsPlaceSecond => 'Hạng 2';

  @override
  String get resultsPlaceThird => 'Hạng 3';

  @override
  String resultsPlaceNth(Object rank) {
    return 'Hạng $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'Trong số $players người chơi';
  }

  @override
  String get resultsHighlightChampion => 'Vô địch! Bạn đã thống trị vòng này';

  @override
  String get resultsHighlightGreatAccuracy =>
      'Độ chính xác tuyệt vời - bạn gần đỉnh rồi!';

  @override
  String get resultsHighlightKeepGoing =>
      'Tiếp tục - sự kiên định thắng tốc độ';

  @override
  String get resultsLeaderboardTitle => 'Bảng xếp hạng';

  @override
  String resultsPlayersCount(Object count) {
    return '$count người chơi';
  }

  @override
  String get resultsBackToCircles => 'Quay lại Circles';

  @override
  String get resultsRematch => 'Tái đấu';

  @override
  String get resultsPlayAgain => 'Chơi lại';

  @override
  String get leaderboardGlobalTitle => 'Xếp hạng toàn cầu';

  @override
  String get leaderboardEmpty => 'Chưa có xếp hạng';

  @override
  String get aboutTitle => 'Về ứng dụng';

  @override
  String aboutVersion(Object version) {
    return 'Phiên bản $version';
  }

  @override
  String get aboutDescription =>
      'SOMA là nền tảng học ngôn ngữ trò chơi hóa giúp việc thành thạo ngôn ngữ mới trở nên thú vị và mang tính xã hội. Thi đấu trong Circles, luyện tập đơn, và theo dõi tiến độ của bạn.';

  @override
  String get aboutTerms => 'Điều khoản sử dụng';

  @override
  String get aboutPrivacy => 'Chính sách bảo mật';

  @override
  String get aboutOpenSource => 'Giấy phép mã nguồn mở';

  @override
  String get addFriendTitle => 'Thêm bạn';

  @override
  String get addFriendFindByUsername => 'Tìm theo tên người dùng';

  @override
  String get addFriendUsernameHint => 'Nhập tên người dùng...';

  @override
  String get addFriendTip => 'Mẹo: hỗ trợ mã QR + ID bạn bè sẽ được thêm sau';

  @override
  String get addFriendSending => 'Đang gửi...';

  @override
  String get addFriendSendRequest => 'Gửi yêu cầu';

  @override
  String addFriendUserNotFound(Object username) {
    return 'Không tìm thấy người dùng @$username';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'Hành động thất bại hoặc đã gửi: $error';
  }

  @override
  String get friendsTitle => 'Bạn bè';

  @override
  String get searchFriendsHint => 'Tìm kiếm bạn bè...';

  @override
  String get somaLearnerSubtitle => 'Học viên Soma';

  @override
  String get friendRequestLabel => 'Yêu cầu';

  @override
  String get friendRequestSentLabel => 'Đã gửi yêu cầu';

  @override
  String get friendIncomingRequestLabel => 'Yêu cầu đến';

  @override
  String get friendRequestsSection => 'Yêu cầu';

  @override
  String get friendPendingSection => 'Đang chờ';

  @override
  String get friendAllSection => 'Tất cả bạn bè';

  @override
  String get friendsEmptyState => 'Chưa có bạn bè. Thêm bạn đầu tiên của bạn!';

  @override
  String get friendsEmptyShort => 'Chưa có bạn bè';

  @override
  String noMatchForQuery(Object query) {
    return 'Không có kết quả cho \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'Hộp thư';

  @override
  String get searchChatsHint => 'Tìm kiếm trò chuyện...';

  @override
  String get inboxEmptyState =>
      'Chưa có cuộc trò chuyện nào. Bắt đầu trò chuyện với bạn bè!';

  @override
  String get newMessageTitle => 'Tin nhắn mới';

  @override
  String get chatCallLater => 'Gọi thoại sau (Circle voice tiếp theo)';

  @override
  String errorWithDetails(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'Chào $name!';
  }

  @override
  String get chatMessageHint => 'Tin nhắn...';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get notificationsTabAll => 'Tất cả';

  @override
  String get notificationsTabCourses => 'Khóa học';

  @override
  String get notificationsTabSocial => 'Xã hội';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'Hệ thống';

  @override
  String get notificationsEmpty => 'Không có thông báo';

  @override
  String get notificationsDeleted => 'Đã xóa thông báo';

  @override
  String get notificationTitleFallback => 'Thông báo';

  @override
  String get notificationTypeCourse => 'Khóa học';

  @override
  String get notificationTypeSocial => 'Xã hội';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'Hệ thống';

  @override
  String get notificationsFriendAccepted => 'Đã chấp nhận yêu cầu kết bạn';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'Chấp nhận yêu cầu kết bạn thất bại: $error';
  }

  @override
  String get notificationsFriendDeclined => 'Đã từ chối yêu cầu kết bạn';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'Từ chối yêu cầu kết bạn thất bại: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Tham gia Circle thất bại: $error';
  }

  @override
  String get notificationsOpening => 'Đang mở';

  @override
  String get notificationsOpened => 'Đã mở';

  @override
  String notificationsActionMessage(Object action) {
    return '$action thông báo';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsSectionAccount => 'Tài khoản';

  @override
  String get settingsEditProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get settingsPrivacy => 'Quyền riêng tư';

  @override
  String get settingsSecurity => 'Bảo mật';

  @override
  String get settingsSectionGameplay => 'Trò chơi';

  @override
  String get settingsShowTranslationLine => 'Hiển thị dòng dịch';

  @override
  String get settingsShowReadingLine => 'Hiển thị cách đọc (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'Bộ đếm mặc định mỗi câu';

  @override
  String get settingsMatchDifficulty => 'Độ khó trận đấu';

  @override
  String get settingsMatchDifficultyAdaptive => 'Thích ứng';

  @override
  String get settingsSectionSoundFeel => 'Âm thanh và cảm giác';

  @override
  String get settingsMusic => 'Nhạc';

  @override
  String get settingsSoundEffects => 'Hiệu ứng âm thanh';

  @override
  String get settingsHaptics => 'Rung';

  @override
  String get settingsSectionNotifications => 'Thông báo';

  @override
  String get settingsPushNotifications => 'Thông báo đẩy';

  @override
  String get settingsDailyReminder => 'Nhắc nhở hàng ngày';

  @override
  String get settingsSectionAppearance => 'Giao diện';

  @override
  String get settingsTheme => 'Chủ đề';

  @override
  String get settingsUiLanguage => 'Ngôn ngữ giao diện';

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsTermsPrivacy => 'Điều khoản và Quyền riêng tư';

  @override
  String get settingsSupport => 'Hỗ trợ';

  @override
  String get settingsLogout => 'Đăng xuất';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeLight => 'Sáng';

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
  String get editProfileUpdated => 'Đã cập nhật hồ sơ';

  @override
  String get editProfileTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get editProfilePhotoLabel => 'Ảnh hồ sơ';

  @override
  String get editProfilePhotoSubtitle =>
      'Chọn avatar qua Supabase Storage sắp ra mắt';

  @override
  String get editProfileChangePhoto => 'Thay đổi';

  @override
  String get editProfileAvatarUploadSoon => 'Tải avatar lên sắp ra mắt';

  @override
  String get editProfileDisplayNameLabel => 'Tên hiển thị';

  @override
  String get editProfileDisplayNameHint => 'Tên của bạn';

  @override
  String get editProfileDisplayNameRequired => 'Nhập tên của bạn';

  @override
  String get editProfileDisplayNameTooShort => 'Quá ngắn';

  @override
  String get editProfileUsernameLabel => 'Tên người dùng';

  @override
  String get editProfileUsernameHint => 'minh_hoc_vien';

  @override
  String get editProfileUsernameRequired => 'Nhập tên người dùng';

  @override
  String get editProfileUsernameTooShort => 'Tối thiểu 3 ký tự';

  @override
  String get editProfileUsernameInvalid => 'Chỉ chữ, số, _';

  @override
  String get editProfileBioLabel => 'Tiểu sử';

  @override
  String get editProfileBioHint => 'Tiểu sử ngắn...';

  @override
  String get editProfileBioTooLong => 'Tối đa 120 ký tự';

  @override
  String get editProfileLocationLabel => 'Vị trí';

  @override
  String get editProfileLocationHint => 'Thành phố / Quốc gia';

  @override
  String get editProfileDailyGoalTitle => 'Mục tiêu hàng ngày';

  @override
  String get editProfileDailyGoalSubtitle =>
      'Chọn số phút bạn muốn học mỗi ngày';

  @override
  String get securityTitle => 'Bảo mật';

  @override
  String get securitySectionPassword => 'Mật khẩu';

  @override
  String get securityChangePasswordTitle => 'Đổi mật khẩu';

  @override
  String get securityChangePasswordSubtitle => 'Cập nhật mật khẩu thường xuyên';

  @override
  String get securitySectionTwoFactor => 'Xác thực hai yếu tố';

  @override
  String get securityEnable2faTitle => 'Bật 2FA';

  @override
  String get securityEnable2faSubtitle => 'Bảo vệ thêm khi đăng nhập';

  @override
  String get securitySectionAppLock => 'Khóa ứng dụng';

  @override
  String get securityBiometricTitle => 'Mở khóa sinh trắc học';

  @override
  String get securityBiometricSubtitle => 'Dùng FaceID/TouchID để mở SOMA';

  @override
  String get securityAppLockTitle => 'Khóa ứng dụng';

  @override
  String get securityAppLockSubtitle => 'Khóa SOMA khi thoát ứng dụng';

  @override
  String get securitySectionSessions => 'Phiên hoạt động';

  @override
  String get securityNoSessions => 'Không tìm thấy phiên hoạt động';

  @override
  String get securityThisDevice => 'Thiết bị này';

  @override
  String get securityDevice => 'Thiết bị';

  @override
  String get securityActiveLabel => 'Hoạt động';

  @override
  String get securitySignInToEnable2fa => 'Đăng nhập để bật 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'Bật 2FA thất bại: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'Tắt 2FA thất bại: $error';
  }

  @override
  String get securitySetup2faTitle => 'Thiết lập 2FA';

  @override
  String get securitySecretKeyLabel => 'Khóa bí mật';

  @override
  String get securityCodeHint => 'Mã 6 chữ số';

  @override
  String get security2faEnabled => '2FA đã bật';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'Xác minh mã thất bại: $error';
  }

  @override
  String get securityVerifying => 'Đang xác minh...';

  @override
  String get securityVerify => 'Xác minh';

  @override
  String get securityCurrentPasswordHint => 'Mật khẩu hiện tại';

  @override
  String get securityNewPasswordHint => 'Mật khẩu mới (tối thiểu 8 ký tự)';

  @override
  String get securityConfirmPasswordHint => 'Xác nhận mật khẩu mới';

  @override
  String get securitySignInToChangePassword => 'Đăng nhập để đổi mật khẩu';

  @override
  String get securityEnterCurrentPassword => 'Nhập mật khẩu hiện tại';

  @override
  String get securityPasswordMinLength =>
      'Mật khẩu mới phải có ít nhất 8 ký tự';

  @override
  String get securityPasswordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get securityPasswordUpdated => 'Đã cập nhật mật khẩu';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'Cập nhật mật khẩu thất bại: $error';
  }

  @override
  String get securityAutoLockAfter => 'Tự động khóa sau';

  @override
  String get privacyTitle => 'Quyền riêng tư';

  @override
  String get privacySectionVisibility => 'Hiển thị';

  @override
  String get privacyProfileVisibilityTitle => 'Hiển thị hồ sơ';

  @override
  String get privacyVisibilityPublic => 'Công khai';

  @override
  String get privacyVisibilityFriends => 'Bạn bè';

  @override
  String get privacyVisibilityPrivate => 'Riêng tư';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'Mọi người có thể xem hồ sơ của bạn';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'Chỉ bạn bè có thể xem hồ sơ của bạn';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'Chỉ bạn có thể xem hồ sơ của mình';

  @override
  String get privacySectionActivity => 'Hoạt động';

  @override
  String get privacyShowOnlineTitle => 'Hiện trạng thái trực tuyến';

  @override
  String get privacyShowOnlineSubtitle =>
      'Cho phép người khác xem khi bạn trực tuyến';

  @override
  String get privacyShowActivityTitle => 'Hiện hoạt động học tập';

  @override
  String get privacyShowActivitySubtitle => 'Hiện chuỗi, XP và tiến độ gần đây';

  @override
  String get privacySectionSocial => 'Xã hội';

  @override
  String get privacyAllowRequestsTitle => 'Cho phép yêu cầu kết bạn';

  @override
  String get privacyAllowRequestsSubtitle =>
      'Cho phép người khác gửi yêu cầu kết bạn';

  @override
  String get privacyWhoCanDmTitle => 'Ai có thể gửi tin nhắn riêng';

  @override
  String get privacyDmEveryone => 'Mọi người';

  @override
  String get privacyDmFriends => 'Bạn bè';

  @override
  String get privacyDmNoOne => 'Không ai';

  @override
  String get privacyDmEveryoneSubtitle =>
      'Bất kỳ ai cũng có thể nhắn tin cho bạn';

  @override
  String get privacyDmFriendsSubtitle => 'Chỉ bạn bè có thể nhắn tin cho bạn';

  @override
  String get privacyDmNoOneSubtitle => 'Không ai có thể nhắn tin cho bạn';

  @override
  String get privacySectionBlockedUsers => 'Người dùng bị chặn';

  @override
  String get privacyBlockedUsersComingSoon =>
      'Quản lý người dùng bị chặn sắp ra mắt';

  @override
  String get privacySectionDataControls => 'Kiểm soát dữ liệu';

  @override
  String get privacyExportDataTitle => 'Xuất dữ liệu của tôi';

  @override
  String get privacyExportDataSubtitle =>
      'Tải xuống hoạt động và khóa học của bạn';

  @override
  String get privacyExportInfoTitle => 'Xuất dữ liệu';

  @override
  String get privacyExportInfoBody =>
      'Bước tiếp theo: tạo xuất JSON/CSV và gửi email hoặc tải xuống cục bộ';

  @override
  String get privacyDeleteAccountTitle => 'Xóa tài khoản';

  @override
  String get privacyDeleteAccountSubtitle =>
      'Điều này sẽ xóa vĩnh viễn tài khoản và dữ liệu của bạn';

  @override
  String get privacyDeleteConfirmTitle => 'Xóa tài khoản?';

  @override
  String get privacyDeleteConfirmBody =>
      'Hành động này không thể hoàn tác. Hồ sơ, khóa học, bạn bè và tin nhắn của bạn sẽ bị xóa';

  @override
  String get privacyDeleteComingSoon => 'Xóa sẽ được kết nối với Supabase sau';

  @override
  String get soloLabel => 'Đơn';

  @override
  String get soloResultsCompletedTitle => 'Phiên đơn hoàn thành';

  @override
  String get soloResultsFeedbackElite => 'Thành tích ưu tú - giữ vững chuỗi';

  @override
  String get soloResultsFeedbackStrong => 'Làm tốt - bạn đang tiến bộ nhanh';

  @override
  String get soloResultsFeedbackProgress =>
      'Tiến bộ tốt - xem lại lỗi và thử lại';

  @override
  String get soloResultsFeedbackTryAgain =>
      'Không sao - thử lại với ít câu hỏi hơn và tập trung';

  @override
  String get soloResultsPerfectScore =>
      'Điểm hoàn hảo! Không có lỗi để xem lại';

  @override
  String get soloResultsReviewPrompt =>
      'Xem lại lỗi để học nhanh hơn. Câu trả lời sai của bạn ở dưới';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'Xem lại lỗi ($count)';
  }

  @override
  String get authNotSignedIn => 'Bạn chưa đăng nhập';

  @override
  String get genericUser => 'Người dùng';

  @override
  String get loading => 'Đang tải...';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get send => 'Gửi';

  @override
  String get join => 'Tham gia';

  @override
  String get leave => 'Rời';

  @override
  String get ready => 'Sẵn sàng';

  @override
  String get levelBeginner => 'Mới bắt đầu';

  @override
  String get levelIntermediate => 'Trung cấp';

  @override
  String get levelAdvanced => 'Nâng cao';

  @override
  String questionsShort(Object count) {
    return '$count câu hỏi';
  }

  @override
  String secondsShort(Object count) {
    return '$count giây';
  }

  @override
  String get circlesAllCourses => 'Tất cả khóa học';

  @override
  String get circlesAllModes => 'Tất cả chế độ';

  @override
  String get circlesAllLevels => 'Tất cả cấp độ';

  @override
  String get circlesAddNewCourse => 'Thêm khóa học mới';

  @override
  String get circlesCoursesTitle => 'Khóa học';

  @override
  String get circlesModeTitle => 'Chế độ';

  @override
  String get circlesLevelTitle => 'Cấp độ';

  @override
  String get circlesNoActiveForFilters =>
      'Không có Circle hoạt động cho các bộ lọc này';

  @override
  String get circlesUnknownRoom => 'Phòng không rõ';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Tạo Circle';

  @override
  String get circlesCircleName => 'Tên Circle';

  @override
  String get circlesEnterName => 'Nhập tên';

  @override
  String get circlesLanguages => 'Ngôn ngữ';

  @override
  String get circlesRoomSetup => 'Thiết lập phòng';

  @override
  String get circlesPlayers => 'Người chơi';

  @override
  String get circlesEmptySlot => 'Chỗ trống';

  @override
  String get circlesPlayersRange => '1-5 người chơi';

  @override
  String get circlesQuestions => 'Câu hỏi';

  @override
  String get circlesQuestionsSubtitle => 'Số lượng câu hỏi';

  @override
  String get circlesTimePerQuestion => 'Thời gian mỗi câu';

  @override
  String get circlesSecondsPerQuestion => 'giây mỗi câu';

  @override
  String get circlesAdvanced => 'Nâng cao';

  @override
  String get circlesAllowSpectators => 'Cho phép người xem';

  @override
  String get circlesAllowSpectatorsSubtitle =>
      'Cho phép người khác xem mà không chơi';

  @override
  String get circlesLiveVoiceChat => 'Trò chuyện thoại trực tiếp';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'Bật giao tiếp bằng giọng nói trong trận đấu';

  @override
  String get circlesLiveTextChat => 'Trò chuyện văn bản trực tiếp';

  @override
  String get circlesLiveTextChatSubtitle => 'Bật trò chuyện trong trận đấu';

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
  String get circlesCreatedSuccess => 'Đã tạo Circle';

  @override
  String circlesCreateError(Object error) {
    return 'Tạo Circle thất bại: $error';
  }

  @override
  String get circlesHostTip => 'Mẹo: bạn có thể mời bạn bè sau khi tạo';

  @override
  String circlesJoinError(Object error) {
    return 'Tham gia Circle thất bại: $error';
  }

  @override
  String get circlesLobbyTitle => 'Sảnh Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'Mã: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'Cài đặt trận đấu';

  @override
  String circlesLevelWithValue(Object level) {
    return 'Cấp độ $level';
  }

  @override
  String get circlesDifficulty => 'Độ khó';

  @override
  String get circlesPerQuestionShort => 'mỗi câu';

  @override
  String get circlesInvite => 'Mời';

  @override
  String get circlesCopyId => 'Sao chép ID';

  @override
  String get circlesCopiedId => 'Đã sao chép ID';

  @override
  String get circlesMatchInProgress => 'Trận đấu đang diễn ra';

  @override
  String get circlesSpectatorQueuedBody =>
      'Trận đấu đang diễn ra. Bạn sẽ tham gia với tư cách người xem';

  @override
  String get circlesHostStartWhenReady =>
      'Chủ phòng sẽ bắt đầu khi mọi người sẵn sàng';

  @override
  String get circlesSpectators => 'Người xem';

  @override
  String get circlesSpectator => 'Người xem';

  @override
  String get circlesSpectatorCanWatch => 'Người xem có thể xem trực tiếp';

  @override
  String get circlesJoinRequests => 'Yêu cầu tham gia';

  @override
  String get circlesAcceptSpectatorsHint =>
      'Chấp nhận người xem trước khi bắt đầu trận đấu';

  @override
  String get circlesStartGame => 'Bắt đầu trò chơi';

  @override
  String get circlesStartingGame => 'Starting game...';

  @override
  String get circlesWaitingForPlayers => 'Đang chờ người chơi';

  @override
  String get circlesLeaveCircle => 'Rời Circle';

  @override
  String get circlesRequestSent => 'Đã gửi yêu cầu';

  @override
  String get circlesRequestToJoin => 'Yêu cầu tham gia';

  @override
  String get circlesWatchLive => 'Xem trực tiếp';

  @override
  String get circlesPlayerTip =>
      'Nhấn Sẵn sàng khi bạn ổn. Chủ phòng sẽ bắt đầu trận đấu';

  @override
  String get circlesSpectatorTip =>
      'Bạn đang xem. Xem trực tiếp khi chủ phòng bắt đầu';

  @override
  String get circlesHostControls => 'Điều khiển chủ phòng';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'Chuyển chủ phòng thất bại: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Kết thúc Circle thất bại: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'Không tìm thấy người dùng @$username';
  }

  @override
  String get circlesInvalidUser => 'Người dùng không hợp lệ';

  @override
  String get circlesCantInviteSelf => 'Bạn không thể mời chính mình';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username đã ở trong Circle';
  }

  @override
  String get circlesDefaultHost => 'Chủ phòng';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'Mời theo tên người dùng';

  @override
  String circlesInviteSent(Object username) {
    return 'Đã gửi lời mời đến @$username';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'Gửi lời mời thất bại: $error';
  }

  @override
  String get circlesJoinRequestSent => 'Đã gửi yêu cầu tham gia';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'Gửi yêu cầu thất bại: $error';
  }

  @override
  String get circlesFull => 'Circle đã đầy';

  @override
  String get circlesSpectatorAdded => 'Đã thêm người xem';

  @override
  String circlesApproveFailed(Object error) {
    return 'Phê duyệt yêu cầu thất bại: $error';
  }

  @override
  String get circlesRequestDeclined => 'Đã từ chối yêu cầu';

  @override
  String circlesDeclineFailed(Object error) {
    return 'Từ chối yêu cầu thất bại: $error';
  }

  @override
  String get circlesParticipant => 'Người tham gia';

  @override
  String get circlesLeavePromptTitle => 'Rời Circle?';

  @override
  String get circlesLeavePromptTransfer =>
      'Vui lòng chuyển chủ phòng trước khi rời';

  @override
  String get circlesLeavePromptEndOnly => 'Kết thúc Circle và rời';

  @override
  String get circlesTransferHost => 'Chuyển chủ phòng';

  @override
  String get circlesEndCircle => 'Kết thúc Circle';

  @override
  String get circlesTransferHostTitle => 'Chuyển chủ phòng';

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
