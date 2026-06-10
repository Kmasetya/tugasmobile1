class Event {
  final String id;
  final String name;
  final String venue;
  final String date;
  final String fullDate;
  final String place;
  final String price;
  final double priceValue; // for calculation
  final String description;
  final String imagePath;
  final String category; // 'Party', 'Night', 'Morning'
  final String artist;

  Event({
    required this.id,
    required this.name,
    required this.venue,
    required this.date,
    required this.fullDate,
    required this.place,
    required this.price,
    required this.priceValue,
    required this.description,
    required this.imagePath,
    required this.category,
    required this.artist,
  });
}

final List<Event> allEvents = [
  Event(
    id: '1',
    name: 'IVE THE 1ST WORLD TOUR',
    venue: 'Bandung City Mall',
    date: 'Monday, 23 June 2025',
    fullDate: 'Monday, 23 June 2025',
    place: 'Stadion Utama GBK',
    price: 'Rp 850.000',
    priceValue: 850000,
    description:
        'Saksikan penampilan spektakuler dari IVE dalam tur dunia pertama mereka! Nikmati vokal memukau, koreografi sinkron, dan tata panggung megah yang akan menyajikan malam luar biasa bagi para DIVE di Indonesia.',
    imagePath: 'assets/images/ive_event.png',
    category: 'Party',
    artist: 'IVE',
  ),
  Event(
    id: '2',
    name: 'Aespa Live Tour - SYNK',
    venue: 'Bandung City Mall',
    date: 'Wednesday, 25 June 2025',
    fullDate: 'Wednesday, 25 June 2025',
    place: 'Stadion Utama GBK',
    price: 'Rp 1.000.000',
    priceValue: 1000000,
    description:
        'Masuki dunia virtual kwangya bersama Aespa! Tur konser SYNK menghadirkan visual memukau teknologi AI terdepan dengan hits internasional seperti Drama, Next Level, dan Supernova.',
    imagePath: 'assets/images/aespa_event.png',
    category: 'Night',
    artist: 'Aespa',
  ),
  Event(
    id: 'u1',
    name: 'Journey Happiness Camp',
    venue: 'Cikole Green Forest',
    date: 'Sunday, 27 March 2026',
    fullDate: 'Sunday, 27 March 2026',
    place: 'Pine Forest Bandung',
    price: 'Rp 550.000',
    priceValue: 550000,
    description:
        'Nikmati festival musik bernuansa alam terbuka di sejuknya hutan pinus Lembang. Bersantai bersama penampilan hangat dari Hanni yang akan membawakan lagu akustik yang menenangkan jiwa.',
    imagePath: 'assets/images/hanni.png',
    category: 'Morning',
    artist: 'Hanni (New Jeans)',
  ),
  Event(
    id: 'u2',
    name: 'Cyber Rave Neon Night',
    venue: 'Dago Highlands',
    date: 'Friday, 10 April 2026',
    fullDate: 'Friday, 10 April 2026',
    place: 'Skyline Arena Bandung',
    price: 'Rp 750.000',
    priceValue: 750000,
    description:
        'Pesta rave neon elektronik paling dinamis tahun ini. Menampilkan set list musik EDM energik berkelas dunia bersama Karina yang akan memanaskan lantai dansa semalaman penuh.',
    imagePath: 'assets/images/karina.png',
    category: 'Night',
    artist: 'Karina (Aespa)',
  ),
  Event(
    id: 'u3',
    name: 'Sunset Acoustic Session',
    venue: 'Floating Market Dago',
    date: 'Saturday, 18 April 2026',
    fullDate: 'Saturday, 18 April 2026',
    place: 'Amphitheater Dago',
    price: 'Rp 450.000',
    priceValue: 450000,
    description:
        'Alunan lagu-lagu romantis yang syahdu mengiringi pemandangan matahari terbenam kota Bandung. Bernyanyi bersama vokal emas Jihyo dalam atmosfer santai, intim, dan penuh kehangatan.',
    imagePath: 'assets/images/jihyo.png',
    category: 'Morning',
    artist: 'Jihyo (Twice)',
  ),
  Event(
    id: 'u4',
    name: 'Summer Paradise Pop Festival',
    venue: 'Trans Studio Mall',
    date: 'Saturday, 02 May 2026',
    fullDate: 'Saturday, 02 May 2026',
    place: 'Convention Hall TSM',
    price: 'Rp 900.000',
    priceValue: 900000,
    description:
        'Sambut musim panas dengan festival musik pop termegah bersama Wonyoung! Penuh dengan wahana interaktif, stan makanan estetik, dan pertunjukan panggung penuh kejutan dan keceriaan.',
    imagePath: 'assets/images/wonyoung.png',
    category: 'Party',
    artist: 'Wonyoung (IVE)',
  ),
  Event(
    id: 'u5',
    name: 'Pink Rose Elegance Tour',
    venue: 'Sasana Budaya Ganesha',
    date: 'Sunday, 17 May 2026',
    fullDate: 'Sunday, 17 May 2026',
    place: 'SABUGA ITB',
    price: 'Rp 1.200.000',
    priceValue: 1200000,
    description:
        'Konser solo eksklusif nan elegan yang menyoroti talenta luar biasa Rosé. Menampilkan aransemen musik orkestra megah berpadu vokal unik ikonik yang menghadirkan pengalaman emosional mendalam.',
    imagePath: 'assets/images/rose.png',
    category: 'Night',
    artist: 'Rosé (BlackPink)',
  ),
];

// Deprecated lists kept for backward compatibility if needed, but mapped to new models
final List<Event> recommendedEvents = allEvents.take(2).toList();
final List<Event> upcomingEvents = allEvents.skip(2).toList();
