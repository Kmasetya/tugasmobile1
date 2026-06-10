import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../services/app_state.dart';
import '../models/event.dart';

class _MenuItem {
  final IconData icon;
  final String label;
  _MenuItem(this.icon, this.label);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Open beautiful bottom sheet for Favourites list
  void _showFavouritesSheet(BuildContext context) {
    final appState = AppState();
    final favoritedEvents = allEvents.where((e) => appState.isFavorite(e.id)).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Konser Favorit Saya',
                    style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (favoritedEvents.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.favorite_border, size: 48, color: AppColors.muted),
                        const SizedBox(height: 12),
                        Text(
                          'Belum Ada Favorit',
                          style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Ketuk ikon hati pada konser untuk menambahkan.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: favoritedEvents.length,
                    itemBuilder: (context, index) {
                      final event = favoritedEvents[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(event.imagePath, width: 48, height: 48, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  Text(event.artist, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right, color: AppColors.primary),
                              onPressed: () {
                                Navigator.pop(context); // Close sheet
                                context.push('/event/${event.id}'); // Route to details
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Open beautiful bottom sheet for My Ticket summary
  void _showMyTicketsSheet(BuildContext context) {
    final tickets = AppState().purchasedTickets;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ringkasan Tiket Aktif',
                    style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: AppColors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (tickets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.confirmation_num_outlined, size: 48, color: AppColors.muted),
                        const SizedBox(height: 12),
                        Text(
                          'Belum Ada Tiket Terdaftar',
                          style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final t = tickets[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.event.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('${t.quantity} Tiket • ${t.ticketCode}', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: t.isActive ? AppColors.primary.withValues(alpha: 0.15) : AppColors.border,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                t.isActive ? 'AKTIF' : 'RIWAYAT',
                                style: GoogleFonts.inter(color: t.isActive ? AppColors.primary : AppColors.muted, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

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
        body: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 12),
                Text('Pengaturan', textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),

                // Dynamic User Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      // User profile photo avatar decoration
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset('assets/images/karina.png', width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.userName.isNotEmpty ? appState.userName : 'Pengguna Konser',
                              style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appState.userPhone.isNotEmpty ? appState.userPhone : 'Belum Ada Telepon',
                              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
                            ),
                            Text(
                              appState.userEmail.isNotEmpty ? appState.userEmail : '',
                              style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11),
                            ),
                          ],
                        ),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items, BuildContext context, {bool isLogout = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          return GestureDetector(
            onTap: () {
              if (isLogout && item.label == 'Log Out') {
                // Terminate session state
                AppState().logout();
                // Push back to Intro Welcome Onboarding
                context.go('/');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.card,
                    content: Text('Anda telah keluar dari akun.', style: GoogleFonts.inter(color: AppColors.white)),
                  ),
                );
              } else if (item.label == 'Favourites') {
                _showFavouritesSheet(context);
              } else if (item.label == 'My ticket') {
                _showMyTicketsSheet(context);
              } else if (item.label == 'Security Policy') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.card,
                    content: Text('Kebijakan Keamanan: Data Anda dilindungi dengan enkripsi SHA-256.', style: GoogleFonts.inter(color: AppColors.white)),
                  ),
                );
              } else if (item.label == 'Languange') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.card,
                    content: Text('Bahasa aktif saat ini: Bahasa Indonesia.', style: GoogleFonts.inter(color: AppColors.white)),
                  ),
                );
              } else if (item.label == 'Help Center') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.card,
                    content: Text('Hubungi Bantuan di: support@tiketkonser.com', style: GoogleFonts.inter(color: AppColors.white)),
                  ),
                );
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
