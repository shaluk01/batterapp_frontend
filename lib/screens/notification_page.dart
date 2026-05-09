import 'package:flutter/material.dart';
import '../screens/chat_message.dart';
import '../services/openrouter_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: "👋 Hi! How can we help you today?", isUser: false)
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isTyping = true;
    });

    final reply = await OpenRouterService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(text: reply, isUser: false));
      _isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// 🔶 CONTACT OPTIONS
          Row(
            children: [
              _contactCard(
                icon: Icons.call,
                title: "Call us",
                subtitle: "+91 754789578",
              ),
              const SizedBox(width: 12),
              _contactCard(
                icon: Icons.email,
                title: "Email us",
                subtitle: "support@batterhub.com",
              ),
            ],
          ),
          const SizedBox(height: 12),
          _contactCard(
            icon: Icons.chat_bubble_outline,
            title: "Live Chat",
            subtitle: "Available 6 am – 11 pm",
            fullWidth: true,
          ),

          const SizedBox(height: 24),

          /// 🔶 CHAT SUPPORT BOX
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 254, 243, 235),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                /// HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7A18),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.support_agent, color: Colors.white),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chat Support",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Usually responds within a minute",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// CHAT MESSAGES
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (_, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? const Color(0xFFFF7A18)
                                : const Color.fromARGB(255, 255, 212, 175),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color:
                                  msg.isUser ? const Color.fromARGB(255, 255, 255, 255) : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                if (_isTyping)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Batter Hub is typing...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                /// INPUT BAR
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Type your message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send,
                            color: Color(0xFFFF7A18)),
                        onPressed: _sendMessage,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// 🔶 FAQ SECTION
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          _faqTile(
            "What are your Delivery Timings?",
            "We deliver fresh batter from 6:00 AM to 8:00 PM across all zones.",
          ),
          _faqTile(
            "How do I track my order?",
            "You can track your order from the Orders section in the app.",
          ),
          _faqTile(
            "Can I cancel my order?",
            "Orders can be cancelled up to 1 hour before dispatch.",
          ),
          _faqTile(
            "How fresh is the batter?",
            "Our batter is freshly prepared every day with premium ingredients.",
          ),
        ],
      ),
    );
  }

  /// 🔹 CONTACT CARD
  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 2 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
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
            Icon(icon, color: const Color(0xFFFF7A18)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  /// 🔹 FAQ TILE
  Widget _faqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(question,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(answer, style: const TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
