import 'dart:async';

import 'package:flutter/foundation.dart';

import 'settings_repository.dart';

enum SomaSubscriptionTier { free, plus, pro }

class SomaSubscriptionPlan {
  final SomaSubscriptionTier tier;
  final String title;
  final String tagline;
  final String? priceLabel;
  final String? secondaryPriceLabel;
  final String? secondaryPriceBadge;
  final bool highlighted;
  final List<String> features;

  const SomaSubscriptionPlan({
    required this.tier,
    required this.title,
    required this.tagline,
    required this.priceLabel,
    this.secondaryPriceLabel,
    this.secondaryPriceBadge,
    required this.highlighted,
    required this.features,
  });
}

const List<SomaSubscriptionPlan> kSomaSubscriptionPlans = [
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.free,
    title: 'FREE',
    tagline: 'Learn & Play for Free',
    priceLabel: null,
    highlighted: false,
    features: [
      'Unlimited Solo Learning (offline)',
      'Public Circles access',
      '3 Circle sessions/day (10 min each)',
      'Spectate Circles (60 min/day, voice included)',
      'DM text is free; voice/messages/files have daily limits',
      'Ads only in Solo Learn',
    ],
  ),
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.plus,
    title: 'PLUS',
    tagline: 'Play with Friends',
    priceLabel: '\$4.99 / month',
    secondaryPriceLabel: '\$12.99 / 3 months',
    secondaryPriceBadge: 'BEST VALUE',
    highlighted: true,
    features: [
      'No Ads',
      'Unlimited Circle sessions',
      'Unlimited Circle time (10-min matches)',
      'Private Circles',
      'Invite friends to play',
      'Unlimited spectating',
      'Unlimited DM voice calls and voice notes',
      'Unlimited DM photos/documents (size caps apply)',
      'Unlimited Circle voice (max 3 members)',
    ],
  ),
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.pro,
    title: 'PRO',
    tagline: 'Community Pro',
    priceLabel: '\$9.99 / month',
    secondaryPriceLabel: '\$26.99 / 3 months',
    secondaryPriceBadge: 'SAVE 10%',
    highlighted: false,
    features: [
      'Everything in Plus',
      'Priority voice connection',
      'Higher voice quality',
      'Larger DM file & photo size limits',
      'Pro badge + profile effects',
      'Premium matchmaking priority',
      'Special events & tournaments',
      'Early access game modes',
    ],
  ),
];

class SomaPlusState {
  final SomaSubscriptionTier tier;
  final bool isActive;
  final DateTime? trialStartedAt;
  final DateTime? expiresAt;

  const SomaPlusState({
    required this.tier,
    required this.isActive,
    this.trialStartedAt,
    this.expiresAt,
  });

  bool get inTrial {
    if (trialStartedAt == null) return false;
    return DateTime.now().difference(trialStartedAt!).inDays < 7;
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isFree => tier == SomaSubscriptionTier.free;
  bool get isPlus => tier == SomaSubscriptionTier.plus;
  bool get isPro => tier == SomaSubscriptionTier.pro;

  bool hasTierOrHigher(SomaSubscriptionTier minimumTier) {
    const order = {
      SomaSubscriptionTier.free: 0,
      SomaSubscriptionTier.plus: 1,
      SomaSubscriptionTier.pro: 2,
    };
    return (order[tier] ?? 0) >= (order[minimumTier] ?? 0);
  }
}

class SomaPlusRepository {
  final ValueNotifier<SomaPlusState> _stateNotifier = ValueNotifier(
    const SomaPlusState(tier: SomaSubscriptionTier.free, isActive: false),
  );
  StreamSubscription<Map<String, dynamic>>? _subscription;

  ValueListenable<SomaPlusState> get state => _stateNotifier;

  Future<void> init() async {
    final settings = await settingsRepository.getSettings();
    _stateNotifier.value = _fromSettings(settings);

    _subscription?.cancel();
    _subscription = settingsRepository.getSettingsStream().listen((settings) {
      _stateNotifier.value = _fromSettings(settings);
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  bool get isSomaPlus => _stateNotifier.value.isActive && !_stateNotifier.value.isExpired;

  static SomaSubscriptionTier parseTier(String? rawValue) {
    final value = (rawValue ?? '').trim().toLowerCase();
    switch (value) {
      case 'plus':
        return SomaSubscriptionTier.plus;
      case 'pro':
        return SomaSubscriptionTier.pro;
      default:
        return SomaSubscriptionTier.free;
    }
  }

  static String serializeTier(SomaSubscriptionTier tier) {
    switch (tier) {
      case SomaSubscriptionTier.plus:
        return 'plus';
      case SomaSubscriptionTier.pro:
        return 'pro';
      case SomaSubscriptionTier.free:
      default:
        return 'free';
    }
  }

  Future<void> startTrial({int days = 7}) async {
    final now = DateTime.now();
    final expires = now.add(Duration(days: days));
    await settingsRepository.updateSettings({
      'plus_plan': serializeTier(SomaSubscriptionTier.plus),
      'plus_enabled': true,
      'plus_trial_started_at': now.toIso8601String(),
      'plus_expires_at': expires.toIso8601String(),
    });
  }

  Future<void> setTier(SomaSubscriptionTier tier, {DateTime? expiresAt}) async {
    await settingsRepository.updateSettings({
      'plus_plan': serializeTier(tier),
      'plus_enabled': tier != SomaSubscriptionTier.free,
      'plus_expires_at': expiresAt?.toIso8601String(),
    });
  }

  Future<void> cancelPlan() async {
    await settingsRepository.updateSettings({
      'plus_plan': serializeTier(SomaSubscriptionTier.free),
      'plus_enabled': false,
      'plus_expires_at': null,
    });
  }

  SomaPlusState _fromSettings(Map<String, dynamic> settings) {
    final tier = parseTier(settings['plus_plan']?.toString());
    final enabled = settings['plus_enabled'] == true;
    final trialStartedAt =
        DateTime.tryParse(settings['plus_trial_started_at']?.toString() ?? '');
    final expiresAt = DateTime.tryParse(settings['plus_expires_at']?.toString() ?? '');

    final isActive =
        tier != SomaSubscriptionTier.free &&
        enabled &&
        (expiresAt == null || DateTime.now().isBefore(expiresAt));

    return SomaPlusState(
      tier: tier,
      isActive: isActive,
      trialStartedAt: trialStartedAt,
      expiresAt: expiresAt,
    );
  }
}

final somaPlusRepository = SomaPlusRepository();
