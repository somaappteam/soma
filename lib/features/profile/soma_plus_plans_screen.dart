import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/glass.dart';
import '../../core/widgets/soma_plus_plan_cards.dart';
import '../../data/soma_plus_repository.dart';
import '../../data/settings_repository.dart';

class SomaPlusPlansScreen extends StatelessWidget {
  const SomaPlusPlansScreen({super.key});

  Future<void> _selectTier(SomaSubscriptionTier tier) async {
    if (tier == SomaSubscriptionTier.free) {
      await settingsRepository.updateSettings({
        'plus_plan': SomaPlusRepository.serializeTier(tier),
        'plus_enabled': false,
      });
      return;
    }
    await settingsRepository.updateSettings({
      'plus_plan': SomaPlusRepository.serializeTier(tier),
      'plus_enabled': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(S.md, S.sm, S.md, S.md),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.pop(context),
                    child: Glass(
                      radius: BorderRadius.circular(16),
                      padding: const EdgeInsets.all(S.xs),
                      child: Icon(Icons.arrow_back_rounded,
                          color: scheme.onSurface.withValues(alpha: 0.9)),
                    ),
                  ),
                  const SizedBox(width: S.sm),
                  const Text(
                    'Soma Plus',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: S.sm),
              Expanded(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: settingsRepository.getSettingsStream(),
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? const <String, dynamic>{};
                    final tier =
                        SomaPlusRepository.parseTier(data['plus_plan']?.toString());

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          'Choose the plan that fits your learning goals.',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.66),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: S.xs),
                        SomaPlusPlanCards(
                          currentTier: tier,
                          onSelect: _selectTier,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
