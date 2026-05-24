import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class _NotifItem {
  final String title;
  final String date;
  final String artist;
  final String imagePath;
  _NotifItem(this.title, this.date, this.artist, this.imagePath);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tabIndex = 0;

  final Map<String, List<_NotifItem>> _promoData = {
    '15 Juli 2025': [
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Hanni (New Jeans)', 'assets/images/hanni.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Karina (Aespa)', 'assets/images/karina.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Jihyo (Twice)', 'assets/images/jihyo.png'),
    ],
    '03 Mei 2025': [
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Jihyo (Twice)', 'assets/images/jihyo.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Wonyoung (IVE)', 'assets/images/wonyoung.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Rosé (BlackPink)', 'assets/images/rose.png'),
    ],
  };

  final Map<String, List<_NotifItem>> _transaksiData = {
    '15 Juli 2025': [
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Hanni (New Jeans)', 'assets/images/hanni.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Karina (Aespa)', 'assets/images/karina.png'),
    ],
    '03 Mei 2025': [
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Wonyoung (IVE)', 'assets/images/wonyoung.png'),
      _NotifItem('Journey Happiness Camp', 'Sunday,27 March 2026', 'Rosé (BlackPink)', 'assets/images/rose.png'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final data = _tabIndex == 0 ? _promoData : _transaksiData;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Text('Notification', style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _tabBtn('Promo', 0),
                  _tabBtn('Daftar Transaksi', 1),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: data.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key, style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      ...entry.value.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(item.imagePath, width: 56, height: 56, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                                  Text(item.date, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                                  Text(item.artist, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                              child: Text('Buy', style: GoogleFonts.inter(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
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
          child: Text(label, textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: isActive ? AppColors.primary : AppColors.muted, fontSize: 15, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
        ),
      ),
    );
  }
}
