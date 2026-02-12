// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => '学ぶ。競う。マスターする。';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'サインアップ';

  @override
  String get signIn => 'サインイン';

  @override
  String get skipForNow => '今はスキップ';

  @override
  String get authFillAllFields => 'すべてのフィールドを入力してください';

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
    return 'エラー: $error';
  }

  @override
  String get authEmail => 'メール';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authUsername => 'ユーザー名';

  @override
  String get authContinue => '続ける';

  @override
  String get authSigningIn => 'サインイン中...';

  @override
  String get authCreateAccount => 'アカウント作成';

  @override
  String get authCreating => '作成中...';

  @override
  String get authNeedAccount => 'アカウントをお持ちでないですか？ ';

  @override
  String get authHaveAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get dialogAuthRequiredTitle => 'Circlesにアクセスするにはサインインしてください';

  @override
  String get dialogAuthRequiredBody =>
      'Circlesはマルチプレイヤールームです。ライブマッチに参加し、友達を招待し、進捗を保存するにはアカウントを作成してください。';

  @override
  String get notNow => '今はしない';

  @override
  String get navHome => 'ホーム';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'コースを削除しますか？';

  @override
  String removeCourseBody(Object course) {
    return '$courseをホームリストから削除します。';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get remove => '削除';

  @override
  String welcomeBack(Object name) {
    return 'おかえりなさい、$nameさん！';
  }

  @override
  String get editCourses => 'コース編集';

  @override
  String get done => '完了';

  @override
  String get noCoursesToEdit => '編集するコースがありません。';

  @override
  String get addCourse => 'コースを追加';

  @override
  String get unknown => '不明';

  @override
  String get iSpeak => '話せる言語';

  @override
  String get iWantToLearn => '学びたい言語';

  @override
  String get chooseYourLanguage => '言語を選択';

  @override
  String get chooseLearningLanguage => '学習する言語を選択してください';

  @override
  String get chooseTwoDifferentLanguages => '2つの異なる言語を選択してください。';

  @override
  String get createCourse => 'コースを作成';

  @override
  String get soloCourseTitle => 'ソロコース';

  @override
  String get searchLanguage => '言語を検索';

  @override
  String get noMatches => '一致なし';

  @override
  String get chooseCourseType => 'コースタイプを選択';

  @override
  String get soloStudyDescription =>
      'Circles スタイルのクイズで一人で学習 - ルーム、チャット、観戦者、ホストオプションなし。';

  @override
  String get soloModeVocabulary => '語彙';

  @override
  String get soloModeSentences => '文章';

  @override
  String get soloModeReview => '復習';

  @override
  String get soloModeVocabularySubtitle => '意味、類義語、用法の選択問題';

  @override
  String get soloModeSentencesSubtitle => '穴埋め + 翻訳 + 読み';

  @override
  String get soloModeReviewDescription => '学んだことを練習：苦手な単語、最近の間違い、間隔反復。';

  @override
  String get startReview => '復習を開始';

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
    return '$modeセットアップ';
  }

  @override
  String get difficulty => '難易度';

  @override
  String get numberOfQuestions => '問題数';

  @override
  String get timerPerQuestion => '問題ごとのタイマー';

  @override
  String get noTimer => 'タイマーなし';

  @override
  String get start => '開始';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileSignInToMessage => 'メッセージを送るにはサインインしてください';

  @override
  String get profileThatsYourProfile => 'これはあなたのプロフィールです';

  @override
  String get profileSignInToAddFriends => '友達を追加するにはサインインしてください';

  @override
  String get profileCantAddYourself => '自分自身を追加することはできません';

  @override
  String profileRequestSent(Object username) {
    return '@$usernameにリクエストを送信しました';
  }

  @override
  String get profileRequestFailed => 'リクエストの送信に失敗しました';

  @override
  String get profileDefaultDisplayName => '新規ユーザー';

  @override
  String get profileDefaultBio => '学習準備完了！';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'ゲスト';

  @override
  String get guestUsername => 'ゲスト';

  @override
  String get guestSessionLabel => 'ゲストセッション';

  @override
  String get unlockFullProfile => 'フルプロフィールをアンロック';

  @override
  String get guestBenefitSync => 'すべてのデバイスで進捗を同期';

  @override
  String get guestBenefitCircles => 'Circlesに参加してライブでプレイ';

  @override
  String get guestBenefitNotifications => '通知と友達リクエストを受信';

  @override
  String get progressStaysOnDevice => 'サインインするまで、進捗はこのデバイスに残ります。';

  @override
  String profileGoalLabel(Object minutes) {
    return '目標: $minutes分';
  }

  @override
  String get profileXpProgress => 'XP進捗';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => '勝利';

  @override
  String get profileStreak => '連続記録';

  @override
  String get profileFriendsTitle => '友達';

  @override
  String get profileViewAll => 'すべて表示';

  @override
  String get profileAchievementsTitle => '実績';

  @override
  String get profileNoAchievements => 'まだ実績がありません。';

  @override
  String get profileRequested => 'リクエスト済み';

  @override
  String get profileSending => '送信中...';

  @override
  String get profileAddFriend => '友達を追加';

  @override
  String get profileConnectTitle => 'つながる';

  @override
  String get profileMessage => 'メッセージ';

  @override
  String get profileSnapshot => 'プロフィールスナップショット';

  @override
  String get profileLocationHidden => '場所は非表示';

  @override
  String get profileBioHidden => '自己紹介は非表示';

  @override
  String profileDailyGoal(Object minutes) {
    return '1日の目標 $minutes分';
  }

  @override
  String get circleInviteTitle => 'Circleへの招待';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID: $id';
  }

  @override
  String get signInToJoin => '参加するにはサインインしてください';

  @override
  String get joiningCircle => '参加中...';

  @override
  String get joinCircle => 'Circleに参加';

  @override
  String get circleJoinedAsPlayer => 'プレイヤーとして参加しました';

  @override
  String get circleJoinedAsSpectator => '観戦者として参加しました';

  @override
  String get accept => '承認';

  @override
  String get decline => '拒否';

  @override
  String get open => '開く';

  @override
  String get circleCountdownTitle => '準備してください';

  @override
  String get circleCountdownSubtitle => 'Circle開始中...';

  @override
  String get userFallbackName => 'ユーザー';

  @override
  String get micOff => 'マイクオフ';

  @override
  String get micOn => 'マイクオン';

  @override
  String get roleHost => 'ホスト';

  @override
  String get roleSpectator => '観戦者';

  @override
  String get tagHost => 'ホスト';

  @override
  String get tagYou => 'あなた';

  @override
  String get statusCorrect => '正解';

  @override
  String get statusWrong => '不正解';

  @override
  String get statusWaiting => '待機中';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'pt';

  @override
  String get pointsLabel => 'ポイント';

  @override
  String get statCorrect => '正解';

  @override
  String get statAnswers => '回答';

  @override
  String get statTotal => '合計';

  @override
  String get statQuestions => '問題';

  @override
  String get statAccuracy => '正確性';

  @override
  String get statRate => 'レート';

  @override
  String get statRank => 'ランク';

  @override
  String get statPosition => '順位';

  @override
  String get statMode => 'モード';

  @override
  String get statType => 'タイプ';

  @override
  String get next => '次へ';

  @override
  String get submit => '送信';

  @override
  String get continueLabel => '続ける';

  @override
  String get save => '保存';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get backToCourse => 'コースに戻る';

  @override
  String get resultsTitle => '結果';

  @override
  String get shareLater => '後で共有';

  @override
  String get delete => '削除';

  @override
  String get ok => 'OK';

  @override
  String minutesShort(Object minutes) {
    return '$minutes分';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count分';
  }

  @override
  String timeShortHours(Object count) {
    return '$count時間';
  }

  @override
  String timeShortDays(Object count) {
    return '$count日';
  }

  @override
  String get timeJustNow => 'たった今';

  @override
  String timeMinutesAgo(Object count) {
    return '$count分前';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count時間前';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count日前';
  }

  @override
  String get liveQuizWaitingForHost => 'ホスト待機中...';

  @override
  String get liveQuizJoinRequestSent => '参加リクエストを送信しました';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'リクエスト失敗: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'ホストコントロール';

  @override
  String get liveQuizSpectatorModeTitle => '観戦モード';

  @override
  String get liveQuizHostControlsSubtitle => '全員が回答するか時間切れになると、ラウンドは自動的に進みます。';

  @override
  String get liveQuizSpectatorModeSubtitle => '問題とリーダーボードをライブで視聴。回答はできません。';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return '問題 $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'リクエストを送信しました';

  @override
  String get liveQuizRequestToJoin => '参加をリクエスト';

  @override
  String get liveQuizSpectatorFooter => 'ライブ視聴中です。問題とリーダーボードをお楽しみください。';

  @override
  String get circleNotFound => 'Circleが見つかりません';

  @override
  String resultsRematchStartFailed(Object error) {
    return '再戦の開始に失敗しました: $error';
  }

  @override
  String get resultsMatchTitle => 'マッチ結果';

  @override
  String resultsNiceWork(Object name) {
    return 'よくできました、$nameさん';
  }

  @override
  String get resultsPlaceFirst => '1位';

  @override
  String get resultsPlaceSecond => '2位';

  @override
  String get resultsPlaceThird => '3位';

  @override
  String resultsPlaceNth(Object rank) {
    return '$rank位';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '$players人中';
  }

  @override
  String get resultsHighlightChampion => 'チャンピオン！このCircleを制しました。';

  @override
  String get resultsHighlightGreatAccuracy => '優れた正確性。トップに近いです！';

  @override
  String get resultsHighlightKeepGoing => '継続は力なり - 安定性がスピードを上回ります。';

  @override
  String get resultsLeaderboardTitle => 'リーダーボード';

  @override
  String resultsPlayersCount(Object count) {
    return '$count人のプレイヤー';
  }

  @override
  String get resultsBackToCircles => 'Circlesに戻る';

  @override
  String get resultsRematch => '再戦';

  @override
  String get resultsPlayAgain => 'もう一度プレイ';

  @override
  String get leaderboardGlobalTitle => 'グローバルリーダーボード';

  @override
  String get leaderboardEmpty => 'まだリーダーボードがありません。';

  @override
  String get aboutTitle => 'について';

  @override
  String aboutVersion(Object version) {
    return 'バージョン $version';
  }

  @override
  String get aboutDescription =>
      'SOMAは、新しい言語の習得を楽しく社交的にするゲーミフィケーション言語学習プラットフォームです。Circlesに参加し、ソロで練習し、進捗を追跡しましょう。';

  @override
  String get aboutTerms => '利用規約';

  @override
  String get aboutPrivacy => 'プライバシーポリシー';

  @override
  String get aboutOpenSource => 'オープンソースライセンス';

  @override
  String get addFriendTitle => '友達を追加';

  @override
  String get addFriendFindByUsername => 'ユーザー名で検索';

  @override
  String get addFriendUsernameHint => 'ユーザー名を入力...';

  @override
  String get addFriendTip => 'ヒント：後でQRコード+フレンドIDをサポートできます。';

  @override
  String get addFriendSending => '送信中...';

  @override
  String get addFriendSendRequest => 'リクエストを送信';

  @override
  String addFriendUserNotFound(Object username) {
    return '@$usernameが見つかりません';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'アクションが失敗したか、すでに送信済み: $error';
  }

  @override
  String get friendsTitle => '友達';

  @override
  String get searchFriendsHint => '友達を検索...';

  @override
  String get somaLearnerSubtitle => 'Soma学習者';

  @override
  String get friendRequestLabel => 'リクエスト';

  @override
  String get friendRequestSentLabel => 'リクエスト送信済み';

  @override
  String get friendIncomingRequestLabel => '受信リクエスト';

  @override
  String get friendRequestsSection => 'リクエスト';

  @override
  String get friendPendingSection => '保留中';

  @override
  String get friendAllSection => 'すべての友達';

  @override
  String get friendsEmptyState => 'まだ友達がいません。最初の友達を追加しましょう！';

  @override
  String get friendsEmptyShort => 'まだ友達がいません。';

  @override
  String noMatchForQuery(Object query) {
    return '\"$query\"に一致するものがありません';
  }

  @override
  String get inboxTitle => '受信トレイ';

  @override
  String get searchChatsHint => 'チャットを検索...';

  @override
  String get inboxEmptyState => 'まだチャットがありません。友達とチャットを始めましょう！';

  @override
  String get newMessageTitle => '新しいメッセージ';

  @override
  String get chatCallLater => '後で音声通話（Circle言語は近日公開）';

  @override
  String errorWithDetails(Object error) {
    return 'エラー: $error';
  }

  @override
  String chatSayHi(Object name) {
    return '$nameさんにあいさつしましょう！';
  }

  @override
  String get chatMessageHint => 'メッセージ...';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsTabAll => 'すべて';

  @override
  String get notificationsTabCourses => 'コース';

  @override
  String get notificationsTabSocial => 'ソーシャル';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'システム';

  @override
  String get notificationsEmpty => 'ここには通知がありません。';

  @override
  String get notificationsDeleted => '通知を削除しました';

  @override
  String get notificationTitleFallback => '通知';

  @override
  String get notificationTypeCourse => 'コース';

  @override
  String get notificationTypeSocial => 'ソーシャル';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'システム';

  @override
  String get notificationsFriendAccepted => '友達リクエストを承認しました';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return '友達リクエストの承認に失敗: $error';
  }

  @override
  String get notificationsFriendDeclined => '友達リクエストを拒否しました';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return '友達リクエストの拒否に失敗: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'Circleへの参加に失敗: $error';
  }

  @override
  String get notificationsOpening => '開いています';

  @override
  String get notificationsOpened => '開きました';

  @override
  String notificationsActionMessage(Object action) {
    return '$action通知';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionAccount => 'アカウント';

  @override
  String get settingsEditProfile => 'プロフィール編集';

  @override
  String get settingsPrivacy => 'プライバシー';

  @override
  String get settingsSecurity => 'セキュリティ';

  @override
  String get settingsSectionGameplay => 'ゲームプレイ';

  @override
  String get settingsShowTranslationLine => '翻訳行を表示';

  @override
  String get settingsShowReadingLine => '読みを表示（Pinyin/Romaji）';

  @override
  String get settingsDefaultTimerPerQuestion => '問題ごとのデフォルトタイマー';

  @override
  String get settingsMatchDifficulty => 'マッチ難易度';

  @override
  String get settingsMatchDifficultyAdaptive => '適応型';

  @override
  String get settingsSectionSoundFeel => 'サウンドと感触';

  @override
  String get settingsMusic => '音楽';

  @override
  String get settingsSoundEffects => '効果音';

  @override
  String get settingsHaptics => '触覚フィードバック';

  @override
  String get settingsSectionNotifications => '通知';

  @override
  String get settingsPushNotifications => 'プッシュ通知';

  @override
  String get settingsDailyReminder => '毎日のリマインダー';

  @override
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsUiLanguage => 'UI言語';

  @override
  String get settingsSectionAbout => 'について';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsTermsPrivacy => '規約とプライバシー';

  @override
  String get settingsSupport => 'サポート';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeLight => 'ライト';

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
  String get editProfileUpdated => 'プロフィールを更新しました';

  @override
  String get editProfileTitle => 'プロフィール編集';

  @override
  String get editProfilePhotoLabel => 'プロフィール写真';

  @override
  String get editProfilePhotoSubtitle => 'Supabase Storageを経由したアバター選択は近日公開。';

  @override
  String get editProfileChangePhoto => '変更';

  @override
  String get editProfileAvatarUploadSoon => 'アバターアップロードは近日公開';

  @override
  String get editProfileDisplayNameLabel => '表示名';

  @override
  String get editProfileDisplayNameHint => 'あなたの名前';

  @override
  String get editProfileDisplayNameRequired => '名前を入力してください';

  @override
  String get editProfileDisplayNameTooShort => '短すぎます';

  @override
  String get editProfileUsernameLabel => 'ユーザー名';

  @override
  String get editProfileUsernameHint => 'tanaka_learner';

  @override
  String get editProfileUsernameRequired => 'ユーザー名を入力してください';

  @override
  String get editProfileUsernameTooShort => '最低3文字';

  @override
  String get editProfileUsernameInvalid => '文字、数字、_のみ';

  @override
  String get editProfileBioLabel => '自己紹介';

  @override
  String get editProfileBioHint => '短い自己紹介...';

  @override
  String get editProfileBioTooLong => '最大120文字';

  @override
  String get editProfileLocationLabel => '場所';

  @override
  String get editProfileLocationHint => '都市 / 国';

  @override
  String get editProfileDailyGoalTitle => '1日の目標';

  @override
  String get editProfileDailyGoalSubtitle => '毎日何分勉強したいかを選択してください。';

  @override
  String get securityTitle => 'セキュリティ';

  @override
  String get securitySectionPassword => 'パスワード';

  @override
  String get securityChangePasswordTitle => 'パスワードを変更';

  @override
  String get securityChangePasswordSubtitle => '定期的にパスワードを更新してください。';

  @override
  String get securitySectionTwoFactor => '2段階認証';

  @override
  String get securityEnable2faTitle => '2FAを有効化';

  @override
  String get securityEnable2faSubtitle => 'サインイン時の追加セキュリティ。';

  @override
  String get securitySectionAppLock => 'アプリロック';

  @override
  String get securityBiometricTitle => '生体認証アンロック';

  @override
  String get securityBiometricSubtitle => 'FaceID/TouchIDを使用してSOMAをアンロック。';

  @override
  String get securityAppLockTitle => 'アプリロック';

  @override
  String get securityAppLockSubtitle => 'アプリを終了時にSOMAをロック。';

  @override
  String get securitySectionSessions => 'アクティブセッション';

  @override
  String get securityNoSessions => 'アクティブセッションが見つかりません。';

  @override
  String get securityThisDevice => 'このデバイス';

  @override
  String get securityDevice => 'デバイス';

  @override
  String get securityActiveLabel => 'アクティブ';

  @override
  String get securitySignInToEnable2fa => '2FAを有効にするにはサインインしてください';

  @override
  String securityEnable2faFailed(Object error) {
    return '2FAの有効化に失敗: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '2FAの無効化に失敗: $error';
  }

  @override
  String get securitySetup2faTitle => '2FAセットアップ';

  @override
  String get securitySecretKeyLabel => '秘密鍵';

  @override
  String get securityCodeHint => '6桁のコード';

  @override
  String get security2faEnabled => '2FAを有効にしました';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'コードの確認に失敗: $error';
  }

  @override
  String get securityVerifying => '確認中...';

  @override
  String get securityVerify => '確認';

  @override
  String get securityCurrentPasswordHint => '現在のパスワード';

  @override
  String get securityNewPasswordHint => '新しいパスワード（8文字以上）';

  @override
  String get securityConfirmPasswordHint => '新しいパスワードを確認';

  @override
  String get securitySignInToChangePassword => 'パスワードを変更するにはサインインしてください';

  @override
  String get securityEnterCurrentPassword => '現在のパスワードを入力してください';

  @override
  String get securityPasswordMinLength => '新しいパスワードは8文字以上である必要があります';

  @override
  String get securityPasswordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get securityPasswordUpdated => 'パスワードを更新しました';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'パスワードの更新に失敗: $error';
  }

  @override
  String get securityAutoLockAfter => '自動ロックまで';

  @override
  String get privacyTitle => 'プライバシー';

  @override
  String get privacySectionVisibility => '表示';

  @override
  String get privacyProfileVisibilityTitle => 'プロフィールの表示';

  @override
  String get privacyVisibilityPublic => '公開';

  @override
  String get privacyVisibilityFriends => '友達';

  @override
  String get privacyVisibilityPrivate => '非公開';

  @override
  String get privacyVisibilityPublicSubtitle => '誰でもあなたのプロフィールを見ることができます。';

  @override
  String get privacyVisibilityFriendsSubtitle => '友達のみがあなたのプロフィールを見ることができます。';

  @override
  String get privacyVisibilityPrivateSubtitle => 'あなただけがプロフィールを見ることができます。';

  @override
  String get privacySectionActivity => 'アクティビティ';

  @override
  String get privacyShowOnlineTitle => 'オンラインステータスを表示';

  @override
  String get privacyShowOnlineSubtitle => '他の人があなたがオンラインであることを見られるようにします。';

  @override
  String get privacyShowActivityTitle => '学習アクティビティを表示';

  @override
  String get privacyShowActivitySubtitle => '連続記録、XP、現在の進捗を表示。';

  @override
  String get privacySectionSocial => 'ソーシャル';

  @override
  String get privacyAllowRequestsTitle => '友達リクエストを許可';

  @override
  String get privacyAllowRequestsSubtitle => '他の人が友達リクエストを送信できるようにします。';

  @override
  String get privacyWhoCanDmTitle => 'DMできる人';

  @override
  String get privacyDmEveryone => '全員';

  @override
  String get privacyDmFriends => '友達';

  @override
  String get privacyDmNoOne => '誰もいない';

  @override
  String get privacyDmEveryoneSubtitle => '誰でもあなたにDMできます。';

  @override
  String get privacyDmFriendsSubtitle => '友達のみがあなたにDMできます。';

  @override
  String get privacyDmNoOneSubtitle => '誰もあなたにDMできません。';

  @override
  String get privacySectionBlockedUsers => 'ブロックしたユーザー';

  @override
  String get privacyBlockedUsersComingSoon => 'ブロックしたユーザーの管理は近日公開。';

  @override
  String get privacySectionDataControls => 'データ管理';

  @override
  String get privacyExportDataTitle => 'データをエクスポート';

  @override
  String get privacyExportDataSubtitle => 'アクティビティとコースをダウンロード。';

  @override
  String get privacyExportInfoTitle => 'データエクスポート';

  @override
  String get privacyExportInfoBody =>
      '次のステップ：JSON/CSVエクスポートを作成し、メールで送信するかローカルにダウンロードします。';

  @override
  String get privacyDeleteAccountTitle => 'アカウントを削除';

  @override
  String get privacyDeleteAccountSubtitle => 'これによりアカウントとデータが永久に削除されます。';

  @override
  String get privacyDeleteConfirmTitle => 'アカウントを削除しますか？';

  @override
  String get privacyDeleteConfirmBody =>
      'この操作は永続的です。プロフィール、コース、友達、メッセージが削除されます。';

  @override
  String get privacyDeleteComingSoon => '削除は後でSupabaseに接続されます';

  @override
  String get soloLabel => 'ソロ';

  @override
  String get soloResultsCompletedTitle => 'ソロセッション完了';

  @override
  String get soloResultsFeedbackElite => 'エリートパフォーマンス。連続記録を維持しましょう。';

  @override
  String get soloResultsFeedbackStrong => '力強い。急速に改善しています。';

  @override
  String get soloResultsFeedbackProgress => '良い進捗。間違いを復習して繰り返しましょう。';

  @override
  String get soloResultsFeedbackTryAgain => 'ストレスなく。少ない問題と集中で再挑戦しましょう。';

  @override
  String get soloResultsPerfectScore => '完璧なスコア！復習する間違いはありません。';

  @override
  String get soloResultsReviewPrompt => 'より速く学ぶために間違いを復習しましょう。以下に誤答を表示します。';

  @override
  String soloResultsReviewMistakes(Object count) {
    return '間違いを復習（$count）';
  }

  @override
  String get authNotSignedIn => 'サインインしていません';

  @override
  String get genericUser => 'ユーザー';

  @override
  String get loading => '読み込み中...';

  @override
  String get edit => '編集';

  @override
  String get send => '送信';

  @override
  String get join => '参加';

  @override
  String get leave => '退出';

  @override
  String get ready => '準備完了';

  @override
  String get levelBeginner => '初級';

  @override
  String get levelIntermediate => '中級';

  @override
  String get levelAdvanced => '上級';

  @override
  String questionsShort(Object count) {
    return '$count問';
  }

  @override
  String secondsShort(Object count) {
    return '$count秒';
  }

  @override
  String get circlesAllCourses => 'すべてのコース';

  @override
  String get circlesAllModes => 'すべてのモード';

  @override
  String get circlesAllLevels => 'すべてのレベル';

  @override
  String get circlesAddNewCourse => '新しいコースを追加';

  @override
  String get circlesCoursesTitle => 'コース';

  @override
  String get circlesModeTitle => 'モード';

  @override
  String get circlesLevelTitle => 'レベル';

  @override
  String get circlesNoActiveForFilters => 'このフィルターのアクティブなCirclesはありません。';

  @override
  String get circlesUnknownRoom => '不明なルーム';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'Circleを作成';

  @override
  String get circlesCircleName => 'Circle名';

  @override
  String get circlesEnterName => '名前を入力';

  @override
  String get circlesLanguages => '言語';

  @override
  String get circlesRoomSetup => 'ルーム設定';

  @override
  String get circlesPlayers => 'プレイヤー';

  @override
  String get circlesEmptySlot => '空きスロット';

  @override
  String get circlesPlayersRange => '1-5人のプレイヤー';

  @override
  String get circlesQuestions => '問題';

  @override
  String get circlesQuestionsSubtitle => '問題数';

  @override
  String get circlesTimePerQuestion => '問題ごとの時間';

  @override
  String get circlesSecondsPerQuestion => '問題ごとの秒数';

  @override
  String get circlesAdvanced => '詳細';

  @override
  String get circlesAllowSpectators => '観戦者を許可';

  @override
  String get circlesAllowSpectatorsSubtitle => '他の人がプレイせずに視聴できるようにします。';

  @override
  String get circlesLiveVoiceChat => 'ライブ音声チャット';

  @override
  String get circlesLiveVoiceChatSubtitle => 'マッチ中のライブ音声を有効化。';

  @override
  String get circlesLiveTextChat => 'ライブテキストチャット';

  @override
  String get circlesLiveTextChatSubtitle => 'マッチ中のチャットを有効化。';

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
  String get circlesCreatedSuccess => 'Circleを作成しました';

  @override
  String circlesCreateError(Object error) {
    return 'Circleの作成に失敗: $error';
  }

  @override
  String get circlesHostTip => 'ヒント：作成後に友達を招待できます。';

  @override
  String circlesJoinError(Object error) {
    return 'Circleへの参加に失敗: $error';
  }

  @override
  String get circlesLobbyTitle => 'Circleロビー';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'コード: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'マッチ設定';

  @override
  String circlesLevelWithValue(Object level) {
    return 'レベル $level';
  }

  @override
  String get circlesDifficulty => '難易度';

  @override
  String get circlesPerQuestionShort => '問題ごと';

  @override
  String get circlesInvite => '招待';

  @override
  String get circlesCopyId => 'IDをコピー';

  @override
  String get circlesCopiedId => 'IDをコピーしました';

  @override
  String get circlesMatchInProgress => 'マッチ進行中';

  @override
  String get circlesSpectatorQueuedBody => 'マッチ進行中。観戦者として参加します。';

  @override
  String get circlesHostStartWhenReady => '全員が準備完了したらホストが開始します。';

  @override
  String get circlesSpectators => '観戦者';

  @override
  String get circlesSpectator => '観戦者';

  @override
  String get circlesSpectatorCanWatch => '観戦者はライブで視聴できます。';

  @override
  String get circlesJoinRequests => '参加リクエスト';

  @override
  String get circlesAcceptSpectatorsHint => 'マッチ開始前に観戦者を承認してください。';

  @override
  String get circlesStartGame => 'ゲーム開始';

  @override
  String get circlesWaitingForPlayers => 'プレイヤー待機中';

  @override
  String get circlesLeaveCircle => 'Circleを退出';

  @override
  String get circlesRequestSent => 'リクエストを送信しました';

  @override
  String get circlesRequestToJoin => '参加をリクエスト';

  @override
  String get circlesWatchLive => 'ライブ視聴';

  @override
  String get circlesPlayerTip => '準備ができたら準備完了をタップ。ホストがマッチを開始します。';

  @override
  String get circlesSpectatorTip => '視聴中です。ホストが開始したらライブで視聴してください。';

  @override
  String get circlesHostControls => 'ホストコントロール';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'ホストの移行に失敗: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'Circleの終了に失敗: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '@$usernameが見つかりません';
  }

  @override
  String get circlesInvalidUser => '無効なユーザー';

  @override
  String get circlesCantInviteSelf => '自分自身を招待することはできません';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$usernameは既にCircleにいます';
  }

  @override
  String get circlesDefaultHost => 'ホスト';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'ユーザー名で招待';

  @override
  String circlesInviteSent(Object username) {
    return '@$usernameに招待を送信しました';
  }

  @override
  String circlesInviteFailed(Object error) {
    return '招待の送信に失敗: $error';
  }

  @override
  String get circlesJoinRequestSent => '参加リクエストを送信しました';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'リクエスト失敗: $error';
  }

  @override
  String get circlesFull => 'Circleが満員です';

  @override
  String get circlesSpectatorAdded => '観戦者を追加しました';

  @override
  String circlesApproveFailed(Object error) {
    return 'リクエストの承認に失敗: $error';
  }

  @override
  String get circlesRequestDeclined => 'リクエストを拒否しました';

  @override
  String circlesDeclineFailed(Object error) {
    return 'リクエストの拒否に失敗: $error';
  }

  @override
  String get circlesParticipant => '参加者';

  @override
  String get circlesLeavePromptTitle => 'Circleを退出しますか？';

  @override
  String get circlesLeavePromptTransfer => '退出する前にホストを移行してください。';

  @override
  String get circlesLeavePromptEndOnly => 'Circleを終了して退出。';

  @override
  String get circlesTransferHost => 'ホストを移行';

  @override
  String get circlesEndCircle => 'Circleを終了';

  @override
  String get circlesTransferHostTitle => 'ホストを移行';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID: $id';
  }
}
