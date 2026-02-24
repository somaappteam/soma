import 'package:get_it/get_it.dart';
import 'package:soma/data/achievements_repository.dart';
import 'package:soma/data/activity_feed_repository.dart';
import 'package:soma/data/ai_repository.dart';
import 'package:soma/data/app_analytics_repository.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/chat_repository.dart';
import 'package:soma/data/circle_chat_repository.dart';
import 'package:soma/data/circles_repository.dart';
import 'package:soma/data/courses_repository.dart';
import 'package:soma/data/exchange_analytics_repository.dart';
import 'package:soma/data/experiment_repository.dart';
import 'package:soma/data/leaderboard_repository.dart';
import 'package:soma/data/notifications_repository.dart';
import 'package:soma/data/offline_queue_repository.dart';
import 'package:soma/data/presence_repository.dart';
import 'package:soma/data/privacy_repository.dart';
import 'package:soma/data/profile_repository.dart';
import 'package:soma/data/quiz_repository.dart';
import 'package:soma/data/session_repository.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/data/social_repository.dart';
import 'package:soma/data/soma_plus_repository.dart';
import 'package:soma/data/stats_repository.dart';
import 'package:soma/data/user_report_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Pass required dependencies to constructors
  locator.registerLazySingleton<AiRepository>(
    () => AiRepository(SupabaseEdgeFunctionInvoker(Supabase.instance.client)),
  );

  // No-arg constructors
  locator.registerLazySingleton<AchievementsRepository>(
      () => AchievementsRepository());
  locator.registerLazySingleton<ActivityFeedRepository>(
      () => ActivityFeedRepository());
  locator.registerLazySingleton<AppAnalyticsRepository>(
      () => AppAnalyticsRepository());
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<ChatRepository>(() => ChatRepository());
  locator.registerLazySingleton<CirclesRepository>(() => CirclesRepository());
  locator.registerLazySingleton<CircleChatRepository>(
      () => CircleChatRepository());
  locator.registerLazySingleton<CoursesRepository>(() => CoursesRepository());
  locator.registerLazySingleton<ExchangeAnalyticsRepository>(
      () => ExchangeAnalyticsRepository());
  locator.registerLazySingleton<ExperimentRepository>(
      () => ExperimentRepository());
  locator.registerLazySingleton<LeaderboardRepository>(
      () => LeaderboardRepository());
  locator.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepository());
  locator.registerLazySingleton<OfflineQueueRepository>(
      () => OfflineQueueRepository());
  locator.registerLazySingleton<PresenceRepository>(() => PresenceRepository());
  locator.registerLazySingleton<PrivacyRepository>(() => PrivacyRepository());
  locator.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  locator.registerLazySingleton<QuizRepository>(() => QuizRepository());
  locator.registerLazySingleton<SessionRepository>(() => SessionRepository());
  locator.registerLazySingleton<SettingsRepository>(() => SettingsRepository());
  locator.registerLazySingleton<SocialRepository>(() => SocialRepository());
  locator.registerLazySingleton<SomaPlusRepository>(() => SomaPlusRepository());
  locator.registerLazySingleton<StatsRepository>(() => StatsRepository());
  locator.registerLazySingleton<UserReportRepository>(
      () => UserReportRepository());
}
