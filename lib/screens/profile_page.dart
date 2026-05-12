import '../services/api_service.dart';
import 'package:batter_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String selectedZone = "Zone 1 - Anna Nagar";

  Map<String, dynamic>? profile;

  bool isLoading = true;


   LatLng currentLocation = const LatLng(13.0827, 80.2707);

  final List<String> zones = [
    "Zone 1 - Anna Nagar",
    "Zone 2 - T Nagar",
    "Zone 3 - Velachery",
    "Zone 4 - Adyar",
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {

    final token = ApiService.authToken;

    if (token == null || token.isEmpty) {

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {

      final data = await ApiService.getUserProfile();

      if (!mounted) return;

      setState(() {
        profile = data;
        isLoading = false;
      });

      if (data is Map) {
        selectedZone =
            data['zone']?.toString() ?? selectedZone;
      }

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ==========================
  // AUTO DETECT LOCATION
  // ==========================

  Future<void> _autoDetectZone() async {

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position =
    await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
  ),
);

   
    setState(() {
      currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );
    });

    final placemarks =
        await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final area =
        "${placemarks.first.subLocality} ${placemarks.first.locality}";

    setState(() {

      if (area.contains("Anna")) {

        selectedZone =
            "Zone 1 - Anna Nagar";

      } else if (area.contains("T Nagar")) {

        selectedZone =
            "Zone 2 - T Nagar";

      } else if (area.contains("Velachery")) {

        selectedZone =
            "Zone 3 - Velachery";

      } else {

        selectedZone =
            "Zone 4 - Adyar";
      }
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Location detected: $selectedZone"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(
              children: [

                // ==========================
                // TOP IMAGE + GRADIENT
                // ==========================

                Stack(
                  children: [

                    Container(
                      height: size.height * 0.5,

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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Almost there!",

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
                        height: size.height * 0.5,

                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(32),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withValues(
                                      alpha: 0.35),

                              blurRadius: 30,

                              offset:
                                  const Offset(0, 18),
                            ),
                          ],
                        ),

                        clipBehavior: Clip.antiAlias,

                        child: Image.asset(
                          "assets/batters.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),

                // ==========================
                // FORM CARD
                // ==========================

                Expanded(
                  child: Transform.translate(

                    offset: const Offset(0, -40),

                    child: Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.fromLTRB(
                              24, 40, 24, 28),

                      decoration: BoxDecoration(

                        gradient:
                            const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.white,
                            Color(0xFFFFF3E0),
                          ],
                        ),

                        borderRadius:
                            const BorderRadius.vertical(
                          top: Radius.circular(48),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withValues(
                                    alpha: 0.08),

                            blurRadius: 20,

                            offset:
                                const Offset(0, -6),
                          ),
                        ],
                      ),

                      child: SingleChildScrollView(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              "Tell us a bit about yourself",

                              style: TextStyle(
                                fontSize: 25,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 20),

                            _input("Name"),
                            _input("Address"),
                            _input("Phone Number"),

                            const SizedBox(height: 8),

                            const Text(
                              "Zone",

                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // ==========================
                            // ZONE + AUTO DETECT
                            // ==========================

                            Row(
                              children: [

                                Expanded(
                                  child: Container(

                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 16,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      color:
                                          Colors.white,

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  18),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .black
                                              .withValues(
                                                  alpha:
                                                      0.05),

                                          blurRadius:
                                              10,
                                        ),
                                      ],
                                    ),

                                    child:
                                        DropdownButtonHideUnderline(

                                      child:
                                          DropdownButton<
                                              String>(

                                        value:
                                            selectedZone,

                                        isExpanded:
                                            true,

                                        items: zones
                                            .map(
                                              (z) =>
                                                  DropdownMenuItem(
                                                value:
                                                    z,

                                                child:
                                                    Text(
                                                        z),
                                              ),
                                            )
                                            .toList(),

                                        onChanged:
                                            (value) {

                                          setState(() {
                                            selectedZone =
                                                value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                GestureDetector(

                                  onTap:
                                      _autoDetectZone,

                                  child: Container(

                                    height: 56,

                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 16,
                                    ),

                                    decoration:
                                        BoxDecoration(

                                      gradient:
                                          const LinearGradient(
                                        colors: [
                                          Color(
                                              0xFFFF7A18),
                                          Color(
                                              0xFFFFA040),
                                        ],
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  18),

                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .orange
                                              .withValues(
                                                  alpha:
                                                      0.4),

                                          blurRadius:
                                              10,
                                        ),
                                      ],
                                    ),

                                    child: const Row(
                                      children: [

                                        Icon(
                                          Icons
                                              .my_location,

                                          color:
                                              Colors
                                                  .white,

                                          size: 18,
                                        ),

                                        SizedBox(
                                            width: 6),

                                        Text(
                                          "Auto Detect",

                                          style:
                                              TextStyle(
                                            color:
                                                Colors
                                                    .white,

                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ==========================
                            //  OPEN STREET MAP
                            // ==========================

                            const SizedBox(height: 20),

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                      20),

                              child: SizedBox(

                                height: 220,

                                child: FlutterMap(

                                  options: MapOptions(
                                    initialCenter:
                                        currentLocation,

                                    initialZoom: 15,
                                  ),

                                  children: [

                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    ),

                                    MarkerLayer(
                                      markers: [

                                        Marker(
                                          point:
                                              currentLocation,

                                          width: 80,
                                          height: 80,

                                          child:
                                              const Icon(
                                            Icons
                                                .location_pin,

                                            color:
                                                Colors
                                                    .red,

                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ==========================
                            // SUBMIT BUTTON
                            // ==========================

                            GestureDetector(

                              onTap: () {

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePage(),
                                  ),
                                );
                              },

                              child: Container(

                                height: 56,

                                width: double.infinity,

                                decoration:
                                    BoxDecoration(

                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFFFF7A18),
                                      Color(0xFFFFA040),
                                    ],
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(18),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .orange
                                          .withValues(
                                              alpha:
                                                  0.45),

                                      blurRadius: 14,

                                      offset:
                                          const Offset(
                                              0, 7),
                                    ),
                                  ],
                                ),

                                alignment:
                                    Alignment.center,

                                child: const Text(
                                  "Get Started",

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _input(String label) {

    return Padding(

      padding:
          const EdgeInsets.only(bottom: 18),

      child: TextField(

        decoration: InputDecoration(

          labelText: label,

          filled: true,

          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),

          border: OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}