import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_page.dart'; // Add this import or adjust the path to where PaymentPage is defined

class SlotSelectionPage extends StatefulWidget {
  const SlotSelectionPage({super.key});

  @override
  State<SlotSelectionPage> createState() => _SlotSelectionPageState();
}

class _SlotSelectionPageState extends State<SlotSelectionPage> {
  int selectedTab = 1; // 0 = Today, 1 = Tomorrow
  int selectedSlotIndex = -1;

  List<Map<String, dynamic>> slots = [
    {
      "time": "7:00 am - 8:00 am",
      "status": "filled",
    },
    {
      "time": "8:00 am - 9:00 am",
      "status": "available",
      "booked": "8 of 10 slots booked",
    },
    {
      "time": "12:00 pm - 1:00 pm",
      "status": "available",
      "booked": "8 of 10 slots booked",
    },
    {
      "time": "3:00 pm - 4:00 pm",
      "status": "available",
      "booked": "4 of 10 slots booked",
    },
    {
      "time": "6:00 pm - 7:00 pm",
      "status": "filled",
    },
    {
      "time": "8:00 pm - 9:00 pm",
      "status": "available",
      "booked": "9 of 10 slots booked",
    },
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSlots();
  }

  Future<void> loadSlots() async {
    try {
      final data = await ApiService.getSlots();

      if (!mounted) return;

      setState(() {
        if (data is List) {
          slots = List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['slots'] is List) {
          slots = List<Map<String, dynamic>>.from(data['slots']);
        }
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

      // 🔶 APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF7A18),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          "Batter Hub",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔶 TITLE
            const Text(
              "Choose Your Delivery Slot",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Select a convenient time for your batter delivery",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // 🔶 TODAY / TOMORROW TOGGLE
            Row(
              children: [
                _DayTab(
                  title: "Today",
                  selected: selectedTab == 0,
                  onTap: () {
                    setState(() {
                      selectedTab = 0;
                      selectedSlotIndex = -1;
                    });
                  },
                ),
                _DayTab(
                  title: "Tomorrow",
                  selected: selectedTab == 1,
                  onTap: () {
                    setState(() {
                      selectedTab = 1;
                      selectedSlotIndex = -1;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔶 SLOT GRID
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      itemCount: slots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.6,
                      ),
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        final bool isFilled = slot["status"] == "filled";
                        final bool isSelected = selectedSlotIndex == index;

                        return GestureDetector(
                          onTap: isFilled
                              ? null
                              : () {
                                  setState(() {
                                    selectedSlotIndex = index;
                                  });
                                },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF1E5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF7A18)
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slot["time"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isFilled ? Colors.grey : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  isFilled ? "Slots filled" : slot["booked"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isFilled
                                        ? Colors.grey
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // 🔶 CONTINUE BUTTON
            GestureDetector(
              onTap: selectedSlotIndex == -1
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentPage()),
                      );
                    },
              child: Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selectedSlotIndex == -1
                      ? Colors.grey.shade300
                      : const Color(0xFFFF7A18),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Continue to Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
}

/* ======================= DAY TAB ======================= */

class _DayTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _DayTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFFFF7A18)
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: double.infinity,
              color: selected
                  ? const Color(0xFFFF7A18)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
