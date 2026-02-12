// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => '学习。竞技。掌握。';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => '注册';

  @override
  String get signIn => '登录';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get authFillAllFields => '请填写所有字段';

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
    return '错误：$error';
  }

  @override
  String get authEmail => '邮箱';

  @override
  String get authPassword => '密码';

  @override
  String get authUsername => '用户名';

  @override
  String get authContinue => '继续';

  @override
  String get authSigningIn => '登录中...';

  @override
  String get authCreateAccount => '创建账户';

  @override
  String get authCreating => '创建中...';

  @override
  String get authNeedAccount => '还没有账户？';

  @override
  String get authHaveAccount => '已有账户？';

  @override
  String get dialogAuthRequiredTitle => '登录以访问Circles';

  @override
  String get dialogAuthRequiredBody => 'Circles是多人房间。创建账户以加入实时对战、邀请好友并保存您的进度。';

  @override
  String get notNow => '稍后';

  @override
  String get navHome => '首页';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => '个人资料';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => '删除课程？';

  @override
  String removeCourseBody(Object course) {
    return '从您的首页中删除$course。';
  }

  @override
  String get cancel => '取消';

  @override
  String get remove => '删除';

  @override
  String welcomeBack(Object name) {
    return '欢迎回来，$name！';
  }

  @override
  String get editCourses => '编辑课程';

  @override
  String get done => '完成';

  @override
  String get noCoursesToEdit => '没有可编辑的课程。';

  @override
  String get addCourse => '添加课程';

  @override
  String get unknown => '未知';

  @override
  String get iSpeak => '我会说';

  @override
  String get iWantToLearn => '我想学习';

  @override
  String get chooseYourLanguage => '选择您的语言';

  @override
  String get chooseLearningLanguage => '选择您要学习的语言';

  @override
  String get chooseTwoDifferentLanguages => '请选择两种不同的语言。';

  @override
  String get createCourse => '创建课程';

  @override
  String get soloCourseTitle => '单人课程';

  @override
  String get searchLanguage => '搜索语言';

  @override
  String get noMatches => '无匹配结果';

  @override
  String get chooseCourseType => '选择课程类型';

  @override
  String get soloStudyDescription => '通过Circles风格的测验独自学习 - 无房间、无聊天、无观众、无主持选项。';

  @override
  String get soloModeVocabulary => '词汇';

  @override
  String get soloModeSentences => '句子';

  @override
  String get soloModeReview => '复习';

  @override
  String get soloModeVocabularySubtitle => '词义、同义词、用法的选择题';

  @override
  String get soloModeSentencesSubtitle => '填空 + 翻译 + 阅读';

  @override
  String get soloModeReviewDescription => '练习所学内容：薄弱的单词、最近的错误、间隔重复。';

  @override
  String get startReview => '开始复习';

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
    return '$mode设置';
  }

  @override
  String get difficulty => '难度';

  @override
  String get numberOfQuestions => '题目数量';

  @override
  String get timerPerQuestion => '每题计时';

  @override
  String get noTimer => '无计时';

  @override
  String get start => '开始';

  @override
  String get profileTitle => '个人资料';

  @override
  String get profileSignInToMessage => '登录以发送消息';

  @override
  String get profileThatsYourProfile => '这是您的个人资料';

  @override
  String get profileSignInToAddFriends => '登录以添加好友';

  @override
  String get profileCantAddYourself => '不能添加自己';

  @override
  String profileRequestSent(Object username) {
    return '已向@$username发送请求';
  }

  @override
  String get profileRequestFailed => '请求发送失败';

  @override
  String get profileDefaultDisplayName => '新用户';

  @override
  String get profileDefaultBio => '准备好学习了！';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => '访客';

  @override
  String get guestUsername => '访客';

  @override
  String get guestSessionLabel => '访客会话';

  @override
  String get unlockFullProfile => '解锁完整资料';

  @override
  String get guestBenefitSync => '在所有设备间同步进度';

  @override
  String get guestBenefitCircles => '加入Circles进行实时游戏';

  @override
  String get guestBenefitNotifications => '接收通知和好友请求';

  @override
  String get progressStaysOnDevice => '登录前，您的进度将保留在此设备上。';

  @override
  String profileGoalLabel(Object minutes) {
    return '目标：$minutes分钟';
  }

  @override
  String get profileXpProgress => '经验值进度';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => '胜利';

  @override
  String get profileStreak => '连续天数';

  @override
  String get profileFriendsTitle => '好友';

  @override
  String get profileViewAll => '查看全部';

  @override
  String get profileAchievementsTitle => '成就';

  @override
  String get profileNoAchievements => '暂无成就。';

  @override
  String get profileRequested => '已请求';

  @override
  String get profileSending => '发送中...';

  @override
  String get profileAddFriend => '添加好友';

  @override
  String get profileConnectTitle => '连接';

  @override
  String get profileMessage => '消息';

  @override
  String get profileSnapshot => '资料快照';

  @override
  String get profileLocationHidden => '位置已隐藏';

  @override
  String get profileBioHidden => '简介已隐藏';

  @override
  String profileDailyGoal(Object minutes) {
    return '每日目标 $minutes分钟';
  }

  @override
  String get circleInviteTitle => 'Circle邀请';

  @override
  String circleIdLabel(Object id) {
    return 'Circle ID：$id';
  }

  @override
  String get signInToJoin => '登录以加入';

  @override
  String get joiningCircle => '加入中...';

  @override
  String get joinCircle => '加入Circle';

  @override
  String get circleJoinedAsPlayer => '已作为玩家加入';

  @override
  String get circleJoinedAsSpectator => '已作为观众加入';

  @override
  String get accept => '接受';

  @override
  String get decline => '拒绝';

  @override
  String get open => '打开';

  @override
  String get circleCountdownTitle => '准备就绪';

  @override
  String get circleCountdownSubtitle => 'Circle即将开始...';

  @override
  String get userFallbackName => '用户';

  @override
  String get micOff => '麦克风关闭';

  @override
  String get micOn => '麦克风开启';

  @override
  String get roleHost => '主持人';

  @override
  String get roleSpectator => '观众';

  @override
  String get tagHost => '主持';

  @override
  String get tagYou => '你';

  @override
  String get statusCorrect => '正确';

  @override
  String get statusWrong => '错误';

  @override
  String get statusWaiting => '等待中';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => '分';

  @override
  String get pointsLabel => '分数';

  @override
  String get statCorrect => '正确';

  @override
  String get statAnswers => '回答';

  @override
  String get statTotal => '总计';

  @override
  String get statQuestions => '题目';

  @override
  String get statAccuracy => '准确率';

  @override
  String get statRate => '比率';

  @override
  String get statRank => '排名';

  @override
  String get statPosition => '位置';

  @override
  String get statMode => '模式';

  @override
  String get statType => '类型';

  @override
  String get next => '下一个';

  @override
  String get submit => '提交';

  @override
  String get continueLabel => '继续';

  @override
  String get save => '保存';

  @override
  String get playAgain => '再玩一次';

  @override
  String get backToCourse => '返回课程';

  @override
  String get resultsTitle => '结果';

  @override
  String get shareLater => '稍后分享';

  @override
  String get delete => '删除';

  @override
  String get ok => '确定';

  @override
  String minutesShort(Object minutes) {
    return '$minutes分钟';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count分钟';
  }

  @override
  String timeShortHours(Object count) {
    return '$count小时';
  }

  @override
  String timeShortDays(Object count) {
    return '$count天';
  }

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinutesAgo(Object count) {
    return '$count分钟前';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count小时前';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count天前';
  }

  @override
  String get liveQuizWaitingForHost => '等待主持人...';

  @override
  String get liveQuizJoinRequestSent => '已发送加入请求';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return '请求失败：$error';
  }

  @override
  String get liveQuizHostControlsTitle => '主持控制';

  @override
  String get liveQuizSpectatorModeTitle => '观众模式';

  @override
  String get liveQuizHostControlsSubtitle => '当所有人答题或时间用尽时，回合会自动进行。';

  @override
  String get liveQuizSpectatorModeSubtitle => '实时观看问题和排行榜。您无法回答。';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return '问题$current/$total';
  }

  @override
  String get liveQuizRequestSent => '已发送请求';

  @override
  String get liveQuizRequestToJoin => '请求加入';

  @override
  String get liveQuizSpectatorFooter => '您正在实时观看。享受问题和排行榜。';

  @override
  String get circleNotFound => '未找到Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return '重赛开始失败：$error';
  }

  @override
  String get resultsMatchTitle => '比赛结果';

  @override
  String resultsNiceWork(Object name) {
    return '干得好，$name';
  }

  @override
  String get resultsPlaceFirst => '第1名';

  @override
  String get resultsPlaceSecond => '第2名';

  @override
  String get resultsPlaceThird => '第3名';

  @override
  String resultsPlaceNth(Object rank) {
    return '第$rank名';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return '共$players名玩家';
  }

  @override
  String get resultsHighlightChampion => '冠军！您征服了这个Circle。';

  @override
  String get resultsHighlightGreatAccuracy => '出色的准确率。您已接近榜首！';

  @override
  String get resultsHighlightKeepGoing => '坚持不懈 - 稳定性胜过速度。';

  @override
  String get resultsLeaderboardTitle => '排行榜';

  @override
  String resultsPlayersCount(Object count) {
    return '$count名玩家';
  }

  @override
  String get resultsBackToCircles => '返回Circles';

  @override
  String get resultsRematch => '重赛';

  @override
  String get resultsPlayAgain => '再玩一次';

  @override
  String get leaderboardGlobalTitle => '全球排行榜';

  @override
  String get leaderboardEmpty => '暂无排行榜。';

  @override
  String get aboutTitle => '关于';

  @override
  String aboutVersion(Object version) {
    return '版本 $version';
  }

  @override
  String get aboutDescription =>
      'SOMA是一个游戏化语言学习平台，让学习新语言变得有趣且社交化。加入Circles，独自练习，追踪您的进度。';

  @override
  String get aboutTerms => '服务条款';

  @override
  String get aboutPrivacy => '隐私政策';

  @override
  String get aboutOpenSource => '开源许可';

  @override
  String get addFriendTitle => '添加好友';

  @override
  String get addFriendFindByUsername => '通过用户名查找';

  @override
  String get addFriendUsernameHint => '输入用户名...';

  @override
  String get addFriendTip => '提示：稍后可支持二维码+好友ID。';

  @override
  String get addFriendSending => '发送中...';

  @override
  String get addFriendSendRequest => '发送请求';

  @override
  String addFriendUserNotFound(Object username) {
    return '未找到@$username';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return '操作失败或已发送：$error';
  }

  @override
  String get friendsTitle => '好友';

  @override
  String get searchFriendsHint => '搜索好友...';

  @override
  String get somaLearnerSubtitle => 'Soma学习者';

  @override
  String get friendRequestLabel => '请求';

  @override
  String get friendRequestSentLabel => '已发送请求';

  @override
  String get friendIncomingRequestLabel => '收到的请求';

  @override
  String get friendRequestsSection => '请求';

  @override
  String get friendPendingSection => '待处理';

  @override
  String get friendAllSection => '所有好友';

  @override
  String get friendsEmptyState => '还没有好友。添加您的第一位好友吧！';

  @override
  String get friendsEmptyShort => '还没有好友。';

  @override
  String noMatchForQuery(Object query) {
    return '无匹配\"$query\"';
  }

  @override
  String get inboxTitle => '收件箱';

  @override
  String get searchChatsHint => '搜索聊天...';

  @override
  String get inboxEmptyState => '还没有聊天。开始与好友聊天吧！';

  @override
  String get newMessageTitle => '新消息';

  @override
  String get chatCallLater => '稍后进行语音通话（Circle语言即将推出）';

  @override
  String errorWithDetails(Object error) {
    return '错误：$error';
  }

  @override
  String chatSayHi(Object name) {
    return '向$name打个招呼吧！';
  }

  @override
  String get chatMessageHint => '消息...';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsTabAll => '全部';

  @override
  String get notificationsTabCourses => '课程';

  @override
  String get notificationsTabSocial => '社交';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => '系统';

  @override
  String get notificationsEmpty => '这里没有通知。';

  @override
  String get notificationsDeleted => '已删除通知';

  @override
  String get notificationTitleFallback => '通知';

  @override
  String get notificationTypeCourse => '课程';

  @override
  String get notificationTypeSocial => '社交';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => '系统';

  @override
  String get notificationsFriendAccepted => '已接受好友请求';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return '好友请求接受失败：$error';
  }

  @override
  String get notificationsFriendDeclined => '已拒绝好友请求';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return '好友请求拒绝失败：$error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return '加入Circle失败：$error';
  }

  @override
  String get notificationsOpening => '打开中';

  @override
  String get notificationsOpened => '已打开';

  @override
  String notificationsActionMessage(Object action) {
    return '$action通知';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionAccount => '账户';

  @override
  String get settingsEditProfile => '编辑资料';

  @override
  String get settingsPrivacy => '隐私';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsSectionGameplay => '游戏玩法';

  @override
  String get settingsShowTranslationLine => '显示翻译行';

  @override
  String get settingsShowReadingLine => '显示读音（拼音/罗马字）';

  @override
  String get settingsDefaultTimerPerQuestion => '每题默认计时';

  @override
  String get settingsMatchDifficulty => '匹配难度';

  @override
  String get settingsMatchDifficultyAdaptive => '自适应';

  @override
  String get settingsSectionSoundFeel => '声音与感觉';

  @override
  String get settingsMusic => '音乐';

  @override
  String get settingsSoundEffects => '音效';

  @override
  String get settingsHaptics => '触觉反馈';

  @override
  String get settingsSectionNotifications => '通知';

  @override
  String get settingsPushNotifications => '推送通知';

  @override
  String get settingsDailyReminder => '每日提醒';

  @override
  String get settingsSectionAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsUiLanguage => '界面语言';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsTermsPrivacy => '条款与隐私';

  @override
  String get settingsSupport => '支持';

  @override
  String get settingsLogout => '登出';

  @override
  String get themeSystem => '系统';

  @override
  String get themeDark => '暗色';

  @override
  String get themeLight => '亮色';

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
  String get editProfileUpdated => '已更新资料';

  @override
  String get editProfileTitle => '编辑资料';

  @override
  String get editProfilePhotoLabel => '资料照片';

  @override
  String get editProfilePhotoSubtitle => '通过Supabase Storage选择头像即将推出。';

  @override
  String get editProfileChangePhoto => '更改';

  @override
  String get editProfileAvatarUploadSoon => '头像上传即将推出';

  @override
  String get editProfileDisplayNameLabel => '显示名称';

  @override
  String get editProfileDisplayNameHint => '您的名字';

  @override
  String get editProfileDisplayNameRequired => '请输入名字';

  @override
  String get editProfileDisplayNameTooShort => '太短';

  @override
  String get editProfileUsernameLabel => '用户名';

  @override
  String get editProfileUsernameHint => 'zhang_learner';

  @override
  String get editProfileUsernameRequired => '请输入用户名';

  @override
  String get editProfileUsernameTooShort => '至少3个字符';

  @override
  String get editProfileUsernameInvalid => '仅限字母、数字、_';

  @override
  String get editProfileBioLabel => '简介';

  @override
  String get editProfileBioHint => '简短的自我介绍...';

  @override
  String get editProfileBioTooLong => '最多120个字符';

  @override
  String get editProfileLocationLabel => '位置';

  @override
  String get editProfileLocationHint => '城市/国家';

  @override
  String get editProfileDailyGoalTitle => '每日目标';

  @override
  String get editProfileDailyGoalSubtitle => '选择您每天想学习多少分钟。';

  @override
  String get securityTitle => '安全';

  @override
  String get securitySectionPassword => '密码';

  @override
  String get securityChangePasswordTitle => '更改密码';

  @override
  String get securityChangePasswordSubtitle => '定期更新您的密码。';

  @override
  String get securitySectionTwoFactor => '双因素认证';

  @override
  String get securityEnable2faTitle => '启用2FA';

  @override
  String get securityEnable2faSubtitle => '登录时的额外安全保护。';

  @override
  String get securitySectionAppLock => '应用锁';

  @override
  String get securityBiometricTitle => '生物识别解锁';

  @override
  String get securityBiometricSubtitle => '使用面容ID/指纹ID解锁SOMA。';

  @override
  String get securityAppLockTitle => '应用锁';

  @override
  String get securityAppLockSubtitle => '退出时锁定SOMA。';

  @override
  String get securitySectionSessions => '活动会话';

  @override
  String get securityNoSessions => '未找到活动会话。';

  @override
  String get securityThisDevice => '此设备';

  @override
  String get securityDevice => '设备';

  @override
  String get securityActiveLabel => '活动';

  @override
  String get securitySignInToEnable2fa => '登录以启用2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return '启用2FA失败：$error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return '禁用2FA失败：$error';
  }

  @override
  String get securitySetup2faTitle => '2FA设置';

  @override
  String get securitySecretKeyLabel => '密钥';

  @override
  String get securityCodeHint => '6位数字代码';

  @override
  String get security2faEnabled => '已启用2FA';

  @override
  String securityVerifyCodeFailed(Object error) {
    return '代码验证失败：$error';
  }

  @override
  String get securityVerifying => '验证中...';

  @override
  String get securityVerify => '验证';

  @override
  String get securityCurrentPasswordHint => '当前密码';

  @override
  String get securityNewPasswordHint => '新密码（至少8个字符）';

  @override
  String get securityConfirmPasswordHint => '确认新密码';

  @override
  String get securitySignInToChangePassword => '登录以更改密码';

  @override
  String get securityEnterCurrentPassword => '请输入当前密码';

  @override
  String get securityPasswordMinLength => '新密码必须至少8个字符';

  @override
  String get securityPasswordsDoNotMatch => '密码不匹配';

  @override
  String get securityPasswordUpdated => '已更新密码';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return '密码更新失败：$error';
  }

  @override
  String get securityAutoLockAfter => '自动锁定于';

  @override
  String get privacyTitle => '隐私';

  @override
  String get privacySectionVisibility => '可见性';

  @override
  String get privacyProfileVisibilityTitle => '资料可见性';

  @override
  String get privacyVisibilityPublic => '公开';

  @override
  String get privacyVisibilityFriends => '好友';

  @override
  String get privacyVisibilityPrivate => '私密';

  @override
  String get privacyVisibilityPublicSubtitle => '任何人都可以查看您的资料。';

  @override
  String get privacyVisibilityFriendsSubtitle => '仅好友可以查看您的资料。';

  @override
  String get privacyVisibilityPrivateSubtitle => '只有您可以查看资料。';

  @override
  String get privacySectionActivity => '活动';

  @override
  String get privacyShowOnlineTitle => '显示在线状态';

  @override
  String get privacyShowOnlineSubtitle => '让其他人看到您在线。';

  @override
  String get privacyShowActivityTitle => '显示学习活动';

  @override
  String get privacyShowActivitySubtitle => '显示连续天数、XP和当前进度。';

  @override
  String get privacySectionSocial => '社交';

  @override
  String get privacyAllowRequestsTitle => '允许好友请求';

  @override
  String get privacyAllowRequestsSubtitle => '允许其他人发送好友请求。';

  @override
  String get privacyWhoCanDmTitle => '谁可以发送私信';

  @override
  String get privacyDmEveryone => '所有人';

  @override
  String get privacyDmFriends => '好友';

  @override
  String get privacyDmNoOne => '无人';

  @override
  String get privacyDmEveryoneSubtitle => '任何人都可以给您发送私信。';

  @override
  String get privacyDmFriendsSubtitle => '仅好友可以给您发送私信。';

  @override
  String get privacyDmNoOneSubtitle => '无人可以给您发送私信。';

  @override
  String get privacySectionBlockedUsers => '已屏蔽用户';

  @override
  String get privacyBlockedUsersComingSoon => '管理已屏蔽用户即将推出。';

  @override
  String get privacySectionDataControls => '数据控制';

  @override
  String get privacyExportDataTitle => '导出数据';

  @override
  String get privacyExportDataSubtitle => '下载您的活动和课程。';

  @override
  String get privacyExportInfoTitle => '数据导出';

  @override
  String get privacyExportInfoBody => '下一步：创建JSON/CSV导出并通过邮件发送或本地下载。';

  @override
  String get privacyDeleteAccountTitle => '删除账户';

  @override
  String get privacyDeleteAccountSubtitle => '这将永久删除您的账户和数据。';

  @override
  String get privacyDeleteConfirmTitle => '删除账户？';

  @override
  String get privacyDeleteConfirmBody => '此操作是永久性的。您的资料、课程、好友和消息将被删除。';

  @override
  String get privacyDeleteComingSoon => '删除功能稍后将连接到Supabase';

  @override
  String get soloLabel => '单人';

  @override
  String get soloResultsCompletedTitle => '单人练习完成';

  @override
  String get soloResultsFeedbackElite => '精英表现。保持连续记录。';

  @override
  String get soloResultsFeedbackStrong => '表现强劲。正在快速进步。';

  @override
  String get soloResultsFeedbackProgress => '进步不错。复习错误并重复练习。';

  @override
  String get soloResultsFeedbackTryAgain => '别紧张。用更少的问题和专注再试一次。';

  @override
  String get soloResultsPerfectScore => '完美得分！没有错误需要复习。';

  @override
  String get soloResultsReviewPrompt => '复习错误以更快学习。您的错误答案如下。';

  @override
  String soloResultsReviewMistakes(Object count) {
    return '复习错误（$count）';
  }

  @override
  String get authNotSignedIn => '未登录';

  @override
  String get genericUser => '用户';

  @override
  String get loading => '加载中...';

  @override
  String get edit => '编辑';

  @override
  String get send => '发送';

  @override
  String get join => '加入';

  @override
  String get leave => '离开';

  @override
  String get ready => '准备';

  @override
  String get levelBeginner => '初级';

  @override
  String get levelIntermediate => '中级';

  @override
  String get levelAdvanced => '高级';

  @override
  String questionsShort(Object count) {
    return '$count题';
  }

  @override
  String secondsShort(Object count) {
    return '$count秒';
  }

  @override
  String get circlesAllCourses => '所有课程';

  @override
  String get circlesAllModes => '所有模式';

  @override
  String get circlesAllLevels => '所有级别';

  @override
  String get circlesAddNewCourse => '添加新课程';

  @override
  String get circlesCoursesTitle => '课程';

  @override
  String get circlesModeTitle => '模式';

  @override
  String get circlesLevelTitle => '级别';

  @override
  String get circlesNoActiveForFilters => '此筛选器没有活动的Circles。';

  @override
  String get circlesUnknownRoom => '未知房间';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => '创建Circle';

  @override
  String get circlesCircleName => 'Circle名称';

  @override
  String get circlesEnterName => '输入名称';

  @override
  String get circlesLanguages => '语言';

  @override
  String get circlesRoomSetup => '房间设置';

  @override
  String get circlesPlayers => '玩家';

  @override
  String get circlesEmptySlot => '空位';

  @override
  String get circlesPlayersRange => '1-5名玩家';

  @override
  String get circlesQuestions => '题目';

  @override
  String get circlesQuestionsSubtitle => '题目数量';

  @override
  String get circlesTimePerQuestion => '每题时间';

  @override
  String get circlesSecondsPerQuestion => '每题秒数';

  @override
  String get circlesAdvanced => '高级';

  @override
  String get circlesAllowSpectators => '允许观众';

  @override
  String get circlesAllowSpectatorsSubtitle => '允许其他人不参与游戏而观看。';

  @override
  String get circlesLiveVoiceChat => '实时语音聊天';

  @override
  String get circlesLiveVoiceChatSubtitle => '在比赛中启用实时语音。';

  @override
  String get circlesLiveTextChat => '实时文字聊天';

  @override
  String get circlesLiveTextChatSubtitle => '在比赛中启用聊天。';

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
  String get circlesCreatedSuccess => '已创建Circle';

  @override
  String circlesCreateError(Object error) {
    return '创建Circle失败：$error';
  }

  @override
  String get circlesHostTip => '提示：创建后可以邀请好友。';

  @override
  String circlesJoinError(Object error) {
    return '加入Circle失败：$error';
  }

  @override
  String get circlesLobbyTitle => 'Circle大厅';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return '代码：$code - $current/$max';
  }

  @override
  String get circlesMatchSettings => '比赛设置';

  @override
  String circlesLevelWithValue(Object level) {
    return '$level级';
  }

  @override
  String get circlesDifficulty => '难度';

  @override
  String get circlesPerQuestionShort => '每题';

  @override
  String get circlesInvite => '邀请';

  @override
  String get circlesCopyId => '复制ID';

  @override
  String get circlesCopiedId => '已复制ID';

  @override
  String get circlesMatchInProgress => '比赛进行中';

  @override
  String get circlesSpectatorQueuedBody => '比赛进行中。作为观众加入。';

  @override
  String get circlesHostStartWhenReady => '所有人准备好后主持人开始。';

  @override
  String get circlesSpectators => '观众';

  @override
  String get circlesSpectator => '观众';

  @override
  String get circlesSpectatorCanWatch => '观众可以实时观看。';

  @override
  String get circlesJoinRequests => '加入请求';

  @override
  String get circlesAcceptSpectatorsHint => '在比赛开始前批准观众。';

  @override
  String get circlesStartGame => '开始游戏';

  @override
  String get circlesWaitingForPlayers => '等待玩家';

  @override
  String get circlesLeaveCircle => '离开Circle';

  @override
  String get circlesRequestSent => '已发送请求';

  @override
  String get circlesRequestToJoin => '请求加入';

  @override
  String get circlesWatchLive => '实时观看';

  @override
  String get circlesPlayerTip => '准备好后点击准备。主持人将开始比赛。';

  @override
  String get circlesSpectatorTip => '您正在观看。主持人开始后实时观看。';

  @override
  String get circlesHostControls => '主持控制';

  @override
  String circlesTransferHostFailed(Object error) {
    return '转移主持人失败：$error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return '结束Circle失败：$error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return '未找到@$username';
  }

  @override
  String get circlesInvalidUser => '无效用户';

  @override
  String get circlesCantInviteSelf => '不能邀请自己';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username已在Circle中';
  }

  @override
  String get circlesDefaultHost => '主持人';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => '通过用户名邀请';

  @override
  String circlesInviteSent(Object username) {
    return '已向@$username发送邀请';
  }

  @override
  String circlesInviteFailed(Object error) {
    return '邀请发送失败：$error';
  }

  @override
  String get circlesJoinRequestSent => '已发送加入请求';

  @override
  String circlesJoinRequestFailed(Object error) {
    return '请求失败：$error';
  }

  @override
  String get circlesFull => 'Circle已满';

  @override
  String get circlesSpectatorAdded => '已添加观众';

  @override
  String circlesApproveFailed(Object error) {
    return '请求批准失败：$error';
  }

  @override
  String get circlesRequestDeclined => '已拒绝请求';

  @override
  String circlesDeclineFailed(Object error) {
    return '请求拒绝失败：$error';
  }

  @override
  String get circlesParticipant => '参与者';

  @override
  String get circlesLeavePromptTitle => '离开Circle？';

  @override
  String get circlesLeavePromptTransfer => '离开前请转移主持人。';

  @override
  String get circlesLeavePromptEndOnly => '结束Circle并离开。';

  @override
  String get circlesTransferHost => '转移主持人';

  @override
  String get circlesEndCircle => '结束Circle';

  @override
  String get circlesTransferHostTitle => '转移主持人';

  @override
  String circlesShareId(Object id) {
    return 'Circle ID：$id';
  }
}
