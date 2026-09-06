import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sornet_providers.dart';

class ApiConfigScreen extends StatefulWidget {
  const ApiConfigScreen({super.key});

  @override
  State<ApiConfigScreen> createState() => _ApiConfigScreenState();
}

class _ApiConfigScreenState extends State<ApiConfigScreen> {
  late TextEditingController _urlController;
  late TextEditingController _keyController;
  String _selectedEnv = 'Production';
  bool _obscureKey = true;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _urlController = TextEditingController(text: settings.apiBaseUrl);
    _keyController = TextEditingController(text: settings.apiKey);
    _selectedEnv = settings.environment;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('API Configuration'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD1E9FF)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_sync_rounded, color: AppColors.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Configure the backend REST API endpoint and environment. Authentication tokens are securely encrypted in device storage.',
                          style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.primaryDark, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Endpoint Settings', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      // Environment selector
                      DropdownButtonFormField<String>(
                        value: _selectedEnv,
                        decoration: const InputDecoration(
                          labelText: 'Server Environment',
                          prefixIcon: Icon(Icons.dns_outlined),
                        ),
                        items: ['Development (Local)', 'Staging / QA', 'Production'].map((env) {
                          return DropdownMenuItem(value: env, child: Text(env));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedEnv = val);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'API Base URL',
                          prefixIcon: Icon(Icons.link_rounded),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _keyController,
                        obscureText: _obscureKey,
                        decoration: InputDecoration(
                          labelText: 'Admin API Key',
                          prefixIcon: const Icon(Icons.vpn_key_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureKey ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: () => setState(() => _obscureKey = !_obscureKey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        onPressed: () {
                          settings.updateApiConfig(
                            baseUrl: _urlController.text.trim(),
                            apiKey: _keyController.text.trim(),
                            environment: _selectedEnv,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('API Configuration saved!'), backgroundColor: AppColors.success),
                          );
                        },
                        child: const Text('Save API Configuration'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Connection Test Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Connection Diagnostics', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                          if (settings.isConnectionSuccessful != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: settings.isConnectionSuccessful! ? AppColors.successBg : AppColors.errorBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: settings.isConnectionSuccessful! ? AppColors.successBorder : AppColors.errorBorder,
                                ),
                              ),
                              child: Text(
                                settings.isConnectionSuccessful! ? 'Connected' : 'Failed',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: settings.isConnectionSuccessful! ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Test the connectivity and latency between this mobile device and the SORNET backend servers.',
                        style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary),
                      ),
                      if (settings.connectionStatusMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  settings.connectionStatusMessage!,
                                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF166534), fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        icon: settings.isTestingConnection
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.network_ping_rounded, size: 18),
                        label: Text(settings.isTestingConnection ? 'Testing Connection...' : 'Ping API Endpoint'),
                        onPressed: settings.isTestingConnection ? null : () => settings.testApiConnection(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
