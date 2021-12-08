import 'package:chatbot/pages/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: controller.messages,
      onSendPressed: controller.handleSendPressed,
      user: controller.user,
    );
  }
}
