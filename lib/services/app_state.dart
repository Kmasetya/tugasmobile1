import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import 'api_service.dart';

class PurchasedTicket {
  final String ticketCode;
  final Event event;
  final String datePurchased;
  final int quantity;
  final double totalAmount;
  final String paymentMethod;
  final bool isActive;

  PurchasedTicket({
    required this.ticketCode,
    required this.event,
    required this.datePurchased,
    required this.quantity,
    required this.totalAmount,
    required this.paymentMethod,
    this.isActive = true,
  });
}

class TransactionNotification {
  final String id;
  final String title;
  final String date;
  final String artist;
  final String imagePath;
  final String type; // 'Promo' or 'Transaksi'
  final String message;

  TransactionNotification({
    required this.id,
    required this.title,
    required this.date,
    required this.artist,
    required this.imagePath,
    required this.type,
    required this.message,
  });
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    // Load initial mock data
    _initMockData();
  }

  final ApiService _apiService = ApiService();

  // Authentication State
  bool _isLoggedIn = false; // Will be determined by Firebase
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  User? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  User? get currentUser => _currentUser;

  // Initialize Firebase Auth Listener
  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _currentUser = user;
      _isLoggedIn = user != null;
      if (user != null) {
        _userEmail = user.email ?? '';
        // Fetch user data from Firestore
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists) {
            final data = doc.data()!;
            _userName = data['name'] ?? user.email?.split('@')[0] ?? 'User';
            _userPhone = data['phone'] ?? '';
          } else {
            _userName = user.email?.split('@')[0] ?? 'User';
          }
        } catch (e) {
          debugPrint('Error fetching user data: $e');
        }
      } else {
        _userEmail = '';
        _userName = '';
        _userPhone = '';
      }
      notifyListeners();
    });
  }

  // Events & Filtering State
  List<Event> _events = [];
  bool _isLoadingEvents = false;
  String _searchQuery = '';
  String _activeCategory = 'All';

  List<Event> get events => _events;
  bool get isLoadingEvents => _isLoadingEvents;
  String get searchQuery => _searchQuery;
  String get activeCategory => _activeCategory;

  // Favorites
  final Set<String> _favoriteEventIds = {'1'}; // IVE favorited by default

  Set<String> get favoriteEventIds => _favoriteEventIds;

  // Purchased Tickets
  final List<PurchasedTicket> _purchasedTickets = [];

  List<PurchasedTicket> get purchasedTickets => _purchasedTickets;

  // Dynamic Notifications & Transactions List
  final List<TransactionNotification> _notifications = [];
  List<TransactionNotification> get notifications => _notifications;

  void _initMockData() {
    _initAuthListener();

    // Pre-populate purchased tickets with initial samples to match design
    _purchasedTickets.addAll([
      PurchasedTicket(
        ticketCode: 'TIC-IVE-8821B',
        event: allEvents[0], // IVE
        datePurchased: 'Yesterday',
        quantity: 1,
        totalAmount: 865000,
        paymentMethod: 'GoPay',
        isActive: true,
      ),
      PurchasedTicket(
        ticketCode: 'TIC-AESPA-9013A',
        event: allEvents[1], // Aespa
        datePurchased: '03 Mei 2025',
        quantity: 2,
        totalAmount: 2015000,
        paymentMethod: 'Virtual Account',
        isActive: true,
      ),
      PurchasedTicket(
        ticketCode: 'TIC-HANNI-2234K',
        event: allEvents[2], // Hanni (Upcoming)
        datePurchased: '03 Mei 2025',
        quantity: 1,
        totalAmount: 565000,
        paymentMethod: 'OVO',
        isActive: false, // Inactive / Used / List
      ),
    ]);

    // Pre-populate notifications
    _notifications.addAll([
      TransactionNotification(
        id: 'n1',
        title: 'Diskon Spesial DIVE!',
        date: '15 Juli 2025',
        artist: 'IVE',
        imagePath: 'assets/images/ive_event.png',
        type: 'Promo',
        message: 'Dapatkan diskon 10% khusus untuk pemesanan tiket konser IVE minggu ini!',
      ),
      TransactionNotification(
        id: 'n2',
        title: 'Tiket Berhasil Dipesan!',
        date: 'Yesterday',
        artist: 'IVE',
        imagePath: 'assets/images/ive_event.png',
        type: 'Transaksi',
        message: 'Pembayaran tiket IVE via GoPay sukses. Silakan cek menu Tiket Aktif.',
      ),
      TransactionNotification(
        id: 'n3',
        title: 'Promo Flash Sale 9.9',
        date: '03 Mei 2025',
        artist: 'Karina (Aespa)',
        imagePath: 'assets/images/karina.png',
        type: 'Promo',
        message: 'Jangan lewatkan tiket barisan depan eksklusif Aespa dengan potongan hingga Rp 150.000!',
      ),
      TransactionNotification(
        id: 'n4',
        title: 'Pembelian Tiket Sukses',
        date: '03 Mei 2025',
        artist: 'Hanni (New Jeans)',
        imagePath: 'assets/images/hanni.png',
        type: 'Transaksi',
        message: 'Pemesanan tiket Hanni (New Jeans) terverifikasi. Transaksi selesai.',
      ),
    ]);

    // Trigger initial fetch of events
    fetchEvents();
  }

  // Fetch Events from API Service
  Future<void> fetchEvents() async {
    _isLoadingEvents = true;
    notifyListeners();

    try {
      _events = await _apiService.getEvents(
        query: _searchQuery,
        category: _activeCategory,
      );
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoadingEvents = false;
      notifyListeners();
    }
  }

  // Update search and query API
  void updateSearch(String query) {
    _searchQuery = query;
    fetchEvents();
  }

  // Update category and query API
  void updateCategory(String category) {
    _activeCategory = category;
    fetchEvents();
  }

  // Favorite management
  bool isFavorite(String eventId) {
    return _favoriteEventIds.contains(eventId);
  }

  void toggleFavorite(String eventId) {
    if (_favoriteEventIds.contains(eventId)) {
      _favoriteEventIds.remove(eventId);
    } else {
      _favoriteEventIds.add(eventId);
    }
    notifyListeners();
  }

  // Dynamic booking & checkout
  Future<void> purchaseTicket({
    required Event event,
    required int quantity,
    required String paymentMethod,
    required double totalAmount,
  }) async {
    final ticketCode = 'TIC-${event.id.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    final newTicket = PurchasedTicket(
      ticketCode: ticketCode,
      event: event,
      datePurchased: 'Hari ini, ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      quantity: quantity,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      isActive: true,
    );

    // Add to ticket list locally for instant UI update
    _purchasedTickets.insert(0, newTicket);

    // Add to notification transaction history
    _notifications.insert(0, TransactionNotification(
      id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Pembelian Tiket Berhasil!',
      date: 'Hari ini',
      artist: event.artist,
      imagePath: event.imagePath,
      type: 'Transaksi',
      message: 'Sukses membeli $quantity tiket ${event.name} senilai Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
    ));

    notifyListeners();

    // Save to Firestore
    if (_currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).collection('tickets').doc(ticketCode).set({
          'ticketCode': ticketCode,
          'eventId': event.id,
          'eventName': event.name,
          'datePurchased': newTicket.datePurchased,
          'quantity': quantity,
          'totalAmount': totalAmount,
          'paymentMethod': paymentMethod,
          'isActive': true,
        });
      } catch (e) {
        debugPrint('Error saving ticket to Firestore: $e');
      }
    }
  }

  // Auth operations
  Future<void> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup({required String email, required String password, String name = '', String phone = ''}) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Save additional info to Firestore
      if (credential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'email': email,
          'name': name,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _favoriteEventIds.clear();
    _purchasedTickets.clear(); // Optionally clear local tickets on logout
    notifyListeners();
  }
}
