import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'settings_repository.dart';
import '../core/di/locator.dart';

// ─── Product IDs (must match App Store Connect / Play Console) ───────────────
const kIapPlusMonthly  = 'soma_plus_monthly';
const kIapPlusAnnual   = 'soma_plus_annual';
const kIapProMonthly   = 'soma_pro_monthly';
const kIapProAnnual    = 'soma_pro_annual';

enum SomaSubscriptionTier { free, plus, pro }


class DmPlanLimits {
  final int maxImageBytes;
  final int maxFileBytes;
  final int maxTextChars;
  final int maxVoiceMessageSeconds;

  const DmPlanLimits({
    required this.maxImageBytes,
    required this.maxFileBytes,
    required this.maxTextChars,
    required this.maxVoiceMessageSeconds,
  });
}

class SomaPlanLimits {
  final int? cloudBackupGb;
  final int? voiceMinutesPerDay;
  final int? fileUploadMbPerFile;
  final int? voiceBitrateKbps;

  const SomaPlanLimits({
    this.cloudBackupGb,
    this.voiceMinutesPerDay,
    this.fileUploadMbPerFile,
    this.voiceBitrateKbps,
  });
}

class SomaPlanSla {
  final int firstResponseHours;
  final bool is24x7;
  final String channels;
  final String scope;

  const SomaPlanSla({
    required this.firstResponseHours,
    required this.is24x7,
    required this.channels,
    required this.scope,
  });
}

class SomaPlanCoaching {
  final int sessionsPerMonth;
  final int minutesPerSession;
  final bool allowRollover;
  final String bookingWindow;

  const SomaPlanCoaching({
    required this.sessionsPerMonth,
    required this.minutesPerSession,
    required this.allowRollover,
    required this.bookingWindow,
  });
}

class SomaSubscriptionPlan {
  final SomaSubscriptionTier tier;
  final String title;
  final String tagline;
  final String? priceLabel;
  final String? secondaryPriceLabel;
  final String? secondaryPriceBadge;
  final bool highlighted;
  final List<String> features;
  final List<String> terms;
  final List<String> compliance;
  final SomaPlanLimits limits;
  final SomaPlanSla? sla;
  final SomaPlanCoaching? coaching;
  final String? uptimeTarget;

  const SomaSubscriptionPlan({
    required this.tier,
    required this.title,
    required this.tagline,
    required this.priceLabel,
    this.secondaryPriceLabel,
    this.secondaryPriceBadge,
    required this.highlighted,
    required this.features,
    required this.terms,
    required this.compliance,
    required this.limits,
    this.sla,
    this.coaching,
    this.uptimeTarget,
  });
}

const List<SomaSubscriptionPlan> kSomaSubscriptionPlans = [
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.free,
    title: 'FREE',
    tagline: 'Learn & Play for Free',
    priceLabel: null,
    highlighted: false,
    limits: SomaPlanLimits(
      cloudBackupGb: 0,
      voiceMinutesPerDay: 30,
      fileUploadMbPerFile: 3,
    ),
    features: [
      'Unlimited Solo Learning (offline)',
      'Public Circles access',
      '3 Circle sessions/day (10 min each)',
      'Spectate Circles (60 min/day, voice included)',
      'DM text is free; voice/messages/files have daily limits',
      'Ads only in Solo Learn',
      'Community support only',
      'Upgrade nudge: "You used 90% of daily voice quota"',
    ],
    terms: [
      'No cloud backup (local device only)',
      'Voice usage hard-stop after 30 minutes/day',
      'File uploads limited to 3 MB per file',
      'Monthly billing only (no annual discount)',
    ],
    compliance: [
      'Standard consumer privacy policy applies',
    ],
  ),
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.plus,
    title: 'PLUS',
    tagline: 'Play with Friends',
    priceLabel: '\$4.99 / month',
    secondaryPriceLabel: '\$49.99 / year',
    secondaryPriceBadge: 'SAVE 15%',
    highlighted: true,
    limits: SomaPlanLimits(
      cloudBackupGb: 5,
      fileUploadMbPerFile: 12,
      voiceBitrateKbps: 64,
    ),
    sla: SomaPlanSla(
      firstResponseHours: 24,
      is24x7: false,
      channels: 'chat/email',
      scope: 'First response in business days; resolution time varies by issue type.',
    ),
    features: [
      'No Ads',
      'Unlimited Circle sessions',
      'Unlimited Circle time (10-min matches)',
      'Private Circles',
      'Invite friends to play',
      'Unlimited spectating',
      'Unlimited DM voice calls and voice notes',
      'Weekly learning report with progress forecast',
      'Export progress report (PDF/CSV)',
      'Multi-device session continuity',
    ],
    terms: [
      '5GB cloud sync and backup across devices',
      'File uploads up to 12 MB per file',
      'Standard voice quality up to 64 kbps',
      'Priority support first response in <24h (business days, chat/email)',
      'Cancel anytime (no partial-month refunds)',
    ],
    compliance: [
      'Data encrypted in transit',
      'Consumer data controls available',
    ],
  ),
  SomaSubscriptionPlan(
    tier: SomaSubscriptionTier.pro,
    title: 'PRO',
    tagline: 'Community Pro',
    priceLabel: '\$9.99 / month',
    secondaryPriceLabel: '\$95.99 / year',
    secondaryPriceBadge: 'SAVE 20%',
    highlighted: false,
    limits: SomaPlanLimits(
      cloudBackupGb: -1,
      fileUploadMbPerFile: 24,
      voiceBitrateKbps: 128,
    ),
    sla: SomaPlanSla(
      firstResponseHours: 2,
      is24x7: true,
      channels: 'chat/email',
      scope: 'First response target is 24/7; severity P1 updates every 2 hours.',
    ),
    coaching: SomaPlanCoaching(
      sessionsPerMonth: 2,
      minutesPerSession: 30,
      allowRollover: false,
      bookingWindow: 'Book 7+ days ahead; unused credits expire monthly.',
    ),
    uptimeTarget: '99.9%',
    features: [
      'Everything in Plus',
      'Priority voice connection',
      'Pro badge + profile effects',
      'Premium matchmaking priority',
      'Special events & tournaments',
      'Early access game modes',
      'Unlimited cloud sync with priority processing',
      'Monthly certified assessment with shareable verification link',
      'Advanced speaking dashboard benchmarked against CEFR',
      '2 x 30-minute 1:1 coaching credits per month',
    ],
    terms: [
      'File uploads up to 24 MB per file',
      'High-fidelity voice quality up to 128 kbps',
      'VIP support first response in <2h (24/7, chat/email)',
      'Data retention controls (30/90/365-day options)',
      'Enhanced privacy mode (private profile + metadata minimization)',
      'Priority incident handling with P1 updates every 2h',
      'Cancel anytime (pro-rated refunds within 7 days)',
    ],
    compliance: [
      'Audit logs for account and learning activity',
      'Encryption in transit and at rest',
      'Uptime target: 99.9% for Pro services',
      'Certified assessment includes verification link for authenticity checks',
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
  StreamSubscription<List<PurchaseDetails>>? _iapSub;
  final _supabase = Supabase.instance.client;

  ValueListenable<SomaPlusState> get state => _stateNotifier;

  static DmPlanLimits dmLimitsForTier(SomaSubscriptionTier tier) {
    switch (tier) {
      case SomaSubscriptionTier.pro:
        return const DmPlanLimits(
          maxImageBytes: 10 * 1024 * 1024,
          maxFileBytes: 24 * 1024 * 1024,
          maxTextChars: 3000,
          maxVoiceMessageSeconds: 60,
        );
      case SomaSubscriptionTier.plus:
        return const DmPlanLimits(
          maxImageBytes: 6 * 1024 * 1024,
          maxFileBytes: 12 * 1024 * 1024,
          maxTextChars: 2200,
          maxVoiceMessageSeconds: 60,
        );
      case SomaSubscriptionTier.free:
      default:
        return const DmPlanLimits(
          maxImageBytes: 2 * 1024 * 1024,
          maxFileBytes: 3 * 1024 * 1024,
          maxTextChars: 1200,
          maxVoiceMessageSeconds: 30,
        );
    }
  }

  Future<void> init() async {
    final settings = await settingsRepository.getSettings();
    _stateNotifier.value = _fromSettings(settings);

    _subscription?.cancel();
    _subscription = settingsRepository.getSettingsStream().listen((settings) {
      _stateNotifier.value = _fromSettings(settings);
    });

    // Start IAP purchase stream (mobile only).
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _iapSub?.cancel();
      _iapSub = InAppPurchase.instance.purchaseStream
          .listen(_onPurchaseUpdate, onError: (e) {
        debugPrint('SomaPlusRepository: IAP stream error – $e');
      });
    }

    // Validate subscription server-side (best-effort).
    validateSubscriptionServerSide().ignore();
  }

  void dispose() {
    _subscription?.cancel();
    _iapSub?.cancel();
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

  // ─────────────────────────── In-App Purchase ─────────────────────────────────

  /// Initiates a purchase for the given [productId].
  Future<void> purchaseProduct(String productId) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      debugPrint('SomaPlusRepository: IAP not supported on this platform');
      return;
    }

    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      debugPrint('SomaPlusRepository: IAP not available');
      return;
    }

    final response = await InAppPurchase.instance
        .queryProductDetails({productId});
    if (response.productDetails.isEmpty) {
      debugPrint('SomaPlusRepository: product not found – $productId');
      return;
    }

    final product = response.productDetails.first;
    final param = PurchaseParam(productDetails: product);
    // Subscriptions are treated as non-consumable on iOS, subscription on Android.
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  /// Restores previous purchases (required for App Store compliance).
  Future<void> restorePurchases() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
    await InAppPurchase.instance.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyPurchaseWithServer(purchase);
          await InAppPurchase.instance.completePurchase(purchase);
        case PurchaseStatus.error:
          debugPrint(
              'SomaPlusRepository: purchase error – ${purchase.error}');
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }
        default:
          break;
      }
    }
  }

  Future<void> _verifyPurchaseWithServer(PurchaseDetails purchase) async {
    try {
      final receiptData = Platform.isIOS
          ? (purchase.verificationData.serverVerificationData)
          : (purchase.verificationData.serverVerificationData);

      final response = await _supabase.functions.invoke(
        'verify-purchase',
        body: {
          'platform': Platform.isIOS ? 'ios' : 'android',
          'productId': purchase.productID,
          'receiptData': receiptData,
        },
      );

      final data = response.data as Map<String, dynamic>?;
      if (data?['valid'] == true) {
        final tier = parseTier(data!['tier']?.toString());
        final expiry = DateTime.tryParse(data['expiresAt']?.toString() ?? '');
        await setTier(tier, expiresAt: expiry);
        debugPrint('SomaPlusRepository: purchase verified – tier=$tier');
      } else {
        debugPrint('SomaPlusRepository: receipt rejected by server');
      }
    } catch (e) {
      debugPrint('SomaPlusRepository: server verification failed – $e');
    }
  }

  // ─────────────────────────── Server-side validation ──────────────────────────

  /// Calls the `verify-subscription` Edge Function to server-side validate
  /// the user's current tier. Auto-cancels locally if expired on server.
  Future<void> validateSubscriptionServerSide() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    try {
      final response = await _supabase.functions.invoke(
        'verify-subscription',
        body: {'user_id': uid},
      );
      final data = response.data as Map<String, dynamic>?;
      if (data == null) return;

      final serverTier    = parseTier(data['tier']?.toString());
      final serverActive  = data['isActive'] == true;
      final serverExpiry  = DateTime.tryParse(data['expiresAt']?.toString() ?? '');
      final localState    = _stateNotifier.value;

      // If server says inactive but local thinks active → sync down.
      if (!serverActive && localState.isActive) {
        debugPrint('SomaPlusRepository: server says subscription expired — revoking locally');
        await cancelPlan();
      } else if (serverActive && serverTier != localState.tier) {
        // Server has a different (upgraded) tier — sync it locally.
        await setTier(serverTier, expiresAt: serverExpiry);
      }
    } catch (e) {
      debugPrint('SomaPlusRepository: server validation failed (best-effort) – $e');
    }
  }
}

SomaPlusRepository get somaPlusRepository => locator<SomaPlusRepository>();
