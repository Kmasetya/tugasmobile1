import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  Event? _getEvent() {
    try {
      return recommendedEvents.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = _getEvent() ?? recommendedEvents.first;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: const Icon(Icons.chevron_left, color: AppColors.white, size: 28),
                            ),
                            const Spacer(),
                            Text('Event', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.share_outlined, color: AppColors.white, size: 18),
                            ),
                          ],
                        ),
                      ),

                      // Event Image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(event.imagePath, height: 300, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.name, style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 16),

                              // Meta Row
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    _metaItem('Price', event.price),
                                    const VerticalDivider(color: AppColors.border, thickness: 1, width: 24),
                                    _metaItem('Date', event.fullDate),
                                    const VerticalDivider(color: AppColors.border, thickness: 1, width: 24),
                                    _metaItem('Place', event.place),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              Text('About Event', style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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

            // Buy Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.background,
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPad),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A0A3E),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Buy Ticket', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metaItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
        ],
      ),
    );
  }
}
