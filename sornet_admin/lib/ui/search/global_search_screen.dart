import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../data/models/business.dart';
import '../../data/models/customer.dart';
import '../../data/models/job.dart';
import '../../providers/sornet_providers.dart';
import '../technicians/technician_detail_screen.dart';
import '../businesses/business_detail_screen.dart';
import '../customers/customer_detail_screen.dart';
import '../jobs/job_detail_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  final List<String> _recentSearches = ['Arun Kumar', 'Daikin AC', 'CoolTech', 'Coimbatore', 'Inverter PCB'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final techProvider = Provider.of<TechniciansProvider>(context);
    final bizProvider = Provider.of<BusinessesProvider>(context);
    final custProvider = Provider.of<CustomersProvider>(context);
    final jobsProvider = Provider.of<JobsProvider>(context);

    final cleanQuery = _query.toLowerCase().trim();

    List<Technician> matchingTechs = [];
    List<Business> matchingBiz = [];
    List<Customer> matchingCust = [];
    List<Job> matchingJobs = [];

    if (cleanQuery.isNotEmpty) {
      matchingTechs = techProvider.technicians.where((t) {
        return t.name.toLowerCase().contains(cleanQuery) ||
            t.primarySkill.toLowerCase().contains(cleanQuery) ||
            t.city.toLowerCase().contains(cleanQuery);
      }).toList();

      matchingBiz = bizProvider.businesses.where((b) {
        return b.businessName.toLowerCase().contains(cleanQuery) ||
            b.city.toLowerCase().contains(cleanQuery) ||
            b.businessType.toLowerCase().contains(cleanQuery);
      }).toList();

      matchingCust = custProvider.customers.where((c) {
        return c.name.toLowerCase().contains(cleanQuery) ||
            c.city.toLowerCase().contains(cleanQuery);
      }).toList();

      matchingJobs = jobsProvider.jobs.where((j) {
        return j.title.toLowerCase().contains(cleanQuery) ||
            j.businessName.toLowerCase().contains(cleanQuery) ||
            j.location.toLowerCase().contains(cleanQuery);
      }).toList();
    }

    final totalResults = matchingTechs.length + matchingBiz.length + matchingCust.length + matchingJobs.length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search technicians, businesses, jobs, customers...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          onChanged: (val) => setState(() => _query = val),
        ),
      ),
      body: _query.isEmpty
          ? _buildRecentSearchesSection()
          : totalResults == 0
              ? _buildNoResultsView()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (matchingTechs.isNotEmpty) ...[
                      _buildSectionHeader('Technicians (${matchingTechs.length})', Icons.engineering_rounded),
                      ...matchingTechs.map((t) => _buildTechResultTile(t)),
                      const SizedBox(height: 14),
                    ],
                    if (matchingBiz.isNotEmpty) ...[
                      _buildSectionHeader('Businesses & Contractors (${matchingBiz.length})', Icons.business_rounded),
                      ...matchingBiz.map((b) => _buildBizResultTile(b)),
                      const SizedBox(height: 14),
                    ],
                    if (matchingJobs.isNotEmpty) ...[
                      _buildSectionHeader('Job Postings (${matchingJobs.length})', Icons.work_rounded),
                      ...matchingJobs.map((j) => _buildJobResultTile(j)),
                      const SizedBox(height: 14),
                    ],
                    if (matchingCust.isNotEmpty) ...[
                      _buildSectionHeader('Customers (${matchingCust.length})', Icons.people_rounded),
                      ...matchingCust.map((c) => _buildCustResultTile(c)),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
    );
  }

  Widget _buildRecentSearchesSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((s) {
              return ActionChip(
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                label: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.textMuted),
                onPressed: () {
                  _searchController.text = s;
                  setState(() => _query = s);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'No items matched "$_query". Try searching for a different name, skill, or location.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTechResultTile(Technician tech) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryLight,
        backgroundImage: tech.profilePhoto.isNotEmpty ? NetworkImage(tech.profilePhoto) : null,
        child: tech.profilePhoto.isEmpty ? Text(tech.name[0]) : null,
      ),
      title: Text(tech.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text('${tech.primarySkill} • ${tech.city}', style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TechnicianDetailScreen(technicianId: tech.id)),
      ),
    );
  }

  Widget _buildBizResultTile(Business biz) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.purpleBg, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.business_rounded, color: AppColors.purple, size: 20),
      ),
      title: Text(biz.businessName, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text('${biz.businessType} • ${biz.city}', style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BusinessDetailScreen(businessId: biz.id)),
      ),
    );
  }

  Widget _buildJobResultTile(Job job) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.work_rounded, color: AppColors.info, size: 20),
      ),
      title: Text(job.title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text('${job.businessName} • ${job.location}', style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => JobDetailScreen(jobId: job.id)),
      ),
    );
  }

  Widget _buildCustResultTile(Customer cust) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryLight,
        child: Text(cust.name[0]),
      ),
      title: Text(cust.name, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Text('${cust.phone} • ${cust.city}', style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CustomerDetailScreen(customerId: cust.id)),
      ),
    );
  }
}
