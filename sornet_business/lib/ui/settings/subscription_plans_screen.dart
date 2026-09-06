import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/subscription_plan.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  bool _isYearly = true;
  String _currentPlanId = 'plan-pro';

  @override
  Widget build(BuildContext context) {
    final plans = MockData.subscriptionPlans;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Subscription & Plans'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              const Text(
                'Supercharge Your Technician Hiring',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Unlock verified skill tests, unlimited direct messaging, and advanced side-by-side comparison tools.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // Billing Cycle Switcher (Monthly vs Yearly)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isYearly = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: !_isYearly ? AppTheme.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !_isYearly ? AppTheme.cardShadow : null,
                        ),
                        child: Text(
                          'Monthly Billing',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: !_isYearly ? AppTheme.primary : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _isYearly = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isYearly ? AppTheme.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _isYearly ? AppTheme.cardShadow : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Annual (Save 20%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _isYearly ? AppTheme.primary : AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.successBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('20% OFF', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.successText)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Plan Cards List
              ...plans.map((plan) => _buildPlanCard(plan)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isCurrent = plan.id == _currentPlanId;
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: plan.isPopular ? AppTheme.primary : AppTheme.border,
          width: plan.isPopular ? 2 : 1,
        ),
        boxShadow: plan.isPopular ? AppTheme.activeShadow : AppTheme.cardShadow,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Current Plan',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.successText),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  plan.description,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 14),

                // Pricing
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price == 0 ? 'Free' : Formatters.formatCurrency(price),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (price > 0)
                      Text(
                        _isYearly ? ' / year' : ' / month',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 14),

                // Features list
                ...plan.features.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          f.isIncluded ? Icons.check_circle_rounded : Icons.cancel_outlined,
                          size: 16,
                          color: f.isIncluded ? AppTheme.primary : AppTheme.border,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f.title,
                            style: TextStyle(
                              fontSize: 12,
                              color: f.isIncluded ? AppTheme.textPrimary : AppTheme.textTertiary,
                              fontWeight: f.isIncluded ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Upgrade / Action Button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: isCurrent
                      ? OutlinedButton(
                          onPressed: null,
                          child: const Text('Active Plan'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() => _currentPlanId = plan.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Upgraded to ${plan.name} plan successfully!'),
                                backgroundColor: AppTheme.success,
                              ),
                            );
                          },
                          child: Text('Upgrade to ${plan.name}'),
                        ),
                ),
              ],
            ),
          ),
          if (plan.isPopular)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: Text(
                  plan.tag,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
