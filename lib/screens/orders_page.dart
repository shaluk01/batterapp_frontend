import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final token = ApiService.authToken;

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final data = await ApiService.getOrders();
      if (!mounted) return;

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isNotEmpty
                ? ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _orderCard(
                          context,
                          orderId: order['orderId']?.toString() ??
                              order['_id']?.toString() ??
                              '#ORD${index + 1}',
                          items: List<String>.from(order['items'] ?? const []),
                          amount: int.tryParse(
                                order['amount']?.toString() ?? '0',
                              ) ??
                              0,
                          status: order['status']?.toString() ?? 'Pending',
                        ),
                      );
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Orders",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      _orderCard(
                        context,
                        orderId: "#ORD1025",
                        items: ["Dosa Batter x2", "Idli Batter x1"],
                        amount: 250,
                        status: "Preparing",
                      ),
                      const SizedBox(height: 14),
                      _orderCard(
                        context,
                        orderId: "#ORD1024",
                        items: ["Combo Batter x1"],
                        amount: 120,
                        status: "On the way",
                      ),
                      const SizedBox(height: 14),
                      _orderCard(
                        context,
                        orderId: "#ORD1023",
                        items: ["Dosa Batter x1"],
                        amount: 90,
                        status: "Delivered",
                      ),
                    ],
                  ),
      ),
    );
  }

  // ================= ORDER CARD =================

  Widget _orderCard(
    BuildContext context, {
    required String orderId,
    required List<String> items,
    required int amount,
    required String status,
  }) {
    final statusColor = _statusColor(status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsPage(
              orderId: orderId,
              items: items,
              amount: amount,
              status: status,
              paymentMethod: 'Card',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(orderId,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 6),
            Text(items.join(", "), style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹$amount",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Preparing":
        return Colors.orange;
      case "On the way":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
