import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/event.dart';
import '../services/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final List<String> _filters = ['All', 'Party', 'Night', 'Morning'];
  String _sortBy = 'Default'; // 'Default', 'Price Low-to-High', 'Price High-to-Low'

  @override
  void initState() {
    super.initState();
    // Register search listener to AppState
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    AppState().updateSearch(_searchController.text);
  }

  // Opens a premium sorting filter dialog
  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Urutkan Berdasarkan',
                    style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _sortOptionTile(setModalState, 'Default', 'Rekomendasi Default'),
                  _sortOptionTile(setModalState, 'Price Low-to-High', 'Harga: Terendah ke Tertinggi'),
                  _sortOptionTile(setModalState, 'Price High-to-Low', 'Harga: Tertinggi ke Terendah'),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sortOptionTile(StateSetter setModalState, String value, String label) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        setModalState(() {});
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  List<Event> _applySort(List<Event> list) {
    List<Event> sorted = List.from(list);
    if (_sortBy == 'Price Low-to-High') {
      sorted.sort((a, b) => a.priceValue.compareTo(b.priceValue));
    } else if (_sortBy == 'Price High-to-Low') {
      sorted.sort((a, b) => b.priceValue.compareTo(a.priceValue));
    }
    return sorted;
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
            // Apply sorting to current dynamic loaded list
            final filteredList = _applySort(appState.events);
            final bool isSearchingOrFiltered = appState.searchQuery.isNotEmpty || appState.activeCategory != 'All';

            return RefreshIndicator(
              onRefresh: () => appState.fetchEvents(),
              color: AppColors.primary,
              backgroundColor: AppColors.card,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 12),

                  // Search Bar & Filter Options Button
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
                              hintText: 'Cari konser, artis, atau lokasi...',
                              hintStyle: GoogleFonts.inter(color: AppColors.muted),
                              prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.muted),
                                      onPressed: () => _searchController.clear(),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _showSortDialog,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(23),
                            border: Border.all(
                              color: _sortBy != 'Default' ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: _sortBy != 'Default' ? AppColors.primary : AppColors.muted,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Event Filter Tabs Category
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, index) {
                        final filter = _filters[index];
                        final isActive = filter == appState.activeCategory;
                        return GestureDetector(
                          onTap: () => appState.updateCategory(filter),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : AppColors.card,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: isActive ? AppColors.primary : AppColors.border,
                              ),
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
                  const SizedBox(height: 20),

                  // If loading, show elegant shimmer loading states
                  if (appState.isLoadingEvents)
                    _buildShimmerLoader()
                  else if (filteredList.isEmpty)
                    _buildEmptyResults()
                  else if (isSearchingOrFiltered)
                    ...[
                      // Search Results Header
                      Row(
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            'Hasil Pencarian (${filteredList.length})',
                            style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Grid/List of Results
                      ...filteredList.map((event) => _buildEventRowCard(event)),
                      const SizedBox(height: 32),
                    ]
                  else ...[
                    // Standard Home View: Rekomendasi
                    Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text('Rekomendasi Event', style: GoogleFonts.inter(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Rekomendasi Horizontal List
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredList.length >= 2 ? 2 : filteredList.length,
                        itemBuilder: (context, index) {
                          final event = filteredList[index];
                          return GestureDetector(
                            onTap: () => context.push('/event/${event.id}'),
                            child: Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      event.imagePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(event.venue, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                                        Text(event.date, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
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

                    // Upcoming Events Title
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

                    // Upcoming List Items (all items from index 2 onwards)
                    ...filteredList.skip(2).map((event) => _buildEventRowCard(event)),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventRowCard(Event event) {
    return GestureDetector(
      onTap: () => context.push('/event/${event.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(event.imagePath, width: 62, height: 62, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(event.date, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500)),
                  Text('${event.artist} • ${event.place}', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Buy',
                style: GoogleFonts.inter(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 120,
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_outlined, size: 64, color: AppColors.muted),
            const SizedBox(height: 16),
            Text(
              'Konser Tidak Ditemukan',
              style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba kata kunci lain atau pilih filter yang berbeda.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
