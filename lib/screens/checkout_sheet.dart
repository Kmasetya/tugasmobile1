import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/event.dart';
import '../services/app_state.dart';

class CheckoutSheet extends StatefulWidget {
  final Event event;

  const CheckoutSheet({super.key, required this.event});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  int _quantity = 1;
  bool _isProcessing = false;
  bool _isSuccess = false;

  final double _adminFee = 15000;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    final totalAmount = (widget.event.priceValue * _quantity) + _adminFee;
    
    try {
      // Create order payload for Midtrans
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/payment/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id': 'TIC-${widget.event.id.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}',
          'gross_amount': totalAmount.toInt(),
          'item_details': [
            {
              'id': widget.event.id,
              'price': widget.event.priceValue.toInt(),
              'quantity': _quantity,
              'name': widget.event.name.length > 50 ? widget.event.name.substring(0, 50) : widget.event.name
            },
            {
              'id': 'ADMIN',
              'price': _adminFee.toInt(),
              'quantity': 1,
              'name': 'Admin Fee'
            }
          ],
          'customer_details': {
            'first_name': AppState().userName,
            'email': AppState().userEmail,
            'phone': AppState().userPhone,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final redirectUrl = data['redirect_url'];

        // Open Midtrans Snap Payment Page
        final url = Uri.parse(redirectUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          
          // Normally we'd wait for a webhook or use Midtrans SDK callback.
          // For now, assume payment succeeds after they open the URL.
          await AppState().purchaseTicket(
            event: widget.event,
            quantity: _quantity,
            paymentMethod: 'Midtrans',
            totalAmount: totalAmount,
          );

          if (mounted) {
            setState(() {
              _isProcessing = false;
              _isSuccess = true;
            });
          }
        } else {
          throw 'Could not launch payment URL';
        }
      } else {
        throw 'Failed to get payment token: ${response.body}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.card,
            content: Text('Payment Error: $e', style: GoogleFonts.inter(color: Colors.redAccent)),
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.event.priceValue * _quantity;
    final total = subtotal + _adminFee;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    if (_isSuccess) {
      return _buildSuccessOverlay(total);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle bar
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Checkout Tiket', style: GoogleFonts.inter(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Concert Header Summary Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(widget.event.imagePath, width: 56, height: 56, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(widget.event.artist, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12)),
                      Text(widget.event.date, style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jumlah Tiket', style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              Container(
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(50), border: Border.all(color: AppColors.border)),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: AppColors.white, size: 16),
                      onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('$_quantity', style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.white, size: 16),
                      onPressed: _quantity < 5 ? () => setState(() => _quantity++) : null, // Limit 5 tickets
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Payment Details breakdown
          Text('Rincian Pembayaran', style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _detailRow('Harga Tiket ($_quantity x)', 'Rp ${_formatPrice(subtotal)}'),
          const SizedBox(height: 6),
          _detailRow('Biaya Admin & Layanan', 'Rp ${_formatPrice(_adminFee)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.border, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Pembayaran', style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              Text('Rp ${_formatPrice(total)}', style: GoogleFonts.inter(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),

          // Buy Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                    )
                  : Text('Bayar Sekarang', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessOverlay(double totalAmount) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Check Success icon indicator
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 40),
          ),
          const SizedBox(height: 24),

          // Title
          Text('Transaksi Sukses!', style: GoogleFonts.inter(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Tiket Anda berhasil dipesan dan diterbitkan.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 28),

          // Ticket Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                _successDetailRow('Konser', widget.event.name),
                const SizedBox(height: 8),
                _successDetailRow('Artis', widget.event.artist),
                const SizedBox(height: 8),
                _successDetailRow('Lokasi', widget.event.place),
                const SizedBox(height: 8),
                _successDetailRow('Tanggal', widget.event.date),
                const SizedBox(height: 8),
                _successDetailRow('Jumlah Tiket', '$_quantity Tiket'),
                const SizedBox(height: 8),
                _successDetailRow('Metode Bayar', 'Midtrans'),
                const Divider(color: AppColors.border, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Bayar', style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13)),
                    Text('Rp ${_formatPrice(totalAmount)}', style: GoogleFonts.inter(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Checkout CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text('Lihat Tiket Saya', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13)),
        Text(value, style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _successDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13)),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _formatPrice(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
