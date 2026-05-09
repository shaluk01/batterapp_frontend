import 'package:batter_app/screens/slot_selection_page.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),

      // 🔶 APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF8C3B),
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 🔶 BODY
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🧺 CART ITEMS
            Expanded(
              child: ListView(
                children: const [
                  _CartItem(
                    image: "assets/dosa.jpeg",
                    title: "Dosa Batter",
                    weight: "1 kg",
                    price: 90,
                    qty: 1,
                  ),
                  _CartItem(
                    image: "assets/idli.jpg",
                    title: "Idli Batter",
                    weight: "½ kg",
                    price: 70,
                    qty: 2,
                  ),
                ],
              ),
            ),

            // 🔢 BILL SUMMARY
            const _BillSummary(),

            const SizedBox(height: 16),

            // 🔶 CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Navigate to Slot Page later
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SlotSelectionPage(),
                          ),
                        );
                },
                child: const Text(
                  "Continue to Slot",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ======================= CART ITEM ======================= */

class _CartItem extends StatelessWidget {
  final String image;
  final String title;
  final String weight;
  final int price;
  final int qty;

  const _CartItem({
    required this.image,
    required this.title,
    required this.weight,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🖼 PRODUCT IMAGE
          Container(
            height: 64,
            width: 64,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(image, fit: BoxFit.cover),
          ),

          const SizedBox(width: 14),

          // 📦 DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weight,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹$price",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A18),
                  ),
                ),
              ],
            ),
          ),

          // ➕➖ QUANTITY
          Column(
            children: [
              const _QtyButton(icon: Icons.add, filled: true),
              const SizedBox(height: 6),
              Text("$qty"),
              const SizedBox(height: 6),
              const _QtyButton(icon: Icons.remove),
            ],
          ),
        ],
      ),
    );
  }
}

/* ======================= BILL SUMMARY ======================= */

class _BillSummary extends StatelessWidget {
  const _BillSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          _BillRow(label: "Total Items", value: "3"),
          _BillRow(label: "Subtotal", value: "₹230"),
          _BillRow(label: "Delivery", value: "₹20"),
          Divider(height: 24),
          _BillRow(
            label: "Total Amount",
            value: "₹250",
            bold: true,
          ),
        ],
      ),
    );
  }
}

/* ======================= BILL ROW ======================= */

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _BillRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: bold ? const Color(0xFFFF7A18) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/* ======================= QTY BUTTON ======================= */

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final bool filled;

  const _QtyButton({required this.icon, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFFF7A18) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(
        icon,
        size: 14,
        color: filled ? Colors.white : Colors.grey,
      ),
    );
  }
}
