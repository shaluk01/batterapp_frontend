import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isEditing = false;

  final nameController = TextEditingController(text: "Ritika");
  final phoneController = TextEditingController(text: "+91 887354288");
  final addressController = TextEditingController(
      text: "123 Green Park, North Zone Near Blue Metro Station");
  final zoneController =
      TextEditingController(text: "Zone 1 - Anna Nagar");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F2),
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔶 Profile Card
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _field("Name", nameController),
                      _field("Phone number", phoneController),
                      _field("Address", addressController),
                      _field("Zone", zoneController),
                    ],
                  ),
                ),

                // ✏️ Floating Edit Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isEditing ? Icons.check : Icons.edit,
                      color: const Color.fromARGB(255, 255, 0, 0),
                    ),
                    onPressed: () {
                      setState(() => isEditing = !isEditing);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🔶 App Information
            const Text(
              "App Information",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            _infoTile("About us", Icons.info_outline),
            _infoTile("Privacy Policy", Icons.lock_outline),
            _infoTile("Terms & Conditions", Icons.description_outlined),

            const SizedBox(height: 30),

            // 🔴 Logout
            Center(
              child: TextButton.icon(
                onPressed: () {
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 Widgets

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Color.fromARGB(255, 255, 132, 0), fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: isEditing,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 249, 249),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDecoration(),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
        },
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
        )
      ],
    );
  }
}
