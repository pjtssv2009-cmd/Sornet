import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sornet_providers.dart';
import '../auth/admin_login_screen.dart';
import '../common/confirm_dialog.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Avatar & Role
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: user?.avatarUrl.isNotEmpty == true ? NetworkImage(user!.avatarUrl) : null,
                        child: user?.avatarUrl.isEmpty != false
                            ? Text(
                                user?.name.isNotEmpty == true ? user!.name[0] : 'A',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'Admin',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user?.role.displayName ?? 'Super Admin',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                  ),
                ),
                const SizedBox(height: 24),

                // Editable Information Card
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
                      Text('Personal Information', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline_rounded)),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        initialValue: user?.email ?? 'admin@sornet.com',
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Email Address (Locked)',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                          filled: true,
                          fillColor: Color(0xFFF8FAFC),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        onPressed: () {
                          auth.updateProfile(
                            name: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile saved successfully!'), backgroundColor: AppColors.success),
                          );
                        },
                        child: const Text('Save Profile Changes'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Logout Action
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.errorBorder),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Logout'),
                  onPressed: () async {
                    final confirm = await ConfirmDialog.show(
                      context,
                      title: 'Confirm Logout',
                      message: 'Are you sure you want to logout?',
                      confirmText: 'Logout',
                      isDangerous: true,
                    );
                    if (confirm == true) {
                      auth.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
