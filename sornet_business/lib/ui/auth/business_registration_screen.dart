import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../shell/business_main_shell.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  State<BusinessRegistrationScreen> createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends State<BusinessRegistrationScreen> {
  int _currentStep = 0; // 0 to 5 (Step 1 to 6)

  // Step 1 Controllers
  final _nameController = TextEditingController(text: 'ArcticAir Climate Care');
  String _selectedBusinessType = AppConstants.businessTypes.first;
  final _contactPersonController = TextEditingController(text: 'Rajesh Subramanian');
  final _mobileController = TextEditingController(text: '+91 98840 55443');
  final _emailController = TextEditingController(text: 'rajesh@arcticaircare.in');

  // Step 2 Controllers
  final _addressController = TextEditingController(text: '77, GST Road, Guindy');
  String _selectedCity = 'Chennai';
  final _stateController = TextEditingController(text: 'Tamil Nadu');
  final _pincodeController = TextEditingController(text: '600032');
  final List<String> _selectedOperatingLocations = ['Chennai', 'Coimbatore'];

  // Step 3 Controllers
  int _yearsInBusiness = 6;
  int _employeesCount = 25;
  final List<String> _selectedServices = [
    'Split AC Servicing',
    'Commercial VRF/VRV Installation',
    'PCB Diagnosis & Repair',
    'Annual Maintenance Contracts (AMC)',
  ];

  // Step 4 Documents
  final _gstController = TextEditingController(text: '33AABCT9988Z1Z5');
  bool _hasUploadedGst = true;
  bool _hasUploadedMsme = true;
  bool _hasUploadedAddressProof = true;

  // Step 5 Passwords
  final _passwordController = TextEditingController(text: 'Business@123');
  final _confirmPasswordController = TextEditingController(text: 'Business@123');
  bool _obscurePass = true;

  // Step 6 Submitted
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _gstController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
    } else {
      _submitRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitRegistration() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.registerBusiness(
      businessName: _nameController.text.trim(),
      businessType: _selectedBusinessType,
      contactPerson: _contactPersonController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _selectedCity,
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      operatingLocations: _selectedOperatingLocations,
      yearsInBusiness: _yearsInBusiness,
      numberOfEmployees: _employeesCount,
      servicesOffered: _selectedServices,
      gstNumber: _gstController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      setState(() => _isSubmitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Register Business'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STEP ${_currentStep + 1} OF 6',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      _getStepTitle(_currentStep),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: (_currentStep + 1) / 6,
                backgroundColor: AppTheme.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                minHeight: 4,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(),
              ),
            ),
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      child: Text(
                        _currentStep == 5 ? 'Submit for Verification' : 'Continue',
                        style: const TextStyle(fontWeight: FontWeight.w700),
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

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Business Identity';
      case 1:
        return 'Address & Locations';
      case 2:
        return 'Operations & Services';
      case 3:
        return 'KYC Documents';
      case 4:
        return 'Security & Password';
      case 5:
        return 'Review & Submit';
      default:
        return '';
    }
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      case 5:
        return _buildStep6();
      default:
        return const SizedBox.shrink();
    }
  }

  // STEP 1: Basic Identity
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about your business',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Provide official business details for technician hiring verification.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        _buildLabel('Registered Business Name *'),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'e.g. ArcticAir Climate Care',
            prefixIcon: Icon(Icons.business_rounded, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Business Type *'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBusinessType,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              items: AppConstants.businessTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBusinessType = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Primary Contact Person *'),
        TextField(
          controller: _contactPersonController,
          decoration: const InputDecoration(
            hintText: 'e.g. Rajesh Subramanian (Director / Manager)',
            prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Official Mobile Number *'),
        TextField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+91 98840 55443',
            prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Official Email Address *'),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'e.g. rajesh@arcticaircare.in',
            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textSecondary, size: 20),
          ),
        ),
      ],
    );
  }

  // STEP 2: Address & Locations
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Address & Service Hubs',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Specify where your headquarters is located and your target hiring locations.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        _buildLabel('Registered Street Address *'),
        TextField(
          controller: _addressController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Building no., street name, industrial area',
            prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Headquarter City *'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border, width: 1.2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        isExpanded: true,
                        items: AppConstants.indianCities.map((city) {
                          return DropdownMenuItem(value: city, child: Text(city, style: const TextStyle(fontSize: 13)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCity = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Pincode *'),
                  TextField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '600032'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildLabel('Operating Hiring Locations (Multi-select)'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.indianCities.map((city) {
            final isSelected = _selectedOperatingLocations.contains(city);
            return FilterChip(
              selected: isSelected,
              label: Text(city),
              selectedColor: AppTheme.primaryLight,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedOperatingLocations.add(city);
                  } else {
                    _selectedOperatingLocations.remove(city);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 3: Business Information
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operational Capacity & Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Help technicians understand your scale and service specializations.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        _buildLabel('Years in Business: $_yearsInBusiness Years'),
        Slider(
          value: _yearsInBusiness.toDouble(),
          min: 1,
          max: 25,
          divisions: 24,
          activeColor: AppTheme.primary,
          label: '$_yearsInBusiness Years',
          onChanged: (val) => setState(() => _yearsInBusiness = val.round()),
        ),
        const SizedBox(height: 16),

        _buildLabel('Total Technicians / Employees: $_employeesCount'),
        Slider(
          value: _employeesCount.toDouble(),
          min: 1,
          max: 200,
          divisions: 40,
          activeColor: AppTheme.primary,
          label: '$_employeesCount Staff',
          onChanged: (val) => setState(() => _employeesCount = val.round()),
        ),
        const SizedBox(height: 20),

        _buildLabel('Services Offered (Select all that apply)'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Split AC Servicing',
            'Window AC Maintenance',
            'Cassette AC Installation',
            'Commercial VRF/VRV Installation',
            'Central Chiller Plants',
            'PCB Diagnosis & Repair',
            'Annual Maintenance Contracts (AMC)',
            'Gas Charging & Vacuuming',
          ].map((srv) {
            final isSelected = _selectedServices.contains(srv);
            return FilterChip(
              selected: isSelected,
              label: Text(srv),
              selectedColor: AppTheme.primaryLight,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedServices.add(srv);
                  } else {
                    _selectedServices.remove(srv);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 4: Business Documents
  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Documents',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Upload official certificates to earn the Verified Business Badge.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        _buildLabel('GST / Business Registration Number'),
        TextField(
          controller: _gstController,
          decoration: const InputDecoration(
            hintText: 'e.g. 33AABCT9988Z1Z5',
            prefixIcon: Icon(Icons.receipt_long_rounded, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 20),

        _buildDocUploadCard(
          title: 'GST / Business Certificate',
          subtitle: 'PDF / JPEG format (Max 5MB)',
          isUploaded: _hasUploadedGst,
          onToggle: () => setState(() => _hasUploadedGst = !_hasUploadedGst),
        ),
        const SizedBox(height: 12),

        _buildDocUploadCard(
          title: 'Company Proof (MSME / Incorporation)',
          subtitle: 'Official company registration deed',
          isUploaded: _hasUploadedMsme,
          onToggle: () => setState(() => _hasUploadedMsme = !_hasUploadedMsme),
        ),
        const SizedBox(height: 12),

        _buildDocUploadCard(
          title: 'Registered Address Proof',
          subtitle: 'Commercial electricity bill or lease agreement',
          isUploaded: _hasUploadedAddressProof,
          onToggle: () => setState(() => _hasUploadedAddressProof = !_hasUploadedAddressProof),
        ),
      ],
    );
  }

  Widget _buildDocUploadCard({
    required String title,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isUploaded ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUploaded ? AppTheme.primaryLight : AppTheme.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
              color: isUploaded ? AppTheme.primary : AppTheme.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(
              isUploaded ? 'Change' : 'Upload',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isUploaded ? AppTheme.textSecondary : AppTheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 5: Security & Passwords
  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Secure Your Business Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Create a strong password for administrative access to the platform.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        _buildLabel('Create Password *'),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePass,
          decoration: InputDecoration(
            hintText: 'At least 8 characters',
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppTheme.textSecondary, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
        const SizedBox(height: 16),

        _buildLabel('Confirm Password *'),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscurePass,
          decoration: const InputDecoration(
            hintText: 'Re-enter your password',
            prefixIcon: Icon(Icons.lock_reset_rounded, color: AppTheme.textSecondary, size: 20),
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.infoBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppTheme.infoText, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your credentials and company verification documents are encrypted with enterprise-grade SSL protection.',
                  style: TextStyle(fontSize: 11, color: AppTheme.infoText, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 6: Review & Final Submission
  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Registration Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Please verify all information before submitting to SORNET Admin.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewRow('Business Name', _nameController.text),
              _buildReviewRow('Category', _selectedBusinessType),
              _buildReviewRow('Contact Person', _contactPersonController.text),
              _buildReviewRow('Phone', _mobileController.text),
              _buildReviewRow('Email', _emailController.text),
              _buildReviewRow('HQ City', '$_selectedCity, ${_stateController.text}'),
              _buildReviewRow('Operating Hubs', _selectedOperatingLocations.join(', ')),
              _buildReviewRow('Scale', '$_yearsInBusiness Yrs in Business • $_employeesCount Staff'),
              _buildReviewRow('GST No.', _gstController.text.isNotEmpty ? _gstController.text : 'Pending'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.warningBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.warningText, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Review Protocol',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.warningText),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Once submitted, your account will enter the "Under Review" state. You can immediately post jobs and browse technician profiles while verification is finalized.',
                      style: TextStyle(fontSize: 11, color: AppTheme.warningText, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  // Success Screen after Step 6 Submission
  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.warningBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    size: 44,
                    color: AppTheme.warningText,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verification Pending',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your business profile has been submitted for verification.\nOur team usually completes review within 24 hours.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const BusinessMainShell()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.dashboard_rounded, size: 18),
                  label: const Text('Go to Business Dashboard'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
