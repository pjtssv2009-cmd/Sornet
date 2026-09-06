import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/offer.dart';
import '../../providers/offer_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/hiring_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';
import '../hiring/my_technicians_screen.dart';

class OffersListScreen extends StatefulWidget {
  final int initialTab;

  const OffersListScreen({super.key, this.initialTab = 0});

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = context.watch<OfferProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Offers Management'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'Sent (${offerProvider.sentOffers.length})'),
            Tab(text: 'Accepted (${offerProvider.acceptedOffers.length})'),
            Tab(text: 'Declined (${offerProvider.rejectedOffers.length})'),
            Tab(text: 'Expired (${offerProvider.expiredOffers.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOffersList(context, offerProvider.sentOffers, offerProvider, OfferStatus.sent),
          _buildOffersList(context, offerProvider.acceptedOffers, offerProvider, OfferStatus.accepted),
          _buildOffersList(context, offerProvider.rejectedOffers, offerProvider, OfferStatus.rejected),
          _buildOffersList(context, offerProvider.expiredOffers, offerProvider, OfferStatus.expired),
        ],
      ),
    );
  }

  Widget _buildOffersList(BuildContext context, List<JobOffer> offers, OfferProvider provider, OfferStatus status) {
    if (offers.isEmpty) {
      return EmptyState(
        icon: Icons.send_outlined,
        title: status == OfferStatus.sent
            ? 'No Pending Offers'
            : status == OfferStatus.accepted
                ? 'No Accepted Offers'
                : 'No Offers in this state',
        message: 'Formal offers extended to candidates will appear here with live tracking.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return _buildOfferCard(context, offer, provider);
      },
    );
  }

  Widget _buildOfferCard(BuildContext context, JobOffer offer, OfferProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    offer.technicianName.isNotEmpty ? offer.technicianName[0] : 'T',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.technicianName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      Text(
                        offer.position,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Job: ${offer.jobTitle}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StatusBadge.offer(offer.status),
              ],
            ),
            const SizedBox(height: 12),

            // Terms Pill
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo('Offered Salary', '${Formatters.formatCurrency(offer.salaryAmount)} / ${offer.salaryPeriod}'),
                      _buildMiniInfo('Joining Date', Formatters.formatDate(offer.joiningDate)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo('Type', offer.employmentType),
                      _buildMiniInfo('Sent', Formatters.timeAgo(offer.sentDate)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (offer.responseRemarks != null) ...[
              Text(
                'Candidate Remarks: "${offer.responseRemarks}"',
                style: const TextStyle(fontSize: 11, color: AppTheme.successText, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
            ],

            // Actions
            if (offer.status == OfferStatus.sent) ...[
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: 'Cancel Offer?',
                        message: 'Are you sure you want to withdraw this offer from ${offer.technicianName}?',
                        confirmText: 'Withdraw Offer',
                        confirmColor: AppTheme.error,
                      );
                      if (confirmed == true) {
                        provider.cancelOffer(offer.id);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    child: const Text('Cancel Offer'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await provider.acceptOffer(offer.id);
                      if (context.mounted) {
                        context.read<HiringProvider>().loadHiredTechnicians();
                        context.read<DashboardProvider>().loadDashboardData();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${offer.technicianName} accepted! Moved to Hired Technicians.'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                    label: const Text('Simulate Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ] else if (offer.status == OfferStatus.accepted) ...[
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyTechniciansScreen()),
                    );
                  },
                  icon: const Icon(Icons.people_rounded, size: 14),
                  label: const Text('View in My Technicians'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }
}
