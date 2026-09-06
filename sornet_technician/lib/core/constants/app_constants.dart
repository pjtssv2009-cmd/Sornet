class AppConstants {
  static const String appName = 'SORNET Technician';
  static const String appTagline = 'Powering Skilled Service Careers';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Demo Credentials
  static const String demoEmail = 'technician@sornet.com';
  static const String demoPassword = 'Technician@123';
  static const String demoPhone = '+91 98402 33441';

  // Primary Trades
  static const String primaryTrade = 'AC Technician';
  static const List<String> availableTrades = [
    'AC Technician',
    'Commercial HVAC Specialist',
    'Electrician',
    'Plumber',
    'Refrigerator Technician',
    'Washing Machine Technician',
    'TV & Electronics Technician',
    'Microwave & Small Appliance',
    'Solar & Inverter Technician',
  ];

  // AC Specializations
  static const List<String> acTypes = [
    'Split AC',
    'Window AC',
    'Cassette AC',
    'Duct AC',
    'Central AC',
    'Portable AC',
    'VRF / VRV',
  ];

  // AC Technologies
  static const List<String> acTechnologies = [
    'Inverter',
    'Non-Inverter',
    'Dual Inverter',
    'Variable Speed Scroll',
  ];

  // AC & Appliance Brands
  static const List<String> brands = [
    'Daikin',
    'Voltas',
    'Blue Star',
    'LG',
    'Samsung',
    'Hitachi',
    'Carrier',
    'Mitsubishi Electric',
    'Panasonic',
    'Godrej',
    'Lloyd',
    'O General',
    'Toshiba',
    'Haier',
    'Whirlpool',
  ];

  static List<String> get acBrands => brands;

  // Technician Services & Skills
  static const List<String> services = [
    'Installation',
    'Uninstallation',
    'General Servicing',
    'Gas Charging',
    'Gas Leakage Repair',
    'PCB Repair',
    'Compressor Replacement',
    'Troubleshooting',
    'AMC Maintenance',
    'Electrical Repair',
    'Cooling Issue Repair',
    'Water Leakage Repair',
    'Copper Piping & Flaring',
    'Deep Jet Cleaning',
  ];

  static List<String> get allSkills => [
        ...services,
        'VRV System Commissioning',
        'Chiller Plant Maintenance',
        'Ducting & Air Balancing',
        'Inverter PCB Board Diagnostics',
        'Cold Storage Plant Servicing',
      ];

  // Indian Cities
  static const List<String> indianCities = [
    'Chennai',
    'Bengaluru',
    'Coimbatore',
    'Madurai',
    'Trichy',
    'Hyderabad',
    'Kochi',
    'Mumbai',
    'Pune',
    'Delhi NCR',
    'Ahmedabad',
    'Kolkata',
  ];

  static List<String> get popularCities => indianCities;

  // Employment Preferences
  static const List<String> employmentTypes = [
    'Full Time',
    'Part Time',
    'Contract',
    'Freelance / Gig',
  ];

  // Availability Options
  static const List<String> availabilityOptions = [
    'Immediately Available',
    'Within 7 Days',
    'Within 15 Days',
    'Available from Specific Date',
    'Currently Working / Not Looking',
  ];

  // Education / Qualification Options
  static const List<String> educationLevels = [
    'ITI - RAC (Refrigeration & AC)',
    'Diploma in Mechanical / Electrical Engg',
    '10th / 12th Pass + Practical Apprenticeship',
    'B.E. / B.Tech (Mechanical / Electrical)',
    'Certified Vocational Technician (NSDC / Skill India)',
  ];

  // Document Types
  static const List<String> documentTypes = [
    'Aadhaar Card (Government ID)',
    'PAN Card',
    'Driving License',
    'Address Proof',
    'Experience Certificate / Relieving Letter',
    'Trade / Training Certificate',
    'ITI / Diploma Certificate',
    'Skill India / NSDC Certificate',
  ];
}
