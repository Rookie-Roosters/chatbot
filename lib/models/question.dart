import 'package:chatbot/services/database_service.dart';

class Question {
  int id;
  String text;

  //Constructor
  Question({required this.id, required this.text});

  //Validaciones
  bool validate() {
    return text.length > 3;
  }

  //CRUD
  static Future<Question> getById(int id) async {
    final result = await DatabaseService.to.connection.query(
      '''
      SELECT `id`, `text`
      FROM `question`
      WHERE `id`=?
      ''',
      [id],
    );
    if (result.length == 1) {
      for (var row in result) {
        return Question(
          id: row[0],
          text: row[1],
        );
      }
    }
    throw Exception('Query returned more than one question or no questions.');
  }

  static Future<int> getIdByText(String text) async {
    final result = await DatabaseService.to.connection.query(
      '''
      SELECT `id`, `text`
      FROM `question`
      WHERE `text`=?
      ''',
      [text.toLowerCase()]
    );
    if (result.length == 1) {
      for (var row in result) {
        return row[0];
      }
    }
    return -1;
  }

  static Future<Question> getByText(String text) async {
    return getById(await getIdByText(text.toLowerCase()));
  }

  Future<void> add() async {
    if (validate()) {
      await DatabaseService.to.connection.query('''
        INSERT INTO `question`
        (`id`, `text`)
        VALUES (?,?)
        ''', [
        null,
        text.toLowerCase(),
      ]);
    } else {
      throw Exception('Invalid Data');
    }
  }
}
