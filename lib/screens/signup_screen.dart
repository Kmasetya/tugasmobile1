import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0118),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Image.asset('assets/images/login_hero.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New User?\nRegister Here',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInput(controller: _emailController, hint: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  _buildPasswordInput(controller: _passwordController, hint: 'Password', show: _showPassword, onToggle: () => setState(() => _showPassword = !_showPassword)),
                  const SizedBox(height: 14),
                  _buildPasswordInput(controller: _confirmController, hint: 'Confirm Password', show: _showConfirm, onToggle: () => setState(() => _showConfirm = !_showConfirm)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text('Signup', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(child: Text('or', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('G'),
                      const SizedBox(width: 16),
                      _socialButton('⌥'),
                      const SizedBox(width: 16),
                      _socialButton('f', color: const Color(0xFF1877F2)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(text: 'Login', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ],
                        ),
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

  Widget _buildInput({required TextEditingController controller, required String hint, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(50)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: AppColors.muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordInput({required TextEditingController controller, required String hint, required bool show, required VoidCallback onToggle}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(50)),
      child: TextField(
        controller: controller,
        obscureText: !show,
        style: GoogleFonts.inter(color: AppColors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: AppColors.muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: IconButton(icon: Icon(show ? Icons.visibility_off : Icons.visibility, color: AppColors.muted), onPressed: onToggle),
        ),
      ),
    );
  }

  Widget _socialButton(String label, {Color? color}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.15)),
      child: Center(child: Text(label, style: GoogleFonts.inter(color: color ?? AppColors.white, fontSize: 20, fontWeight: FontWeight.w700))),
    );
  }
}
