// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => '배우고. 경쟁하고. 마스터하세요.';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => '가입하기';

  @override
  String get signIn => '로그인';

  @override
  String get skipForNow => '지금은 건너뛰기';

  @override
  String get authFillAllFields => '모든 필드를 입력해주세요';

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
    return '오류: $error';
  }

  @override
  String get authEmail => '이메일';

  @override
  String get authPassword => '비밀번호';

  @override
  String get authUsername => '사용자 이름';

  @override
  String get authContinue => '계속';

  @override
  String get authSigningIn => '로그인 중...';

  @override
  String get authCreateAccount => '계정 만들기';

  @override
  String get authCreating => '생성 중...';

  @override
  String get authNeedAccount => '계정이 없으신가요? ';

  @override
  String get authHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get dialogAuthRequiredTitle => 'Circles에 접근하려면 로그인하세요';

  @override
  String get dialogAuthRequiredBody =>
      'Circles는 멀티플레이어 룸입니다. 계정을 만들어 라이브 매치에 참여하고, 친구를 초대하고, 진행 상황을 저장하세요.';

  @override
  String get notNow => '나중에';

  @override
  String get navHome => '홈';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => '프로필';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => '코스를 삭제하시겠습니까?';

  @override
  String removeCourseBody(Object course) {
    return '홈 목록에서 $course를 제거합니다.';
  }

  @override
  String get cancel => '취소';

  @override
  String get remove => '삭제';

  @override
  String welcomeBack(Object name) {
    return '환영합니다, $name님!';
  }

  @override
  String get editCourses => '코스 편집';

  @override
  String get done => '완료';

  @override
  String get noCoursesToEdit => '편집할 코스가 없습니다.';

  @override
  String get addCourse => '코스 추가';

  @override
  String get unknown => '알 수 없음';

  @override
  String get iSpeak => '사용 언어';

  @override
  String get iWantToLearn => '배우고 싶은 언어';

  @override
  String get chooseYourLanguage => '언어 선택';

  @override
  String get chooseLearningLanguage => '배우고 싶은 언어를 선택하세요';

  @override
  String get chooseTwoDifferentLanguages => '두 개의 다른 언어를 선택해주세요.';

  @override
  String get createCourse => '코스 만들기';

  @override
  String get soloCourseTitle => '솔로 코스';

  @override
  String get searchLanguage => '언어 검색';

  @override
  String get noMatches => '일치하는 항목 없음';

  @override
  String get chooseCourseType => '코스 유형 선택';

  @override
  String get soloStudyDescription =>
      'Circles 스타일의 퀴즈로 혼자 공부하세요 - 룸, 채팅, 관전자, 호스트 옵션 없음.';

  @override
  String get soloModeVocabulary => '어휘';

  @override
  String get soloModeSentences => '문장';

  @override
  String get soloModeReview => '복습';

  @override
  String get soloModeVocabularySubtitle => '의미, 동의어, 사용법 객관식';

  @override
  String get soloModeSentencesSubtitle => '빈칸 채우기 + 번역 + 읽기';

  @override
  String get soloModeReviewDescription => '배운 내용을 연습하세요: 약한 단어, 최근 실수, 간격 반복.';

  @override
  String get startReview => '복습 시작';

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
    return '$mode 설정';
  }

  @override
  String get difficulty => '난이도';

  @override
  String get numberOfQuestions => '문제 수';

  @override
  String get timerPerQuestion => '문제당 타이머';

  @override
  String get noTimer => '타이머 없음';

  @override
  String get start => '시작';

  @override
  String get profileTitle => '프로필';

  @override
  String get profileSignInToMessage => '메시지를 보내려면 로그인하세요';

  @override
  String get profileThatsYourProfile => '이것은 당신의 프로필입니다';

  @override
  String get profileSignInToAddFriends => '친구를 추가하려면 로그인하세요';

  @override
  String get profileCantAddYourself => '자신을 추가할 수 없습니다';

  @override
  String profileRequestSent(Object username) {
    return '@$username에게 요청을 보냈습니다';
  }

  @override
  String get profileRequestFailed => '요청 전송 실패';

  @override
  String get profileDefaultDisplayName => '새 사용자';

  @override
  String get profileDefaultBio => '배울 준비 완료!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => '게스트';

  @override
  String get guestUsername => '게스트';

  @override
  String get guestSessionLabel => '게스트 세션';

  @override
  String get unlockFullProfile => '전체 프로필 잠금 해제';

  @override
  String get guestBenefitSync => '모든 기기에서 진행 상황 동기화';

  @override
  String get guestBenefitCircles => 'Circles에 참여하여 라이브 플레이';

  @override
  String get guestBenefitNotifications => '알림 및 친구 요청 받기';

  @override
  String get progressStaysOnDevice => '로그인하기 전까지 진행 상황은 이 기기에 저장됩니다.';

  @override
  String profileGoalLabel(Object minutes) {
    return '목표: $minutes분';
  }

  @override
  String get profileXpProgress => '경험치 진행 상황';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => '승리';

  @override
  String get profileStreak => '연속 일수';

  @override
  String get profileFriendsTitle => '친구';

  @override
  String get profileViewAll => '전체 보기';

  @override
  String get profileAchievementsTitle => '업적';

  @override
  String get profileNoAchievements => '아직 업적이 없습니다.';

  @override
  String get profileRequested => '요청됨';

  @override
  String get profileSending => '전송 중...';

  @override
  String get profileAddFriend => '친구 추가';

  @override
  String get profileConnectTitle => '연결';

  @override
  String get profileMessage => '메시지';

  @override
  String get profileSnapshot => '프로필 스냅샷';

  @override
  String get profileLocationHidden => '위치 숨김';

  @override
  String get profileBioHidden => '소개 숨김';

  @override
  String profileDailyGoal(Object minutes) {
    return '일일 목표 $minutes분';
  }

  @override
  String get circleInviteTitle => 'Circle 초대';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => '참여하려면 로그인하세요';

  @override
  String get joiningCircle => '참여 중...';

  @override
  String get joinCircle => 'Circle 참여';

  @override
  String get circleJoinedAsPlayer => '플레이어로 참여했습니다';

  @override
  String get circleJoinedAsSpectator => '관전자로 참여했습니다';

  @override
  String get accept => '수락';

  @override
  String get decline => '거절';

  @override
  String get open => '열기';

  @override
  String get circleCountdownTitle => '준비하세요';

  @override
  String get circleCountdownSubtitle => 'Circle이 시작됩니다...';

  @override
  String get userFallbackName => '사용자';

  @override
  String get micOff => '마이크 끄기';

  @override
  String get micOn => '마이크 켜기';

  @override
  String get roleHost => '호스트';

  @override
  String get roleSpectator => '관전자';

  @override
  String get tagHost => '호스트';

  @override
  String get tagYou => '나';

  @override
  String get statusCorrect => '정답';

  @override
  String get statusWrong => '오답';

  @override
  String get statusWaiting => '대기 중';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => '점';

  @override
  String get pointsLabel => '점수';

  @override
  String get statCorrect => '정답';

  @override
  String get statAnswers => '답변';

  @override
  String get statTotal => '합계';

  @override
  String get statQuestions => '문제';

  @override
  String get statAccuracy => '정확도';

  @override
  String get statRate => '비율';

  @override
  String get statRank => '순위';

  @override
  String get statPosition => '위치';

  @override
  String get statMode => '모드';

  @override
  String get statType => '유형';

  @override
  String get next => '다음';

  @override
  String get submit => '제출';

  @override
  String get continueLabel => '계속';

  @override
  String get save => '저장';

  @override
  String get playAgain => '다시 플레이';

  @override
  String get backToCourse => '코스로 돌아가기';

  @override
  String get resultsTitle => '결과';

  @override
  String get shareLater => '나중에 공유';

  @override
  String get delete => '삭제';

  @override
  String get ok => '확인';

  @override
  String minutesShort(Object minutes) {
    return '$minutes분';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count분';
  }

  @override
  String timeShortHours(Object count) {
    return '$count시간';
  }

  @override
  String timeShortDays(Object count) {
    return '$count일';
  }

  @override
  String get timeJustNow => '방금';

  @override
  String timeMinutesAgo(Object count) {
    return '$count분 전';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count시간 전';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count일 전';
  }

  @override
  String get liveQuizWaitingForHost => '호스트 대기 중...';

  @override
  String get liveQuizJoinRequestSent => '참여 요청을 보냈습니다';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return '요청 실패: $error';
  }

  @override
  String get liveQuizHostControlsTitle => '호스트 컨트롤';

  @override
  String get liveQuizSpectatorModeTitle => '관전 모드';

  @override
  String get liveQuizHostControlsSubtitle =>
      '모든 사람이 답변하거나 시간이 초과되면 라운드가 자동으로 진행됩니다.';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      '질문과 리더보드를 실시간으로 시청합니다. 답변할 수 없습니다.';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return '질문 $current/$total';
  }

  @override
  String get liveQuizRequestSent => '요청을 보냈습니다';

  @override
  String get liveQuizRequestToJoin => '참여 요청';

  @override
  String get liveQuizSpectatorFooter => '실시간 시청 중입니다. 질문과 리더보드를 즐기세요.';

  @override
  String get circleNotFound => 'Circle을 찾을 수 없습니다';

  @override
  String resultsRematchStartFailed(Object error) {
    return '재대결 시작 실패: $error';
  }

  @override
  String get resultsMatchTitle => '매치 결과';

  @override
  String resultsNiceWork(Object name) {
    return '잘했어요, $name님';
  }

  @override
  String get resultsPlaceFirst => '1위';

  @override
  String get resultsPlaceSecond => '2위';

  @override
  String get resultsPlaceThird => '3위';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank위';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players명 중';
  }

  @override
  String get resultsHighlightChampion => '챔피언! 이 Circle을 정복했습니다.';

  @override
  String get resultsHighlightGreatAccuracy => '훌륭한 정확도. 거의 1위에 가깝습니다!';

  @override
  String get resultsHighlightKeepGoing => '계속 하세요 - 안정성이 속도를 이깁니다.';

  @override
  String get resultsLeaderboardTitle => '리더보드';

  @override
  String resultsPlayersCount(Object count) {
    return '$count명의 플레이어';
  }

  @override
  String get resultsBackToCircles => 'Circles로 돌아가기';

  @override
  String get resultsRematch => '재대결';

  @override
  String get resultsPlayAgain => '다시 플레이';

  @override
  String get leaderboardGlobalTitle => '글로벌 리더보드';

  @override
  String get leaderboardEmpty => '아직 리더보드가 없습니다.';

  @override
  String get aboutTitle => '정보';

  @override
  String aboutVersion(Object version) {
    return '버전 $version';
  }

  @override
  String get aboutDescription =>
      'SOMA는 새로운 언어를 배우는 것을 재미있고 사회적으로 만드는 게임화 언어 학습 플랫폼입니다. Circles에 참여하고, 혼자 연습하고, 진행 상황을 추적하세요.';

  @override
  String get aboutTerms => '이용 약관';

  @override
  String get aboutPrivacy => '개인정보 보호정책';

  @override
  String get aboutOpenSource => '오픈소스 라이선스';

  @override
  String get addFriendTitle => '친구 추가';

  @override
  String get addFriendFindByUsername => '사용자 이름으로 찾기';

  @override
  String get addFriendUsernameHint => '사용자 이름 입력...';

  @override
  String get addFriendTip => '팁: 나중에 QR 코드 + 친구 ID를 지원할 수 있습니다.';

  @override
  String get addFriendSending => '전송 중...';

  @override
  String get addFriendSendRequest => '요청 보내기';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$username을(를) 찾을 수 없습니다';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return '작업 실패 또는 이미 전송됨: $error';
  }

  @override
  String get friendsTitle => '친구';

  @override
  String get searchFriendsHint => '친구 검색...';

  @override
  String get somaLearnerSubtitle => 'Soma 학습자';

  @override
  String get friendRequestLabel => '요청';

  @override
  String get friendRequestSentLabel => '요청 전송됨';

  @override
  String get friendIncomingRequestLabel => '받은 요청';

  @override
  String get friendRequestsSection => '요청';

  @override
  String get friendPendingSection => '대기 중';

  @override
  String get friendAllSection => '모든 친구';

  @override
  String get friendsEmptyState => '아직 친구가 없습니다. 첫 번째 친구를 추가하세요!';

  @override
  String get friendsEmptyShort => '아직 친구가 없습니다.';

  @override
  String noMatchForQuery(Object query) {
    return '\\\"$query\\\"에 일치하는 항목 없음';
  }

  @override
  String get inboxTitle => '받은편지함';

  @override
  String get searchChatsHint => '채팅 검색...';

  @override
  String get inboxEmptyState => '아직 채팅이 없습니다. 친구와 채팅을 시작하세요!';

  @override
  String get newMessageTitle => '새 메시지';

  @override
  String get chatCallLater => '나중에 음성 통화 (Circle 언어 곧 출시)';

  @override
  String errorWithDetails(Object error) {
    return '오류: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$name님에게 인사하세요!';
  }

  @override
  String get chatMessageHint => '메시지...';

  @override
  String get notificationsTitle => '알림';

  @override
  String get notificationsTabAll => '전체';

  @override
  String get notificationsTabCourses => '코스';

  @override
  String get notificationsTabSocial => '소셜';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => '시스템';

  @override
  String get notificationsEmpty => '여기에 알림이 없습니다.';

  @override
  String get notificationsDeleted => '알림을 삭제했습니다';

  @override
  String get notificationTitleFallback => '알림';

  @override
  String get notificationTypeCourse => '코스';

  @override
  String get notificationTypeSocial => '소셜';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => '시스템';

  @override
  String get notificationsFriendAccepted => '친구 요청을 수락했습니다';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return '친구 요청 수락 실패: $error';
  }

  @override
  String get notificationsFriendDeclined => '친구 요청을 거절했습니다';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return '친구 요청 거절 실패: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circle 참여 실패: $error';
  }

  @override
  String get notificationsOpening => '여는 중';

  @override
  String get notificationsOpened => '열었습니다';

  @override
  String notificationsActionMessage(Object action) {
    return '$action 알림';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSectionAccount => '계정';

  @override
  String get settingsEditProfile => '프로필 편집';

  @override
  String get settingsPrivacy => '개인정보';

  @override
  String get settingsSecurity => '보안';

  @override
  String get settingsSectionGameplay => '게임플레이';

  @override
  String get settingsShowTranslationLine => '번역 줄 표시';

  @override
  String get settingsShowReadingLine => '읽기 표시 (병음/로마자)';

  @override
  String get settingsDefaultTimerPerQuestion => '문제당 기본 타이머';

  @override
  String get settingsMatchDifficulty => '매치 난이도';

  @override
  String get settingsMatchDifficultyAdaptive => '적응형';

  @override
  String get settingsSectionSoundFeel => '사운드 및 느낌';

  @override
  String get settingsMusic => '음악';

  @override
  String get settingsSoundEffects => '효과음';

  @override
  String get settingsHaptics => '햅틱 피드백';

  @override
  String get settingsSectionNotifications => '알림';

  @override
  String get settingsPushNotifications => '푸시 알림';

  @override
  String get settingsDailyReminder => '일일 알림';

  @override
  String get settingsSectionAppearance => '모양';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsUiLanguage => 'UI 언어';

  @override
  String get settingsSectionAbout => '정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsTermsPrivacy => '약관 및 개인정보';

  @override
  String get settingsSupport => '지원';

  @override
  String get settingsLogout => '로그아웃';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeDark => '다크';

  @override
  String get themeLight => '라이트';

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
  String get editProfileUpdated => '프로필을 업데이트했습니다';

  @override
  String get editProfileTitle => '프로필 편집';

  @override
  String get editProfilePhotoLabel => '프로필 사진';

  @override
  String get editProfilePhotoSubtitle => 'Supabase Storage를 통한 아바타 선택 곧 출시.';

  @override
  String get editProfileChangePhoto => '변경';

  @override
  String get editProfileAvatarUploadSoon => '아바타 업로드 곧 출시';

  @override
  String get editProfileDisplayNameLabel => '표시 이름';

  @override
  String get editProfileDisplayNameHint => '당신의 이름';

  @override
  String get editProfileDisplayNameRequired => '이름을 입력하세요';

  @override
  String get editProfileDisplayNameTooShort => '너무 짧습니다';

  @override
  String get editProfileUsernameLabel => '사용자 이름';

  @override
  String get editProfileUsernameHint => 'kim_learner';

  @override
  String get editProfileUsernameRequired => '사용자 이름을 입력하세요';

  @override
  String get editProfileUsernameTooShort => '최소 3자';

  @override
  String get editProfileUsernameInvalid => '문자, 숫자, _만 가능';

  @override
  String get editProfileBioLabel => '소개';

  @override
  String get editProfileBioHint => '짧은 자기소개...';

  @override
  String get editProfileBioTooLong => '최대 120자';

  @override
  String get editProfileLocationLabel => '위치';

  @override
  String get editProfileLocationHint => '도시 / 국가';

  @override
  String get editProfileDailyGoalTitle => '일일 목표';

  @override
  String get editProfileDailyGoalSubtitle => '매일 얼마나 공부하고 싶은지 선택하세요.';

  @override
  String get securityTitle => '보안';

  @override
  String get securitySectionPassword => '비밀번호';

  @override
  String get securityChangePasswordTitle => '비밀번호 변경';

  @override
  String get securityChangePasswordSubtitle => '정기적으로 비밀번호를 업데이트하세요.';

  @override
  String get securitySectionTwoFactor => '2단계 인증';

  @override
  String get securityEnable2faTitle => '2FA 활성화';

  @override
  String get securityEnable2faSubtitle => '로그인 시 추가 보안.';

  @override
  String get securitySectionAppLock => '앱 잠금';

  @override
  String get securityBiometricTitle => '생체 인증 잠금 해제';

  @override
  String get securityBiometricSubtitle => 'Face ID/Touch ID로 SOMA 잠금 해제.';

  @override
  String get securityAppLockTitle => '앱 잠금';

  @override
  String get securityAppLockSubtitle => '종료 시 SOMA 잠금.';

  @override
  String get securitySectionSessions => '활성 세션';

  @override
  String get securityNoSessions => '활성 세션을 찾을 수 없습니다.';

  @override
  String get securityThisDevice => '이 기기';

  @override
  String get securityDevice => '기기';

  @override
  String get securityActiveLabel => '활성';

  @override
  String get securitySignInToEnable2fa => '2FA를 활성화하려면 로그인하세요';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FA 활성화 실패: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FA 비활성화 실패: $error';
  }

  @override
  String get securitySetup2faTitle => '2FA 설정';

  @override
  String get securitySecretKeyLabel => '비밀 키';

  @override
  String get securityCodeHint => '6자리 코드';

  @override
  String get security2faEnabled => '2FA를 활성화했습니다';

  @override
  String securityVerifyCodeFailed(Object error) {
    return '코드 확인 실패: $error';
  }

  @override
  String get securityVerifying => '확인 중...';

  @override
  String get securityVerify => '확인';

  @override
  String get securityCurrentPasswordHint => '현재 비밀번호';

  @override
  String get securityNewPasswordHint => '새 비밀번호 (최소 8자)';

  @override
  String get securityConfirmPasswordHint => '새 비밀번호 확인';

  @override
  String get securitySignInToChangePassword => '비밀번호를 변경하려면 로그인하세요';

  @override
  String get securityEnterCurrentPassword => '현재 비밀번호를 입력하세요';

  @override
  String get securityPasswordMinLength => '새 비밀번호는 최소 8자 이상이어야 합니다';

  @override
  String get securityPasswordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get securityPasswordUpdated => '비밀번호를 업데이트했습니다';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return '비밀번호 업데이트 실패: $error';
  }

  @override
  String get securityAutoLockAfter => '자동 잠금까지';

  @override
  String get privacyTitle => '개인정보';

  @override
  String get privacySectionVisibility => '공개 범위';

  @override
  String get privacyProfileVisibilityTitle => '프로필 공개 범위';

  @override
  String get privacyVisibilityPublic => '공개';

  @override
  String get privacyVisibilityFriends => '친구';

  @override
  String get privacyVisibilityPrivate => '비공개';

  @override
  String get privacyVisibilityPublicSubtitle => '누구나 프로필을 볼 수 있습니다.';

  @override
  String get privacyVisibilityFriendsSubtitle => '친구만 프로필을 볼 수 있습니다.';

  @override
  String get privacyVisibilityPrivateSubtitle => '나만 프로필을 볼 수 있습니다.';

  @override
  String get privacySectionActivity => '활동';

  @override
  String get privacyShowOnlineTitle => '온라인 상태 표시';

  @override
  String get privacyShowOnlineSubtitle => '다른 사람이 온라인 상태를 볼 수 있습니다.';

  @override
  String get privacyShowActivityTitle => '학습 활동 표시';

  @override
  String get privacyShowActivitySubtitle => '연속 일수, XP, 현재 진행 상황 표시.';

  @override
  String get privacySectionSocial => '소셜';

  @override
  String get privacyAllowRequestsTitle => '친구 요청 허용';

  @override
  String get privacyAllowRequestsSubtitle => '다른 사람이 친구 요청을 보낼 수 있습니다.';

  @override
  String get privacyWhoCanDmTitle => 'DM을 보낼 수 있는 사람';

  @override
  String get privacyDmEveryone => '모든 사람';

  @override
  String get privacyDmFriends => '친구';

  @override
  String get privacyDmNoOne => '없음';

  @override
  String get privacyDmEveryoneSubtitle => '누구나 DM을 보낼 수 있습니다.';

  @override
  String get privacyDmFriendsSubtitle => '친구만 DM을 보낼 수 있습니다.';

  @override
  String get privacyDmNoOneSubtitle => '아무도 DM을 보낼 수 없습니다.';

  @override
  String get privacySectionBlockedUsers => '차단된 사용자';

  @override
  String get privacyBlockedUsersComingSoon => '차단된 사용자 관리 곧 출시.';

  @override
  String get privacySectionDataControls => '데이터 관리';

  @override
  String get privacyExportDataTitle => '데이터 내보내기';

  @override
  String get privacyExportDataSubtitle => '활동 및 코스 다운로드.';

  @override
  String get privacyExportInfoTitle => '데이터 내보내기';

  @override
  String get privacyExportInfoBody =>
      '다음 단계: JSON/CSV 내보내기를 만들어 이메일로 보내거나 로컬로 다운로드합니다.';

  @override
  String get privacyDeleteAccountTitle => '계정 삭제';

  @override
  String get privacyDeleteAccountSubtitle => '계정과 데이터가 영구적으로 삭제됩니다.';

  @override
  String get privacyDeleteConfirmTitle => '계정을 삭제하시겠습니까?';

  @override
  String get privacyDeleteConfirmBody =>
      '이 작업은 영구적입니다. 프로필, 코스, 친구, 메시지가 삭제됩니다.';

  @override
  String get privacyDeleteComingSoon => '삭제 기능은 나중에 Supabase에 연결됩니다';

  @override
  String get soloLabel => '솔로';

  @override
  String get soloResultsCompletedTitle => '솔로 세션 완료';

  @override
  String get soloResultsFeedbackElite => '엘리트 성과. 연속 기록을 유지하세요.';

  @override
  String get soloResultsFeedbackStrong => '강력합니다. 빠르게 향상되고 있습니다.';

  @override
  String get soloResultsFeedbackProgress => '좋은 진전. 실수를 복습하고 반복하세요.';

  @override
  String get soloResultsFeedbackTryAgain => '스트레스 없이. 적은 문제와 집중으로 다시 시도하세요.';

  @override
  String get soloResultsPerfectScore => '완벽한 점수! 복습할 실수가 없습니다.';

  @override
  String get soloResultsReviewPrompt => '더 빨리 배우기 위해 실수를 복습하세요. 오답은 아래와 같습니다.';

  @override
  String soloResultsReviewMistakes(Object count) {
    return '실수 복습 ($count)';
  }

  @override
  String get authNotSignedIn => '로그인되지 않음';

  @override
  String get genericUser => '사용자';

  @override
  String get loading => '로딩 중...';

  @override
  String get edit => '편집';

  @override
  String get send => '보내기';

  @override
  String get join => '참여';

  @override
  String get leave => '나가기';

  @override
  String get ready => '준비';

  @override
  String get levelBeginner => '초급';

  @override
  String get levelIntermediate => '중급';

  @override
  String get levelAdvanced => '고급';

  @override
  String questionsShort(Object count) {
    return '$count문제';
  }

  @override
  String secondsShort(Object count) {
    return '$count초';
  }

  @override
  String get circlesAllCourses => '모든 코스';

  @override
  String get circlesAllModes => '모든 모드';

  @override
  String get circlesAllLevels => '모든 레벨';

  @override
  String get circlesAddNewCourse => '새 코스 추가';

  @override
  String get circlesCoursesTitle => '코스';

  @override
  String get circlesModeTitle => '모드';

  @override
  String get circlesLevelTitle => '레벨';

  @override
  String get circlesNoActiveForFilters => '이 필터에 활성 Circle이 없습니다.';

  @override
  String get circlesUnknownRoom => '알 수 없는 룸';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circle 만들기';

  @override
  String get circlesCircleName => 'Circle 이름';

  @override
  String get circlesEnterName => '이름 입력';

  @override
  String get circlesLanguages => '언어';

  @override
  String get circlesRoomSetup => '룸 설정';

  @override
  String get circlesPlayers => '플레이어';

  @override
  String get circlesEmptySlot => '빈 슬롯';

  @override
  String get circlesPlayersRange => '1-5명의 플레이어';

  @override
  String get circlesQuestions => '문제';

  @override
  String get circlesQuestionsSubtitle => '문제 수';

  @override
  String get circlesTimePerQuestion => '문제당 시간';

  @override
  String get circlesSecondsPerQuestion => '문제당 초';

  @override
  String get circlesAdvanced => '고급';

  @override
  String get circlesAllowSpectators => '관전자 허용';

  @override
  String get circlesAllowSpectatorsSubtitle => '다른 사람이 플레이하지 않고 시청할 수 있습니다.';

  @override
  String get circlesLiveVoiceChat => '라이브 음성 채팅';

  @override
  String get circlesLiveVoiceChatSubtitle => '매치 중 라이브 음성 활성화.';

  @override
  String get circlesLiveTextChat => '라이브 텍스트 채팅';

  @override
  String get circlesLiveTextChatSubtitle => '매치 중 채팅 활성화.';

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
  String get circlesCreatedSuccess => 'Circle을 만들었습니다';

  @override
  String circlesCreateError(Object error) {
    return 'Circle 생성 실패: $error';
  }

  @override
  String get circlesHostTip => '팁: 만든 후 친구를 초대할 수 있습니다.';

  @override
  String circlesJoinError(Object error) {
    return 'Circle 참여 실패: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circle 로비';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return '코드: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => '매치 설정';

  @override
  String circlesLevelWithValue(Object level) {
    return '레벨 $level';
  }

  @override
  String get circlesDifficulty => '난이도';

  @override
  String get circlesPerQuestionShort => '문제당';

  @override
  String get circlesInvite => '초대';

  @override
  String get circlesCopyId => 'ID 복사';

  @override
  String get circlesCopiedId => 'ID를 복사했습니다';

  @override
  String get circlesMatchInProgress => '매치 진행 중';

  @override
  String get circlesSpectatorQueuedBody => '매치 진행 중. 관전자로 참여합니다.';

  @override
  String get circlesHostStartWhenReady => '모두 준비되면 호스트가 시작합니다.';

  @override
  String get circlesSpectators => '관전자';

  @override
  String get circlesSpectator => '관전자';

  @override
  String get circlesSpectatorCanWatch => '관전자는 실시간으로 시청할 수 있습니다.';

  @override
  String get circlesJoinRequests => '참여 요청';

  @override
  String get circlesAcceptSpectatorsHint => '매치 시작 전에 관전자를 승인하세요.';

  @override
  String get circlesStartGame => '게임 시작';

  @override
  String get circlesWaitingForPlayers => '플레이어 대기 중';

  @override
  String get circlesLeaveCircle => 'Circle 나가기';

  @override
  String get circlesRequestSent => '요청을 보냈습니다';

  @override
  String get circlesRequestToJoin => '참여 요청';

  @override
  String get circlesWatchLive => '실시간 시청';

  @override
  String get circlesPlayerTip => '준비가 되면 준비를 탭하세요. 호스트가 매치를 시작합니다.';

  @override
  String get circlesSpectatorTip => '시청 중입니다. 호스트가 시작하면 실시간으로 시청하세요.';

  @override
  String get circlesHostControls => '호스트 컨트롤';

  @override
  String circlesTransferHostFailed(Object error) {
    return '호스트 이전 실패: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circle 종료 실패: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$username을(를) 찾을 수 없습니다';
  }

  @override
  String get circlesInvalidUser => '유효하지 않은 사용자';

  @override
  String get circlesCantInviteSelf => '자신을 초대할 수 없습니다';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username은(는) 이미 Circle에 있습니다';
  }

  @override
  String get circlesDefaultHost => '호스트';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => '사용자 이름으로 초대';

  @override
  String circlesInviteSent(Object username) {
    return '@$username에게 초대를 보냈습니다';
  }

  @override
  String circlesInviteFailed(Object error) {
    return '초대 전송 실패: $error';
  }

  @override
  String get circlesJoinRequestSent => '참여 요청을 보냈습니다';

  @override
  String circlesJoinRequestFailed(Object error) {
    return '요청 실패: $error';
  }

  @override
  String get circlesFull => 'Circle이 가득 찼습니다';

  @override
  String get circlesSpectatorAdded => '관전자를 추가했습니다';

  @override
  String circlesApproveFailed(Object error) {
    return '요청 승인 실패: $error';
  }

  @override
  String get circlesRequestDeclined => '요청을 거절했습니다';

  @override
  String circlesDeclineFailed(Object error) {
    return '요청 거절 실패: $error';
  }

  @override
  String get circlesParticipant => '참가자';

  @override
  String get circlesLeavePromptTitle => 'Circle을 나가시겠습니까?';

  @override
  String get circlesLeavePromptTransfer => '나가기 전에 호스트를 이전하세요.';

  @override
  String get circlesLeavePromptEndOnly => 'Circle을 종료하고 나갑니다.';

  @override
  String get circlesTransferHost => '호스트 이전';

  @override
  String get circlesEndCircle => 'Circle 종료';

  @override
  String get circlesTransferHostTitle => '호스트 이전';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
