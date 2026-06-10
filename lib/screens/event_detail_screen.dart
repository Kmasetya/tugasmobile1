import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/event.dart';
import '../services/app_state.dart';
import 'checkout_sheet.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  Event _getEvent() {
    try {
      return allEvents.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return allEvents.first; // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = _getEvent();
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            final isFavorite = appState.isFavorite(event.id);

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Header Row controls
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Icon(Icons.chevron_left, color: AppColors.white, size: 28),
                                ),
                                const Spacer(),
                                Text('Detail Konser', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                const Spacer(),

                                // Heart Favorites icon toggle button
                                GestureDetector(
                                  onTap: () {
                                    appState.toggleFavorite(event.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppColors.card,
                                        duration: const Duration(seconds: 1),
                                        content: Text(
                                          isFavorite ? 'Dihapus dari Favorit' : 'Ditambahkan ke Favorit!',
                                          style: GoogleFonts.inter(color: isFavorite ? AppColors.white : AppColors.primary),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: isFavorite ? AppColors.primary : AppColors.border),
                                      color: isFavorite ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                                    ),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? AppColors.primary : AppColors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),

                                // Share button
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppColors.card,
                                        content: Text('Tautan konser ${event.name} berhasil disalin ke papan klip!', style: GoogleFonts.inter(color: AppColors.white)),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: const Icon(Icons.share_outlined, color: AppColors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Event Banner Image
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Hero(
                                tag: 'hero-event-${event.id}',
                                child: Image.asset(event.imagePath, height: 300, width: double.infinity, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Info Detail Card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: AppColors.primary, width: 0.8),
                                    ),
                                    child: Text(
                                      event.category.toUpperCase(),
                                      style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Text(event.name, style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text('Oleh ${event.artist}', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14)),
                                  const SizedBox(height: 20),

                                  // Meta Detail Row Info
                                  IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        _metaItem('Harga Mulai', event.price),
                                        const VerticalDivider(color: AppColors.border, thickness: 1, width: 24),
                                        _metaItem('Tanggal', event.fullDate),
                                        const VerticalDivider(color: AppColors.border, thickness: 1, width: 24),
                                        _metaItem('Tempat', event.place),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  Text('Tentang Event', style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10),
                                  Text(event.description, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13, height: 1.6)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 100 + bottomPad),
                        ],
                      ),
                    ),
                  ],
                ),

                // Buy Ticket bottom sticky button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
                    ),
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPad),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CheckoutSheet(event: event),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text('Beli Tiket Sekarang', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _metaItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.inter(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
