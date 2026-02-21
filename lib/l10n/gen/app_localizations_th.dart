// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'SOMA';

  @override
  String get welcomeTagline => 'เรียนรู้ แข่งขัน ชนะใจ';

  @override
  String welcome(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get skipForNow => 'ข้ามไปก่อน';

  @override
  String get authFillAllFields => 'กรุณากรอกข้อมูลให้ครบทุกช่อง';

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
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get authEmail => 'อีเมล';

  @override
  String get authPassword => 'รหัสผ่าน';

  @override
  String get authUsername => 'ชื่อผู้ใช้';

  @override
  String get authContinue => 'ดำเนินการต่อ';

  @override
  String get authSigningIn => 'กำลังเข้าสู่ระบบ...';

  @override
  String get authCreateAccount => 'สร้างบัญชี';

  @override
  String get authCreating => 'กำลังสร้าง...';

  @override
  String get authNeedAccount => 'ยังไม่มีบัญชี? ';

  @override
  String get authHaveAccount => 'มีบัญชีแล้ว? ';

  @override
  String get dialogAuthRequiredTitle => 'เข้าสู่ระบบเพื่อเข้าถึง Circles';

  @override
  String get dialogAuthRequiredBody =>
      'Circles เป็นพื้นที่สำหรับหลายผู้เล่น สร้างบัญชีเพื่อเข้าร่วมการแข่งขันสด เชิญเพื่อน และบันทึกความคืบหน้าของคุณ';

  @override
  String get notNow => 'ไว้ทีหลัง';

  @override
  String get navHome => 'หน้าแรก';

  @override
  String get navCircles => 'Circles';

  @override
  String get navProfile => 'โปรไฟล์';

  @override
  String get myCourses => 'My Courses';

  @override
  String get removeCourseTitle => 'ลบคอร์สหรือไม่?';

  @override
  String removeCourseBody(Object course) {
    return 'กำลังลบ $course จากรายการหน้าแรกของคุณ';
  }

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get remove => 'ลบ';

  @override
  String welcomeBack(Object name) {
    return 'ยินดีต้อนรับกลับมา $name!';
  }

  @override
  String get editCourses => 'แก้ไขคอร์ส';

  @override
  String get done => 'เสร็จสิ้น';

  @override
  String get noCoursesToEdit => 'ไม่มีคอร์สให้แก้ไข';

  @override
  String get addCourse => 'เพิ่มคอร์ส';

  @override
  String get unknown => 'ไม่ทราบ';

  @override
  String get iSpeak => 'ฉันพูดภาษา';

  @override
  String get iWantToLearn => 'ฉันต้องการเรียน';

  @override
  String get chooseYourLanguage => 'เลือกภาษาของคุณ';

  @override
  String get chooseLearningLanguage => 'เลือกภาษาที่คุณต้องการเรียน';

  @override
  String get chooseTwoDifferentLanguages => 'กรุณาเลือกสองภาษาที่แตกต่างกัน';

  @override
  String get createCourse => 'สร้างคอร์ส';

  @override
  String get soloCourseTitle => 'คอร์สเดี่ยว';

  @override
  String get searchLanguage => 'ค้นหาภาษา';

  @override
  String get noMatches => 'ไม่พบผลลัพธ์';

  @override
  String get chooseCourseType => 'เลือกประเภทคอร์ส';

  @override
  String get soloStudyDescription =>
      'เรียนด้วยตัวเองด้วยแบบทดสอบสไตล์ Circles - ไม่มีห้อง แชท ผู้ชม หรือตัวเลือกโฮสต์';

  @override
  String get soloModeVocabulary => 'คำศัพท์';

  @override
  String get soloModeSentences => 'ประโยค';

  @override
  String get soloModeReview => 'ทบทวน';

  @override
  String get soloModeVocabularySubtitle =>
      'คำถามแบบปรนัย ความหมาย คำพ้อง การใช้งาน';

  @override
  String get soloModeSentencesSubtitle => 'เติมคำในช่องว่าง + แปล + การอ่าน';

  @override
  String get soloModeReviewDescription =>
      'ฝึกฝนสิ่งที่เรียนรู้: คำที่จำไม่ได้ ข้อผิดพลาดล่าสุด การทบทวนตามช่วงเวลา';

  @override
  String get soloReverse => 'Reverse mode';

  @override
  String get startReview => 'เริ่มทบทวน';

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
    return 'การตั้งค่า $mode';
  }

  @override
  String get difficulty => 'ระดับความยาก';

  @override
  String get numberOfQuestions => 'จำนวนคำถาม';

  @override
  String get timerPerQuestion => 'ตัวจับเวลาต่อคำถาม';

  @override
  String get noTimer => 'ไม่มีตัวจับเวลา';

  @override
  String get start => 'เริ่ม';

  @override
  String get profileTitle => 'โปรไฟล์';

  @override
  String get profileSignInToMessage => 'เข้าสู่ระบบเพื่อส่งข้อความ';

  @override
  String get profileThatsYourProfile => 'นี่คือโปรไฟล์ของคุณ';

  @override
  String get profileSignInToAddFriends => 'เข้าสู่ระบบเพื่อเพิ่มเพื่อน';

  @override
  String get profileCantAddYourself => 'ไม่สามารถเพิ่มตัวเองได้';

  @override
  String profileRequestSent(Object username) {
    return 'ส่งคำขอไปยัง @$username แล้ว';
  }

  @override
  String get profileRequestFailed => 'ส่งคำขอไม่สำเร็จ';

  @override
  String get profileDefaultDisplayName => 'ผู้ใช้ใหม่';

  @override
  String get profileDefaultBio => 'พร้อมเรียนรู้!';

  @override
  String get profileDefaultLocation => 'Soma';

  @override
  String get guestDisplayName => 'ผู้เยี่ยมชม';

  @override
  String get guestUsername => 'ผู้เยี่ยมชม';

  @override
  String get guestSessionLabel => 'เซสชันผู้เยี่ยมชม';

  @override
  String get unlockFullProfile => 'ปลดล็อคโปรไฟล์เต็มรูปแบบ';

  @override
  String get guestBenefitSync => 'ซิงค์ความคืบหน้าในทุกอุปกรณ์';

  @override
  String get guestBenefitCircles => 'เข้าร่วม Circles เพื่อเล่นแบบสด';

  @override
  String get guestBenefitNotifications => 'รับการแจ้งเตือนและคำขอเพิ่มเพื่อน';

  @override
  String get progressStaysOnDevice =>
      'จนกว่าคุณจะเข้าสู่ระบบ ความคืบหน้าของคุณจะอยู่ในอุปกรณ์นี้';

  @override
  String profileGoalLabel(Object minutes) {
    return 'เป้าหมาย: $minutes นาที';
  }

  @override
  String get profileXpProgress => 'ความคืบหน้า XP';

  @override
  String profileXpValue(Object xp) {
    return '$xp XP';
  }

  @override
  String get profileWins => 'ชนะ';

  @override
  String get profileStreak => 'ต่อเนื่อง';

  @override
  String get profileFriendsTitle => 'เพื่อน';

  @override
  String get profileViewAll => 'ดูทั้งหมด';

  @override
  String get profileAchievementsTitle => 'ความสำเร็จ';

  @override
  String get profileNoAchievements => 'ยังไม่มีความสำเร็จ';

  @override
  String get profileRequested => 'ส่งคำขอแล้ว';

  @override
  String get profileSending => 'กำลังส่ง...';

  @override
  String get profileAddFriend => 'เพิ่มเพื่อน';

  @override
  String get profileConnectTitle => 'เชื่อมต่อ';

  @override
  String get profileMessage => 'ข้อความ';

  @override
  String get profileSnapshot => 'สแนปช็อตโปรไฟล์';

  @override
  String get profileLocationHidden => 'ซ่อนที่อยู่';

  @override
  String get profileBioHidden => 'ซ่อนประวัติ';

  @override
  String profileDailyGoal(Object minutes) {
    return 'เป้าหมายรายวัน $minutes นาที';
  }

  @override
  String get circleInviteTitle => 'คำเชิญ Circle';

  @override
  String circleIdLabel(Object id) {
    return 'รหัส Circle: $id';
  }

  @override
  String get signInToJoin => 'เข้าสู่ระบบเพื่อเข้าร่วม';

  @override
  String get joiningCircle => 'กำลังเข้าร่วม...';

  @override
  String get joinCircle => 'เข้าร่วม Circle';

  @override
  String get circleJoinedAsPlayer => 'เข้าร่วมในฐานะผู้เล่น';

  @override
  String get circleJoinedAsSpectator => 'เข้าร่วมในฐานะผู้ชม';

  @override
  String get accept => 'ยอมรับ';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get open => 'เปิด';

  @override
  String get circleCountdownTitle => 'เตรียมพร้อม';

  @override
  String get circleCountdownSubtitle => 'Circle กำลังเริ่ม...';

  @override
  String get userFallbackName => 'ผู้ใช้';

  @override
  String get micOff => 'ไมค์ปิด';

  @override
  String get micOn => 'ไมค์เปิด';

  @override
  String get roleHost => 'โฮสต์';

  @override
  String get roleSpectator => 'ผู้ชม';

  @override
  String get tagHost => 'โฮสต์';

  @override
  String get tagYou => 'คุณ';

  @override
  String get statusCorrect => 'ถูกต้อง';

  @override
  String get statusWrong => 'ผิด';

  @override
  String get statusWaiting => 'กำลังรอ';

  @override
  String get statusNone => '-';

  @override
  String get pointsAbbrev => 'คะแนน';

  @override
  String get pointsLabel => 'คะแนน';

  @override
  String get statCorrect => 'ถูกต้อง';

  @override
  String get statAnswers => 'คำตอบ';

  @override
  String get statTotal => 'รวม';

  @override
  String get statQuestions => 'คำถาม';

  @override
  String get statAccuracy => 'ความแม่นยำ';

  @override
  String get statRate => 'อัตรา';

  @override
  String get statRank => 'อันดับ';

  @override
  String get statPosition => 'ตำแหน่ง';

  @override
  String get statMode => 'โหมด';

  @override
  String get statType => 'ประเภท';

  @override
  String get next => 'ถัดไป';

  @override
  String get submit => 'ส่ง';

  @override
  String get continueLabel => 'ดำเนินการต่อ';

  @override
  String get save => 'บันทึก';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get backToCourse => 'กลับไปยังคอร์ส';

  @override
  String get resultsTitle => 'ผลลัพธ์';

  @override
  String get shareLater => 'แชร์ภายหลัง';

  @override
  String get delete => 'ลบ';

  @override
  String get ok => 'ตกลง';

  @override
  String minutesShort(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String timeShortMinutes(Object count) {
    return '$count นาที';
  }

  @override
  String timeShortHours(Object count) {
    return '$count ชม.';
  }

  @override
  String timeShortDays(Object count) {
    return '$count วัน';
  }

  @override
  String get timeJustNow => 'เมื่อสักครู่';

  @override
  String timeMinutesAgo(Object count) {
    return '$count นาทีที่แล้ว';
  }

  @override
  String timeHoursAgo(Object count) {
    return '$count ชั่วโมงที่แล้ว';
  }

  @override
  String timeDaysAgo(Object count) {
    return '$count วันที่แล้ว';
  }

  @override
  String get liveQuizWaitingForHost => 'กำลังรอโฮสต์...';

  @override
  String get liveQuizJoinRequestSent => 'ส่งคำขอเข้าร่วมแล้ว';

  @override
  String liveQuizJoinRequestFailed(Object error) {
    return 'คำขอล้มเหลว: $error';
  }

  @override
  String get liveQuizHostControlsTitle => 'การควบคุมโฮสต์';

  @override
  String get liveQuizSpectatorModeTitle => 'โหมดผู้ชม';

  @override
  String get liveQuizHostControlsSubtitle =>
      'รอบจะดำเนินไปโดยอัตโนมัติเมื่อทุกคนตอบหรือหมดเวลา';

  @override
  String get liveQuizSpectatorModeSubtitle =>
      'ดูคำถามและกระดานคะแนนแบบสด คุณไม่สามารถตอบคำถามได้';

  @override
  String liveQuizQuestionCounter(Object current, Object total) {
    return 'คำถาม $current/$total';
  }

  @override
  String get liveQuizRequestSent => 'ส่งคำขอแล้ว';

  @override
  String get liveQuizRequestToJoin => 'ขอเข้าร่วม';

  @override
  String get liveQuizSpectatorFooter =>
      'คุณกำลังดูแบบสด เพลิดเพลินกับคำถามและกระดานคะแนน';

  @override
  String get circleNotFound => 'ไม่พบ Circle';

  @override
  String resultsRematchStartFailed(Object error) {
    return 'เริ่มการแข่งขันซ้ำไม่สำเร็จ: $error';
  }

  @override
  String get resultsMatchTitle => 'ผลการแข่งขัน';

  @override
  String resultsNiceWork(Object name) {
    return 'ทำได้ดี $name';
  }

  @override
  String get resultsPlaceFirst => 'ที่ 1';

  @override
  String get resultsPlaceSecond => 'ที่ 2';

  @override
  String get resultsPlaceThird => 'ที่ 3';

  @override
  String resultsPlaceNth(Object rank) {
    return 'ที่ $rank';
  }

  @override
  String resultsOutOfPlayers(Object players) {
    return 'จาก $players ผู้เล่น';
  }

  @override
  String get resultsHighlightChampion => 'แชมป์! คุณพิชิต Circle นี้แล้ว';

  @override
  String get resultsHighlightGreatAccuracy =>
      'ความแม่นยำยอดเยี่ยม คุณเกือบถึงจุดสูงสุดแล้ว!';

  @override
  String get resultsHighlightKeepGoing =>
      'ทำต่อไป - ความสม่ำเสมอเอาชนะความเร็ว';

  @override
  String get resultsLeaderboardTitle => 'กระดานผู้นำ';

  @override
  String resultsPlayersCount(Object count) {
    return '$count ผู้เล่น';
  }

  @override
  String get resultsBackToCircles => 'กลับไปยัง Circles';

  @override
  String get resultsRematch => 'แข่งซ้ำ';

  @override
  String get resultsPlayAgain => 'เล่นอีกครั้ง';

  @override
  String get leaderboardGlobalTitle => 'กระดานผู้นำทั่วโลก';

  @override
  String get leaderboardEmpty => 'ยังไม่มีกระดานผู้นำ';

  @override
  String get aboutTitle => 'เกี่ยวกับ';

  @override
  String aboutVersion(Object version) {
    return 'เวอร์ชัน $version';
  }

  @override
  String get aboutDescription =>
      'SOMA เป็นแพลตฟอร์มเรียนภาษาแบบเกมมิฟิเคชันที่ทำให้การเรียนภาษาใหม่สนุกและเป็นสังคม เข้าร่วม Circles ฝึกฝนเดี่ยว และติดตามความคืบหน้าของคุณ';

  @override
  String get aboutTerms => 'ข้อกำหนดการให้บริการ';

  @override
  String get aboutPrivacy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get aboutOpenSource => 'สิทธิ์การใช้งานโอเพนซอร์ส';

  @override
  String get addFriendTitle => 'เพิ่มเพื่อน';

  @override
  String get addFriendFindByUsername => 'ค้นหาตามชื่อผู้ใช้';

  @override
  String get addFriendUsernameHint => 'ใส่ชื่อผู้ใช้...';

  @override
  String get addFriendTip =>
      'เคล็ดลับ: รองรับ QR code + รหัสเพื่อนจะเพิ่มในภายหลัง';

  @override
  String get addFriendSending => 'กำลังส่ง...';

  @override
  String get addFriendSendRequest => 'ส่งคำขอ';

  @override
  String addFriendUserNotFound(Object username) {
    return 'ไม่พบ @$username';
  }

  @override
  String addFriendRequestFailed(Object error) {
    return 'การดำเนินการล้มเหลวหรือส่งแล้ว: $error';
  }

  @override
  String get friendsTitle => 'เพื่อน';

  @override
  String get searchFriendsHint => 'ค้นหาเพื่อน...';

  @override
  String get somaLearnerSubtitle => 'ผู้เรียน Soma';

  @override
  String get friendRequestLabel => 'คำขอ';

  @override
  String get friendRequestSentLabel => 'ส่งคำขอแล้ว';

  @override
  String get friendIncomingRequestLabel => 'คำขอเข้ามา';

  @override
  String get friendRequestsSection => 'คำขอ';

  @override
  String get friendPendingSection => 'รอดำเนินการ';

  @override
  String get friendAllSection => 'เพื่อนทั้งหมด';

  @override
  String get friendsEmptyState => 'ยังไม่มีเพื่อน เพิ่มเพื่อนคนแรกของคุณ!';

  @override
  String get friendsEmptyShort => 'ยังไม่มีเพื่อน';

  @override
  String noMatchForQuery(Object query) {
    return 'ไม่พบผลลัพธ์สำหรับ \\\"$query\\\"';
  }

  @override
  String get inboxTitle => 'กล่องข้อความ';

  @override
  String get searchChatsHint => 'ค้นหาแชท...';

  @override
  String get inboxEmptyState => 'ยังไม่มีแชท เริ่มแชทกับเพื่อน!';

  @override
  String get newMessageTitle => 'ข้อความใหม่';

  @override
  String get chatCallLater => 'โทรเสียงภายหลัง (ภาษา Circle เร็วๆ นี้)';

  @override
  String errorWithDetails(Object error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String chatSayHi(Object name) {
    return 'ทักทาย $name!';
  }

  @override
  String get chatMessageHint => 'ข้อความ...';

  @override
  String get notificationsTitle => 'การแจ้งเตือน';

  @override
  String get notificationsTabAll => 'ทั้งหมด';

  @override
  String get notificationsTabCourses => 'คอร์ส';

  @override
  String get notificationsTabSocial => 'โซเชียล';

  @override
  String get notificationsTabCircles => 'Circles';

  @override
  String get notificationsTabSystem => 'ระบบ';

  @override
  String get notificationsEmpty => 'ไม่มีการแจ้งเตือน';

  @override
  String get notificationsDeleted => 'ลบการแจ้งเตือนแล้ว';

  @override
  String get notificationTitleFallback => 'การแจ้งเตือน';

  @override
  String get notificationTypeCourse => 'คอร์ส';

  @override
  String get notificationTypeSocial => 'โซเชียล';

  @override
  String get notificationTypeCircle => 'Circle';

  @override
  String get notificationTypeSystem => 'ระบบ';

  @override
  String get notificationsFriendAccepted => 'ยอมรับคำขอเพิ่มเพื่อนแล้ว';

  @override
  String notificationsFriendAcceptFailed(Object error) {
    return 'ยอมรับคำขอไม่สำเร็จ: $error';
  }

  @override
  String get notificationsFriendDeclined => 'ปฏิเสธคำขอเพิ่มเพื่อนแล้ว';

  @override
  String notificationsFriendDeclineFailed(Object error) {
    return 'ปฏิเสธคำขอไม่สำเร็จ: $error';
  }

  @override
  String notificationsJoinCircleFailed(Object error) {
    return 'เข้าร่วม Circle ไม่สำเร็จ: $error';
  }

  @override
  String get notificationsOpening => 'กำลังเปิด';

  @override
  String get notificationsOpened => 'เปิดแล้ว';

  @override
  String notificationsActionMessage(Object action) {
    return '$action การแจ้งเตือน';
  }

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsSectionAccount => 'บัญชี';

  @override
  String get settingsEditProfile => 'แก้ไขโปรไฟล์';

  @override
  String get settingsPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get settingsSecurity => 'ความปลอดภัย';

  @override
  String get settingsSectionGameplay => 'การเล่นเกม';

  @override
  String get settingsShowTranslationLine => 'แสดงบรรทัดคำแปล';

  @override
  String get settingsShowReadingLine => 'แสดงการอ่าน (Pinyin/Romaji)';

  @override
  String get settingsDefaultTimerPerQuestion => 'ตัวจับเวลาเริ่มต้นต่อคำถาม';

  @override
  String get settingsMatchDifficulty => 'ความยากในการแข่งขัน';

  @override
  String get settingsMatchDifficultyAdaptive => 'ปรับตัว';

  @override
  String get settingsSectionSoundFeel => 'เสียงและความรู้สึก';

  @override
  String get settingsMusic => 'ดนตรี';

  @override
  String get settingsSoundEffects => 'เอฟเฟกต์เสียง';

  @override
  String get settingsHaptics => 'การสั่นสะเทือน';

  @override
  String get settingsSectionNotifications => 'การแจ้งเตือน';

  @override
  String get settingsPushNotifications => 'การแจ้งเตือนแบบพุช';

  @override
  String get settingsDailyReminder => 'การเตือนรายวัน';

  @override
  String get settingsSectionAppearance => 'รูปลักษณ์';

  @override
  String get settingsTheme => 'ธีม';

  @override
  String get settingsUiLanguage => 'ภาษาอินเตอร์เฟซ';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับ';

  @override
  String get settingsVersion => 'เวอร์ชัน';

  @override
  String get settingsTermsPrivacy => 'ข้อกำหนดและความเป็นส่วนตัว';

  @override
  String get settingsSupport => 'การสนับสนุน';

  @override
  String get settingsLogout => 'ออกจากระบบ';

  @override
  String get themeSystem => 'ระบบ';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeLight => 'สว่าง';

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
  String get editProfileUpdated => 'อัปเดตโปรไฟล์แล้ว';

  @override
  String get editProfileTitle => 'แก้ไขโปรไฟล์';

  @override
  String get editProfilePhotoLabel => 'รูปโปรไฟล์';

  @override
  String get editProfilePhotoSubtitle =>
      'การเลือกอวาตาร์ผ่าน Supabase Storage เร็วๆ นี้';

  @override
  String get editProfileChangePhoto => 'เปลี่ยน';

  @override
  String get editProfileAvatarUploadSoon => 'อัปโหลดอวาตาร์เร็วๆ นี้';

  @override
  String get editProfileDisplayNameLabel => 'ชื่อที่แสดง';

  @override
  String get editProfileDisplayNameHint => 'ชื่อของคุณ';

  @override
  String get editProfileDisplayNameRequired => 'กรุณาใส่ชื่อ';

  @override
  String get editProfileDisplayNameTooShort => 'สั้นเกินไป';

  @override
  String get editProfileUsernameLabel => 'ชื่อผู้ใช้';

  @override
  String get editProfileUsernameHint => 'somchai_learner';

  @override
  String get editProfileUsernameRequired => 'กรุณาใส่ชื่อผู้ใช้';

  @override
  String get editProfileUsernameTooShort => 'อย่างน้อย 3 ตัวอักษร';

  @override
  String get editProfileUsernameInvalid => 'อนุญาตเฉพาะตัวอักษร ตัวเลข _';

  @override
  String get editProfileBioLabel => 'ประวัติ';

  @override
  String get editProfileBioHint => 'ประวัติสั้นๆ...';

  @override
  String get editProfileBioTooLong => 'สูงสุด 120 ตัวอักษร';

  @override
  String get editProfileLocationLabel => 'ที่อยู่';

  @override
  String get editProfileLocationHint => 'เมือง / ประเทศ';

  @override
  String get editProfileDailyGoalTitle => 'เป้าหมายรายวัน';

  @override
  String get editProfileDailyGoalSubtitle =>
      'เลือกจำนวนนาทีที่คุณต้องการเรียนในแต่ละวัน';

  @override
  String get securityTitle => 'ความปลอดภัย';

  @override
  String get securitySectionPassword => 'รหัสผ่าน';

  @override
  String get securityChangePasswordTitle => 'เปลี่ยนรหัสผ่าน';

  @override
  String get securityChangePasswordSubtitle => 'อัปเดตรหัสผ่านของคุณเป็นประจำ';

  @override
  String get securitySectionTwoFactor => 'การยืนยันตัวตนแบบสองปัจจัย';

  @override
  String get securityEnable2faTitle => 'เปิดใช้งาน 2FA';

  @override
  String get securityEnable2faSubtitle =>
      'ความปลอดภัยเพิ่มเติมเมื่อเข้าสู่ระบบ';

  @override
  String get securitySectionAppLock => 'ล็อคแอป';

  @override
  String get securityBiometricTitle => 'ปลดล็อคด้วยไบโอเมตริก';

  @override
  String get securityBiometricSubtitle =>
      'ใช้ FaceID/TouchID เพื่อปลดล็อค SOMA';

  @override
  String get securityAppLockTitle => 'ล็อคแอป';

  @override
  String get securityAppLockSubtitle => 'ล็อค SOMA เมื่อออกจากแอป';

  @override
  String get securitySectionSessions => 'เซสชันที่ใช้งานอยู่';

  @override
  String get securityNoSessions => 'ไม่พบเซสชันที่ใช้งานอยู่';

  @override
  String get securityThisDevice => 'อุปกรณ์นี้';

  @override
  String get securityDevice => 'อุปกรณ์';

  @override
  String get securityActiveLabel => 'ใช้งานอยู่';

  @override
  String get securitySignInToEnable2fa => 'เข้าสู่ระบบเพื่อเปิดใช้งาน 2FA';

  @override
  String securityEnable2faFailed(Object error) {
    return 'เปิดใช้งาน 2FA ไม่สำเร็จ: $error';
  }

  @override
  String securityDisable2faFailed(Object error) {
    return 'ปิดใช้งาน 2FA ไม่สำเร็จ: $error';
  }

  @override
  String get securitySetup2faTitle => 'ตั้งค่า 2FA';

  @override
  String get securitySecretKeyLabel => 'คีย์ลับ';

  @override
  String get securityCodeHint => 'รหัส 6 หลัก';

  @override
  String get security2faEnabled => 'เปิดใช้งาน 2FA แล้ว';

  @override
  String securityVerifyCodeFailed(Object error) {
    return 'ตรวจสอบรหัสไม่สำเร็จ: $error';
  }

  @override
  String get securityVerifying => 'กำลังตรวจสอบ...';

  @override
  String get securityVerify => 'ตรวจสอบ';

  @override
  String get securityCurrentPasswordHint => 'รหัสผ่านปัจจุบัน';

  @override
  String get securityNewPasswordHint => 'รหัสผ่านใหม่ (อย่างน้อย 8 ตัวอักษร)';

  @override
  String get securityConfirmPasswordHint => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get securitySignInToChangePassword =>
      'เข้าสู่ระบบเพื่อเปลี่ยนรหัสผ่าน';

  @override
  String get securityEnterCurrentPassword => 'กรุณาใส่รหัสผ่านปัจจุบัน';

  @override
  String get securityPasswordMinLength =>
      'รหัสผ่านใหม่ต้องมีอย่างน้อย 8 ตัวอักษร';

  @override
  String get securityPasswordsDoNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get securityPasswordUpdated => 'อัปเดตรหัสผ่านแล้ว';

  @override
  String securityPasswordUpdateFailed(Object error) {
    return 'อัปเดตรหัสผ่านไม่สำเร็จ: $error';
  }

  @override
  String get securityAutoLockAfter => 'ล็อคอัตโนมัติหลังจาก';

  @override
  String get privacyTitle => 'ความเป็นส่วนตัว';

  @override
  String get privacySectionVisibility => 'การมองเห็น';

  @override
  String get privacyProfileVisibilityTitle => 'การมองเห็นโปรไฟล์';

  @override
  String get privacyVisibilityPublic => 'สาธารณะ';

  @override
  String get privacyVisibilityFriends => 'เพื่อน';

  @override
  String get privacyVisibilityPrivate => 'ส่วนตัว';

  @override
  String get privacyVisibilityPublicSubtitle =>
      'ทุกคนสามารถเห็นโปรไฟล์ของคุณได้';

  @override
  String get privacyVisibilityFriendsSubtitle =>
      'เฉพาะเพื่อนเท่านั้นที่เห็นโปรไฟล์ของคุณได้';

  @override
  String get privacyVisibilityPrivateSubtitle =>
      'เฉพาะคุณเท่านั้นที่เห็นโปรไฟล์ได้';

  @override
  String get privacySectionActivity => 'กิจกรรม';

  @override
  String get privacyShowOnlineTitle => 'แสดงสถานะออนไลน์';

  @override
  String get privacyShowOnlineSubtitle => 'ให้ผู้อื่นเห็นว่าคุณออนไลน์';

  @override
  String get privacyShowActivityTitle => 'แสดงกิจกรรมการเรียนรู้';

  @override
  String get privacyShowActivitySubtitle =>
      'แสดงสถิติต่อเนื่อง XP และความคืบหน้าปัจจุบัน';

  @override
  String get privacySectionSocial => 'โซเชียล';

  @override
  String get privacyAllowRequestsTitle => 'อนุญาตคำขอเพิ่มเพื่อน';

  @override
  String get privacyAllowRequestsSubtitle =>
      'อนุญาตให้ผู้อื่นส่งคำขอเพิ่มเพื่อน';

  @override
  String get privacyWhoCanDmTitle => 'ใครสามารถส่ง DM ได้';

  @override
  String get privacyDmEveryone => 'ทุกคน';

  @override
  String get privacyDmFriends => 'เพื่อน';

  @override
  String get privacyDmNoOne => 'ไม่มีใคร';

  @override
  String get privacyDmEveryoneSubtitle => 'ทุกคนสามารถส่ง DM ให้คุณได้';

  @override
  String get privacyDmFriendsSubtitle =>
      'เฉพาะเพื่อนเท่านั้นที่ส่ง DM ให้คุณได้';

  @override
  String get privacyDmNoOneSubtitle => 'ไม่มีใครส่ง DM ให้คุณได้';

  @override
  String get privacySectionBlockedUsers => 'ผู้ใช้ที่ถูกบล็อค';

  @override
  String get privacyBlockedUsersComingSoon =>
      'การจัดการผู้ใช้ที่ถูกบล็อคเร็วๆ นี้';

  @override
  String get privacySectionDataControls => 'การควบคุมข้อมูล';

  @override
  String get privacyExportDataTitle => 'ส่งออกข้อมูล';

  @override
  String get privacyExportDataSubtitle => 'ดาวน์โหลดกิจกรรมและคอร์สของคุณ';

  @override
  String get privacyExportInfoTitle => 'ส่งออกข้อมูล';

  @override
  String get privacyExportInfoBody =>
      'ขั้นตอนถัดไป: สร้างไฟล์ส่งออก JSON/CSV และส่งทางอีเมลหรือดาวน์โหลดในเครื่อง';

  @override
  String get privacyDeleteAccountTitle => 'ลบบัญชี';

  @override
  String get privacyDeleteAccountSubtitle =>
      'การกระทำนี้จะลบบัญชีและข้อมูลของคุณอย่างถาวร';

  @override
  String get privacyDeleteConfirmTitle => 'ลบบัญชีหรือไม่?';

  @override
  String get privacyDeleteConfirmBody =>
      'การกระทำนี้ไม่สามารถย้อนกลับได้ โปรไฟล์ คอร์ส เพื่อน และข้อความของคุณจะถูกลบ';

  @override
  String get privacyDeleteComingSoon =>
      'การลบจะเชื่อมต่อกับ Supabase ในภายหลัง';

  @override
  String get soloLabel => 'เดี่ยว';

  @override
  String get soloResultsCompletedTitle => 'เซสชันเดี่ยวเสร็จสิ้น';

  @override
  String get soloResultsFeedbackElite => 'ผลงานระดับยอด รักษาสถิติต่อเนื่องไว้';

  @override
  String get soloResultsFeedbackStrong =>
      'แข็งแกร่ง คุณกำลังเติบโตอย่างรวดเร็ว';

  @override
  String get soloResultsFeedbackProgress =>
      'ความคืบหน้าที่ดี ทบทวนข้อผิดพลาดและลองใหม่';

  @override
  String get soloResultsFeedbackTryAgain =>
      'ไม่ต้องเครียด ลองใหม่ด้วยคำถามน้อยลงและโฟกัส';

  @override
  String get soloResultsPerfectScore => 'คะแนนสมบูรณ์! ไม่มีข้อผิดพลาดให้ทบทวน';

  @override
  String get soloResultsReviewPrompt =>
      'ทบทวนข้อผิดพลาดเพื่อเรียนรู้เร็วขึ้น คำตอบที่ผิดของคุณอยู่ด้านล่าง';

  @override
  String soloResultsReviewMistakes(Object count) {
    return 'ทบทวนข้อผิดพลาด ($count)';
  }

  @override
  String get authNotSignedIn => 'ยังไม่ได้เข้าสู่ระบบ';

  @override
  String get genericUser => 'ผู้ใช้';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get edit => 'แก้ไข';

  @override
  String get send => 'ส่ง';

  @override
  String get join => 'เข้าร่วม';

  @override
  String get leave => 'ออก';

  @override
  String get ready => 'พร้อม';

  @override
  String get levelBeginner => 'เริ่มต้น';

  @override
  String get levelIntermediate => 'กลาง';

  @override
  String get levelAdvanced => 'ขั้นสูง';

  @override
  String questionsShort(Object count) {
    return '$count คำถาม';
  }

  @override
  String secondsShort(Object count) {
    return '$count วิ';
  }

  @override
  String get circlesAllCourses => 'คอร์สทั้งหมด';

  @override
  String get circlesAllModes => 'โหมดทั้งหมด';

  @override
  String get circlesAllLevels => 'ระดับทั้งหมด';

  @override
  String get circlesAddNewCourse => 'เพิ่มคอร์สใหม่';

  @override
  String get circlesCoursesTitle => 'คอร์ส';

  @override
  String get circlesModeTitle => 'โหมด';

  @override
  String get circlesLevelTitle => 'ระดับ';

  @override
  String get circlesNoActiveForFilters =>
      'ไม่มี Circles ที่ใช้งานอยู่สำหรับตัวกรองนี้';

  @override
  String get circlesUnknownRoom => 'ห้องที่ไม่รู้จัก';

  @override
  String circlesRoomLine(Object from, Object to, Object mode, Object level) {
    return '$from -> $to - $mode - $level';
  }

  @override
  String get circlesCreateCircle => 'สร้าง Circle';

  @override
  String get circlesCircleName => 'ชื่อ Circle';

  @override
  String get circlesEnterName => 'ใส่ชื่อ';

  @override
  String get circlesLanguages => 'ภาษา';

  @override
  String get circlesRoomSetup => 'การตั้งค่าห้อง';

  @override
  String get circlesPlayers => 'ผู้เล่น';

  @override
  String get circlesEmptySlot => 'ช่องว่าง';

  @override
  String get circlesPlayersRange => '1-5 ผู้เล่น';

  @override
  String get circlesQuestions => 'คำถาม';

  @override
  String get circlesQuestionsSubtitle => 'จำนวนคำถาม';

  @override
  String get circlesTimePerQuestion => 'เวลาต่อคำถาม';

  @override
  String get circlesSecondsPerQuestion => 'วินาทีต่อคำถาม';

  @override
  String get circlesAdvanced => 'ขั้นสูง';

  @override
  String get circlesAllowSpectators => 'อนุญาตผู้ชม';

  @override
  String get circlesAllowSpectatorsSubtitle => 'อนุญาตให้ผู้อื่นดูโดยไม่เล่น';

  @override
  String get circlesLiveVoiceChat => 'แชทด้วยเสียงแบบสด';

  @override
  String get circlesLiveVoiceChatSubtitle =>
      'เปิดใช้งานเสียงแบบสดระหว่างการแข่งขัน';

  @override
  String get circlesLiveTextChat => 'แชทข้อความแบบสด';

  @override
  String get circlesLiveTextChatSubtitle => 'เปิดใช้งานแชทระหว่างการแข่งขัน';

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
  String get circlesCreatedSuccess => 'สร้าง Circle แล้ว';

  @override
  String circlesCreateError(Object error) {
    return 'สร้าง Circle ไม่สำเร็จ: $error';
  }

  @override
  String get circlesHostTip => 'เคล็ดลับ: คุณสามารถเชิญเพื่อนหลังจากสร้างแล้ว';

  @override
  String circlesJoinError(Object error) {
    return 'เข้าร่วม Circle ไม่สำเร็จ: $error';
  }

  @override
  String get circlesLobbyTitle => 'ล็อบบี้ Circle';

  @override
  String circlesCodeLine(Object code, Object current, Object max) {
    return 'รหัส: $code - $current/$max';
  }

  @override
  String get circlesMatchSettings => 'การตั้งค่าการแข่งขัน';

  @override
  String circlesLevelWithValue(Object level) {
    return 'ระดับ $level';
  }

  @override
  String get circlesDifficulty => 'ความยาก';

  @override
  String get circlesPerQuestionShort => 'ต่อคำถาม';

  @override
  String get circlesInvite => 'เชิญ';

  @override
  String get circlesCopyId => 'คัดลอกรหัส';

  @override
  String get circlesCopiedId => 'คัดลอกรหัสแล้ว';

  @override
  String get circlesMatchInProgress => 'การแข่งขันกำลังดำเนินอยู่';

  @override
  String get circlesSpectatorQueuedBody =>
      'การแข่งขันกำลังดำเนินอยู่ เข้าร่วมในฐานะผู้ชม';

  @override
  String get circlesHostStartWhenReady => 'โฮสต์จะเริ่มเมื่อทุกคนพร้อม';

  @override
  String get circlesSpectators => 'ผู้ชม';

  @override
  String get circlesSpectator => 'ผู้ชม';

  @override
  String get circlesSpectatorCanWatch => 'ผู้ชมสามารถดูแบบสดได้';

  @override
  String get circlesJoinRequests => 'คำขอเข้าร่วม';

  @override
  String get circlesAcceptSpectatorsHint => 'อนุมัติผู้ชมก่อนเริ่มการแข่งขัน';

  @override
  String get circlesStartGame => 'เริ่มเกม';

  @override
  String get circlesWaitingForPlayers => 'กำลังรอผู้เล่น';

  @override
  String get circlesLeaveCircle => 'ออกจาก Circle';

  @override
  String get circlesRequestSent => 'ส่งคำขอแล้ว';

  @override
  String get circlesRequestToJoin => 'ขอเข้าร่วม';

  @override
  String get circlesWatchLive => 'ดูแบบสด';

  @override
  String get circlesPlayerTip => 'แตะพร้อมเมื่อคุณพร้อม โฮสต์จะเริ่มการแข่งขัน';

  @override
  String get circlesSpectatorTip => 'คุณกำลังดู ดูแบบสดเมื่อโฮสต์เริ่ม';

  @override
  String get circlesHostControls => 'การควบคุมโฮสต์';

  @override
  String circlesTransferHostFailed(Object error) {
    return 'โอนโฮสต์ไม่สำเร็จ: $error';
  }

  @override
  String circlesEndCircleFailed(Object error) {
    return 'จบ Circle ไม่สำเร็จ: $error';
  }

  @override
  String circlesUserNotFound(Object username) {
    return 'ไม่พบ @$username';
  }

  @override
  String get circlesInvalidUser => 'ผู้ใช้ไม่ถูกต้อง';

  @override
  String get circlesCantInviteSelf => 'ไม่สามารถเชิญตัวเองได้';

  @override
  String circlesUserAlreadyInCircle(Object username) {
    return '@$username อยู่ใน Circle แล้ว';
  }

  @override
  String get circlesDefaultHost => 'โฮสต์';

  @override
  String get circlesDefaultTitle => 'Circle';

  @override
  String get circlesInviteByUsername => 'เชิญด้วยชื่อผู้ใช้';

  @override
  String circlesInviteSent(Object username) {
    return 'ส่งคำเชิญไปยัง @$username แล้ว';
  }

  @override
  String circlesInviteFailed(Object error) {
    return 'ส่งคำเชิญไม่สำเร็จ: $error';
  }

  @override
  String get circlesJoinRequestSent => 'ส่งคำขอเข้าร่วมแล้ว';

  @override
  String circlesJoinRequestFailed(Object error) {
    return 'คำขอล้มเหลว: $error';
  }

  @override
  String get circlesFull => 'Circle เต็มแล้ว';

  @override
  String get circlesSpectatorAdded => 'เพิ่มผู้ชมแล้ว';

  @override
  String circlesApproveFailed(Object error) {
    return 'อนุมัติคำขอไม่สำเร็จ: $error';
  }

  @override
  String get circlesRequestDeclined => 'ปฏิเสธคำขอแล้ว';

  @override
  String circlesDeclineFailed(Object error) {
    return 'ปฏิเสธคำขอไม่สำเร็จ: $error';
  }

  @override
  String get circlesParticipant => 'ผู้เข้าร่วม';

  @override
  String get circlesLeavePromptTitle => 'ออกจาก Circle หรือไม่?';

  @override
  String get circlesLeavePromptTransfer => 'กรุณาโอนโฮสต์ก่อนออก';

  @override
  String get circlesLeavePromptEndOnly => 'จบ Circle และออก';

  @override
  String get circlesTransferHost => 'โอนโฮสต์';

  @override
  String get circlesEndCircle => 'จบ Circle';

  @override
  String get circlesTransferHostTitle => 'โอนโฮสต์';

  @override
  String circlesShareId(Object id) {
    return 'รหัส Circle: $id';
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
