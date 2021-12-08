import 'dart:math';
import 'package:chatbot/models/answer.dart';
import 'package:chatbot/models/question.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../utils/random_string.dart';

enum ChatStatus {
  waitingAnswer,
  waitingQuestion,
  writing,
}

final _notFoundResponses = [
  'No recuerdo muy bien... ¿Me podrías refrescar la memoria y decirme cuál es la respuesta? *guiño guiño*',
  'Esa no venía en la tarea, ¿me soplas la respuesta?',
];

final _foundResponses = [
  'Elemental, mi querido Watson. La respuesta es: ',
  'Pero por su pollo que me la sabanas. ',
];

final _newAnswerResponses = ['Entendido y anotado!', 'Cada día se aprende algo nuevo', 'Gracias por el dato, crack'];

final _waitingQuestionResponses = [
  '¿Algo más en lo que pueda ayudarte?',
  '¿Tienes alguna otra pregunta?',
];

class ChatbotController extends GetxController {
  List<types.Message> messages = [];
  final user = const types.User(id: 'user');
  final chatbot = const types.User(id: 'chatbot');
  var status = ChatStatus.waitingAnswer.obs;
  int lastQuestion = -1;

  void handleSendPressed(types.PartialText message) {
    createMessage(message.text, user);
    chatbotResponse(message);
  }

  Future<void> chatbotResponse(types.PartialText message) async {
    if (status.value == ChatStatus.waitingAnswer) {
      status(ChatStatus.writing);
      await 1.seconds.delay();
      await Answer(question: Question(id: lastQuestion, text: ''), text: message.text.toLowerCase()).add();
      createMessage(_newAnswerResponses[Random().nextInt(_newAnswerResponses.length)]);
      createMessage(_waitingQuestionResponses[Random().nextInt(_waitingQuestionResponses.length)]);
      status(ChatStatus.waitingQuestion);
    } else if (status.value == ChatStatus.waitingQuestion) {
      lastQuestion = await Question.getIdByText(message.toString().toLowerCase());
      status(ChatStatus.writing);
      await 1.seconds.delay();
      if (lastQuestion == -1) {
        createMessage(_notFoundResponses[Random().nextInt(_notFoundResponses.length)]);
        status(ChatStatus.waitingAnswer);
      } else {
        final answers = await Answer.getByQuestion(lastQuestion);
        final answer = answers[Random().nextInt(answers.length)];
        createMessage('${_foundResponses[Random().nextInt(_foundResponses.length)]} ${answer.text}');
        status(ChatStatus.waitingQuestion);
      }
    }
  }

  types.TextMessage createMessage(String text, [types.User? author]) {
    final message = types.TextMessage(
      id: getRandomString(16),
      author: author ?? chatbot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: text,
    );
    messages.insert(0, message);
    return message;
  }
}
