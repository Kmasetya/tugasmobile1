import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Party', 'Night', 'Morning'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 12),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(color: AppColors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.inter(color: AppColors.muted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.muted, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rekomendasi Event
            Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text('Rekomendasi Event', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 255,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedEvents.length,
                itemBuilder: (context, index) {
                  final event = recommendedEvents[index];
                  return GestureDetector(
                    onTap: () => context.push('/event/${event.id}'),
                    child: Container(
                      width: 170,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 175,
                            child: Image.asset(event.imagePath, fit: BoxFit.cover, width: double.infinity),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.name, style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(event.venue, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                                Text(event.date, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Events
            Row(
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF50057))),
                    const SizedBox(width: 4),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(width: 8),
                Text('Upcoming Events', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),

            // Filter Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isActive = filter == _activeFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.card,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        filter,
                        style: GoogleFonts.inter(
                          color: isActive ? AppColors.white : AppColors.muted,
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Upcoming List
            ...upcomingEvents.map(
              (event) => GestureDetector(
                onTap: () => context.push('/event/${event.id}'),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(event.imagePath, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(event.date, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                            Text(event.artist, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
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
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
