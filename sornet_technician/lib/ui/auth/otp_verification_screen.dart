import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../shell/technician_main_shell.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneOrEmail;

  const OTPVerificationScreen({super.key, required this.phoneOrEmail});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendTimer = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-fill demo OTP 123456
    _controllers[0].text = '1';
    _controllers[1].text = '2';
    _controllers[2].text = '3';
    _controllers[3].text = '4';
    _controllers[4].text = '5';
    _controllers[5].text = '6';
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  void _verifyOtp() async {
    final auth = context.read<AuthProvider>();
    final otp = _enteredOtp;

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits of the OTP.')),
      );
      return;
    }

    final success = await auth.verifyOtp(widget.phoneOrEmail, otp);
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const TechnicianMainShell()),
        (route) => false,
      );
    } else if (mounted && auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Your Number',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent a 6-digit verification code to ${widget.phoneOrEmail}. Enter code below to sign in.',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '💡 Demo verification code is 123456 (prefilled)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 32),

              // 6 Digits Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: AppTheme.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Submit Button
              ElevatedButton(
                onPressed: auth.isLoading ? null : _verifyOtp,
                child: auth.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Verify & Proceed to Dashboard'),
              ),
              const SizedBox(height: 20),

              // Resend Timer
              Center(
                child: _resendTimer > 0
                    ? Text(
                        'Resend code in ${_resendTimer}s',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary, fontWeight: FontWeight.w500),
                      )
                    : TextButton(
                        onPressed: _startTimer,
                        child: const Text('Resend Code Now', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
