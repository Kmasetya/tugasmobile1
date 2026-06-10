import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../services/app_state.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int _tabIndex = 0;

  // Render a gorgeous simulated QR code pixel grid
  Widget _buildSimulatedQRCode() {
    return Container(
      width: 140,
      height: 140,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          // Semi-random deterministic pattern for QR Code representation
          final isBlack = (index * 7 + 13) % 3 == 0 || 
                          (index < 30 && index % 10 < 3) || 
                          (index > 70 && index % 10 > 7) ||
                          (index % 10 == 0 || index % 10 == 9) && (index < 10 || index > 90);
          return Container(
            color: isBlack ? AppColors.background : Colors.white,
          );
        },
      ),
    );
  }

  // Opens a high-fidelity checkout ticket pass modal
  void _showTicketPass(BuildContext context, PurchasedTicket ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket Container Box
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    // Concert banner image header
                    Image.asset(ticket.event.imagePath, height: 130, width: double.infinity, fit: BoxFit.cover),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(ticket.event.name, textAlign: TextAlign.center, style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Oleh ${ticket.event.artist}', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13)),
                          const SizedBox(height: 20),

                          // Dotted separator indicator
                          Row(
                            children: List.generate(
                              15,
                              (index) => Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 2,
                                  color: AppColors.border,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // QR Code Container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _buildSimulatedQRCode(),
                          ),
                          const SizedBox(height: 12),
                          Text(ticket.ticketCode, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                          Text('STATUS: ${ticket.isActive ? "AKTIF" : "SUDAH DIPAKAI"}', style: GoogleFonts.inter(color: ticket.isActive ? AppColors.primary : AppColors.muted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          
                          const SizedBox(height: 20),
                          Row(
                            children: List.generate(
                              15,
                              (index) => Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 2,
                                  color: AppColors.border,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Booking parameters
                          _passDetailRow('Nama Pemegang', AppState().userName),
                          const SizedBox(height: 8),
                          _passDetailRow('Lokasi / Venue', ticket.event.place),
                          const SizedBox(height: 8),
                          _passDetailRow('Tanggal Konser', ticket.event.date),
                          const SizedBox(height: 8),
                          _passDetailRow('Jumlah Tiket', '${ticket.quantity} Tiket'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Close dialog floating button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(Icons.close, color: AppColors.white, size: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _passDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
        Text(value, style: GoogleFonts.inter(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: appState,
          builder: (context, _) {
            // Filter tickets based on active tab
            // tab 0 = Tiket Aktif (isActive == true)
            // tab 1 = Daftar Tiket (all tickets / history)
            final allTickets = appState.purchasedTickets;
            final activeTickets = allTickets.where((t) => t.isActive).toList();
            final historyTickets = allTickets.where((t) => !t.isActive).toList();

            final currentTickets = _tabIndex == 0 ? activeTickets : historyTickets;

            return Column(
              children: [
                const SizedBox(height: 12),
                Text('Tiket Saya', style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),

                // Custom dynamic tab buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _tabBtn('Tiket Aktif (${activeTickets.length})', 0),
                      _tabBtn('Riwayat Penggunaan (${historyTickets.length})', 1),
                    ],
                  ),
                ),
                const Divider(color: AppColors.border, height: 1),

                // Tickets list display area
                Expanded(
                  child: currentTickets.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                          itemCount: currentTickets.length,
                          itemBuilder: (context, index) {
                            final ticket = currentTickets[index];
                            return GestureDetector(
                              onTap: () => _showTicketPass(context, ticket),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Row(
                                  children: [
                                    // Side vertical visual tag
                                    Container(
                                      width: 8,
                                      height: 100,
                                      color: ticket.isActive ? AppColors.primary : AppColors.muted,
                                    ),
                                    const SizedBox(width: 14),

                                    // Event Poster icon
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(ticket.event.imagePath, width: 64, height: 64, fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 14),

                                    // Details text
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ticket.event.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(ticket.event.date, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 2),
                                            Text('${ticket.quantity} Tiket • ${ticket.event.place}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // View button arrow indicator
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16, left: 8),
                                      child: Icon(
                                        Icons.qr_code_2,
                                        color: ticket.isActive ? AppColors.primary : AppColors.muted,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
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
            Icon(Icons.local_activity_outlined, size: 64, color: AppColors.muted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Tiket',
              style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _tabIndex == 0
                  ? 'Tiket konser aktif yang Anda beli akan terbit di sini.'
                  : 'Riwayat tiket yang sudah terpakai akan dicatat di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
