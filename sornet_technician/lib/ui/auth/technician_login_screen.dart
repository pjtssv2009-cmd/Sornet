import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../shell/technician_main_shell.dart';
import 'otp_verification_screen.dart';
import 'forgot_password_screen.dart';
import 'technician_registration_screen.dart';

class TechnicianLoginScreen extends StatefulWidget {
  const TechnicianLoginScreen({super.key});

  @override
  State<TechnicianLoginScreen> createState() => _TechnicianLoginScreenState();
}

class _TechnicianLoginScreenState extends State<TechnicianLoginScreen> {
  final _emailController = TextEditingController(text: AppConstants.demoEmail);
  final _passwordController = TextEditingController(text: AppConstants.demoPassword);
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TechnicianMainShell()),
      );
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage!),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = AppConstants.demoEmail;
      _passwordController.text = AppConstants.demoPassword;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo technician credentials filled: technician@sornet.com'),
        backgroundColor: AppTheme.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Logo
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppTheme.skyGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.engineering_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SORNET',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: AppTheme.accentNavy,
                          ),
                        ),
                        Text(
                          'Technician Portal',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Welcome texts
                const Text(
                  'Welcome Back, Tech Lead',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to explore high-paying AC & HVAC jobs, receive interview invites, and track your offers.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // 1-Tap Quick Demo Credentials Card
                InkWell(
                  onTap: _fillDemoCredentials,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1-Tap Demo Credentials',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Text(
                                'technician@sornet.com  •  Technician@123',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.touch_app_rounded, color: AppTheme.primary, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email / Phone Input
                const Text(
                  'Mobile Number / Email Address',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +91 98402 33441 or technician@sornet.com',
                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.textTertiary),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppTheme.textTertiary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppTheme.textTertiary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) => setState(() => _rememberMe = val ?? true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember Me',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign In Button
                ElevatedButton(
                  onPressed: auth.isLoading ? null : _handleLogin,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Sign In to Account'),
                ),
                const SizedBox(height: 14),

                // OTP Login Alternative
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OTPVerificationScreen(
                          phoneOrEmail: _emailController.text.isNotEmpty ? _emailController.text : '+91 98402 33441',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.sms_outlined, size: 18),
                  label: const Text('Sign In via OTP Verification'),
                ),
                const SizedBox(height: 32),

                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "New to SORNET? ",
                        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TechnicianRegistrationScreen()),
                          );
                        },
                        child: const Text(
                          'Create Technician Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
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
