import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../shell/technician_main_shell.dart';

class TechnicianRegistrationScreen extends StatefulWidget {
  const TechnicianRegistrationScreen({super.key});

  @override
  State<TechnicianRegistrationScreen> createState() => _TechnicianRegistrationScreenState();
}

class _TechnicianRegistrationScreenState extends State<TechnicianRegistrationScreen> {
  int _currentStep = 0;

  // Form Controllers
  final _nameCtrl = TextEditingController(text: 'R. Vignesh Kumar');
  final _mobileCtrl = TextEditingController(text: '+91 98402 88776');
  final _emailCtrl = TextEditingController(text: 'vignesh.tech@gmail.com');
  final _dobCtrl = TextEditingController(text: '1995-06-15');
  String _gender = 'Male';
  String _city = 'Chennai';
  final String _state = 'Tamil Nadu';
  final _pincodeCtrl = TextEditingController(text: '600042');

  // Step 2: Professional Information
  String _primaryTrade = 'AC Technician';
  double _experienceYears = 5.0;
  String _employmentPreference = 'Full Time';
  final _expectedSalaryCtrl = TextEditingController(text: '30000');
  String _availability = 'Immediately Available';

  // Step 3: Technical Expertise
  final Set<String> _selectedAcTypes = {'Split AC', 'Cassette AC', 'VRF / VRV'};
  final Set<String> _selectedTech = {'Inverter', 'Dual Inverter', 'Non-Inverter'};
  final Set<String> _selectedBrands = {'Daikin', 'Voltas', 'LG', 'Blue Star', 'Samsung'};

  // Step 4: Services
  final Set<String> _selectedServices = {
    'Installation',
    'General Servicing',
    'Gas Charging',
    'Gas Leakage Repair',
    'PCB Repair',
    'Troubleshooting',
  };

  // Step 5: Experience
  final _companyCtrl = TextEditingController(text: 'Daikin Certified Service Hub');
  final _roleCtrl = TextEditingController(text: 'Senior AC Field Specialist');
  final _expStartCtrl = TextEditingController(text: '2020-05-01');
  final _expEndCtrl = TextEditingController(text: 'Present');
  final _expDescCtrl = TextEditingController(text: 'Handled residential and commercial multi-split AC installations and inverter PCB diagnosis.');

  // Step 6: Certifications
  final _certNameCtrl = TextEditingController(text: 'Daikin VRV System Master Specialist');
  final _certIssuerCtrl = TextEditingController(text: 'Daikin Airconditioning India');
  final _certYearCtrl = TextEditingController(text: '2022');

  // Step 7: Documents
  bool _aadhaarUploaded = true;
  bool _drivingLicenseUploaded = true;
  bool _tradeCertUploaded = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    _pincodeCtrl.dispose();
    _expectedSalaryCtrl.dispose();
    _companyCtrl.dispose();
    _roleCtrl.dispose();
    _expStartCtrl.dispose();
    _expEndCtrl.dispose();
    _expDescCtrl.dispose();
    _certNameCtrl.dispose();
    _certIssuerCtrl.dispose();
    _certYearCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 7) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submit() async {
    final auth = context.read<AuthProvider>();

    // Prepare draft data in provider
    auth.updateRegistrationData('fullName', _nameCtrl.text.trim());
    auth.updateRegistrationData('mobileNumber', _mobileCtrl.text.trim());
    auth.updateRegistrationData('email', _emailCtrl.text.trim());
    auth.updateRegistrationData('gender', _gender);
    auth.updateRegistrationData('dateOfBirth', _dobCtrl.text.trim());
    auth.updateRegistrationData('city', _city);
    auth.updateRegistrationData('state', _state);
    auth.updateRegistrationData('pincode', _pincodeCtrl.text.trim());
    auth.updateRegistrationData('primaryTrade', _primaryTrade);
    auth.updateRegistrationData('experienceYears', _experienceYears);
    auth.updateRegistrationData('employmentPreference', _employmentPreference);
    auth.updateRegistrationData('expectedSalary', _expectedSalaryCtrl.text.trim());
    auth.updateRegistrationData('availabilityStatus', _availability);
    auth.updateRegistrationData('acTypes', _selectedAcTypes.toList());
    auth.updateRegistrationData('acTechnologies', _selectedTech.toList());
    auth.updateRegistrationData('brands', _selectedBrands.toList());
    auth.updateRegistrationData('services', _selectedServices.toList());

    final success = await auth.submitRegistration();
    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppTheme.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded, size: 36, color: AppTheme.success),
              ),
              const SizedBox(height: 16),
              const Text(
                'Registration Submitted!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your profile is under verification. You can now browse verified jobs, track applications, and receive interview invitations.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const TechnicianMainShell()),
                    (route) => false,
                  );
                },
                child: const Text('Go to Technician Dashboard'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final stepTitles = [
      'Basic Info',
      'Professional',
      'Expertise',
      'Services',
      'Experience',
      'Certifications',
      'Documents',
      'Review & Submit',
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Technician Onboarding (${_currentStep + 1}/8)'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Progress Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppTheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP ${_currentStep + 1}: ${stepTitles[_currentStep].toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / 8 * 100).toInt()}% Completed',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 8,
                      minHeight: 6,
                      backgroundColor: AppTheme.borderLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _nextStep,
                      child: auth.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_currentStep == 7 ? 'Submit for Verification' : 'Continue to Next Step'),
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

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1BasicInfo();
      case 1:
        return _buildStep2Professional();
      case 2:
        return _buildStep3Expertise();
      case 3:
        return _buildStep4Services();
      case 4:
        return _buildStep5Experience();
      case 5:
        return _buildStep6Certifications();
      case 6:
        return _buildStep7Documents();
      case 7:
        return _buildStep8Review();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: Basic Information
  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal & Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Enter your basic details to create your verified technician identity.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        // Photo Avatar Picker
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppTheme.primaryLight,
                child: const Icon(Icons.person_rounded, size: 52, color: AppTheme.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text('Full Legal Name (as per Govt ID)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'e.g. R. Vignesh Kumar')),
        const SizedBox(height: 14),

        const Text('Mobile Number (for SMS & OTP)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _mobileCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '+91 98402 88776')),
        const SizedBox(height: 14),

        const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'vignesh.tech@gmail.com')),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date of Birth', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(controller: _dobCtrl, decoration: const InputDecoration(hintText: 'YYYY-MM-DD')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (val) => setState(() => _gender = val ?? 'Male'),
                    decoration: const InputDecoration(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('City', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _city,
                    items: AppConstants.indianCities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _city = val ?? 'Chennai'),
                    decoration: const InputDecoration(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pincode', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(controller: _pincodeCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '600042')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 2: Professional Information
  Widget _buildStep2Professional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Professional Background & Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Help employers discover you based on your experience and salary expectations.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        const Text('Primary Trade', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _primaryTrade,
          items: AppConstants.availableTrades.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _primaryTrade = val ?? 'AC Technician'),
          decoration: const InputDecoration(),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Years of Experience', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('${_experienceYears.toStringAsFixed(1)} Years', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.primary)),
          ],
        ),
        Slider(
          value: _experienceYears,
          min: 0,
          max: 20,
          divisions: 40,
          activeColor: AppTheme.primary,
          label: '${_experienceYears.toStringAsFixed(1)} Years',
          onChanged: (val) => setState(() => _experienceYears = val),
        ),
        const SizedBox(height: 14),

        const Text('Employment Preference', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: AppConstants.employmentTypes.map((type) {
            final isSelected = _employmentPreference == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => setState(() => _employmentPreference = type),
              selectedColor: AppTheme.primaryLight,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        const Text('Expected Monthly Salary (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _expectedSalaryCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g. 30000', prefixText: '₹ '),
        ),
        const SizedBox(height: 16),

        const Text('Joining Availability', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _availability,
          items: AppConstants.availabilityOptions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
          onChanged: (val) => setState(() => _availability = val ?? 'Immediately Available'),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }

  // STEP 3: Technical Expertise
  Widget _buildStep3Expertise() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AC Expertise & Brands', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Select all equipment types and manufacturer brands you can independently service.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        const Text('AC Equipment Types', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.acTypes.map((type) {
            final isSelected = _selectedAcTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAcTypes.add(type);
                  } else {
                    _selectedAcTypes.remove(type);
                  }
                });
              },
              selectedColor: AppTheme.primaryLight,
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        const Text('Technology Expertise', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.acTechnologies.map((tech) {
            final isSelected = _selectedTech.contains(tech);
            return FilterChip(
              label: Text(tech),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTech.add(tech);
                  } else {
                    _selectedTech.remove(tech);
                  }
                });
              },
              selectedColor: AppTheme.primaryLight,
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        const Text('Brand Experience', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.brands.map((brand) {
            final isSelected = _selectedBrands.contains(brand);
            return FilterChip(
              label: Text(brand),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedBrands.add(brand);
                  } else {
                    _selectedBrands.remove(brand);
                  }
                });
              },
              selectedColor: AppTheme.primaryLight,
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 4: Services
  Widget _buildStep4Services() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Service Capabilities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Select all repair, diagnostic, and installation jobs you perform.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: AppConstants.services.map((service) {
            final isSelected = _selectedServices.contains(service);
            return FilterChip(
              label: Text(service),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedServices.add(service);
                  } else {
                    _selectedServices.remove(service);
                  }
                });
              },
              selectedColor: AppTheme.primaryLight,
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // STEP 5: Experience
  Widget _buildStep5Experience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Previous Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Add your previous HVAC/AC contractor or employer records.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        const Text('Company / Contractor Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _companyCtrl, decoration: const InputDecoration(hintText: 'e.g. Daikin Certified Service Hub')),
        const SizedBox(height: 14),

        const Text('Job Role / Designation', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _roleCtrl, decoration: const InputDecoration(hintText: 'e.g. Senior AC Field Specialist')),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Start Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(controller: _expStartCtrl, decoration: const InputDecoration(hintText: 'YYYY-MM-DD')),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('End Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(controller: _expEndCtrl, decoration: const InputDecoration(hintText: 'Present or YYYY-MM-DD')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        const Text('Key Responsibilities & Projects', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _expDescCtrl,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Summarize the tasks, projects, or volume of AC units serviced...'),
        ),
      ],
    );
  }

  // STEP 6: Certifications
  Widget _buildStep6Certifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trade & Manufacturer Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Certificates significantly increase employer contact rates.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        const Text('Certificate Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _certNameCtrl, decoration: const InputDecoration(hintText: 'e.g. Daikin VRV Master Specialist')),
        const SizedBox(height: 14),

        const Text('Issuing Organization / Brand', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _certIssuerCtrl, decoration: const InputDecoration(hintText: 'e.g. Daikin Airconditioning India / DGT ITI')),
        const SizedBox(height: 14),

        const Text('Issue Year', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(controller: _certYearCtrl, decoration: const InputDecoration(hintText: '2022')),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.error, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('daikin_vrv_specialist.pdf', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    Text('1.4 MB • Uploaded & Ready for Verification', style: TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  // STEP 7: Document Verification
  Widget _buildStep7Documents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Identity & Document Verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Uploaded documents are stored securely and only reviewed by SORNET Admin verification officers.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        _buildDocUploadCard('Government ID (Aadhaar / PAN / Voter ID)', 'aadhaar_card_front_back.pdf', _aadhaarUploaded, () {
          setState(() => _aadhaarUploaded = !_aadhaarUploaded);
        }),
        const SizedBox(height: 12),
        _buildDocUploadCard('Driving License / Address Proof', 'driving_license_valid.pdf', _drivingLicenseUploaded, () {
          setState(() => _drivingLicenseUploaded = !_drivingLicenseUploaded);
        }),
        const SizedBox(height: 12),
        _buildDocUploadCard('ITI / Trade Qualification Certificate', 'iti_rac_diploma.pdf', _tradeCertUploaded, () {
          setState(() => _tradeCertUploaded = !_tradeCertUploaded);
        }),
      ],
    );
  }

  Widget _buildDocUploadCard(String title, String fileName, bool isUploaded, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isUploaded ? AppTheme.success.withValues(alpha: 0.3) : AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUploaded ? AppTheme.successBg : AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isUploaded ? Icons.file_present_rounded : Icons.upload_file_rounded, color: isUploaded ? AppTheme.success : AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  isUploaded ? '$fileName (Ready)' : 'Tap to select document',
                  style: TextStyle(fontSize: 11, color: isUploaded ? AppTheme.successText : AppTheme.textTertiary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isUploaded ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, color: isUploaded ? AppTheme.success : AppTheme.primary),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }

  // STEP 8: Review & Submit
  Widget _buildStep8Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Review Profile Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Please verify your information before submitting for official verification.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 20),

        // Preview Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0] : 'T',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_nameCtrl.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                        Text('$_primaryTrade • ${_experienceYears.toStringAsFixed(1)} Years Exp', style: const TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                        Text('$_city, $_state', style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildReviewRow('Mobile', _mobileCtrl.text),
              _buildReviewRow('Email', _emailCtrl.text),
              _buildReviewRow('Expected Salary', '${Formatters.formatCurrency(int.tryParse(_expectedSalaryCtrl.text) ?? 30000)}/month'),
              _buildReviewRow('Availability', _availability),
              _buildReviewRow('AC Types', _selectedAcTypes.join(', ')),
              _buildReviewRow('Brands', _selectedBrands.join(', ')),
              _buildReviewRow('Employer', _companyCtrl.text),
              _buildReviewRow('Certificate', _certNameCtrl.text),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppTheme.infoBg, borderRadius: BorderRadius.circular(12)),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppTheme.infoText, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your profile and documents will be reviewed by the SORNET verification team within 24-48 hours.',
                  style: TextStyle(fontSize: 12, color: AppTheme.infoText, height: 1.3),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
