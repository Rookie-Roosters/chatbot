import 'package:chatbot/utils/printer.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';

class DatabaseService extends GetxService {
  static DatabaseService get to => Get.find<DatabaseService>();

  late final MySqlConnection connection;

  final _settings = ConnectionSettings(
    host: '192.168.0.1', //ip local
    port: 3306,
    user: 'root',
    // password: '',
    db: 'chatbot',
  );

  Future<DatabaseService> init() async {
    try {
      connection = await MySqlConnection.connect(_settings);
    } catch (error) {
      Printer.error(error);
    }
    return this;
  }
}
