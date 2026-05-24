import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class _MenuItem {
  final IconData icon;
  final String label;
  _MenuItem(this.icon, this.label);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contentItems = [
      _MenuItem(Icons.favorite_border, 'Favourites'),
      _MenuItem(Icons.local_offer_outlined, 'My ticket'),
      _MenuItem(Icons.lock_outline, 'Security Policy'),
    ];

    final preferenceItems = [
      _MenuItem(Icons.language, 'Languange'),
      _MenuItem(Icons.help_outline, 'Help Center'),
      _MenuItem(Icons.logout, 'Log Out'),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text('Settings', textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('assets/images/karina.png', width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wonhee', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('085266328499', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Content', style: GoogleFonts.inter(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _buildMenuGroup(contentItems, context),

            const SizedBox(height: 24),
            Text('Preferences', style: GoogleFonts.inter(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _buildMenuGroup(preferenceItems, context, isLogout: true),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items, BuildContext context, {bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return GestureDetector(
            onTap: () {
              if (isLogout && item.label == 'Log Out') {
                context.go('/');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: AppColors.muted, size: 20),
                  const SizedBox(width: 14),
                  Expanded(child: Text(item.label, style: GoogleFonts.inter(color: AppColors.white, fontSize: 15))),
                  const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
