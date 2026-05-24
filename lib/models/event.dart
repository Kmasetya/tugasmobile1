class Event {
  final String id;
  final String name;
  final String venue;
  final String date;
  final String fullDate;
  final String place;
  final String price;
  final String description;
  final String imagePath;

  Event({
    required this.id,
    required this.name,
    required this.venue,
    required this.date,
    required this.fullDate,
    required this.place,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}

class UpcomingEvent {
  final String id;
  final String title;
  final String date;
  final String artist;
  final String imagePath;

  UpcomingEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.artist,
    required this.imagePath,
  });
}

final List<Event> recommendedEvents = [
  Event(
    id: '1',
    name: 'IVE',
    venue: 'Bandung City Mall',
    date: 'Monday,23 June 2025',
    fullDate: 'Sunday,15 Juli 2025',
    place: 'Stadion GBK',
    price: 'Rp 850.000',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    imagePath: 'assets/images/ive_event.png',
  ),
  Event(
    id: '2',
    name: 'Aespa',
    venue: 'Bandung City Mall',
    date: 'Monday,23 June 2025',
    fullDate: 'Monday,23 June 2025',
    place: 'Stadion GBK',
    price: 'Rp 1.000.000',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    imagePath: 'assets/images/aespa_event.png',
  ),
];

final List<UpcomingEvent> upcomingEvents = [
  UpcomingEvent(id: 'u1', title: 'Journey Happiness Camp', date: 'Sunday,27 March 2026', artist: 'Hanni (New Jeans)', imagePath: 'assets/images/hanni.png'),
  UpcomingEvent(id: 'u2', title: 'Journey Happiness Camp', date: 'Sunday,27 March 2026', artist: 'Karina (Aespa)', imagePath: 'assets/images/karina.png'),
  UpcomingEvent(id: 'u3', title: 'Journey Happiness Camp', date: 'Sunday,27 March 2026', artist: 'Jihyo (Twice)', imagePath: 'assets/images/jihyo.png'),
  UpcomingEvent(id: 'u4', title: 'Journey Happiness Camp', date: 'Sunday,27 March 2026', artist: 'Wonyoung (IVE)', imagePath: 'assets/images/wonyoung.png'),
  UpcomingEvent(id: 'u5', title: 'Journey Happiness Camp', date: 'Sunday,27 March 2026', artist: 'Rosé (BlackPink)', imagePath: 'assets/images/rose.png'),
];
