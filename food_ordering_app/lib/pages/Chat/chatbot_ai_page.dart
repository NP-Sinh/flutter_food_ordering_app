import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/gemini_service.dart';
import '../../const/colors.dart';

class ChatbotAIPage extends StatefulWidget {
  static const routeName = '/chatbot-ai';

  const ChatbotAIPage({Key? key}) : super(key: key);

  @override
  State<ChatbotAIPage> createState() => _ChatbotAIPageState();
}

class _ChatbotAIPageState extends State<ChatbotAIPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Khởi tạo trong initState
  late final GeminiService _geminiService;

  bool _isLoading = false;
  bool _geminiError = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(
      apiKey: 'AIzaSyAbXpAtR4CNcqu04YGcl8B0KgtTFKpLLxE',
    );

    // Thêm tin nhắn chào mừng
    _messages.add(
      ChatMessage(
        message:
            'Xin chào! Tôi là trợ lý AI của ứng dụng đặt đồ ăn. Tôi có thể giúp bạn tìm món ăn, đề xuất món phù hợp, cho bạn biết món ăn bán chạy nhất, đắt nhất, rẻ nhất, hoặc trả lời câu hỏi của bạn về ẩm thực.\n\nBạn cần giúp gì?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    // Kiểm tra API key
    _testGeminiAPI();
  }

  Future<void> _testGeminiAPI() async {
    try {
      final response = await _geminiService.getChatResponse(
        'Hãy trả lời "OK" nếu API đang hoạt động',
      );
      print('Test API response: $response');
    } catch (e) {
      setState(() {
        _geminiError = true;
      });
      print('Lỗi khi test API: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          message: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    String response = '';

    if (_geminiError) {
      // Nếu Gemini không hoạt động, xử lý tại chỗ với câu trả lời cơ bản
      response = _getBasicResponse(userMessage);
    } else {
      try {
        // Sử dụng phương thức processUserQuestion mới để xử lý câu hỏi
        // Phương thức này sẽ tự động lấy dữ liệu, phân tích câu hỏi và trả lời
        response = await _geminiService.processUserQuestion(userMessage);
      } catch (e) {
        print('Lỗi khi xử lý tin nhắn: $e');
        setState(() {
          _geminiError = true;
        });
        response =
            'Xin lỗi, tôi đang gặp sự cố kỹ thuật. Vui lòng thử lại sau.';
      }
    }

    setState(() {
      _messages.add(
        ChatMessage(
          message: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = false;
    });

    _scrollToBottom();
  }

  // Tạo câu trả lời cơ bản
  String _getBasicResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('món ăn bán chạy') ||
        lowerMessage.contains('bán nhiều nhất')) {
      return 'Xin lỗi, hiện tại tôi không thể kết nối với cơ sở dữ liệu để lấy thông tin về món ăn bán chạy nhất. Vui lòng thử lại sau.';
    }

    if (lowerMessage.contains('món ăn đắt nhất') ||
        lowerMessage.contains('giá cao nhất')) {
      return 'Xin lỗi, hiện tại tôi không thể kết nối với cơ sở dữ liệu để lấy thông tin về món ăn đắt nhất. Vui lòng thử lại sau.';
    }

    if (lowerMessage.contains('món ăn rẻ nhất') ||
        lowerMessage.contains('giá thấp nhất')) {
      return 'Xin lỗi, hiện tại tôi không thể kết nối với cơ sở dữ liệu để lấy thông tin về món ăn rẻ nhất. Vui lòng thử lại sau.';
    }

    if (lowerMessage.contains('tìm') || lowerMessage.contains('kiếm')) {
      return 'Xin lỗi, hiện tại tôi không thể kết nối với cơ sở dữ liệu để tìm kiếm món ăn. Vui lòng thử lại sau.';
    }

    return 'Xin lỗi, hiện tại tôi không thể xử lý yêu cầu của bạn. Dịch vụ AI đang gặp sự cố, chúng tôi đang khắc phục vấn đề này. Vui lòng thử lại sau.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với AI Trợ lý'),
        backgroundColor: AppColor.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  // Hiển thị loading indicator
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SpinKitThreeBounce(
                        color: AppColor.orange,
                        size: 24,
                      ),
                    ),
                  );
                }

                final message = _messages[index];

                return message.isUser
                    ? BubbleSpecialThree(
                      text: message.message,
                      color: AppColor.orange,
                      tail: true,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      isSender: true,
                    )
                    : BubbleSpecialThree(
                      text: message.message,
                      color: const Color(0xFFE8E8EE),
                      tail: true,
                      textStyle: TextStyle(color: Colors.black, fontSize: 16),
                      isSender: false,
                    );
              },
            ),
          ),
          // Gợi ý câu hỏi nhanh
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickSuggestion('Món ăn bán chạy nhất?'),
                _buildQuickSuggestion('Món ăn đắt nhất?'),
                _buildQuickSuggestion('Món ăn rẻ nhất?'),
                _buildQuickSuggestion('Tìm món cơm'),
                _buildQuickSuggestion('Các món ăn healthy'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập câu hỏi hoặc yêu cầu của bạn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  onPressed: _sendMessage,
                  color: AppColor.orange,
                  textColor: Colors.white,
                  minWidth: 0,
                  shape: const CircleBorder(),
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSuggestion(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          _messageController.text = text;
          _sendMessage();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(text, style: TextStyle(color: AppColor.orange)),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}
