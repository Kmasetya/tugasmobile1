import '../models/event.dart';

class ApiService {
  // Simulate fetching all events with delay
  Future<List<Event>> getEvents({String? query, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulated network latency

    List<Event> results = List.from(allEvents);

    if (category != null && category != 'All') {
      results = results.where((e) => e.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((e) => 
        e.name.toLowerCase().contains(q) || 
        e.artist.toLowerCase().contains(q) || 
        e.place.toLowerCase().contains(q) ||
        e.venue.toLowerCase().contains(q)
      ).toList();
    }

    return results;
  }

  // Simulate fetching single event by ID
  Future<Event?> getEventById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400)); // Simulating quick details load
    try {
      return allEvents.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
