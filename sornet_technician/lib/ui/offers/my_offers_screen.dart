import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/offer.dart';
import '../../providers/offer_provider.dart';
import '../common/empty_state.dart';
import '../common/status_badge.dart';
import 'offer_detail_screen.dart';

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = Provider.of<OfferProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Hiring Offers'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Pending (${offerProvider.pendingOffers.length})'),
            Tab(text: 'Accepted (${offerProvider.acceptedOffers.length})'),
            Tab(text: 'Rejected (${offerProvider.rejectedOffers.length})'),
            Tab(text: 'Expired (${offerProvider.expiredOffers.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OfferList(
            offers: offerProvider.pendingOffers,
            emptyTitle: 'No pending offers',
            emptySubtitle: 'When companies extend job offers to you, they will appear here.',
            emptyIcon: Icons.local_offer_outlined,
          ),
          _OfferList(
            offers: offerProvider.acceptedOffers,
            emptyTitle: 'No accepted offers',
            emptySubtitle: 'Offers you have accepted will appear here.',
            emptyIcon: Icons.check_circle_outline,
          ),
          _OfferList(
            offers: offerProvider.rejectedOffers,
            emptyTitle: 'No rejected offers',
            emptySubtitle: 'Offers you declined will appear here.',
            emptyIcon: Icons.cancel_outlined,
          ),
          _OfferList(
            offers: offerProvider.expiredOffers,
            emptyTitle: 'No expired offers',
            emptySubtitle: 'Offers that have passed their deadline will appear here.',
            emptyIcon: Icons.timer_off_outlined,
          ),
        ],
      ),
    );
  }
}

class _OfferList extends StatelessWidget {
  final List<JobOffer> offers;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;

  const _OfferList({
    required this.offers,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return Center(
        child: EmptyState(
          icon: emptyIcon,
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final offer = offers[index];
        return _OfferCard(offer: offer);
      },
    );
  }
}

class _OfferCard extends StatelessWidget {
  final JobOffer offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OfferDetailScreen(offerId: offer.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work_outline_rounded,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.jobTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          offer.businessName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: offer.status.label,
                    color: Color(offer.status.badgeColorValue),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Offered Salary',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatSalary(
                            offer.offeredSalary, offer.salaryPeriod),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Joining Date',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatDate(offer.joiningDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (offer.status == OfferStatus.pending) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OfferDetailScreen(offerId: offer.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Review Offer'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
