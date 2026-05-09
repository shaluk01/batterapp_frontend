
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'profile_page.dart';

class OtpPage extends StatefulWidget {
  final String phone;

  const OtpPage({super.key, required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtp() async {
    try {
      String otp = otpController.text.trim();

      if (otp.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter valid 6-digit OTP")),
        );
        return;
      }

      // 🔥 CALL API
      final res = await ApiService.verifyOtp(widget.phone, otp);
      debugPrint(res.toString());

      if (!mounted) return;

      // ✅ SUCCESS → go to profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfilePage(),
        ),
      );
    } catch (e) {
      debugPrint("OTP Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          // TOP UI SAME
          Stack(
            children: [
              Container(
                height: size.height * 0.55,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF8C3B),
                      Color(0xFFFF6F00),
                    ],
                  ),
                ),
              ),
              const SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Batter Hub",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "OTP Verification",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          // BOTTOM UI
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text("Enter OTP"),

                    const SizedBox(height: 20),

                    // 🔥 SINGLE OTP FIELD (IMPORTANT)
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        hintText: "Enter 6-digit OTP",
                      ),
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: verifyOtp, // 🔥 FIXED
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        color: Colors.orange,
                        alignment: Alignment.center,
                        child: const Text(
                          "Verify OTP",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

