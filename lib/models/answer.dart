import 'package:chatbot/models/question.dart';
import 'package:chatbot/services/database_service.dart';

class Answer {
  Question? question;
  String text;

  //Constructor
  Answer({required this.question, required this.text});

  //Validaciones
  bool validate() {
    return text.length > 3;
  }

  //CRUD
  static Future<List<Answer>> getByQuestion(int idQuestion) async {
    final result = await DatabaseService.to.connection.query(
      '''
      SELECT `id_question`, `text`
      FROM `answer`
      WHERE `id_question`=?
      ''',
      [idQuestion],
    );
    List<Answer> answers = [];
    for (var row in result) {
      Answer answer = Answer(
        question: await Question.getById(row[0]),
        text: row[1],
      );
      answers.add(answer);
    }
    return answers;
  }

  Future<void> add() async {
    if (validate()) {
      await DatabaseService.to.connection.query('''
        INSERT INTO `answer`
        (`id_question`, `text`)
        VALUES (?,?)
        ''', [
        question!.id,
        text,
      ]);
    } else {
      throw Exception('Invalid Data');
    }
  }
}
