
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://batterapp-backend-2-1mhs.onrender.com";

  // Store token after login
  static String? authToken;

  // =======================
  // PRODUCTS
  // =======================

  static Future<List<dynamic>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/products'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<dynamic> getProductById(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/products/$id'),
    );
    return jsonDecode(res.body);
  }

  
  

  // =======================
  // USERS
  // =======================

  static Future<dynamic> getUserProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/users/profile'),
      headers: {"Authorization": "Bearer $authToken"},
    );

    return jsonDecode(res.body);
  }

  // =======================
  // ORDERS
  // =======================

  static Future<dynamic> createOrder(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/orders'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken"
      },
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getOrders() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/orders'),
      headers: {"Authorization": "Bearer $authToken"},
    );

    return jsonDecode(res.body);
  }

  // =======================
  // SLOTS
  // =======================

  static Future<dynamic> getSlots() async {
    final res = await http.get(Uri.parse('$baseUrl/api/slots'));
    return jsonDecode(res.body);
  }

  static Future<dynamic> getSlotAvailability(String zoneId, String date) async {
  final res = await http.get(
    Uri.parse('$baseUrl/api/slot-availability?zoneId=$zoneId&date=$date'),
  );

  return jsonDecode(res.body);
}

  // =======================
  // STOCK
  // =======================

  static Future<dynamic> getStock() async {
    final res = await http.get(Uri.parse('$baseUrl/api/stock'));
    return jsonDecode(res.body);
  }

  // =======================
  // ZONES
  // =======================

  static Future<dynamic> getZones() async {
    final res = await http.get(Uri.parse('$baseUrl/api/zones'));
    return jsonDecode(res.body);
  }

  // =======================
  // DELIVERY PARTNERS
  // =======================

  static Future<dynamic> getDeliveryPartners() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/delivery-partners'),
    );
    return jsonDecode(res.body);
  }

  // =======================
  // ADMIN (OPTIONAL)
  // =======================

  static Future<dynamic> getAllProductsAdmin() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/products/admin/all'),
      headers: {"Authorization": "Bearer $authToken"},
    );

    return jsonDecode(res.body);
  }
}

