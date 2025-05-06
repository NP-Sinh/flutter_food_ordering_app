import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/MonAn.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel model;

  GeminiService({required this.apiKey}) {
    model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  Future<String> getChatResponse(String prompt) async {
    try {
      final content = Content.text(prompt);
      final response = await model.generateContent([content]);

      return response.text ??
          'Xin lỗi, tôi không thể trả lời câu hỏi vào lúc này.';
    } catch (e) {
      print('Lỗi khi gọi Gemini API: $e');
      return 'Đã xảy ra lỗi khi xử lý yêu cầu của bạn. Vui lòng thử lại sau.';
    }
  }

  // Tạo prompt thông minh cho Gemini với thông tin từ cơ sở dữ liệu
  String createPromptWithData(String userMessage, List<MonAn>? relatedFoods) {
    String basePrompt = userMessage;

    // Nếu có dữ liệu món ăn liên quan, thêm vào prompt
    if (relatedFoods != null && relatedFoods.isNotEmpty) {
      basePrompt += '\n\nDưới đây là một số món ăn có thể liên quan:\n';
      for (var i = 0; i < relatedFoods.length; i++) {
        final food = relatedFoods[i];
        basePrompt += '${i + 1}. ${food.tenMonAn} - ${food.gia} đ';
        if (food.moTa != null && food.moTa!.isNotEmpty) {
          basePrompt += ' - ${food.moTa}';
        }
        basePrompt += '\n';
      }
    }

    return basePrompt;
  }

  // Phân tích ý định người dùng để biết họ đang tìm gì
  IntentType analyzeUserIntent(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('bán chạy') ||
        lowerMessage.contains('phổ biến') ||
        lowerMessage.contains('nhiều người mua') ||
        lowerMessage.contains('bán nhiều nhất')) {
      return IntentType.bestSelling;
    }

    if (lowerMessage.contains('đắt nhất') ||
        lowerMessage.contains('cao cấp') ||
        lowerMessage.contains('sang trọng') ||
        lowerMessage.contains('giá cao')) {
      return IntentType.mostExpensive;
    }

    if (lowerMessage.contains('rẻ nhất') ||
        lowerMessage.contains('giá rẻ') ||
        lowerMessage.contains('tiết kiệm') ||
        lowerMessage.contains('giá thấp')) {
      return IntentType.cheapest;
    }

    if (lowerMessage.contains('tìm') ||
        lowerMessage.contains('kiếm') ||
        lowerMessage.contains('món') ||
        lowerMessage.contains('đồ ăn') ||
        lowerMessage.contains('thức ăn')) {
      // Trích xuất từ khóa sau "tìm"
      return IntentType.search;
    }

    return IntentType.generalChat;
  }

  // Trích xuất từ khóa tìm kiếm từ câu người dùng
  String extractSearchKeyword(String message) {
    final lowerMessage = message.toLowerCase();
    List<String> searchPrefixes = ['tìm', 'kiếm', 'món', 'đồ ăn', 'thức ăn'];

    for (var prefix in searchPrefixes) {
      if (lowerMessage.contains(prefix)) {
        int index = lowerMessage.indexOf(prefix);
        if (index >= 0 && index + prefix.length < lowerMessage.length) {
          return lowerMessage.substring(index + prefix.length).trim();
        }
      }
    }

    // Nếu không tìm thấy từ khóa cụ thể, lấy toàn bộ nội dung
    return message;
  }
}

enum IntentType { bestSelling, mostExpensive, cheapest, search, generalChat }
