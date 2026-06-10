import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../services/app_state.dart';
import '../models/event.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            // Filter dynamic notifications from AppState
            final list = appState.notifications;
            final promoData = list.where((n) => n.type == 'Promo').toList();
            final transaksiData = list.where((n) => n.type == 'Transaksi').toList();

            final currentList = _tabIndex == 0 ? promoData : transaksiData;

            return Column(
              children: [
                const SizedBox(height: 12),
                Text('Notifikasi', style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),

                // Tab selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _tabBtn('Promo (${promoData.length})', 0),
                      _tabBtn('Daftar Transaksi (${transaksiData.length})', 1),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),

                // Notifications ListView
                Expanded(
                  child: currentList.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          itemCount: currentList.length,
                          itemBuilder: (context, index) {
                            final item = currentList[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(item.imagePath, width: 56, height: 56, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.message,
                                          style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12, height: 1.4),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.date,
                                              style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              item.artist,
                                              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  
                                  // Action button - let's navigate to detail page for booking!
                                  if (item.type == 'Promo')
                                    GestureDetector(
                                      onTap: () {
                                        // Dynamic mapping: Try to find event with matching artist name
                                        try {
                                          final matchedEvent = allEvents.firstWhere(
                                            (e) => e.artist.toLowerCase().contains(item.artist.split(' ')[0].toLowerCase()),
                                          );
                                          context.push('/event/${matchedEvent.id}');
                                        } catch (_) {
                                          context.push('/event/1'); // Fallback
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Beli',
                                          style: GoogleFonts.inter(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final isActive = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isActive ? AppColors.primary : Colors.transparent, width: 2)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: isActive ? AppColors.primary : AppColors.muted,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Notifikasi',
              style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _tabIndex == 0
                  ? 'Info diskon tiket dan promo menarik akan dikabarkan di sini.'
                  : 'Riwayat transaksi pembelian tiket Anda akan dicatat di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
