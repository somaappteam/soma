import 'package:flutter/material.dart';

import 'package:soma/core/theme/spacing.dart';
import 'package:soma/core/widgets/glass.dart';
import 'package:soma/data/soma_plus_repository.dart';

class SomaPlusPlanCards extends StatelessWidget {
  final SomaSubscriptionTier currentTier;
  final ValueChanged<SomaSubscriptionTier> onSelect;

  const SomaPlusPlanCards({
    super.key,
    required this.currentTier,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        for (final plan in kSomaSubscriptionPlans) ...[
          _PlanCard(
            plan: plan,
            selected: plan.tier == currentTier,
            onTap: () => onSelect(plan.tier),
          ),
          if (plan != kSomaSubscriptionPlans.last) const SizedBox(height: S.sm),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SomaSubscriptionPlan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHighlighted = plan.highlighted;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Glass(
        radius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(S.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  plan.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: selected ? scheme.primary : scheme.onSurface,
                  ),
                ),
                if (isHighlighted) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (selected)
                  Icon(Icons.check_circle_rounded,
                      color: scheme.primary, size: 20),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plan.tagline,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.72),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (plan.priceLabel != null) ...[
              const SizedBox(height: 6),
              Text(
                plan.priceLabel!,
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
            if (plan.secondaryPriceLabel != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '⭐ ${plan.secondaryPriceLabel!}',
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                  if (plan.secondaryPriceBadge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        plan.secondaryPriceBadge!,
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            const SizedBox(height: S.sm),
            for (final feature in plan.features)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✔',
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.88),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
