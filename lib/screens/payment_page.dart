import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedPayment = 0; // 0 = COD, 1 = Online
  final List<Map<String, dynamic>> cartItems = const [
    {"name": "Dosa Batter 1/2 kg", "qty": 1},
    {"name": "Dosa Batter 650 g", "qty": 2},
    {"name": "Combo Batter 1/2 kg", "qty": 1},
  ];
  final int totalAmount = 340;

  Future<void> _confirmOrder() async {
    final token = ApiService.authToken;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login required before placing order.')),
      );
      return;
    }

    try {
      final result = await ApiService.createOrder({
        "items": cartItems,
        "total": totalAmount,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed: $result')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),

      // 🔶 APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF7A18),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _sectionTitle("Delivery Address"),
            _infoCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kritika",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  SizedBox(height: 6),
                  Text(
                    "123 Green Park, North Zone Near Blue Metro Station\n+91 8456787899\nZone 8 - Anna Nagar",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Time Slot"),
            _infoCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "27-11-2025, 8:00 am - 9:00 am",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Estimated delivery within 1 hour",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _sectionTitle("Select Payment Method"),
            const SizedBox(height: 10),

            _paymentTile(
              index: 0,
              title: "Cash on Delivery",
              subtitle: "Pay when you receive your batter",
              icon: Icons.payments_outlined,
            ),

            const SizedBox(height: 12),

            _paymentTile(
              index: 1,
              title: "Pay Online",
              subtitle: "UPI, Net Banking via Razorpay",
              icon: Icons.credit_card,
            ),

            const SizedBox(height: 30),

            _sectionTitle("Order Summary"),
            _infoCard(
              child: const Column(
                children: [
                  _OrderRow("Dosa Batter 1/2 kg", "1", "₹90"),
                  _OrderRow("Dosa Batter 650 g", "2", "₹180"),
                  _OrderRow("Combo Batter 1/2 kg", "1", "₹50"),
                  Divider(height: 30),
                  _OrderRow("Subtotal", "", "₹320"),
                  _OrderRow("Delivery Fee", "", "₹20"),
                  SizedBox(height: 6),
                  _OrderRow(
                    "Total",
                    "",
                    "₹340",
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔶 CONFIRM BUTTON
            GestureDetector(
              onTap: _confirmOrder,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF7A18),
                      Color(0xFFFFA040),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Confirm Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ======================= HELPERS ======================= */

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _paymentTile({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedPayment = index);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF1E5) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFFF7A18) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? const Color(0xFFFF7A18) : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: const Color(0xFFFF7A18),
            )
          ],
        ),
      ),
    );
  }
}

/* ======================= ORDER ROW ======================= */

class _OrderRow extends StatelessWidget {
  final String title;
  final String qty;
  final String price;
  final bool bold;

  const _OrderRow(this.title, this.qty, this.price, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              qty.isEmpty ? title : "$title x$qty",
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
