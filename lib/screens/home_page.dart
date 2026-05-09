
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'cart_page.dart';
import 'orders_page.dart';
import 'notification_page.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      var data = await ApiService.getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF8C3B),
        title: const Text(
          "Batter Hub",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18),
                SizedBox(width: 4),
                Text("Anna Nagar"),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: _currentIndex == 0
          ? _homeBody()
          : _currentIndex == 1
              ? const OrdersPage()
              : _currentIndex == 2
                  ? const NotificationPage()
                  : const UserPage(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF7A18),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _homeBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const Center(child: Text("No products available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: products.length,
      itemBuilder: (context, index) {
        var item = products[index];

        return _BatterCard(
          title: item['name'] ?? "No Name",
          subtitle: item['description'] ?? "No Description",
          image: item['image'] ?? "assets/dosa.jpeg",
          price: item['price'] ?? 0,
        );
      },
    );
  }
}

// ================= BATTER CARD =================

class _BatterCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final int price;

  const _BatterCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
  });

  @override
  State<_BatterCard> createState() => _BatterCardState();
}

class _BatterCardState extends State<_BatterCard> {
  int qty = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              widget.image.startsWith("http")
                  ? Image.network(widget.image, height: 50, width: 50)
                  : Image.asset(widget.image, height: 50, width: 50),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(widget.subtitle,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${widget.price}"),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (qty > 0) {
                        setState(() => qty--);
                      }
                    },
                  ),
                  Text("$qty"),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => qty++);
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

