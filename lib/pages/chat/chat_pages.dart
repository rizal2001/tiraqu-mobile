import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChatPages extends StatefulWidget {
  const ChatPages({super.key});

  @override
  State<ChatPages> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // List chat
  List<Map<String, dynamic>> messages = [];

  // Option
  final List<Map<String, String>> options = [
    {
      "text": "Informasi Seputar Satu",
      "reply": "Ini jawaban untuk Informasi Seputar Satu.",
    },
    {
      "text": "Kendala Pelayanan Dua",
      "reply": "Berikut solusi untuk Kendala Pelayanan Dua.",
    },
    {
      "text": "Mulai Percakapan AI",
      "reply": "Silakan ketik pertanyaanmu, AI siap membantu!",
    },
  ];

  // Pesan sistem awal
  @override
  void initState() {
    super.initState();
    messages.add({
      "text":
          "Halo, ini merupakan ucapan selamat datang.\nBerikut adalah beberapa informasi kendala yang bisa kamu pilih.",
      "isUser": false,
      "isInitial": true,
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"text": text, "isUser": true});
      messages.add({
        "text": "Mohon tunggu...",
        "isUser": false,
        "isWaiting": true,
      });
    });

    _controller.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      final index = messages.indexWhere((m) => m["isWaiting"] == true);
      if (index != -1) {
        messages[index] = {"text": text, "isUser": false};
      }
    });

    _scrollToBottom();
  }

  void _handleOptionClick(Map<String, String> option) async {
    setState(() {
      messages.add({"text": option["text"]!, "isUser": true});
      messages.add({
        "text": "Mohon tunggu...",
        "isUser": false,
        "isWaiting": true,
      });
    });

    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      final index = messages.indexWhere((m) => m["isWaiting"] == true);
      if (index != -1) {
        messages[index] = {"text": option["reply"]!, "isUser": false};
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        centerTitle: false,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "TiraQu Chat",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          // Nama user
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.person, size: 40),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Herman Kardon",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "08123456789 - hermankardon@gmail.com",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Nomor Pelanggan Yang Terhubung Dengan Anda",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "ITA WIDJAYA",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "000001",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Herman Kardon - 000001",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Area chat
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Obrolan dimulai at 12:00",
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                  );
                }

                final msg = messages[messages.length - 1 - index];

                if (msg["isInitial"] == true) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChatBubble(msg),
                      const SizedBox(height: 8),
                      Column(
                        children: options
                            .map(
                              (o) => _optionButton(
                                context,
                                o["text"]!,
                                onTap: () {
                                  _handleOptionClick(o);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
                }

                return _buildChatBubble(msg);
              },
            ),
          ),

          // Input pesan manual
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Ketik Pesan",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1A237E)),
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Chat Bot
  Widget _buildChatBubble(Map<String, dynamic> msg) {
    return Align(
      alignment: msg["isUser"] ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: msg["isUser"]
                ? Colors.grey[200]
                : Color.fromARGB(255, 0, 144, 170),
            borderRadius: msg["isUser"]
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(0),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(12),
                  ),
          ),
          child: Text(
            msg["text"],
            style: TextStyle(
              color: msg["isUser"] ? Colors.black87 : Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // Option
  Widget _optionButton(
    BuildContext context,
    String text, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.indigo[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_forward,
              size: 12,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
